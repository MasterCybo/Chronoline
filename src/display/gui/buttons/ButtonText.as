package display.gui.buttons {
	import display.base.ButtonApp;
	import display.base.TextApp;
	import flash.geom.Point;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.Bmp9Scale;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ButtonText extends ButtonApp {
		private var _text:String;
		private var _width:int;
		private var _height:int;
		private var _paddings:uint;
		
		public function ButtonText( text:String = "", width:int = -1, height:int = -1, paddings:uint = 20 ) {
			_text = text;
			_width = width;
			_height = height;
			_paddings = paddings;
			
			super();
		}
		
		override public function setupSkinsCustom():void {
			super.label = new TextApp( _text ).init();
			
			var ww:uint = _width > 0 ? _width : super.label.width + _paddings;
			var hh:uint = _height > 0 ? _height : super.label.height + _paddings;
			
			super.skinUp = Bmp9Scale.createFromClass( PngBtnNormal, new Point( 2,2 ), new Point( 4,4 ) ).init();
			super.skinOver = Bmp9Scale.createFromClass( PngBtnOver, new Point( 2, 2 ), new Point( 4, 4 ) ).init();
			
			super.skinUp.setSize( ww, hh );
			super.skinOver.setSize( ww, hh );
		}
	}

}