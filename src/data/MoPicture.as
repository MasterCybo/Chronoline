package data {
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.core.utils.Log;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class MoPicture extends ModelBase {
		
		public var filename:String;
		
		public function MoPicture( id:String, title:String, filename:String ) {
			this.filename = filename;
			super( id, title );
		}
		
		override public function toString():String {
			return "[" + getQualifiedClassName( this ) + " " + uidStr + ", " + id + ", title=" + title.substr( 0, 15 ) + "... " + filename + "]";
		}
		
		/**
		 * Статический метод создания модели из JSON-данных
		 * @param	json
		 * @return
		 */
		static public function fromJSON( json:Object ):MoPicture {
			return new MoPicture( json.id, json.name, json.filename );
		}
	}

}
