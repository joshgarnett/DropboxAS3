package com.adverserealms.dropbox.config
{
	public class Services
	{
		public static var version:String = "0";
		
		public static var tokenService:String = "https://api.dropbox.com/"+version+"/token";
		
		public static var accountService:String = "https://api.dropbox.com/"+version+"/account/info";
		
		public static var metadataService:String = "https://api.dropbox.com/"+version+"/metadata/dropbox";
		
		public static var fileService:String = "https://api-content.dropbox.com/"+version+"/files/dropbox";
		
		public static var thumbService:String = "https://api-content.dropbox.com/"+version+"/thumbnails/dropbox";
		
	}
}