package com.adverserealms.dropbox.util
{
	public class ValidateResult
	{
		public static function checkIfJSONResultIsValid(jsonObject:Object) : Boolean {
			if(jsonObject.status == null || jsonObject.status != "200") {
				return false;
			}
			return true;
		}

	}
}