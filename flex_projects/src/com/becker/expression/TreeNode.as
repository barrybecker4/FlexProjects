package com.becker.expression {
    /**
     * A node in a binary tree. 
     * Contains either a operator (non-leaf) or operand (at leaf).
     * 
     * @author Barry Becker
     */
    public class TreeNode {
        
        /** child nodes if any */
        public var children:Array = [];
        
        /** if true then the sup expression represented by this node has parenthesis around it */
        public var hasParens:Boolean;
        
        /** either an operator or an operand */
        private var _data:String;
        
 
        /**
         * Constructor
         * @param	value data value - either an operator or an operand.
         */
        public function TreeNode(value:String) { 
            _data = value;
        }
        
        public function get data():String {
            return _data;
        }
         
        public function toString():String {
            return _data; 
        }
        
        /** @return true if the specified node is an operator */
        public function isOperator():Boolean {
            return !hasParens && Operators.isOperator(data);
        }
    }
}