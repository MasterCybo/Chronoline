package display.base {
	import flash.events.MouseEvent;

	import ru.arslanov.flash.gui.buttons.AButton;
	import ru.arslanov.flash.gui.hints.ATooltipManager;
	import ru.arslanov.flash.interfaces.IKillable;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ButtonApp extends AButton {

		public var textTootip:String = "";

		private var _ttm:ATooltipManager;

		public function ButtonApp( skinUp:IKillable=null, skinOver:IKillable=null, skinDown:IKillable=null, label:IKillable=null ) {
			super( skinUp, skinOver, skinDown, label );
		}

		override public function init():*
		{
			super.init();
			_ttm = ATooltipManager.me;
			return this;
		}

		override public function kill():void
		{
			super.kill();

			_ttm = null;
		}

		override protected function handlerMouse( ev:MouseEvent ):void
		{
//			trace("ev.type : " + ev.type);

			if ( textTootip && ( textTootip != "" ) ) {
				switch ( true ) {
					case ev.type == MouseEvent.MOUSE_OVER :
						_ttm.displayHint( TooltipApp, { text:textTootip } );
						break;
					default :
						_ttm.removeHint();
				}
			}

			super.handlerMouse( ev );
		}

	}

}