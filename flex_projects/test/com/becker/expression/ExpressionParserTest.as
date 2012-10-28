package com.becker.expression {
    
    import com.becker.common.BaseTest;
    import com.becker.expression.TreeSerializer;
    import com.becker.expression.TreeNode;
    import mx.controls.Alert;
    
    /**
     * Tests for ExpressionParser
     * 
     * @author Barry Becker
     */
    public class ExpressionParserTest extends BaseTest {
        
        /** instance under test */
        private var parser:ExpressionParser = new ExpressionParser();
        
        private static const CASES:Array = [
            "x",
            "x*x",
            "x^2",
            "x-2",
            "2-x",
            "5x",
            "3x - 1",
            "(2x + 1) - 3",
            "3(6x - 2)",
            "(3 + x) - (x - 2)",
            "3x - 2x^-2",
            "-3x^2 - 1",
            "4 --4",
            "2(x + 1)(x-1)",
            "-3x + (4x^2 - 5) / (x^-3 + x^2 - (1/x + 4)) (x + 1)",
            "(3 + 2(x + 3x^(5+x))/ 2x) - 4x(3+1/x)^(2x(8-x))"
        ];
        
        private static const NEGATIVE_CASES:Array = [
            "a",
            "xx",
            "^x",
            "x-^2",
            "4 ---4",
        ];
        
        public function ExpressionParserTest() {
        }
        
        public function run():String {
            
            var log:String  = runPositiveTests();
            log += runNegativeTests();
            return log;
        }
        
        public function runPositiveTests():String {
            
            var log:String = "\nnow running positive tests...\n";
            var root:TreeNode;
            
            for each (var testCase:String in CASES) {
                try {
                    root = parser.parse(testCase);
                    log += new TreeSerializer().serialize(root);
                } catch (e:Error) {
                    log += "Failed for case="+ testCase + "\n  " + e.message;
                }
                log += "\n";
            }
            return log;
        }
        
        public function runNegativeTests():String {
            
            var log:String = "\nnow running negative tests...\n";
            var root:TreeNode;
            
            for each (var testCase:String in NEGATIVE_CASES) {
                try {
                    root = parser.parse(testCase);
                    log += "<b>Failed: Did no get any error for case " + testCase + " </b>";
                } catch (e:Error) {
                    log += "Got expected error for case="+ testCase + "\t\t" + e.message;
                }
                log += "\n";
            }
            return log;
        }
    }

}