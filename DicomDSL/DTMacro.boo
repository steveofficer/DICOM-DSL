namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast

final class DateTimeMacro:
"""Description of DTMacro"""
    public def constructor():
        pass

    VR: 
        get: return "DT"
            
    def ReadTagValues(data_arguments as ExpressionCollection):
        values = List[of string](data_arguments.Count)
        for arg in data_arguments:
            raise TagException(arg.LexicalInfo, "The tag values must be a $NodeType.StringLiteralExpression") if arg.NodeType != NodeType.StringLiteralExpression
            v = (arg as StringLiteralExpression).Value
            # Fill in the validation, this is a tricky one because of all the optional values.
            values.Add(v)
        return values