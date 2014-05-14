/**
 * Created by aa on 14.05.2014.
 */
package display.windows
{
	import constants.LocaleString;
	import constants.TextFormats;

	import display.base.InputApp;

	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class WinSavePreset extends WindowApp
	{
		static public const WINDOW_NAME:String = "winSavePreset";

		public function WinSavePreset()
		{
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

			var inpName:InputApp = new InputApp( "", TextFormats.RANGE_EDIT, 300 ).init();
			inpName.setBorder( true, 0xB9B9B9 );
			inpName.setBackground( true, 0xffffff );
			inpName.setTextHelp( LocaleString.HELP_NAME_PRESET, TextFormats.RANGE_EDIT_HELPER );
			inpName.setXY( (width - inpName.width) / 2, (height - inpName.height) / 2 );
			addChildToContent( inpName );

			return this;
		}
	}
}
