namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast

final class AgeStringMacro(TagMacro):
"""Description of ASMacro"""
    public def constructor():
        pass

    VR: 
        get: return "AS"
            
    def ReadTagValues(data_arguments as ExpressionCollection):
        values = List[of string](data_arguments.Count)
        for arg in data_arguments:
            raise TagException(arg.LexicalInfo, "The tag values must be a $NodeType.StringLiteralExpression") if arg.NodeType != NodeType.StringLiteralExpression
            v = (arg as StringLiteralExpression).Value.ToUpper()
            raise TagException(arg.LexicalInfo, "An $VR value must follow one of the following patterns: nnnD, nnnW, nnnM, nnnY") if not v =~ /^\d{1,3}[D|W|M|Y]$/
            values.Add(v)
        return values