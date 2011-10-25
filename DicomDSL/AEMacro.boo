namespace DicomDSL

import System
import System.IO
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

class AEMacro(TagMacro):
"""Description of AEMacro"""
    
    VR:
        get: return "AE"
            
    def TryGetTagValues(data_arguments as ExpressionCollection):
        if data_arguments.IsEmpty:
            data_arguments.Add(StringLiteralExpression())
        else:
            for arg in data_arguments:
                raise TagException(arg.LexicalInfo, "The tag values must be a $NodeType.StringLiteralExpression") if arg.NodeType != NodeType.StringLiteralExpression
        return data_arguments
        
    def WriteTagData(stream as Stream, data as ExpressionCollection):
        for literal as StringLiteralExpression in data:
            val = literal.Value
            if String.IsNullOrEmpty(val):
                stream.WriteByte(0)
            else:
                raise TagException(literal.LexicalInfo, "An AE value cannot contain the LF character.") if char(0x0A) in val
                raise TagException(literal.LexicalInfo, "An AE value cannot contain the FF character.") if char(0x0C) in val
                raise TagException(literal.LexicalInfo, "An AE value cannot contain the CR character.") if char(0x0D) in val
                raise TagException(literal.LexicalInfo, "An AE value cannot contain the ESC character.") if char(0x1B) in val
                raise TagException(literal.LexicalInfo, "An AE value cannot contain the \\ character.") if char(0x5C) in val
                for character in val:
                    stream.WriteByte(character)