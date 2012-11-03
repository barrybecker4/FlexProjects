package com.becker.controls {
    
    import com.becker.expression.Expression;
    import com.becker.expression.TreeNode;
    import com.becker.common.GraphicsUtil;
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.text.TextFormat;
    import mx.containers.VBox;
    
    
    /**
     * Shows an expression tree visually.
     * Test with something like 2 + (x^2 - (x + (x  + (x + (x - (3x -(x + (x + 1))))))))/ 2
     * 
     * @author Barry Becker
     */
    public class ExpressionTreeViewer extends VBox {
        
        /** The expression to view */
        public var _expression:Expression;
        
        private static const NODE_SIZE:int = 16;
        private static const TEXT_FORMAT:TextFormat = new TextFormat("Arial", 14, 0x330000, true);
        private static const LINE_COLOR:uint = 0x000099;
        private static const PARENTHESIZED_COLORS:Array = 
            [0xffffaa, 0xccffcc, 0xddddff, 0xffddaa, 0xbbeeff, 0xffddf0, 0xd0ffee, 0xffccd0, 0xddffbb];
        
        /** greatest depth of the expresssion tree being view */
        private var treeDepth:int;
        
        /** width at every level. Indexed by level with level 0 being at the root. */
        private var levelWidths:Array;
        
        /** current depth of the expresssion tree while rendering */
        private var currentMaxDepth:int;
        
        /** current x position at every level. */
        private var levelXpos:Array;
        
        
        /** Constructor */
        public function ExpressionTreeViewer() {}
     
        [Bindable]
        public function get expression():Expression {
            return _expression;
        }
         
         public function set expression(exp:Expression):void {
             _expression = exp;
             invalidateDisplayList();
         }
        
        override protected function updateDisplayList(w:Number, h:Number):void {
            super.updateDisplayList(w, h);
            graphics.clear();
            drawTree(w, h);  
        }
        
        private function drawTree(w:Number, h:Number):void {
            if (expression && expression.isValid) {
                levelXpos = [];
                levelXpos[0] = 0;
                currentMaxDepth = 0;
                
                preprocessTree();
                drawSubtree(expression.rootNode, null, 0, 0, w, h);
            }
        }
        
        /** recursive method to draw the subtree */
        private function drawSubtree(node:TreeNode, parentLocation:Point, 
                                     level:int, parenNest:int, w:Number, h:Number):void {
            
            if (level > currentMaxDepth) {
                currentMaxDepth = level;
                levelXpos[currentMaxDepth] = 0;
            }
            
            if (node.children.length == 2) {
                if (node.hasParens) parenNest++;
                
                var newParentLocation:Point = getPoint(level, width, height);
                
                drawSubtree(node.children[0], newParentLocation, level + 1, parenNest, w, h);
                
                drawNode(node, parentLocation, level, parenNest, w, h);
                levelXpos[level]++;
                
                drawSubtree(node.children[1], newParentLocation, level + 1, parenNest, w, h);
            }
            else {
                drawNode(node, parentLocation, level, parenNest, w, h);
                levelXpos[level]++;
            }
        }
        
        private function drawNode(node:TreeNode, parentLocation:Point, level:int, 
                                  parenNest:int, w:Number, h:Number):void {
            var pt:Point = getPoint(level, w, h);
            graphics.lineStyle(1, LINE_COLOR);            
            graphics.beginFill(getParenColor(parenNest));
            graphics.drawCircle(pt.x, pt.y, NODE_SIZE);
            if (parentLocation) {
                graphics.moveTo(pt.x, pt.y - NODE_SIZE);
                graphics.lineTo(parentLocation.x, parentLocation.y + NODE_SIZE);
            }
            GraphicsUtil.drawText(pt.x - NODE_SIZE / 3, pt.y - NODE_SIZE / 2 - 2, 
                                  node.data, graphics, TEXT_FORMAT);
        }
        
        private function getPoint(level:int, w:Number, h:Number):Point {
            var x:int = w * ((levelXpos[level] + 1.0) / (levelWidths[level] + 1.0));
            var y:int = h * (level + 0.5) / (treeDepth + 1.0);
            return new Point(x, y);
        }
        
        /** Determine tree width and depth */
        private function preprocessTree():void {
            treeDepth = 0;
            levelWidths = [];
            levelWidths.push(0);
            preprocessSubtree(expression.rootNode, 0);
        }
        
        /** Determine subtree width and depth */
        private function preprocessSubtree(node:TreeNode, level:int):void {
            if (level > treeDepth) {
                treeDepth = level;
                levelWidths[treeDepth] = 0;
            }
            levelWidths[level]++;
            
            if (node.children.length == 2) {
                preprocessSubtree(node.children[0], level + 1);
                preprocessSubtree(node.children[1], level + 1);
            }
        }
        
        /** cycle through the nested parenthesis colors */
        private function getParenColor(parenNest:int):uint {
            return PARENTHESIZED_COLORS[parenNest % PARENTHESIZED_COLORS.length];
        }
    }
}
