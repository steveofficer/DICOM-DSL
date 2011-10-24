namespace DicomDSL

import System
import System.IO
import System.Collections.Generic
import Boo.Lang.Compiler.Ast
import Boo.Lang.Compiler

protected abstract class TagMacro(LexicalInfoPreservingMacro):
"""Description of TagMacro"""
    public def constructor():
        pass
    
    protected abstract VR as string:
        get: pass
            
    private def GetTagId(arguments as ExpressionCollection):
        first_argument = arguments.First as IntegerLiteralExpression
        if first_argument is null:
            error = CompilerErrorFactory.InvalidParameterType(
                arguments.First,  
                "uint"
            )
            Errors.Add(error)
            return 0
        return cast(uint, first_argument.Value)
        
    protected abstract def GetTagValue(arguments as ExpressionCollection) as ExpressionCollection:
        pass
        
    private def FindParent(statement as MacroStatement):
        parent = statement.GetParentMacroByName("dicom") or statement.GetParentMacroByName("SQ")
        return parent
        
    private def AddToParent(parent as MacroStatement, tag_id as uint, tag_data as (byte)):
        if not parent.ContainsAnnotation("Tags"):
            parent["Tags"] = Dictionary[of uint, (byte)]()
        tags = parent["Tags"] as IDictionary[of uint, (byte)]
        tags[tag_id] = tag_data
    
    private def ConvertToBytes(tag_id as uint, data as ExpressionCollection):
        using stream = MemoryStream():
            # Output the tag value
            unchecked:
                stream.WriteByte(tag_id >> 24)
                stream.WriteByte(tag_id >> 16)
                stream.WriteByte(tag_id >> 8)
                stream.WriteByte(tag_id)
            
            # Output the VR
            for c in VR:
                stream.WriteByte(c)
            
            WriteTagData(stream, data)
            return stream.GetBuffer()
        
    protected abstract def WriteTagData(stream as Stream, data as ExpressionCollection):
        pass
    
    def ExpandImpl(macro as MacroStatement):
        tag_id = GetTagId(macro.Arguments)
        tag_data = ConvertToBytes(tag_id, GetTagValue(macro.Arguments))
        
        parent_macro = FindParent(macro)
        if parent_macro is not null:
            AddToParent(parent_macro, tag_id, tag_data)
        else:
            def ConvertToArrayLiteral(data as (byte)):
                literal = ArrayLiteralExpression()
                for b in data:
                    literal.Items.Add(IntegerLiteralExpression(b))
                return literal
                
            tag_id_literal = IntegerLiteralExpression(tag_id, IsLong: false)
            data_literal = ConvertToArrayLiteral(tag_data)
            return ExpressionStatement(
                [| 
                    System.Collections.Generic.KeyValuePair[of uint, (int)]($tag_id_literal, $data_literal)
                |]
            )