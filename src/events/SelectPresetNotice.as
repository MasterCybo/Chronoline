/**
 * Created by aa on 26.05.2014.
 */
package events
{
	import ru.arslanov.core.events.ANotice;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class SelectPresetNotice extends ANotice
	{
		static public const NAME:String = "selectPresetNotice";

		public var presetID:String = "";

		public function SelectPresetNotice( presetID:String )
		{
			this.presetID = presetID;
			super();
		}
	}
}
