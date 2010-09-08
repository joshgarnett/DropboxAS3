package com.adverserealms.core.model
{
	public class HTTPFault
	{
		public var message:String;
		public var code:String;
		
		public function HTTPFault(message:String, code:String = "")
		{
			this.message = message;
			this.code = code;
		}

	}
}