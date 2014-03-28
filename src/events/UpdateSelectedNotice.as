package events {
	import ru.arslanov.core.events.ANotice;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class UpdateSelectedNotice extends ANotice {
		
		static public const NAME:String = "updateSelectedNotice";
		
		public var count:int;
		
		public function UpdateSelectedNotice( num:int ) {
			count = num;
			
			super();
			
		}
		
	}

}