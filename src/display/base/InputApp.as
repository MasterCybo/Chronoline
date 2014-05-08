package display.base {
	import flash.text.TextFormat;

	import ru.arslanov.flash.text.AInputField;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class InputApp extends AInputField {
		
		public function InputApp( text:* = "", format:TextFormat = null, width:uint = 100, height:int = -1 ) {
			super( text, width, height, format );
		
		}
	
	}

}