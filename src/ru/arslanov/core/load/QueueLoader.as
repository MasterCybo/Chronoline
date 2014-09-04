package ru.arslanov.core.load {
	import adobe.utils.CustomActions;
	import flash.events.EventDispatcher;
	import ru.arslanov.core.events.LoaderEvent;
	import ru.arslanov.core.utils.Log;
	
	/**
	 * QueueLoader (QLoader)
	 * Класс для создания очереди загрузки
	 * @author Artem Arslanov
	 */
	public class QueueLoader extends EventDispatcher {
		
		static public var logging:Boolean = false;
		
		public var preloaderDisplayObject:Object;
		
		private var _isDisposed:Boolean = false;
		private var _streams:uint = 10;
		private var _completeLoaders:uint;
		private var _curIdx:uint;
		private var _queue:Object/*AbstractLoader*/;
		private var _listIds:Vector.<String>;
		
		public function QueueLoader( streams:uint = 10 ) {
			_streams = streams;
			_listIds = new Vector.<String>();
			_queue = {};
		}
		
		override public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void {
			super.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		override public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void {
			super.removeEventListener( type, listener, useCapture );
		}
		
		/**
		 * Добавляет новый загрузчик в очередь загрузки
		 * @param	loader - экземпляр загрузчика, наследник AbstractLoader.
		 * @return	AbstractLoader - возвращает загрузчик
		 */
		public function addLoader( loader:AbstractLoader ):AbstractLoader {
			if ( _queue[ loader.loaderName ] ) {
				Log.traceWarn( this + ".add (" + loader.loaderName + ") : Loader already exists!" );
				return null;
			}
			_queue[ loader.loaderName ] = loader;
			_listIds.push( loader.loaderName );
			
			if ( logging ) Log.traceText( this + ".add : " + loader );
			
			return loader;
		}
		
		public function removeLoader( loaderName:String ):void {
			if ( !_queue[ loaderName ] ) {
				Log.traceWarn( this + ".remove (" + loaderName + ") : Loader not found!" );
				return;
			}
			_queue[ loaderName ].stop();
			if ( !_queue[ loaderName ].protectFromDisposing ) {
				_queue[ loaderName ].kill();
			}
			
			if ( logging ) Log.traceText( this + ".remove : " + _queue[ loaderName ] );
			
			_queue[ loaderName ] = null;
			
			var idx:int = _listIds.indexOf( loaderName );
			if ( idx >= 0 ) {
				_listIds.splice( idx, 1 );
			}
			
		}
		
		/**
		 * Удаляет все загрузчики.
		 * @param	includeProtected - вкулючая защищённые свойством protectFromDisposing
		 */
		public function removeAll( includeProtected:Boolean = false ):void {
			for ( var i:int = 0; i < _listIds.length; i++ ) {
				_queue[ _listIds[ i ] ].stop();
				if ( !_queue[ _listIds[ i ] ].protectFromDisposing || includeProtected ) {
					_queue[ _listIds[ i ] ].kill();
				}
				_queue[ _listIds[ i ] ] = null;
			}
			_listIds.length = 0;
			
			if ( logging ) Log.traceText( this + ".removeAll" );
		}
		
		public function start():void {
			beginLoaders( streams );
		}
		
		private function beginLoaders( range:uint ):void {
			var lastIdx:uint = Math.min( _curIdx + range, numLoaders );
			var ldr:AbstractLoader;
			//log (this + " Start range : " + _curIdx + "-" + (lastIdx - 1));
			while ( _curIdx < lastIdx ) {
				ldr = _queue[ _listIds[ _curIdx ] ];
				
				ldr.addEventListener( LoaderEvent.PROGRESS, onLoaderProgress );
				ldr.addEventListener( LoaderEvent.COMPLETE, onLoaderComplete );
				ldr.start();
				
				if ( logging ) Log.traceText( this + " start loader : " + ldr );
				
				_curIdx++;
			}
			
			ldr = null;
		}
		
		private function onLoaderProgress( event:LoaderEvent ):void {
			dispatchEvent( new LoaderEvent( LoaderEvent.PROGRESS ) );
		}
		
		private function onLoaderComplete( event:LoaderEvent ):void {
			_completeLoaders++;
			if ( _completeLoaders < numLoaders ) {
				beginLoaders( 1 );
			} else {
				_completeLoaders = _curIdx = 0;
				
				if ( logging ) Log.traceText( this + " queue of loaders complete" );
				
				dispatchEvent( new LoaderEvent( LoaderEvent.COMPLETE ) );
			}
		}
		
		public function stop( loaderName:String ):void {
			if ( !_queue[ loaderName ] ) {
				Log.traceError( this + ".stop (" + loaderName + ") : Loader not found!" );
				return;
			}
			_queue[ loaderName ].stop();
			
			if ( logging ) Log.traceText( this + ".stop" );
		}
		
		public function stopAll():void {
			for ( var i:int = 0; i < _listIds.length; i++ ) {
				_queue[ _listIds[ i ] ].stop();
			}
			
			if ( logging ) Log.traceText( this + ".stopAll" );
		}
		
		public function getLoader( loaderName:String ):AbstractLoader {
			if ( !_queue[ loaderName ] ) {
				Log.traceError( this + ".getLoader (" + loaderName + ") : Loader not found!" );
				return null;
			}
			return _queue[ loaderName ];
		}
		
		public function getTextLoader( loaderName:String ):TextLoader {
			if ( !_queue[ loaderName ] ) {
				Log.traceError( this + ".getTextLoader (" + loaderName + ") : Loader not found!" );
				return null;
			}
			return _queue[ loaderName ] as TextLoader;
		}
		
		public function getDisplayLoader( loaderName:String ):DisplayLoader {
			if ( !_queue[ loaderName ] ) {
				Log.traceError( this + ".getDisplayLoader (" + loaderName + ") : Loader not found!" );
				return null;
			}
			return _queue[ loaderName ] as DisplayLoader;
		}
		
		public function get streams():uint {
			return _streams;
		}
		
		public function set streams( value:uint ):void {
			_streams = value;
		}
		
		public function get numLoaders():uint {
			return _listIds.length;
		}
		
		public function get percent():Number {
			var sumPercent:Number = 0;
			for each ( var loaderName:String in _listIds ) {
				sumPercent += _queue[ loaderName ].percent;
			}
			return sumPercent / Math.max( 1, _listIds.length );
		}
		
		public function getVectorLoaders():Vector.<AbstractLoader> {
			var vect:Vector.<AbstractLoader> = new Vector.<AbstractLoader>();
			for each (var item:AbstractLoader in _queue ) {
				vect.push( item );
			}
			return vect;
		}
		
		public function getNames():Array {
			var arr:Array = [];
			for (var item:String in _queue ) {
				arr.push( item );
			}
			return arr;
		}
		
		public function get disposed():Boolean {
			return _isDisposed;
		}
		
		public function dispose( includeProtected:Boolean = false ):void {
			if ( disposed ) {
				throw new Error( this + " already killed!" );
			}
			
			removeAll( includeProtected );
			
			preloaderDisplayObject = null;
			
			_queue = null;
			_listIds = null;
			_isDisposed = true;
		}
	}

}
