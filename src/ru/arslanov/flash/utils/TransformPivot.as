package ru.arslanov.flash.utils {
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * Класс трансформации DisplayObject относительно заданной точки Pivot Point
	 * @author Artem Arslanov
	 */
	public class TransformPivot {
		
		private var _target:DisplayObject;
		private var _pivotPoint:Point;
		private var _targetPoint:Point;
		private var _rotation:Number = 0;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		private var _scale:Number = 1;
		
		public function TransformPivot( target:DisplayObject, pivotPoint:Point = null ) {
			_target = target;
			
			_rotation = _target.rotation;
			_scaleX = _target.scaleX;
			_scaleY = _target.scaleY;
			
			this.pivotPoint = pivotPoint ? pivotPoint : new Point();
		}
		
		// Точка "регистрации", начало координат в координатной плоскости визуального объекта.
		public function get pivotPoint():Point {
			return _pivotPoint;
		}
		
		public function set pivotPoint( value:Point ):void {
			_pivotPoint = value;
			_targetPoint = _target.parent.globalToLocal( _target.localToGlobal( pivotPoint ) );
		}
		
		public function set pivotX( value:Number ):void {
			_pivotPoint.x = value;
			
			updateMatrix();
		}
		
		public function get pivotX():Number {
			return _pivotPoint.x;
		}
		
		public function set pivotY( value:Number ):void {
			_pivotPoint.y = value;
			
			updateMatrix();
		}
		
		public function get pivotY():Number {
			return _pivotPoint.y;
		}
		
		private function updateMatrix():void {
			const matrix:Matrix = new Matrix();
			
			matrix.identity();
			matrix.translate( -pivotPoint.x, -pivotPoint.y ); // Применили точку регистрации.
			matrix.scale( _scaleX, _scaleY ); // Предположим, что мы немножко повернули объект относительно точки регистрации.
			matrix.rotate( _rotation ); // Предположим, что мы немножко повернули объект относительно точки регистрации.
			matrix.translate( _targetPoint.x, _targetPoint.y ); // Поместили в заданные координаты относительно контейнера.
			_target.transform.matrix = matrix;
		}
		
		/***************************************************************************
		Вращение
		***************************************************************************/
		public function get rotation():Number {
			return _rotation;
		}
		
		public function set rotation( value:Number ):void {
			_rotation = value;
			updateMatrix();
		}
		
		/***************************************************************************
		Масштабирование пропорциональное
		***************************************************************************/
		public function get scale():Number {
			//return _scale;
			//return (_target.scaleX + _target.scaleY) / 2;
			return _target.scaleX;
		}
		
		public function set scale( value:Number ):void {
			_scale = _scaleX = _scaleY = value;
			updateMatrix();
		}
		
		/***************************************************************************
		Масштабирование по осям
		***************************************************************************/
		public function get scaleX():Number {
			return _scaleX;
		}
		
		public function set scaleX( value:Number ):void {
			_scaleX = value;
			updateMatrix();
		}
		
		public function get scaleY():Number {
			return _scaleY;
		}
		
		public function set scaleY( value:Number ):void {
			_scaleY = value;
			updateMatrix();
		}
		
		public function dispose():void {
			_target = null;
			_pivotPoint = null;
			_targetPoint = null;
		}
	}

}