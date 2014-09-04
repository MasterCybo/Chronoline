package ru.arslanov.flash.interfaces {
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.IBitmapDrawable;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public interface IKillable extends IBitmapDrawable {
		
		function init():*;
		
		function get isInited():Boolean;
		function get isKilled():Boolean;
		
		function get height():Number;
		function set height( value:Number ):void;
		
		function get width():Number;
		function set width( value:Number ):void;
		
		function get x():Number;
		function set x( value:Number ):void;
		
		function get y():Number;
		function set y( value:Number ):void;
		
		function setXY( x:Number, y:Number, rounded:Boolean = true ):void;
		function setSize( width:Number, height:Number, rounded:Boolean = true ):void;
		
		function getBounds( space:DisplayObject ):Rectangle;
		function getRect( space:DisplayObject ):Rectangle;
		
		function kill():void;
		
		function get uid():Number;
		function get uidStr():String;
	}
	
}