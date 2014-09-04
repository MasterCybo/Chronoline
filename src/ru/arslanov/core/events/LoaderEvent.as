package ru.arslanov.core.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class LoaderEvent extends Event {
		
		static public const COMPLETE	:String = "complete";
		static public const HTTP_STATUS	:String = "httpStatus";
		static public const IO_ERROR	:String = "ioError";
		static public const INIT		:String = "init";
		static public const OPEN		:String = "open";
		static public const PROGRESS	:String = "progress";
		static public const UNLOAD		:String = "unload";
		
		public var loaderName:String;
		
		public function LoaderEvent( type:String, loaderName:String = null, bubbles:Boolean = false, cancelable:Boolean = false ) {
			this.loaderName = loaderName;
			super( type, bubbles, cancelable );
		}
		
		override public function clone():Event {
			return new LoaderEvent( type, loaderName, bubbles, cancelable );
		}
		
		override public function toString():String {
			return formatToString( "LoaderEvent", "loaderName", "type", "bubbles", "cancelable", "eventPhase" );
		}
		
	}
	
}