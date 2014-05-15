/**
 * Created by aa on 14.05.2014.
 */
package data
{
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class MoPresetItemList extends ModelBase
	{

		public static function parse( json:Object ):MoPresetItemList
		{
			var ids:Array = String( json.param ).split( "," );
			return new MoPresetItemList( json.id, json.name, ids );
		}

		public var listIDs:Array = [];

		public function MoPresetItemList( id:String = "", title:String = "", listIDs:Array = null )
		{
			this.listIDs = listIDs ? listIDs : this.listIDs;
			super( id, title );
		}
	}
}
