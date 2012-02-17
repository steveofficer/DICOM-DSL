namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast

final class IntegerStringMacro(TagMacro):
"""Macro for outputting IS values."""
    public def constructor():
        pass

    public static final error_msg = "The tag values must be positive or negative integers"
    
    VR: 
        get: return "IS"
            
    private def AssertValueIsInteger(node as Expression):
        raise TagException(node.LexicalInfo, error_msg) if node.NodeType != NodeType.IntegerLiteralExpression
        raise TagException(node.LexicalInfo, error_msg) if (node as IntegerLiteralExpression).IsLong
                
    def ReadTagValues(data_arguments as ExpressionCollection):
        values = List[of string](data_arguments.Count)    
        for arg in data_arguments:
            if arg.NodeType == NodeType.UnaryExpression:
                expr = arg as UnaryExpression
                raise TagException(arg.LexicalInfo, error_msg) if expr.Operator != UnaryOperatorType.UnaryNegation
                AssertValueIsInteger(expr.Operand)
                v = -(expr.Operand as IntegerLiteralExpression).Value
            else:
                AssertValueIsInteger(arg)
                v = (arg as IntegerLiteralExpression).Value
            values.Add(v.ToString())
        return values       
   