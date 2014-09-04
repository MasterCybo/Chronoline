package ru.arslanov.core.collection
{
	import com.adobe.utils.DictionaryUtil;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public dynamic class ADictionary extends Dictionary
	{
		public function ADictionary( weakKeys:Boolean = false )
		{
			super( weakKeys );
		}
		
		public function getLength():uint {
			var num:uint;
			for each (var item:* in this) { num++; }
			return num;
		}
		
		public function getValues():Array {
			return DictionaryUtil.getValues( this );
		}
		
		public function getKeys():Array {
			return DictionaryUtil.getKeys( this );
		}
	}

}