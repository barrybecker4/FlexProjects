package com.becker.expression {
    
    /**
     * Evaluates an expressoin
     * 
     * @author Barry Becker
     */
    public class ExpressionEvaluator {
        
        private var _exp:Expression;
        
        private var ymin:Number;
        private var ymax:Number;
        
        /**
         * Constructor
         * @param exp the expression to evaluate
         */
        public function ExpressionEvaluator(exp:Expression) {
            _exp = exp;
        }
        
        /** 
         * Prevent the range from exceeding certain limits or the graph will not look good
         * when y values go off to infinity.
         */
        public function setRangeLimits(yMin:Number, yMax:Number):void {
            this.ymin = yMin;
            this.ymax = yMax;
        }
        
        /**
         * Evaluate the expression
         * @param  x a real value to plug in for x.
         * @return the result of evaluating the expression with x.
         */
        public function evaluate(x:Number):Number {
            var result:Number = eval(x, _exp.rootNode);
            if (ymin) {
                result = (result < ymin || result > ymax) ? NaN : result;
            }
            return result;
        }
        
        /** 
         * Recursive traversal of the ecpression tree nodes to evaluate 
         */
        private function eval(x:Number, node:TreeNode):Number {

            if (node.children.length == 2) {
                // parent nodes are always operators
                var operand1:Number = eval(x, node.children[0]);
                var operand2:Number = eval(x, node.children[1]);
                return Operators.operate(node.data, operand1, operand2);
            }
            // leaf nodes are always an operand
            return node.data == 'x' ? x : parseFloat(node.data);
        }
    }
}