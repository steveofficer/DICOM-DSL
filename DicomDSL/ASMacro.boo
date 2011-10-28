namespace DicomDSL

import System
import System.IO
import Boo.Lang.Compiler.Ast

final class ASMacro(TagMacro):
"""Description of ASMacro"""
    public def constructor():
        pass

    VR: 
        get: return "AS"
            
    def TryGetTagValues(data_arguments as ExpressionCollection):
        if data_arguments.IsEmpty:
            data_arguments.Add(NullLiteralExpression())
        else:
            for arg in data_arguments:
                raise TagException(arg.LexicalInfo, "The tag values must be a $NodeType.StringLiteralExpression") if arg.NodeType != NodeType.StringLiteralExpression
        return data_arguments
        
    def WriteTagData(stream as Stream, data as ExpressionCollection):
        for literal as StringLiteralExpression in data:
            val = literal.Value.ToUpper()
            raise TagException(literal.LexicalInfo, "An $VR value must follow one of the following patterns: nnnD, nnnW, nnnM, nnnY") if not val =~ /^\d{1,3}[D|W|M|Y]$/
            for c in val:
            	stream.WriteByte(c)