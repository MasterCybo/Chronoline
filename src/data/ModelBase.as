package data {
	import flash.utils.getQualifiedClassName;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ModelBase {
		
		static private var _counter:Number = 0;
		
		public var id:String;
		public var title:String = "";
		public var description:String = "";
		
		private var _uid:Number = 0;
		
		public function ModelBase( id:String = "", title:String = "", description:String = "" ) {
			_uid = ++_counter;
			
			this.id = id;
			this.title = title;
			this.description = description;
		}
		
		public function get uid():Number {
			return _uid;
		}
		
		public function get uidStr():String {
			return "0x" + uid.toString( 16 ).toUpperCase();
		}
		
		public function toString():String {
			return "[" + getQualifiedClassName( this ) + " " + uidStr + ", title=" + title.substr( 0, 15 ) + "..." + "]";
		}
	}

}