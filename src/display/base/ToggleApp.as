package display.base {
	import ru.arslanov.flash.gui.buttons.AToggle;
	import ru.arslanov.flash.interfaces.IKillable;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ToggleApp extends AToggle {
		
		public function ToggleApp( skinUp:IKillable=null, skinOver:IKillable=null, skinDown:IKillable=null, skinDownOver:IKillable=null, label:IKillable=null ) {
			super( skinUp, skinOver, skinDown, skinDownOver, label );
		}
		
	}

}
