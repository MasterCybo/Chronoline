package ru.arslanov.core.load {
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	/**
	 * Загрузчик текстовых файлов, вместо XmlLoader
	 * @author Artem Arslanov
	 */
	public class TextLoader extends AbstractLoader {
		
		private var _ldr:URLLoader;
		
		
		public function TextLoader( url:String = null ) {
			super( url );
		}
		
		override public function start():void {
			_ldr = new URLLoader();
			_ldr.dataFormat = URLLoaderDataFormat.TEXT;
			
			setEventDispatcher( _ldr );
			
			super.start ();
			
			_ldr.load( new URLRequest( url ) );
		}
		
		override public function stop():void {
			if ( super._openStream ) {
				_ldr.close();
			}
		}
		
		public function getXml():XML {
			return XML( _ldr.data );
		}
		
		public function getString():String {
			return String( _ldr.data );
		}
		
		override public function dispose():void {
			stop();
			
			super.dispose();
		}
	}

}