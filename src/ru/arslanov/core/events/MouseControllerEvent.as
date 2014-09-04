package ru.arslanov.core.events
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class MouseControllerEvent extends Event
	{

		static public const CLICK:String = MouseEvent.CLICK;
		static public const MOUSE_OVER:String = MouseEvent.MOUSE_OVER;
		static public const MOUSE_OUT:String = MouseEvent.MOUSE_OUT;
		static public const MOUSE_DOWN:String = MouseEvent.MOUSE_DOWN;
		static public const MOUSE_UP:String = MouseEvent.MOUSE_UP;
		static public const MOUSE_WHEEL:String = MouseEvent.MOUSE_WHEEL;
		static public const MOUSE_MOVE:String = MouseEvent.MOUSE_MOVE;
		static public const MOUSE_DRAG:String = "mouseDrag";

		public function MouseControllerEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );

		}

		public override function clone():Event
		{
			return new MouseControllerEvent( type, bubbles, cancelable );
		}

		public override function toString():String
		{
			return formatToString( "MouseControllerEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}

	}

}