/**
 * Copyright (c) 2014 SmartHead. All rights reserved.
 */
package ru.arslanov.core.utils
{
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DateUtils
	{
		static public var weekdaysLocale:Array = [ "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье" ];
		static public var monthsLocale:Array = [ "Января", "Февраля", "Марта", "Апреля", "Мая", "Июня", "Июля", "Августа", "Сентября", "Октября", "Ноября", "Декабря" ];

		static private var _daysInMonths:Array = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

		/**
		 * Проверка високосности Григорианского года
		 * Взято с стайта https://www.fourmilab.ch/documents/calendar/
		 * @param year
		 * @return Boolean
		 */
		static public function isLeapYear( year:int ):Boolean
		{
			return (( year % 4 ) == 0 ) && ( !((( year % 100 ) == 0 ) && (( year % 400 ) != 0 ) ) );
		}

		/**
		 * Возвращает количество дней в месяце в зависимости от високосности года
		 * @param year
		 * @param month - 1=январь
		 * @return
		 */
		static public function getDaysMonth( year:int, month:uint ):uint
		{
			month = Math.max( 1, month ) - 1;
			return isLeapYear( year ) && (month == 1/*февраль*/) ? _daysInMonths[month] + 1 : _daysInMonths[month];
		}

		/**
		 * Возвращает количество дней в году в зависимости от високосности года
		 * @param year
		 * @param month - 0=январь
		 * @return
		 */
		static public function getDaysYear( year:int ):uint
		{
			return isLeapYear( year ) ? 366 : 365;
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
		 * Количество дней между двумя датами
		 * @param date1
		 * @param date2
		 * @return
		 */
		static public function getDaysBetweenDates(date1:Date, date2:Date):int
		{
			var oneDay:Number = 1000 * 60 * 60 * 24;
			var date1Milliseconds:Number = date1.getTime();
			var date2Milliseconds:Number = date2.getTime();
			var differenceMilliseconds:Number = Math.abs(date1Milliseconds - date2Milliseconds);
			return Math.round(differenceMilliseconds/oneDay);
		}
	}
}
