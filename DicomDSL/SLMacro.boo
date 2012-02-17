namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast

final class SignedLongMacro(TagMacro):
"""Description of SLMacro"""
    public def constructor():
        pass

    public static final error_msg = "The tag values must be positive or negative integers"
    
    VR: 
        get: return "SL"
            
    private def AssertValueIsLong(node as Expression):
        raise TagException(node.LexicalInfo, error_msg) if node.NodeType != NodeType.IntegerLiteralExpression
                
    def ReadTagValues(data_arguments as ExpressionCollection):
        # This can't actually return its values as a string because it needs to be serialized as an integer"
        values = List[of string](data_arguments.Count)    
        for arg in data_arguments:
            if arg.NodeType == NodeType.UnaryExpression:
                expr = arg as UnaryExpression
                raise TagException(arg.LexicalInfo, error_msg) if expr.Operator != UnaryOperatorType.UnaryNegation
                AssertValueIsLong(expr.Operand)
                v = -(expr.Operand as IntegerLiteralExpression).Value
            else:
                AssertValueIsLong(arg)
                v = (arg as IntegerLiteralExpression).Value
            values.Add(v.ToString())
        return values       
   