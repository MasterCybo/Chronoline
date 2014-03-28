package data {
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class MoListEntity extends Object {
		
		public var id:String;
		public var name:String;
		public var count:uint;
		
		public function MoListEntity( id:String, name:String, count:uint ) {
			this.id = id;
			this.name = name;
			this.count = count;
			
			super();
		}
		
		static public function parseJSON( json:Object ):MoListEntity {
			return new MoListEntity( json.id, json.name, json.cnt );
		}
		
		public function toString():String {
			return "[" + id + ", " + name + ", " + count + "]"
		}
	}

}
