/**
 * Created by aa on 05.05.2014.
 */
package ru.arslanov.flash.display
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;

	import ru.arslanov.core.events.LoaderEvent;
	import ru.arslanov.core.load.DisplayLoader;

	/**
	 * Класс отображения BitmapData с возможностью загрузки изображения из внешнего хранилища или использования встраиваемого ресурса.
	 * Все BitmapData помещаются в кэш для повторного использования.
	 */
	public class Picture extends ABitmap
	{
		static private var _cache:Dictionary /*BitmapData*/ = new Dictionary( true ); // id = BitmapData

		/**
		 * Очищает кэш изображений
		 */
		public static function clearCache():void
		{
			_cache = new Dictionary( true );
		}

		/**
		 * Полная очистка кэша, с высвобождением памяти с помощью метода dispose
		 */
		public static function disposeCacheBitmapData():void
		{
			for each ( var bd:BitmapData in _cache ) {
				bd.dispose();
			}

			clearCache();
		}


		private var _width:uint = 0;
		private var _height:uint = 0;

		public function Picture( bitmapData:BitmapData = null, width:uint = 0, height:uint = 0 )
		{
			_width = width;
			_height = height;

			super( bitmapData );
		}

		/**
		 * Отображает данные BitmapData и изменяет конечный размер изображения
		 * @param bitmapData
		 * @param width - если =0, то предыдущее значение _width не перезаписывается
		 * @param height - если =0, то предыдущее значение _height не перезаписывается
		 */
		public function drawAndResize( bitmapData:BitmapData, width:uint = 0, height:uint = 0 ):void
		{
			_width = width > 0 ? width : _width;
			_height = height > 0 ? height : _height;

			var ww:int;
			var hh:int;

			if ( (_width > 0) && (_height <= 0) ) {
				ww = _width;
				hh = bitmapData.width * ( _width / bitmapData.width );
			}

			if ( (_width <= 0) && (_height > 0) ) {
				hh = _height;
				ww = bitmapData.height * ( _height / bitmapData.height );
			}

			if ( (_width > 0) && (_height > 0) ) {
				ww = _width;
				hh = _height;
			}

			var isResize:Boolean = (_width > 0) || (_height > 0);
			if ( isResize ) {
				var mtx:Matrix = new Matrix();
				mtx.scale( ww / bitmapData.width, hh / bitmapData.height );

				var bd:BitmapData = new BitmapData( ww, hh );
				bd.draw( bitmapData, mtx, null, null, null, true );

				bitmapData = bd;
			}

			this.bitmapData = bitmapData;

			eventManager.dispatchEvent( new LoaderEvent( LoaderEvent.COMPLETE ) );
		}

		/**
		 * Создание изображения из внедрённой ресурса
		 * @param embedClass
		 */
		public function drawEmbed( embedClass:Class ):void
		{
			var bd:BitmapData = _cache[embedClass];

			if ( bd ) {
				drawAndResize( bd );
			} else {
				drawAndResize( ABitmap.fromClass( embedClass ).bitmapData );
			}
		}

		/**
		 * Загружает внешний ресурс
		 * @param url
		 */
		public function load( url:String ):void
		{
			var bd:BitmapData = _cache[url];

			if ( bd ) {
				drawAndResize( bd );
			} else {
				var loader:DisplayLoader = new DisplayLoader( url );
				loader.addEventListener( LoaderEvent.COMPLETE, onLoadComplete );
				loader.start();
			}
		}

		private function onLoadComplete( event:LoaderEvent ):void
		{
			drawAndResize( (event.target as DisplayLoader).getBitmapData() );
		}
	}
}
