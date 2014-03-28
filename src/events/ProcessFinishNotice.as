package events {
	import ru.arslanov.core.events.ANotice;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ProcessFinishNotice extends ANotice {
		
		static public const NAME:String = "processFinishNotice";
		
		public function ProcessFinishNotice() {
			super();
		}
		
	}

}