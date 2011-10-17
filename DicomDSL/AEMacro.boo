namespace DicomDSL

import System
import System.Linq.Enumerable from System.Core
import System.Collections.Generic
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

class AEMacro(LexicalInfoPreservingMacro):
"""Description of AEMacro"""
    private final allowedNodeTypes = [NodeType.StringLiteralExpression]
    
    #########################################################################################################
    
    public def constructor():
        pass
    
    #########################################################################################################
    
    private def AddToParent(parent as MacroStatement, tag as uint, data as (byte)):
        if not parent.ContainsAnnotation("Tags"):
            parent["Tags"] = Dictionary[of uint, (byte)]()
        tags = parent["Tags"] as IDictionary[of uint, (byte)]
        tags[tag] = data
    
    #########################################################################################################
    
    private def ConvertToBytes(tag as uint, data as ExpressionCollection):
        bytes = List of byte()
        
        # Output the tag value
        unchecked:
            bytes.Add(cast(byte, tag >> 24))
            bytes.Add(cast(byte, tag >> 16))
            bytes.Add(cast(byte, tag >> 8))
            bytes.Add(cast(byte, tag))
        
        # Output the VR
        bytes.Add(char('A'))
        bytes.Add(char('E'))
        
        # Output each of the data arguments
        for arg in data:
            str_arg = arg as StringLiteralExpression
            for c in str_arg.Value:
                raise "The backslash character is not allowed" if c == char('\\')
                raise "The LF character is not allowed" if c == char(10)
                raise "The FF character is not allowed" if c == char(12)
                raise "The CR character is not allowed" if c == char(13)
                raise "The ESC character is not allowed" if c == char(27)
                bytes.Add(c)
        
        return bytes.ToArray()
        
    #########################################################################################################
    
    private def ExtractTagId(macro as MacroStatement):
    """Extracts the Tag Id from the arguments. The Tag Id must be the first argument."""
        # Need to change this so that it could also be a reference to field in a static class.
        # this allows people to link against a library of tags.
        first_argument = macro.Arguments.First as IntegerLiteralExpression
        if first_argument is null:
            raise "The first argument must be a uint that represents the tag id"
        return first_argument.Value
    
    #########################################################################################################
    
    private def ExtractTagData(macro as MacroStatement):
    """Extracts the tag data from the arguments. The data is everything after the first argument."""
        other_arguments = macro.Arguments.PopRange(1)
        if other_arguments.IsEmpty:
            # If there are no more arguments, then it must be a null value
            other_arguments.Add(NullLiteralExpression())
        else:
            # Check that the types for all the arguments are allowed
            if not other_arguments.All({x | allowedNodeTypes.Contains(x.NodeType)}):
                raise "The data values must be one of the allowed types: $allowedNodeTypes" 
        return other_arguments
    
    #########################################################################################################
    
    private def FindParent(macro as MacroStatement):
        parent = macro.GetParentMacroByName("dicom") or macro.GetParentMacroByName("SQ")
        return parent
    
    #########################################################################################################
    
    private def ConvertToArrayLiteral(data as (byte)):
        literal = ArrayLiteralExpression()
        for b in data:
            literal.Items.Add(IntegerLiteralExpression(b))
        return literal
        
    #########################################################################################################
    
    def ExpandImpl(macro as MacroStatement):
        tag_id as uint = ExtractTagId(macro)
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