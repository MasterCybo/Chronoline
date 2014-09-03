package display.objects
{

	import data.MoEntity;

	import display.components.TitleEntity;

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
