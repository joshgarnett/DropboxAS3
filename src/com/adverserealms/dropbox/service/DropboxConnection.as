package com.adverserealms.dropbox.service
{
	import com.adverserealms.dropbox.command.*;
	import com.adverserealms.dropbox.config.Services;
	import com.adverserealms.dropbox.model.DropboxFile;
	
	import flash.net.FileReference;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import org.iotashan.oauth.OAuthToken;
	
	public class DropboxConnection
	{
		private var consumer:OAuthConsumer;
		private var token:OAuthToken;
		
		public function DropboxConnection(consumerKey:String, consumerSecret:String)
		{
			consumer = new OAuthConsumer(consumerKey,consumerSecret);
		}
		
		public function login(email:String, password:String) : AsyncToken {
			var asyncToken:AsyncToken = new GetToken().execute(consumer,email,password);
			asyncToken.addResponder(new Responder(loginResult,null));
			return asyncToken;
		}
		
		/**
		 * Manually set token if you have it cached
		 */
		public function setToken(key:String, secret:String) : void {
			token = new OAuthToken(key,secret);
		}
		
		private function loginResult(result:Object) : void {
			token = result as OAuthToken;
		}
		
		public function getAccountInfo() : AsyncToken {
			return new GetAccountInfo().execute(consumer,token);
		}
		
		public function getMetadata(file:DropboxFile) : AsyncToken {
			return new GetMetadata().execute(consumer,token,file);
		}
		
		public function copyFile(file:DropboxFile,newPath:String) : AsyncToken {
			return null;
		}
		
		public function createFolder() : void {
			
		}
		
		public function deleteFile() : void {
			
		}
		
		public function moveFile(file:DropboxFile,newPath:String) : AsyncToken {
			return null;
		}

		/**
		 * Uses FileReference allowing a user to download the file to their disk.
		 */
		public function downloadFileExternal(file:DropboxFile) : void {
			var ref:FileReference = new FileReference();
		}
		
		/**
		 * Downloads a file internally, should only be used for files that can be
		 * processed by the flash runtime.
		 */
		public function downloadFile(file:DropboxFile) : void {
		
		}
		
		/**
		 * Uses the FileReference code.
		 */
		public function uploadFile() : void {
			
		}
		
		public function getDownloadURL(file:DropboxFile) : String {
			if(file.isDir) {
				return "";
			}
			
			var cleanPath:String = file.path.replace(/ /g,"%20");
			var request:OAuthRequest = new OAuthRequest("GET",Services.fileService+cleanPath, {}, consumer, token);
			return request.buildRequest(new OAuthSignatureMethod_HMAC_SHA1());
		} 
		
		public function getThumbnailURL(file:DropboxFile, size:String = "small") : String {
			if(!file.thumbExists) {
				return "";
			}
			
			var params:Object = new Object();
			params.size = size;
			
			var cleanPath:String = file.path.replace(/ /g,"%20");
			var request:OAuthRequest = new OAuthRequest("GET",Services.thumbService+cleanPath, params, consumer, token);
			return request.buildRequest(new OAuthSignatureMethod_HMAC_SHA1());
		}
		
		
	}
}