namespace ACBrLib.Core.NFe
{
    public enum TipoNFeDebito
    {
        [EnumValue("")]
        tdNenhum,

        [EnumValue("01")]
        tdTransferenciaCreditoCooperativa = 01,

        [EnumValue("02")]
        tdAnulacao = 02,

        [EnumValue("03")]
        tdDebitosNaoProcessadas = 03,

        [EnumValue("04")]
        tdMultaJuros = 04,

        [EnumValue("05")]
        tdTransferenciaCreditoSucessao = 05,

        [EnumValue("06")]
        tdPagamentoAntecipado = 06,

        [EnumValue("07")]
        tdPerdaEmEstoque = 07,

        [EnumValue("08")]
        tdDesenquadramentodoSN = 08
    }
}
