package net {
	import flash.net.URLVariables;

	import ru.arslanov.core.http.HTTPRequest;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ReqEntityData extends HTTPRequest {
		
		static public const URL:String = "entitydata.php";
		
		public function ReqEntityData( idEntities:Array, offset:uint, numObjects:uint ) {
			var vars:URLVariables = new URLVariables();
			vars.type = "Entity";
			vars.entityId = idEntities.join( "," );
			vars.offset = offset;
			vars.count = numObjects;
			
			super( URL, vars );
			
			altURL = "entitydata.json";
		}
		
	}

}
