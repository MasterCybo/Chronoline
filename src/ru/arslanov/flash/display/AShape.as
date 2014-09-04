package ru.arslanov.flash.display {
	import flash.display.Shape;
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.flash.interfaces.IKillable;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class AShape extends Shape implements IKillable {
		
		static private var _counter:Number = 0;
		
		private var _isInited:Boolean;
		private var _isKilled:Boolean;
		private var _uid:Number;
		
		public function AShape() {
			_uid =++_counter;
			
			super();
		}
		
		/**
		 * Метод инициализации экземпляра. Вызывать перед добавлением на stage
		 * @return ссылка на себя
		 */
		public function init():* {
			_isInited = true;
			// override me
			return this;
		}
		
		public function get isInited():Boolean {
			return _isInited;
		}
		
		public function setXY( x:Number, y:Number, rounded:Boolean = true ):void {
			this.x = rounded ? Math.round( x ) : x;
			this.y = rounded ? Math.round( y ) : y;
		}
		
		public function setSize( width:Number, height:Number, rounded:Boolean = true ):void {
			this.width = rounded ? Math.round( width ) : width;
			this.height = rounded ? Math.round( height ) : height;
		}
		
		/**
		 * Убивает экземпляр
		 */
		public function kill():void {
			if ( _isKilled ) throw new Error( this + " ALREADY KILLED!" ).getStackTrace();
			
			if ( parent ) parent.removeChild( this );
			
			_isKilled = true;
			
			// override me
		}
		
		public function get isKilled():Boolean {
			return _isKilled;
		}
		
		/**
		 * Уникальный идентификатор
		 */
		public function get uid():Number {
			return _uid;
		}
		
		public function get uidStr():String {
			return "0x" + uid.toString( 16 ).toUpperCase();
		}
		
		override public function toString():String {
			return "[" + getQualifiedClassName( this ).split( ":" ).pop() + " " + uidStr + "]";
		}
	}

}
