/**
 * Created by aa on 23.05.2014.
 */
package ru.arslanov.core.utils
{
	import flash.geom.ColorTransform;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ColorUtils
	{
		static public function toAlphaColor( alpha:Number,  color:uint ):Number
		{
			trace( alpha + " = " + Number(0.5 * 255).toString(16) );
			trace( "0xff000000 = " + 0xff000000);

			return (alpha * 0xff000000) + 0xff0000;
		}

		public static function rgbToHex( red:int, green:int, blue:int):uint
		{
			red = Math.max(-255, Math.min( red, 255));
			green = Math.max(-255, Math.min( green, 255));
			blue = Math.max(-255, Math.min( blue, 255));
			return red << 16 | green << 8 | blue;
		}

		public static function hexToRgb( hexColor:uint):Object
		{
			return { red:hexColor >> 16, green:hexColor >> 8 & 0xFF, blue:hexColor & 0xFF };
		}
	}
}
