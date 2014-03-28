package events {
	import ru.arslanov.core.events.ANotice;
	
	/**
	 * Событие окончания загрузки данных
	 * @author Artem Arslanov
	 */
	public class ServerDataCompleteNotice extends ANotice {
		
		static public const NAME:String = "serverDataCompleteNotice";
		
		public function ServerDataCompleteNotice() {
			super();
		}
		
	}

}