package display.gui.buttons {
	import display.gui.TextTriming;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import ru.arslanov.flash.display.Bmp9Scale;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class BtnItemRelocation extends BtnGroupRelocation {
		static public const PADDING:uint = 10;
		
		private var _caption:String;
		private var _width:uint;
		private var _align:String;
		private var _height:uint;
		
		public function BtnItemRelocation( caption:String = "", width:uint = 150, height:uint = 20, align:String = "left" ) {
			_caption = caption;
			_width = width;
			_height = height;
			_align = align;
			
			super();
		}
		
		override public function setupSkinsCustom():void {
			super.skinUp = Bmp9Scale.createFromClass( PngBtnListNormal, new Point( 2, 2 ), new Point( 2, 2 ) ).init();
			super.skinOver = Bmp9Scale.createFromClass( PngBtnListOver, new Point( 2, 2 ), new Point( 2, 2 ) ).init();
			super.skinDown = Bmp9Scale.createFromClass( PngBtnListOver, new Point( 2, 2 ), new Point( 2, 2 ) ).init();
			
			super.skinUp.setSize( _width, _height );
			super.skinOver.setSize( _width, _height );
			super.skinDown.setSize( _width, _height );
			
			super.label = new TextTriming( _caption, null, _width - 2 * PADDING ).init();
		}
		
		public function get caption():String {
			return _caption;
		}
		
		public function set caption( value:String ):void {
			_caption = value;
			
			( super.label as TextTriming ).text = _caption;
			
			updateLabelPosition( MouseEvent.MOUSE_UP );
		}
		
		override public function set width( value:Number ):void {
			super.width = _width = value;
			
			( super.label as TextTriming ).width = _width - 2 * PADDING;
		}
		
		override protected function updateLabelPosition( eventType:String, offsetX:Number = 0, offsetY:Number = 0 ):void {
			super.label.y = int(( super.skinUp.height - super.label.height ) / 2 );
			
			switch ( _align ) {
				case "left":
					super.label.x = PADDING;
					break;
				case "right":
					super.label.x = super.skinUp.width - super.label.width - PADDING;
					break;
				default:
					super.updateLabelPosition( eventType, offsetX, offsetY );
			}
		
		}
	}

}
