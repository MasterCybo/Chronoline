package ru.arslanov.core.utils {
	
	/**
	 * Равномерный рандом
	 * @author Artem Arslanov
	 */
	public class RndNormal {
		
		static private var _maxValue:uint = 2147483647;
		
		private var _val:uint;
		private var _k:uint = 1220703125;
		private var _b:uint = 7;
		private var _m:uint;
		
		public function RndNormal( modul:uint = 100 ) {
			_m = modul;
			var t:Date = new Date();
			var s:String = t.time.toString();
			s = s.substr( s.length - 3, 3 );
			_val = uint( s );
		}
		
		public function get value():uint {
			_val = (( _k * _val + _b ) % _maxValue );
			return _val % _m;
		}
	}

}