package com.becker.expression {
    
    import com.becker.expression.TreeNode;
    
    /**
     * Parses the text form of an expression (in x) into a tree representation.
     * 
     * @author Barry Becker
     */
    public class ExpressionParser {
       
        /** 
         * Parses an expression.
         * Called recursively to parse sub-expressions nested within parenthesis.
         * @return the root node in the parsed expression tree.
         */
        public function parse(textExpression:String):TreeNode {
            
            var nodes:Array = getNodesAtLevel(textExpression);
            return makeTreeFromNodes(nodes);
        }
        
        /** 
         * Recursive method to find all the tree nodes for the terms a the current level.
         * For example, given this expression 
         * 2x^3 +  5(x + 3x^2) / (x - 1)
         * the items in []'s represent the array of nodes returned.
         * [2] [*] [x] [^] [3] [+] [5][*][x + 3x^2] [/] [x - 1]
         * The parts that were in {()'s become their own subtrees via recursive calls.
         * 
         * @param exp the expression to get the nodes at the current level for
         * @return array of nodes representing terms that the current level.
         * @throws Error if there is a syntax error causing the expression to be invalid
         */
        private function getNodesAtLevel(exp:String):Array {
            
            var pos:int = 0;
            var nodes:Array = [];
            var token:String = "";
            var ch:String = exp.charAt(pos++);
            
            while (pos <= exp.length && token != ")") {
                if (ch == ' ') {
                    // spaces are ignored
                }
                else if (ch == '(') {
                    var closingParenPos:int = findClosingParen(exp, pos);
                    // this method will make the recursive call
                    token = processSubExpression(exp, pos, token, closingParenPos, nodes);
                    pos = closingParenPos + 1;
                }
                else if (ch == Operators.MINUS && token.length == 0 && Operators.isLastNodeOperator(nodes)) {
                    // a leading minus sign
                    token += ch;
                }
                else if (isNumericChar(ch)) {
                    token += ch;
                    if (token.indexOf("x") >= 0) {
                        throw new Error("Cannot have numbers after x in a term "+ token +" within " + exp);
                    }
                }
                else if (ch == 'x') {
                    token += ch;
                }
                else if (Operators.isOperator(ch)) {
                    pushNodesForToken(token, nodes);
                    token = "";
                    nodes.push(new TreeNode(ch));
                }
                else {
                    throw new Error("Unexpected character " + ch +" in expression: " + exp);
                }
                ch = exp.charAt(pos++);
            }
            // add the final node
            pushNodesForToken(token, nodes);

            return nodes; 
        }
        
        /**
         * @param exp the whole sup expression
         * @param pos location of lef parenthesis
         * @return location of matching right parenthesis
         */
        private function findClosingParen(exp:String, pos:int):int {
            var parenCount:int = 1;
            var i:int = pos;
            var ch:String;
            
            trace("pos=" + pos + " ch=" + ch + " exp=" + exp);
            do {
                ch = exp.charAt(i++);
                if (ch == '(') parenCount++;
                if (ch == ')') parenCount--;
                trace(i + " parenCt=" + parenCount + " ch=" + ch);
            } while (!(ch == ')' && parenCount == 0) && i<=exp.length);
            
            if (ch != ')' && i == exp.length) {
                throw new Error("Mismatched parenthesis in " + exp);
            }
            return i-1;
        }
        
        /**
         * Parse a parenthesized sub expression recursively.
         * @return current token. May have been reset to "".
         */
        private function processSubExpression(
            exp:String, pos:int, token:String, closingParenPos:int, nodes:Array):String {
            
            // recursive call for sub expression
            var subTree:TreeNode = parse(exp.substring(pos, closingParenPos));
            subTree.hasParens = true;
            
            if (token) {
                // there was some leading token before the parenthesized expression.
                pushNodesForToken(token, nodes);
                token = "";
                nodes.push(new TreeNode(Operators.TIMES));
            }
            else if (nodes.length > 0 && nodes[nodes.length - 1].hasParens) {
                nodes.push(new TreeNode(Operators.TIMES));
            }
            nodes.push(subTree);
            return token;
        }
        
        /**
         * The token may represent several nodes because of implicit multiplication.
         * For example, 
         *   -4x should become  [-4] [times] [x] 
         *    -x should become [-1] [times] [x] 
         * @param	token the token to parse
         * @param	nodes array of nodes that the token was parsed into.
         */
        private function pushNodesForToken(token:String, nodes:Array):void {
            
            if (!token) return;
            
            var len:int = token.length;
            if (token.charAt(len - 1) == 'x') {
                if (len > 1) {
                    if (token.charAt(0) == Operators.MINUS) {
                        nodes.push(new TreeNode("-1"));
                    }
                    else {
                        nodes.push(getNodeForNumber(token.substring(0, len - 1)));
                    }
                    nodes.push(new TreeNode(Operators.TIMES));
                }
                nodes.push(new TreeNode("x"));
            }
            else {
                nodes.push(getNodeForNumber(token));
            }
        }
        
        private function isNumericChar(ch:String):Boolean {
           
            return (ch >= '0' && ch <= '9') || ch == '.';
        }
        
        private function getNodeForNumber(token:String):TreeNode {
            var num:Number = parseFloat(token);
            if (isNaN(num)) {
                throw new Error("Invalid number in expression: " + token);
            }
            return new TreeNode("" + num);
        }
        
        /** 
         * Converts a list of nodes to a single node by reducing them to
         * subtrees in order of operator precendence.
         */
        private function makeTreeFromNodes(nodes:Array):TreeNode {
            
            for each (var ops:Array in Operators.OPERATOR_PRECEDENCE) {
                nodes = reduceNodes(ops, nodes);
            }

            if (nodes.length > 1) {
                throw new Error("Expected to have only one node after reducing, but have "
                    + nodes.length +" : " + nodes);
            }
            if (nodes[0].isOperator() && nodes[0].children.length == 0) {
                throw new Error("Missing operands");
            }
            
            return nodes[0];
        }
        
        /**
         * Simplify the list of terms by evaluating the terms joined by the specified operators.
         * Reduce the nodes list to a single node and return it.
         * @param ops list of operators that all have the same precendence.
         * @param nodes the list of nodes to reduce
         * @return same list of nodes, but reduced.
         */
        private function reduceNodes(ops:Array, nodes:Array):Array {
            
            var index:int = 1;
            if (nodes.length == 2) {
                throw new Error("Missing operand : " + nodes);
            }
            
            while (index < nodes.length) {
                if (isOperator(nodes[index], ops)) {
                    nodes[index].children = [nodes[index - 1], nodes[index + 1]];
                    if (nodes.length < index + 1) {
                        throw new Error("Not enough operands for operator in nodes=" + nodes);
                    }
                    nodes.splice(index-1, 3, nodes[index]);
                } else {
                    index += 2;
                }
            }
            return nodes;
        }
        
        private function isOperator(node:TreeNode, ops:Array):Boolean {
            return ops.indexOf(node.data) >= 0 && !node.hasParens;
        }
    }
}