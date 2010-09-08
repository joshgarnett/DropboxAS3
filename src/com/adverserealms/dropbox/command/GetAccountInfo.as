package com.adverserealms.dropbox.command
{
	import com.adobe.serialization.json.JSON;
	import com.adverserealms.core.command.AsyncCommand;
	import com.adverserealms.core.model.HTTPFault;
	import com.adverserealms.core.net.HTTPLoader;
	import com.adverserealms.dropbox.config.Services;
	import com.adverserealms.dropbox.model.AccountInfo;
	import com.adverserealms.dropbox.util.ValidateResult;
	
	import mx.rpc.AsyncToken;
	
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import org.iotashan.oauth.OAuthToken;

	public class GetAccountInfo extends AsyncCommand
	{	
		public function execute(consumer:OAuthConsumer, token:OAuthToken) : AsyncToken {
			var params:Object = new Object();
			params.status_in_response = "true";
			
			var request:OAuthRequest = new OAuthRequest("GET",Services.accountService,params,consumer,token);
			
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
				
				if(ValidateResult.checkIfJSONResultIsValid(jsonObject)) {
					var body:Object = jsonObject.body;
					
					var accountInfo:AccountInfo = new AccountInfo();
					accountInfo.referralLink = body.referral_link;
					accountInfo.displayName = body.display_name;
					accountInfo.uid = body.uid;
					accountInfo.country = body.country;
					accountInfo.quota = Number(body.quota_info.quota);
					accountInfo.usedNormal = Number(body.quota_info.normal);
					accountInfo.usedShared = Number(body.quota_info.shared);
					accountInfo.email = body.email;
					
					return accountInfo;
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