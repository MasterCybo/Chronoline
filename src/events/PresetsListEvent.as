/**
 * Created by aa on 16.05.2014.
 */
package events
{
	import data.MoPresetItemList;

	import flash.events.Event;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class PresetsListEvent extends Event
	{
		static public const COMPLETE:String = "PresetsListEvent.complete";

		public var listPresets:Vector.<MoPresetItemList>;

		public function PresetsListEvent( listPresets:Vector.<MoPresetItemList> )
		{
			this.listPresets = listPresets;

			super( COMPLETE, false, false );
		}
	}
}
