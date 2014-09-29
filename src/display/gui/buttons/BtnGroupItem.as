package display.gui.buttons {
	import display.base.ToggleApp;
	import display.gui.TextTriming;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.Bmp9Scale;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class BtnGroupItem extends ToggleApp {
		static public const PADDING:uint = 0;
		
		private var _caption:String;
		private var _width:uint;
		private var _align:String;
		private var _height:uint;
		private var _icoClosed:ABitmap;
		private var _icoOpened:ABitmap;
		
		public function BtnGroupItem( caption:String = "", width:uint = 150, height:uint = 20, align:String = "left" ) {
			_caption = caption;
			_width = width;
			_height = height;
			_align = align;
			
			super();
		}
		
		override public function setupSkinsCustom():void {
			_icoClosed = ABitmap.fromClass( PngIcoPartClose ).init();
			_icoOpened = ABitmap.fromClass( PngIcoPartOpen ).init();
			
			super.skinUp = Bmp9Scale.createFromClass( PngBtnListNormal, new Point( 2, 2 ), new Point( 2, 2 ) ).init();
			super.skinUp.setSize( _width, _height );
			
			super.skinOver = Bmp9Scale.createFromClass( PngBtnListOver, new Point( 2, 2 ), new Point( 2, 2 ) ).init();
			super.skinOver.setSize( _width, _height );
			
			super.skinDown = Bmp9Scale.createFromClass( PngBtnListNormal, new Point( 2, 2 ), new Point( 2, 2 ) ).init();
			super.skinDown.setSize( _width, _height );
			
			super.skinDownOver = Bmp9Scale.createFromClass( PngBtnListOver, new Point( 2, 2 ), new Point( 2, 2 ) ).init();
			super.skinDownOver.setSize( _width, _height );
			
			super.label = new TextTriming( _caption, null, _width - 2 * PADDING ).init();
		}
		
		override protected function updateState():void {
			super.updateState();
			
			if ( checked ) {
				if ( contains( _icoOpened ) ) {
					removeChild( _icoOpened );
				}
				if ( !contains( _icoClosed ) ) {
					addChild( _icoClosed );
				}
			} else {
				if ( contains( _icoClosed ) ) {
					removeChild( _icoClosed );
				}
				if ( !contains( _icoOpened ) ) {
					addChild( _icoOpened );
				}
			}
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
			
			( super.label as TextTriming ).width = _width - 2 * super.label.x;
		}
		
		override protected function updateLabelPosition( eventType:String, offsetX:Number = 0, offsetY:Number = 0 ):void {
			super.label.y = int(( super.skinUp.height - super.label.height ) / 2 );
			
			switch ( _align ) {
				case "left":
					super.label.x = Math.max( _icoClosed.width, _icoOpened.width ) + PADDING;
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
