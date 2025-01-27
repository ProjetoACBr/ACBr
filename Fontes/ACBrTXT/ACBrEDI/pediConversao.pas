{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit pediConversao;

{$I ACBr.inc}

interface

uses pcnConversao, SysUtils, ACBrUtil.Strings ;

type
  {$IFNDEF FPC}
    {$IFNDEF DELPHI2009_UP}
    TDate = TDateTime;
    TTime = TDateTime;
    {$ENDIF}
  {$ENDIF}


  tveEdi            = (ve30, ve30a, ve31, ve50) ;
  tediOperacao      = (toLeitura, toGravacao) ;

  tediSimNao        = (tediSim,tediNao) ;
  tSimNaoST         = (tstSim, tstNao, tstIsento) ;
  tIncideICMS       = (ticSim, ticNao, ticIsento, ticDiferido, ticReduzido, ticPresumido,
                       ticSubstituicao, ticAliqNormal, ticNaoIncide ) ;
  tpAcao            = (tpaInclusao, tpaComplementar, tpaExcluir) ;
  tCondicaoFrete    = (tcfCIF, tcfFOB) ;
  tpFrete           = (tpfNormal, tpfExportacao, tpfImportacao) ;
  tpCobranca        = (tcBanco, tcCarteira) ;
  tpDocCobranca     = (tdcNotaFiscal, tdcRomaneio) ;

  tmTransporte      = (tmNavioTanque        , tmVagaoFerroviarioTanque, tmVagaoFerroviarioGraneleiro,
                       tmExpressoFerroviario, tmCaminhaoCargaSeca     , tmCaminhaoTanque            ,
                       tmRemessaExpressaRodo, tmFreteAereo            , tmExpressoAereo             ,
                       tmEncomendaPostal    , tmCorreioExpresso       , tmCorreioAereo              ,
                       tmMensageiroExpresso , tmPeruas                , tmCaminhonete5Ton           ,
                       tmTocoAberto         , tmTocoFechado           , tmTruckAberto               ,
                       tmTruckFechado       , tmCarretaAberta         , tmCarretaFechada            ,
                       tmTruckRefrigerado   , tmCarretaRefrigerada    , tmTruckSider                ,
                       tmCarretaSider       , tmFurgao3_5Ton          , tmCaminhonete1Ton           ,
                       tmCarreta60Metros3   , tmCarreta80Metros3      , tmConainerBuggy             ,
                       tmContainer20Pes     , tmContainer40Pes        , tmContainer40PesHC          ,
                       tmContainer20PesRefri, tmContainer40PesRefri) ;

  tpCte             = (tpcAjudantes, tpcTransbordoCarga, tpcComplementar, tpcCTeDevolucao, tpcNormalDeEentrada,
                       tpcFreteColeta, tpcCobrancaStretchFilm, tpcEstadias, tpcDespesasManuseioCarga, tpcNormal,
                       tpcNormalDeRetorno, tpcTransportePallets, tpcCTeDeReentrega, tpcNormalDeSaida, tpcNormalDeTtransferenciaInterna,
                       tpcCustoComunicao, tpcComplementarDeRetorno, tpcComplementarDeEntrada, tpcComplementarDeSaida, tpcComplementarDeTransferenciaInterna) ;

  tpDocto           = (tpdNFSe, tpdCTRC, tpdNFe, tpdCTe, tpdOutros, tpdCarteoraDebito) ;
  tDesctoAcrescimo  = (tdaNormal, tdaAcrescimo, tdaDesconto) ;
  tediDireitoFiscal = (tdfExportacao, tdfComST, tdfSemST) ;
  tediImposto       = (tpiExportacao, tpiComST, tpiSemST) ;


// declara��o da fun��es de convers�o dos tipos
function StrToVersaoEdi(out ok: boolean; const s: String ): tveEdi ;
function VersaoEdiToStr(const t: tveEdi): String ;

function StrToSimNaoEdi(out ok: boolean; const s: String ): tediSimNao ;
function SimNaoEdiToStr(const t: tediSimNao): String ;

function StrToSimNaoST(out ok: boolean; const s: String ): tSimNaoST ;
function SimNaoSTToStr(const t: tSimNaoST): String ;

function IncideICMSToStr(const t: tIncideICMS ): string;
function StrToIncideICMS(out ok: boolean; const s: String ): tIncideICMS;

function StrToAcaoEdi(out ok: boolean; const s: String ): tpAcao ;
function AcaoEdiToStr(const t: tpAcao): String ;

function StrToMeioTransporte(out ok: boolean; const s: String ): tmTransporte ;
function MeioTransporteToStr(const t: tmTransporte ): String ;

function StrToTpDocto(out ok: boolean; const s: String ): tpDocto ;
function TpDoctoToStr(const t: tpDocto ): String ;

function StrToTipoCTe(out ok: boolean; const s: String ): tpCte ;
function TipoCTeToStr(const t: tpCte ): String ;

function StrToCondicaoFrete(out ok: boolean; const s: String ): tCondicaoFrete ;
function CondicaoFreteToStr(const t: tCondicaoFrete ): String ;

function StrToDesctoAcrescimo(out ok: boolean; const s: String ): tDesctoAcrescimo ;
function DesctoAcrescimoToStr(const t: tDesctoAcrescimo): String ;

function StrToDireitoFiscal(out ok: boolean; const s: String ): tediDireitoFiscal ;
function DireitoFiscalToStr(const t: tediDireitoFiscal): String ;

function StrToTipoImposto(out ok: boolean; const s: String ): tediImposto ;
function TipoImpostoToStr(const t: tediImposto ): String ;

function StrToTipoFrete(out ok: boolean; const s: String ): tpFrete ;
function TipoFreteToStr(const t: tpFrete ): String ;

function StrToTipoCobranca(out ok: boolean; const s: String ): tpCobranca ;
function TipoCobrancaToStr(const t: tpCobranca ): String ;

function StrToDocCobranca(out ok: boolean; const s: String ): tpDocCobranca ;
function DocCobrancaToStr(const t: tpDocCobranca ): String ;

// fun��es para convers�o de valores e datas
function StringToDouble( const xStr: String; Inteiro, Decimal: Integer ): Double ;
function StringToDate( xStr: String ): TDate ;
function StringToTime( xStr: String ): TTime ;

implementation

// As fun��es abaixo convertem os tipos em seus respectivos valores
function VersaoEdiToStr(const t: tveEdi ): string;
begin
  result := EnumeradoToStr(t, ['3.0', '3.0a', '3.1', '5.0'],
                              [ve30 , ve30a , ve31 , ve50]);
end;

function StrToVersaoEdi(out ok: boolean; const s: string): tveEdi;
begin
  result := StrToEnumerado(ok, s, ['3.0', '3.0a', '3.1', '5.0'],
                                  [ve30 , ve30a , ve31 , ve50]);
end;

function SimNaoEdiToStr(const t: tediSimNao ): string;
begin
  result := EnumeradoToStr(t, ['S', 'N'], [tediSim,tediNao]);
end;

function StrToSimNaoEdi(out ok: boolean; const s: string): tediSimNao;
begin
  result := StrToEnumerado(ok, s, ['S', 'N'], [tediSim,tediNao]);
end;

function SimNaoSTToStr(const t: tSimNaoST ): string;
begin
  result := EnumeradoToStr(t, ['1', '2', '3'], [tstSim, tstNao, tstIsento]);
end;

function StrToSimNaoST(out ok: boolean; const s: string): tSimNaoST;
begin
  result := StrToEnumerado(ok, s, ['1', '2', '3'], [tstSim, tstNao, tstIsento]);
end;

function IncideICMSToStr(const t: tIncideICMS ): string;
begin
  result := EnumeradoToStr(t, ['S', 'N', 'I', 'D', 'R', 'P', 'T', 'S', 'N'],
                              [ticSim, ticNao, ticIsento, ticDiferido, ticReduzido,
                               ticPresumido, ticSubstituicao, ticAliqNormal, ticNaoIncide]);
end;

function StrToIncideICMS(out ok: boolean; const s: string): tIncideICMS;
begin
  result := StrToEnumerado(ok, s, ['S', 'N', 'I', 'D', 'R', 'P', 'T', 'S', 'N'],
                                  [ticSim, ticNao, ticIsento, ticDiferido, ticReduzido,
                                   ticPresumido, ticSubstituicao, ticAliqNormal, ticNaoIncide]);
end;

function AcaoEdiToStr(const t: tpAcao ): string;
begin
  result := EnumeradoToStr(t, ['I', 'C', 'E'], [tpaInclusao, tpaComplementar, tpaExcluir]);
end;

function StrToAcaoEdi(out ok: boolean; const s: string): tpAcao;
begin
  result := StrToEnumerado(ok, s, ['I', 'C', 'E'], [tpaInclusao, tpaComplementar, tpaExcluir]);
end;

function DesctoAcrescimoToStr(const t: tDesctoAcrescimo ): string;
begin
  result := EnumeradoToStr(t, ['N', 'A', 'D'], [tdaNormal, tdaAcrescimo, tdaDesconto]);
end;

function StrToDesctoAcrescimo(out ok: boolean; const s: string): tDesctoAcrescimo ;
begin
  result := StrToEnumerado(ok, s, ['N', 'A', 'D'], [tdaNormal, tdaAcrescimo, tdaDesconto]);
end;

function DireitoFiscalToStr(const t: tediDireitoFiscal ): string;
begin
  result := EnumeradoToStr(t, ['IC3','Z23','IC0'], [tdfExportacao, tdfComST, tdfSemST]);
end;

function StrToDireitoFiscal(out ok: boolean; const s: string): tediDireitoFiscal;
begin
  result := StrToEnumerado(ok, s, ['IC3','Z23','IC0'], [tdfExportacao, tdfComST, tdfSemST]);
end;

function TipoImpostoToStr(const t: tediImposto ): string;
begin
  result := EnumeradoToStr(t, ['ICM3','ICM3','ICM1'], [tpiExportacao, tpiComST, tpiSemST]);
end;

function StrToTipoImposto(out ok: boolean; const s: string): tediImposto;
begin
  result := StrToEnumerado(ok, s, ['ICM3','ICM3','ICM1'], [tpiExportacao, tpiComST, tpiSemST]);
end;

function MeioTransporteToStr(const t: tmTransporte ): string;
begin
  result := EnumeradoToStr(t, ['12', '21', '23', '25', '31', '32', '34', '41',
                               '43', '51', '52', '55', '101', 'BR01', 'BR02', 'BR03',
                               'BR04', 'BR05', 'BR06', 'BR07', 'BR08', 'BR10', 'BR11',
                               'BR12', 'BR13', 'BR50', 'BR51', 'BR60', 'BR80', 'CTB', 'C20',
                               'C40', 'C4H', 'C2R', 'C4R'],
                              [tmNavioTanque        , tmVagaoFerroviarioTanque, tmVagaoFerroviarioGraneleiro,
                               tmExpressoFerroviario, tmCaminhaoCargaSeca     , tmCaminhaoTanque            ,
                               tmRemessaExpressaRodo, tmFreteAereo            , tmExpressoAereo             ,
                               tmEncomendaPostal    , tmCorreioExpresso       , tmCorreioAereo              ,
                               tmMensageiroExpresso , tmPeruas                , tmCaminhonete5Ton           ,
                               tmTocoAberto         , tmTocoFechado           , tmTruckAberto               ,
                               tmTruckFechado       , tmCarretaAberta         , tmCarretaFechada            ,
                               tmTruckRefrigerado   , tmCarretaRefrigerada    , tmTruckSider                ,
                               tmCarretaSider       , tmFurgao3_5Ton          , tmCaminhonete1Ton           ,
                               tmCarreta60Metros3   , tmCarreta80Metros3      , tmConainerBuggy             ,
                               tmContainer20Pes     , tmContainer40Pes        , tmContainer40PesHC          ,
                               tmContainer20PesRefri, tmContainer40PesRefri]);
end;

function StrToMeioTransporte(out ok: boolean; const s: string): tmTransporte;
begin
  result := StrToEnumerado(ok, s, ['12', '21', '23', '25', '31', '32', '34', '41',
                                   '43', '51', '52', '55', '101', 'BR01', 'BR02', 'BR03',
                                   'BR04', 'BR05', 'BR06', 'BR07', 'BR08', 'BR10', 'BR11',
                                   'BR12', 'BR13', 'BR50', 'BR51', 'BR60', 'BR80', 'CTB', 'C20',
                                   'C40', 'C4H', 'C2R', 'C4R'],
                              [tmNavioTanque        , tmVagaoFerroviarioTanque, tmVagaoFerroviarioGraneleiro,
                               tmExpressoFerroviario, tmCaminhaoCargaSeca     , tmCaminhaoTanque            ,
                               tmRemessaExpressaRodo, tmFreteAereo            , tmExpressoAereo             ,
                               tmEncomendaPostal    , tmCorreioExpresso       , tmCorreioAereo              ,
                               tmMensageiroExpresso , tmPeruas                , tmCaminhonete5Ton           ,
                               tmTocoAberto         , tmTocoFechado           , tmTruckAberto               ,
                               tmTruckFechado       , tmCarretaAberta         , tmCarretaFechada            ,
                               tmTruckRefrigerado   , tmCarretaRefrigerada    , tmTruckSider                ,
                               tmCarretaSider       , tmFurgao3_5Ton          , tmCaminhonete1Ton           ,
                               tmCarreta60Metros3   , tmCarreta80Metros3      , tmConainerBuggy             ,
                               tmContainer20Pes     , tmContainer40Pes        , tmContainer40PesHC          ,
                               tmContainer20PesRefri, tmContainer40PesRefri]);
end;

function TpDoctoToStr(const t: tpDocto ): string;
begin
  result := EnumeradoToStr(t, ['07', '08', '55', '57', '99', 'CD'],
                              [tpdNFSe, tpdCTRC, tpdNFe, tpdCTe, tpdOutros, tpdCarteoraDebito]);
end;

function StrToTpDocto(out ok: boolean; const s: string): tpDocto;
begin
  result := StrToEnumerado(ok, s, ['07', '08', '55', '57', '99', 'CD'],
                              [tpdNFSe, tpdCTRC, tpdNFe, tpdCTe, tpdOutros, tpdCarteoraDebito]);
end;

function CondicaoFreteToStr(const t: tCondicaoFrete ): string;
begin
  result := EnumeradoToStr(t, ['C', 'F'], [tcfCIF, tcfFOB]);
end;

function StrToCondicaoFrete(out ok: boolean; const s: string): tCondicaoFrete;
begin
  result := StrToEnumerado(ok, s, ['C', 'F'], [tcfCIF, tcfFOB]);
end;

function TipoFreteToStr(const t: tpFrete ): string;
begin
  result := EnumeradoToStr(t, ['1', '2', '3'], [tpfNormal, tpfExportacao, tpfImportacao]);
end;

function StrToTipoFrete(out ok: boolean; const s: string): tpFrete;
begin
  result := StrToEnumerado(ok, s, ['1', '2', '3'], [tpfNormal, tpfExportacao, tpfImportacao]);
end;

function TipoCobrancaToStr(const t: tpCobranca ): string;
begin
  result := EnumeradoToStr(t, ['BCO', 'CAR'], [tcBanco, tcCarteira]);
end;

function StrToTipoCobranca(out ok: boolean; const s: string): tpCobranca;
begin
  result := StrToEnumerado(ok, s, ['BCO', 'CAR'], [tcBanco, tcCarteira]);
end;

function DocCobrancaToStr(const t: tpDocCobranca ): string;
begin
  result := EnumeradoToStr(t, ['0', '1'], [tdcNotaFiscal, tdcRomaneio]);
end;

function StrToDocCobranca(out ok: boolean; const s: string): tpDocCobranca;
begin
  result := StrToEnumerado(ok, s, ['0', '1'], [tdcNotaFiscal, tdcRomaneio]);
end;


function TipoCTeToStr( const t: tpCTe ): string;
begin
  result := EnumeradoToStr(t, ['A', 'B', 'C', 'D', 'E', 'F', 'H', 'I', 'M', 'N',
                               'O', 'P', 'R', 'S', 'T', 'U', 'W', 'X', 'Y', 'Z'],
                              [tpcAjudantes, tpcTransbordoCarga, tpcComplementar,
                               tpcCTeDevolucao, tpcNormalDeEentrada, tpcFreteColeta,
                               tpcCobrancaStretchFilm, tpcEstadias, tpcDespesasManuseioCarga,
                               tpcNormal, tpcNormalDeRetorno, tpcTransportePallets,
                               tpcCTeDeReentrega, tpcNormalDeSaida, tpcNormalDeTtransferenciaInterna,
                               tpcCustoComunicao, tpcComplementarDeRetorno, tpcComplementarDeEntrada,
                               tpcComplementarDeSaida, tpcComplementarDeTransferenciaInterna]);
end;

function StrToTipoCTe(out ok: boolean; const s: string): tpCTe;
begin
  result := StrToEnumerado(ok, s, ['A', 'B', 'C', 'D', 'E', 'F', 'H', 'I', 'M', 'N',
                                   'O', 'P', 'R', 'S', 'T', 'U', 'W', 'X', 'Y', 'Z'],
                              [tpcAjudantes, tpcTransbordoCarga, tpcComplementar,
                               tpcCTeDevolucao, tpcNormalDeEentrada, tpcFreteColeta,
                               tpcCobrancaStretchFilm, tpcEstadias, tpcDespesasManuseioCarga,
                               tpcNormal, tpcNormalDeRetorno, tpcTransportePallets,
                               tpcCTeDeReentrega, tpcNormalDeSaida, tpcNormalDeTtransferenciaInterna,
                               tpcCustoComunicao, tpcComplementarDeRetorno, tpcComplementarDeEntrada,
                               tpcComplementarDeSaida, tpcComplementarDeTransferenciaInterna]);
end;

function StringToDouble( const xStr: String; Inteiro, Decimal: Integer ): Double ;
var
  i: integer ;
begin
  i := Length(Copy(xStr,1,Inteiro))+1 ;
  result := StrToFloat(Copy(xStr,1,Inteiro)+','+Copy(xStr,i,Decimal)) ;
end;

function StringToDate( xStr: String ): TDate ;
begin
  xStr := OnlyNumber(xStr) ;
  if xStr <> '' then
  begin
    if length(xStr) < 8 then
      xStr := Copy(xStr,1,2)+'/'+Copy(xStr,3,2)+'/'+Copy(xStr,5,2)
    else
      xStr := Copy(xStr,1,2)+'/'+Copy(xStr,3,2)+'/'+Copy(xStr,5,4) ;
  end
  else
    xStr := DateToStr(date) ;
  result := StrToDate(xStr) ;
end;

function StringToTime( xStr: String ): TTime ;
begin
  xStr := OnlyNumber(xStr) ;
  if xStr <> '' then
    xStr := Copy(xStr,1,2)+':'+Copy(xStr,3,2)
  else
    xStr := TimeToStr(Time) ;
  result := StrToTime(xStr) ;
end;

end.
