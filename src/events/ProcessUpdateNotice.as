package events {
	import ru.arslanov.core.events.ANotice;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ProcessUpdateNotice extends ANotice {
		static public const NAME:String = "processUpdateNotice";
		
		public var progress:Number;
		public var total:Number;
		
		public function ProcessUpdateNotice( progress:Number, total:Number ) {
			this.progress = progress;
			this.total = total;
			super();
		}
		
	}

}