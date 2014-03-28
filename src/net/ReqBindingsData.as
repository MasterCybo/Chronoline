package net {
	import flash.net.URLVariables;
	import ru.arslanov.core.http.HTTPRequest;
	import ru.arslanov.core.utils.Log;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ReqBindingsData extends HTTPRequest {
		
		static public const URL:String = "entitydata.php";
		
		public function ReqBindingsData( idEntities:Array, offset:uint, numObjects:uint ) {
			var vars:URLVariables = new URLVariables();
			vars.type = "Binding";
			vars.entityId = idEntities.join( "," );
			vars.offset = offset;
			vars.count = numObjects;
			
			super( URL, vars );
		}
		
	}

}
