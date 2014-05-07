package events {
	import ru.arslanov.core.events.ANotice;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class BondRemoveNotice extends ANotice {
		
		static public const NAME:String = "bondRemoveNotice";
		
		public var factID:String;
		
		public function BondRemoveNotice( factID:String ) {
			this.factID = factID;
			
			super();
		}
		
	}

}