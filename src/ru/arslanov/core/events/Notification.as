package ru.arslanov.core.events {
	import flash.events.Event;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class Notification {
		
		static public var tracer:Function = trace;
		
		static private var _listeners:Object = {};
		static private var _unlogEvents:Vector.<String> = new Vector.<String>();
		
		public function Notification () {
			//constructor
		}
		
		static public function send( noticeName:String, data:* = null ) : void {
			if ( _unlogEvents.indexOf( noticeName ) == -1 ) {
				sendMessage( "Notification.send '" + noticeName + "'" + ( data != null ? ", data : " + data : "" ) );
			}
			
			var arr:Array = _listeners[noticeName];
			
			if ( arr == null ) return;
			
			var handlers:Array = (new Array ()).concat( arr );
			var handler:Function;
			
			for each ( handler in handlers ) {
				if ( arr.indexOf( handler ) != -1 ) {
					if ( data ) {
						handler( data );
					} else {
						handler();
					}
				}
			}
		}
		
		static public function add( noticeName:String, handler:Function, silent:Boolean=false ):void {
			if ( handler == null ) {
				sendMessage( "ERROR : GlobalEvent '" + noticeName + "' no handler!" );
				return;
			}
			
			if ( noticeName == Event.ENTER_FRAME ) {
				sendMessage( "Add listener enterFrame \n" + ( new Error() ).getStackTrace() );
			}
			
			var arr:Array = _listeners[noticeName];
			
			if (arr == null) {
				_listeners[noticeName] = [ handler ];
			} else {
				if(arr.indexOf( handler ) == -1) {
					arr.push( handler );
				} else if ( !silent ) {
					sendMessage( "WARNING : On '" + noticeName + "' added dublicate handler!");
				}
			}
		}
		
		static public function has( noticeName:String, handler:Function ):Boolean {
			return ( (_listeners[noticeName] != null ) && ( _listeners[noticeName].indexOf( handler ) != -1 ) );
		}
		
		static public function isListen( noticeName:String ):Boolean {
			return ( ( _listeners[noticeName] != null ) && ( _listeners[noticeName].length > 0 ) );
		}
		
		static public function removeIfHas( noticeName:String, handler:Function ):void {
			if ( has( noticeName, handler ) ) {
				remove( noticeName, handler );
			}
		}
		
		static public function remove( noticeName:String, handler:Function = null/*, throwErrors:Boolean = false*/ ) : void {
			var arr:Array = _listeners[noticeName];
			
			if (arr == null) {
				sendMessage( "WARNING GlobalEvent.remove : Event name '" + noticeName + "' not found!" + ( new Error() ).getStackTrace() );
				return;
			}
			
			var idx : int = arr.indexOf( handler );
			
			if( idx != -1 ) arr.splice( idx, 1 );
		}
		
		static public function unlog( noticeName:String ):void {
			if ( _unlogEvents.indexOf( noticeName ) == -1 ) {
				_unlogEvents.push( noticeName );
			}
		}
		
		static public function dump():void {
			sendMessage( "Events dump its hash:" );
			
			for ( var name:String in _listeners ) {
				sendMessage( name + " : [" + _listeners[name].join( "," ) + "]" );
			}
		}
		
		static private function sendMessage( message:String ):void {
			if ( tracer == null ) return;
			
			tracer( message );
		}
		
	}

}