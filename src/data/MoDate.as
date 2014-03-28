package data {
	import constants.LocaleString;
	import ru.arslanov.core.utils.DateUtils;
	import ru.arslanov.core.utils.StringUtils;
	/**
	 * Базовый класс исторической даты.
	 * @author Artem Arslanov
	 */
	public class MoDate {
		
		static public function parse( jd:Number ):MoDate {
			return new MoDate( jd );
		}
		
		
		
		
		
		private var _jd:Number = 0;
		
		private var _year:int;
		private var _month:uint;
		private var _hours:uint;
		private var _minutes:uint;
		private var _date:uint; // Число месяца
		
		public function MoDate( jd:Number = 0 ) {
			this.jd = jd;
		}
		
		/***************************************************************************
		ГЕТТЕРЫ / СЕТТЕРЫ
		***************************************************************************/
		//{ region 
		/**
		 * Julian day
		 */
		public function get jd():Number {
			return _jd;
		}
		
		/**
		 * Julian day
		 */
		public function set jd( value:Number ):void {
			_jd = value;
		}
		
		/**
		 * Julian days to Grigorian date
		 * @return Object { year:Number, month:Number, date:Number, weekday:Number, hours:hours, minutes:minutes, seconds:seconds }
		 */
		public function getGregorian():Object {
			//return DateUtils.JDNToDate( jd );
			return DateUtils.JDToDate( jd );
		}
		//} endregion
		
		/***************************************************************************
		Utilites
		***************************************************************************/
		
		public function equals( moDate:MoDate ):Boolean {
			return jd == moDate.jd;
		}
		
		public function getFormatedDate():String {
			return getFormatString( LocaleString.DATE_FORMAT );
		}
		
		public function getFormatString( format:String ):String {
			var gdate:Object = getGregorian();
			return StringUtils.substitute( format, gdate.date, DateUtils.getMonthName( gdate.month ), gdate.year );
			//return StringUtils.substitute( format, gdate.date, gdate.month, gdate.year );
		}
		
		public function getFormatFullString( format:String ):String {
			var gdate:Object = getGregorian();
			return StringUtils.substitute( format, gdate.date, DateUtils.getMonthName( gdate.month ), gdate.year, StringUtils.numberToString( gdate.hours ), StringUtils.numberToString( gdate.minutes ), StringUtils.numberToString( gdate.seconds ) );
		}
		
		public function toString():String {
			var gdate:Object = getGregorian();
			//return "JDx" + jd + " = " + gdate.date + "/" + DateUtils.getMonthName( gdate.month ) + "/" + gdate.year;
			//return "JDx" + jd + " = " + gdate.date + "/" + gdate.month + "/" + gdate.year;
			return "JDx" + jd + " = " + StringUtils.substitute( "{2}-{1}-{0}, {3}:{4}:{5}"
										, gdate.date
										, DateUtils.getMonthName( gdate.month )
										, gdate.year
										, gdate.hours
										, gdate.minutes
										, gdate.seconds);
		}
		
		public function clone():MoDate {
			return new MoDate( jd );
		}
	}

}