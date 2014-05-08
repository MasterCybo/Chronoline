package constants {
	import flash.text.TextFormat;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class TextFormats {
		
		static public const DEFAULT:TextFormat = new TextFormat( "Verdana", 12, 0x0 );
		static public const VERSION:TextFormat = new TextFormat( "Arial", 11, 0xB6B6B6 );
		static public const INPUT_HELP:TextFormat = new TextFormat( "Verdana", 12, 0X8F8F8F );
		static public const LIST_HEADER:TextFormat = new TextFormat( "Verdana", 18, 0X868686 );
		static public const WHITE_20:TextFormat = new TextFormat( "Arial", 20, 0xffffff, false, null, null, null, null, "center" );
		
		/***************************************************************************
		Стили глобальной временной шкалы
		***************************************************************************/
		static public const TL_MAJOR_LABEL:TextFormat = new TextFormat( "Arial", 13, 0x46402f );
		
		/***************************************************************************
		Стили вспомогательной временной шкалы
		***************************************************************************/
		static public const TR_MAJOR_LABEL:TextFormat = new TextFormat( "Arial", 12, 0x474130 );
		
		/***************************************************************************
		Стили Интерфейса
		***************************************************************************/
		//static public const RANGE_EDIT:TextFormat = new TextFormat( "Arial", 30, 0x0, true );
		static public const RANGE_EDIT:TextFormat = new TextFormat( "Arial", 18, 0x0, true, null, null, null, null, "center" );
		
		/***************************************************************************
		Стили Сущностей
		***************************************************************************/
		static public const DATE_LABEL:TextFormat = new TextFormat( "Arial", 11, 0xffffff, false, null, null, null, null, "center" );
		static public const TITLE_ENTITY:TextFormat = new TextFormat( "Arial", 14, 0X6C6C6C, false, null, null, null, null, "left" );
	}

}
