package display.gui {
	import display.base.TextApp;
	import flash.text.TextFormat;
	import ru.arslanov.core.utils.Log;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class TextTriming extends TextApp {
		private var _width:uint;
		private var _text:String;
		
		public function TextTriming( text:* = "", format:TextFormat = null, width:uint = 100 ) {
			_text = String( text );
			_width = width;
			super( text, format );
		}
		
		override public function init():* {
			super.init();
			
			updateTrim();
			
			return this;
		}
		
		override public function set width( value:Number ):void {
			_width = value;
			
			updateTrim();
		}
		
		override public function get text():String {
			return _text;
		}
		
		override public function set text( value:String ):void {
			_text = value;
			
			updateTrim();
		}
		
		private function updateTrim():void {
			super.text = _text;
			
			if ( width > _width ) {
				var idx:int = super.getCharIndexAtPoint( _width, super.height / 2 );
				idx = idx == -1 ? _text.length : idx;
				
				super.text = _text.substring( 0, Math.max( 3, idx - 3 ) ) + "...";
			} else {
				super.text = _text;
			}
		}
	}

}