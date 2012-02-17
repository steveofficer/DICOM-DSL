namespace DicomDSL.Dicom

import System
import System.Collections.Generic

class TagNode:
"""Description of TagNode"""
    private m_tag_id as uint
    private m_vr as string
    private m_values as IEnumerable[of string]
    
    public def constructor(tag_id as uint, vr as string, values as IEnumerable[string]):
        m_tag_id = tag_id
        m_vr = vr
        m_values = values

    public TagId:
        get: return m_tag_id
    
    public VR:
        get: return m_vr
        
    public Values:
        get: return m_values
    