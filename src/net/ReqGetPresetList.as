package net {
	import ru.arslanov.core.http.HTTPRequest;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ReqGetPresetList extends HTTPRequest {
		
		public function ReqGetPresetList() {
			super("preset.php", "list");
		}
		
	}

}