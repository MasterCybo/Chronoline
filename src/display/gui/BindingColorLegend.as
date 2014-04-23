package display.gui {

	import constants.BindingColor;

	import flash.events.Event;

	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class BindingColorLegend extends ASprite {
		
		public function BindingColorLegend() {
			super();
			
		}
		
		override protected function init( ev:Event ):void {
			super.init( ev );
			
			var title:Text = new Text( "Цветовые обозначения связей" );
			title.wordWrap = false;
			addChild( title );
			
			var box1:ASprite = createItem( BindingColor.FORMAL, "Формальные связи" );
			addChild( box1 );
			box1.y = title.height + 2;
			var box2:ASprite = createItem( BindingColor.KINSHIP, "Родственные связи" );
			addChild( box2 );
			box2.y = box1.y + box1.height + 2;
			var box3:ASprite = createItem( BindingColor.PERSONAL, "Личные связи" );
			addChild( box3 );
			box3.y = box2.y + box2.height + 2;
		}
		
		private function createItem( color:Number, label:String ):ASprite {
			var box:ASprite = new ASprite();
			
			var rect:ASprite = new ASprite();
			rect.graphics.beginFill( color );
			rect.graphics.drawRect( 0, 0, 20, 10 );
			rect.graphics.endFill();
			
			box.addChild( rect );
			
			var text:Text = new Text( label, 10 );
			text.wordWrap = false;
			box.addChild( text );
			
			text.x = rect.width + 5;
			text.y = int(( rect.height - text.height ) / 2);
			
			return box;
		}
	}

}