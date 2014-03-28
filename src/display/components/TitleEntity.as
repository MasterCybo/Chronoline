package display.components {
	import constants.TextFormats;
	import display.base.TextApp;
	import flash.text.TextFieldAutoSize;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class TitleEntity extends ASprite {
		private var _title:String;
		
		public function TitleEntity( title:String ) {
			_title = title;
			
			super();
		}
		
		override public function init():*{
			var tf:TextApp = new TextApp( _title, TextFormats.TITLE_ENTITY ).init();
			tf.x = 0;// 15;
			tf.y = 0;// 5;
			tf.autoSize = TextFieldAutoSize.LEFT;
			
			var bg:ABitmap = ABitmap.fromColor( Settings.ENT_CLR_BG_TITLE, tf.width + 2 * tf.x, tf.height + 2 * tf.y ).init();
			
			addChild( bg );
			addChild( tf );
			
			return super.init();
		}
	}

}
