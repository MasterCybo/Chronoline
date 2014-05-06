package display.base {
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	import ru.arslanov.core.events.LoaderEvent;
	import ru.arslanov.core.load.DisplayLoader;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ExternalPicture extends ASprite {
		
		static private var _cache:Dictionary /*BitmapData*/ = new Dictionary( true ); // filename = BitmapData
		static private var _loaders:Dictionary /*DisplayLoader*/ = new Dictionary( true ); // _url = DisplayLoader
		
		private var _drawCompleteHandler:Function;
		private var _url:String;
		private var _bitmap:ABitmap;
		
		public function ExternalPicture( url:String, drawCompleteHandler:Function = null ) {
			_url = url;
			_drawCompleteHandler = drawCompleteHandler;
			
			super();
		}
		
		override public function init():* {
			super.init();
			
			var bd:BitmapData = _cache[ _url ]; // Загружен ли ресур ранее
			
			if ( !bd ) {
				var loader:DisplayLoader = _loaders[ _url ];
				
				if ( loader ) {// Если загрузчик этого ресурса уже добавлен в очередь, тогда просто подписываемся на его событие и ждём, пока загрузится
//					Log.traceText( this + " жду, пока загрузиться " + _url );
					loader.addEventListener( LoaderEvent.COMPLETE, onLoadComplete );
				} else {
//					Log.traceText( this + " Загружаю " + _url );
					loader = new DisplayLoader( _url );
					_loaders[ _url ] = loader;
					loader.addEventListener( LoaderEvent.COMPLETE, onLoadComplete );
					loader.start();
				}
			} else {
				// Если ресурс был ранее загружен, достаём его из кэша
//				Log.traceText( this + " беру из кэша " + _url );
				drawAndComplete( bd );
			}
			
			return this;
		}
		
		private function onLoadComplete( ev:LoaderEvent ):void {
			var loader:DisplayLoader = ev.target as DisplayLoader;
			loader.removeEventListener( LoaderEvent.COMPLETE, onLoadComplete );
			
			var bd:BitmapData = _cache[ _url ];
			
			if ( !bd ) {
//				Log.traceText( this + " Помещаю ресурс в кэш " + _url );
//				Ресурс отсутствует в кэше - помещаем его в кэш
				bd = loader.getBitmapData();
				
				delete _loaders[ _url ];
				
				_cache[ _url ] = bd;
			}
			
			loader.dispose();
			
			drawAndComplete( bd );
		}
		
		private function drawAndComplete( bd:BitmapData ):void {
			_bitmap = new ABitmap( bd ).init();
			_bitmap.disposeOnKill = false; // При удалении картинки с экрана, изображение останется в кэше
			addChild( _bitmap );
			
			if ( _drawCompleteHandler != null ) {
				if ( _drawCompleteHandler.length ) {
					_drawCompleteHandler( this );
				} else {
					_drawCompleteHandler();
				}
			}
		}
		
		public function get bitmap():ABitmap {
			return _bitmap;
		}
		
		override public function kill():void {
			_drawCompleteHandler = null;
			super.kill();
		}
	}

}
