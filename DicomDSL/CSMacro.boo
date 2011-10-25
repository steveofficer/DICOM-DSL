namespace DicomDSL

import System
import System.IO
import Boo.Lang.Compiler.Ast
import Boo.Lang.Compiler

class CSMacro(TagMacro):
"""Description of CSMacro"""
    public def constructor():
        pass
    
    VR: 
        get: return "CS"
            
    def TryGetTagValues(data_arguments as ExpressionCollection):
        if data_arguments.IsEmpty:
            data_arguments.Add(StringLiteralExpression())
        else:
            for arg in data_arguments:
                raise TagException(arg.LexicalInfo, "The tag values must be a $NodeType.StringLiteralExpression") if arg.NodeType != NodeType.StringLiteralExpression
                literal = arg as StringLiteralExpression
                for c in literal.Value:
                    if char.IsLower(c):
                        Warnings.Add(CompilerWarningFactory.CustomWarning(arg, "The tag values must be uppercased."))
                        literal.Value = literal.Value.ToUpper()
                        break
        return data_arguments
        
    def WriteTagData(stream as Stream, data as ExpressionCollection):
        def IsAllowed(c as char):
            return char.IsNumber(c) or char.IsUpper(c) or c.Equals(char('_')) or c.Equals(char(' '))
            
        for literal as StringLiteralExpression in data:
            val = literal.Value
            if string.IsNullOrEmpty(val):
                stream.WriteByte(0)
            else:
                for c in val:
                    raise TagException(literal.LexicalInfo, "A $VR value can only contain alphanumberics, ' ' and '_' characters.") if not IsAllowed(c)
                    stream.WriteByte(c)
