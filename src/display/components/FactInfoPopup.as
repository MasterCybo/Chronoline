package display.components {
	import data.MoFact;

	import display.base.TextApp;

	import ru.arslanov.core.utils.JDUtils;

	import ru.arslanov.flash.display.AShape;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class FactInfoPopup extends ASprite {
		
		public var moFact:MoFact;
		
		public function FactInfoPopup( moFact:MoFact ) {
			this.moFact = moFact;
			super();
		}
		
		override public function init():* {
			super.init();
			
			var text:String = JDUtils.getFormatString( moFact.period.beginJD ) + " — " + JDUtils.getFormatString( moFact.period.endJD ) + "\n" + moFact.title;

			var tf:TextApp = new TextApp( text ? text : "" ).init();
			tf.setBorder( true, Settings.FACT_CLR );
			tf.setBackground( true, 0xFFFFA8 );
			tf.setWidth( Settings.HINT_WIDTH );
			
			while ( tf.height > Settings.HINT_WIDTH ) {
				tf.setWidth( tf.width * 1.5 );
			}
			
			var tail:AShape = new AShape().init();
			tail.graphics.lineStyle( 1, Settings.FACT_CLR );
			tail.graphics.lineTo( 40, 30 );
			
			tf.x = tail.width - 2;
			tf.y = tail.height - 2;
			
			addChild( tail );
			addChild( tf );
			
			mouseChildren = false;
			
			//filters = [ new DropShadowFilter( 3, 45, 0x0, 0.3, 4, 4 ) ];
			
			return this;
		}
		
		override public function kill():void {
			moFact = null;
			
			super.kill();
		}
	}

}