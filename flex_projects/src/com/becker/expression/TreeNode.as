package com.becker.expression {
	/**
     * A node in a binary tree. 
     * Contains either a operator (non-leaf) or operand (at leaf).
     * 
     * @author Barry Becker
     */
    public class TreeNode {
        
        public var children:Array = [];
        private var _data:String;
        
 
        public function TreeNode(value:String) {
            
            _data = value;
        }
        
        public function get data():String {
            return _data;
        }
        
        public function toString():String {
            return _data; 
        }
    }

}