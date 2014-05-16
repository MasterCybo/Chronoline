package net
{
	import ru.arslanov.core.http.HTTPRequest;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ReqPresetsList extends HTTPRequest
	{

		public function ReqPresetsList()
		{
			super( "preset.php?list" );
		}

	}

}