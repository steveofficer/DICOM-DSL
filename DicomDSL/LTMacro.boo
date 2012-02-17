namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast

final class LongTextMacro(TagMacro):
"""Description of LTMacro"""
    public def constructor():
        pass
        
    VR: 
        get: return "LT"
            
    def ReadTagValues(data_arguments as ExpressionCollection):
        raise TagException(data_arguments[1].LexicalInfo, "An $VR can only have one value") if data_arguments.Count > 1
        
        arg = data_arguments.First
        raise TagException(arg.LexicalInfo, "The tag values must be a $NodeType.StringLiteralExpression") if arg.NodeType != NodeType.StringLiteralExpression
        v = (arg as StringLiteralExpression).Value
        return (v,)

