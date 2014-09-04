package ru.arslanov.flash.gui {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import ru.arslanov.core.controllers.MouseController;
	import ru.arslanov.core.events.MouseControllerEvent;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.interfaces.IKillable;
	import ru.arslanov.flash.interfaces.IKillableInteractive;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class AScrollbar extends ASprite {
		private var _thumb:IKillable; // Ползунок
		private var _target:DisplayObject;
		private var _scrollRect:Rectangle;
		private var _targetBounds:Rectangle;
		private var _msc:MouseController;
		private var _minHThumb:Number; // Минимальная высота ползунка равна инициализированной высота ползунка
		
		private var _scrollerOffsetX:int;
		private var _scrollerOffsetY:int;
		private var _position:Number = 0;
		
		public function AScrollbar( target:IKillableInteractive, rect:Rectangle, thumb:IKillable ) {
			_target = target as DisplayObject;
			_scrollRect = rect;
			_thumb = thumb;
			super();
		}
		
		override public function init():* {
			_minHThumb = _thumb.height;
			_targetBounds = _target.getBounds( _target );
			
			addChild( _thumb as DisplayObject );
			
			_msc = new MouseController( _thumb as DisplayObject );
			_msc.handlerDrag = hrMouseMove;
			
			// Контент может вещать событие Event.CHANGE, по которому произойдёт обновление скроллера
			( _target as IKillableInteractive ).eventManager.addEventListener( Event.CHANGE, hrContentChange );
			
			visible = false;
			
			update();
			
			return super.init();
		}
		
		/***************************************************************************
		   Обработчики событий
		 ***************************************************************************/
		private function hrContentChange( ev:Event ):void {
			updateThumbHeight();
			updateVisible();
		}
		
		private function hrMouseMove( ev:MouseControllerEvent ):void {
			_thumb.y = Math.round( Math.min( Math.max( 0, _thumb.y + ev.movement.y ), _scrollRect.height - _thumb.height ) );
			
			if ( !_scrollRect )
				return;
			
			position = _thumb.y / ( _scrollRect.height - _thumb.height );
		}
		
		/***************************************************************************
		   Геттеры / Сеттеры
		 ***************************************************************************/
		public function get position():Number {
			return _position;
		}
		
		public function set position( value:Number ):void {
			value = Math.max( 0, Math.min( value, 1 ) );
			
			if ( value == position )
				return;
			
			_position = value;
			
			_thumb.y = ( _scrollRect.height - _thumb.height ) * value;
			
			updateScrollRect();
		}
		
		/***************************************************************************
		   Обновляторы
		 ***************************************************************************/
		public function update():void {
			_target.scrollRect = _scrollRect;
			
			updateThumbHeight();
			updateScroller();
			updateVisible();
		}
		
		private function updateThumbHeight():void {
			if ( !_scrollRect )
				return;
			
			_targetBounds = _target.getBounds( _target );
			
			Log.traceText( "_targetBounds : " + _targetBounds );
			Log.traceText( "_scrollRect : " + _scrollRect );
			
			_thumb.height = Math.max( _scrollRect.height * _scrollRect.height / _targetBounds.height, _minHThumb );
		}
		
		private function updateScrollRect():void {
			_scrollRect.y = ( _targetBounds.height - _scrollRect.height ) * position;
			_target.scrollRect = _scrollRect;
		}
		
		private function updateScroller():void {
			setXY( _target.x + _scrollRect.right, _target.y );
		}
		
		private function updateVisible():void {
			//_targetBounds = _target.getBounds( _target );
			
			var vis:Boolean = _targetBounds.height > _scrollRect.height;
			
			if ( vis == visible )
				return;
			
			visible = vis;
			
			if ( visible ) {
				_target.scrollRect = _scrollRect;
			} else {
				_target.scrollRect = null;
			}
		}
		
		public function setViewPort( rect:Rectangle ):void {
			if ( (rect.height == _scrollRect.height) && (rect.width == _scrollRect.width) ) return;
			
			_scrollRect = rect;
			update();
		}
		
		public function getViewPort():Rectangle {
			return _scrollRect;
		}
		
		override public function kill():void {
			_msc.kill();
			
			super.kill();
		}
	
	}

}