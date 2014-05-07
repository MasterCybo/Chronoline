package events {
	import flash.events.Event;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class TimelineEvent extends Event {
		
		// Новые события
		static public const SCALE_CHANGED		:String = "scaleChanged"; // Изменение временного масштаба
		static public const BASE_CHANGED		:String = "baseChanged"; // Измененине текущей даты
		static public const INITED				:String = "inited"; // Событие окончания инициализации временной шкалы
		
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