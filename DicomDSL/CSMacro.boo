namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast

final class CodeStringMacro(TagMacro):
"""Macro for outputting CS values."""
    public def constructor():
        pass
    
    VR: 
        get: return "CS"
            
    private def AllowableCharacter(c as char):
        return char.IsNumber(c) or char.IsUpper(c) or c.Equals(char('_')) or c.Equals(char(' '))
        
    def ReadTagValues(data_arguments as ExpressionCollection):
        values = List[of string](data_arguments.Count)
        for arg in data_arguments:
            raise TagException(arg.LexicalInfo, "The tag values must be a $NodeType.StringLiteralExpression") if arg.NodeType != NodeType.StringLiteralExpression
            v = (arg as StringLiteralExpression).Value.ToUpper()
            for c in v:
                raise TagException(arg.LexicalInfo, "A $VR value can only contain alphanumberics, ' ' and '_' characters.") if not AllowableCharacter(c)
            values.Add(v)
        return values       
   