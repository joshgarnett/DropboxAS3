package com.adverserealms.core.util
{    
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    
    public class URLUtil
    {
        /**
         * Adds a trailing slash to a URL if its needed
         */
        public static function addTrailingSlash(url:String):String {
            var lastChar:String = url.charAt(url.length-1);
            if(lastChar != "/") {
                url = url + "/";
            }
            return url;
        }
        
        // returns a string representation of the dynamic properties of a params object
        public static function joinParams(params:Object):String {
            var joined:String = "";
            
            if(params != null) {        
            	joined = "?";
            	    
	            var prop:String;
	            var value:Object;
	            for (prop in params) {
	                value = params[prop];
	                if(value != null) {
	                    joined += prop + "=" + params[prop].toString() + "&";
	                }
	            }
	            
	            // remove final &
	            joined = joined.slice(0, joined.length - 1);
           	}
            
            return joined;
        }
    }
}