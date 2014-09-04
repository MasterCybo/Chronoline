package ru.arslanov.flash.text {
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class TextSprite extends ASprite {
		
		private var _tf:ATextField;
		private var _text:*;
		private var _format:TextFormat;
		
		public function TextSprite( text:* = "", format:TextFormat = null ) {
			_text = text;
			_format = format;
			
			super();
		}
		
		/**
		 * Метод инициализации экземпляра. Вызывать перед добавлением на stage
		 * @return ссылка на себя
		 */
		override public function init():* {
			_tf = new ATextField( _text, _format ).init();
			addChild( _tf );
			
			return super.init();
		}
		
		public function get textField():ATextField {
			return _tf;
		}
		
		/**
		 * Убивает экземпляр
		 */
		override public function kill():void {
			super.kill();
			
			_tf = null;
		}
		
		override public function toString():String {
			return super.toString() + ", " + _tf.toString();
		}
		
		override public function toStringGeometry():String {
			return super.toStringGeometry();
		}
	}

}