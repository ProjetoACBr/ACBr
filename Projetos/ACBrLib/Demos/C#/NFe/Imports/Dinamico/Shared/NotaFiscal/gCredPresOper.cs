using ACBrLib.Core.DFe;
using ACBrLib.Core.NFe;
using System;

namespace ACBrLib.NFe
{
    public class gCredPresOper
    {
        #region Constructor
        public gCredPresOper()
        {
            gIBSCredPres = new gCredPres();
            gCBSCredPres = new gCredPres();
        }
        #endregion

        #region Properties
        public decimal vBCCredPres { get; set; }

        public TcCredPres cCredPres { get; set; }

        public gCredPres gIBSCredPres { get; }

        public gCredPres gCBSCredPres { get; }
        #endregion



    }
}
