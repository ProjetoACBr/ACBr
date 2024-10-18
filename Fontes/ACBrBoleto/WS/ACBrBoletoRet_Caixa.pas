{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Jos� M S Junior                                }
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

unit ACBrBoletoRet_Caixa;

interface

uses
  Classes,
  SysUtils,
  ACBrBoleto,
  ACBrBoletoWS,
  ACBrBoletoRetorno,
  DateUtils,
  pcnConversao,
  ACBrBoletoWS.SOAP;

type

{ TRetornoEnvio_Caixa }

 TRetornoEnvio_Caixa = class(TRetornoEnvioSOAP)
  private
    function RetornaCodigoOcorrencia(const ASituacao: string) : String;
  public
    constructor Create(ABoletoWS: TACBrBoleto); override;
    destructor  Destroy; Override;
    function LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean;override;
    function RetornoEnvio(const AIndex: Integer): Boolean; override;

  end;

implementation

uses
  ACBrBoletoConversao, ACBrUtil.XMLHTML;

{ TRetornoEnvio }

constructor TRetornoEnvio_Caixa.Create(ABoletoWS: TACBrBoleto);
begin
  inherited Create(ABoletoWS);

end;

destructor TRetornoEnvio_Caixa.Destroy;
begin
  inherited Destroy;
end;

function TRetornoEnvio_Caixa.LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean;
var
  Ok: Boolean;
  //RetornoCaixa: TACBrBoletoRetornoWS;
  i: Integer;
  lXML: String;
  TipoOperacao : TOperacao;
begin
  Result := True;

  lXML:= StringReplace(Leitor.Arquivo, 'sibar_base:', '', [rfReplaceAll]) ;
  Leitor.Arquivo := lXML;
  Leitor.Grupo := Leitor.Arquivo;//StringReplace(Leitor.Arquivo, 'sibar_base:"', '', [rfReplaceAll] );

  ARetornoWS.HTTPResultCode  := HTTPResultCode;
  ARetornoWS.JSONEnvio       := EnvWs;
  ARetornoWS.Header.Operacao := ACBrBoleto.Configuracoes.WebService.Operacao;

  //RetornoCaixa:= ACBrBoleto.CriarRetornoWebNaLista;
  try
    //with RetornoCaixa do
    with ARetornoWS do
    begin
      TipoOperacao := ACBrBoleto.Configuracoes.WebService.Operacao;
      ARetornoWS.HTTPResultCode  := HTTPResultCode;
      ARetornoWS.JSONEnvio       := EnvWs;
      ARetornoWS.Header.Operacao := TipoOperacao;
      CodRetorno := Leitor.rCampo(tcStr, 'COD_RETORNO');
      OriRetorno := Leitor.rCampo(tcStr, 'ORIGEM_RETORNO');
      MsgRetorno := Leitor.rCampo(tcStr, 'MSG_RETORNO');

      if leitor.rExtrai(1, 'HEADER') <> '' then
      begin
        with Header do
        begin
          Versao          := Leitor.rCampo(tcStr, 'VERSAO');
          Autenticacao    := Leitor.rCampo(tcStr, 'AUTENTICACAO');
          Usuario_Servico := Leitor.rCampo(tcStr, 'USUARIO_SERVICO');
          Usuario         := Leitor.rCampo(tcStr, 'USUARIO');
          Operacao        := StrToTipoOperacao(Ok, Leitor.rCampo(tcStr, 'OPERACAO'));
          Indice          := Leitor.rCampo(tcInt, 'INDICE');
          Sistema_Origem  := Leitor.rCampo(tcStr, 'SISTEMA_ORIGEM');
          Agencia         := Leitor.rCampo(tcInt, 'UNIDADE');
          Id_Origem       := Leitor.rCampo(tcStr, 'IDENTIFICADOR_ORIGEM');
          Data_Hora       := Leitor.rCampo(tcDatHorCFe, 'DATA_HORA');
          Id_Processo     := Leitor.rCampo(tcStr, 'ID_PROCESSO');
        end;
      end;

      with DadosRet do
      begin
        if leitor.rExtrai(1, 'DADOS') <> '' then
        begin
          Excecao := Leitor.rCampo(tcStr, 'EXCECAO');

          if leitor.rExtrai(2, 'CONTROLE_NEGOCIAL') <> '' then
          begin
            with ControleNegocial do
            begin
              OriRetorno := Leitor.rCampo(tcStr, 'ORIGEM_RETORNO');
              CodRetorno := Leitor.rCampo(tcStr, 'COD_RETORNO');
              NSU        := Leitor.rCampo(tcStr, 'NSU');
              if leitor.rExtrai(3, 'MENSAGENS') <> '' then
              begin
                  Retorno := Leitor.rCampo(tcStr, 'RETORNO');
              end;
            end;
          end;

          if leitor.rExtrai(2, 'COMPROVANTE') <> '' then
          begin
            Comprovante.Data := Leitor.rCampo(tcDat, 'DATA');
            Comprovante.Hora := Leitor.rCampo(tcStr, 'HORA');
          end;

          if (leitor.rExtrai(2, 'INCLUI_BOLETO') <> '') or
             (leitor.rExtrai(2, 'BAIXA_BOLETO') <> '') or
             (leitor.rExtrai(2, 'ALTERA_BOLETO') <> '') then
          begin
            DadosRet.IDBoleto.CodBarras := Leitor.rCampo(tcStr, 'CODIGO_BARRAS');
            DadosRet.IDBoleto.LinhaDig  := Leitor.rCampo(tcStr, 'LINHA_DIGITAVEL');
            DadosRet.IDBoleto.NossoNum  := Leitor.rCampo(tcStr, 'NOSSO_NUMERO');
            DadosRet.IDBoleto.URL       := Leitor.rCampo(tcStr, 'URL');

            if ACBrBoleto.Cedente.CedenteWS.IndicadorPix then
              DadosRet.TituloRet.EMV := Leitor.rCampo(tcStr, 'QRCODE');
          end;

          if leitor.rExtrai(2, 'CONSULTA_BOLETO') <> '' then
          begin
            if leitor.rExtrai(3, 'TITULO') <> ''  then
            begin
              ControleNegocial.Retorno := Leitor.rCampo(tcStr, 'SITUACAO');
              TituloRet.EstadoTituloCobranca := ControleNegocial.Retorno;
              TituloRet.CodigoEstadoTituloCobranca := RetornaCodigoOcorrencia(AnsiUpperCase(ControleNegocial.Retorno));

              TituloRet.NumeroDocumento         := Leitor.rCampo(tcStr, 'NUMERO_DOCUMENTO');
              TituloRet.Vencimento              := Leitor.rCampo(tcDat, 'DATA_VENCIMENTO');
              TituloRet.ValorDocumento          := Leitor.rCampo(tcDe2, 'VALOR');
              TituloRet.EspecieDoc              := Leitor.rCampo(tcStr, 'TIPO_ESPECIE');
              TituloRet.Aceite                  := StrToAceite(Ok, Leitor.rCampo(tcStr, 'FLAG_ACEITE'));
              TituloRet.DataDocumento           := Leitor.rCampo(tcDat, 'DATA_EMISSAO');
              TituloRet.DataRegistro            := Leitor.rCampo(tcDat, 'DATA_EMISSAO');
              TituloRet.ValorAbatimento         := Leitor.rCampo(tcDe2, 'VALOR_ABATIMENTO');
              TituloRet.EspecieMod              := Leitor.rCampo(tcInt, 'CODIGO_MOEDA');

              TituloRet.ValorIOF                := Leitor.rCampo(tcDe2, 'VALOR_IOF');
              TituloRet.SeuNumero               := Leitor.rCampo(tcStr, 'IDENTIFICACAO_EMPRESA');

              TituloRet.CodBarras               := Leitor.rCampo(tcStr, 'CODIGO_BARRAS');
              TituloRet.LinhaDig                := Leitor.rCampo(tcStr, 'LINHA_DIGITAVEL');
              TituloRet.URL                     := Leitor.rCampo(tcStr, 'URL');

              TituloRet.ValorPago               := Leitor.rCampo(tcDe2, 'VALOR_PAGO');
              TituloRet.DataCredito             := Leitor.rCampo(tcDatHor, 'DATA_HORA_PAGAMENTO');
              TituloRet.DataBaixa               := Leitor.rCampo(tcDatHor, 'DATA_HORA_PAGAMENTO');

              if ACBrBoleto.Cedente.CedenteWS.IndicadorPix then
                DadosRet.TituloRet.EMV := Leitor.rCampo(tcStr, 'QRCODE');

              if leitor.rExtrai(4, 'JUROS_MORA') <> '' then
              begin
                TituloRet.CodigoMoraJuros       := StrToTipoJuros(Ok, Leitor.rCampo(tcStr, 'TIPO'));
                TituloRet.DataMoraJuros         := Leitor.rCampo(tcDat, 'DATA');
                if (TituloRet.CodigoMoraJuros = cjValorDia) then
                  TituloRet.ValorMoraJuros      := Leitor.rCampo(tcDe2, 'VALOR')
                else
                  TituloRet.ValorMoraJuros      := Leitor.rCampo(tcDe2, 'PERCENTUAL');
              end;

              if leitor.rExtrai(4, 'POS_VENCIMENTO') <> '' then
              begin
                TituloRet.CodigoNegativacao     := StrToTipoNegativacao(Ok, Leitor.rCampo(tcStr, 'ACAO'));
                TituloRet.DiasDeProtesto        := Leitor.rCampo(tcInt, 'NUMERO_DIAS');
              end;

              if leitor.rExtrai(4, 'PAGADOR') <> '' then
              begin
                TituloRet.Sacado.CNPJCPF        := Leitor.rCampoCNPJCPF;
                TituloRet.Sacado.NomeSacado     := Leitor.rCampo(tcStr, 'NOME');
                if (TituloRet.Sacado.NomeSacado = '') then
                  TituloRet.Sacado.NomeSacado   := Leitor.rCampo(tcStr, 'RAZAO_SOCIAL');

                if leitor.rExtrai(5, 'ENDERECO') <> '' then
                begin
                  TituloRet.Sacado.Logradouro := Leitor.rCampo(tcStr, 'LOGRADOURO');
                  TituloRet.Sacado.Bairro     := Leitor.rCampo(tcStr, 'BAIRRO');
                  TituloRet.Sacado.Cidade     := Leitor.rCampo(tcStr, 'CIDADE');
                  TituloRet.Sacado.UF         := Leitor.rCampo(tcStr, 'UF');
                  TituloRet.Sacado.Cep        := Leitor.rCampo(tcStr, 'CEP');
                end;
              end;

              if leitor.rExtrai(4, 'SACADOR_AVALISTA') <> '' then
              begin
                TituloRet.SacadoAvalista.CNPJCPF := Leitor.rCampoCNPJCPF;
                TituloRet.SacadoAvalista.NomeAvalista    := Leitor.rCampo(tcStr, 'NOME');
                if TituloRet.SacadoAvalista.NomeAvalista = '' then
                  TituloRet.SacadoAvalista.NomeAvalista  := Leitor.rCampo(tcStr, 'RAZAO_SOCIAL');
              end;

              if leitor.rExtrai(4, 'MULTA') <> '' then
              begin
                TituloRet.DataMulta        := Leitor.rCampo(tcDat, 'DATA');
                TituloRet.PercentualMulta  := Leitor.rCampo(tcDe2, 'VALOR');
                TituloRet.CodigoMulta  := cmValorFixo;
                if (TituloRet.PercentualMulta = 0) then
                begin
                  TituloRet.PercentualMulta  := Leitor.rCampo(tcDe2, 'PERCENTUAL');
                  TituloRet.CodigoMulta  := cmPercentual;
                end;
              end;

              if leitor.rExtrai(4, 'DESCONTOS') <> '' then
              begin
                if (leitor.rExtrai(5, 'DESCONTO', '', 1) <> '') then
                begin
                  TituloRet.DataDesconto       := Leitor.rCampo(tcDat, 'DATA');
                  TituloRet.ValorDesconto      := Leitor.rCampo(tcDe2, 'VALOR');
                  if (TituloRet.ValorDesconto = 0) then
                    TituloRet.CodigoDesconto    := Leitor.rCampo(tcDe2, 'PERCENTUAL')
                  else
                    TituloRet.CodigoDesconto   := cdValorFixo;
                end;

                if (leitor.rExtrai(5, 'DESCONTO', '', 2) <> '') then
                begin
                  TituloRet.DataDesconto2       := Leitor.rCampo(tcDat, 'DATA');
                  TituloRet.ValorDesconto2      := Leitor.rCampo(tcDe2, 'VALOR');
                  if (TituloRet.ValorDesconto2 = 0) then
                    TituloRet.CodigoDesconto    := Leitor.rCampo(tcDe2, 'PERCENTUAL')
                  else
                    TituloRet.CodigoDesconto   := cdValorFixo;
                end;

              end;

              if leitor.rExtrai(4, 'FICHA_COMPENSACAO') <> '' then
              begin
                if leitor.rExtrai(5, 'MENSAGENS') <> '' then
                begin
                  i:= 0;
                  while (Leitor.rExtrai(6, 'MENSAGEM', '', i + 1) <> '') do
                  begin
                    TituloRet.Mensagem.Add(Leitor.rCampo(tcStr, 'MENSAGEM'));
                    inc(i);
                  end;
                end;
              end;

              if leitor.rExtrai(4, 'RECIBO_PAGADOR') <> '' then
              begin
                if leitor.rExtrai(5, 'MENSAGENS') <> '' then
                begin
                  if (Leitor.rExtrai(6, 'MENSAGEM', '', 1) <> '') then
                    TituloRet.Instrucao1:= Leitor.rCampo(tcStr, 'MENSAGEM');
                  if (Leitor.rExtrai(6, 'MENSAGEM', '', 2) <> '') then
                    TituloRet.Instrucao2:= Leitor.rCampo(tcStr, 'MENSAGEM');
                  if (Leitor.rExtrai(6, 'MENSAGEM', '', 3) <> '') then
                    TituloRet.Instrucao3:= Leitor.rCampo(tcStr, 'MENSAGEM');

                end;
              end;

              if leitor.rExtrai(4, 'PAGAMENTO') <> '' then
              begin
                TituloRet.QtdePagamentoParcial := Leitor.rCampo(tcInt, 'QUANTIDADE_PERMITIDA');
                TituloRet.TipoPagamento        := StrToTipoPagamento(Ok, Leitor.rCampo(tcStr, 'TIPO'));
                TituloRet.ValorMinPagamento    := Leitor.rCampo(tcDe2, 'VALOR_MINIMO');
                TituloRet.ValorMaxPagamento    := Leitor.rCampo(tcDe2, 'VALOR_MAXIMO');
                TituloRet.PercentualMinPagamento:= Leitor.rCampo(tcDe2, 'PERCENTUAL_MINIMO');
                TituloRet.PercentualMaxPagamento:= Leitor.rCampo(tcDe2, 'PERCENTUAL_MAXIMO');
              end;
            end;
          end;

        end;
      end;
    end;

  except
    Result := False;
  end;

end;

function TRetornoEnvio_Caixa.RetornaCodigoOcorrencia(const ASituacao: string) : String;
begin
  Result := '';
  if pos('EM ABERTO', ASituacao) > 0 then
    Result := '01'
  else
  if pos('BAIXA POR DEVOLUCAO', ASituacao) > 0 then
    Result := '07'
  else
  if pos('BAIXA POR ESTORNO', ASituacao) > 0 then
    Result := '07'
  else
  if pos('BAIXA POR PROTESTO', ASituacao) > 0 then
    Result := '13'
  else
  if pos('ENVIADO AO CARTORIO', ASituacao) > 0 then
    Result := '02'
  else
  if pos('LIQUIDADO NO CARTORIO', ASituacao) > 0 then
    Result := '10'
  else
  if pos('LIQUIDADO', ASituacao) > 0 then
    Result := '06'
  else
  if pos('TITULO JA PAGO NO DIA', ASituacao) > 0 then
    Result := '06'
end;

function TRetornoEnvio_Caixa.RetornoEnvio(const AIndex: Integer): Boolean;
var
  lRetornoWS: String;
begin

  lRetornoWS := RetWS;
  RetWS := SeparaDados(lRetornoWS, 'soapenv:Body');

  Result:=inherited RetornoEnvio(AIndex);

end;

end.

