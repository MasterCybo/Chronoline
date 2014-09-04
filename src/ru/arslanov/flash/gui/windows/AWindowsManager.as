package ru.arslanov.flash.gui.windows {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * 
	 * @author Artem Arslanov
	 */
	public class AWindowsManager {
		
		static public const POSITION_L:String 	= "left";
		static public const POSITION_LT:String 	= "leftTop";
		static public const POSITION_T:String 	= "top";
		static public const POSITION_RT:String 	= "rightTop";
		static public const POSITION_R:String 	= "right";
		static public const POSITION_RB:String 	= "rightBottom";
		static public const POSITION_B:String 	= "bottom";
		static public const POSITION_LB:String 	= "leftBottom";
		static public const POSITION_C:String 	= "center";
		
		/***************************************************************************
		Инициализация синглтона
		***************************************************************************/
		private static var _instance:AWindowsManager;
		
		public static function get me():AWindowsManager {
			if ( _instance == null ) {
				_instance = new AWindowsManager( new PrivateKey() );
			}
			return _instance;
		}
		
		public function AWindowsManager( key:PrivateKey ):void {
			if ( !key ) {
				throw new Error( "Error: Instantiation failed: Use AWindowsManager.instance instead of new." );
			}
		}
		
		/***************************************************************************
		Тело класса
		***************************************************************************/
		
		private var _container:DisplayObjectContainer;
		private var _windows:Vector.<AWindow>;
		private var _windowNames:Dictionary/*AWindow*/;
		
		public function init( container:DisplayObjectContainer ):AWindowsManager {
			if ( _container ) {
				Log.traceWarn( "AWindowsManager.init already inited!" );
				return _instance;
			}
			
			_container = container;
			_windows = new Vector.<AWindow>();
			_windowNames = new Dictionary( true );
			
			Display.stageAddEventListener( Event.RESIZE, hrStageResize );
			
			return _instance;
		}
		
		private function hrStageResize( ev:Event ):void {
			var len:uint = _windows.length;
			for (var i:int = 0; i < len; i++) {
				_windows[i].updatePosition();
			}
		}
		
		public function displayWindow( window:AWindow ):void {
			if ( _windowNames[ window.name ] ) {
				Log.traceWarn( "AWindowsManager.displayWindow( " + window.name + " ) already exist!" );
				return;
			}
			
			_windows.push( window );
			_windowNames[ window.name ] = window;
			
			window.updatePosition();
			_container.addChild( window );
		}
		
		public function removeWindow( name:String, killMethod:Boolean = true ):void {
			if ( !_windowNames[ name ] ) {
				Log.traceWarn( "AWindowsManager.removeWindow( " + name + " ) doesn't exist!" );
				return;
			}
			
			var window:AWindow = _windowNames[ name ];
			_container.removeChild( window );
			
			delete _windowNames[ name ];
			_windows.splice( _windows.indexOf( window ), 1 );

			if ( killMethod ) {
				window.kill();
			}
		}
		
		public function removeAllWindows():void {
			var len:uint = _windows.length;
			for (var i:int = 0; i < len; i++) {
				removeWindow( _windows[i].name );
			}
		}
		
		public function setFocusWindow( name:String ):void {
			//_container.addChild( window );
		}
		
		public function getFocusedWindow():AWindow {
			//_container.addChild( window );
			return null;
		}
		
		public function getWindowsNames():Vector.<String> {
			var vect:Vector.<String> = new Vector.<String>();
			
			var len:uint = _windows.length;
			for (var i:int = 0; i < len; i++) {
				vect.push( _windows[i].name );
			}
			
			return vect;
		}
	}
}

// Приватный ключ для инстанцирования синглтона
internal class PrivateKey{}