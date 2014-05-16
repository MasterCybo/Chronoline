/**
 * Created by aa on 14.05.2014.
 */
package display.windows
{
	import constants.LocaleString;
	import constants.TextFormats;

	import display.base.InputApp;
	import display.gui.buttons.ButtonText;

	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.layout.HBox;
	import ru.arslanov.flash.gui.layout.VBox;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class WinSavePreset extends WindowApp
	{
		static public const WINDOW_NAME:String = "winSavePreset";

		private var _handlerOk:Function;
		private var _handlerCancel:Function;
		private var _inpName:InputApp;

		public function WinSavePreset( handlerOk:Function = null, handlerCancel:Function = null )
		{
			_handlerOk = handlerOk;
			_handlerCancel = handlerCancel;
			super( WINDOW_NAME, Display.stageWidth, Display.stageHeight );
		}


		override public function init():*
		{
			super.init();

			var bg:ASprite = new ASprite().init();
			bg.graphics.beginFill( 0x0, 0.75 );
			bg.graphics.drawRect( 0, 0, width, height );
			bg.graphics.endFill();

			super.setBody( bg );


			var vBox:VBox = new VBox( 10 ).init();
			var hBox:HBox = new HBox( 10 ).init();

			_inpName = new InputApp( "", TextFormats.RANGE_EDIT, 300 ).init();
			_inpName.setBorder( true, 0xB9B9B9 );
			_inpName.setBackground( true, 0xffffff );
			_inpName.setTextHelp( LocaleString.HELP_NAME_PRESET, TextFormats.RANGE_EDIT_HELPER );


			var _btnSave:ButtonText = new ButtonText( LocaleString.SAVE_PRESET ).init();
			_btnSave.onRelease = onClickSave;

			var _btnCancel:ButtonText = new ButtonText( LocaleString.CANCEL ).init();
			_btnCancel.onRelease = onClickCancel;


			vBox.addChildAndUpdate( _inpName );

			hBox.addChildAndUpdate( _btnSave );
			hBox.addChildAndUpdate( _btnCancel );

			vBox.addChildAndUpdate( hBox );
			hBox.x =int((vBox.width - hBox.width)/2);

			vBox.setXY( (width - vBox.width) / 2, (height - vBox.height) / 2 );
			addChildToContent( vBox );

			return this;
		}

		private function onClickCancel():void
		{
			if ( _handlerCancel != null ) {
				_handlerCancel();
			}
		}

		private function onClickSave():void
		{
			if ( _inpName.text == "" ) return;

			if ( _handlerOk != null ) {
				_handlerOk( _inpName.text );
			}
		}


		override public function kill():void
		{
			_handlerOk = null;
			_handlerCancel = null;

			super.kill();
		}
	}
}
