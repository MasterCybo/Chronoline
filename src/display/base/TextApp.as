package display.base {
	import flash.text.TextFormat;

	import ru.arslanov.flash.text.ATextField;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class TextApp extends ATextField {
		
		public function TextApp( text:* = "", format:TextFormat = null ) {
			super( text, format );
		}
		
	}

}