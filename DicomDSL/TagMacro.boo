namespace DicomDSL

import System
import System.Collections.Generic
import Boo.Lang.Compiler.Ast
import Boo.Lang.Compiler
import DicomDSL.Dicom

protected abstract class TagMacro(LexicalInfoPreservingMacro):
"""The base class for all macros that are used to represent tags and their values in a DICOM file."""
    public def constructor():
        pass
    
    protected abstract VR as string:
        get: pass
            
    private def ReadTagId(macro as MacroStatement) as uint:
        arguments = macro.Arguments
        raise TagException(macro.LexicalInfo, "There must be at least one argument. The first argument represents the Tag Id.") if arguments.IsEmpty
        first_argument = arguments.First as IntegerLiteralExpression
        raise TagException(arguments.First.LexicalInfo, "The first argument must be a uint that represents the Tag Id.") if first_argument is null
        return cast(uint, first_argument.Value)
        
    protected abstract def ReadTagValues(arguments as ExpressionCollection) as IEnumerable[of string]:
        pass
        
    private def FindParent(statement as MacroStatement):
        parent = statement.GetParentMacroByName("dicom") or statement.GetParentMacroByName("SQ")
        return parent
        
    private def AddToParent(parent as MacroStatement, tag as TagNode):
        if not parent.ContainsAnnotation("Tags"):
            parent["Tags"] = Dictionary[of uint, TagNode]()
        tags = parent["Tags"] as IDictionary[of uint, TagNode]
        tags[tag.TagId] = tag
    
    def ExpandImpl(macro as MacroStatement):
        try:
            tag_id = ReadTagId(macro)
            value_args = macro.Arguments.PopRange(1)
            tag_values = (null if value_args.IsEmpty else ReadTagValues(value_args))
        except e as TagException:
            Errors.Add(CompilerErrorFactory.CustomError(e.LexicalInfo, e.Message))
            return ExpressionStatement()
        
        dicom_representation = TagNode(tag_id, VR, tag_values)
        parent_macro = FindParent(macro)
        if parent_macro is not null:
            AddToParent(parent_macro, dicom_representation)        