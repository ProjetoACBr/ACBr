using ACBrLib.Core.DFe;

namespace ACBrLib.NFe
{
    /// <summary>
    /// Imposto de Importação
    /// </summary>
    public class IBSCBSProdutoNFe
    {
        #region Constructors
        public IBSCBSProdutoNFe()
        {
            gIBSCBS = new gIBSCBS();
            gIBSCBSMono = new gIBSCBSMono();
            gMonoPadrao = new gMonoPadrao();
            gMonoReten = new gMonoReten();
            gMonoRet = new gMonoRet();
            gMonoDif = new gMonoDif();
            gTransfCred = new gTransfCred();
            gCredPresIBSZFM = new gCredPresIBSZFM();
            gCredPresOper = new gCredPresOper();
            gAjusteCompet = new gAjusteCompet();
            gEstornoCred = new gEstornoCred();

        }
        #endregion Constructors
        #region Properties

        /// <summary>
        /// Código de Classificação Tributária do IBS e CBS
        /// </summary>
        public CSTIBSCBS CST { get; set; }

        /// <summary>
        /// Código de Classificação Tributária do IBS e CBS
        /// </summary>
        public string cClassTrib { get; set; }  
        
        /// <summary>
        /// Grupo de Informações do IBS e da CBS
        /// </summary>
        public gIBSCBS gIBSCBS { get; }

        public gIBSCBSMono gIBSCBSMono { get; }

        public gMonoPadrao gMonoPadrao { get; }

        public gMonoReten gMonoReten { get; }

        public gMonoRet gMonoRet { get; }

        public gMonoDif gMonoDif { get; }

        public gTransfCred gTransfCred { get; }      
        
        public gCredPresIBSZFM gCredPresIBSZFM { get; }

        public gCredPresOper gCredPresOper { get; }

        public gAjusteCompet gAjusteCompet { get; }

        public gEstornoCred gEstornoCred { get; }

        public IndDoacao indDoacao { get; set; }

        #endregion Properties
    }
}