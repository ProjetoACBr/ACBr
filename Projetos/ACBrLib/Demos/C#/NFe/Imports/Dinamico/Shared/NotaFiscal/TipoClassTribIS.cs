using System;
using ACBrLib.Core;

namespace ACBrLib.NFe
{
    [Obsolete("Foi alterado para string, deixou de ser eNUM", false)]
    public enum TipoClassTribIS 
    {
        [EnumValue("")]
        ctisNenhum,

        [EnumValue("000001")]
        ctis000001
    }
}