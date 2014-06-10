package controllers
{
	import data.MoEntity;
	import data.MoFact;
	import data.MoTimeline;

	import display.objects.Entity;

	import display.objects.Fact;

	import events.TimelineEvent;

	import flash.utils.Dictionary;

	import ru.arslanov.core.utils.Log;

	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class FactsRender
	{
		private var _host:ASprite;
		private var _height:Number;

		private var _mapRenders:Dictionary/*FactsEntityRender*/ = new Dictionary( true ); // MoEntity.id = FactsEntityRender


		public function FactsRender( host:ASprite, height:Number )
		{
			_host = host;
			_height = height;
		}

		public function init():void
		{

		}

		public function update( visibleEntities:Dictionary/*Entity*/ ):void
		{
			// Удаляем устаревшие рендеры
			for each ( var fer:FactsEntityRender in _mapRenders ) {
				if ( !visibleEntities[ fer.moEntity.id ] ) {
					Log.traceText( "- Remove facts render : " + fer.moEntity.title );
					delete _mapRenders[ fer.moEntity.id ];
					fer.dispose();
				}
			}

			// Добавляем новые
			for each ( var ent:Entity in visibleEntities ) {
				if ( !_mapRenders[ ent.moEntity.id ] ) {
					Log.traceText( "+ Add facts render : " + ent.moEntity.title );
					_mapRenders[ ent.moEntity.id ] = new FactsEntityRender( _host, ent.moEntity, ent.x, _height );
				}
			}


			for each ( var fer2:FactsEntityRender in _mapRenders ) {
				fer2.update();
			}
		}

		public function get visibleFacts():Dictionary
		{
			return null;
		}

		public function dispose():void
		{
			for each ( var fer:FactsEntityRender in _mapRenders ) {
				fer.dispose();
			}

			_mapRenders = null;
			_host = null;
		}
	}

}