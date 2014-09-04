package ru.arslanov.core.collection.linkedlist {
	
	/**
	* ...
	* @author Artem Arslanov
	*/
	public interface ILinkedNode {
		function set value( value:* ):void;
		function get value():*;
		
		function get prev():ILinkedNode;
		function set prev( value:ILinkedNode ):void;
		
		function get next():ILinkedNode;
		function set next( value:ILinkedNode ):void;
		
		function addNext( node:ILinkedNode ):ILinkedNode; // put - класть, положить
		function addPrev( node:ILinkedNode ):ILinkedNode; // push - протолкнуть, пихать
		
		function clone():ILinkedNode;
		function apart():ILinkedNode; // Вырезает текущий нод из списка
		function dispose():void;
	}
	
}