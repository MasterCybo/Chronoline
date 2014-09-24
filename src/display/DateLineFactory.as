/**
 * Created by Artem on 21.07.2014.
 */
package display
{
	import constants.LocaleString;

	import display.components.DateLine;

	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DateLineFactory
	{
		public static const MODE_FULL_DATE:uint = 0;
		public static const MODE_ONLY_YEAR:uint = 1;
		public static const MODE_MONTH:uint = 2;

		private static var _pool:Array = [];
		
		static public function createDateMarker( jd:Number, width:uint, mode:uint = 0 ):ASprite
		{
			// TODO: реализовать изменение линии в зависимости от масштаба
//			return new DateLine( jd, width, LocaleString.DATE_YYYY_MONTH_DD, Settings.GRID_TEXT_COLOR, Settings.GRID_LINE_COLOR ).init();
			
			var marker:DateLine = _pool.pop();
			var template:String = LocaleString.DATE_YYYY_MONTH_DD;
			
			switch ( mode ) {
				case 1:
					template = LocaleString.DATE_YYYY;
					break;
				case 2:
					template = LocaleString.DATE_YYYY_MONTH;
					break;
				default:
					template = LocaleString.DATE_YYYY_MONTH_DD;
			}
			
//			if ( !marker ) {
				marker = new DateLine( jd, width, template, Settings.GRID_TEXT_COLOR, Settings.GRID_LINE_COLOR ).init();
//			} else {
//				marker.reinit( jd, width, template );
//			}
			
			return marker;
		}

		public static function removeDateMarker( dateMarker:DateLine ):void
		{
			_pool.push( dateMarker );
		}
	}
}
