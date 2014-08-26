package display.components {
	import display.gui.buttons.BtnIcon;

	import flash.geom.Rectangle;

	import ru.arslanov.core.controllers.SimpleDragController;
	import ru.arslanov.core.events.MouseControllerEvent;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ZoomSlider extends ASprite {
		public var onChange:Function;
		public var onPress:Function;
		public var onRelease:Function;
		
		private var _dragCtrl:SimpleDragController;
		private var _thumb:BtnIcon;
		
		public function ZoomSlider() {
			super();
		}
		
		override public function init():* {
			var body:ABitmap = ABitmap.fromColor( Settings.GUI_COLOR, Settings.NAVBAR_WIDTH, Settings.ZOOM_SLIDER_HEIGHT ).init();
			_thumb = new BtnIcon( PngThumbZoom ).init();
			
			var pad:Number = Math.round( 5 + _thumb.height / 2 );
			
			var track:ASprite = new ASprite().init();
			track.graphics.beginFill( 0xc8c8c8 );
			track.graphics.drawRect( 0, 0, 2, body.height - 2 * pad );
			track.graphics.endFill();
			
			track.x = Math.round(( body.width - track.width ) / 2 );
			track.y = pad;
			
			_thumb.x = track.x + Math.round(( track.width - _thumb.width ) / 2 );
			_thumb.y = track.y;
			
			_dragCtrl = new SimpleDragController( _thumb, false );
			_dragCtrl.dragArea = new Rectangle( Math.round( _thumb.x + _thumb.width / 2 ), track.y, 0, track.height );
			_dragCtrl.addEventListener(MouseControllerEvent.MOUSE_DRAG, onThumbDrag);
			_dragCtrl.addEventListener(MouseControllerEvent.MOUSE_DOWN, onMouseDown);
			_dragCtrl.addEventListener(MouseControllerEvent.MOUSE_UP, onMouseUp);
			
			addChild( body );
			addChild( track );
			addChild( _thumb );
			
			return super.init();
		}
		
		private function onMouseDown( ev:MouseControllerEvent ):void {
			if ( onPress != null ) {
				onPress();
			}
		}
		
		private function onMouseUp( ev:MouseControllerEvent ):void {
			if ( onRelease != null ) {
				onRelease();
			}
		}
		
		private function onThumbDrag( ev:MouseControllerEvent ):void {
			if ( onChange != null ) {
				onChange();
			}
		}
		
		public function get heightTrack():Number {
			return _dragCtrl.dragArea.height;
		}
		
		public function get position():Number {
			return 1 - ( _dragCtrl.position.y + _dragCtrl.target.height / 2 - _dragCtrl.dragArea.y ) / _dragCtrl.dragArea.height;
		}
		
		public function set position( value:Number ):void {
			value = Math.max( 0, Math.min( value, 1 ) );
			_thumb.y = _dragCtrl.dragArea.y + _dragCtrl.dragArea.height - _dragCtrl.dragArea.height * value - _dragCtrl.target.height / 2;
		}
		
		override public function kill():void {
			onChange = null;
			onPress = null;
			onRelease = null;
			_dragCtrl.dispose();
			
			super.kill();
		}
	}

}