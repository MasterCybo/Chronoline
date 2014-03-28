package events {
	import ru.arslanov.core.events.ANotice;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ProcessStartNotice extends ANotice {
		
		static public const NAME:String = "processStartNotice";
		
		public function ProcessStartNotice() {
			super();
		}
		
	}

}