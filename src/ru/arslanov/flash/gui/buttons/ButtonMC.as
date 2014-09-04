package ru.arslanov.flash.gui.buttons {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import ru.arslanov.flash.display.AMovieClipContainer;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ButtonMC extends ASprite {
		
		public var onOver:Function;
		public var onOut:Function;
		public var onDown:Function;
		public var onUp:Function;
		public var onClick:Function;
		
		private var _state:String = null;
		private var _isOver:Boolean = false;
		private var _body:AMovieClipContainer;
		private var _skin:ButtonSkinBase;
		private var _enabled:Boolean;
		
		public function ButtonMC( skin:ButtonSkinBase ) {
			_skin = skin;
			
			super();
		}
		
		override public function init():* {
			if ( !skin.upState ) skin.init();
			
			_body = _skin.upState as AMovieClipContainer;
			addChild( _body );
			
			mouseChildren = false;
			
			enabled = true;
			
			//if ( skin.hitArea ) {
				//hitArea = skin.hitArea;
				//hitArea.mouseEnabled = false;
				//addChild( hitArea );
			//}
			
			setState( MouseEvent.MOUSE_UP );
			
			return super.init();
		}
		
		protected function handlerMouse( ev:MouseEvent ):void {
			setState( ev.type );
			callHandlers( ev.type );
			
			//ev.stopPropagation();
			//ev.stopImmediatePropagation();
		}
		
		public function setState( state:String, forced:Boolean = false ):void {
			//trace( "_state, state : " + _state, state );
			if ( (state == _state) && !forced ) return;
			
			//trace( "state : " + state );
			switch ( state ) {
				case MouseEvent.MOUSE_OVER:
					_isOver = true;
					_body.gotoAndPlay( "over" );
				break;
				case MouseEvent.MOUSE_OUT:
					_isOver = false;
					_body.gotoAndPlay( "normal" );
				break;
				case MouseEvent.MOUSE_DOWN:
					_body.gotoAndPlay( "press" );
				break;
				default:
					if ( _isOver ) {
						_body.gotoAndPlay( "over" );
					} else {
						_body.gotoAndPlay( "normal" );
					}
			}
			
			if ( skin.label && !contains( skin.label as DisplayObject ) ) {
				skin.label.mouseEnabled = false;
				addChild( skin.label as DisplayObject );
			}
			
			skin.updateLabelPosition();
			skin.updateHitAreaPosition();
			
			_state = state;
		}
		
		private function callHandlers( type:String ):void {
			switch ( type ) {
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
					if ( onDown != null ) {
						if ( onDown.length == 1 ) {
							onDown( this );
						} else {
							onDown();
						}
					}
				break;
				case MouseEvent.MOUSE_UP:
					if ( onUp != null ) {
						if ( onUp.length == 1 ) {
							onUp( this );
						} else {
							onUp();
						}
					}
				break;
				case MouseEvent.CLICK:
					if ( onClick != null ) {
						if ( onClick.length == 1 ) {
							onClick( this );
						} else {
							onClick();
						}
					}
				break;
				default:
			}
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		public function set enabled( value:Boolean ):void {
			if ( value == _enabled ) return;
			
			_enabled = value;
			
			buttonMode = _enabled;
			mouseEnabled = _enabled;
			
			if ( _enabled ) {
				addEventListener( MouseEvent.MOUSE_OVER, 	handlerMouse );
				addEventListener( MouseEvent.MOUSE_OUT, 	handlerMouse );
				addEventListener( MouseEvent.MOUSE_DOWN, 	handlerMouse );
				addEventListener( MouseEvent.MOUSE_UP, 		handlerMouse );
				addEventListener( MouseEvent.CLICK, 		handlerMouse );
			} else {
				removeEventListener( MouseEvent.MOUSE_OVER, 	handlerMouse );
				removeEventListener( MouseEvent.MOUSE_OUT, 		handlerMouse );
				removeEventListener( MouseEvent.MOUSE_DOWN, 	handlerMouse );
				removeEventListener( MouseEvent.MOUSE_UP, 		handlerMouse );
				removeEventListener( MouseEvent.CLICK, 			handlerMouse );
			}
		}
		
		public function get skin():ButtonSkinBase {
			return _skin;
		}
		
		override public function set width( value:Number ):void {
			skin.setSize( value, height );
		}
		
		override public function set height( value:Number ):void {
			skin.setSize( width, value );
		}

		override public function kill():void {
			enabled = false;
			
			onOver = null;
			onOut = null;
			onDown = null;
			onUp = null;
			onClick = null;
			
			customData = null;
			
			super.kill();
			
			_body = null;
			_skin = null;
		}
		
	}

}