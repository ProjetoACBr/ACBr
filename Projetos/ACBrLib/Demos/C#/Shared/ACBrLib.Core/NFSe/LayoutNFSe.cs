using System;
using System.ComponentModel;

namespace ACBrLib.Core.NFSe
{
    public enum LayoutNFSe
    {
        [Description("Layout Provedor")]
        lnfsProvedor = 0,

        [Description("Layout Padrão Nacional")]
        lnfsPadraoNacionalv1 = 1,

        [Description("Layout Padrão Nacional v1.01")]
        lnfsPadraoNacionalv101 = 2
    }
}