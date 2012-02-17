namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast

final class LongStringMacro(TagMacro):
"""Description of LOMacro"""
    public def constructor():
        pass

    public static final error_msg = "The tag values must be positive or negative long integers"
    
    VR: 
        get: return "LO"
            
    private def AssertValueIsLongInteger(node as Expression):
        raise TagException(node.LexicalInfo, error_msg) if node.NodeType != NodeType.IntegerLiteralExpression
                
    def ReadTagValues(data_arguments as ExpressionCollection):
        values = List[of string](data_arguments.Count)    
        for arg in data_arguments:
            if arg.NodeType == NodeType.UnaryExpression:
                expr = arg as UnaryExpression
                raise TagException(arg.LexicalInfo, error_msg) if expr.Operator != UnaryOperatorType.UnaryNegation
                AssertValueIsLongInteger(expr.Operand)
                v = -(expr.Operand as IntegerLiteralExpression).Value
            else:
                AssertValueIsLongInteger(arg)
                v = (arg as IntegerLiteralExpression).Value
            values.Add(v.ToString())
        return values       