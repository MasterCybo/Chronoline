package display.objects
{

	import data.MoEntity;

	import display.components.TitleEntity;

	import flash.filters.DropShadowFilter;

	import flash.filters.GlowFilter;

	import ru.arslanov.core.filters.ColorAdjust;

	import ru.arslanov.flash.display.ASprite;

	/**
	 * Сущность хроноленты
	 * @author Artem Arslanov
	 */
	public class Entity extends ASprite
	{
		private var _moEntity:MoEntity;
		private var _body:EntityView;

		public function Entity( moEntity:MoEntity )
		{
			_moEntity = moEntity;

			this.name = "ent_" + moEntity.id;

			super();
		}

		override public function init():*
		{
			super.init();

			_body = new EntityView( moEntity, 1, App.entityColorPalette.getNextColor() ).init();
			var title:TitleEntity = new TitleEntity(moEntity.title).init();
			title.setXY( -title.width, 0 );
			
			addChild( title );
			addChild( _body );

			var colorize:ColorAdjust = new ColorAdjust( ColorAdjust.CLEAR );
			colorize.colorize( _body.color, 1 );
			
			var border:GlowFilter = new GlowFilter( _body.color, 1, 1.5, 1.5, 3, 3, true );
			
			_body.filters = [border, new DropShadowFilter( 0, 0, 0x0, 0.30, 3, 3, 1, 3 ), colorize.filter];

//			var colorInfo:ColorTransform = this.transform.colorTransform;
//			colorInfo.redMultiplier = 10;
//			this.transform.colorTransform = colorInfo;

			return this;
		}

		public function get moEntity():MoEntity
		{
			return _moEntity;
		}

		override public function set height( value:Number ):void
		{
			if ( value == _body.height ) return;

			_body.height = value;
		}

		public function setHeight( heightValue:Number, offsetY:Number = 0 ):void
		{
			_body.setHeight( heightValue, offsetY );
		}

		public function get body():EntityView
		{
			return _body;
		}

		override public function kill():void
		{
			super.kill();

			_moEntity = null;
		}
	}

}
