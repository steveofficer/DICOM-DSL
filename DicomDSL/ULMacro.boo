namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast

class UnsignedLongMacro(TagMacro):
"""Description of ULMacro"""
    public def constructor():
        pass
    
    VR: 
        get: return "UL"
            
    def ReadTagValues(data_arguments as ExpressionCollection):
        values = List[of string](data_arguments.Count)
        for arg in data_arguments:
            raise TagException(arg.LexicalInfo, "The tag values must be an unsigned $NodeType.IntegerLiteralExpression") if arg.NodeType != NodeType.IntegerLiteralExpression
            values.Add((arg as IntegerLiteralExpression).Value.ToString())
        return values