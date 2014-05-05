package net {
	import flash.net.URLVariables;

	import ru.arslanov.core.http.HTTPRequest;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ReqGetPresetList extends HTTPRequest {
		
		public function ReqGetPresetList() {
			var vars:URLVariables = new URLVariables();
			vars.count = "list";
			super("preset.php", vars);
		}
		
	}

}