package utils {
	import data.MoPeriod;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class BoundUtils {
		
		static public function min( bound1:MoPeriod, bound2:MoPeriod ):MoPeriod {
			if ( !bound1 || !bound2 ) return bound1 || bound2;
			
			if ( bound1.begin.getValue() <= bound2.begin.getValue() ) {
				return bound1;
			} else {
				return bound2;
			}
		}
		
		static public function max( bound1:MoPeriod, bound2:MoPeriod ):MoPeriod {
			if ( !bound1 || !bound2 ) return bound1 || bound2;
			
			if ( bound1.begin.getValue() > bound2.begin.getValue() ) {
				return bound1;
			} else {
				return bound2;
			}
		}
	}

}