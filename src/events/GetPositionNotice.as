package events {
	import ru.arslanov.core.events.ANotice;
	
	/**
	 * Получение глобальных координат экранного объекта
	 * @author Artem Arslanov
	 */
	public class GetPositionNotice extends ANotice {
		
		static public const NAME:String = "getPositionNotice";
		
		public var objectID:String;
		public var globalX:Number = 0;
		public var globalY:Number = 0;
		
		public function GetPositionNotice( objectID:String ) {
			this.objectID = objectID;
			super();
			
		}
		
	}

}