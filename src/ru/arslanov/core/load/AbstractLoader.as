package ru.arslanov.core.load {
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.core.events.LoaderEvent;
	import ru.arslanov.core.utils.Log;
	/**
	 * Абстрактный класс загрузчика.
	 * Супер-класс для всех загрузчиков.
	 * @author Artem Arslanov
	 */
	public class AbstractLoader extends EventDispatcher {
		
		static private var _counter:uint;
		
		public var protectFromDisposing:Boolean = false;
		public var completed:Boolean = false;
		public var logging:Boolean = false;
		public var customData:Object;
		public var preloaderDisplayObject:Object;// DisplayObject
		
		
		protected var _openStream:Boolean;
		protected var _url:String;
		
		private var _eventDispatcher:EventDispatcher;
		private var _uid:uint; // unique ID
		private var _loaderName:String;
		
		
		public function AbstractLoader( url:String = null ) {
			_uid = ++_counter;
			
			this.url = url;
			this._loaderName = createLoaderName();
		}
		
		/**
		 * START / STOP
		 */
		public function start():void {
			if ( logging ) Log.traceText ("Load start : " + this);
			
			if ( !url ) Log.traceError( "url is null!" + this );
			
			// override me
		}
		
		public function stop():void {
			if ( logging ) Log.traceText ("Load stop : " + this);
			// override me
		}
		
		/**
		 * Events!
		 */
		protected function setEventDispatcher( eventDispatcher:EventDispatcher ):void {
			_eventDispatcher = eventDispatcher;
			
			_eventDispatcher.addEventListener( Event.INIT, 							initHandler );
			_eventDispatcher.addEventListener( Event.COMPLETE, 						completeHandler );
			_eventDispatcher.addEventListener( IOErrorEvent.IO_ERROR, 				ioErrorHandler );
			_eventDispatcher.addEventListener( ProgressEvent.PROGRESS, 				progressHandler );
			_eventDispatcher.addEventListener( HTTPStatusEvent.HTTP_STATUS, 		httpStatusHandler );
			_eventDispatcher.addEventListener( SecurityErrorEvent.SECURITY_ERROR, 	securityErrorHandler );
		}
		
		protected function removeAllListeners ():void {
			if ( !_eventDispatcher ) return;
			
			_eventDispatcher.removeEventListener( Event.INIT, 							initHandler );
			_eventDispatcher.removeEventListener( Event.COMPLETE, 						completeHandler );
			_eventDispatcher.removeEventListener( IOErrorEvent.IO_ERROR, 				ioErrorHandler );
			_eventDispatcher.removeEventListener( ProgressEvent.PROGRESS, 				progressHandler );
			_eventDispatcher.removeEventListener( HTTPStatusEvent.HTTP_STATUS, 			httpStatusHandler );
			_eventDispatcher.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, 	securityErrorHandler );
		}
		
		/**
		 * Handlers
		 */
		protected function initHandler( event:Event ):void {
			_openStream = true;
			
			dispatchEvent( new LoaderEvent( LoaderEvent.INIT, _loaderName ) );
		}
		
		protected function progressHandler( event:ProgressEvent ):void {
			event.stopPropagation();
			dispatchEvent( new LoaderEvent( LoaderEvent.PROGRESS, _loaderName ) );
		}
		
		protected function completeHandler( event:Event ):void {
			_openStream = false;
			completed = true;
			
			if ( logging ) Log.traceText ("Load complete : " + this);
			
			dispatchEvent( new LoaderEvent( LoaderEvent.COMPLETE, _loaderName ) );
			
			removeAllListeners();
		}
		
		protected function httpStatusHandler( event:HTTPStatusEvent ):void {
			switch ( event.status ) {
				case 404:
					Log.traceError( event.status +' - ' + _url + ' (Сервер не может найти запрашиваемую страницу)' );
				break;
				case 503:
					Log.traceError( event.status +' - ' + _url + ' (Сервер временно недоступен, так как он перегружен или отключен для обслуживания)' );
				break;
			}
			
			dispatchEvent( new LoaderEvent ( LoaderEvent.HTTP_STATUS, _loaderName ) );
		}
		
		protected function ioErrorHandler( event:IOErrorEvent ):void {
			Log.traceError( this + " : " + event );
			
			dispatchEvent( new LoaderEvent( LoaderEvent.IO_ERROR, _loaderName ) );
			
			removeAllListeners();
		}
		
		private function securityErrorHandler( event:SecurityErrorEvent ):void {
			Log.traceError( "Security ERROR (" + _url + ") : " + event.type + ", " + event.text );
		}
		
		/**
		 * GETTERS / SETTERS
		 */
		public function get url():String {
			return _url;
		}
		
		public function set url( value:String ):void {
			_url = value;
		}
		
		public function get bytesTotal():Number {
			if ( _eventDispatcher is LoaderInfo ) {
				return ( _eventDispatcher as LoaderInfo ).bytesTotal;
			}
			if ( _eventDispatcher is URLLoader ) {
				return ( _eventDispatcher as URLLoader ).bytesTotal;
			}
			return -1;
		}
		
		public function get bytesLoaded():Number {
			if ( _eventDispatcher is LoaderInfo ) {
				return ( _eventDispatcher as LoaderInfo ).bytesLoaded;
			}
			if ( _eventDispatcher is URLLoader ) {
				return ( _eventDispatcher as URLLoader ).bytesLoaded;
			}
			return -1;
		}
		
		public function get percent():Number {
			return bytesLoaded / Math.max( 1, bytesTotal );
		}
		
		public function get loaderName():String {
			return _loaderName;
		}
		
		public function get uidStr():String {
			return "0x" + _uid.toString( 16 ).toUpperCase();
		}
		
		/**
		 * Utils
		 */
		
		private function createLoaderName():String {
			var str:String = _url;
			
			if ( url.lastIndexOf( "/" ) != -1 ) {
				str = str.substring( str.lastIndexOf( "/" ) + 1 );
			}
			
			//return str.substring( 0, str.lastIndexOf( "." ) ); // Отрезает расширение
			return str; // Вместе с расширением
		}
		
		public function dispose():void {
			removeAllListeners();
			
			_eventDispatcher = null;
			customData = null;
			preloaderDisplayObject = null;
		}
		
		override public function toString():String {
			return "[" + getQualifiedClassName( this ) + " " + uidStr + ", url=" + url + "]";
		}
	}

}
