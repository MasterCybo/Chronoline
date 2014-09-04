package ru.arslanov.flash.gui.hints {
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ATooltip extends ASprite {
		
		protected var _data:Object;
		
		public function ATooltip( data:Object = null ) {
			_data = data;
			super();
		}
		
		override public function init():* {
			mouseEnabled = mouseChildren = false;
			return super.init();
		}
		
		override public function kill():void {
			super.kill();
			
			_data = null;
		}
	}

}