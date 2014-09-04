package ru.arslanov.core.external {
	import flash.external.ExternalInterface;
	import ru.arslanov.core.utils.Log;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class JSWrapper {
		
		static public var logging:Boolean = true;
		
		public function JSWrapper() {
			
		}
		
		static public function get availability():Boolean {
			return ExternalInterface.available;
		}
		
		static private function get checkAvailable():Boolean {
			if ( !availability ) Log.traceError( "ExternalInterface not available!" );
			
			return availability;
		}
		
		static public function call( functionName:String, ...rest ):* {
			if ( logging ) Log.traceText( "ExternalInterface call : " + functionName + "( " + rest + " )" );
			
			if ( !checkAvailable ) return;
			
			rest.unshift( functionName );
			
			try {
				return ExternalInterface.call.apply( null, rest );
			} catch ( error:Error ) {
				Log.traceError( error );
			}
		}
		
		static public function addCallback( functionName:String, handler:Function ):void {
			if ( !checkAvailable ) return;
			
			try {
				if ( logging ) Log.traceText( "ExternalInterface addCallback : " + functionName );
				ExternalInterface.addCallback( functionName, handler );
			} catch ( error:Error ) {
				Log.traceError( error );
			} catch ( secError:SecurityError ) {
				Log.traceError( secError );
			}
		}
	}

}