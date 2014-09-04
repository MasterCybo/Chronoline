package ru.arslanov.core.load {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.text.Font;
	import ru.cybo.events.LoaderEvent;
	import ru.cybo.utils.logger.log;
	import ru.cybo.utils.logger.Logger;
	/**
	 * Загрузчик SWF-файла со встроенными шрифтами
	 * !!! NOT USED !!!
	 * @author Artem Arslanov
	 */
	public class FontLoader extends AbstractLoader {
		
		private var _ldr:Loader;
		private var _registeredFonts:Object;
		private var _emptyFont:Font = new Font ();
		
		
		public function FontLoader (url:String) {
			_registeredFonts = { };
			super (url);
		}
		
		public function get instance ():Loader {
			return _ldr;
		}
		
		override public function start ():void {
			_ldr = new Loader ();
			
			addLoaderEventDispatcher (_ldr.contentLoaderInfo);
			
			super.start ();
			
			_ldr.load (new URLRequest (_url));
		}
		
		override public function stop ():void {
			if (super._openStream) {
				_ldr.close ();
			}
		}
		
		/**
		 * Метод возвращает объект типа Font ассоциированным по fontName из загруженной библиотеки.
		 * @param	fontName
		 * @return
		 */
		public function getFont (fontName:String):Font {
			if (_registeredFonts[fontName]) return _registeredFonts[fontName];
			
			var ClassName:Class = getClass (fontName);
			
			if (! (ClassName is Class)) {
				logDefError ("getFont", fontName);
				return _emptyFont;
			}
			
			
			//trace ("ClassName : " + ClassName, typeof (ClassName)); // Debug info Variable
			
			try {
				Font.registerFont (ClassName as Class);
			} catch (err:Error){
				throw new Error (err.getStackTrace ());
			}
			
			//log ('Font "' + fontName + '" register successfully.', Logger.COLOR_INFO);
			
			_registeredFonts[fontName] = new ClassName ();
			return _registeredFonts[fontName];
		}
		
		/**
		 * Метод возвращает ссылку на контент загруженной библиотеки.
		 * Аналог Loader.contentLoaderInfo.content
		 */
		public function get content ():MovieClip {
			return _ldr.contentLoaderInfo.content as MovieClip;
		}
		
		private function getClass (linkage:String):Class {
			var hasDef:Boolean = _ldr.contentLoaderInfo.applicationDomain.hasDefinition (linkage);
			
			//trace (linkage + ", hasDef : " + hasDef); // Debug info Variable
			
			if (!hasDef) {
				return null;
			}
			return _ldr.contentLoaderInfo.applicationDomain.getDefinition (linkage) as Class;
		}
		
		
		private function logDefError (methodName:String, key:String):void {
			log ('FontLoader.' + methodName + '("' + key + '") : Объект "' + key + '" не найден!', Logger.COLOR_ERROR);
		}
		
		
		
		override public function destroy ():void {
			stop ();
			
			_ldr.unloadAndStop ();
			
			super.destroy ();
			
			_ldr = null;
			_registeredFonts = null;
			_emptyFont = null;
		}
	}

}