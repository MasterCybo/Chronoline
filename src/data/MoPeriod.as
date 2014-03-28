package data {
	import flash.utils.getQualifiedClassName;
	/**
	 * Объект исторического периода, содержащий даты начала и конца периода.
	 * @author Artem Arslanov
	 */
	public class MoPeriod extends ModelBase {
		
		// Дата может быть определена не точно
		public var dateBegin:MoDate;
		public var dateEnd:MoDate;
		
		public function MoPeriod( begin:MoDate = null, end:MoDate = null ) {
			this.dateBegin = begin ? begin : new MoDate();
			this.dateEnd = end ? ( begin.equals( end ) ? begin.clone() : end ) : new MoDate();
			
			super();
		}
		
		public function get duration():Number {
			return dateEnd.jd - dateBegin.jd;
		}
		
		public function get middle():Number {
			return dateBegin.jd + duration * 0.5;
		}
		
		public function get isFixed():Boolean {
			return dateBegin.equals( dateEnd );
		}
		
		public function get string():String {
			return isFixed ? dateBegin.getFormatedDate() : dateBegin.getFormatedDate() + " - " + dateEnd.getFormatedDate();
		}
		
		public function clone():MoPeriod {
			return new MoPeriod( dateBegin.clone(), dateEnd.clone() );
		}
		
		override public function toString():String {
			return "[" + getQualifiedClassName( this ) + ", " + dateBegin + " - " + dateEnd + "]"
		}
	}

}