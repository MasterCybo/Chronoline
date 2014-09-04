/**
 * Created by aa on 12.05.2014.
 */
package ru.arslanov.core.collection.list
{
	/**
	 * Элемента списка
	 * @author Artem Arslanov
	 */
	public class AListItem
	{

		public var sortIndex:Number = 0;
		public var data:Object = null;

		/**
		 * @param sortIndex - индекс сортировки
		 * @param data - пользовательский объект данных
		 */
		public function AListItem( sortIndex:Number = 0, data:Object = null )
		{
			this.sortIndex = sortIndex;
			this.data = data;
		}
	}
}
