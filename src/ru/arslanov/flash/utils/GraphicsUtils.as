package ru.arslanov.flash.utils {
	import flash.display.Graphics;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class GraphicsUtils {
		
		public function GraphicsUtils() {
		
		}
		
		static public function drawDash( target:Graphics, x1:Number, y1:Number, x2:Number, y2:Number, dashLength:Number = 5, spaceLength:Number = 5 ):void {
			var x:Number = x2 - x1;
			var y:Number = y2 - y1;
			var hyp:Number = Math.sqrt(( x ) * ( x ) + ( y ) * ( y ) );
			var units:Number = hyp / ( dashLength + spaceLength );
			var dashSpaceRatio:Number = dashLength / ( dashLength + spaceLength );
			var dashX:Number = ( x / units ) * dashSpaceRatio;
			var spaceX:Number = ( x / units ) - dashX;
			var dashY:Number = ( y / units ) * dashSpaceRatio;
			var spaceY:Number = ( y / units ) - dashY;
			
			target.moveTo( x1, y1 );
			while ( hyp > 0 ) {
				x1 += dashX;
				y1 += dashY;
				hyp -= dashLength;
				if ( hyp < 0 ) {
					x1 = x2;
					y1 = y2;
				}
				target.lineTo( x1, y1 );
				x1 += spaceX;
				y1 += spaceY;
				target.moveTo( x1, y1 );
				hyp -= spaceLength;
			}
			target.moveTo( x2, y2 );
		}
	}

}