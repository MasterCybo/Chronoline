package  {
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class Settings {
		
		// Настройки
		//=======================================================================================================
		static public const URL_ICONS:String = "images/";
		static public const GUI_COLOR:uint = 0xDDDDDD;
		static public const SIDEBAR_COLOR:uint = 0xDDDDDD;// 0xB7B7B7;
		public static const LEGEND_MIN_SIZE:Number = 32;
		
		// Настройки ГЛАВНОЙ временной шкалы
		//=======================================================================================================
		static public const TL_BODY_WIDTH:uint = 40;
		static public const TL_BODY_COLOR:uint = 0x5686a1;// 0xd3c6a5;
		static public const TL_DASH_WIDTH_MAJOR:uint = 10;
		static public const TL_DASH_WIDTH_MINOR:uint = 20;
		static public const TL_DASH_COLOR:uint = 0x000000;// 0x817963; // 0x683C17
		static public const TL_DATE_MARGIN:uint = 50; // Запас верхний и нижний в годах
		static public const TL_DATE_STEP:Number = 0.1; // Шаг делений, в % от временного диапазона
		
		// Настройки ПОЛЗУНКА
		//=======================================================================================================
		static public const THUMB_BODY_CLR:uint = 0x78a3c3;// 0xd3c6a5;
		static public const THUMB_MIN_HEIGHT:int = 1;
		
		// Настройки ВСПОМОГАТЕЛЬНОЙ временной шкалы
		//=======================================================================================================
		static public const TR_BODY_WIDTH:uint = 40;
		static public const TR_BODY_COLOR:uint = 0x9ABFE5;// 0xf2eee3; // 0xf2eee3
		static public const TR_DASH_WIDTH_MAJOR:uint = 7;
		static public const TR_DASH_WIDTH_MINOR:uint = 15;
		static public const TR_DASH_COLOR:uint = 0x000000;// 0x817963; // 0x683C17
		static public const TR_DIVIDE:uint = 10; // Количество делений
		
		// Настройки рабочего стола
		//=======================================================================================================
		static public const DESK_OFFSET:uint = 0; // Отступ от вспомогательной временной шкалы
		static public const DESK_CLR_BG:uint = 0xffffff;
		static public const DESK_CLR_LINES:uint = 0xDBDBDB;
		
		// Настройки СУЩНОСТЕЙ
		//=======================================================================================================
		static public const ENT_SPACE:uint = 70;// 100;
		static public const ENT_WIDTH:uint = 20; // Ширина
		static public const ENT_CLR_BODY:uint = 0xBCD948;//0X88AC0D; // Цвет тела сущности
		static public const ENT_CLR_SPAN:uint = 0xDFED94; // Цвет неточной границы сущности
		static public const ENT_CLR_BG_TITLE:uint = 0xE4E4E4; // Цвет бирки сущности
		static public const ENT_ARROW_HEIGHT:uint = 10; // Размер стрелки начала и конца сущности
		
		// Настройки СОБЫТИЙ (Фактов)
		//=======================================================================================================
		static public const FACT_CLR:uint = 0x000000;// 0x444444;// 0X283302;// 0X4A5F05;// 0XCEF253;// 0x0;// 0xB0DF11;
		static public const FACT_CLR_OVER:uint = 0xFF0080;//0XFFFF00;
		static public const FACT_LINE_THIK_NORMAL:uint = 1;
		static public const FACT_LINE_THIK_OVER:uint = 5;
		static public const FACT_LINE_ALPHA:Number = 0.75;
		static public const MIN_RANK:uint = 30;
		static public const MAX_RANK:uint = 100;
		static public const ICON_OFFSET:uint = 4; // Смещение иконок в закрытом состоянии (на сколько иконка выглядывает из-за предыдущей)
		static public const ICON_SPACE:uint = 1; // Расстояние между иконками в раскрытом состоянии
		static public const ICON_SIZE:uint = 30; // px - Размер иконки по-умолчанию (родной размер - 60 px)
		static public const DELAY_CLOSE:uint = 100; // Пауза перед закрытием группы иконок
		static public const TAIL_LENGTH:uint = 10; // Длина выносной линии иконки
		
		// Настройки СВЯЗЕЙ
		//=======================================================================================================
		static public const BOND_MARK_COLOR:uint = 0xAEAEAE;// 0x0;// 0xB0DF11;
		//static public const BOND_MARK_BORDER:uint = 0X566C09;
		static public const BOND_THICKNESS:uint = 2; // Толщина линии связи
		static public const BOND_ROOT_WIDTH:uint = 15; // Ширина корня связи
		static public const BOND_ALPHA:Number = 0.65; //
		
		// Всплывающие подсказки
		//=======================================================================================================
		static public const HINT_WIDTH:uint = 250;
		
		// Выезжающая панель настроек
		//=======================================================================================================
		static public const SBAR_WIDTH:uint = 500;
		static public const SBAR_LABEL_WIDTH:uint = 30;
		static public const SBAR_LABEL_HEIGHT:uint = 30;
		
		// Верхняя панель с кнопками
		//=======================================================================================================
		static public const TOOLBAR_HEIGHT:uint = 40;
		
		// Навигационная панель
		//=======================================================================================================
		static public const NAVBAR_WIDTH:uint = 46;

		// Масштабная сетка
		//=======================================================================================================
		public static const GRID_TEXT_COLOR:uint = 0x9F9F9F;
		public static const GRID_LINE_COLOR:uint = 0x9F9F9F;

		// Метка базовой даты
		//=======================================================================================================
		public static const BASE_BACKGROUND_COLOR:uint = 0xFFFFFF;
		public static const BASE_TEXT_COLOR:uint = 0xFF8000;
		public static const BASE_LINE_COLOR:uint = 0xFF8000;

		// Миникарта с прокруткой
		//=======================================================================================================
		public static const MIN_MAP_SIZE_ENTITY:Number = 2; // Минимальный размер сущности на миникарте
		public static const MIN_MAP_COLOR_ENT:Number = 0x000000; // Цвет сущности на миникарте

	}

}
