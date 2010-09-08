package com.adverserealms.dropbox.command
{
	import com.adobe.serialization.json.JSON;
	import com.adverserealms.core.command.AsyncCommand;
	import com.adverserealms.core.model.HTTPFault;
	import com.adverserealms.core.net.HTTPLoader;
	import com.adverserealms.dropbox.config.Services;
	import com.adverserealms.dropbox.model.Metadata;
	import com.adverserealms.dropbox.util.ValidateResult;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import org.iotashan.oauth.OAuthToken;

	public class GetMetadata extends AsyncCommand
	{
		private var metadata:Metadata;
		
		public function execute(consumer:OAuthConsumer, token:OAuthToken, metadata:Metadata) : AsyncToken {
			this.metadata = metadata;
			
			var params:Object = new Object();
			params.status_in_response = "true";
			params.file_limit = "1000";			//default is 10k, we are going to impose a 1k limit
			
			if(metadata.hash != null && metadata.hash != "") {
				params.hash = metadata.hash;
			}
			
			if(metadata.isDir && Metadata.directoryCache[metadata.path] == null) {
				Metadata.directoryCache[metadata.path] = metadata;
			}
			
			var path:String = metadata.path.replace(" ","%20");
			
			var request:OAuthRequest = new OAuthRequest("GET",Services.metadataService+path, params, consumer, token);
			
			var url:String = request.buildRequest(new OAuthSignatureMethod_HMAC_SHA1());
			
			//this isn't going to work for post requests, just keep in mind
			HTTPLoader.load(url,null).addResponder(this);
			
			return asyncToken;
		}
		
		protected override function handleResult(data:Object):Object
		{
			var jsonResult:String = data as String;
			
			if(jsonResult != null && jsonResult != "") {				
				var jsonObject:Object = JSON.decode(jsonResult);
				
				if(ValidateResult.checkIfJSONResultIsValid(jsonObject) || jsonObject.status == "304") {
					
					if(jsonObject.status != "304") {
						//update values on metadata
						var body:Object = jsonObject.body;
						setMetadataValues(this.metadata,body);
						
						var contents:Array = body.contents;
						var metadataContents:Array = new Array();
						
						if(contents != null && contents.length > 0) {
							for(var i:Number = 0; i < contents.length; i++) {
								var o:Object = contents[i];
								
								var mdata:Metadata;
								if(o.is_dir == "true" && Metadata.directoryCache[o.path] != null) {
									mdata = Metadata.directoryCache[o.path];
								}
								else {
									mdata = new Metadata();
								
									setMetadataValues(mdata,o);
									mdata.parent = this.metadata;
								
									Metadata.directoryCache[mdata.path] = mdata;	
								}
								
								metadataContents.push(mdata);
							}
						}
						
						this.metadata.contents = new ArrayCollection(metadataContents);
					}
					
					return metadata;
				}
				else {
					return new HTTPFault(jsonObject.response,jsonObject.status);
				}
			}
			else {
				return new HTTPFault("result was empty");
			}
		}
		
		private function setMetadataValues(mdata:Metadata,jsonObject:Object) : void {
			mdata.hash = jsonObject.hash;
			mdata.revision = jsonObject.revision;
			mdata.thumbExists = jsonObject.thumb_exists;
			mdata.bytes = Number(jsonObject.bytes);
			mdata.modified = parseModifiedString(jsonObject.modified);
			mdata.path = jsonObject.path;
			mdata.isDir = jsonObject.is_dir;
			mdata.icon = jsonObject.icon;
			mdata.mimeType = jsonObject.mime_type;
			mdata.size = jsonObject.size;
			mdata.root = jsonObject.root;
			
			//extract filename
			var parts:Array = mdata.path.split("/");
			mdata.filename = parts[parts.length-1];
		}
		
		/**
		 * [3 letter day], [2 digit date] [3 letter month] [4 digit year] [HH:MM:SS] [TZ]"
		 * Sat, 28 Aug 2010 03:54:59 +0000
		 */
		private function parseModifiedString(modified:String) : Date {
			//Day Mon DD HH:MM:SS TZD YYYY
			//Wed Apr 12 15:30:17 GMT-0700 2006
			if(modified == null) {
				return null;
			}
			
			var dayOfWeek:String = modified.substr(0,3);
			var day:String = modified.substr(5,2);
			var month:String = modified.substr(8,3);
			var year:String = modified.substr(12,4);
			var time:String = modified.substr(17,8);
			var tz:String = "GMT"+modified.substr(26,5);
			
			var newModified:String = dayOfWeek+" "+month+" "+day+" "+time+" "+tz+" "+year;
			
			//trace("converted date: "+modified+" to "+new Date(newModified).toString());
			
			return new Date(newModified);
		}
		
	}
}