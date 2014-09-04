package ru.arslanov.core.utils {
	import flash.utils.getTimer;
	
	/**
	 * Измерение производительности Performance
	 * @author Artem Arslanov
	 */
	public class Perf {
		
		static private var _t1:int = 0;
		
		static public function start():void {
			_t1 = getTimer();
		}
		
		static public function stop():String {
			return "Delay " + ( getTimer() - _t1 ) + " ms";
		}
	}

}