package controllers
{
	import display.objects.Entity;

	import flash.utils.Dictionary;

	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class EntityFactsRender
	{
		private var _host:ASprite;
		private var _height:Number;

		private var _mapFactsRenders:Dictionary/*FactsRender*/ = new Dictionary( true ); // MoEntity.id = FactsRender


		public function EntityFactsRender( host:ASprite, height:Number )
		{
			_host = host;
			_height = height;
		}

		public function init():void
		{
		}

		public function reset():void
		{
			var fer:FactsRender;
			// Удаляем устаревшие рендеры
			for each ( fer in _mapFactsRenders ) {
				fer.dispose();
			}
			_mapFactsRenders = new Dictionary( true );
		}

		public function update( visibleEntities:Dictionary/*Entity*/ ):void
		{
			var fer:FactsRender;

			// Удаляем устаревшие рендеры
			for each ( fer in _mapFactsRenders ) {
				if ( !visibleEntities[ fer.moEntity.id ] ) {
//					Log.traceText( "- Remove facts render : " + fer.moEntity.title );
					delete _mapFactsRenders[ fer.moEntity.id ];
					fer.dispose();
				}
			}

			// Добавляем новые
			for each ( var ent:Entity in visibleEntities ) {
				if ( !_mapFactsRenders[ ent.moEntity.id ] ) {
//					Log.traceText( "+ Add facts render : " + ent.moEntity.title );
					_mapFactsRenders[ ent.moEntity.id ] = new FactsRender( _host, ent.moEntity, ent.x, _height );
				}
			}

			// Обновляем рендеры каждой сущности
			for each ( fer in _mapFactsRenders ) {
				fer.update();
			}
		}

		public function dispose():void
		{
			for each ( var fer:FactsRender in _mapFactsRenders ) {
				fer.dispose();
			}

			_mapFactsRenders = null;
			_host = null;
		}
	}

}