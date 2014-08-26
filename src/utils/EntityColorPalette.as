package utils
{

	/**
	 * ...
	 * @author ...
	 */
	public class EntityColorPalette
	{

		private var _colors:Vector.<uint>;
		private var _curIdx:uint;

		public function EntityColorPalette()
		{
			generateNewPalette();
		}

		public function generateNewPalette():void
		{
			_curIdx = 0;
			_colors = Vector.<uint>(
					[ 0xff9e9e
						, 0xffc976
						, 0xe4e253
						, 0x8dee83
						, 0x7deff6
						, 0xadbcff
						, 0xfaa0ff
						, 0xdbbbbb
						, 0xdfc0ff
						, 0x7fffd2 ]
			);
			
			for ( var i:int = 0; i < 50; i++ ) {
				_colors.push( uint( Math.random() * 0xFFFFFF ) );
			}
		}

		public function getNextColor():uint
		{
			var prevIdx:uint = _curIdx;

			_curIdx++;
			
			if( _curIdx >= _colors.length ) {
				_curIdx = 0;
			}
			
			return _colors[ prevIdx ];
		}
		
		public function getColor( id:String ):uint
		{
			var prevIdx:uint = _curIdx;

			_curIdx++;

			if( _curIdx >= _colors.length ) {
				_curIdx = 0;
			}

			return _colors[ prevIdx ];
		}

		public function reset():void
		{
			_curIdx = 0;
		}
	}

}