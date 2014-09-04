package ru.arslanov.core.utils
{
	import com.adobe.utils.DictionaryUtil;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DictUtils
	{
		static private var _fieldName:String;
		static private var _unequal:Boolean;
		static private var _value:*;
		
		/**
		 * Фильтрация
		 * @param	dictionary
		 * @param	fieldName
		 * @param	value
		 * @param	unequal
		 * @return
		 */
		static public function filterByField( dictionary:Dictionary, fieldName:String, value:*, unequal:Boolean = false ):Array
		{
			_fieldName = fieldName;
			_value = value;
			_unequal = unequal;
			
			var arr:Array = DictionaryUtil.getValues( dictionary ).filter( equalByField );
			
			_fieldName = null;
			_value = null;
			
			return arr;
		}
		
		static private function equalByField( item:*, index:int, array:Array ):Boolean {
			return _unequal ? item[_fieldName] != _value : item[_fieldName] == _value;
		}
		
		static public function filterByValue( dictionary:Dictionary, value:*, unequal:Boolean = false ):Array
		{
			_value = value;
			_unequal = unequal;
			
			var arr:Array = DictionaryUtil.getValues( dictionary ).filter( equalByValue );
			
			_value = null;
			
			return arr;
		}
		
		static private function equalByValue( item:*, index:int, array:Array ):Boolean {
			return _unequal ? item != _value : item == _value;
		}
		
		static public function filter( dictionary:Dictionary, callback:Function, thisObject:* = null ):Array
		{
			return DictionaryUtil.getValues( dictionary ).filter( callback, thisObject );
		}
		
	}

}