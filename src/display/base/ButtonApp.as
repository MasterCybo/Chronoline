package display.base {
	import ru.arslanov.flash.gui.buttons.AButton;
	import ru.arslanov.flash.interfaces.IKillable;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ButtonApp extends AButton {
		
		public function ButtonApp( skinUp:IKillable=null, skinOver:IKillable=null, skinDown:IKillable=null, label:IKillable=null ) {
			super( skinUp, skinOver, skinDown, label );
		}
		
	}

}