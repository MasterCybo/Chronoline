package controllers {
	import data.MoTimeline;
	import events.TimelineEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import ru.arslanov.core.events.EventManager;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	/**
	* ...
	* @author Artem Arslanov
	*/
	public class Render {
		
		public var onRenderComplete:Function;
		
		private var _entsRender:EntitiesRender;
		private var _factsRender:FactsRender;
		private var _bondsRender:BondsRender;
		
		private var _host:ASprite;
		private var _viewportRect:Rectangle;
		
		public function Render( host:ASprite, viewportRect:Rectangle ) {
			_host = host;
			_viewportRect = viewportRect;
		}
		
		public function start():void {
			_entsRender = new EntitiesRender( _host, _viewportRect );
			_factsRender = new FactsRender( _host, _viewportRect );
			_bondsRender = new BondsRender( _host, _viewportRect );
			
			_entsRender.onRenderComplete = onRenderEntities;
			_factsRender.onRenderComplete = onRenderFacts;
			_bondsRender.onRenderComplete = onRenderBonds;
			
			_entsRender.start();
			_factsRender.start();
			_bondsRender.start();
			
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.TIMELINE_RESIZE, onTimelineChange );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_RESIZE, onTimelineChange );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_MOVE, onTimelineChange );
		}
		
		private function onTimelineChange( ev:TimelineEvent ):void {
			render();
		}
		
		public function render():void {
			_entsRender.render();
		}
		
		private function onRenderEntities(  ):void {
			_factsRender.render( _entsRender.getDisplayedMoEntities() );
		}
		
		private function onRenderFacts(  ):void {
			_bondsRender.render();
		}
		
		private function onRenderBonds(  ):void {
			//Log.traceText( "*execute* Render.onRenderBonds" );
		}
		
		public function dispose():void {
			onRenderComplete = null;
			
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.TIMELINE_RESIZE, onTimelineChange );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.RANGE_RESIZE, onTimelineChange );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.RANGE_MOVE, onTimelineChange );
			
			_entsRender.dispose();
			_factsRender.dispose();
			_bondsRender.dispose();
		}
	}

}