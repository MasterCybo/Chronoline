package ru.arslanov.core.utils
{

	/**
	 * Класс для работы с Юлианским календарём. Формула справедлива для дат после 23 ноября −4713 г.
	 * @author Artem Arslanov
	 */
	public class JDUtils
	{

		static public const GREGORIAN_EPOCH:Number = 1721425.5; // 
		static public const MIN_YEAR:int = -4713; // 
		static public const DAYS_PER_YEAR:Number = 365.25; // Среднее количество дней в Юлианском году
		static public const DAYS_PER_MONTH:Number = 30.4375; // Среднее количество дней в месяце 365.25/12
		static public const WEEKS_PER_MONTH:Number = 4.34821428571428571429; // Среднее количество недель в месяце 30.4375/7
		
		static public var weekdaysLocale:Array = [ "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье" ];
		static public var monthsLocale:Array = [ "Января", "Февраля", "Марта", "Апреля", "Мая", "Июня", "Июля", "Августа", "Сентября", "Октября", "Ноября", "Декабря" ];
		
		/**
		 * Конвертирование Юлианского числа в Григорианскую дату
		 * Взято с стайта https://www.fourmilab.ch/documents/calendar/
		 * @param    jd - Юлианская дата, содержащая дробную часть
		 * @return   {year:Number, month:Number, date:Number, weekday:Number, hours:Number, minutes:Number, seconds:Number}
		 */
		static public function JDToGregorian( jd:Number ):Object
		{
			var wjd:Number = Math.floor( jd - 0.5 ) + 0.5;
			var depoch:Number = wjd - GREGORIAN_EPOCH;
			var quadricent:Number = Math.floor( depoch / 146097 );
			var dqc:Number = depoch % 146097;
			var cent:Number = Math.floor( dqc / 36524 );
			var dcent:Number = dqc % 36524;
			var quad:Number = Math.floor( dcent / 1461 );
			var dquad:Number = dcent % 1461;
			var yindex:Number = Math.floor( dquad / 365 );
			var year:Number = quadricent * 400 + cent * 100 + quad * 4 + yindex;

			if ( !(( cent == 4 ) || ( yindex == 4 ) ) ) year++;

			var yearday:Number = wjd - gregorianToJD( year, 1, 1 );
			var leapadj:Number = ( wjd < gregorianToJD( year, 3, 1 ) ) ? 0 : ( isLeapGregorian( year ) ? 1 : 2 );
			var month:Number = Math.floor( ((( yearday + leapadj ) * 12 ) + 373 ) / 367 );
			var day:Number = (wjd - gregorianToJD( year, month, 1 )) + 1;
			
			var time:Object = JDToTime( jd );
			
			var weekday:uint = Math.floor( jd + 1.5 ) % 7; // 0-воскресенье, 1-понедельник, 2-вторник и т.д.
			
			return { year: year, month: month, date: day, weekday: weekday, hours: time.hours, minutes: time.minutes, seconds: time.seconds };
		}

		/**
		 * Конвертирование Грегорианской даты в Юлианское число
		 * Взято с стайта https://www.fourmilab.ch/documents/calendar/
		 * @param year
		 * @param month
		 * @param day
		 * @return Number
		 */
		static public function gregorianToJD( year:Number, month:Number = 1, day:Number = 1, hours:uint = 0, minutes:uint = 0, seconds:uint = 0 ):Number
		{
			return ( GREGORIAN_EPOCH - 1 )
					+ ( 365 * ( year - 1 ) )
					+ Math.floor( ( year - 1 ) / 4 )
					+ ( -Math.floor( ( year - 1 ) / 100 ) )
					+ Math.floor( ( year - 1 ) / 400 )
					+ Math.floor( ((( 367 * month ) - 362 ) / 12 ) + (( month <= 2 ) ? 0 : ( isLeapGregorian( year ) ? -1 : -2 ) ) + day )
					+ Math.floor(seconds + 60 * (minutes + 60 * hours) + 0.5) / 86400.0;
		}

		/**
		 * Проверка високосности Григорианского года
		 * Взято с стайта https://www.fourmilab.ch/documents/calendar/
		 * @param year
		 * @return Boolean
		 */
		static public function isLeapGregorian( year:Number ):Boolean
		{
			return (( year % 4 ) == 0 ) && ( !((( year % 100 ) == 0 ) && (( year % 400 ) != 0 ) ) );
		}

		/**
		 * Вычисление времени по Юлианскому числу
		 * Взято с стайта https://www.fourmilab.ch/documents/calendar/
		 * @param jd
		 * @return { hours:Number, minutes:Number, seconds:Number }
		 */
		static public function JDToTime( jd:Number ):Object
		{
			var j:Number = jd + 0.5; // Astronomical to civil
			var ij:Number = ((j - Math.floor( j )) * 86400.0) + 0.5;
			return {
				hours  : Math.floor( ij / 3600 ),
				minutes: Math.floor( (ij / 60) % 60 ),
				seconds: Math.floor( ij % 60 )
			};
		}
		
		static public function getNameMonth( numMonth:uint ):String
		{
			//trace( "*execute* DateUtils.getNameMonth" );
			//trace( "num : " + num );
			return monthsLocale[ Math.max( 0, numMonth - 1 ) ];
		}

		static public function getNameWeekday( num:uint ):String
		{
			return weekdaysLocale[( 6 + num ) % 7 ];
		}

		/**
		 * Форматирование даты по шаблону
		 * @param jd
		 * @param template - шаблон строки {0}-год, {1}-месяц, {2}-число, {3}-день недели, {4}-час, {5}-минута
		 * @return String
		 */
		static public function getFormatString( jd:Number, template:String = "{2} {1} {0}, {4}:{5}" ):String
		{
			// – дефис
			var date:Object = JDToGregorian( jd );
			
			var str:String = "";
			
			if ( template && template != "" ) {
				str = StringUtils.substitute( template, date.year // {0}
						, getNameMonth( date.month ) // {1}
						, StringUtils.numberToString( date.date, 1 ) // {2}
						, getNameWeekday( date.weekday ) // {3}
						, StringUtils.numberToString( date.hours ) // {4}
						, StringUtils.numberToString( date.minutes ) ); // {5}
			}
			else {
				str = "" + jd;
			}
			
//			trace( jd + " = " + str );
			
			return str;
		}

		/**
		 * Разница между двумя юлианскими датами в ЮЛИАНСКИХ ДНЯХ
		 * @param jd1
		 * @param jd2
		 * @return
		 */
		static public function diffDays( jd1:Number, jd2:Number ):Number
		{
			return jd2 - jd1;
		}

		/**
		 * Разница между двумя юлианскими датами в ГОДАХ
		 * @param jd1
		 * @param jd2
		 * @return
		 */
		static public function diffYears( jd1:Number, jd2:Number ):Number
		{
			return ( jd2 - jd1 ) / DAYS_PER_YEAR;
		}
	}

}