package com.becker.expression {
    
    import mx.controls.Alert;
    
    /**
     * Creates a tree from a text representation of an expression that
     * is written in terms of x.
     * 
     * @author Barry Becker
     */
    public class Expression {
        
        private var expRoot:TreeNode;
        private var _isValid:Boolean = false;
        
        
        /** 
         * Constructor 
         * @param expressionText the expression in text form. It will be parsed.
         */
        public function Expression(expressionText:String) {
            
            var parser:ExpressionParser = new ExpressionParser();
            try {
               expRoot = parser.parse(expressionText);
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
        
        /**
         * Evaluate the expression give a value for x.
         * @param x the value to plug in for x.
         * @return result of evaluation.
         */
        public function evaluate(x:Number):Number {
            return x;
        }
        

        public function toString():String {
            
            return expRoot ? print(expRoot) : "Invalid";
        }
        
        /** recursive in order traversal of the tree */
        private function print(node:TreeNode):String {
            
            var text:String = "";
            
            if (node.children.length == 2) {
                text += print(node.children[0]);
                text += " " + node.data + " ";
                text += print(node.children[1]);
            }
            else {
                text += node.data;
            }
            trace("returning " + text);
            return text;
        }
        
    }

}