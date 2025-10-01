using System.Collections.Generic;

namespace ACBrLib.NFe
{
    public class Agropecuario
    {
        #region Constructors

        public Agropecuario()
        {
            Defensivo = new List<Defensivo>(20);
            GuiaTransito = new GuiaTransito();
        }

        #endregion Constructors

        public List<Defensivo> Defensivo { get; } = new List<Defensivo>();
        public GuiaTransito GuiaTransito { get; }
    }
}
