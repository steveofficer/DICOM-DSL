namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast

final class UniqueIdentifierMacro(TagMacro):
"""Macro for outputting UI values."""
    public def constructor():
        pass
    
    VR: 
        get: return "UI"
            
    def ReadTagValues(data_arguments as ExpressionCollection):
        values = List[of string](data_arguments.Count)
        for arg in data_arguments:
            raise TagException(arg.LexicalInfo, "The tag values must be a $NodeType.StringLiteralExpression") if arg.NodeType != NodeType.StringLiteralExpression
            v = (arg as StringLiteralExpression).Value
            for c in v:
                raise TagException(arg.LexicalInfo, "A $VR value can only contain numbers and the '.' character.") if not (char.IsNumber(c) or c.Equals(char('.')))
            values.Add(v)
        return values