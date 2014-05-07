/**
 * Created by aa on 05.05.2014.
 */
package net {
	import flash.net.URLVariables;

	import ru.arslanov.core.http.HTTPRequest;

	public class ReqETagList extends HTTPRequest {
		public function ReqETagList() {
			super( "admin.etaglist.php" );
		}
	}
}
