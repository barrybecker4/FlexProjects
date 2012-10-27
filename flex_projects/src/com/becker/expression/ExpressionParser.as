package com.becker.expression {
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
            
            // reduce the nodes list to a single node and return it
            return makeTreeFromNodes(nodes);
        }
        
        /** 
         * Find all the tree nodes for the terms a the current level 
         * For example, given this expression 
         * 2x^3 +  5(x + 3x^2) / (x - 1)
         * the items in []'s represent the array of nodes returned.
         * [2] [.] [x] [^] [3] [+] [5][.][x + 3x^2] [/] [x - 1]
         * The parts that were in {()'s become their own subtrees via recursive calls.
         * @param exp the expression to get the nodes at the current level for
         * @param array of nodes representing terms that the current level.
         * @throws Error if there is a syntax error causing the expression to be invalid
         */
        private function getNodesAtLevel(exp:String):Array {
            
            var pos:int = 0;
            var nodes:Array = [];
            var token:String = "";
            var ch:String = exp.charAt(pos++);
            
            while (pos <= exp.length && token != ")") {
                trace("pos=" + pos +" ch=[" + ch + "]  token=" +token);
                if (ch == ' ') {
                    // spaces are ignored
                }
                else if (ch == '(') {
                    var closingParen:int = findClosingParen(exp, pos);
                    // recursive call for sub expression
                    var subTree:TreeNode = parse(exp.substring(pos, closingParen));
                    subTree.hasParens = true;
                    
                    if (token.length > 0 ) {
                        pushNodesForToken(token, nodes);
                        token = "";
                        nodes.push(new TreeNode(Operators.TIMES));
                    }
                    else if (nodes.length > 0 && nodes[nodes.length - 1].hasParens) {
                        nodes.push(new TreeNode(Operators.TIMES));
                    }
                    nodes.push(subTree);
                    pos = closingParen + 1;
                }
                else if (ch == Operators.MINUS && token.length == 0) {
                    token += ch;
                }
                else if (ch >= '0' && ch <= '9') {
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
            var parenCount:int = 0;
            var i:int = pos + 1;
            var ch:String = exp.charAt(i);
            while (!(ch == ')' && parenCount == 0) && i<exp.length) {
                if (ch == '(') parenCount++;
                if (ch == ')') parenCount--;
                ch = exp.charAt(i++);
            }
            
            if (ch != ')' && i == exp.length) {
                throw new Error("Mismatched parenthesis in " + exp);
            }
            return i-1;
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
            
            if (!token ) return;
            var len:int = token.length;
            if (token.charAt(len - 1) == 'x') {
                if (len > 1) {
                    nodes.push(getNodeForNumber(token.substring(0, len-1)));
                    nodes.push(new TreeNode(Operators.TIMES));
                }
                nodes.push(new TreeNode("x"));
            }
            else {
                nodes.push(getNodeForNumber(token));
            }
        }
        
        private function getNodeForNumber(token:String):TreeNode {
            var num:Number = parseInt(token);
            if (isNaN(num)) {
                throw new Error("Invalid number in expression: " + token);
            }
            return new TreeNode("" + int(num));
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
            return nodes[0];
        }
        
        /**
         * Simplify the list of terms by evaluating the terms joined by the specified operators.
         * @param ops list of operators that all have the same precendence.
         * @param nodes the list of nodes to reduce
         * @return same list of nodes, but reduced.
         */
        private function reduceNodes(ops:Array, nodes:Array):Array {
            
            var index:int = 1;
            
            while (index < nodes.length) {
                if (ops.indexOf(nodes[index].data) >= 0 && !nodes[index].hasParens) {
                    nodes[index].children = [nodes[index-1], nodes[index+1]];
                    nodes.splice(index-1, 3, nodes[index]);
                } else {
                    index += 2;
                }
            }
            return nodes;
        }
    }
}