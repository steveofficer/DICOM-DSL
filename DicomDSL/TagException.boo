namespace DicomDSL

import System
import Boo.Lang.Compiler.Ast

class TagException(Exception):
"""Description of TagValueException"""
    public def constructor(lexical_info as LexicalInfo, message as string):
        super(message)
        _lexical_info = lexical_info
        
    [Property(LexicalInfo)]
    _lexical_info as LexicalInfo
