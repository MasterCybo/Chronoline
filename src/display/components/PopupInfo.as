package display.components {
	import data.MoFact;
	import display.base.TextApp;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import ru.arslanov.flash.display.AShape;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class PopupInfo extends ASprite {
		
		public var moFact:MoFact;
		
		private var _tf:TextApp;
		
		public function PopupInfo( moFact:MoFact ) {
			this.moFact = moFact;
			super();
		}
		
		override public function init():* {
			super.init();
			
			var text:String = moFact.period.string + "\n" + moFact.title;
			
			_tf = new TextApp( text ? text : "" ).init();
			_tf.setBorder( true, Settings.FACT_CLR );
			_tf.setBackground( true, 0xFFFFA8 );
			_tf.setWidth( Settings.HINT_WIDTH );
			
			while ( _tf.height > Settings.HINT_WIDTH ) {
				_tf.setWidth( _tf.width * 1.5 );
			}
			
			var tail:AShape = new AShape().init();
			tail.graphics.lineStyle( 1, Settings.FACT_CLR );
			tail.graphics.lineTo( 40, 30 );
			
			_tf.x = tail.width - 2;
			_tf.y = tail.height - 2;
			
			addChild( tail );
			addChild( _tf );
			
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