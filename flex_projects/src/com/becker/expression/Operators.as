package com.becker.expression {
    
    /**
     * the expected binary operators in the text expression.
     * 
     * @author Barry Becker
     */
    public class Operators {
        
        public static const EXPONENT:String = '^';
        public static const TIMES:String = '*';
        public static const DIVIDE:String = '/';
        public static const PLUS:String = '+';
        public static const MINUS:String = '-';
        
        /** 
         * Defines the order of precedence for the operators
         * This at the same level are evaluated from left to right.
         */
        public static const OPERATOR_PRECEDENCE:Array = [
            [EXPONENT],
            [TIMES, DIVIDE],
            [PLUS, MINUS]
        ];
        
        
        /** @return true if the last node is an operator or there were no previous nodes */
        public static function isLastNodeOperator(nodes:Array):Boolean {
            return nodes.length == 0 || nodes[nodes.length - 1].isOperator();
        }
        
        /** @return true if the specified character is an operator */
        public static function isOperator(ch:String):Boolean {
            return ch == PLUS || ch == MINUS || ch == TIMES || ch == DIVIDE || ch == EXPONENT;
        }
    }

}