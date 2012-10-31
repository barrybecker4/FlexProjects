package com.becker.expression {
    
    import mx.controls.Alert;
    
    /**
     * Creates a tree from a text representation of an expression that
     * is written in terms of x.
     * 
     * @author Barry Becker
     */
    public class Expression {
        
        /** root of the binary tree representing the expression */
        private var _rootNode:TreeNode;
        private var _isValid:Boolean = false;
        
        /** 
         * Constructor 
         * @param expressionText the expression in text form. It will be parsed.
         */
        public function Expression(expressionText:String) {
            
            try {
               _rootNode = new ExpressionParser().parse(expressionText);
               _isValid = true;
            }
            catch (e:Error) {
                _isValid = false;
                Alert.show("Error: " + e.message);
            }
        }
        
        public function get isValid():Boolean {
            return _isValid;
        }
        
        public function get rootNode():TreeNode {
            return _rootNode;
        }

        public function toString():String {   
            return new TreeSerializer().serialize(_rootNode);
        }
    }
}