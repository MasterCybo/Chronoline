/**
 * Created by aa on 30.05.2014.
 */
package controllers
{
	import data.MoEntity;
	import data.MoFact;
	import data.MoTimeline;

	import display.objects.Fact;

	import flash.utils.Dictionary;

	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class FactsEntityRender
	{
		public var enabled:Boolean = true;

		private var _host:ASprite;
		private var _moEntity:MoEntity;
		private var _height:Number;
		private var _minJD:Number;
		private var _maxJD:Number;
		private var _positionX:Number;
		private var _numDisplay:uint = 0;

		private var _mapDisplayMoFacts:Dictionary/*Fact*/ = new Dictionary( true ); // MoFact.id = Fact
		private var _spaceJD:Number;
		private var _yCenter:Number;

		public function FactsEntityRender( host:ASprite, moEntity:MoEntity, positionX:Number, height:Number )
		{
			_host = host;
			_positionX = positionX;
			_moEntity = moEntity;
			_height = height;
			_yCenter = height / 2;
		}

		public function update():void
		{
			if ( !enabled ) return;

			Log.traceText( "BEGIN =======================================> _moEntity.title : " + _moEntity.title );

//			var dh:Number = Display.stageHeight - Settings.TOOLBAR_HEIGHT;
			_minJD = MoTimeline.me.baseJD - _yCenter / MoTimeline.me.scale;
			_maxJD = MoTimeline.me.baseJD + _yCenter / MoTimeline.me.scale;


			var entHeight:Number = moEntity.duration * MoTimeline.me.scale;
			var div:Number = int( ( entHeight + Settings.ICON_SIZE ) / Settings.ICON_SIZE );
			_spaceJD = _moEntity.duration / ( div / MoTimeline.me.scale );

			Log.traceText( "_spaceJD : " + _spaceJD );


			takeMiddle( _moEntity.facts, _moEntity.facts[ 0 ], _moEntity.facts[ _moEntity.facts.length - 1 ] );

			Log.traceText( "    _mapDisplayMoFacts number objects : " + _numDisplay );

			for each ( var moFact:MoFact in _mapDisplayMoFacts ) {
				var fact:Fact = _host.getChildByName( "fact_" + moFact.id ) as Fact;

				if ( !fact ) {
					fact = new Fact().init();
					fact.name = "fact_" + moFact.id;
					fact.x = _positionX;
					fact.initialize( moFact );
					fact.height = Math.max( 1, moFact.period.duration * MoTimeline.me.scale );
					_host.addChild( fact );

					Log.traceText( "        moFact.title : " + moFact.title );
					Log.traceText( "            fact.y : " + fact.y );
				}

				fact.y = getY( moFact );
			}

			Log.traceText( "END ------------------> _moEntity.title : " + _moEntity.title );
		}

		private function takeMiddle( listFacts:Vector.<MoFact>, f1:MoFact, f2:MoFact ):void
		{
//			Log.traceText( " " );

			if ( f1 == f2 ) return;


			// Проверяем по условию разности индексов
			var idx1:int = listFacts.indexOf( f1 );
			var idx2:int = listFacts.indexOf( f2 );

			idx1 = Math.min( idx1, idx2 ); // Индекс первого элемента
			idx2 = Math.max( idx1, idx2 ); // Индекс второго элемента

			if ( ( idx2 - idx1 ) <= 1 ) return;


			// Проверка по условию: разница между фактами должна быть больше значения _spaceJD
			var deltaJD21:Number = f2.period.middle - f1.period.middle;
//
			if ( deltaJD21 >= _spaceJD  ) {
				if ( ( f1.period.middle > _minJD ) && ( f1.period.middle < _maxJD ) ) {
					if ( !_mapDisplayMoFacts[ f1.id ] ) {
						_mapDisplayMoFacts[ f1.id ] = f1;
						_numDisplay++;

						Log.traceText( "        Add fact first " + f1.id );
					}
				}

				if ( ( f2.period.middle > _minJD ) && ( f2.period.middle < _maxJD ) ) {
					if ( !_mapDisplayMoFacts[ f2.id ] ) {
						_mapDisplayMoFacts[ f2.id ] = f2;
						_numDisplay++;

						Log.traceText( "        Add fact second " + f2.id );
					}
				}
			}


			// Проверка по условию: помещается ли между фактами ещё один факт - 2*_spaceJD
			if ( deltaJD21 >= ( 2 * _spaceJD )  ) {
				var idx3:int = int( ( idx1 + idx2 ) / 2 );
				var f3:MoFact = listFacts[ idx3 ];

				var deltaJD31:Number = f3.period.middle - f1.period.middle;
				var deltaJD23:Number = f2.period.middle - f3.period.middle;

				if ( ( deltaJD31 > _spaceJD ) && ( deltaJD23 > _spaceJD ) ) {
					if ( ( f3.period.middle > _minJD ) && ( f3.period.middle < _maxJD ) ) {
						if ( _mapDisplayMoFacts[ f3.id ] ) {
							_mapDisplayMoFacts[ f3.id ] = f3;
							_numDisplay++;

							Log.traceText( "        Add fact middle " + f3.id );
						}
					}
				}
			}


			//
			if ( _mapDisplayMoFacts[ f3.id ] || _mapDisplayMoFacts[ f2.id ] ) {
				takeMiddle( listFacts, f3, f2 );
			}

			if ( _mapDisplayMoFacts[ f1.id ] || _mapDisplayMoFacts[ f3.id ] ) {
				takeMiddle( listFacts, f1, f3 );
			}
		}

		private function getY( moFact:MoFact ):Number
		{
			return _yCenter + MoTimeline.me.scale * ( moFact.period.beginJD - MoTimeline.me.baseJD );
		}

		public function get moEntity():MoEntity
		{
			return _moEntity;
		}

		public function clear():void
		{
			_mapDisplayMoFacts = new Dictionary( true );
			_numDisplay = 0;
		}

		public function dispose():void
		{
			_host = null;
			_moEntity = null;
			_mapDisplayMoFacts = null;
			_numDisplay = 0;
		}
	}
}
