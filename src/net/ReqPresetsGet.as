package net
{
	import ru.arslanov.core.http.HTTPRequest;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ReqPresetsGet extends HTTPRequest
	{

		public function ReqPresetsGet()
		{
			super( "preset.php?list" );
		}

	}

}