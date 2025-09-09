namespace ACBrLib.NFe
{
    public class gMonoReten
    {
        /// <summary>
        /// Quantidade tributada na monofasia
        /// </summary>
        public decimal qBCMonoReten { get; set; }
        /// <summary>
        /// Alíquota ad rem do IBS
        /// </summary>
        public decimal adRemIBSReten { get; set; }

        /// <summary>
        /// Alíquota ad rem do CBS
        /// </summary>
        public decimal adRemCBSReten { get; set; }

        /// <summary>
        /// Valor do IBS monofásico
        /// </summary>
        public decimal vIBSMonoReten { get; set; }

        /// <summary>
        /// Valor da CBS monofásica
        /// </summary>
        public decimal vCBSMonoReten { get; set; }
    }
}