package ru.arslanov.flash.gui {
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.interfaces.IKillable;
	import ru.arslanov.flash.text.ATextField;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ALabel extends ASprite {
		
		private var _tf:ATextField;
		private var _image:IKillable;
		private var _newImage:IKillable;
		private var _text:String = "";
		private var _align:String = "left";
		private var _space:int;
		private var _textFormat:TextFormat;
		
		public function ALabel( text:String = "", textFormat:TextFormat = null, image:IKillable = null, space:int = 0, align:String = "left" ) {
			_text = text;
			_textFormat = textFormat;
			_newImage = image;
			_space = space;
			_align = align;
			
			super();
		}
		
		override public function init():* {
			build();
			
			return super.init();
		}
		
		public function setImage( image:IKillable, space:int = 0, align:String = "left" ):void {
			_newImage = image;
			_space = space;
			_align = align;
			
			build();
		}
		
		private function build():void {
			if ( !_tf ) {
				_tf = new ATextField( _text, _textFormat ).init();
				_tf.autoSize = "left";
				addChild( _tf );
			}
			
			if ( _newImage ) {
				if ( _image && (_newImage != _image) ) {
					_image.kill();
					_image = null;
				}
				
				_image = _newImage;
				addChild( _image as DisplayObject );
			}
			
			updatePos();
		}
		
		private function updatePos():void {
			if ( !_image ) return;
			
			if ( _align == "right" ) {
				_tf.x = 0;
				_image.x = _tf.x + _tf.width + _space;
			} else {
				_image.x = 0;
				_tf.x = _image.x + _image.width + _space;
			}
			
			_tf.y = int( ( _image.height - _tf.height ) / 2 );
		}
		
		public function get textField():ATextField {
			return _tf;
		}
	}

}