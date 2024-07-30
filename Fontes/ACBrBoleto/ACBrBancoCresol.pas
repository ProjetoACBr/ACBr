{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Victor Hugo Gonzales                            }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrBancoCresol;

interface

uses
  ACBrBancoCresolSCRS, ACBrBoleto, Classes, SysUtils, StrUtils, Math;

type

  { TACBrBancoCresol }

  TACBrBancoCresol = class(TACBrBancoCresolSCRS)
  private
  protected
    function DefineCodigoMulta(const ACBrTitulo: TACBrTitulo): String; override;
  public
    Constructor Create(AOwner: TACBrBanco);
    function MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): String; Override;
    function GerarRegistroTransacao240(ACBrTitulo : TACBrTitulo): String; Override;
    function GerarRegistroHeader240(NumeroRemessa : Integer): String; Override;
    procedure LerRetorno240(ARetorno: TStringList); Override;
    function DefinePosicaoNossoNumeroRetorno: Integer; Override;
  end;


implementation

uses
  ACBrUtil.Base, ACBrBoletoConversao, ACBrUtil.Strings, ACBrUtil.DateTime;

{ TACBrBancoCresol }

constructor TACBrBancoCresol.Create(AOwner: TACBrBanco);
begin
  inherited;
  fpNome                          := 'Cresol';
  fpNumero                        := 133;
  fpDigito                        := 3;
  fpCodigosMoraAceitos            := '012';
  fpNumeroCorrespondente          := 0;
  fpLayoutVersaoArquivo           := 84;
  fpLayoutVersaoLote              := 42;
end;

function TACBrBancoCresol.MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo) : String;
begin
  Result := ACBrTitulo.NossoNumero + '-' + CalcularDigitoVerificador(ACBrTitulo)
end;

procedure TACBrBancoCresol.LerRetorno240(ARetorno: TStringList);
var
  Titulo: TACBrTitulo;
  TempData, Linha, rCedente, rCNPJCPF: String;
  ContLinha : Integer;
  idxMotivo: Integer;
  rConvenioCedente: String;
  ACodBeneficiario: String;
begin
  // Verifica se o arquivo pertence ao banco
  if StrToIntDef(copy(ARetorno.Strings[0], 1, 3),-1) <> Numero then
     raise Exception.create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
                            'n�o' + '� um arquivo de retorno do ' + Nome));

  ACBrBanco.ACBrBoleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0],144,2)+'/'+
                                                          Copy(ARetorno[0],146,2)+'/'+
                                                          Copy(ARetorno[0],148,4),0, 'DD/MM/YYYY' );

  ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0],158,6),0);

  rCedente         := trim(copy(ARetorno[0], 73, 30));
  if (copy(ARetorno[0], 18, 1) = '2') then
    rCNPJCPF         := OnlyNumber( copy(ARetorno[0], 19, 14) )
  else
    rCNPJCPF         := OnlyNumber( copy(ARetorno[0], 22, 11) );
  rConvenioCedente := Trim(Copy(ARetorno[0], 33, 20));

  ValidarDadosRetorno('', '', rCNPJCPF);
  with ACBrBanco.ACBrBoleto do
  begin

     if LeCedenteRetorno then
     begin
       ACodBeneficiario:= trim(DefineCodBeneficiarioHeader);
       Cedente.Nome     := rCedente;
       Cedente.CNPJCPF  := rCNPJCPF;
       Cedente.Convenio := rConvenioCedente;
       Cedente.Agencia       := trim(copy(ARetorno[0], 53, 5));
       Cedente.AgenciaDigito := trim(copy(ARetorno[0], 58, 1));
       if (ACodBeneficiario <> '') then
         Cedente.CodigoCedente := trim(copy(ARetorno[0], 59, 14))
       else
       begin
         Cedente.Conta         := trim(copy(ARetorno[0], 59, 12));
         Cedente.ContaDigito   := trim(copy(ARetorno[0], 71, 1));
       end;

       if (StrToIntDef(copy(ARetorno[0], 18, 1), 0) = 1) then
         Cedente.TipoInscricao := pFisica
       else
         Cedente.TipoInscricao := pJuridica;

     end;

     ACBrBanco.ACBrBoleto.ListadeBoletos.Clear;
  end;

  Linha := '';
  Titulo := nil;

  for ContLinha := 1 to ARetorno.Count - 2 do
  begin
     Linha := ARetorno[ContLinha];

     if copy(Linha, 8, 1) <> '3' then // verifica se o registro (linha) � um registro detalhe (segmento J)
        Continue;

     if copy(Linha, 14, 1) = 'T' then // se for segmento T cria um novo titulo
        Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

     if Assigned(Titulo) then
     with Titulo do
     begin
        if copy(Linha, 14, 1) = 'T' then
        begin
          SeuNumero := copy(Linha, 106, 25);
          NumeroDocumento := copy(Linha, 59, fpTamanhoNumeroDocumento);
          Carteira := copy(Linha, DefinePosicaoCarteiraRetorno, TamanhoCarteira);

          case strtoint(copy(Linha, 58, 1)) of
            1: CaracTitulo := tcSimples;
            2: CaracTitulo := tcVinculada;
            3: CaracTitulo := tcCaucionada;
            4: CaracTitulo := tcDescontada;
            5: CaracTitulo := tcVendor;
          end;

           TempData := copy(Linha, 74, 2) + '/'+copy(Linha, 76, 2)+'/'+copy(Linha, 78, 4);
           if TempData <> '00/00/0000' then
              Vencimento := StringToDateTimeDef(TempData, 0, 'DD/MM/YYYY');

           ValorDocumento := StrToFloatDef(copy(Linha, 82, 15), 0) / 100;
           NossoNumero    := DefineNossoNumeroRetorno(Linha);
           ValorDespesaCobranca := StrToFloatDef(copy(Linha, 199, 15), 0) / 100;

           OcorrenciaOriginal.Tipo := CodOcorrenciaToTipo(StrToIntDef(copy(Linha, 16, 2), 0));

           IdxMotivo := 214;

           while (IdxMotivo < 223) do
           begin
              if (trim(Copy(Linha, IdxMotivo, 2)) <> '')  and (trim(Copy(Linha, IdxMotivo, 2)) <> '00') then
              begin
                 MotivoRejeicaoComando.Add(Copy(Linha, IdxMotivo, 2));
                 DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo, StrToIntDef(Copy(Linha, IdxMotivo, 2), 0)));
              end;
              Inc(IdxMotivo, 2);
           end;

        end
        else // segmento U
        begin
           ValorIOF            := StrToFloatDef(copy(Linha, 63, 15), 0) / 100;
           ValorAbatimento     := StrToFloatDef(copy(Linha, 48, 15), 0) / 100;
           ValorDesconto       := StrToFloatDef(copy(Linha, 33, 15), 0) / 100;
           ValorMoraJuros      := StrToFloatDef(copy(Linha, 18, 15), 0) / 100;
           ValorOutrosCreditos := StrToFloatDef(copy(Linha, 123, 15), 0) / 100;
           ValorOutrasDespesas := StrToFloatDef(copy(Linha, 108, 15), 0) / 100;
           ValorRecebido       := StrToFloatDef(copy(Linha, 78, 15), 0) / 100;

           TempData            := copy(Linha, 138, 2)+'/'+copy(Linha, 140, 2)+'/'+copy(Linha, 142, 4);
           if TempData <> '00/00/0000' then
               DataOcorrencia  := StringToDateTimeDef(TempData, 0, 'DD/MM/YYYY');

           TempData := copy(Linha, 146, 2)+'/'+copy(Linha, 148, 2)+'/'+copy(Linha, 150, 4);
           if TempData <> '00/00/0000' then
               DataCredito     := StringToDateTimeDef(TempData, 0, 'DD/MM/YYYY');
        end;
     end;
  end;
end;

function TACBrBancoCresol.DefineCodigoMulta(const ACBrTitulo: TACBrTitulo): String;
begin
  with ACBrTitulo do
  begin
    if(PercentualMulta > 0)then
      Result := '2'
    else
      Result := '1';
  end;
end;

function TACBrBancoCresol.DefinePosicaoNossoNumeroRetorno: Integer;
begin
  if ACBrBanco.ACBrBoleto.LayoutRemessa = c240 then
    Result := 38
  else
    Result := 71;

end;

function TACBrBancoCresol.GerarRegistroHeader240(NumeroRemessa: Integer): String;
var LNome : String;
begin
  LNome := fpNome;
  try
    fpNome := 'CRESOL CONFEDERA��O';
    Result := inherited GerarRegistroHeader240(NumeroRemessa);
  finally
    fpNome := LNome;
  end;
end;

function TACBrBancoCresol.GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): String;
var
  AEspecieTitulo,
  ATipoInscricao,
  ATipoOcorrencia,
  ATipoBoleto,
  ADataMoraJuros,
  ADataDesconto,
  ACodigoMulta,
  ADataMulta,
  ATipoAceite,
  NossoNum                : string;
  strCarteiraEnvio        : Char;
  ACodProtesto            : Char;
  DataProtestoNegativacao : string;
  DiasProtestoNegativacao : string;
begin
  if (ACBrTitulo.NossoNumero <> IntToStrZero(0, length(ACBrTitulo.NossoNumero))) then
    NossoNum := RemoveString('-', MontarCampoNossoNumero(ACBrTitulo))
  else
    NossoNum := ACBrTitulo.NossoNumero;

  with ACBrTitulo do
  begin
    {SEGMENTO P}
    {Pegando o Tipo de Ocorrencia}
    case OcorrenciaOriginal.Tipo of
      toRemessaBaixar                         : ATipoOcorrencia := '02';
      toRemessaConcederAbatimento             : ATipoOcorrencia := '04';
      toRemessaCancelarAbatimento             : ATipoOcorrencia := '05';
      toRemessaAlterarVencimento              : ATipoOcorrencia := '06';
      toRemessaProtestar                      : ATipoOcorrencia := '09';
      toRemessaCancelarInstrucaoProtestoBaixa : ATipoOcorrencia := '10';
      toRemessaCancelarInstrucaoProtesto      : ATipoOcorrencia := '11';
    else
      ATipoOcorrencia := '01';
    end;

    {Pegando o Aceite do T�tulo }
    case Aceite of
      atSim : ATipoAceite := 'A';
      atNao : ATipoAceite := 'N';
    end;

    {Pegando Tipo de Boleto}
    case ACBrBoleto.Cedente.ResponEmissao of
      tbBancoEmite      : ATipoBoleto := '1';
      tbCliEmite        : ATipoBoleto := '2';
      tbBancoReemite    : ATipoBoleto := '3';
      tbBancoNaoReemite : ATipoBoleto := '4';
    end;

    {Pegando Tipo de Sacado}
    if (Length(OnlyNumber(Sacado.CNPJCPF)) > 11) then
      Sacado.Pessoa := pJuridica
    else
      Sacado.Pessoa := pFisica;

    {Pegando especie do t�tulo}
    if EspecieDoc = 'CH' then
      AEspecieTitulo := '01'
    else if EspecieDoc = 'DM' then
      AEspecieTitulo := '02'
    else if EspecieDoc = 'DMI' then
      AEspecieTitulo := '02'
    else if EspecieDoc = 'DS' then
      AEspecieTitulo := '04'
    else if EspecieDoc = 'DSI' then
      AEspecieTitulo := '04'
    else if EspecieDoc = 'DR' then
      AEspecieTitulo := '06'
    else if EspecieDoc = 'LC' then
      AEspecieTitulo := '07'
    else if EspecieDoc = 'NP' then
      AEspecieTitulo := '12'
    else if EspecieDoc = 'RC' then
      AEspecieTitulo := '17'
    else if EspecieDoc = 'ND' then
      AEspecieTitulo := '19'
    else if EspecieDoc = 'BDP' then
      AEspecieTitulo := '32'
    else
      AEspecieTitulo := '99';

    {Descontos}
    if (ValorDesconto > 0) then
    begin
      if (DataDesconto > 0) then
        ADataDesconto := FormatDateTime('ddmmyyyy', DataDesconto)
      else
        ADataDesconto := PadLeft('', 8, '0');
    end
    else
      ADataDesconto := PadLeft('', 8, '0');

    {C�digo para Protesto / Negativa��o}
    case CodigoNegativacao of
      cnProtestarCorrido : ACodProtesto := '1';
      cnProtestarUteis   : ACodProtesto := '1';
    else
      case TipoDiasProtesto of
        diCorridos : ACodProtesto := '1';
        diUteis    : ACodProtesto := '1';
      else
        ACodProtesto := '3';
      end;
    end;

    {Data e Dias de Protesto / Negativa��o}
    if (ACodProtesto <> '3') then
    begin
      DataProtestoNegativacao := DateToStr(DataProtesto);
      DiasProtestoNegativacao := IntToStr(DiasDeProtesto);
    end
    else
    begin
      DataProtestoNegativacao := '';
      DiasProtestoNegativacao := '0';
    end;

    if (CodigoMora = '') then
    begin
      if (ValorMoraJuros > 0) then // cjValorDia, cjTaxaMensal
      begin
        case CodigoMoraJuros of
          cjValorDia: CodigoMora   := '1';
          cjTaxaMensal: CodigoMora := '2';
        else
          raise Exception.create(ACBrStr('Informar CodigoMoraJuros (cjValordia/cjTaxaMensal) !'));
        end;
      end;
    end;

    {Mora Juros}
    if (ValorMoraJuros > 0) then
    begin
      if (DataMoraJuros > 0) then
        ADataMoraJuros := FormatDateTime('ddmmyyyy', DataMoraJuros)
      else
        ADataMoraJuros := PadLeft('', 8, '0');
    end
    else
    begin
      ADataMoraJuros := PadLeft('', 8, '0');
    end;

    if (ACBrTitulo.CarteiraEnvio = tceCedente) then
      strCarteiraEnvio := '2'
    else
      strCarteiraEnvio := '1';

    {C�digo Multa}
    ACodigoMulta := DefineCodigoMulta(ACBrTitulo);

    {Data Multa}
    ADataMulta := DefineDataMulta(ACBrTitulo);

    Result := IntToStrZero(ACBrBanco.Numero, 3)                         + //1 a 3 - C�digo do banco
              '0001'                                                    + //4 a 7 - Lote de servi�o
              '3'                                                       + //8 - Tipo do registro: Registro detalhe
              IntToStrZero((fpQtdRegsLote)+ 1, 5)     + //9 a 13 - N�mero seq�encial do registro no lote - Cada registro possui dois segmentos
              'P'                                                       + //14 - C�digo do segmento do registro detalhe
              ' '                                                       + //15 - Uso exclusivo FEBRABAN/CNAB: Branco
              ATipoOcorrencia                                           + //16 a 17 - C�digo de movimento
              PadLeft(OnlyNumber(ACBrBoleto.Cedente.Agencia), 5, '0')   + //18 a 22 - Ag�ncia mantenedora da conta
              '0'                                                       + //23 - Digito agencia
              PadLeft(OnlyNumber(ACBrBoleto.Cedente.Conta), 12, '0')    + //24 a 35 - N�mero da Conta Corrente
              PadLeft(ACBrBoleto.Cedente.ContaDigito, 1, '0')           + //36 - D�gito da Conta Corrente
              ' '                                                       + //37 - DV Ag�ncia/COnta Brancos
              '00000000'                                                + //38 a 45 - Identific. do Produto
              PadLeft(NossoNum, 12, '0')                                + //46 a 57 - Nosso N�mero e Digito do nosso N�m
              PadRight(Carteira, 1)                                     + //58 - Carteira
              '0'                                                       + //59 - Forma de cadastramento no banco
              '0'                                                       + //60 - Tipo de Documento
              ATipoBoleto                                               + //61 - Identifica��o da emiss�o do boleto
              strCarteiraEnvio                                          + //62 - Identifica��o da distribui��o
              PadRight(NumeroDocumento, 15, ' ')                         + //63 a 77 - N�mero que identifica o t�tulo na empresa
              FormatDateTime('ddmmyyyy', Vencimento)                    + //78 a 85 - Data de vencimento do t�tulo
              IntToStrZero(round(ValorDocumento * 100), 15)             + //86 a 100 - Valor nominal do t�tulo
              '00000'                                                   + //101 a 105 - Ag�ncia cobradora. // Ficando com Zeros o Ita� definir� a ag�ncia cobradora pelo CEP do sacado
              ' '                                                       + //106 - D�gito da ag�ncia cobradora
              PadRight(AEspecieTitulo, 2)                               + //107 a 108 - Esp�cie do documento
              ATipoAceite                                               + //109 - Identifica��o de t�tulo Aceito / N�o aceito
              FormatDateTime('ddmmyyyy', DataDocumento)                 + //110 a 117 - Data da emiss�o do documento
              PadRight(CodigoMora, 1, '0')                              + //118 - Codigo Mora (juros) - 1) Por dia, 2) Taxa mensal e 3) Isento
              ADataMoraJuros                                            + //119 a 126 - Data a partir da qual ser�o cobrados juros
              IntToStrZero(Round(ValorMoraJuros * 100), 15)             + //127 a 141 - Valor de juros de mora por dia
              TipoDescontoToString(TipoDesconto)                        + //142 - "C�digo do Desconto 1
                                                                          // '0'  =  N�o Conceder desconto
                                                                          // '1'  =  Valor Fixo At� a Data Informada
                                                                          // '2'  =  Percentual At� a Data Informada"
              ADataDesconto                                             + //143 a 150 - Data limite para desconto
              IfThen(ValorDesconto > 0,
                     IntToStrZero(round(ValorDesconto * 100), 15),
                     PadLeft('', 15, '0'))                              + //151 a 165 - Valor do desconto por dia
              IntToStrZero(round(ValorIOF * 100), 15)                   + //166 a 180 - Valor do IOF a ser recolhido
              IntToStrZero(round(ValorAbatimento * 100), 15)            + //181 a 195 - Valor do abatimento
              PadRight(SeuNumero, 25, ' ')                              + //196 a 220 - Identifica��o do t�tulo na empresa
              IfThen((DataProtestoNegativacao <> '') and
                     (StrToInt(DiasProtestoNegativacao) > 0),
                     ACodProtesto, '3')                                 + //221 - C�digo de protesto
              IfThen((DataProtestoNegativacao <> '') and
                     (StrToInt(DiasProtestoNegativacao) > 0),
                     PadLeft(DiasProtestoNegativacao, 2, '0'),
                     '00')                                              + //222 a 223 - Prazo para protesto (em dias)
              '0'                                                       + //224 - C�digo de Baixa
              space(3)                                                  + //225 a 227 - Dias para baixa
              '09'                                                      + //228 a 229 - C�digo da Moeda
              '00000000000';                                              //230 a 240 zeros
    Inc(fpQtdRegsLote);

    {SEGMENTO Q}
    {Pegando tipo de pessoa do Sacado}
    case Sacado.Pessoa of
      pFisica   : ATipoInscricao := '1';
      pJuridica : ATipoInscricao := '2';
      pOutras   : ATipoInscricao := '9';
    end;

    Result := Result + sLineBreak +
              IntToStrZero(ACBrBanco.Numero, 3)                          + //1 a 3 - C�digo do banco
              '0001'                                                     + //4 a 7 - N�mero do lote
              '3'                                                        + //8 - Tipo do registro: Registro detalhe
              IntToStrZero((fpQtdRegsLote)+ 1, 5)      + //9 a 13 - N�mero seq�encial do registro no lote - Cada registro possui dois segmentos
              'Q'                                                        + //14 - C�digo do segmento do registro detalhe
              ' '                                                        + //15 - Uso exclusivo FEBRABAN/CNAB: Branco
              ATipoOcorrencia                                            + //16 a 17 - C�digo de movimento
              ATipoInscricao                                             + //18 a 18 - Tipo inscricao
              PadLeft(OnlyNumber(Sacado.CNPJCPF), 15, '0')               + //19 a 33 - N�mero de Inscri��o
              PadRight(Sacado.NomeSacado, 40, ' ')                       + //34 a 73 - Nome
              PadRight(Sacado.Logradouro + ' ' + Sacado.Numero + ' '     +
                       Sacado.Complemento, 40, ' ')                      + //74 a 113 - Endere�o
              PadRight(Sacado.Bairro, 15, ' ')                           + //114 a 128 - Bairro
              PadLeft(Sacado.CEP, 8, '0')                                + //129 a 136 - CEP
              PadRight(Sacado.Cidade, 15, ' ')                           + //137 a 151 - Cidade
              PadRight(Sacado.UF, 2, ' ')                                + //152 a 153 - UF
              '0'                                                        + //154 a 154 - Tipo de inscri��o: N�o informado
              PadLeft('0', 15, '0')                                      + //155 a 169 - N�mero de inscri��o
              space(40)                                                  + //170 a 209 - Nome do sacador/avalista
              '000'                                                      + //210 a 212 - Uso exclusivo FEBRABAN/CNAB
              space(28);                                                   //213 a 240 - Uso exclusivo FEBRABAN/CNAB
    Inc(fpQtdRegsLote);

    {SEGMENTO R OPCIONAL }
    if (TipoDesconto2<>tdNaoConcederDesconto) or
       (TipoDesconto3<>tdNaoConcederDesconto) or
       (PercentualMulta > 0) then
    begin
      Result := Result + sLineBreak +
                IntToStrZero(ACBrBanco.Numero, 3)                      + //1 a 3 - C�digo do banco
                '0001'                                                 + //4 a 7 - N�mero do lote
                '3'                                                    + //8 - Tipo do registro: Registro detalhe
                IntToStrZero((fpQtdRegsLote)+ 1, 5)  + //9 a 13 - N�mero seq�encial do registro no lote - Cada registro possui dois segmentos
                'R'                                                    + //14 - C�digo do segmento do registro detalhe
                ' '                                                    + //CNAB Uso Exclusivo FEBRABAN/CNAB 15 15 1 - Alfa Brancos G004
                ATipoOcorrencia                                        + //C�digo de Movimento Remessa 16 17 2 - Num *C004
                TipoDescontoToString(TipoDesconto2)                    + //C�digo do Desconto 2 18 18 1 - Num *C021
                PadLeft(IfThen(TipoDesconto2<>tdNaoConcederDesconto,IfThen(DataDesconto2  > 0, FormatDateTime( 'ddmmyyyy', DataDesconto2),''),''),8,'0') + //Data do Desconto 2 19 26 8 - Num C022
                PadLeft(IfThen(TipoDesconto2<>tdNaoConcederDesconto,IfThen(ValorDesconto2 > 0,IntToStrZero(round(ValorDesconto2 * 100), 15),''),''), 15, '0') + //Valor/Percentual a ser Concedido 27 41 13 2 Num C023
                TipoDescontoToString(TipoDesconto3)                    + //C�digo do Desconto 3 42 42 1 - Num *C021
                PadLeft(IfThen(TipoDesconto3<>tdNaoConcederDesconto,IfThen(DataDesconto3  > 0, FormatDateTime( 'ddmmyyyy', DataDesconto3),'0'),'0'),8,'0') + //Data do Desconto 3 43 50 8 - Num C022
                PadLeft(IfThen(TipoDesconto3<>tdNaoConcederDesconto,IfThen(ValorDesconto3 > 0,IntToStrZero(round(ValorDesconto3 * 100), 15),''),''), 15, '0') + //Valor/Percentual a Ser Concedido 51 65 13 2 Num C023
                ACodigoMulta                                           + //C�digo da Multa 66 66 1 - Alfa G073
                ADataMulta                                             + //Data da Multa 67 74 8 - Num G074
                IfThen(PercentualMulta > 0,
                  IntToStrZero(round(PercentualMulta * 100), 15),
                PadRight('', 15, '0'))                                 + //Multa Valor/Percentual a Ser Aplicado 75 89 13 2 Num G075
                PadRight('', 10, ' ')                                  + //Informa��o ao Pagador Informa��o ao Pagador 90 99 10 - Alfa *C036
                PadRight('', 40, ' ')                                  + //Informa��o 3 Mensagem 3 100 139 40 - Alfa *C037
                PadRight('', 40, ' ')                                  + //Mensagem 4 140 179 40 - Alfa *C037
                PadRight('', 20, ' ')                                  + //CNAB Uso Exclusivo FEBRABAN/CNAB 180 199 20 - Alfa Brancos G004
                PadLeft('', 8, '0')                                    + //C�d. Ocor. do Pagador 200 207 8 - Num *C038
                PadLeft('', 3, '0')                                    + //C�d. do Banco na Conta do D�bito 208 210 3 - Num G001
                PadLeft('', 5, '0')                                    + //C�digo da Ag�ncia do D�bito 211 215 5 - Num *G008
                PadLeft('', 1, ' ')                                    + //D�gito Verificador da Ag�ncia 216 216 1 - Alfa *G009
                PadLeft('', 12, '0')                                   + //Corrente para D�bito 217 228 12 - Num *G010
                PadLeft('', 1, ' ')                                    + //D�gito Verificador da Conta 229 229 1 - Alfa *G011
                PadLeft('', 1, ' ')                                    + //DV D�gito Verificador Ag/Conta 230 230 1 - Alfa *G012
                PadLeft('', 1, '0')                                    + //Ident. da Emiss�o do Aviso D�b. Aviso para D�bito Autom�tico 231 231 1 - Num *C039
                PadLeft('',9, ' ');                                      //CNAB Uso Exclusivo FEBRABAN/CNAB 232 240 9 - Alfa Brancos G004
      Inc(fpQtdRegsLote);
    end;

  end;
end;

end.

