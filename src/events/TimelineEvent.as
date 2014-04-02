package events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class TimelineEvent extends Event {
		
		// Новые события
		static public const TIMELINE_RESIZE :String = "timelineResize"; // Изменение границ временной шкалы
		static public const RANGE_MOVE 		:String = "rangeMove"; // Смещение наблюдаемого диапазона
		static public const RANGE_RESIZE 	:String = "rangeResize"; // Изменнеие границ диапазона
		static public const SCALE_CHANGED	:String = "scaleChanged"; // Изменение временного масштаба
		
		//public var deltaBegin:Number;
		//public var deltaEnd:Number;
		
		public function TimelineEvent( type:String ) {
			super( type, false, false );
		}
		
		public override function clone():Event {
			return new TimelineEvent( type );
		}
		
		public override function toString():String {
			return formatToString( "TimeLineEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}
	
	}

}