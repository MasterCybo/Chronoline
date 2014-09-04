package ru.arslanov.flash.gui {
	import fw2cybo.com.adobe.protocols.dict.events.DisconnectedEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import ru.arslanov.core.controllers.MouseController;
	import ru.arslanov.core.events.MouseControllerEvent;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.layout.VBox;
	import ru.arslanov.flash.interfaces.IKillable;
	import ru.arslanov.flash.interfaces.IKillableInteractive;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class AScrollList extends ASprite {
		private var _list:VBox; // Содержит весь контент скроллера
		private var _container:ASprite; // Маскируемый контейнер
		private var _thumb:IKillable; // Ползунок
		private var _scroller:ASprite; // Контейнер позунка
		private var _scrollRect:Rectangle;
		private var _width:uint;
		private var _height:uint;
		private var _msc:MouseController;
		private var _minHThumb:Number; // Минимальная высота ползунка равна инициализированной высота ползунка
		private var _kf:Number;
		
		private var _scrollerOffsetX:int;
		private var _scrollerOffsetY:int;
		
		public function AScrollList( width:uint, height:uint, thumb:IKillable, thumbBackground:IKillable = null, background:DisplayObject = null ) {
			_width = width;
			_height = height;
			_thumb = thumb;
			super();
		}
		
		override public function init():* {
			_minHThumb = _thumb.height;
			
			_list = new VBox().init();
			_container = new ASprite().init();
			
			_container.addChild( _list );
			addChild( _container );
			
			_scroller = new ASprite().init();
			addChild( _scroller );
			
			_scroller.addChild( _thumb as DisplayObject );
			
			_msc = new MouseController( _thumb as DisplayObject );
			_msc.handlerDrag = hrMouseMove;
			
			// Контент может вещать событие Event.CHANGE, по которому произойдёт обновление скроллера
			eventManager.addEventListener( Event.CHANGE, hrListChange );
			
			updateScroller();
			
			updateThumb();
			
			return super.init();
		}
		
		private function hrListChange( ev:Event ):void {
			updateThumb();
		}
		
		private function hrMouseMove( ev:MouseControllerEvent ):void {
			_thumb.y = Math.round( Math.min( Math.max( 0, _thumb.y + ev.movement.y ), _container.y + _container.height - _thumb.height ) );
			
			if ( !_scrollRect ) return;
			
			_scrollRect.y = _thumb.y / _kf;
			_container.scrollRect = _scrollRect;
		}
		
		private function updateThumb():void {
			if ( !_scrollRect ) return;
			
			var contBounds:Rectangle = _container.getBounds( _container );
			Log.traceText( "contBounds : " + contBounds );
			Log.traceText( "_container.height : " + _container.height );
			Log.traceText( "_list.height : " + _list.height );
			Log.traceText( "_scrollRect : " + _scrollRect );
			
			_scroller.visible = _list.height > _scrollRect.height;
			
			_thumb.height = Math.max( _scrollRect.height * _scrollRect.height / _list.height, _minHThumb );
			
			_kf = ( _scrollRect.height - _thumb.height ) / ( _list.height - _scrollRect.height );
		}
		
		private function updateScroller():void {
			_scroller.setXY( _container.x + _container.width + _scrollerOffsetX, _scrollerOffsetY );
		}
		
		
		/***************************************************************************
		Геттеры / Сеттеры
		***************************************************************************/
		public function setScroller( offsetX:int = 0, offsetY:int = 0 ):void {
			_scrollerOffsetX = offsetX;
			_scrollerOffsetY = offsetY;
			
			updateScroller();
		}
		
		public function get space():int {
			return _list.space;
		}
		
		public function set space( value:int ):void {
			_list.space = value;
		}
		
		public function setClipBounds( rect:Rectangle ):void {
			_scrollRect = rect;
			
			_container.scrollRect = _scrollRect;
			
			updateThumb();
		}
		
		public function addChildList( child:DisplayObject ):DisplayObject {
			var object:DisplayObject = _list.addChild( child );
			updateThumb();
			return object;
		}
		
		override public function kill():void {
			_msc.kill();
			
			super.kill();
		}
	}

}