package {
	import flash.display.Sprite;
	import flash.events.Event;

	import ru.arslanov.flash.interfaces.IKillable;

	/**
	 * ...
	 * @author Artem Arslanov
	 */

	[SWF(frameRate=60,width=800,height=600)]
	public class Main extends Sprite {
		
		public function Main():void {
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init( ev:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, init );
			
			( addChild( new App() ) as IKillable ).init();
		}
		
	}

}