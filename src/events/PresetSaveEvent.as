/**
 * Created by aa on 16.05.2014.
 */
package events
{
	import flash.events.Event;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class PresetSaveEvent extends Event
	{
		static public const COMPLETE:String = "PresetSaveEvent.complete";

		public var presetID:String = "";

		public function PresetSaveEvent( presetID:String = "" )
		{
			this.presetID = presetID;
			super( COMPLETE, false, false );
		}
	}
}
