package ru.arslanov.flash.gui {
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class SlideBox extends ASprite {
		
		private var _source:DisplayObject;
		private var _bounds:Rectangle;
		
		private var _vSlider:SliderBase;
		private var _hSlider:SliderBase;
		
		private var _srcHeight:Number;
		private var _srcWidth:Number;
		
		private var _ptPress:Point;
		private var _ptMouse:Point;
		
		public function SlideBox( source:DisplayObject, bounds:Rectangle = null ) {
			_source = source;
			_bounds = bounds;
			
			_srcHeight = _source.height;
			_srcWidth = _source.width;
			
			super();
		}
		
		override public function init():* {
			super.mouseEnabled = false;
			
			_bounds = _bounds ? _bounds : new Rectangle( 0, 0, 200, 200 );
			
			x = _source.x = _bounds.x;
			y = _source.y = _bounds.y;
			
			_bounds.x = 0;
			_bounds.y = 0;
			
			_source.scrollRect = _bounds;
			
			if ( _srcWidth > _bounds.width ) {
				_hSlider = new SliderBase( new SliderSkinDefault(), _bounds.width ).init();
				_hSlider.setTargetObject( _source );
				_hSlider.onSlide = slideHorizontal;
				_hSlider.y = _bounds.height;
				addChild( _hSlider );
			}
			
			if ( _srcHeight > _bounds.height ) {
				_vSlider = new SliderBase( new SliderSkinDefault(), _bounds.height ).init();
				_vSlider.setTargetObject( _source );
				_vSlider.onSlide = slideVertical;
				_vSlider.rotation = 90;
				_vSlider.x = _bounds.width + _vSlider.width;
				//_vSlider.x = 500;
				//_vSlider.x = _vSlider.width;
				
				//trace( "_bounds.width : " + _bounds.width );
				
				addChild( _vSlider );
			}
			
			//trace( "_vSlider.x, y : " + _vSlider.x, _vSlider.y );
			
			return super.init();
		}
		
		private function slideHorizontal( sdr:SliderBase ):void {
			_bounds.x = ( _srcWidth - _bounds.width ) * sdr.position;
			_source.scrollRect = _bounds;
		}
		
		private function slideVertical( sdr:SliderBase ):void {
			_bounds.y = ( _srcHeight - _bounds.height ) * sdr.position;
			_source.scrollRect = _bounds;
		}
		
		public function set positionVertical( value:Number ):void {
			if ( !_vSlider ) return;
			_vSlider.position = value;
		}
		
		public function get positionVertical():Number {
			return _vSlider ? _vSlider.position : 0;
		}
		
		public function set positionHorizontal( value:Number ):void {
			if ( !_hSlider ) return;
			_hSlider.position = value;
		}
		
		public function get positionHorizontal():Number {
			return _hSlider ? _hSlider.position : 0;
		}
		
		public function set mouseControll( value:Boolean ):void {
			if ( value ) {
				_ptPress = new Point();
				_ptMouse = new Point();
				Display.stageAddEventListener( MouseEvent.MOUSE_DOWN, onPress );
			} else {
				_ptPress = null;
				_ptMouse = null;
				Display.stageRemoveEventListener( MouseEvent.MOUSE_DOWN, onPress );
			}
		}
		
		public function get mouseControll():Boolean {
			return _ptPress != null;
		}
		
		private function onPress( ev:MouseEvent ):void {
			_ptPress.x = ev.stageX;
			_ptPress.y = ev.stageY;
			_ptPress = _source.globalToLocal( _ptPress );
			
			if ( !_bounds.containsPoint( _ptPress ) ) return;
			
			Display.stageAddEventListener( MouseEvent.MOUSE_UP, onRelease );
			Display.stageAddEventListener( MouseEvent.MOUSE_MOVE, onSlide );
		}
		
		private function onSlide( ev:MouseEvent ):void {
			_ptMouse.x = ev.stageX;
			_ptMouse.y = ev.stageY;
			
			_ptMouse = globalToLocal( _ptMouse );
			
			positionHorizontal = Math.max( 0, Math.min( -_ptMouse.x + _ptPress.x, ( _srcWidth - _bounds.width ) ) ) / ( _srcWidth - _bounds.width );
			positionVertical = Math.max( 0, Math.min( -_ptMouse.y + _ptPress.y, ( _srcHeight - _bounds.height ) ) ) / ( _srcHeight - _bounds.height );
		}
		
		private function onRelease( ev:MouseEvent ):void {
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onRelease );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onSlide );
		}
		
		override public function kill():void {
			Display.stageRemoveEventListener( MouseEvent.MOUSE_DOWN, onPress );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onRelease );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onSlide );
			
			_source.scrollRect = null;
			
			super.kill();
			
			_source = null;
			_bounds = null;
			_ptPress = null;
			_ptMouse = null;
			_vSlider = null;
			_hSlider = null;
		}
	}

}