package data {
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.core.utils.Log;
	/**
	 * Связь между сущностями
	 * @author Artem Arslanov
	 */
	public class MoBond extends ModelBase {
		
		public var entityUid1:String = "";
		public var entityUid2:String = "";
		
		public function MoBond( id:String, entityUid1:String, entityUid2:String ) {
			this.entityUid1 = entityUid1;
			this.entityUid2 = entityUid2;
			
			// id связи соответствует id события MoFact.id
			super( id );
		}
		
		static public function fromJSON( json:Object ):MoBond {
			//Log.traceText( "type : " + json.type, "link : " + json.link, "title : " + json.title );
			
			return new MoBond( json.id, json.entityId1, json.entityId2 );
		}
		
		override public function toString():String {
			return "[" + getQualifiedClassName( this ) + " " + uidStr + ", " + id + ", entities : " + entityUid1 + " - " + entityUid2 + "]";
		}
	}

}
