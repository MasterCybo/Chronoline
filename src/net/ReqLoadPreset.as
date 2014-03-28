package net {
	import ru.arslanov.core.http.HTTPRequest;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ReqLoadPreset extends HTTPRequest {
		
		public function ReqLoadPreset( id:uint ) {
			super( "preset.php", "load&id=" + id );
		}
		
	}

}