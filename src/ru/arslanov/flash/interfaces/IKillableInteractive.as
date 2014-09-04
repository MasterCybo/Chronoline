package ru.arslanov.flash.interfaces {
	import flash.events.Event;

	import ru.arslanov.core.events.EventManager;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public interface IKillableInteractive extends IKillable {
		function get eventManager():EventManager;
		function set mouseEnabled( value:Boolean ):void;

		function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void;
		function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void;
		function dispatchEvent( event:Event ):Boolean;
		function hasEventListener(type:String):Boolean;
	}
	
}