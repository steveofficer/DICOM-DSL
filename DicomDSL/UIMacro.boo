namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast
import System.IO

class UIMacro(TagMacro):
"""Description of UIMacro"""
    public def constructor():
        pass
    
    VR: 
        get: return "UI"
            
    def TryGetTagValues(data_arguments as ExpressionCollection):
        if data_arguments.IsEmpty:
            data_arguments.Add(StringLiteralExpression())
        else:
            for arg in data_arguments:
                raise TagException(arg.LexicalInfo, "The tag values must be a $NodeType.StringLiteralExpression") if arg.NodeType != NodeType.StringLiteralExpression
        return data_arguments
        
    def WriteTagData(stream as Stream, data as ExpressionCollection):
        allowed_chars = (char('.'), char('0'),char('1'),char('2'),char('3'),char('4'),char('5'),char('6'),char('7'),char('8'),char('9'))
        for literal as StringLiteralExpression in data:
            val = literal.Value
            if String.IsNullOrEmpty(val):
                stream.WriteByte(0)
            else:
                for character in val:
                    raise TagException(literal.LexicalInfo, "A UI value can only contain numbers and the '.' character.") if not character in allowed_chars
                    stream.WriteByte(character)
