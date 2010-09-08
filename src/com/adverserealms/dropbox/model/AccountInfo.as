package com.adverserealms.dropbox.model
{
	[Bindable]
	public class AccountInfo
	{
		public var referralLink:String;
		public var displayName:String;
		public var uid:String;
		public var country:String;
		public var quota:Number;
		public var usedNormal:Number;
		public var usedShared:Number;
		public var email:String;
		
		public function getUsageDetails() : String {
			var totalUsed:Number = usedNormal + usedShared;
			var percentageUsed:Number = Math.round(((totalUsed/quota)*1000))/10;
			var gbQuota:Number = Math.round((quota / 1024 / 1024 / 1024)*100)/100;
			return percentageUsed+"% of "+gbQuota+"GB used";
		}
	}
}