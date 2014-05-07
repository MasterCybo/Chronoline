package events {
	import ru.arslanov.core.events.ANotice;

	/**
	* ...
	* @author Artem Arslanov
	*/
	public class SysMessageDisplayNotice extends ANotice {
		
		static public const NAME:String = "sysMessageDisplayNotice";
		
		public var message:String;
		public var handlerAfterClose:Function;
		
		public function SysMessageDisplayNotice( message:String, handlerAfterClose:Function = null ) {
			this.message = message;
			this.handlerAfterClose = handlerAfterClose;
			super();
			
		}
		
	}

}