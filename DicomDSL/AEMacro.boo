namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast

final class ApplicationEntityMacro(TagMacro):
"""Description of AEMacro"""
    
    VR:
        get: return "AE"
            
    def ReadTagValues(data_arguments as ExpressionCollection):
        values = List[of string](data_arguments.Count)
        for arg in data_arguments:
            raise TagException(arg.LexicalInfo, "The tag values must be a $NodeType.StringLiteralExpression") if arg.NodeType != NodeType.StringLiteralExpression
            v = (arg as StringLiteralExpression).Value
            raise TagException(arg.LexicalInfo, "An $VR value cannot contain the LF character.") if char(0x0A) in v
            raise TagException(arg.LexicalInfo, "An $VR value cannot contain the FF character.") if char(0x0C) in v
            raise TagException(arg.LexicalInfo, "An $VR value cannot contain the CR character.") if char(0x0D) in v
            raise TagException(arg.LexicalInfo, "An $VR value cannot contain the ESC character.") if char(0x1B) in v
            raise TagException(arg.LexicalInfo, "An $VR value cannot contain the \\ character.") if char(0x5C) in v
            values.Add(v)
        return values