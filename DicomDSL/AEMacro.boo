namespace DicomDSL

import System
import System.IO
import System.Linq.Enumerable from System.Core
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

class AEMacro(TagMacro):
"""Description of AEMacro"""
    
    VR:
        get: return "AE"
            
    def GetTagValue(arguments as ExpressionCollection):
    """Extracts the tag data from the arguments. The data is everything after the first argument."""
        other_arguments = arguments.PopRange(1)
        if other_arguments.IsEmpty:
            # If there are no more arguments, then it must be a null value
            other_arguments.Add(NullLiteralExpression())
        else:
            # Check that the types for all the arguments are allowed
            if not other_arguments.All({x | x.NodeType == NodeType.StringLiteralExpression}):
                raise "The tag values must be a $NodeType.StringLiteralExpression" 
        return other_arguments
        
    def WriteTagData(stream as Stream, data as ExpressionCollection):
        pass