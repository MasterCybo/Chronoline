package ru.arslanov.flash.gui.buttons {
	import flash.events.MouseEvent;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.text.ATextField;
	import ru.arslanov.flash.interfaces.IKillable;
	
	/**
	 * Базовый класс кнопки-переключателя
	 * @author Artem Arslanov
	 */
	public class AToggle extends AButton {
		
		public var skinDownOver:IKillable;
		
		private var _over:IKillable;
		private var _isChecked:Boolean = false;
		
		public function AToggle( skinUp:IKillable = null, skinOver:IKillable = null, skinDown:IKillable = null, skinDownOver:IKillable = null, label:IKillable = null ) {
			this.skinDownOver = skinDownOver;
			super( skinUp, skinOver, skinDown, label );
		}
		
		override protected function handlerMouse( ev:MouseEvent ):void {
			if ( ev.type == MouseEvent.MOUSE_UP ) {
				_isChecked = !_isChecked;
			}
			super.handlerMouse( ev );
		}
		
		override protected function getSkinOver():IKillable {
			return _isChecked ? ( skinDownOver ? skinDownOver : super.getSkinOver() ) : super.getSkinOver();
		}
		
		override protected function getSkinUp():IKillable {
			return _isChecked ? ( super.getSkinDown() ? super.getSkinDown() : super.getSkinUp() ) : super.getSkinUp();
		}
		
		public function get checked():Boolean {
			return _isChecked;
		}
		
		public function set checked( value:Boolean ):void {
			//Log.traceText( "value : " + value );
			if ( value == _isChecked ) return;
			
			_isChecked = value;
			
			super.setState( MouseEvent.MOUSE_UP, true );
		}
		
		override public function set width( value:Number ):void {
			if ( skinDownOver ) skinDownOver.width = value;
			super.width = value;
		}
		
		override public function set height( value:Number ):void {
			if ( skinDownOver ) skinDownOver.height = value;
			super.height = value;
		}
		
		override protected function setupSkinsDefault():void {
			super.skinUp = ABitmap.fromColor( 0XC0C0C0, 100, 30 ).init();
			super.skinDown = ABitmap.fromColor( 0X63BE1F, 100, 30 ).init();
			super.label = new ATextField( "AToggle" );
			
			skinDownOver = ABitmap.fromColor( 0X9DE767, 100, 30 ).init();
		}
	}

}