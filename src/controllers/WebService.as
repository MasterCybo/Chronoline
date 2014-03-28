package controllers {
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class WebService {
		
		private var _cacheResponses:Dictionary/*String*/ = new Dictionary( true ); // ключ - имя запроса, значение - ответ сервера
		
		public function WebService() {
			
		}
		
		public function sendRequest( /*интерфейс запроса*/ ):void {
			
		}
		
		public function clearCache():void {
			_cacheResponses = new Dictionary( true );
		}
	}

}