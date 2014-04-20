package data {
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.core.utils.JDUtils;
	/**
	 * Объект исторического периода, содержащий даты начала и конца периода.
	 * @author Artem Arslanov
	 */
	public class MoPeriod extends ModelBase {
		
		// Дата может быть определена не точно
		public var beginJD:Number;
		public var endJD:Number;
		
		public function MoPeriod( beginJD:Number = 0, endJD:Number = 0 ) {
			this.beginJD = beginJD;
			this.endJD = endJD;
			
			super();
		}
		
		public function get duration():Number {
			return endJD - beginJD;
		}
		
		public function get middle():Number {
			return beginJD + duration * 0.5;
		}
		
		public function get isFixed():Boolean {
			return beginJD == endJD;
		}
		
		public function clone():MoPeriod {
			return new MoPeriod( beginJD, endJD );
		}
		
		override public function toString():String {
			return "[" + getQualifiedClassName( this ) + ", " + JDUtils.getFormatString( beginJD ) + " - " + JDUtils.getFormatString( endJD ) + "]"
		}
	}

}