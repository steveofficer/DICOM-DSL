namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast

class PersonNameMacro(TagMacro):
"""Description of PNMacro"""
    public def constructor():
        pass

    VR: 
        get: return "PN"
            
    def ReadTagValues(data_arguments as ExpressionCollection):
        values = List[of string](data_arguments.Count)
        for arg in data_arguments:
            raise TagException(arg.LexicalInfo, "The tag values must be a $NodeType.StringLiteralExpression") if arg.NodeType != NodeType.StringLiteralExpression
            v = (arg as StringLiteralExpression).Value
            raise TagException(arg.LexicalInfo, "An $VR value cannot contain the LF character.") if char(0x0A) in v
            raise TagException(arg.LexicalInfo, "An $VR value cannot contain the FF character.") if char(0x0C) in v
            raise TagException(arg.LexicalInfo, "An $VR value cannot contain the CR character.") if char(0x0D) in v
                
            component_groups = v.Split(char('='))
            
            raise TagException(arg.LexicalInfo, "A $VR value can have a maximum of 3 component groups") if component_groups.Length > 3
            
            for group in component_groups:
                components = group.Split(char('^'))
                raise TagException(arg.LexicalInfo, "A $VR component group can have a maximum of 5 components") if components.Length > 5
            values.Add(v)
        return values
