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
		private var _removedMoFacts:Array/*MoFact.id*/ = [];
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

//			Log.traceText( "BEGIN =======================================> _moEntity.title : " + _moEntity.title );
//			Log.traceText( "    ...facts.length : " + _moEntity.facts.length );

//			var dh:Number = Display.stageHeight - Settings.TOOLBAR_HEIGHT;
			_minJD = MoTimeline.me.baseJD - _yCenter / MoTimeline.me.scale;
			_maxJD = MoTimeline.me.baseJD + _yCenter / MoTimeline.me.scale;


			var entHeight:Number = moEntity.duration * MoTimeline.me.scale;
			var div:Number = int( ( entHeight + Settings.ICON_SIZE ) / Settings.ICON_SIZE );
//			_spaceJD = _moEntity.duration / ( div / MoTimeline.me.scale );
			_spaceJD = _moEntity.duration / div;

//			Log.traceText( "entHeight : " + entHeight );
//			Log.traceText( "div : " + div );
//			Log.traceText( "_spaceJD = " + _spaceJD );

			_numDisplay = 0;

			takeMiddle( _moEntity.facts, 0, _moEntity.facts.length - 1 );

//			Log.traceText( "_mapDisplayMoFacts number objects : " + _numDisplay );

//			Log.traceText( "Ready to remove : " + _removedMoFacts.length );

			while ( _removedMoFacts.length ) {
				var fact:Fact = _host.getChildByName( "fact_" + _removedMoFacts.pop() ) as Fact;
				fact.kill();
			}

			var numDisplay:uint = 0;
			for each ( var moFact:MoFact in _mapDisplayMoFacts ) {
				var fact:Fact = _host.getChildByName( "fact_" + moFact.id ) as Fact;

				if ( !fact ) {
					fact = new Fact().init();
					fact.name = "fact_" + moFact.id;
					fact.x = _positionX;
					fact.initialize( moFact );
					fact.height = moFact.period.duration * MoTimeline.me.scale;
					_host.addChild( fact );

//					Log.traceText( "        moFact.title : " + moFact.title );
				}

				fact.y = getY( moFact );
//				Log.traceText( "            fact.y = " + fact.y + " (" + moFact.id + ") : " + moFact.title );
				numDisplay++;
			}

//			Log.traceText( "Displayed : " + numDisplay );

//			Log.traceText( "END ------------------> _moEntity.title : " + _moEntity.title );
		}

		private function takeMiddle( listFacts:Vector.<MoFact>, idx1:uint, idx2:uint ):void
		{
//			Log.traceText( "-" );

			idx1 = Math.min( idx1, idx2 ); // Индекс первого элемента
			idx2 = Math.max( idx1, idx2 ); // Индекс второго элемента
			
			if ( idx1 == idx2 ) return;

			// Проверяем по условию разности индексов
			if ( ( idx2 - idx1 ) <= 1 ) return;



			// Добавляем в отображение, если это первый и последний факты.
			var fact1:MoFact = listFacts[idx1];
			var fact2:MoFact = listFacts[idx2];

//			Log.traceText( "...idx1 " + "(" + fact1.id + ") = " + idx1 );
//			Log.traceText( "...idx2 " + "(" + fact2.id + ") = " + idx2 );
			if ( idx1 == 0 ) {
				if ( ( fact1.period.middle > _minJD ) && ( fact1.period.middle < _maxJD ) ) {
					if ( !_mapDisplayMoFacts[ fact1.id ] ) {
						_mapDisplayMoFacts[ fact1.id ] = fact1;
						_numDisplay++;

//						Log.traceText( "        + Add fact first " + idx1 + " (" + fact1.id + ")" );
					}
				} else {
					if ( _mapDisplayMoFacts[ fact1.id ] ) {
						_removedMoFacts.push( fact1.id );
						delete _mapDisplayMoFacts[ fact1.id ];
					}
				}
			}

			if ( idx2 == ( listFacts.length - 1 ) ) {
				if ( ( fact2.period.middle > _minJD ) && ( fact2.period.middle < _maxJD ) ) {
					if ( !_mapDisplayMoFacts[ fact2.id ] ) {
						_mapDisplayMoFacts[ fact2.id ] = fact2;
						_numDisplay++;

//						Log.traceText( "        + Add fact second " + idx2 + " (" + fact2.id + ")" );
					}
				} else {
					if ( _mapDisplayMoFacts[ fact2.id ] ) {
						_removedMoFacts.push( fact2.id );
						delete _mapDisplayMoFacts[ fact2.id ];
					}
				}
			}


			// Если между первым и вторым фактами помещается ещё один факт ( deltaJD21 >= 2 * _spaceJD ), то определяем промежуточный факт и проверяем его на добавление
			var deltaJD21:Number = fact2.period.middle - fact1.period.middle;

//			Log.traceText( "...delta " + idx2 + "-" + idx1 + " = " + deltaJD21 );

			var idx3:int = int( ( idx1 + idx2 ) / 2 );
			var fact3:MoFact = listFacts[ idx3 ];

			if ( deltaJD21 >= ( 2 * _spaceJD ) ) {

//				Log.traceText( "...idx3 " + "(" + fact3.id + ") = " + idx3 );

//				Log.traceText( "...deltaJD 2-3 = " + deltaJD23 );
//				Log.traceText( "deltaPX31 = " + (deltaJD31 * MoTimeline.me.scale), "deltaPX23 = " + (deltaJD23 * MoTimeline.me.scale) );

				if ( ( fact3.period.middle > _minJD ) && ( fact3.period.middle < _maxJD ) ) {
					var deltaJD31:Number = fact3.period.middle - fact1.period.middle;
					var deltaJD23:Number = fact2.period.middle - fact3.period.middle;

//					Log.traceText( "...deltaJD " + idx3 + " - " + idx1 + " = " + deltaJD31 );
//					Log.traceText( "...deltaJD " + idx2 + " - " + idx3 + " = " + deltaJD23 );
					if ( ( deltaJD31 >= _spaceJD ) && ( deltaJD23 >= _spaceJD ) ) {
						if ( !_mapDisplayMoFacts[ fact3.id ] ) {
							_mapDisplayMoFacts[ fact3.id ] = fact3;
							_numDisplay++;
//
//							Log.traceText( "        Add fact middle " + idx3 + " (" + fact3.id + ")" );
						}

					} else {
						if ( _mapDisplayMoFacts[ fact3.id ] ) {
							_removedMoFacts.push( fact3.id );
							delete _mapDisplayMoFacts[ fact3.id ];
						}
					}
				} else {
					if ( _mapDisplayMoFacts[ fact3.id ] ) {
						_removedMoFacts.push( fact3.id );
						delete _mapDisplayMoFacts[ fact3.id ];
					}
				}


				// Если один из фактов попал в список отображения, тогда рекрсивно продолжаем определять средние факты.
//				if ( _mapDisplayMoFacts[ fact1.id ] || _mapDisplayMoFacts[ fact3.id ] ) {
					takeMiddle( listFacts, idx1, idx3 );
//				}

//				if ( _mapDisplayMoFacts[ fact3.id ] || _mapDisplayMoFacts[ fact2.id ] ) {
					takeMiddle( listFacts, idx3, idx2 );
//				}
			} else {
				if ( _mapDisplayMoFacts[ fact3.id ] ) {
					_removedMoFacts.push( fact3.id );
					delete _mapDisplayMoFacts[ fact3.id ];
				}
			}

//			takeMiddle( listFacts, idx1, idx3 );
//			takeMiddle( listFacts, idx3, idx2 );
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
