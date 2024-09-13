{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo: Antonio Carlos Junior                           }

{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }

{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }

{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }

{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrLibPIXCDBase;

interface

uses
  Classes, SysUtils, ACBrLibComum, ACBrLibPIXCDDataModule, ACBrUtil.FilesIO;

type
  { TACBrLibPIXCD }
  TACBrLibPIXCD = class (TACBrLib)
    private
      FPIXCDDM: TLibPIXCDDM;

    protected
      procedure CriarConfiguracao(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
      procedure Executar; Override;

    public
      constructor Create(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
      destructor Destroy; override;

      property PIXCDDM: TLibPIXCDDM read FPIXCDDM;

      function GerarQRCodeEstatico(AValor: Double; const AinfoAdicional: PAnsiChar; const ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function ConsultarPix(const Ae2eid: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function ConsultarPixRecebidos(ADataInicio: TDateTime; ADataFim: TDateTime; const ATxId: PAnsiChar; const ACpfCnpj: PAnsiChar; PagAtual: integer; ItensPorPagina: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function SolicitarDevolucaoPix(AInfDevolucao: PAnsiChar; const Ae2eid: PAnsiChar; AidDevolucao: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function ConsultarDevolucaoPix(const Ae2eid, AidDevolucao: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function CriarCobrancaImediata(AInfCobSolicitada: PAnsiChar; const ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function ConsultarCobrancaImediata(const ATxId: PAnsiChar; ARevisao: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function ConsultarCobrancasCob(ADataInicio: TDateTime; ADataFim: TDateTime; ACpfCnpj: PAnsiChar; ALocationPresente: Boolean; AStatus: integer; PagAtual: integer; ItensPorPagina: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function RevisarCobrancaImediata(AInfCobRevisada: PAnsiChar; const ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function CancelarCobrancaImediata(ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function CriarCobranca(AinfCobVSolicitada: PAnsiChar; ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function ConsultarCobranca(const ATxId: PAnsiChar; ARevisao: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function ConsultarCobrancasCobV(ADataInicio: TDateTime; ADataFim: TDateTime; ACpfCnpj: PAnsiChar; ALocationPresente: Boolean; AStatus: integer; PagAtual: integer; ItensPorPagina: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function RevisarCobranca(AInfCobVRevisada: PAnsiChar; const ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function CancelarCobranca(ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;

      //Matera
      function MateraIncluirConta(aInfIncluirConta: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function MateraConsultarConta(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function MateraInativarConta(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function MateraIncluirChavePix(aAccountId, aExternalID: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function MateraConsultarChavePix(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function MateraExcluirChavePix(aAccountId, aChavePIX: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function MateraGerarQRCode(aInfQRCode: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function MateraConsultarTransacao(aAccountId, aTransactionID: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function MateraConsultarSaldoEC(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function MateraConsultarExtratoEC(aAccountId: PAnsiChar; aInicio: TDateTime; aFim: TDateTime; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function MateraConsultarMotivosDevolucao(const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function MateraSolicitarDevolucao(aInfSolicitarDevolucao: PAnsiChar; aAccountId, aTransactionID: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function MateraConsultarAliasRetirada(aAccountId, aAlias: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
      function MateraSolicitarRetirada(aInfSolicitarRetirada: PAnsiChar; aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
  end;

implementation

Uses
  ACBrLibConsts, ACBrLibConfig, ACBrLibPIXCDConfig, ACBrPIXCD, ACBrPIXBase, ACBrLibPIXCDRespostas, ACBrLibPIXCDMateraRespostas, ACBrLibHelpers,
  ACBrUtil.Strings, ACBrUtil.Base, ACBrPIXSchemasCob, ACBrPIXSchemasCobV, ACBrSchemasMatera;

{ TACBrLibPIXCD }

constructor TACBrLibPIXCD.Create(ArqConfig: string; ChaveCrypt: ansistring);
begin
  inherited Create(ArqConfig, ChaveCrypt);

  FPIXCDDM := TLibPIXCDDM.Create(Nil);
  FPIXCDDM.Lib := Self;
end;

destructor TACBrLibPIXCD.Destroy;
begin
  FPIXCDDM.Free;

  inherited Destroy;
end;

procedure TACBrLibPIXCD.CriarConfiguracao(ArqConfig: string; ChaveCrypt: ansistring);
begin
  fpConfig := TLibPIXCDConfig.Create(Self, ArqConfig, ChaveCrypt);
end;

procedure TACBrLibPIXCD.Executar;
begin
  inherited Executar;
  FPIXCDDM.AplicarConfiguracoes;
end;

function TACBrLibPIXCD.GerarQRCodeEstatico(AValor: Double; const AinfoAdicional: PAnsiChar; const ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  Resposta: AnsiString;
  ValorCurrency: Currency;
begin
  try
    //Conversão realizada por conta de algumas linguagens não suportar Currency - C#.
    ValorCurrency:= AValor;

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_GerarQRCodeEstatico(' + CurrToStr(ValorCurrency) + ',' + AinfoAdicional + ',' + ATxId + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_GerarQRCodeEstatico', logNormal);

    PIXCDDM.Travar;
    try
      Resposta:= PIXCDDM.ACBrPixCD1.GerarQRCodeEstatico(ValorCurrency, AinfoAdicional, ATxId);

      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.ConsultarPix(const Ae2eid: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  e2id: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDConsultarPixResposta;
  RespProb: TLibPIXCDProblemaResposta;
  Ok: boolean;
begin
  try
    e2id:= ConverterStringEntrada(Ae2eid);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_ConsultarPIX(' + e2id + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_ConsultarPIX', logNormal);

    PIXCDDM.Travar;
    try
      Ok := PIXCDDM.ACBrPixCD1.PSP.epPix.ConsultarPix(e2id);

      if Ok then
      begin
        Resp := TLibPIXCDConsultarPixResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.Processar(PIXCDDM.ACBrPixCD1.PSP.epPix.Pix);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPixCD1.PSP.epPix.Problema);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.ConsultarPixRecebidos(ADataInicio: TDateTime; ADataFim: TDateTime; const ATxId: PAnsiChar; const ACpfCnpj: PAnsiChar; PagAtual: integer; ItensPorPagina: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  TxId, CpfCnpj: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDConsultarPixRecebidosResposta;
  RespProb: TLibPIXCDProblemaResposta;
  Ok: Boolean;
begin
  try
    TxId:= ConverterStringEntrada(ATxId);
    CpfCnpj:= ConverterStringEntrada(ACpfCnpj);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_ConsultarPixRecebidos(' + DateToStr(ADataInicio) + ',' + DateToStr(ADataFim) + ',' + TxId + ',' + CpfCnpj + ',' + IntToStr(PagAtual) + ',' + IntToStr(ItensPorPagina) + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_ConsultarPixRecebidos', logNormal);

    PIXCDDM.Travar;
    try
      Ok := PIXCDDM.ACBrPixCD1.PSP.epPix.ConsultarPixRecebidos(ADataInicio, ADataFim, TxId, CpfCnpj, PagAtual, ItensPorPagina);

      if Ok then
      begin
        Resp := TLibPIXCDConsultarPixRecebidosResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.Processar(PIXCDDM.ACBrPixCD1.PSP.epPix.PixConsultados);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb :=TLibPIXCDProblemaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPixCD1.PSP.epPix.Problema);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.SolicitarDevolucaoPix(AInfDevolucao: PAnsiChar; const Ae2eid: PAnsiChar; AidDevolucao: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  e2eid, idDevolucao: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDDevolucaoPixResposta;
  RespProb: TLibPIXCDProblemaResposta;
  Ok: Boolean;
begin
  try
    e2eid:= ConverterStringEntrada(Ae2eid);
    idDevolucao:= ConverterStringEntrada(AidDevolucao);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_SolicitarDevolucaoPix(' + AInfDevolucao + ',' + e2eid + ',' + idDevolucao + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_SolicitarDevolucaoPix', logNormal);

    if StringEhArquivo(AInfDevolucao) then
    VerificarArquivoExiste(AInfDevolucao);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPixCD1.PSP.epPix.DevolucaoSolicitada.LoadFromIni(AInfDevolucao);
      Ok:= PIXCDDM.ACBrPixCD1.PSP.epPix.SolicitarDevolucaoPix(e2eid, idDevolucao);

      if Ok then
      begin
        Resp := TLibPIXCDDevolucaoPixResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
           Resp.Processar(PIXCDDM.ACBrPixCD1.PSP.epPix.Devolucao);
           Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPixCD1.PSP.epPix.Problema);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.ConsultarDevolucaoPix(const Ae2eid, AidDevolucao: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  e2eid, idDevolucao: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDDevolucaoPixResposta;
  RespProb: TLibPIXCDProblemaResposta;
  Ok: Boolean;
begin
  try
    e2eid:= ConverterStringEntrada(Ae2eid);
    idDevolucao:= ConverterStringEntrada(AidDevolucao);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_ConsultarDevolucaoPix(' + e2eid + ',' + idDevolucao + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_ConsultarDevolucaoPix', logNormal);

    PIXCDDM.Travar;
    try
      Ok := PIXCDDM.ACBrPixCD1.PSP.epPix.ConsultarDevolucaoPix(e2eid, idDevolucao);

      if Ok then
      begin
        Resp := TLibPIXCDDevolucaoPixResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.Processar(PIXCDDM.ACBrPixCD1.PSP.epPix.Devolucao);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPixCD1.PSP.epPix.Problema);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.CriarCobrancaImediata(AInfCobSolicitada: PAnsiChar; const ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  Resposta: AnsiString;
  Resp: TLibPIXCDCobResposta;
  RespProb: TLibPIXCDProblemaResposta;
  TxId: String;
  Ok: Boolean;
begin
  try
    TxId:= ConverterStringEntrada(ATxId);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_CriarCobrancaImediata(' + AInfCobSolicitada + ',' + TxId + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_CriarCobrancaImediata', logNormal);

    if StringEhArquivo(AInfCobSolicitada) then
    VerificarArquivoExiste(AInfCobSolicitada);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPixCD1.PSP.epCob.CobSolicitada.LoadFromIni(AInfCobSolicitada);
      Ok := PIXCDDM.ACBrPixCD1.PSP.epCob.CriarCobrancaImediata(TxId);

      if Ok then
      begin
        Resp := TLibPIXCDCobResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.ProcessarCobGerada(PIXCDDM.ACBrPixCD1.PSP.epCob.CobGerada);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPixCD1.PSP.epCob.Problema);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.ConsultarCobrancaImediata(const ATxId: PAnsiChar; ARevisao: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  TxId: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDCobResposta;
  RespProb: TLibPIXCDProblemaResposta;
  ok: Boolean;
begin
  try
    TxId:= ConverterStringEntrada(ATxId);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_ConsultarCobrancaImediata(' + TxId + ',' + IntToStr(ARevisao) + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_ConsultarCobrancaImediata', logNormal);

    PIXCDDM.Travar;
    try
      Ok := PIXCDDM.ACBrPixCD1.PSP.epCob.ConsultarCobrancaImediata(TxId, ARevisao);

      if Ok then
      begin
        Resp := TLibPIXCDCobResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.ProcessarCobCompleta(PIXCDDM.ACBrPixCD1.PSP.epCob.CobCompleta);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPixCD1.PSP.epCob.Problema);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.ConsultarCobrancasCob(ADataInicio: TDateTime; ADataFim: TDateTime; ACpfCnpj: PAnsiChar; ALocationPresente: Boolean; AStatus: integer; PagAtual: integer; ItensPorPagina: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  CpfCnpj: String;
  Resposta: AnsiString;
  status: TACBrPIXStatusCobranca;
  Resp: TLibPIXCDCobsConsultadas;
  RespProb: TLibPIXCDProblemaResposta;
  Ok: Boolean;
begin
  try
    CpfCnpj := ConverterStringEntrada(ACpfCnpj);

    if not (TEnum.TryParse<TACBrPIXStatusCobranca>(AStatus, status)) then
       status := TACBrPIXStatusCobranca.stcNENHUM;

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_ConsultarCobrancasCob(' + DateToStr(ADataInicio) + ',' + DateToStr(ADataFim) + ',' + CpfCnpj + ',' + BoolToStr(ALocationPresente) + ',' + PIXStatusCobrancaToString(status) + ',' + IntToStr(PagAtual) + ',' + IntToStr(ItensPorPagina) + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_ConsultarCobrancasCob', logNormal);

    PIXCDDM.Travar;
    try
      Ok := PIXCDDM.ACBrPixCD1.PSP.epCob.ConsultarCobrancas(ADataInicio, ADataFim, CpfCnpj, ALocationPresente, status, PagAtual, ItensPorPagina);

      if Ok then
      begin
        Resp := TLibPIXCDCobsConsultadas.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.Processar(PIXCDDM.ACBrPixCD1.PSP.epCob.CobsConsultadas);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPixCD1.PSP.epCob.Problema);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.RevisarCobrancaImediata(AInfCobRevisada: PAnsiChar; const ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer):integer;
var
  TxId: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDCobResposta;
  RespProb: TLibPIXCDProblemaResposta;
  Ok: Boolean;
begin
  try
    TxId:= ConverterStringEntrada(ATxId);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_RevisarCobrancaImediata(' + AInfCobRevisada + ',' + TxId + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_RevisarCobrancaImediata', logNormal);

    if StringEhArquivo(AInfCobRevisada) then
    VerificarArquivoExiste(AInfCobRevisada);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPixCD1.PSP.epCob.CobRevisada.LoadFromIni(AInfCobRevisada);
      Ok := PIXCDDM.ACBrPixCD1.PSP.epCob.RevisarCobrancaImediata(TxId);

      if Ok then
      begin
        Resp := TLibPIXCDCobResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.ProcessarCobGerada(PIXCDDM.ACBrPixCD1.PSP.epCob.CobGerada);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPixCD1.PSP.epCob.Problema);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.CancelarCobrancaImediata(ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  TxId: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDCobResposta;
  RespProb: TLibPIXCDProblemaResposta;
  Ok: boolean;
begin
  try
    TxId := ConverterStringEntrada(ATxId);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_CancelarCobrancaImediata(' + TxId + ' )', logCompleto, True)
       else
       GravarLog('PIXCD_CancelarCobrancaImediata', logNormal);

    PIXCDDM.Travar;
    try
      with PIXCDDM.ACBrPixCD1 do
      begin
        PSP.epCob.CobRevisada.Clear;
        PSP.epCob.CobRevisada.status:= stcREMOVIDA_PELO_USUARIO_RECEBEDOR;
      end;

      Ok := PIXCDDM.ACBrPixCD1.PSP.epCob.RevisarCobrancaImediata(TxId);

      if Ok then
      begin
        Resp := TLibPIXCDCobResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.ProcessarCobGerada(PIXCDDM.ACBrPixCD1.PSP.epCob.CobGerada);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPixCD1.PSP.epCob.Problema);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.CriarCobranca(AinfCobVSolicitada: PAnsiChar; ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  Resposta: AnsiString;
  Resp: TLibPIXCDCobVResposta;
  RespProb: TLibPIXCDProblemaResposta;
  TxId: String;
  Ok: Boolean;
begin
  try
    TxId:= ConverterStringEntrada(ATxId);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_CriarCobranca(' + AinfCobVSolicitada + ',' + TxId + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_CriarCobranca', logNormal);

    if StringEhArquivo(AinfCobVSolicitada) then
    VerificarArquivoExiste(AinfCobVSolicitada);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPixCD1.PSP.epCobV.CobVSolicitada.LoadFromIni(AInfCobVSolicitada);
      Ok := PIXCDDM.ACBrPixCD1.PSP.epCobV.CriarCobranca(TxId);

      if Ok then
      begin
        Resp := TLibPIXCDCobVResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.ProcessarCobVGerada(PIXCDDM.ACBrPixCD1.PSP.epCobV.CobVGerada);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPixCD1.PSP.epCobV.Problema);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.ConsultarCobranca(const ATxId: PAnsiChar; ARevisao: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  TxId: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDCobVResposta;
  RespProb: TLibPIXCDProblemaResposta;
  Ok: Boolean;
begin
  try
    TxId:= ConverterStringEntrada(ATxId);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_ConsultarCobranca(' + TxId + ',' + IntToStr(ARevisao) + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_ConsultarCobranca', logNormal);

    PIXCDDM.Travar;
    try
      Ok := PIXCDDM.ACBrPixCD1.PSP.epCobV.ConsultarCobranca(TxId, ARevisao);

      if Ok then
      begin
        Resp := TLibPIXCDCobVResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.ProcessarCobVCompleta(PIXCDDM.ACBrPixCD1.PSP.epCobV.CobVCompleta);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPixCD1.PSP.epCobV.Problema);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.ConsultarCobrancasCobV(ADataInicio: TDateTime; ADataFim: TDateTime; ACpfCnpj: PAnsiChar; ALocationPresente: Boolean; AStatus: integer; PagAtual: integer; ItensPorPagina: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  CpfCnpj: String;
  Resposta: AnsiString;
  status: TACBrPIXStatusCobranca;
  Resp: TLibPIXCDCobsVConsultadas;
  RespProb: TLibPIXCDProblemaResposta;
  Ok: Boolean;
begin
  try
    CpfCnpj := ConverterStringEntrada(ACpfCnpj);

    if not (TEnum.TryParse<TACBrPIXStatusCobranca>(AStatus, status)) then
       status := TACBrPIXStatusCobranca.stcNENHUM;

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_ConsultarCobrancasCobV(' + DateToStr(ADataInicio) + ',' + DateToStr(ADataFim) + ',' + CpfCnpj + ',' + BoolToStr(ALocationPresente) + ',' + PIXStatusCobrancaToString(status) + ',' + IntToStr(PagAtual) + ',' + IntToStr(ItensPorPagina) + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_ConsultarCobrancasCobV', logNormal);

    PIXCDDM.Travar;
    try
      Ok := PIXCDDM.ACBrPixCD1.PSP.epCobV.ConsultarCobrancas(ADataInicio, ADataFim, CpfCnpj, ALocationPresente, status, PagAtual, ItensPorPagina);

      if Ok then
      begin
        Resp := TLibPIXCDCobsVConsultadas.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.Processar(PIXCDDM.ACBrPixCD1.PSP.epCobV.CobsVConsultadas);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPixCD1.PSP.epCobV.Problema);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.RevisarCobranca(AInfCobVRevisada: PAnsiChar; const ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  TxId: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDCobVResposta;
  RespProb: TLibPIXCDProblemaResposta;
  Ok: Boolean;
begin
  try
    TxId:= ConverterStringEntrada(ATxId);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_RevisarCobranca(' + AInfCobVRevisada + ',' + TxId + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_RevisarCobranca', logNormal);

    if StringEhArquivo(AInfCobVRevisada) then
    VerificarArquivoExiste(AInfCobVRevisada);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPixCD1.PSP.epCobV.CobVRevisada.LoadFromIni(AInfCobVRevisada);
      Ok := PIXCDDM.ACBrPixCD1.PSP.epCobV.RevisarCobranca(TxId);

      If Ok Then
      begin
        Resp := TLibPIXCDCobVResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.ProcessarCobVGerada(PIXCDDM.ACBrPixCD1.PSP.epCobV.CobVGerada);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPixCD1.PSP.epCobV.Problema);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.CancelarCobranca(ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  TxId: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDCobVResposta;
  RespProb: TLibPIXCDProblemaResposta;
  Ok: boolean;
begin
  try
    TxId := ConverterStringEntrada(ATxId);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_CancelarCobranca(' + TxId + ' )', logCompleto, True)
       else
       GravarLog('PIXCD_CancelarCobranca', logNormal);

    PIXCDDM.Travar;
    try
      with PIXCDDM.ACBrPixCD1 do
      begin
        PSP.epCobV.CobVRevisada.Clear;
        PSP.epCobV.CobVRevisada.status:= stcREMOVIDA_PELO_USUARIO_RECEBEDOR;
      end;

      Ok := PIXCDDM.ACBrPixCD1.PSP.epCobV.RevisarCobranca(TxId);

      If Ok Then
      begin
        Resp := TLibPIXCDCobVResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.ProcessarCobVGerada(PIXCDDM.ACBrPixCD1.PSP.epCobV.CobVGerada);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPixCD1.PSP.epCobV.Problema);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.MateraIncluirConta(aInfIncluirConta: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  Resposta: AnsiString;
  Resp: TLibPIXCDIncluirContaResposta;
  RespProb: TLibPIXCDProblemaRespostaMatera;
  Ok: Boolean;
begin
  try
    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_Matera_IncluirConta(' + aInfIncluirConta + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_Matera_IncluirConta', logNormal);

    if StringEhArquivo(aInfIncluirConta) then
    VerificarArquivoExiste(aInfIncluirConta);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPSPMatera1.ContaSolicitacao.LoadFromIni(aInfIncluirConta);
      Ok := PIXCDDM.ACBrPSPMatera1.ContaIncluir;

      if Ok then
      begin
        Resp := TLibPIXCDIncluirContaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
           Resp.Processar(PIXCDDM.ACBrPSPMatera1.ContaResposta);
           Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaRespostaMatera.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPSPMatera1.ErroResposta);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.MateraConsultarConta(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  accountid: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDConsultarContaReposta;
begin
  try
    accountid := ConverterStringEntrada(aAccountId);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_Matera_ConsultarConta(' + accountid + ' )', logCompleto, True)
       else
       GravarLog('PIXCD_Matera_ConsultarConta', logNormal);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPSPMatera1.ContaConsultar(accountid);
      Resp := TLibPIXCDConsultarContaReposta.Create(Config.TipoResposta, Config.CodResposta);
      try
        Resp.Processar(PIXCDDM.ACBrPSPMatera1.ContaResposta);
        Resposta := Resp.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        Resp.Free;
      end;
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.MateraInativarConta(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  accountid: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDInativarContaReposta;
  RespProb: TLibPIXCDProblemaRespostaMatera;
  Ok: Boolean;
begin
  try
    accountid := ConverterStringEntrada(aAccountId);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_Matera_InativarConta(' + accountid + ' )', logCompleto, True)
       else
       GravarLog('PIXCD_Matera_InativarConta', logNormal);

    PIXCDDM.Travar;
    try
      Ok := PIXCDDM.ACBrPSPMatera1.ContaInativar(accountid);

      if Ok then
      begin
        Resp := TLibPIXCDInativarContaReposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.Processar(PIXCDDM.ACBrPSPMatera1);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaRespostaMatera.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPSPMatera1.ErroResposta);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.MateraIncluirChavePix(aAccountId, aExternalID: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  accountid, externalid: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDChavePIXResposta;
  RespProb: TLibPIXCDProblemaRespostaMatera;
  Ok: Boolean;
begin
  try
    accountid := ConverterStringEntrada(aAccountId);
    externalid := ConverterStringEntrada(aExternalID);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_Matera_IncluirChavePix(' + accountid + ',' + externalid +' )', logCompleto, True)
       else
       GravarLog('PIXCD_Matera_IncluirChavePix', logNormal);

    PIXCDDM.Travar;
    try

      with PIXCDDM.ACBrPSPMatera1 do
      begin
        ChavePIXSolicitacao.externalIdentifier := externalid;
        ChavePIXSolicitacao.alias_.type_ := malEVP
      end;

      Ok := PIXCDDM.ACBrPSPMatera1.ChavePIXIncluir(accountid);

      if Ok then
      begin
        Resp := TLibPIXCDChavePIXResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.Processar(PIXCDDM.ACBrPSPMatera1.ChavePIXResposta);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaRespostaMatera.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPSPMatera1.ErroResposta);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.MateraConsultarChavePix(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  accountid: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDChavePIXResposta;
begin
  try
    accountid := ConverterStringEntrada(aAccountId);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_Matera_ConsultarChavePix(' + accountid + ' )', logCompleto, True)
       else
       GravarLog('PIXCD_Matera_ConsultarChavePix', logNormal);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPSPMatera1.ChavesPIXConsultar(accountid);
      Resp := TLibPIXCDChavePIXResposta.Create(Config.TipoResposta, Config.CodResposta);
      try
        Resp.Processar(PIXCDDM.ACBrPSPMatera1.ChavesPIXResposta);
        Resposta := Resp.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        Resp.Free
      end;
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.MateraExcluirChavePix(aAccountId, aChavePIX: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  accountid, chavepix: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDExcluirChavePIXResposta;
  RespProb: TLibPIXCDProblemaRespostaMatera;
  Ok: Boolean;
begin
  try
    accountid := ConverterStringEntrada(aAccountId);
    chavepix := ConverterStringEntrada(aChavePIX);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_Matera_ExcluirChavePix(' + accountid + ',' + chavepix + ' )', logCompleto, True)
       else
       GravarLog('PIXCD_Matera_ExcluirChavePix', logNormal);

    PIXCDDM.Travar;
    try
      Ok := PIXCDDM.ACBrPSPMatera1.ChavePIXExcluir(accountid, chavepix);

      if Ok then
      begin
        Resp := TLibPIXCDExcluirChavePIXResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.Processar(PIXCDDM.ACBrPSPMatera1);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaRespostaMatera.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPSPMatera1.ErroResposta);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.MateraGerarQRCode(aInfQRCode: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  Resposta: AnsiString;
  Resp: TLibPIXCDQRCodeResposta;
  RespProb: TLibPIXCDProblemaRespostaMatera;
  Ok: Boolean;
begin
  try
    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_Matera_GerarQRCode(' + aInfQRCode + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_Matera_GerarQRCode', logNormal);

    if StringEhArquivo(aInfQRCode) then
    VerificarArquivoExiste(aInfQRCode);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPSPMatera1.QRCodeSolicitacao.LoadFromIni(aInfQRCode);
      Ok := PIXCDDM.ACBrPSPMatera1.GerarQRCode;

      if Ok then
      begin
        Resp := TLibPIXCDQRCodeResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.Processar(PIXCDDM.ACBrPSPMatera1.QRCodeResposta);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaRespostaMatera.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPSPMatera1.ErroResposta);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.MateraConsultarTransacao(aAccountId, aTransactionID: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  accountid, transactionID: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDConsultarTransacaoResposta;
begin
  try
    accountid := ConverterStringEntrada(aAccountId);
    transactionID := ConverterStringEntrada(aTransactionID);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_Matera_ConsultarTransacao(' + accountid + ',' + transactionID + ' )', logCompleto, True)
       else
       GravarLog('PIXCD_Matera_ConsultarTransacao', logNormal);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPSPMatera1.ConsultarTransacao(accountid, transactionID);
      Resp := TLibPIXCDConsultarTransacaoResposta.Create(Config.TipoResposta, Config.CodResposta);
      try
        Resp.Processar(PIXCDDM.ACBrPSPMatera1.TransacoesResposta);
        Resposta := Resp.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        Resp.Free;
      end;
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.MateraConsultarSaldoEC(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  accountid: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDSaldoECResposta;
begin
  try
    accountid := ConverterStringEntrada(aAccountId);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_Matera_ConsultarSaldoEC(' + accountid + ' )', logCompleto, True)
       else
       GravarLog('PIXCD_Matera_ConsultarSaldoEC', logNormal);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPSPMatera1.ConsultarSaldoEC(accountid);
      Resp := TLibPIXCDSaldoECResposta.Create(Config.TipoResposta, Config.CodResposta);
      try
        Resp.Processar(PIXCDDM.ACBrPSPMatera1.SaldoECResposta);
        Resposta := Resp.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      except
        Resp.Free;
      end;
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.MateraConsultarExtratoEC(aAccountId: PAnsiChar; aInicio: TDateTime; aFim: TDateTime; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  accountid: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDExtratoECResposta;
begin
  try
    accountid := ConverterStringEntrada(aAccountId);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_Matera_ConsultarExtratoEC(' + accountid + ',' + DateToStr(aInicio) + ',' + DateToStr(aFim) + ' )', logCompleto, True)
       else
       GravarLog('PIXCD_Matera_ConsultarExtratoEC', logNormal);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPSPMatera1.ConsultarExtratoEC(accountid, aInicio, aFim);
      Resp := TLibPIXCDExtratoECResposta.Create(Config.TipoResposta, Config.CodResposta);
      try
        Resp.Processar(PIXCDDM.ACBrPSPMatera1.ExtratoECResposta);
        Resposta := Resp.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      except
        Resp.Free;
      end;
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.MateraConsultarMotivosDevolucao(const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  Resposta: AnsiString;
  Resp: TLibPIXCDMotivosDevolucaoResposta;
begin
  try
    GravarLog('PIXCD_Matera_ConsultarMotivosDevolucao', logCompleto);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPSPMatera1.DevolucaoConsultarMotivos;
      Resp := TLibPIXCDMotivosDevolucaoResposta.Create(Config.TipoResposta, Config.CodResposta);
      try
        Resp.Processar(PIXCDDM.ACBrPSPMatera1.DevolucaoMotivos.returnCodes);
        Resposta := Resp.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      except
        Resp.Free;
      end;
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.MateraSolicitarDevolucao(aInfSolicitarDevolucao: PAnsiChar; aAccountId, aTransactionID: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  accountid, transactionid: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDSolicitarDevolucaoResposta;
  RespProb: TLibPIXCDProblemaRespostaMatera;
  Ok: Boolean;
begin
  try
    accountid := ConverterStringEntrada(aAccountId);
    transactionid := ConverterStringEntrada(aTransactionID);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_Matera_SolicitarDevolucao(' + aInfSolicitarDevolucao + ',' + accountid + ',' + transactionid + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_Matera_SolicitarDevolucao', logNormal);

    if StringEhArquivo(aInfSolicitarDevolucao) then
    VerificarArquivoExiste(aInfSolicitarDevolucao);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPSPMatera1.DevolucaoSolicitacao.LoadFromIni(aInfSolicitarDevolucao);
      Ok := PIXCDDM.ACBrPSPMatera1.DevolucaoSolicitar(accountid, transactionid);

      if Ok then
      begin
        Resp := TLibPIXCDSolicitarDevolucaoResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.Processar(PIXCDDM.ACBrPSPMatera1.DevolucaoResposta);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaRespostaMatera.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPSPMatera1.ErroResposta);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.MateraConsultarAliasRetirada(aAccountId, aAlias: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  accountid, alias: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDAliasRetiradaResposta;
begin
  try
    accountid := ConverterStringEntrada(aAccountId);
    alias := ConverterStringEntrada(aAlias);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_Matera_ConsultarAliasRetirada(' + accountid + ',' + alias + ' )', logCompleto, True)
       else
       GravarLog('PIXCD_Matera_ConsultarAliasRetirada', logNormal);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPSPMatera1.ConsultarAliasRetirada(accountid, alias);
      Resp := TLibPIXCDAliasRetiradaResposta.Create(Config.TipoResposta, Config.CodResposta);
      try
        Resp.Processar(PIXCDDM.ACBrPSPMatera1.AliasRetiradaResposta);
        Resposta := Resp.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        Resp.Free;
      end;
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibPIXCD.MateraSolicitarRetirada(aInfSolicitarRetirada: PAnsiChar; aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
var
  accountid: String;
  Resposta: AnsiString;
  Resp: TLibPIXCDSolicitarRetiradaResposta;
  RespProb: TLibPIXCDProblemaRespostaMatera;
  Ok: Boolean;
begin
  try
    accountid := ConverterStringEntrada(aAccountId);

    if Config.Log.Nivel > logNormal then
       GravarLog('PIXCD_Matera_SolicitarRetirada(' + aInfSolicitarRetirada + ',' + accountid + ' )', logCompleto, True)
    else
       GravarLog('PIXCD_Matera_SolicitarRetirada', logNormal);

    if StringEhArquivo(aInfSolicitarRetirada) then
    VerificarArquivoExiste(aInfSolicitarRetirada);

    PIXCDDM.Travar;
    try
      PIXCDDM.ACBrPSPMatera1.RetiradaSolicitacao.LoadFromIni(aInfSolicitarRetirada);
      Ok := PIXCDDM.ACBrPSPMatera1.RetiradaSolicitar(accountid);

      if Ok then
      begin
        Resp := TLibPIXCDSolicitarRetiradaResposta.Create(Config.TipoResposta, Config.CodResposta);
        try
          Resp.Processar(PIXCDDM.ACBrPSPMatera1.RetiradaResposta);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;
      end else
      begin
        RespProb := TLibPIXCDProblemaRespostaMatera.Create(Config.TipoResposta, Config.CodResposta);
        try
          RespProb.Processar(PIXCDDM.ACBrPSPMatera1.ErroResposta);
          Resposta := RespProb.Gerar;
        finally
          RespProb.Free;
        end;
      end;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result:= SetRetorno(ErrOK, Resposta);
    finally
      PIXCDDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

end.

