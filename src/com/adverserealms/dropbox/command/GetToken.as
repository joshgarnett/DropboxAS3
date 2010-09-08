package com.adverserealms.dropbox.command
{
	import com.adobe.serialization.json.JSON;
	import com.adverserealms.core.command.AsyncCommand;
	import com.adverserealms.core.model.HTTPFault;
	import com.adverserealms.core.net.HTTPLoader;
	import com.adverserealms.dropbox.config.Services;
	import com.adverserealms.dropbox.util.ValidateResult;
	
	import mx.rpc.AsyncToken;
	import mx.utils.UIDUtil;
	
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthToken;

	public class GetToken extends AsyncCommand
	{
		public function execute(consumer:OAuthConsumer, email:String, password:String) : AsyncToken {
			var curDate:Date = new Date();
			var uuid:String = UIDUtil.getUID(curDate);
			
			var url:String = Services.tokenService+
								"?oauth_consumer_key="+consumer.key+
								"&email="+email+
								"&password="+password+
								"&oauth_timestamp="+String(curDate.time).substring(0, 10)+
								"&oauth_nonce="+uuid+
								"&status_in_response=true";
			
			//this isn't going to work for post requests, just keep in mind
			HTTPLoader.load(url,null).addResponder(this);
			
			return asyncToken;
		}
		
		protected override function handleResult(data:Object):Object
		{
			var jsonResult:String = data as String;
			
			if(jsonResult != null && jsonResult != "") {
				var jsonObject:Object = JSON.decode(jsonResult);
				
				if(ValidateResult.checkIfJSONResultIsValid(jsonObject)) {
					var token:OAuthToken = new OAuthToken(jsonObject.body.token,jsonObject.body.secret);
					return token;
				}
				else {
					return new HTTPFault(jsonObject.response,jsonObject.status);
				}
			}
			else {
				return new HTTPFault("result was empty");
			}
		}	
	}
}