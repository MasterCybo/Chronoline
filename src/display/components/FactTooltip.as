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

		public function FactTooltip( moFact:MoFact )
		{
			this.moFact = moFact;
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
			tail.graphics.moveTo( 0, 36 );
			tail.graphics.lineTo( 61, 0 );
			tail.graphics.lineTo( 61, 13 );
			tail.graphics.lineTo( 0, 37 );
			tail.graphics.endFill();
			addChild( tail );


			var body:ASprite = new ASprite();
			// header
			body.graphics.beginFill( 0xc5c6ac );
			body.graphics.drawRect( 0, 0, DEF_WIDTH, DEF_DATE_HEIGHT );
			body.graphics.endFill();
			addChild( body );


			tail.x = 0;
			tail.y = -tail.height;
			body.x = tail.x + tail.width;
			body.y = tail.y - 33;

			mouseChildren = true;

			var tfDate:TextApp = new TextApp( dateText ? dateText : "not found", TextFormats.TOOLTIP_DATE ).init();
			tfDate.x = body.x + 5;
			tfDate.y = body.y + (DEF_DATE_HEIGHT - tfDate.height) / 2;
			addChild( tfDate );

			var tfTitle:TextApp = new TextApp( moFact.title, TextFormats.TOOLTIP_TITLE ).init();
			tfTitle.setWidth( DEF_WIDTH - 10 );
			tfTitle.x = tfDate.x;
			tfTitle.y = body.y + DEF_DATE_HEIGHT + 5;
			addChild(tfTitle);

			var bodyHeight:uint = tfTitle.height + 10;

			if ( (moFact.urlMore != null) && (moFact.urlMore != "") ) {
				var tfLinkMore:TextApp = new TextApp("", TextFormats.TOOLTIP_MORE).init();
				tfLinkMore.htmlText = "<a href='" + moFact.urlMore + "' target='_blank'>" + LocaleString.TOOLTIP_MORE + "</a>";
				tfLinkMore.x = tfTitle.x;
				tfLinkMore.y = tfTitle.y + tfTitle.height + 5;
				addChild( tfLinkMore );

				bodyHeight += tfLinkMore.height + 5;
			}


			// text
			body.graphics.beginFill( 0xf2f0d5 );
			body.graphics.drawRect( 0, DEF_DATE_HEIGHT, DEF_WIDTH, bodyHeight/*DEF_BODY_HEIGHT*/ );
			body.graphics.endFill();
			// border
			body.graphics.lineStyle( 1, 0x9b9c7f, 1, true );
			body.graphics.drawRect( 0, 0, DEF_WIDTH, /*DEF_BODY_HEIGHT*/bodyHeight + DEF_DATE_HEIGHT );

			body.filters = [ new DropShadowFilter( 0, 0, 0x0, 0.3, 7, 7 ) ];


			return this;
		}

		override public function kill():void
		{
			moFact = null;

			super.kill();
		}
	}

}