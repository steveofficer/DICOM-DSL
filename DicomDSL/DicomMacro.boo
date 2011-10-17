namespace DicomDSL

import System
import System.Collections.Generic

macro dicom:
    all_tags = self.__macro["tags"] as IEnumerable[of KeyValuePair[of uint, byte]]
    for tag in all_tags:
        print "$tag.Key : $tag.Value"

