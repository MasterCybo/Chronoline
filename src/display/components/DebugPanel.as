package display.components {
	import data.MoTimeline;
	import display.base.ButtonApp;
	import display.gui.buttons.ButtonText;
	import ru.arslanov.core.controllers.SimpleDragController;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.layout.HBox;
	
	/**
	* ...
	* @author Artem Arslanov
	*/
	public class DebugPanel extends ASprite {
		private var _dragCtrl:SimpleDragController;
		
		public function DebugPanel() {
			super();
			
		}
		
		override public function init():* {
			var bg:ASprite = new ASprite().init();
			bg.graphics.beginFill( 0xE0E0E0 );
			bg.graphics.drawRect( 0, 0, 100, 100 );
			bg.graphics.endFill();
			bg.mouseEnabled = true;
			addChild( bg );
			
			var hBox:HBox = new HBox( 5 ).init();
			addChild( hBox );
			
			var btnHalf:ButtonText = new ButtonText( "hf" ).init();
			btnHalf.onRelease = onClickHalf;
			
			var btnFull:ButtonText = new ButtonText( "fl" ).init();
			btnFull.onRelease = onClickFull;
			
			hBox.addChildAndUpdate( btnHalf );
			hBox.addChildAndUpdate( btnFull );
			
			hBox.setXY( ( bg.width - hBox.width ) / 2, ( bg.height - hBox.height ) / 2 );
			
			_dragCtrl = new SimpleDragController();
			_dragCtrl.init( this );
			
			return super.init();
		}
		
		private function onClickFull():void {
			var bjd:Number = MoTimeline.me.beginDate.jd;
			var ejd:Number = MoTimeline.me.endDate.jd;
			
			MoTimeline.me.setRange( bjd, ejd );
		}
		
		private function onClickHalf():void {
			var bjd:Number = MoTimeline.me.beginDate.jd;
			var ejd:Number = MoTimeline.me.endDate.jd;
			var dur:Number = MoTimeline.me.duration;
			
			//bjd = bjd + dur * 0.5;
			
			MoTimeline.me.setRange( bjd + dur * 0.5, ejd );
		}
	}

}