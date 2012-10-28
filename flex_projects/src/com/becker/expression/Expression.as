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
        private var expRoot:TreeNode;
        private var _isValid:Boolean = false;
        
        /** 
         * Constructor 
         * @param expressionText the expression in text form. It will be parsed.
         */
        public function Expression(expressionText:String) {
            
            try {
               expRoot = new ExpressionParser().parse(expressionText);
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
            return new TreeSerializer().serialize(expRoot);
        }
    }
}