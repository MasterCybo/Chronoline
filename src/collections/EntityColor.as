package collections {
	
	/**
	 * ...
	 * @author ...
	 */
	public class EntityColor {
		
		//static private const COLORS:Vector.<uint> = Vector.<uint>( [ 0x0599B0, 0xA4BD0A, 0xFF8E0A, 0xA060FF, 0x5AB56D, 0xC9BF58 ] );
		//static private const COLORS:Vector.<uint> = Vector.<uint>( [ 0xC75E5E, 0xCF8936, 0xA4A213, 0x4DAE43, 0x3DAFB6, 0x6D7CDA, 0xBA60D1, 0x9B7B7B, 0x9F80C4, 0x3FC692 ] );
		static private const COLORS:Vector.<uint> = Vector.<uint>( [ 0xff9e9e, 0xffc976, 0xe4e253, 0x8dee83, 0x7deff6, 0xadbcff, 0xfaa0ff, 0xdbbbbb, 0xdfc0ff, 0x7fffd2 ] );
		
		static private var _curIdx:uint;
		
		public function EntityColor() {
		
		}
		
		static public function getColor():uint {
			var clr:uint;
			
			if ( _curIdx < COLORS.length ) {
				clr = COLORS[ _curIdx ];
			} else {
				clr = uint( Math.random() * 0xFFFFFF );
			}
			
			_curIdx++;
			
			return clr;
		}
		
		static public function reset():void {
			_curIdx = 0;
		}
	}

}