package net {
	import flash.net.URLVariables;

	import ru.arslanov.core.http.HTTPRequest;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ReqPartEntities extends HTTPRequest {
		
		static public const URL:String = "partitionentities.php";
		
		public var type:String;
		
		public function ReqPartEntities( type:String ) {
			this.type = type;
			
			var vars:URLVariables = new URLVariables();
			vars.type = type;
			
			super( URL, vars );
			
			altURL = "partitionentities.json";
		}
		
	}

}