package ru.arslanov.core.controllers
{
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;

	import ru.arslanov.core.utils.Log;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class KeyController
	{
		public var verbose:Boolean = true;

		private var _enabled:Boolean = false;
		private var _target:InteractiveObject;
		private var _handlers:Object/*Array*/; // down_65 = [Function, ...], up_65 = [Function, ...]

		public function KeyController( target:InteractiveObject )
		{
			if ( !target ) throw new ArgumentError( "Parameter target is null" );

			_target = target;
			_handlers = {};
			enabled = true;
		}

		public function bindChar( letter:String, pressHandler:Function = null, releaseHandler:Function = null ):void
		{
			if ( pressHandler != null ) addHandler( "char_down_" + letter, pressHandler );
			if ( releaseHandler != null ) addHandler( "char_up_" + letter, releaseHandler );
		}

		public function unbindChar( letter:String, pressHandler:Function = null, releaseHandler:Function = null ):void
		{
			if ( pressHandler != null ) removeHandler( "char_down_" + letter, pressHandler );
			if ( releaseHandler != null ) removeHandler( "char_up_" + letter, releaseHandler );
		}

		public function bindKey( keyCode:uint, pressHandler:Function = null, releaseHandler:Function = null ):void
		{
			if ( pressHandler != null ) addHandler( "key_down_" + keyCode, pressHandler );
			if ( releaseHandler != null ) addHandler( "key_up_" + keyCode, releaseHandler );
		}

		public function unbindKey( keyCode:uint, pressHandler:Function = null, releaseHandler:Function = null ):void
		{
			if ( pressHandler != null ) removeHandler( "key_down_" + keyCode, pressHandler );
			if ( releaseHandler != null ) removeHandler( "key_up_" + keyCode, releaseHandler );
		}

		private function addHandler( token:String, handler:Function ):void
		{
			if ( !_handlers[ token ] ) _handlers[ token ] = [];
			if ( _handlers[ token ].indexOf( handler ) == -1 ) {
				_handlers[ token ].push( handler );
			}
			else {
				Log.traceWarn( "KeyController.bind... : Handler for token '" + token + "' already exists!" );
			}
		}

		private function removeHandler( token:String, handler:Function ):void
		{
			var handlers:Array = _handlers[ token ];
			if ( handlers ) {
				var idx:int = handlers.indexOf( handler );
				if ( idx != -1 ) {
					handlers.splice( idx, 1 );
				}
				else {
					Log.traceWarn( "KeyController.unbind... : Token '" + token + "' undefined!" );
				}
			}
		}

		public function unbindAll():void
		{
			_handlers = {};
		}

		private function onKeyDown( ev:KeyboardEvent ):void
		{
			toTrace( "KeyController.onKeyDown : Key down = " + String.fromCharCode( ev.charCode ) + ", code = " + ev.charCode );

			callHandler( "char_down_" + String.fromCharCode( ev.charCode ), ev );
			callHandler( "key_down_" + ev.keyCode, ev );
		}

		private function onKeyUp( ev:KeyboardEvent ):void
		{
			toTrace( "KeyController.onKeyUp : Key up = " + String.fromCharCode( ev.charCode ) + ", code = " + ev.charCode );

			callHandler( "char_up_" + String.fromCharCode( ev.charCode ), ev );
			callHandler( "key_up_" + ev.keyCode, ev );
		}

		private function callHandler( token:String, event:KeyboardEvent ):void
		{
			var handlers:Array = _handlers[ token ] as Array;

			if ( handlers ) {
				for each ( var fn:Function in handlers ) {
					if ( fn != null ) {
						if ( fn.length == 1 ) {
							fn( event );
						}
						else {
							fn();
						}
					}
				}
			}
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled( value:Boolean ):void
		{
			if ( value == enabled ) return;

			_enabled = value;

			if ( _enabled ) {
				_target.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
				_target.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			}
			else {
				_target.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
				_target.removeEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			}
		}

		private function toTrace( str:String ):void
		{
			if ( verbose ) return;

			Log.traceText( str );
		}

		public function dispose():void
		{
			enabled = false;
			_handlers = null;
			_target = null;
		}
	}

}