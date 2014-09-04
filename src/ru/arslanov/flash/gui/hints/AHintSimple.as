package ru.arslanov.flash.gui.hints {
	import flash.text.TextFormat;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.text.ATextField;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class AHintSimple extends ATooltip {
		
		private var _text:String;
		
		public function AHintSimple( data:* ) {
			_text = data;
			
			super();
		}
		
		override public function init():* {
			var tf:ATextField = new ATextField( _text, new TextFormat( "Arial" ) ).init();
			
			var body:ASprite = new ASprite().init();
			body.graphics.lineStyle( 1, 0x808080 );
			body.graphics.beginFill( 0xffffff );
			body.graphics.drawRect( 0, 0, tf.width + 10, tf.height + 10 );
			body.graphics.endFill();
			
			addChild( body );
			addChild( tf );
			
			return super.init();
		}
	}

}