package com.adverserealms.dropbox.service
{
	import com.adverserealms.dropbox.command.*;
	import com.adverserealms.dropbox.model.Metadata;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	
	import org.iotashan.oauth.OAuthConsumer;
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
		
		private function loginResult(result:Object) : void {
			token = result as OAuthToken;
		}
		
		public function getAccountInfo() : AsyncToken {
			var asyncToken:AsyncToken = new GetAccountInfo().execute(consumer,token);
			return asyncToken;
		}
		
		public function getMetadata(metadata:Metadata) : AsyncToken {
			var asyncToken:AsyncToken = new GetMetadata().execute(consumer,token,metadata);
			return asyncToken;
		}

	}
}