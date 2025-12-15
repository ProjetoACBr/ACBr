using ACBrLib.Core.DFe;
using ACBrLib.DFe;

namespace ACBrLib.NFe
{
    /// <summary>
    /// Imposto de Importação
    /// </summary>
    public class gIBSCBS
    {
        #region Constructors

        public gIBSCBS()
        {
            gIBSUF = new gIBSUF();
            gIBSMun = new gIBSMun();
            gCBS = new gCBS();
            gTribRegular = new gTribRegular();
            gTribCompraGov = new gTribCompraGov();
        }

        #endregion Constructors
        #region Properties

        /// <summary>
        /// Base de cálculo do IBS e CBS
        /// </summary>
        public decimal vBC { get; set; }

        public decimal vIBS { get; set; }

        /// <summary>
        /// Grupo de informações do IBS para a UF.
        /// </summary>
        public gIBSUF gIBSUF { get; }

        /// <summary>
        /// Grupo de informações do IBS para o Município.
        /// </summary>
        public gIBSMun gIBSMun { get; } 

        public gCBS gCBS { get; }

        public gTribRegular gTribRegular { get; }

        public gTribCompraGov gTribCompraGov { get; }

        public gIBSCBSMono gIBSCBSMono { get; }

        public gMonoPadrao gMonoPadrao { get; }

        public gMonoReten gMonoReten { get; }

        #endregion Properties
    }
}