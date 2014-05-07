/**
 * Created by aa on 05.05.2014.
 */
package data
{
	public class MoETag
	{

		public var id:String;
		public var num:uint;
		public var imageURL:String;
		public var name:String;

		public static function parse( json:Object ):MoETag
		{
			return new MoETag( json.id, json.cnt, json.filename, json.name);
		}

		public function MoETag( id:String, num:uint, imageURL:String, name:String )
		{
			this.id = id;
			this.num = num;
			this.imageURL = imageURL;
			this.name = name;
		}


		public function toString():String
		{
			return "[" + id + ", " + name + ", " + imageURL + ", " + num + "]";
		}
	}
}
