package ru.arslanov.flash.gui.windows {
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.interfaces.IKillable;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class AWindow extends ASprite {
		
		protected var body:IKillable;
		
		private var _header:ASprite;
		private var _content:ASprite;
		private var _contPaddings:Rectangle = new Rectangle();
		private var _isResizedByContent:Boolean = false;
		private var _alignPosition:String = "center";
		private var _dragManager:IEventDispatcher;
		
		public function AWindow( name:String, body:IKillable ) {
			this.name = name;
			this.body = body;
			super();
		}
		
		override public function init():* {
			_content = new ASprite();
			_header = new ASprite();
			
			addChild( body as DisplayObject );
			addChild( _header );
			addChild( _content );
			
			return super.init();
		}

		public function setBody( body:IKillable ):void
		{
			if ( this.body && contains( this.body as DisplayObject ) ) {
				this.body.kill();
			}

			this.body = body;
			addChildAt( this.body as DisplayObject, 0 );
		}
		
		public function setConfiguration( config:Object ):void {
			// TODO: реализовать инициализацию окна через класс конфигурации
		}
		
		/***************************************************************************
		Размеры окна
		***************************************************************************/
		override public function set width( value:Number ):void {
			body.width = value;
		}
		
		override public function set height( value:Number ):void {
			body.height = value;
		}
		
		public function get resizedByContent():Boolean {
			return _isResizedByContent;
		}
		
		public function set resizedByContent( value:Boolean ):void {
			_isResizedByContent = value;
			
			resizeByContent();
		}
		
		protected function resizeByContent( rounded:Boolean = true ):void {
			super.setSize( _content.width + contentPaddings.x + contentPaddings.width, _content.height + contentPaddings.y + contentPaddings.height, rounded );
			updatePosition();
		}
		
		/***************************************************************************
		Позиционирование окна
		***************************************************************************/
		override public function set x( value:Number ):void {
			super.x = value;
			
			_alignPosition = null;
		}
		
		override public function set y(value:Number):void {
			super.y = value;
			
			_alignPosition = null;
		}
		
		public function get alignPosition():String {
			return _alignPosition;
		}
		
		public function set alignPosition( value:String ):void {
			_alignPosition = value;
			
			updatePosition();
		}
		
		public function updatePosition():void {
			Log.traceText( "alignPosition : " + alignPosition );
			if ( alignPosition ) {
				switch ( alignPosition ) {
					case "left":
						super.x = 0;
						super.y = int(( Display.stageHeight - height ) / 2);
					break;
					case "top":
						super.x = int(( Display.stageWidth - width ) / 2);
						super.y = 0;
					break;
					case "right":
						super.x = int( Display.stageWidth - width );
						super.y = int(( Display.stageHeight - height ) / 2);
					break;
					case "bottom":
						super.x = int(( Display.stageWidth - width ) / 2);
						super.y = int( Display.stageHeight - height );
					break;
					case "leftTop":
						super.x = 0;
						super.y = 0;
					break;
					case "rightTop":
						super.x = int( Display.stageWidth - width );
						super.y = 0;
					break;
					case "leftBottom":
						super.x = 0;
						super.y = int( Display.stageHeight - height );
					break;
					case "rightBottom":
						super.x = int( Display.stageWidth - width );
						super.y = int( Display.stageHeight - height );
					break;
					default:
						super.x = int(( Display.stageWidth - width ) / 2);
						super.y = int(( Display.stageHeight - height ) / 2);
				}
			}
		}
		
		/***************************************************************************
		Гетеры элементов окна
		***************************************************************************/
		//public function get header():ASprite {
			//return _header;
		//}
		
		//public function get content():ASprite {
			//return _content;
		//}
		
		public function addChildToHeader( displayObject:IKillable ):DisplayObject {
			return _header.addChild( displayObject as DisplayObject );
		}
		
		public function addChildToContent( displayObject:IKillable ):DisplayObject {
			var obj:DisplayObject = _content.addChild( displayObject as DisplayObject );
			
			if ( resizedByContent ) resizeByContent();
			
			return obj;
		}
		
		
		public function set contentPaddings( rect:Rectangle ):void {
			_contPaddings = rect;
			_content.x = contentPaddings.x;
			_content.y = contentPaddings.y;
			
			if ( resizedByContent ) resizeByContent();
		}
		
		public function get contentPaddings():Rectangle {
			return _contPaddings;
		}
		
		
		public function get dragManager():IEventDispatcher {
			return _dragManager;
		}
		
		public function set dragManager( value:IEventDispatcher ):void {
			_dragManager = value;
		}
		
		
		
		override public function kill():void {
			super.kill();
		}
		
	}

}