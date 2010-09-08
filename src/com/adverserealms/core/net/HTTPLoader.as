package com.adverserealms.core.net
{
	import com.adverserealms.core.util.URLUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	public class HTTPLoader
	{
		private var asyncToken:AsyncToken = new AsyncToken();
		
		/**
		 * Loads a specific URL.
		 */
		public function load(request:URLRequest) : AsyncToken {
			var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, handleComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
            loader.load(request);
            
            return asyncToken;
		}
		
		private function handleComplete(event:Event) : void {
			var loader:URLLoader = URLLoader(event.target);
			
			var data:Object = loader.data as Object;
			
			complete(data);
		}
		
		private function handleIOError(event:IOErrorEvent) : void {
			fault(event.toString());
		}
		
		private function handleSecurityError(event:SecurityErrorEvent) : void {
			fault(event.toString());
		}
		
		private function complete(data:Object) : void {
			if(asyncToken != null && asyncToken.hasResponder()) {
				for(var i:Number = 0; i < asyncToken.responders.length; i++) {
					var responder:IResponder = IResponder(asyncToken.responders[i]);
					if(responder.result != null) {
						responder.result(data);
					}
				}
			}
		}
		
		private function fault(message:String) : void {
			if(asyncToken != null && asyncToken.hasResponder()) {
				for(var i:Number = 0; i < asyncToken.responders.length; i++) {
					var responder:IResponder = IResponder(asyncToken.responders[i]);
					if(responder.fault != null) {
						responder.fault(message);
					}
				}
			}
		}
		
		public static function load(baseURL:String,params:Object) : AsyncToken {
			var url:String = baseURL + URLUtil.joinParams(params);
			trace("HTTPLoader: load: "+url);
			
            return new HTTPLoader().load(new URLRequest(url));
		}
	}
}