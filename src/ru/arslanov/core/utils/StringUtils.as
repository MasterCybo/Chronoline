package ru.arslanov.core.utils
{

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class StringUtils
	{

		/**
		 * Преобразует число в строку с добавлением нулей до указанного разряда.
		 * Примеры: numberToString( 6, 2 ) = 06
		 *            numberToString( 6, 4 ) = 0006
		 * @param    value
		 * @param    digits
		 * @return
		 */
		static public function numberToString( value:Number, digits:uint = 2 ):String
		{
			var stop:Number = value == 0 ? 1 : value;
			var dec:Number = Math.pow( 10, digits - 1 );

			var zero:String = "";
			while ( stop < dec ) {
				zero += "0";
				dec /= 10;
			}
			;
			return zero + value;
		}

		/**
		 * Нормализует (чистит) текст.
		 * Удаляет лишние переносы строк и символ /\r
		 * @param    text
		 * @return
		 */
		static public function normalize( text:String ):String
		{
			return text.replace( /\\n/g, '\n' ).replace( /\r/g, "" );
		}

		/**
		 * Делает первую букву слова заглавной
		 * @param    string
		 * @return
		 */
		static public function capital( string:String ):String
		{
			return string.substr( 0, 1 ).toUpperCase() + string.substr( 1 ).toLowerCase();
		}

		/**
		 * Делает заглавной первую букву в каждом слове текста
		 * @param    string
		 * @return
		 */
		static public function capitalWords( string:String ):String
		{
			return string.split( " " ).map( capWord ).join( " " );
		}

		static private function capWord( item:*, index:int, array:Array ):String
		{
			return capital( item );
		}

		/**
		 * Замена значений {n} в тексте
		 * @param    str
		 * @param    ...rest
		 * @return
		 */
		static public function substitute( str:String, ...rest ):String
		{
			var len:uint = rest.length;
			var exp:RegExp;
			for ( var i:int = 0; i < len; i++ ) {
				exp = new RegExp( "\\{" + i + "}", "g" );
				str = str.replace( exp, rest[i] );
				//trace( exp );
				//trace( "str : " + str );
			}
			return str;
		}

		static public function repeat( text:String, count:uint ):String
		{
			var res:String = "";
			while ( count ) {
				res += text;
				count--;
			}

			return res;
		}

		/**
		 * Склонение числительных
		 * @param value - число
		 * @param titles - список числительных
		 * @return
		 * @example declensionOfNumber( N, ['арбуз','арбуза','арбузов'] );
		 * @output 1 арбуз, 2 арбуза, 12 арбузов
		 */
		static public function declensionOfNumber( value:Number, titles:Array ):String
		{
			var cases:Array = [2, 0, 1, 1, 1, 2];
			return titles[ ( value % 100 > 4 && value % 100 < 20) ? 2 : cases[(value % 10 < 5) ? value % 10 : 5] ];
		}

		static public function getArrayEmailes( text:String ):Array
		{
			//   /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/gim

			return text.match(
					new RegExp(
							"/[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
							"gim"
					)
			);
		}
	}

}
