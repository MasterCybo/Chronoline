package constants {
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class LocaleString {
		
		static public const SEARCH_HELP:String = "Поиск...";
		static public const SELECTED_ITEMS:String = "Выбрано {0} из {1}";
		static public const TITLE_ORIGIN:String = "Доступно:";
		static public const TITLE_TARGET:String = "Выбрано:";
		static public const TITLE_PRESETS:String = "Наборы:";
		static public const DATE_FORMAT:String = "{0} {1} {2} г."; // 24 марта 2005 г.
		static public const DATE_TEMPLATE_SHORT:String = "{2} {1} {0}"; // 24 марта 2005
		static public const DATE_TEMPLATE_FULL:String = "{0} {1} {2} ({4}:{5})"; // 24 марта 2005 (18:32)
		static public const DATE_YYYY_MONTH_DD:String = "{0} {1} {2}"; // 2005 март 24
		static public const DATE_YYYY:String = "{0} г."; // 2005 г.
		static public const DATE_FULL_FORMAT:String = "{0} {1} {2} г. {4}:{5}"; // {0}-год, {1}-мес, {2}-ч, {3}-нед, {4}-час, {5}-мин
		static public const DATE_ENTITY_HINT:String = "{2} {1} {0} г. {4}:{5}"; // 24 марта 2005 г. 18:32:47
		static public const WAITING_PROCESS:String = "Пожалуйста, подождите...";
		static public const SERVER_ERROR_RESPONSE:String = "Ошибка: Сервер не ответил на запрос.";
		static public const MONTHS:Array = ["Январь","Февраль","Март","Апрель","Май","Июнь","Июль","Август","Сентябрь","Октябрь","Ноябрь","Декабрь"];
		static public const MONTHS_GENITIVE:Array = ["Января","Февраля","Марта","Апреля","Мая","Июня","Июля","Августа","Сентября","Октября","Ноября","Декабря"];
		public static const HELP_NAME_PRESET:String = "Введите название набора...";

		//{ region КНОПКИ
		static public const DISPLAY_SELECTED:String = "Показать";
		static public const SAVE_PRESET:String = "Сохранить набор";
		static public const CANCEL:String = "Отменить";
		static public const SCREENSHOT:String = "Снимок экрана";
		static public const PRESET_SAVE:String = "Сохранить набор";
		static public const BACK_MAIN_PAGE:String = "На главную";
		static public const LEGEND:String = "Легенда";
		static public const WAITING:String = "Подождите пожалуйста...";
		static public const HELPER:String = "Помощник";
		static public const NEXT:String = "Продолжить";
		static public const TOOLTIP_MORE:String = "Подробнее...";
		//} endregion
	}

}
