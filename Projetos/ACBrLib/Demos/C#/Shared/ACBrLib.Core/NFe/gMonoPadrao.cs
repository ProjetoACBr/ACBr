namespace ACBrLib.NFe
{
    public class gMonoPadrao
    {
        /// <summary>
        /// Quantidade tributada na monofasia
        /// </summary>
        public decimal qBCMono { get; set; }
        /// <summary>
        /// Alíquota ad rem do IBS
        /// </summary>
        public decimal adRemIBS { get; set; }

        /// <summary>
        /// Alíquota ad rem do CBS
        /// </summary>
        public decimal adRemCBS { get; set; }

        /// <summary>
        /// Valor do IBS monofásico
        /// </summary>
        public decimal vIBSMono { get; set; }
        
        /// <summary>
        /// Valor da CBS monofásica
        /// </summary>
        public decimal vCBSMono { get; set; }

    }
}