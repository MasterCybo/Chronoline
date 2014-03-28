package display.components {
	import display.base.TextApp;
	import flash.display.BitmapData;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * Направляющая линия, ориентир, указатель (Indicator)
	 * @author Artem Arslanov
	 */
	public class GuideLine extends ASprite {
		
		private var _width:uint;
		private var _tfInfo:TextApp;
		private var _line:ABitmap;
		private var _bd:BitmapData;
		
		public function GuideLine( width:uint ) {
			_width = width;
			super();
		}
		
		override public function init():* {
			_line = new ABitmap().init();
			
			_tfInfo = new TextApp( "" ).init();
			_tfInfo.setBorder( true, 0x40FF0000 );
			_tfInfo.setBackground( true, 0xffffff );
			
			drawLine();
			
			addChild( _line );
			addChild( _tfInfo );
			
			return super.init();
		}
		
		private function drawLine():void {
			if ( _bd ) {
				_bd.dispose();
			}
			
			_bd = new BitmapData( _width, 1, true, 0x40FF0000 );
			_line.bitmapData = _bd;
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width( value:Number ):void {
			if ( value == _width )
				return;
			
			_width = value;
			
			drawLine();
		}
		
		override public function get height():Number {
			return _line.height;
		}
		
		override public function set height( value:Number ):void {
			// Запрещаем менять высоту
			// super.height = value;
		}
		
		public function set textLabel( value:* ):void {
			_tfInfo.text = "" + value;
			_tfInfo.y = -int( _tfInfo.height / 2 );
		}
	}

}