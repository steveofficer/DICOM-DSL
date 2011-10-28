﻿namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast
import System.IO

final class UIMacro(TagMacro):
"""Macro for outputting UI values."""
    public def constructor():
        pass
    
    VR: 
        get: return "UI"
            
    def TryGetTagValues(data_arguments as ExpressionCollection):
        if data_arguments.IsEmpty:
            data_arguments.Add(NullLiteralExpression())
        else:
            for arg in data_arguments:
                raise TagException(arg.LexicalInfo, "The tag values must be a $NodeType.StringLiteralExpression") if arg.NodeType != NodeType.StringLiteralExpression
        return data_arguments
        
    def WriteTagData(stream as Stream, data as ExpressionCollection):
        for literal as StringLiteralExpression in data:
            val = literal.Value
            if string.IsNullOrEmpty(val):
                stream.WriteByte(0)
            else:
                for c in val:
                    raise TagException(literal.LexicalInfo, "A $VR value can only contain numbers and the '.' character.") if not (char.IsNumber(c) or c.Equals(char('.')))
                    stream.WriteByte(c)
