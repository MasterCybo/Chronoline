package ru.arslanov.flash.interfaces {
	import flash.display.Graphics;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public interface IKillableContainer extends IKillableInteractive {
		
		function get graphics():Graphics;
		function set mouseChildren( value:Boolean ):void;
		function killChildren( startIdx:uint = 0, num:int = -1 ):void;
	}
	
}