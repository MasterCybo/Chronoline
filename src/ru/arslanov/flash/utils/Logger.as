package ru.arslanov.flash.utils {
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.text.TextFormat;

	import ru.arslanov.core.controllers.KeyController;
	import ru.arslanov.core.external.SOManager;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.text.ATextField;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class Logger {
		static public const POSITION_LEFT	:String = "left";
		static public const POSITION_RIGHT	:String = "right";
		static public const POSITION_TOP	:String = "top";
		static public const POSITION_BOTTOM	:String = "bottom";
		static public const POSITION_CENTER	:String = "center";
		
		static public var autoClearNumLines:uint = 1000;
		
		static private var _host:DisplayObjectContainer;
		static private var _keyCtrl:KeyController;
		static private var _body:ASprite;
		static private var _bg:ASprite;
		static private var _tf:ATextField;
		static private var _position:String;
		static private var _clipboard:Clipboard;
		static private var _count:uint;
		static private var _btnEdit:ASprite;
		static private var _btnSide:ASprite;
		
		static public function init( container:DisplayObjectContainer, position:String = "right" ):void {
			_host = container;
			_position = position;
			
			_clipboard = Clipboard.generalClipboard;
			
			_body = new ASprite().init();
			_body.mouseEnabled = _body.mouseChildren = false;
			_bg = new ASprite().init();
			_tf = new ATextField( "", new TextFormat( "Arial", 12, 0XD3D3D3 ) ).init();
			_tf.autoSize = "none";
			
			_btnEdit = new ASprite().init();
			_btnEdit.mouseEnabled = true;
			_btnEdit.buttonMode = true;
			_btnEdit.graphics.beginFill( 0xff0000 );
			_btnEdit.graphics.drawRect( 0, 0, 10, 10 );
			_btnEdit.graphics.endFill();
			_btnEdit.eventManager.addEventListener( MouseEvent.CLICK, onClickEdit );
			
			_btnSide = new ASprite().init();
			_btnSide.mouseEnabled = true;
			_btnSide.buttonMode = true;
			_btnSide.graphics.beginFill( 0x80FF00 );
			_btnSide.graphics.drawRect( 0, 0, 10, 10 );
			_btnSide.graphics.endFill();
			_btnSide.eventManager.addEventListener( MouseEvent.CLICK, onClickSide );
			
			_body.addChild( _bg );
			_body.addChild( _tf );
			
			_body.visible = _btnEdit.visible = _btnSide.visible = false;
			
			_host.addChild( _body );
			_host.addChild( _btnEdit );
			_host.addChild( _btnSide );
			
			updateSize();
			
			traceHelp();
			
			Display.stage.doubleClickEnabled = true;
			Display.stageAddEventListener( Event.RESIZE, hrStageResize );
			Display.stageAddEventListener( MouseEvent.MIDDLE_CLICK, hrMiddleClick );
			Display.root.addEventListener( TouchEvent.TOUCH_END, hrTouchEnd );
			Display.root.addEventListener( TouchEvent.TOUCH_TAP, hrTouchTap );
			
			_keyCtrl = new KeyController( Display.stage );
			_keyCtrl.bindChar( "L", hrKeyUp );
			
			var isVis:Boolean = SOManager.getBoolean( "loggerView" );
			
			if ( isVis ) {
				visible = true;
			}
		}

		private static function hrKeyUp( ev:KeyboardEvent ):void
		{
			visible = !visible;
		}
		
		static private function onClickSide( ev:MouseEvent ):void {
			if ( _position == POSITION_RIGHT ) {
				_position = POSITION_LEFT;
			} else {
				_position = POSITION_RIGHT;
			}
			
			updateSize();
		}
		
		static private function onClickEdit( ev:MouseEvent ):void {
			_tf.selectable = !_tf.selectable;
			_body.mouseChildren = _tf.selectable;
			_tf.setSelection( 0, _tf.text.length );
			
			if ( _tf.selectable ) {
				Display.stage.focus = _tf;
			} else {
				Display.stage.focus = null;
			}
		}
		
		static private function hrTouchEnd( ev:TouchEvent ):void {
			traceMessage( "CALL >> Logger.hrTouchEnd" );
		}
		
		static private function hrTouchTap( ev:TouchEvent ):void {
			traceMessage( "CALL >> Logger.hrTouchTap" );
		}
		
		static private function hrMiddleClick( ev:MouseEvent ):void {
			if ( ev.ctrlKey ) {
				_clipboard.setData( ClipboardFormats.TEXT_FORMAT, _tf.text );
				
				traceMessage( "Copy to clipboard" );
			}
			
			if ( ev.altKey ) {
				_tf.text = "";
				traceHelp();
			}
			
			if ( ev.shiftKey ) {
				visible = !visible;
			}
		}
		
		static private function hrStageResize( ev:Event ):void {
			updateSize();
		}
		
		static private function updateSize():void {
			var ww:uint = Display.stageWidth;
			var hh:uint = Display.stageHeight;
			var xx:uint = 0;
			var yy:uint = 0;
			
			switch ( _position ) {
				case POSITION_BOTTOM:
					ww = Display.stageWidth;
					hh = int( Display.stageHeight / 2 );
					yy = hh;
				break;
				case POSITION_LEFT:
					ww = int( Display.stageWidth / 2 );
					hh = Display.stageHeight;
				break;
				case POSITION_RIGHT:
					ww = int( Display.stageWidth / 2 );
					hh = Display.stageHeight;
					xx = ww;
				break;
				case POSITION_TOP:
					ww = Display.stageWidth;
					hh = int( Display.stageHeight / 2 );
				break;
				default:
			}
			
			_bg.x = xx;
			_bg.y = yy;
			_bg.graphics.clear();
			_bg.graphics.beginFill( 0x0, 0.75 );
			_bg.graphics.drawRect( 0, 0, ww, hh );
			_bg.graphics.endFill();
			
			_tf.x = _bg.x + 10;
			_tf.y = _bg.y + 10;
			_tf.setWidth( ww - 20 );
			_tf.height = hh - 20;
			
			_btnEdit.x = _bg.x + _bg.width - 5 - _btnEdit.width;
			_btnEdit.y = _bg.y + 5;
			
			_btnSide.x = _btnEdit.x - _btnSide.width - 5;
			_btnSide.y = _btnEdit.y;
		}
		
		static public function traceMessage( message:* ):void {
			if ( _tf.numLines == autoClearNumLines ) {
				_tf.text = "";
				_count = 0;
			}
			
			_count++;
			
			_tf.appendText( _count + ". " + String( message ) );
			_tf.appendText( "\n" );
			
			_tf.scrollV = _tf.maxScrollV;
			
			toTop();
		}
		
		static public function set visible( value:Boolean ):void {
			if ( value ) toTop();
			_body.visible = _btnEdit.visible = _btnSide.visible = value;
			
			SOManager.setVar( "loggerView", value );
		}
		
		static public function get visible():Boolean {
			return _body.visible;
		}
		
		static private function traceHelp():void {
			traceMessage( "CTRL + MOUSE_MIDDLE_CLICK - copy log to clipboard" );
			traceMessage( "ALT + MOUSE_MIDDLE_CLICK - clear log" );
			traceMessage( "SHIFT + MOUSE_MIDDLE_CLICK - show / hide log" );
			traceMessage( "-----------------------------------------------------" );
		}
		
		static private function toTop():void {
			_host.setChildIndex( _body, _host.numChildren - 1 );
			_host.setChildIndex( _btnEdit, _host.numChildren - 1 );
			_host.setChildIndex( _btnSide, _host.numChildren - 1 );
		}
	}

}