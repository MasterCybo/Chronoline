package display.base {
	import flash.text.TextFieldAutoSize;

	import ru.arslanov.flash.gui.hints.AHint;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class HintApp extends AHint {
		private var _tf:TextApp;
		
		public function HintApp( data:Object = null ) {
			super( data );
		}
		
		override public function init():* {
			super.init();
			
			_tf = new TextApp( _data ? _data.text : "" ).init();
			_tf.setBorder( true, 0X808000 );
			_tf.setBackground( true, 0XFFFFA8 );
			_tf.autoSize = TextFieldAutoSize.LEFT;
			
			if ( _data && _data.width ) {
				_tf.setWidth( _data.width );
			}
			
			while ( _tf.height > _data.width ) {
				_tf.setWidth( _tf.width * 1.1 );
			}
			
			addChild( _tf );
			
			return this;
		}
		
		public function setText( message:* ):void {
			if ( message == _tf.text ) return;
			
			_tf.text = String( message );
		}
	}

}