package events {
	import ru.arslanov.core.events.ANotice;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class BondDisplayNotice extends ANotice {
		
		static public const NAME:String = "bondDisplayNotice";
		
		public var factID:String;
		
		public function BondDisplayNotice( factID:String ) {
			this.factID = factID;
			
			super();
		}
		
	}

}