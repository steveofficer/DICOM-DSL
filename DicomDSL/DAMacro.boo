namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast

final class DateMacro(TagMacro):
"""Description of DAMacro"""
    public def constructor():
        pass

    VR: 
        get: return "DA"
            
    def ReadTagValues(data_arguments as ExpressionCollection):
        values = List[of string](data_arguments.Count)
        for arg in data_arguments:
            raise TagException(arg.LexicalInfo, "The tag values must be a $NodeType.StringLiteralExpression") if arg.NodeType != NodeType.StringLiteralExpression
            v = (arg as StringLiteralExpression).Value
            raise TagException(arg.LexicalInfo, "A $VR value must be 8 digits long and in the format YYYYMMDD") if not v =~ /^\d{8}$/
            year = uint.Parse(v.Substring(0, 4))
            month = uint.Parse(v.Substring(4, 2))
            day = uint.Parse(v.Substring(6, 2))
            raise TagException(arg.LexicalInfo, "A $VR value must be in the format YYYYMMDD and MM must be between 1 and 12") if month > 12
            days_in_month = DateTime.DaysInMonth(year, month)
            raise TagException(arg.LexicalInfo, "A $VR value must be in the format YYYYMMDD and DD must be between 1 and $days_in_month") if day > days_in_month
            values.Add(v)
        return values