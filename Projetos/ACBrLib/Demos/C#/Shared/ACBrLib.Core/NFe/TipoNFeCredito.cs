namespace ACBrLib.Core.NFe
{
    public enum TipoNFeCredito
    {
        [EnumValue("")]
        tcNenhum,
        [EnumValue("01")]
        tcMultaJuros,
        [EnumValue("02")]
        tcApropriacaoCreditoPresumido,
        [EnumValue("03")]
        tcRetorno,
        [EnumValue("04")]
        tcReducaoValores,
        [EnumValue("05")]
        tcTransferenciaCreditoSucessao
    }
}

