/**
 * Copyright (c) 2014 SmartHead. All rights reserved.
 */
package display.gui
{
	import data.MoEntity;

	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.core.utils.Log;

	import ru.arslanov.flash.gui.hints.ATooltip;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class EntityTooltip extends ATooltip
	{
		public function EntityTooltip( data:MoEntity )
		{
			super( data );
		}

		public function get moEntity():MoEntity { return _data as MoEntity; }

		override public function init():*
		{
			var beginJD:Number = moEntity.beginPeriod.beginJD;
			var endJD:Number = moEntity.endPeriod.endJD;

			var beginDate:Object = JDUtils.JDToGregorian(beginJD);
			var endDate:Object = JDUtils.JDToGregorian(endJD);

			var beginDateLocale:String = beginDate.date + " " + JDUtils.getNameMonth(beginDate.month) + " " + beginDate.year;
			var endDateLocale:String = endDate.date + " " + JDUtils.getNameMonth(endDate.month) + " " + endDate.year;
			Log.traceText(beginDateLocale + " - " + endDateLocale);

			return this;
		}
	}
}
