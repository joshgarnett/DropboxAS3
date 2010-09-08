package com.adverserealms.dropbox.model
{
	import com.adverserealms.dropbox.config.Services;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import org.iotashan.oauth.OAuthToken;
	
	[Bindable]
	public class Metadata
	{
		public static var directoryCache:Dictionary = new Dictionary();
		
		public function Metadata(path:String = "") {
			this.path = path;
		}
		
		public var hash:String;
		public var revision:String;
		public var thumbExists:Boolean;
		public var bytes:Number;
		public var modified:Date;
		public var path:String;
		public var filename:String;
		public var isDir:Boolean;
		public var icon:String;
		public var mimeType:String;
		public var size:String;			//preformatted text based on bytes sets bytes, kb, gb, etc...
		public var root:String;
		
		public var parent:Metadata;
		
		public var contents:ArrayCollection;
		
		public function getDownloadURL(consumer:OAuthConsumer, token:OAuthToken) : String {
			if(isDir) {
				return "";
			}
			
			var cleanPath:String = path.replace(" ","%20");
			var request:OAuthRequest = new OAuthRequest("GET",Services.fileService+cleanPath, {}, consumer, token);
			return request.buildRequest(new OAuthSignatureMethod_HMAC_SHA1());
		} 
		
		public function getThumbnailURL(consumer:OAuthConsumer, token:OAuthToken, size:String = "small") : String {
			if(!thumbExists) {
				return "";
			}
			
			var params:Object = new Object();
			params.size = size;
			
			var cleanPath:String = path.replace(" ","%20");
			var request:OAuthRequest = new OAuthRequest("GET",Services.thumbService+cleanPath, params, consumer, token);
			return request.buildRequest(new OAuthSignatureMethod_HMAC_SHA1());
		}
	}
}