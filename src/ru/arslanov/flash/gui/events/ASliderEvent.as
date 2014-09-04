/**
 * Created by aa on 20.05.2014.
 */
package ru.arslanov.flash.gui.events
{
	import flash.events.Event;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ASliderEvent extends Event
	{
		static public const CHANGE_VALUE:String = "ASliderEvent.changeValue";

		public var position:Number = 0;

		public function ASliderEvent( position:Number, type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			this.position = position;

			super( type, bubbles, cancelable );
		}

		override public function clone():Event
		{
			var event:ASliderEvent = super.clone() as ASliderEvent;
			event.position = this.position;
			return event;
		}
	}
}
