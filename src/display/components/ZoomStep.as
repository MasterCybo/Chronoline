package display.components {
	import data.MoTimeline;
	import display.gui.buttons.BtnIcon;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.layout.VBox;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ZoomStep extends ASprite {
		
		public var onChange:Function;
		
		private var _step:Number;
		private var _min:Number;
		private var _max:Number;
		private var _pos:Number;
		
		public function ZoomStep( min:Number = 0, max:Number = 1, step:Number = 0.1 ) {
			_min = min;
			_max = max;
			_step = step;
			_pos = _min;
			super();
		}
		
		override public function init():* {
			var vbox:VBox = new VBox().init();
			
			var btnPlus:BtnIcon = new BtnIcon( PngBtnPlus ).init();
			var btnMinus:BtnIcon = new BtnIcon( PngBtnMinus ).init();
			
			btnPlus.onRelease = onClickPlus;
			btnMinus.onRelease = onClickMinus;
			
			vbox.addChildAndUpdate( btnPlus );
			vbox.addChildAndUpdate( btnMinus );
			
			var body:ABitmap = ABitmap.fromColor( Settings.GUI_COLOR, Settings.NAVBAR_WIDTH, vbox.height + 10 ).init();
			
			vbox.x = int(( body.width - vbox.width ) / 2 );
			vbox.y = int(( body.height - vbox.height ) / 2 );
			
			addChild( body );
			addChild( vbox );
			
			return super.init();
		}
		
		private function onClickPlus():void {
			if ( _pos + _step > _max )
				return;
			
			_pos += _step;
			
			callOnChange();
		}
		
		private function onClickMinus():void {
			if ( _pos - _step < _min )
				return;
			
			_pos -= _step;
			
			callOnChange();
		}
		
		private function callOnChange():void {
			if (onChange != null) {
				onChange();
			}
		}
		
		public function get step():Number {
			return _step;
		}
		
		public function set step( value:Number ):void {
			_step = value;
		}
		
		public function get position():Number {
			return _pos;
		}
		
		public function set position(value:Number):void {
			_pos = Math.max( _min, Math.min( value, _max ) );
		}
		
		override public function kill():void {
			onChange = null;
			
			super.kill();
		}
	}

}