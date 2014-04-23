package display.components {
	import display.gui.buttons.BtnIcon;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.layout.VBox;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ZoomStepper extends ASprite {
		
		public var onChange:Function;
		
		private var _step:Number;
		private var _min:Number;
		private var _max:Number;
		private var _pos:Number;
		private var _tmrTick:Timer; // шаговый таймер
		private var _tmrDelay:Timer; // таймер задежки перед включением шагового таймера
		private var _direct:int = 0; // направление изменения положения
		
		public function ZoomStepper( min:Number = 0, max:Number = 1, step:Number = 0.1 ) {
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
			
			btnPlus.onRelease = onReleaseButton;
			btnPlus.onPress = onPressPlus;
			
			btnMinus.onRelease = onReleaseButton;
			btnMinus.onPress = onPressMinus;
			
			vbox.addChildAndUpdate( btnPlus );
			vbox.addChildAndUpdate( btnMinus );
			
			var body:ABitmap = ABitmap.fromColor( Settings.GUI_COLOR, Settings.NAVBAR_WIDTH, vbox.height + 10 ).init();
			
			vbox.x = int(( body.width - vbox.width ) / 2 );
			vbox.y = int(( body.height - vbox.height ) / 2 );
			
			addChild( body );
			addChild( vbox );
			
			_tmrDelay = new Timer( 500, 1 );
			_tmrDelay.addEventListener( TimerEvent.TIMER_COMPLETE, onDelayComplete );
			
			_tmrTick = new Timer( 10 );
			_tmrTick.addEventListener( TimerEvent.TIMER, onTickTimer );
			
			return super.init();
		}
		
		private function onPressPlus():void {
			_direct = 1;
			_tmrDelay.start();
		}
		
		private function onPressMinus():void {
			_direct = -1;
			_tmrDelay.start();
		}
		
		private function onReleaseButton():void {
			changePosition();
			
			_direct = 0;
			_tmrTick.stop();
			_tmrDelay.stop();
		}
		
		private function onDelayComplete( ev:TimerEvent ):void {
			_tmrDelay.stop();
			_tmrTick.start();
		}
		
		private function onTickTimer( ev:TimerEvent ):void {
			changePosition();
		}
		
		private function changePosition():void {
			var newPos:Number = _pos + _step * _direct;
			
			if ( newPos < _min ) {
				_tmrTick.stop();
				setPosition( newPos );
				return;
			}
			
			if ( newPos > _max ) {
				_tmrTick.stop();
				setPosition( newPos );
				return;
			}
			
			setPosition( newPos );
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
		
		public function set position( value:Number ):void {
			_pos = Math.max( _min, Math.min( value, _max ) );
		}
		
		private function setPosition( value:Number ):void {
			position = value;
			
			if ( onChange != null ) {
				onChange();
			}
		}
		
		override public function kill():void {
			onChange = null;
			
			_tmrDelay.removeEventListener( TimerEvent.TIMER, onDelayComplete );
			_tmrTick.removeEventListener( TimerEvent.TIMER, onTickTimer );
			
			_tmrDelay.stop();
			_tmrTick.stop();
			
			super.kill();
		}
	}

}