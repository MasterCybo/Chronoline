package controllers {
	import data.MoListEntity;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ParserEntities {
		
		static public function serializeJSON( data:Object ):Vector.<MoListEntity> {
			var arrParts:Array /*Object*/ = JSON.parse( String( data ) ) as Array;
			
			arrParts = arrParts.sortOn( "name" );
			
			var len:uint = arrParts.length;
			var vect:Vector.<MoListEntity> = new Vector.<MoListEntity>();
			
			for ( var i:int = 0; i < len; i++ ) {
				vect.push( MoListEntity.parseJSON( arrParts[ i ] ) );
			}
			
			return vect;
		}
		
	}

}
