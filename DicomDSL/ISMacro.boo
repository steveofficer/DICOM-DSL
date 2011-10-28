namespace DicomDSL

import System
import System.IO
import Boo.Lang.Compiler.Ast

final class ISMacro(TagMacro):
"""Macro for outputting IS values."""
    public def constructor():
        pass

    VR: 
        get: return "IS"
            
    def TryGetTagValues(data_arguments as ExpressionCollection):
        if data_arguments.IsEmpty:
            data_arguments.Add(NullLiteralExpression())
        else:
            error_msg = "The tag values must be positive or negative integers"
            def AssertValueIsInteger(node as Expression):
                raise TagException(node.LexicalInfo, error_msg) if node.NodeType != NodeType.IntegerLiteralExpression
                raise TagException(node.LexicalInfo, error_msg) if (node as IntegerLiteralExpression).IsLong
                
            for arg in data_arguments:
                if arg.NodeType == NodeType.UnaryExpression:
                    expr = arg as UnaryExpression
                    raise TagException(arg.LexicalInfo, error_msg) if expr.Operator != UnaryOperatorType.UnaryNegation
                    AssertValueIsInteger(expr.Operand)
                else:
                    AssertValueIsInteger(arg)
                        
        return data_arguments
        
    def WriteTagData(stream as Stream, data as ExpressionCollection):
        for literal in data:
            if literal.NodeType == NodeType.IntegerLiteralExpression:
                val = "$((literal as IntegerLiteralExpression).Value)"
            else:
                # It must be a UnaryExpression with an IntegerLiteral as its Operand
                # (as checked by TryGetTagValues)
                expr = (literal as UnaryExpression).Operand as IntegerLiteralExpression
                val = "-$(expr.Value)"
            for c in val:
            	stream.WriteByte(c)