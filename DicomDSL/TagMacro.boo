namespace DicomDSL

import System
import System.IO
import Boo.Lang.Compiler.Ast
import Boo.Lang.Compiler

protected abstract class TagMacro(LexicalInfoPreservingMacro):
"""Description of TagMacro"""
    public def constructor():
        pass
    
    private def GetTagId(arguments as ExpressionCollection):
        first_argument = arguments.First as IntegerLiteralExpression
        if first_argument is null:
            Errors.Add(
                CompilerErrorFactory.InvalidParameterType(
                    arguments.First,  
                    "uint"
                )
            )
        return first_argument.Value as uint
        
    protected abstract GetTagValue():
        pass
        
    private def FindParent():
        pass
        
    private def AddToParent():
        pass
    
    private def WriteTag():
        using stream = MemoryStream():
            # Output the tag value
            unchecked:
                stream.WriteByte(tag >> 24)
                stream.WriteByte(tag >> 16)
                stream.WriteByte(tag >> 8)
                stream.WriteByte(tag)
            
            # Output the VR
            stream.WriteByte(char('A'))
            stream.WriteByte(char('E'))
            
            WriteTagData(stream)
            return stream.GetBuffer()
        
    protected abstract def WriteTagData(stream as Stream):
        pass
    
    def ExpandImpl(macro as MacroStatement):
        tag_id = GetTagId(macro.Arguments)
        tag_data = ConvertToBytes(tag_id, ExtractTagData(macro))
        
        parent_macro = FindParent(macro)
        if parent_macro is not null:
            AddToParent(parent_macro, tag_id, tag_data)
        else:
            tag_id_literal = IntegerLiteralExpression(tag_id, IsLong: false)
            data_literal = ConvertToArrayLiteral(tag_data)
            return ExpressionStatement(
                [| 
                    System.Collections.Generic.KeyValuePair[of uint, (int)]($tag_id_literal, $data_literal)
                |]
            )