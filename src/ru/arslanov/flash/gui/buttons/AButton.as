package ru.arslanov.flash.gui.buttons {
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.interfaces.IKillable;
	import ru.arslanov.flash.text.ATextField;
	
	/**
	 * Базовая кнопка
	 * @author Artem Arslanov
	 */
	public class AButton extends ASprite {
		
		public var onOver:Function;
		public var onPress:Function;
		public var onRelease:Function;
		public var onOut:Function;
		
		public var skinUp:IKillable;
		public var skinOver:IKillable;
		public var skinDown:IKillable;
		public var label:IKillable;
		
		private var _eventType:String = null;
		private var _isOver:Boolean = false;
		private var _body:ASprite;
		private var _curSkin:IKillable;
		
		public function AButton( skinUp:IKillable = null, skinOver:IKillable = null, skinDown:IKillable = null, label:IKillable = null ) {
			this.skinUp = skinUp;
			this.skinOver = skinOver;
			this.skinDown = skinDown;
			this.label = label;
			
			super();
		}
		
		override public function init():* {
			super.init();
			
			setupSkinsCustom();
			
			if ( !skinUp && !skinOver && !skinDown && !label ) {
			//if ( !skinUp && !skinOver && !label ) {
				setupSkinsDefault();
			}
			
			_body = new ASprite().init();
			addChild( _body );
			
			if ( label ) addChild( label as DisplayObject );
			
			eventManager.addEventListener( MouseEvent.MOUSE_OVER, 	handlerMouse );
			eventManager.addEventListener( MouseEvent.MOUSE_OUT, 	handlerMouse );
			eventManager.addEventListener( MouseEvent.MOUSE_DOWN, 	handlerMouse );
			//eventManager.addEventListener( MouseEvent.MOUSE_UP, 	handlerUp );
			//eventManager.addEventListener( MouseEvent.CLICK, 		handlerMouse );
			
			mouseChildren = false;
			enabled = true;
			buttonMode = true;
			
			_curSkin = getSkinUp();
			
			updateState();
			
			return this;
		}
		
		public function setupSkinsCustom():void {
			// override me
		}
		
		protected function handlerMouse( ev:MouseEvent ):void {
			//Log.traceText( "*execute* AButton.handlerMouse" );
			switch ( ev.type ) {
				case MouseEvent.MOUSE_DOWN:
					eventManager.addEventListener( MouseEvent.MOUSE_UP, handlerMouse );
				break;
				case MouseEvent.MOUSE_UP:
				//case MouseEvent.CLICK:
					eventManager.removeEventListener( MouseEvent.MOUSE_UP, handlerMouse );
				break;
				case MouseEvent.MOUSE_OVER:
					_isOver = true;
					//eventManager.addEventListener( MouseEvent.MOUSE_OUT, 	handlerMouse );
					//eventManager.addEventListener( MouseEvent.CLICK, handlerMouse );
				break;
				case MouseEvent.MOUSE_OUT:
					_isOver = false;
					//eventManager.removeEventListener( MouseEvent.MOUSE_OUT, 	handlerMouse );
					//eventManager.removeEventListener( MouseEvent.CLICK, handlerMouse );
				break;
				default:
			}
			
			setState( ev.type );
			callHandlers( ev.type );
		}
		
		public function setState( eventType:String, forced:Boolean = false ):void {
			if ( ( eventType == _eventType ) && !forced ) return;
			
			if ( _curSkin ) _body.removeChild( _curSkin as DisplayObject );
			
			switch ( eventType ) {
				case MouseEvent.MOUSE_OVER:
					if ( getSkinOver() ) _curSkin = getSkinOver();
				break;
				case MouseEvent.MOUSE_OUT:
					_curSkin = getSkinUp();
				break;
				case MouseEvent.MOUSE_DOWN:
					if ( getSkinOver() ) _curSkin = getSkinOver();
					if ( getSkinDown() ) _curSkin = getSkinDown();
				break;
				default:
					_curSkin = _isOver ? ( getSkinOver() ? getSkinOver() : getSkinUp() ) : getSkinUp();
			}
			
			_eventType = eventType;
			
			updateState();
		}
		
		protected function updateState():void {
			_body.addChild( _curSkin as DisplayObject );
			updateLabelPosition( _eventType );
		}
		
		protected function getSkinOver():IKillable {
			return skinOver;
		}
		
		protected function getSkinDown():IKillable {
			return skinDown;
		}
		
		protected function getSkinUp():IKillable {
			return skinUp;
		}
		
		private function callHandlers( eventType:String ):void {
			switch ( eventType ) {
				case MouseEvent.MOUSE_OVER:
					if ( onOver != null ) {
						if ( onOver.length == 1 ) {
							onOver( this );
						} else {
							onOver();
						}
					}
				break;
				case MouseEvent.MOUSE_OUT:
					if ( onOut != null ) {
						if ( onOut.length == 1 ) {
							onOut( this );
						} else {
							onOut();
						}
					}
				break;
				case MouseEvent.MOUSE_DOWN:
					if ( onPress != null ) {
						if ( onPress.length == 1 ) {
							onPress( this );
						} else {
							onPress();
						}
					}
				break;
				case MouseEvent.MOUSE_UP:
				//case MouseEvent.CLICK:
					if ( onRelease != null ) {
						if ( onRelease.length == 1 ) {
							onRelease( this );
						} else {
							onRelease();
						}
					}
				break;
				default:
			}
		}
		
		public function get enabled():Boolean {
			return mouseEnabled;
		}
		
		public function set enabled( value:Boolean ):void {
			if ( value == mouseEnabled ) return;
			
			buttonMode = value;
			mouseEnabled = value;
		}
		
		override public function set width( value:Number ):void {
			if ( getSkinOver() ) getSkinOver().width = value;
			if ( getSkinDown() ) getSkinDown().width = value;
			if ( getSkinUp() ) getSkinUp().width = value;
			
			updateLabelPosition( _eventType );
		}
		
		override public function set height( value:Number ):void {
			if ( getSkinOver() ) getSkinOver().height = value;
			if ( getSkinDown() ) getSkinDown().height = value;
			if ( getSkinUp() ) getSkinUp().height = value;
			
			updateLabelPosition( _eventType );
		}
		
		/**
		 * Обновление позиционирования бирки
		 * @param	offsetX
		 * @param	offsetY
		 */
		protected function updateLabelPosition( eventType:String, offsetX:Number = 0, offsetY:Number = 0 ):void {
			if ( !label ) return;
			
			label.x = Math.round(( _body.width - label.width ) / 2 + offsetX);
			label.y = Math.round(( _body.height - label.height ) / 2 + offsetY);
			
			// override me
		}
		
		public function forceCallHandler( type:String ):void {
			callHandlers( type );
		}
		
		public function forceDispatchEvent( type:String ):void {
			eventManager.dispatchEvent( new MouseEvent( type ) );
		}
		
		protected function setupSkinsDefault():void {
			skinUp = ABitmap.fromColor( 0x8BA86C, 100, 30 ).init();
			skinOver = ABitmap.fromColor( 0xB8C451, 100, 30 ).init();
			skinDown = ABitmap.fromColor( 0x9AA538, 100, 30 ).init();
			label = new ATextField( "AButton" ).init();
		}
		
		override public function kill():void {
			onOver = null;
			onOut = null;
			onPress = null;
			onRelease = null;
			
			super.kill();
		}
		
	}

}
