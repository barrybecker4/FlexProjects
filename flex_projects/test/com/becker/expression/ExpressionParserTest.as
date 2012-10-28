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
        
        public function run():String {
            
            var log:String  = runPositiveTests();
            log += runNegativeTests();
            return log;
        }
        
        public function runPositiveTests():String {
            
            var log:String = "\nnow running positive tests...\n";
            var root:TreeNode;
            
            for each (var testCase:String in ExpressionCases.CASES) {
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
            
            for each (var testCase:String in ExpressionCases.NEGATIVE_CASES) {
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