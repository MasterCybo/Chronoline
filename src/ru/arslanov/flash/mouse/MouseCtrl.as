/**
 * Created by aa on 06.05.2014.
 */
package ru.arslanov.flash.mouse
{
	import flash.events.Event;

	import ru.arslanov.core.events.EventManager;

	import ru.arslanov.flash.interfaces.IKillableInteractive;

	public class MouseCtrl
	{
		private var _target:IKillableInteractive;
		private var _eventManager:EventManager;

		public function MouseCtrl( target:IKillableInteractive )
		{
			_target = target;
			_eventManager = new EventManager( target );
		}

		public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void {
			_target.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}

		public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void {
			_target.removeEventListener( type, listener, useCapture );
		}

		public function dispatchEvent( event:Event ):Boolean {
			return _target.dispatchEvent( event );
		}
	}
}
