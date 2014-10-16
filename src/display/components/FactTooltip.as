package display.components
{
	import constants.LocaleString;
	import constants.TextFormats;

	import data.MoFact;

	import display.base.TextApp;

	import flash.filters.DropShadowFilter;

	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.flash.display.AShape;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class FactTooltip extends ASprite
	{

		private static const DEF_WIDTH:uint = 300;
		private static const DEF_DATE_HEIGHT:uint = 25;
		private static const DEF_BODY_HEIGHT:uint = 150;

		public var moFact:MoFact;

		private var _body:ASprite = new ASprite();
		private var _tfMore:TextApp = new TextApp("", TextFormats.TOOLTIP_MORE).init();

		public function FactTooltip( moFact:MoFact )
		{
			this.moFact = moFact;
			mouseChildren = true;
			super();
		}



		override public function init():*
		{
			super.init();

			var dateText:String = JDUtils.getFormatString( moFact.period.beginJD, LocaleString.DATE_TEMPLATE_SHORT )
					    + " — "
					    + JDUtils.getFormatString( moFact.period.endJD, LocaleString.DATE_TEMPLATE_SHORT );



			var tail:AShape = new AShape();
			tail.graphics.beginFill( 0x9b9c7f );
			tail.graphics.moveTo( 0, 0 );
			tail.graphics.lineTo( 61, 36 );
			tail.graphics.lineTo( 61, 47 );
			tail.graphics.lineTo( 0, 0 );
			tail.graphics.endFill();
			addChild( tail );


			addChild( _body );


			tail.x = 0;
			tail.y = 0;
			_body.x = tail.x + tail.width;
			_body.y = tail.y + int(Settings.ICON_SIZE / 2) + 2;


			var tfDate:TextApp = new TextApp( dateText ? dateText : "not found", TextFormats.TOOLTIP_DATE ).init();
			tfDate.x = _body.x + 5;
			tfDate.y = _body.y + (DEF_DATE_HEIGHT - tfDate.height) / 2;
			addChild( tfDate );

			var tfTitle:TextApp = new TextApp( moFact.title, TextFormats.TOOLTIP_TITLE ).init();
			tfTitle.setWidth( DEF_WIDTH );
//			tfTitle.setWidth( DEF_WIDTH - 10 );
			tfTitle.x = tfDate.x;
			tfTitle.y = _body.y + DEF_DATE_HEIGHT + 5;

//			while ( (tfTitle.height > tfTitle.width) && (tfTitle.width < 2 * DEF_WIDTH) ) {
			while ( ( tfTitle.width / tfTitle.height ) < 1.3 ) {
				tfTitle.setWidth( tfTitle.width + 10 );
//				trace( "tfTitle.width : " + tfTitle.width );
			}

			addChild(tfTitle);

			var bodyWidth:uint = tfTitle.width + 10;
			var bodyHeight:uint = tfTitle.height + 10;

			if ( (moFact.urlMore != null) && (moFact.urlMore != "") ) {
				_tfMore.htmlText = "<a href='" + moFact.urlMore + "' target='_blank'>" + LocaleString.TOOLTIP_MORE + "</a>";
				_tfMore.x = tfTitle.x;
				_tfMore.y = tfTitle.y + tfTitle.height + 5;
				addChild( _tfMore );

				bodyHeight += _tfMore.height + 5;
			}

			// header
			_body.graphics.beginFill( 0xc5c6ac );
			_body.graphics.drawRect( 0, 0, bodyWidth, DEF_DATE_HEIGHT );
			_body.graphics.endFill();

			// text
			_body.graphics.beginFill( 0xf2f0d5 );
			_body.graphics.drawRect( 0, DEF_DATE_HEIGHT, bodyWidth, bodyHeight/*DEF_BODY_HEIGHT*/ );
			_body.graphics.endFill();
			// border
			_body.graphics.lineStyle( 1, 0x9b9c7f, 1, true );
			_body.graphics.drawRect( 0, 0, bodyWidth, bodyHeight + DEF_DATE_HEIGHT );

			_body.filters = [ new DropShadowFilter( 0, 0, 0x0, 0.3, 7, 7 ) ];


			return this;
		}

		override public function kill():void
		{
			moFact = null;

			super.kill();
		}
	}

}