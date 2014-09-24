/**
 * Copyright (c) 2014 SmartHead. All rights reserved.
 */
package display.gui
{
	import constants.LocaleString;
	import constants.TextFormats;

	import data.MoEntity;

	import display.base.TextApp;

	import flash.filters.DropShadowFilter;

	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;

	import ru.arslanov.flash.gui.hints.ATooltip;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class EntityTooltip extends ATooltip
	{
		static private const DEF_DATE_HEIGHT:uint = 25;

		public function EntityTooltip( data:MoEntity )
		{
			super( data );
		}

		public function get moEntity():MoEntity { return _data as MoEntity; }

		override public function init():*
		{
			var dateText:String = JDUtils.getFormatString( moEntity.beginPeriod.beginJD, LocaleString.DATE_TEMPLATE_SHORT )
					+ " — "
					+ JDUtils.getFormatString( moEntity.endPeriod.endJD, LocaleString.DATE_TEMPLATE_SHORT );


			var tfTitle:TextApp = new TextApp( moEntity.title, TextFormats.TOOLTIP_DATE ).init();
//			tfTitle.setWidth( DEF_WIDTH - 10 );

			var tfDate:TextApp = new TextApp( dateText, TextFormats.TOOLTIP_TITLE ).init();


			var body:ASprite = new ASprite();
			var bodyHeight:uint = tfTitle.height + 10;
			var bodyWidth:uint = Math.max( tfTitle.width, tfDate.width ) + 10;

			// header
			body.graphics.beginFill( 0xc5c6ac );
			body.graphics.drawRect( 0, 0, bodyWidth, DEF_DATE_HEIGHT );
			body.graphics.endFill();
			// text
			body.graphics.beginFill( 0xf2f0d5 );
			body.graphics.drawRect( 0, DEF_DATE_HEIGHT, bodyWidth, bodyHeight/*DEF_BODY_HEIGHT*/ );
			body.graphics.endFill();
			// border
			body.graphics.lineStyle( 1, 0x9b9c7f, 1, true );
			body.graphics.drawRect( 0, 0, bodyWidth, /*DEF_BODY_HEIGHT*/bodyHeight + DEF_DATE_HEIGHT );


			tfTitle.x = body.x + 5;
			tfTitle.y = body.y + (DEF_DATE_HEIGHT - tfDate.height) / 2;

			tfDate.x = tfTitle.x;
			tfDate.y = body.y + DEF_DATE_HEIGHT + 5;


			body.filters = [ new DropShadowFilter( 0, 0, 0x0, 0.3, 7, 7 ) ];

			addChild( body );
			addChild( tfTitle );
			addChild( tfDate );

			return this;
		}
	}
}
