package ru.arslanov.core.utils {
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * @author Artem Arslanov
	 */
	public class Calc {
		
		static public const GOLDEN_RATIO:Number = 1.61803399;
		static public const PI:Number = 3.14159265; // 3.141592653589793
		static public const HPI:Number = PI * 0.5; // 1.570796325 = 90
		static public const TPI:Number = PI / 3; // 1.04719755119659774615 - third - треть = 60
		static public const QPI:Number = PI * 0.25; // 0.78539816339744830962 - quarter - четверть = 45
		
		static public function abs( value:Number ):Number {
			return value < 0 ? -value : value;
		}
		
		static public function roundTo( value:Number, precision:uint ):Number {
			var k:uint = Math.pow ( 10, precision );
			return Math.round ( value * k ) / k;
		}
		
		static public function round1( value:Number ):Number {
			return Math.round (value * 10) * 0.1;
		}
		
		static public function round2( value:Number ):Number {
			return Math.round (value * 100) * 0.01;
		}
		
		static public function round3 (value:Number):Number {
			return Math.round (value * 1000) * 0.001;
		}
		
		static public function floor1( value:Number ):Number {
			return Math.floor (value * 10) * 0.1;
		}
		
		static public function floor2( value:Number ):Number {
			return Math.floor (value * 100) * 0.01;
		}
		
		static public function floor3( value:Number ):Number {
			return Math.floor (value * 1000) * 0.001;
		}
		
		static public function toRad( degree:Number ):Number {
			return degree * PI / 180;
		}
		
		static public function toDeg ( radian:Number ):Number {
			return radian * 180 / PI;
		}
		
		static public function sign( value:Number ):int {
			return value < 0 ? -1 : 1;
		}
		
		static public function isNegative( value:Number ):Boolean {
			return value < 0;
		}
		
		static public function isPositive( value:Number ):Boolean {
			return value > 0;
		}
		
		static public function distance( x1:Number, y1:Number, x2:Number, y2:Number ):Number {
			return Math.sqrt (pow2 (x2 - x1) + pow2 (y2 - y1));
		}
		
		static public function distanceObjects( object1:Object, object2:Object ):Number {
			return Math.sqrt (pow2 (object2.x - object1.x) + pow2 (object2.y - object1.y));
		}
		
		static public function pow2( arg:Number, round:Boolean = false ):Number {
			return round ? Math.round( arg * arg ) : arg * arg;
		}
		
		/**
		 * Из полярных координат в координату X
		 * @param	angle
		 * @param	radius
		 * @return
		 */
		static public function polarToX( angle:Number, radius:Number ):Number {
			return radius * Math.sin ( toRad ( angle ) );
		}
		/**
		 * Из полярных координат в координату Y
		 * @param	angle
		 * @param	radius
		 * @return
		 */
		static public function polarToY( angle:Number, radius:Number ):Number {
			return radius * Math.cos ( toRad (angle) );
		}
		
		static public function polarPoint( angle:Number, radius:Number ):Point {
			return new Point( polarToX( angle, radius ), polarToY( angle, radius ) );
		}
		
		static public function getPercent( value:Number, base:Number ):Number {
			return value * 100 / base;
		}
		
		static public function getValue( percent:Number, base:Number ):Number {
			return percent * base * 0.01;
		}
		
		/**
		 * Ограничивает входное значение минимальным и максимальным значением
		 * @param	min
		 * @param	value
		 * @param	max
		 * @return
		 */
		static public function constrain( min:Number, value:Number, max:Number ):Number {
			return Math.min( Math.max ( min, value ), max );
		}
		
		static public function randomRange( from:Number, to:Number, round:Boolean = false ):Number {
			return round ? Math.round (from + Math.random () * (to - from)) : from + Math.random () * (to - from);
		}
		
		static public function randomFromArray( array:Array ):* {
			return array[ randomRange( 0, array.length, true ) ];
		}
		
		/**
		 * Проверяет, входит ли величина в диапазон, ограниченный значениями min и max
		 * @param	min
		 * @param	value
		 * @param	max
		 * @return
		 */
		static public function entry( min:Number, value:Number, max:Number ):Boolean {
			return (value > min) && (value < max);
		}
		
		/**
		 * Бросаем монетку
		 * @param	chance
		 * @return
		 */
		static public function throwCoin( chance:Number = 0.5 ):Boolean {
			if (chance > 1) throw new ArgumentError ("chance должен задаваться в пределах 0 - 1");
			
			return Math.random () <= chance;
		}
		
		/**
		 * Логарифм от числа value по основанию base
		 * @param	base
		 * @param	val
		 * @return
		 */
		static public function log( base:Number, val:Number ):Number {
			return Math.log( val ) / Math.log( base );
		}
		
		/**
		 * Логарифм двоичный от числа val
		 * @param	val
		 * @return
		 */
		static public function lg( val:Number ):Number {
			return log( 2, val );
		}

		/**
		 * Логарифм натуральный (по основанию E)
		 * @param	val
		 * @return
		 */
		static public function ln( val:Number ):Number {
			return log( Math.E, val );
		}
	}
}
