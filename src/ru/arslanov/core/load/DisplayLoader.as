package ru.arslanov.core.load {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import ru.arslanov.core.utils.Log;
	
	/**
	 * Загрузчик изображений
	 * @author Artem Arslanov
	 */
	public class DisplayLoader extends AbstractLoader {
		
		private var _ldr:Loader;
		
		public function DisplayLoader( url:String ) {
			super( url );
		}
		
		public function get instance():Loader {
			return _ldr;
		}
		
		override public function start():void {
			_ldr = new Loader();
			
			setEventDispatcher( _ldr.contentLoaderInfo );
			addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			
			super.start();
			
			_ldr.load( new URLRequest( _url ) );
		}
		
		override public function stop():void {
			if ( super._openStream ) {
				_ldr.close();
			}
		}
		
		override protected function ioErrorHandler( event:IOErrorEvent ):void {
			Log.traceError( this + " : " + event.text );
			super.completeHandler( new Event( Event.COMPLETE ) );
		}
		
		public function get content():* {
			if ( !_ldr.content ) {
				var cont:MovieClip = new MovieClip();
				drawEmpty( cont.graphics );
				return cont;
			}
			return _ldr.content;
		}
		
		public function getContent( instanceName:String ):MovieClip {
			var cont:MovieClip = new MovieClip();
			if ( _ldr.content && _ldr.content[ instanceName ] ) {
				cont = _ldr.content[ instanceName ];
			} else {
				Log.traceError( this + " : Resource name '" + instanceName + "' not found!" );
				drawEmpty( cont.graphics );
			}
			
			return cont;
		}
		
		public function getBitmap():Bitmap {
			if ( _ldr.content is Bitmap ) {
				return _ldr.content as Bitmap;
			} else {
				return new Bitmap( drawEmptyBD() );
			}
		}
		
		public function getBitmapData():BitmapData {
			if ( _ldr.content is Bitmap ) {
				return ( _ldr.content as Bitmap ).bitmapData;
			} else if ( _ldr.content ) {
				var bmpData:BitmapData = new BitmapData( _ldr.content.width, _ldr.content.height );
				bmpData.draw( _ldr.content, null, null, null, null, true );
				return bmpData;
			} else {
				return drawEmptyBD();
			}
		}
		
		private function drawEmpty( target:Graphics ):void {
			target.beginFill( 0xff0000, 0.5 );
			target.drawRect( 0, 0, 40, 40 );
			target.endFill();
		}
		
		private function drawEmptyBD():BitmapData {
			return new BitmapData( 40, 40, true, 0x82ff0000 );
		}
		
		override public function dispose():void {
			removeEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			
			stop();
			
			_ldr.unloadAndStop();
			
			super.dispose();
		}
	}

}