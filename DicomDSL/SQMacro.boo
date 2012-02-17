namespace DicomDSL

import System
import System.Collections.Generic

# This will have a child macro called SequenceItemMacro and the tags will be nested below this.
# Tags pass TagNode up to SequenceItem, SequenceItem passes TagNode collection up to Sequence, Sequence passes the whole thing up to Dicom Macro
macro SQ:
    all_tags = self.__macro["tags"] as IEnumerable[of KeyValuePair[of uint, byte]]
    for tag in all_tags:
        print "$tag.Key : $tag.Value"

