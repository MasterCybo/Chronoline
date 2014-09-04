package ru.arslanov.flash.display {
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.core.events.EventManager;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.interfaces.IKillableContainer;
	import ru.arslanov.flash.interfaces.IKillable;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ASprite extends Sprite implements IKillableContainer {
		
		static private var _counter:Number = 0;
		
		public var customData:Object; // Для хранения пользовательских данных. Зануляется в kill()
		
		private var _uid:Number = 0;
		private var _isKilled:Boolean;
		private var _isInited:Boolean;
		private var _eventManager:EventManager;
		
		public function ASprite() {
			_uid = ++_counter;
			
			super();
		}
		
		/**
		 * Метод инициализации экземпляра. Вызывать перед добавлением на stage
		 * @return ссылка на себя
		 */
		public function init():* {
			_isInited = true;
			mouseEnabled = false;
			// override me
			return this;
		}
		
		public function get isInited():Boolean {
			return _isInited;
		}
		
		/**
		 * Менеджер подписки событий.
		 * Все события, подписанные через EventManager автоматически отписываются при вызове метода kill()
		 */
		public function get eventManager():EventManager {
			if ( !_eventManager ) {
				_eventManager = new EventManager( this );
				mouseEnabled = true;
			}
			
			return _eventManager;
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
		 * Вызывыет метод kill у всех вложенных детей
		 * @param	startIdx
		 * @param	num
		 */
		public function killChildren( startIdx:uint = 0, num:int = -1 ):void {
			if ( numChildren == 0 ) return;
			
			var obj:IKillable;
			
			num = ( num == -1 ) ? numChildren : Math.min( num, numChildren - startIdx );
			startIdx = Math.min( startIdx, numChildren );
			
			while ( num > 0 ) {
				obj = getChildAt ( startIdx ) as IKillable;
				
				if ( obj ) {
					obj.kill();
					num --;
				}
			}
		}
		
		/**
		 * Убивает экземпляр
		 */
		public function kill():void {
			if ( _isKilled ) throw new Error( this + " ALREADY KILLED!" ).getStackTrace();
			
			if ( _eventManager ) _eventManager.dispose();
			_eventManager = null;
			
			killChildren();
			
			if ( parent ) parent.removeChild( this );
			
			customData = null;
			_isKilled = true;
			
			filters = null;
			
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

		public function getClassName():String
		{
			return getQualifiedClassName( this ).split( ":" ).pop();
		}
		
		override public function toString():String {
			return "[" + getClassName() + " " + uidStr + "]";
		}
		
		public function toStringGeometry():String {
			return toString() + " x:" + x + ", y:" + y + ", width:" + width + ", height:" + height;
		}
		
	}

}