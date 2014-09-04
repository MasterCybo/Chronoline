package ru.arslanov.flash.scenes {
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.interfaces.IState;
	
	/**
	 * Менеджер сцен (экранов)
	 * @author Artem Arslanov
	 */
	public class SceneManager {
		
		/***************************************************************************
		Инициализация синглтона
		***************************************************************************/
		private static var _instance:SceneManager;
		
		public static function get me():SceneManager {
			if ( _instance == null ) {
				_instance = new SceneManager( new PrivateKey() );
			}
			return _instance;
		}
		
		public function SceneManager( key:PrivateKey ):void {
			if ( !key ) {
				throw new Error( "Error: Instantiation failed: Use SceneManager.instance instead of new." );
			}
		}
		
		/***************************************************************************
		Тело класса
		***************************************************************************/
		
		private var _inited : Boolean = false;
		private var _container : Object; // Контейнер экранов
		private var _curScene : IState; // Текущий отображенный экран
		private var _scenes : Object/*IState*/ = {}; // Массив экранов
		private var _nameList : Vector.<String>; // Список имён экранов
		private var _curIdx : int; // Индекс текущего экрана
		private var _historyName : Array /*String*/ = []; // История отображенных экранов
		
		/**
		 * Инициализация менеджера экранов
		 * @param	sceneContainer - контейнер
		 */
		public function init( sceneContainer : Object ) : void {
			if ( _inited ) {
				Log.traceWarn( "SceneManager already inited!" );
				return;
			}
			
			if ( !( "addChild" in sceneContainer ) )
				throw new ArgumentError( "SceneManager :: sceneContainer no addChild" );
			
			_container = sceneContainer;
			
			_nameList = new Vector.<String>();
			
			_inited = true;
			
			Log.traceText( "SceneManager successful inited." );
		}
		
		/**
		 * Добавление класса экрана с массив экранов
		 * @param	stateClass
		 * @param	name
		 */
		public function addScene( stateClass : Class, name : String ) : void {
			if ( hasExisting( name ) )
				return;
			
			_scenes[ name ] = stateClass;
			_nameList.push( name );
		}
		
		/**
		 * Отображение экрана с заданным именем
		 * @param	name - имя экрана
		 * @param	initData - объект инициализации экрана
		 * @param	ignoreExists - игнорировать если указанный экран уже отображён
		 */
		public function displayScene( name : String, initData : Object = null, ignoreExists : Boolean = false ) : void {
			if ( _curScene ) {
				if (( _curScene.nameScene == name ) && !ignoreExists )
					return;
				
				_historyName.push( _curScene.nameScene );
				
				removeCurrentScene();
			}
			
			if ( !hasExisting( name ) ) {
				throw( new Error( "SceneManager :: State name='" + name + "' not found!" ) ).getStackTrace();
			}
			
			if ( initData ) {
				_curScene = ( new ( _scenes[ name ] as Class )( initData ) as AScene ).init();
			} else {
				_curScene = ( new ( _scenes[ name ] as Class )() as AScene ).init();
			}
			
			_curIdx = _nameList.indexOf( name );
			
			_container.addChild( _curScene );
		}
		
		/**
		 * Показ следующего экрана
		 */
		public function displayNext() : void {
			_curIdx++;
			
			if ( _curIdx >= _nameList.length )
				_curIdx = 0;
			
			displayScene( _nameList[ _curIdx ] );
		}
		
		/**
		 * Показ предыдущего экрана
		 */
		public function displayPrev() : void {
			_curIdx--;
			
			if ( _curIdx < 0 )
				_curIdx = _nameList.length - 1;
			
			displayScene( _nameList[ _curIdx ] );
		}
		
		/**
		 * Отображение предыдущего экрана из истории показов
		 */
		public function displayPrevHistory() : void {
			if ( _historyName.length == 0 )
				return;
			
			displayScene( _historyName.pop() );
		}
		
		/**
		 * Удаление текущего экрана
		 */
		private function removeCurrentScene() : void {
			if ( !_curScene )
				return;
			
			_curScene.kill();
			_curScene = null;
		}
		
		/**
		 * Проверка существования экрана с указанным именем
		 * @param	name
		 * @return
		 */
		private function hasExisting( name : String ) : Boolean {
			return ( name in _scenes );
		}
		
		/**
		 * Очистка всех экранов
		 */
		public function clearAllScenes() : void {
			_scenes = {};
			_nameList.length = 0;
			_curScene = null;
			_historyName = null;
		}
	}

}

// Приватный ключ для инстанцирования синглтона
internal class PrivateKey{}