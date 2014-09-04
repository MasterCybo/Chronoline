package ru.arslanov.flash.gui {
	import flash.utils.getQualifiedClassName;

	import ru.arslanov.flash.display.ASprite;

	/**
	 * Базовый класс элемента интерфейса
	 * @author Artem Arslanov
	 */
	public class UIWidget extends ASprite {
		
		public function UIWidget( name:String = null ) {
			super();
			this.name = name ? name : "ui_widget_" + uid;
		}

		/**
		 * Получение экземпляра элмента по его имени.
		 * Сквозной поиск по всем вложенным элементам.
		 * @param name
		 * @return
		 */
		public function retrieveWidget( name:String ):UIWidget
		{
			var widget:UIWidget = getChildByName( name ) as UIWidget;

			if ( !widget ) {
				var idx:uint = numChildren;
				var child:UIWidget;
				while( idx-- ) {
					child = getChildAt(idx) as UIWidget;
					if ( child ) {
						widget = child.retrieveWidget(name);
						if ( widget ) break;
					}
				}
			}

			return widget;
		}

		override public function toString():String
		{
			return "[" + getClassName() + " " + uidStr + " '" + name + "']";
		}

		override public function kill():void {
			super.kill();
		}
	}

}