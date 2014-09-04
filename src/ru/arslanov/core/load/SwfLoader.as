package ru.arslanov.core.load {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import ru.arslanov.core.utils.Log;
	
	/**
	 * Загрузчик SWF-файла
	 * @author Artem Arslanov
	 */
	public class SwfLoader extends AbstractLoader {
		
		// Если флаг установлен, тогда на любой геттер, если объект не найден будет возвращаться заглушка.
		// Если флаг сброшен, тогда будет возвращаться null
		static public var returnEmptyObject:Boolean = true;
		
		private var _ldr:Loader;
		
		public function SwfLoader( url:String ) {
			super( url );
		}
		
		public function get instance():Loader {
			return _ldr;
		}
		
		override public function start():void {
			_ldr = new Loader();
			
			setEventDispatcher( _ldr.contentLoaderInfo );
			
			super.start();
			
			_ldr.load( new URLRequest( _url ) );
		}
		
		override public function stop():void {
			if ( super._openStream ) {
				_ldr.close();
			}
		}
		
		/**
		 * Метод возвращает объект типа BitmapData ассоциированным по linkage из загруженной библиотеки.
		 * @param	linkage
		 * @return
		 */
		public function getBitmapData( linkage:String ):BitmapData {
			var SrcClass:Class = getClass( linkage );
			var src:BitmapData;
			
			if ( SrcClass ) {
				src = new SrcClass() as BitmapData;
			} else if ( returnEmptyObject ) {
				logDefError( "getBitmapData", linkage );
				src = new BitmapData( 40, 40, true, 0x82ff0000 );
			}
			return src;
		}
		
		/**
		 * Метод возвращает объект типа MovieClip ассоциированным по linkage из загруженной библиотеки.
		 * @param	linkage
		 * @return
		 */
		public function getMovieClip( linkage:String ):MovieClip {
			var SrcClass:Class = getClass( linkage );
			var src:MovieClip;
			
			if ( SrcClass ) {
				src = new SrcClass() as MovieClip;
			} else if ( returnEmptyObject ) {
				logDefError( "getMovieClip", linkage );
				src = new MovieClip();
				drawEmpty( src.graphics );
			}
			
			return src;
		}
		
		/**
		 * Метод возвращает объект типа Sprite ассоциированным по linkage из загруженной библиотеки.
		 * @param	linkage
		 * @return
		 */
		public function getSprite( linkage:String ):Sprite {
			var SrcClass:Class = getClass( linkage );
			var src:Sprite;
			
			if ( SrcClass ) {
				src = new SrcClass() as Sprite;
			} else if ( returnEmptyObject ) {
				logDefError( "getSprite", linkage );
				src = new Sprite();
				drawEmpty( src.graphics );
			}
			
			return src;
		}
		
		/**
		 * Метод возвращает ссылку на контент загруженной библиотеки.
		 * Аналог Loader.contentLoaderInfo.content
		 */
		public function get content():MovieClip {
			return _ldr.contentLoaderInfo.content as MovieClip;
		}
		
		private function getClass( linkage:String ):Class {
			if ( !_ldr.contentLoaderInfo.applicationDomain.hasDefinition( linkage ) ) {
				return null;
			}
			return _ldr.contentLoaderInfo.applicationDomain.getDefinition( linkage ) as Class;
		}
		
		private static function drawEmpty( graphics:Graphics ):void {
			graphics.beginFill( 0xff0000, 0.5 );
			graphics.drawRect( 0, 0, 20, 20 );
			graphics.endFill();
		}
		
		private function logDefError( methodName:String, key:String ):void {
			Log.traceError( 'SwfLoader.' + methodName + '(".' + key + '") : Объект "' + key + '" не найден!' );
		}
		
		override public function dispose():void {
			stop();
			
			_ldr.unloadAndStop();
			
			super.dispose();
		}
		
	}

}