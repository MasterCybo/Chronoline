package display.base {
	import ru.arslanov.flash.display.ABitmap;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ToggleText extends ToggleApp {
		
		private var _text:String;
		private var _width:int;
		private var _height:int;
		private var _paddings:uint;
		
		public function ToggleText( text:String = "", width:int = -1, height:int = -1, paddings:uint = 20 ) {
			_text = text;
			_width = width;
			_height = height;
			_paddings = paddings;
			
			super();
		}
		
		override public function init():* {
			super.label = new TextApp( _text ).init();
			
			var ww:uint = _width > 0 ? _width : super.label.width + _paddings;
			var hh:uint = _height > 0 ? _height : super.label.height + _paddings;
			
			super.skinUp = ABitmap.fromColor( 0X7DABBF, ww, hh ).init();
			super.skinOver = ABitmap.fromColor( 0X98BDCD, ww, hh ).init();
			super.skinDown = ABitmap.fromColor( 0XFF8000, ww, hh ).init();
			super.skinDownOver = ABitmap.fromColor( 0XFFA042, ww, hh ).init();
			
			return super.init();
		}
	}

}