package ru.arslanov.core.collection.linkedlist {
	/**
	* ...
	* @author Artem Arslanov
	*/
	public class LinkedNode implements ILinkedNode {
		
		private var _prev:ILinkedNode;
		private var _next:ILinkedNode;
		private var _value:*;
		
		public function LinkedNode( value:* ) {
			this.value = value;
		}
		
		/* INTERFACE ru.arslanov.core.collection.ILinkedNode */
		
		public function set value( value:* ):void {
			_value = value;
		}
		
		public function get value():* {
			return _value;
		}
		
		public function set prev( node:ILinkedNode ):void {
			_prev = node;
		}
		
		public function set next( node:ILinkedNode ):void {
			_next = node;
		}
		
		public function get prev():ILinkedNode {
			return _prev;
		}
		
		public function get next():ILinkedNode {
			return _next;
		}
		
		/**
		* Присоединить после
		* @param node
		*/
		public function addNext( node:ILinkedNode ):ILinkedNode {
			node.prev = this;
			node.next = next;
			
			if ( next ) next.prev = node;
			next = node;
			
			return node;
		}
		
		/**
		* Вставить перед
		* @param node
		*/
		public function addPrev( node:ILinkedNode ):ILinkedNode {
			node.prev = prev;
			node.next = this;
			
			if ( prev ) prev.next = node;
			prev = node;
			
			return node;
		}
		
		/**
		* Вырезать нод из списка
		*/
		public function apart():ILinkedNode {
			if ( prev ) prev.next = next;
			if ( next ) next.prev = prev;
			
			_prev = null;
			_next = null;
			
			return this;
		}
		
		public function clone():ILinkedNode {
			var node:LinkedNode = new LinkedNode( value );
			node.prev = prev;
			node.next = next;
			
			return node;
		}
		
		public function dispose():void {
			apart();
			
			value = null;
		}
	}

}