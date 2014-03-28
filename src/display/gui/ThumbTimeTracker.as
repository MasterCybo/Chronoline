package display.gui {
	
	import display.base.ButtonApp;
	import display.skins.ThumbDownSkin;
	import display.skins.ThumbSkin;
	import display.skins.ThumbTopSkin;
	import flash.events.MouseEvent;
	import ru.arslanov.core.controllers.MouseController;
	import ru.arslanov.core.utils.Calc;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ThumbTimeTracker extends ASprite {
		
		static public const ALPHA_MAX:Number = 1;
		static public const ALPHA_MIN:Number = 0.4;
		
		
		public var onMove:Function;
		public var onResize:Function;
		public var onDown:Function; // Обработчик нажатия мыши
		public var onUp:Function; // Обработки отжатия мыши
		
		private var _body:ButtonApp;
		private var _btnTop:ButtonApp;
		private var _btnDown:ButtonApp;
		
		private var _height:Number = 0;
		
		private var _posTop:Number = 0; // Положение тела ползунка в %
		private var _posBottom:Number = 0.5; // Положение нижней кнопки ползунка в %
		
		private var _ctrlBody:MouseController;
		private var _ctrlTop:MouseController;
		private var _ctrlDown:MouseController;
		
		public function ThumbTimeTracker( height:Number ) {
			_height = height;
			
			super();
		}
		
		override public function init():* {
			_body = new ButtonApp( new ThumbSkin().init() ).init();
			_btnTop = new ButtonApp( new ThumbTopSkin().init() ).init();
			_btnDown = new ButtonApp( new ThumbDownSkin().init() ).init();
			
			_btnTop.alpha = _btnDown.alpha = ALPHA_MIN;
			
			
			updateSize();
			updatePositions();
			
			
			addChild( _body );
			addChild( _btnTop );
			addChild( _btnDown );
			
			_ctrlBody = new MouseController( _body );
			_ctrlTop = new MouseController( _btnTop );
			_ctrlDown = new MouseController( _btnDown );
			
			_ctrlBody.handlerDrag = onMoveBody;
			_ctrlTop.handlerDrag = onMoveTop;
			_ctrlDown.handlerDrag = onMoveBottom;
			
			eventManager.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			eventManager.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			eventManager.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			
			return super.init();
		}
		
		private function onMouseDown( ev:MouseEvent ):void {
			Display.stageAddEventListener( MouseEvent.MOUSE_UP, onStageUp );
			
			if ( onDown != null ) {
				onDown();
			}
		}
		
		private function onStageUp( ev:MouseEvent ):void {
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onStageUp );
			
			if ( onUp != null ) {
				onUp();
			}
		}
		
		/***************************************************************************
		Отображение / скрытие кнопок изменения размера ползунка
		***************************************************************************/
		private function onMouseOver( ev:MouseEvent ):void {
			_btnTop.alpha = _btnDown.alpha = ALPHA_MAX;
		}
		
		private function onMouseOut( ev:MouseEvent ):void {
			_btnTop.alpha = _btnDown.alpha = ALPHA_MIN;
		}
		
		/***************************************************************************
		Обработчик таскания ТЕЛА ползунка
		***************************************************************************/
		private function onMoveBody():void {
			var ny:Number = _body.y + _ctrlBody.movement.y;
			
			if ( (ny < 0) || ((ny + _body.height) > _height) ) return;
			
			_posTop = ny / _height;
			_posBottom = ( ny + _body.height ) / _height;
			
			updatePositions();
			callMove();
		}
		
		/***************************************************************************
		Обработчик таскания ВЕРХНЕГО регулятора
		***************************************************************************/
		private function onMoveTop():void {
			var ny:Number = _btnTop.y + _ctrlTop.movement.y;
			
			if ( ( _ctrlTop.movement.y < 0 ) && ( (ny - _btnTop.height) < 0 ) ) return;
			if ( ( _ctrlTop.movement.y > 0 ) && ( ny > (_btnDown.y - Settings.THUMB_MIN_HEIGHT) ) ) return;
			
			_posTop = ny / _height;
			
			updateSize();
			callResize();
		}
		
		/***************************************************************************
		Обработчик таскания НИЖНЕГО регулятора
		***************************************************************************/
		private function onMoveBottom():void {
			var ny:Number = _btnDown.y + _ctrlDown.movement.y;
			
			if ( ( _ctrlDown.movement.y > 0 ) && ( (ny + _btnDown.height) > _height ) ) return;
			if ( ( _ctrlDown.movement.y < 0 ) && ( ny < (_body.y + Settings.THUMB_MIN_HEIGHT) ) ) return;
			
			_posBottom = ny / _height;
			
			updateSize();
			callResize();
		}
		
		/***************************************************************************
		Обновление элементов
		***************************************************************************/
		private function updatePositions():void {
			_btnTop.y = posTop * _height;
			_body.y = _btnTop.y;
			_btnDown.y = _body.y + _body.height;
		}
		
		private function updateSize():void {
			_btnTop.y = posTop * _height;
			_body.y = _btnTop.y;
			
			_btnDown.y = posDown * _height;
			
			_body.height = _btnDown.y - _btnTop.y;
		}
		
		/***************************************************************************
		Геттеры / Сеттеры
		***************************************************************************/
		// Позиция ВЕРХНЕГО регулятора
		public function get posTop():Number {
			return _posTop;
		}
		
		// Позиция НИЖНЕГО регулятора
		public function get posDown():Number {
			return _posBottom;
		}
		
		// Размер ползунка
		public function get size():Number {
			return _posBottom - _posTop;
		}
		
		public function setPositions( top:Number, bottom:Number ):void {
			top = Calc.constrain( 0, top, 1 );
			bottom = Calc.constrain( 0, bottom, 1 );
			
			var delta:Number = _posBottom - _posTop;
			
			_posTop = top;
			_posBottom = bottom;
			
			if ((_posBottom - _posTop) == delta ) {
				updatePositions();
			} else {
				updateSize();
			}
		}
		
		public function set heightMax( value:Number ):void {
			_height = value;
			
			updateSize();
		}
		
		public function get heightMax():Number {
			return _height;
		}
		
		/***************************************************************************
		Вызов обработчиков
		***************************************************************************/
		private function callMove():void {
			if ( onMove != null ) {
				onMove();
			}
		}
		
		private function callResize():void {
			if ( onResize != null ) {
				onResize();
			}
		}
		
		override public function kill():void {
			eventManager.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			eventManager.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			eventManager.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onStageUp );
			
			_ctrlBody.dispose();
			_ctrlTop.dispose();
			_ctrlDown.dispose();
			
			onUp = null;
			onDown = null;
			onMove = null;
			onResize = null;
			
			super.kill();
		}
	}

}