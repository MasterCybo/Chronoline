package events {
	import ru.arslanov.core.events.ANotice;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class GuideLineNotice extends ANotice {
		
		static public const NAME:String = "displayLineNotice";
		
		public var visible:Boolean;
		
		public function GuideLineNotice( visible:Boolean ) {
			this.visible = visible;
			
			super();
			
		}
		
	}

}