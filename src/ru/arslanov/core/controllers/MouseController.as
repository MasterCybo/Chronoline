package ru.arslanov.core.controllers {
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import ru.arslanov.core.events.EventManager;
	import ru.arslanov.core.events.MouseControllerEvent;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * ...
	 * @author
	 */
	public class MouseController extends EventDispatcher {
		
		private var _target:InteractiveObject;
		private var _targetUp:InteractiveObject;
		private var _targetMove:InteractiveObject;
		private var _targetWheel:InteractiveObject;
		
		private var _prevX:Number = 0;
		private var _prevY:Number = 0;
		
		private var _deltaWheel:Number = 0;
		private var _movement:Point = new Point();
		private var _pressed:Point = new Point();
		private var _released:Point = new Point();
		private var _globalPosition:Point = new Point();
		
		protected var _eventManager:EventManager = new EventManager();
		
		public function MouseController( target:InteractiveObject, targetUp:InteractiveObject = null, targetMove:InteractiveObject = null, targetWheel:InteractiveObject = null ) {
			_target = target;
			_targetUp = targetUp ? targetUp : Display.stage;
			_targetMove = targetMove ? targetMove : Display.stage;
			_targetWheel = targetWheel ? targetWheel : target;
			
			_target.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			_target.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			_target.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			_targetWheel.addEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
			
			if ( !( _target is Stage ) ) {
				_target.mouseEnabled = true;
			}
			
			super();
		}
		
		override public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void {
			_eventManager.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		override public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void {
			_eventManager.removeEventListener( type, listener, useCapture );
		}
		
		override public function dispatchEvent( event:Event ):Boolean {
			return _eventManager.dispatchEvent( event );
		}
		
		protected function onMouseOver( ev:MouseEvent ):void {
			_eventManager.dispatchEvent( new MouseControllerEvent( MouseControllerEvent.MOUSE_OVER ) );
		}
		
		protected function onMouseOut( ev:MouseEvent ):void {
			_eventManager.dispatchEvent( new MouseControllerEvent( MouseControllerEvent.MOUSE_OUT ) );
		}
		
		protected function onMouseDown( ev:MouseEvent ):void {
			_pressed.setTo( _target.mouseX, _target.mouseY );
			
			_prevX = ev.stageX;
			_prevY = ev.stageY;
			
			_eventManager.dispatchEvent( new MouseControllerEvent( MouseControllerEvent.MOUSE_DOWN ) );
			
			_targetUp.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			_targetMove.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		protected function onMouseUp( ev:MouseEvent ):void {
			_released.setTo( _targetUp.mouseX, _targetUp.mouseY );
			
			_eventManager.dispatchEvent( new MouseControllerEvent( MouseControllerEvent.MOUSE_UP ) );
			
			_targetUp.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			_targetMove.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		protected function onMouseWheel( ev:MouseEvent ):void {
			_deltaWheel = ev.delta;
			
			_eventManager.dispatchEvent( new MouseControllerEvent( MouseControllerEvent.MOUSE_WHEEL ) );
			
			_deltaWheel = 0;
		}
		
		protected function onMouseMove( ev:MouseEvent ):void {
			_globalPosition.setTo( ev.stageX, ev.stageY );
			
			_movement.x = ev.stageX - _prevX;
			_movement.y = ev.stageY - _prevY;
			
			_prevX = ev.stageX;
			_prevY = ev.stageY;
			
			_eventManager.dispatchEvent( new MouseControllerEvent( MouseControllerEvent.MOUSE_MOVE ) );
		}
		
		public function get deltaWheel():Number {
			return _deltaWheel;
		}
		
		public function get movement():Point {
			return _movement;
		}
		
		public function get pressed():Point {
			return _pressed;
		}
		
		public function get released():Point {
			return _released;
		}
		
		public function get globalPosition():Point {
			return _globalPosition;
		}
		
		public function get target():InteractiveObject {
			return _target;
		}
		
		public function dispose():void {
			_eventManager.dispose();
			_eventManager = null;
			
			_target.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			_target.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			_target.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			_targetUp.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			_targetMove.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			_targetWheel.removeEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
			
			_target = null;
			_targetUp = null;
			_targetMove = null;
			_targetWheel = null;
			_movement = null;
			_pressed = null;
			_released = null;
		}
	}

}