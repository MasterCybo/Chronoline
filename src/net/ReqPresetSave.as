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

		public function ReqPresetSave( ids:Array, name:String = "untitled_preset" )
		{
			var vars:URLVariables = new URLVariables();
			vars.save = "";
			vars.entityId = ids.join(",");
			vars.name = name;

			super( "preset.php", vars );
		}

	}

}