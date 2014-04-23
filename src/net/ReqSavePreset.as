package net {
	import flash.net.URLVariables;

	import ru.arslanov.core.http.HTTPRequest;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ReqSavePreset extends HTTPRequest {
		
		public function ReqSavePreset( type:String, idEntities:Array ) {
			var vars:URLVariables = new URLVariables();
			vars.type = type;
			vars.reltype = "Event";
			vars.save = "";
			
			for (var i:int = 0; i < idEntities.length; i++) {
				vars[ "entityId[" + (i + 1) + "]" ] = idEntities[i];
			}
			
			
			//super( "preset.php", "save&type=" + type + "&reltype=Event" + params );
			super( "preset.php", vars );
		}
		
	}

}