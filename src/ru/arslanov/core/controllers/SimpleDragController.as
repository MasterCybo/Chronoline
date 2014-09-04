package ru.arslanov.core.controllers {
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import ru.arslanov.core.events.MouseControllerEvent;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class SimpleDragController extends MouseController {
		private var _dragArea:Rectangle;
		private var _checkBounds:Boolean;
		private var _position:Point = new Point();
		private var _tbounds:Rectangle;
		
		public function SimpleDragController( target:InteractiveObject, checkBounds:Boolean = false ) {
			_checkBounds = checkBounds;
			
			super( target );
		}
		
		override protected function onMouseMove( ev:MouseEvent ):void {
			super.onMouseMove( ev );
			
			onDragMouse();
		}
		
		private function onDragMouse():void {
			setPosition( super.target.x + super.movement.x, super.target.y + super.movement.y );
			
			_eventManager.dispatchEvent( new MouseControllerEvent( MouseControllerEvent.MOUSE_DRAG ) );
		}
		
		public function get dragArea():Rectangle {
			return _dragArea;
		}
		
		public function set dragArea( value:Rectangle ):void {
			if ( !value )
				return;
			if ( _dragArea && _dragArea.equals( value ) )
				return;
			
			_dragArea = value;
		}
		
		public function get position():Point {
			return _position;
		}
		
		public function setPosition( newX:Number, newY:Number ):void {
			_tbounds = super.target.getBounds( super.target.parent );
			_tbounds.x = newX;
			_tbounds.y = newY;
			
			var left:Number = 0;
			var right:Number = 0;
			var top:Number = 0;
			var bottom:Number = 0;
			
			if ( _checkBounds ) {
				left = _tbounds.left;
				right = _tbounds.right;
				top = _tbounds.top;
				bottom = _tbounds.bottom;
			} else {
				left = right = _tbounds.x + _tbounds.width * 0.5;
				top = bottom = _tbounds.y + _tbounds.height * 0.5;
			}
			
			if ( _dragArea ) {
				if (( left >= _dragArea.left ) && ( right <= _dragArea.right ) ) {
					super.target.x = _tbounds.x;
				}
				
				if (( top >= _dragArea.top ) && ( bottom <= _dragArea.bottom ) ) {
					super.target.y = _tbounds.y;
				}
			}
			
			_position.setTo( super.target.x, super.target.y );
		}
		
		override public function dispose():void {
			_dragArea = null;
			
			super.dispose();
		}
	}

}