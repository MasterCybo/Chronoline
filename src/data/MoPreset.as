/**
 * Created by aa on 14.05.2014.
 */
package data {
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class MoPreset extends ModelBase {
		public static function parse(json:Object):MoPreset
		{
			var ids:Array = String(json.param).split(",");
			return new MoPreset(json.id, json.name, ids);
		}


		public var listIDs:Array = [];

		public function MoPreset(id:String = "", title:String = "", listIDs:Array = null)
		{
			this.listIDs = listIDs ? listIDs : this.listIDs;
			super(id, title);
		}
	}
}
