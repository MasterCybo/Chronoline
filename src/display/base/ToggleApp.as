package display.base {
	import flash.events.MouseEvent;

	import ru.arslanov.flash.gui.buttons.AToggle;
	import ru.arslanov.flash.gui.hints.ATooltipManager;
	import ru.arslanov.flash.interfaces.IKillable;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ToggleApp extends AToggle {
		public var textTootip:String = "";
		public var textTootipChecked:String = "";

		private var _ttm:ATooltipManager;

		public function ToggleApp( skinUp:IKillable=null, skinOver:IKillable=null, skinDown:IKillable=null, skinDownOver:IKillable=null, label:IKillable=null ) {
			super( skinUp, skinOver, skinDown, skinDownOver, label );
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

			if ( !checked ) {
				if ( textTootip && ( textTootip != "" ) ) {
					switch ( true ) {
						case ev.type == MouseEvent.MOUSE_OVER :
							_ttm.displayHint( TooltipApp, { text:textTootip } );
							break;
						default :
							_ttm.removeHint();
					}
				}
			} else {
				if ( textTootipChecked && ( textTootipChecked != "" ) ) {
					switch ( true ) {
						case ev.type == MouseEvent.MOUSE_OVER :
							_ttm.displayHint( TooltipApp, { text:textTootipChecked } );
							break;
						default :
							_ttm.removeHint();
					}
				}
			}


			super.handlerMouse( ev );
		}
	}

}
