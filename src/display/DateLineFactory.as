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

		private static var _isFill:Boolean = true;
		
		static public function createDateMarker( text:String, width:uint, height:uint, isFilled:Boolean = false ):ASprite
		{
//			var marker:DateLine = _pool.pop();

			
//			if ( !marker ) {
			var marker:DateLine = new DateLine( text, width, height, isFilled ? 0xF3F3F3 : Settings.DESK_CLR_BG, Settings.GRID_TEXT_COLOR ).init();
//			} else {
//				marker.reinit( jd, width, template );
//			}

			_isFill = !_isFill;
			
			return marker;
		}

		public static function removeDateMarker( dateMarker:DateLine ):void
		{
			_pool.push( dateMarker );
		}

		public static function getDateTemplate( markerMode:uint ):String
		{
			var template:String = LocaleString.DATE_YYYY_MONTH_DD;

			switch ( markerMode ) {
				case 1:
					template = LocaleString.DATE_YYYY;
					break;
				case 2:
					template = LocaleString.DATE_YYYY_MONTH;
					break;
				default:
					template = LocaleString.DATE_YYYY_MONTH_DD;
			}

			return template;
		}
	}
}
