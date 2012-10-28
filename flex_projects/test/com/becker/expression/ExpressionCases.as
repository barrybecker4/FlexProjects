package com.becker.expression {
	/**
     * ...
     * @author Barry Becker
     */
    public class ExpressionCases {
        
        public static const CASES:Array = [
            "x",
            "-5",
            "-x",
            "x*x",
            "x*-x",
            "x^x-3x",
            "x^-x-3x",
            "-x*x",
            "x*x*x",
            "x^2",
            "x^3 - x^3",
            "x-2",
            "2-x",
            "5x",
            "1/6x",
            "3x - 1",
            "(2x + 1) - 3",
            "3(6x - 2)",
            "(3 + x) - (x - 2)",
            "3x - 2x^-2",
            "-3x^2 - 1",
            "4 --4",
            "2(x + 1)(x-1)",
            "-3x + (4x^2 - 5) / (x^-3 + x^2 - (1/x + 4)) (x + 1)",
            "(3 + 2(x + 3x^(5+x))/ 2x) - 4x(3+1/x)^(2x(8-x))",
            "-1 - -2(4 + x)",
            "(1/6x)^(2(x + 3(x^2/3) -1))"
        ];
        
        
        public static const NEGATIVE_CASES:Array = [
            "a",
            "xx",
            "*",
            "1+",
            "x-*x",
            "^x",
            "x-^2",
            "4 ---4",
        ];
        
    }

}