package net {
	import ru.arslanov.core.http.HTTPRequest;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ReqPartitions extends HTTPRequest {
		
		static public const URL:String = "partitions.php";
		
		public function ReqPartitions() {
			super( URL );
			
			altURL = "partitions.json";
		}
		
	}

}