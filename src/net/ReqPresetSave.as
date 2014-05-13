package net
{
	import flash.net.URLVariables;

	import ru.arslanov.core.http.HTTPRequest;
	import ru.arslanov.core.utils.Log;

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
			vars.entityId = ids.join(",");
			vars.name = "test_preset";

			super( "preset.php", vars );
		}

	}

}