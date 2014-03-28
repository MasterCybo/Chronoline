package data {
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class MoListPartition extends Object {
		
		public var count:uint; // Количество сущностей в разделе
		public var type:String; // Тип раздела для команды ReqPartitions
		public var name:String; // Имя для отображения
		
		public function MoListPartition( count:uint, type:String, name:String ) {
			this.count = count;
			this.type = type;
			this.name = name;
			super();
		}
		
		static public function parseJSON( json:Object ):MoListPartition {
			return new MoListPartition( json.cnt, json.type, json.name );
		}
	}

}
