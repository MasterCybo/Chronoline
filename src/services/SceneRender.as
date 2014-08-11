/**
 * Created by Artem on 07.08.2014.
 */
package services
{
	import collections.EntityManager;

	import data.MoEntity;

	import data.MoTimeline;

	import flash.utils.Dictionary;

	import ru.arslanov.core.utils.Log;

	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class SceneRender
	{
		private var _visEntities:Dictionary;
		private var _facts:Dictionary;
		private var _bonds:Dictionary;
		
		private var _halfHeight:Number;
		private var _scale:Number;
		private var _baseJD:Number;
		
		
		public function SceneRender()
		{
		}

		public function update():void
		{
			Log.traceText( "*execute* SceneRender.update" );
			
			var height:Number = Display.stageHeight - Settings.TOOLBAR_HEIGHT;
			var moTimeline:MoTimeline = MoTimeline.me;
			var beginJD:Number = moTimeline.beginJD;
			var endJD:Number = moTimeline.endJD;
			_baseJD = moTimeline.baseJD;
			_scale = moTimeline.scale;
			_halfHeight = height / 2;

			var minJD:Number = _baseJD - _halfHeight * _scale; // Верхняя экранная временная граница (меньшее значение)
			var maxJD:Number = _baseJD + _halfHeight * _scale; // Нижняя экранная временная граница (большее значение)
			
			Log.traceText( "_scale : " + _scale );
			Log.traceText( "_baseJD : " + _baseJD );
			Log.traceText( "minJD - maxJD : " + minJD + " - " + maxJD );
			
			_visEntities = new Dictionary( true );
			
			var arrMoEnts:Array = EntityManager.getArrayEntities();
			var moEnt:MoEntity;

			for each ( moEnt in arrMoEnts ) {
//				var yy:Number = getY( moEnt.beginPeriod.beginJD );
//				var hh:Number = getHeight( moEnt.beginPeriod.beginJD, moEnt.endPeriod.endJD );

				if ( ( moEnt.beginPeriod.beginJD > minJD ) && ( beginJD < maxJD ) ) {
					
				}
			}
			
		}
		
		private function getY( jd:Number ):Number
		{
			return Math.max( 0, _halfHeight + _scale * ( jd - MoTimeline.me.baseJD ) );
		}

		private function getHeight( beginJD:Number, endJD:Number ):Number
		{
			var deltaCenterJD:Number = _halfHeight / _scale;
			var beginJD:Number = Math.max( beginJD, _baseJD - deltaCenterJD );
			var endJD:Number = Math.min( _baseJD + deltaCenterJD, endJD );

			return _scale * (endJD - beginJD);
		}
	}
}
