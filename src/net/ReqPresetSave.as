package net
{
	import flash.net.URLVariables;

	import ru.arslanov.core.http.HTTPRequest;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ReqPresetSave extends HTTPRequest
	{

		public function ReqPresetSave( ids:Array )
		{
			var vars:URLVariables = new URLVariables();
			vars.save = "";

			for ( var i:int = 0; i < ids.length; i++ ) {
				vars[ "entityId[" + (i + 1) + "]" ] = ids[i];
			}

			super( "preset.php", vars );
		}

	}

}