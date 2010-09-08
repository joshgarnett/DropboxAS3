package com.adverserealms.core.command
{
	import com.adverserealms.core.model.HTTPFault;
	import com.adverserealms.core.util.ReflectionUtil;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class AsyncCommand implements IResponder
	{
		protected var asyncToken:AsyncToken = new AsyncToken();
		
		public function result(data:Object):void
		{
			trace(ReflectionUtil.getClassName(this)+": result");

			var result:Object = handleResult(data);
			if(asyncToken != null && asyncToken.hasResponder()) {
				for(var i:Number = 0; i < asyncToken.responders.length; i++) {
					var responder:IResponder = IResponder(asyncToken.responders[i]);
					if(result is HTTPFault) {
						//return as fault and not result
						if(responder.fault != null) {
							responder.fault(result);
						}
					}
					else {
						if(responder.result != null) {
							responder.result(result);
						}
					}
				}
			}
		}
		
		/**
		 * Returns the object that should be sent to the result handlers.
		 */
		protected function handleResult(data:Object) : Object {
			return data;
		}
		
		public function fault(info:Object):void
		{
			trace(ReflectionUtil.getClassName(this)+": fault: "+info);
			
			//pass object onto responders
			var fault:Object = handleFault(info);
			if(asyncToken != null && asyncToken.hasResponder()) {
				for(var i:Number = 0; i < asyncToken.responders.length; i++) {
					var responder:IResponder = IResponder(asyncToken.responders[i]);
					responder.fault(fault);
				}
			}
		}
		
		protected function handleFault(info:Object) : Object {
			return info;
		}
	}
}