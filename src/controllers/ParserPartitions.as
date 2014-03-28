package controllers {
	import data.MoListPartition;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ParserPartitions {
		
		static public const EXCLUDE_TYPES:Array = ["Event"];
		
		static public function serializeJSON( data:Object ):Vector.<MoListPartition> {
			var arrParts:Array /*Object*/ = JSON.parse( String( data ) ) as Array;
			
			arrParts = arrParts.sortOn( "name" );
			
			var len:uint = arrParts.length;
			var vect:Vector.<MoListPartition> = new Vector.<MoListPartition>();
			
			for ( var i:int = 0; i < len; i++ ) {
				if ( EXCLUDE_TYPES.indexOf( arrParts[ i ].type ) != -1 ) continue; // Если один из типов входит исключения - пропускаем элемент
				vect.push( MoListPartition.parseJSON( arrParts[ i ] ) );
			}
			
			return vect;
		}
	}

}
