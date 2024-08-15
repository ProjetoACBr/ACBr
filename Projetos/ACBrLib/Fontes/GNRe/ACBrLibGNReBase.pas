﻿{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Teno Dias                                }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrLibGNReBase;

interface

uses
  Classes, SysUtils, Forms, StrUtils,
  ACBrLibComum, ACBrLibGNReDataModule;

type

  { TACBrLibGNRe }

  TACBrLibGNRe = class(TACBrLib)
  private
    FGNReDM: TLibGNReDM;

    function SetRetornoGNReCarregados(const NumGNRe: Integer): Integer;

  protected
    procedure CriarConfiguracao(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
    procedure Executar; override;

  public
    constructor Create(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
    destructor Destroy; override;

    property GNReDM: TLibGNReDM read FGNReDM;

    function LimparLista: Integer;
    function CarregarXML(const eArquivoOuXML: PAnsiChar): Integer;
    function CarregarINI(const eArquivoOuINI: PAnsiChar): Integer;
    function ObterXml(AIndex: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
    function GravarXml(AIndex: Integer; const eNomeArquivo, ePathArquivo: PAnsiChar): Integer;
    function LimparListaGuiaRetorno: Integer;
    function CarregarGuiaRetorno(const eArquivoOuXml: PAnsiChar): Integer;
    function Assinar: Integer;
    function Validar: Integer;
    function VerificarAssinatura(const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
    function ObterCertificados(const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
    function Enviar(const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
    function Consultar(const eUF: PAnsiChar; const AReceita: Integer;
                       const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
    function EnviarEmail(const ePara, eArquivoOuXml: PAnsiChar; const AEnviaPDF: Boolean;
                         const eAssunto, eCC, eAnexos, eMensagem: PAnsiChar): Integer;
    function Imprimir(const eNomeImpressora, eMostrarPreview: PAnsiChar): Integer;
    function ImprimirPDF: Integer;

  end;

implementation

uses
  ACBrLibConsts, ACBrLibGNReConsts, ACBrLibConfig, ACBrLibResposta,
  ACBrLibGNReConfig, ACBrLibGNReRespostas, ACBrGNRE2, ACBrMail,
  ACBrUtil.Base, ACBrUtil.FilesIO, ACBrUtil.Strings,
  pcnConversao, pcnAuxiliar, blcksock, ACBrLibCertUtils;

{ TACBrLibGNRe }

constructor TACBrLibGNRe.Create(ArqConfig: string; ChaveCrypt: ansistring);
begin
  inherited Create(ArqConfig, ChaveCrypt);

  FGNReDM := TLibGNReDM.Create(nil);
  FGNReDM.Lib := Self;
end;

destructor TACBrLibGNRe.Destroy;
begin
  FGNReDM.Free;

  inherited Destroy;
end;

procedure TACBrLibGNRe.CriarConfiguracao(ArqConfig: string; ChaveCrypt: ansistring);
begin
  fpConfig := TLibGNReConfig.Create(Self, ArqConfig, ChaveCrypt);
end;

procedure TACBrLibGNRe.Executar;
begin
  inherited Executar;
  FGNReDM.AplicarConfiguracoes;
end;

function TACBrLibGNRe.LimparLista: Integer;
begin
  try
    GravarLog('GNRE_LimparLista', logNormal);

    GNReDM.Travar;
    try
      GNReDM.ACBrGNRe1.Guias.Clear;
      Result := SetRetornoGNReCarregados(GNReDM.ACBrGNRe1.Guias.Count);
    finally
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.CarregarXML(const eArquivoOuXML: PAnsiChar): Integer;
var
  EhArquivo: boolean;
  ArquivoOuXml: Ansistring;
begin
  try
    
    ArquivoOuXml := ConverterStringEntrada(eArquivoOuXML);

    if Config.Log.Nivel > logNormal then
      GravarLog('GNRE_CarregarXML(' + ArquivoOuXml + ' )', logCompleto, True)
    else
      GravarLog('GNRE_CarregarXML', logNormal);

    EhArquivo := StringEhArquivo(ArquivoOuXml);
    if EhArquivo then
      VerificarArquivoExiste(ArquivoOuXml);

    GNReDM.Travar;
    try
      if EhArquivo then
        GNReDM.ACBrGNRe1.Guias.LoadFromFile(ArquivoOuXml)
      else
        GNReDM.ACBrGNRe1.Guias.LoadFromString(ArquivoOuXml);

      Result := SetRetornoGNReCarregados(GNReDM.ACBrGNRe1.Guias.Count);
    finally
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.CarregarINI(const eArquivoOuINI: PAnsiChar): Integer;
var
  ArquivoOuINI: Ansistring;
begin
  try
    ArquivoOuINI := ConverterStringEntrada(eArquivoOuINI);

    if Config.Log.Nivel > logNormal then
      GravarLog('GNRE_CarregarINI(' + ArquivoOuINI + ' )', logCompleto, True)
    else
      GravarLog('GNRE_CarregarINI', logNormal);

    if StringEhArquivo(ArquivoOuINI) then
      VerificarArquivoExiste(ArquivoOuINI);

    GNReDM.Travar;
    try
      GNReDM.ACBrGNRe1.Guias.LoadFromIni(ArquivoOuINI);
      Result := SetRetornoGNReCarregados(GNReDM.ACBrGNRe1.Guias.Count);
    finally
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.ObterXml(AIndex: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
Var
  Resposta: Ansistring;
begin
  try
    if Config.Log.Nivel > logNormal then
      GravarLog('GNRE_ObterXml(' + IntToStr(AIndex) + ' )', logCompleto, True)
    else
      GravarLog('GNRE_ObterXml', logNormal);

    GNReDM.Travar;
    try
      if (GNReDM.ACBrGNRe1.Guias.Count < 1) or (AIndex < 0) or (AIndex >= GNReDM.ACBrGNRe1.Guias.Count) then
        raise EACBrLibException.Create(ErrIndex, Format(SErrIndex, [AIndex]));

      if EstaVazio(GNReDM.ACBrGNRe1.Guias.Items[AIndex].XMLOriginal) then
        GNReDM.ACBrGNRe1.Guias.Items[AIndex].GerarXML;

      Resposta := GNReDM.ACBrGNRe1.Guias.Items[AIndex].XMLOriginal;
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.GravarXml(AIndex: Integer; const eNomeArquivo, ePathArquivo: PAnsiChar): Integer;
Var
  ANomeArquivo, APathArquivo: Ansistring;
begin
  try
    ANomeArquivo := ConverterStringEntrada(eNomeArquivo);
    APathArquivo := ConverterStringEntrada(ePathArquivo);

    if Config.Log.Nivel > logNormal then
      GravarLog('GNRE_GravarXml(' + IntToStr(AIndex) + ',' + ANomeArquivo + ',' + APathArquivo + ' )', logCompleto, True)
    else
      GravarLog('GNRE_GravarXml', logNormal);

    GNReDM.Travar;
    try
      if (GNReDM.ACBrGNRe1.Guias.Count < 1) or (AIndex < 0) or (AIndex >= GNReDM.ACBrGNRe1.Guias.Count) then
        raise EACBrLibException.Create(ErrIndex, Format(SErrIndex, [AIndex]));

      if GNReDM.ACBrGNRe1.Guias.Items[AIndex].GravarXML(ANomeArquivo, APathArquivo) then
        Result := SetRetorno(ErrOK)
      else
        Result := SetRetorno(ErrGerarXml);
    finally
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.LimparListaGuiaRetorno: Integer;
begin
  try
    GravarLog('GNRE_LimparListaGuiaRetorno', logNormal);

    GNReDM.Travar;
    try
      GNReDM.ACBrGNRe1.GuiasRetorno.Clear;
      Result := SetRetornoGNReCarregados(GNReDM.ACBrGNRe1.GuiasRetorno.Count);
    finally
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.CarregarGuiaRetorno(const eArquivoOuXml: PAnsiChar): Integer;
var
  EhArquivo: boolean;
  ArquivoOuXml: Ansistring;
begin
  try
    ArquivoOuXml := ConverterStringEntrada(eArquivoOuXml);

    if Config.Log.Nivel > logNormal then
      GravarLog('GNRE_CarregarGuiaRetorno(' + ArquivoOuXml + ' )', logCompleto, True)
    else
      GravarLog('GNRE_CarregarGuiaRetorno', logNormal);

    EhArquivo := StringEhArquivo(ArquivoOuXml);
    if EhArquivo then
      VerificarArquivoExiste(ArquivoOuXml);

    GNReDM.Travar;
    try
      if EhArquivo then
        GNReDM.ACBrGNRe1.GuiasRetorno.LoadFromFile(ArquivoOuXml)
      else
        GNReDM.ACBrGNRe1.GuiasRetorno.LoadFromString(ArquivoOuXml);
      Result := SetRetornoGNReCarregados(GNReDM.ACBrGNRe1.GuiasRetorno.Count);
    finally
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.Assinar: Integer;
begin
  try
    GravarLog('GNRE_Assinar', logNormal);

    GNReDM.Travar;
    try
      try
        GNReDM.ACBrGNRe1.Guias.Assinar;
      except
        on E: EACBrGNReException do
          Result := SetRetorno(ErrAssinarGNRe, ConverterStringSaida(E.Message));
      end;
      Result := SetRetornoGNReCarregados(GNReDM.ACBrGNRe1.Guias.Count);
    finally
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.Validar: Integer;
begin
  try
    GravarLog('GNRE_Validar', logNormal);

    GNReDM.Travar;
    try
      try
        GNReDM.ACBrGNRe1.Guias.Validar;
        Result := SetRetornoGNReCarregados(GNReDM.ACBrGNRe1.Guias.Count);
      except
        on E: EACBrGNReException do
          Result := SetRetorno(ErrValidacaoGNRe, ConverterStringSaida(E.Message));
      end;
    finally
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.VerificarAssinatura(const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
Var
  Erros: string;
begin
  try
    GravarLog('GNRE_VerificarAssinatura', logNormal);

    GNReDM.Travar;
    try
      Erros := '';
      GNReDM.ACBrGNRe1.Guias.VerificarAssinatura(Erros);
      Erros := IfThen(Config.CodResposta = codAnsi, ACBrUTF8ToAnsi(Erros), Erros);
      MoverStringParaPChar(Erros, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Erros);
    finally
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.ObterCertificados(const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
Var
  Resposta: string;
begin
  try
    GravarLog('GNRE_ObterCertificados', logNormal);

    GNReDM.Travar;

    try
      Resposta := '';
      Resposta := ObterCerticados(GNReDM.ACBrGNRe1.SSL);
      Resposta := IfThen(Config.CodResposta = codAnsi, ACBrUTF8ToAnsi(Resposta), Resposta);
      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

{%endregion}

{%region Servicos}
function TACBrLibGNRe.Enviar(const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
var
  Resp: TLibGNReEnvio;
  Resposta: String;
begin
  try
    GravarLog('GNRE_Enviar', logNormal);

    GNReDM.Travar;
    try
      with GNReDM.ACBrGNRe1 do
      begin
        if Guias.Count = 0 then
          raise EACBrLibException.Create(ErrEnvio, Format(SInfGNReCarregados, [Guias.Count]));

        Resp := TLibGNReEnvio.Create(Config.TipoResposta, Config.CodResposta);

        WebServices.Enviar.Executar;
        Resposta := ''; //RespostaEnvio;

        WebServices.Retorno.numeroRecibo := WebServices.Enviar.numero;
        WebServices.Retorno.Executar;

        Resp.Processar(GNReDM.ACBrGNRe1);

        Resposta := Resp.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      end;
    finally
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));
    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.Consultar(const eUF: PAnsiChar; const AReceita: Integer;
  const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
var
  Resp: TLibGNReConsulta;
  AUF, Resposta: Ansistring;
begin
  try
    AUF := ConverterStringEntrada(eUF);

    if Config.Log.Nivel > logNormal then
      GravarLog('GNRE_Consultar(' + AUF + ',' + IntToStr(AReceita) +' )', logCompleto, True)
    else
      GravarLog('GNRE_Consultar', logNormal);

    GNReDM.Travar;

    try
      with GNReDM.ACBrGNRe1 do
      begin
        WebServices.ConsultaUF.Uf := AUF;
        WebServices.ConsultaUF.receita := AReceita;
        WebServices.ConsultaUF.Executar;

        Resp := TLibGNReConsulta.Create(Config.TipoResposta, Config.CodResposta);
        Resp.Processar(GNReDM.ACBrGNRe1);
        Resposta := Resp.Gerar;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      end;
    finally
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.EnviarEmail(const ePara, eArquivoOuXml: PAnsiChar; const AEnviaPDF: Boolean;
  const eAssunto, eCC, eAnexos, eMensagem: PAnsiChar): Integer;
var
  APara, ArquivoOuXml, AAssunto, ACC, AAnexos, AMensagem: Ansistring;
  slMensagemEmail, slCC, slAnexos: TStringList;
  EhArquivo: boolean;
begin
  try
    APara := ConverterStringEntrada(ePara);
    ArquivoOuXml := ConverterStringEntrada(eArquivoOuXml);
    AAssunto := ConverterStringEntrada(eAssunto);
    ACC := ConverterStringEntrada(eCC);
    AAnexos := ConverterStringEntrada(eAnexos);
    AMensagem := ConverterStringEntrada(eMensagem);

    if Config.Log.Nivel > logNormal then
      GravarLog('GNRE_EnviarEmail(' + APara + ',' + ArquivoOuXml + ',' +
         BoolToStr(AEnviaPDF, 'PDF','') + ',' + AAssunto + ',' + ACC + ',' +
         AAnexos + ',' + AMensagem + ' )', logCompleto, True)
    else
      GravarLog('GNRE_EnviarEmail', logNormal);

    GNReDM.Travar;

    try
      with GNReDM.ACBrGNRe1 do
      begin
        EhArquivo := StringEhArquivo(ArquivoOuXml);

        if EhArquivo then
          VerificarArquivoExiste(ArquivoOuXml);

        if EhArquivo then
          Guias.LoadFromFile(ArquivoOuXml)
        else
        Guias.LoadFromString(ArquivoOuXml);

        if Guias.Count = 0 then
          raise EACBrLibException.Create(ErrEnvio, Format(SInfGNReCarregados, [Guias.Count]))
        else
        begin
          slMensagemEmail := TStringList.Create;
          slCC := TStringList.Create;
          slAnexos := TStringList.Create;
          try
            with mail do
            begin
              slMensagemEmail.DelimitedText:= sLineBreak;
              slMensagemEmail.Text := StringReplace(AMensagem, ';', sLineBreak, [rfReplaceAll]);

              slCC.DelimitedText:= sLineBreak;
              slCC.Text := StringReplace(ACC, ';', sLineBreak, [rfReplaceAll]);

              slAnexos.DelimitedText := sLineBreak;
              slAnexos.Text := StringReplace(AAnexos, ';', sLineBreak, [rfReplaceAll]);

              if AEnviaPDF then
                GNReDM.ConfigurarImpressao(True);

              try
                GNReDM.ACBrGNRe1.Guias.Items[0].EnviarEmail(APara,
                                                            AAssunto,
                                                            slMensagemEmail,
                                                            AEnviaPDF, // Enviar PDF junto
                                                            slCC,      // Lista com emails que serão enviado cópias - TStrings
                                                            slAnexos); // Lista de slAnexos - TStrings

                Result := SetRetorno(ErrOK, 'Email enviado com sucesso');
              except
                on E: Exception do
                  raise EACBrLibException.Create(ErrRetorno, 'Erro ao enviar email' + sLineBreak + E.Message);
              end;
            end;
          finally
            slCC.Free;
            slAnexos.Free;
            slMensagemEmail.Free;
            GNReDM.FinalizarImpressao;
          end;
        end;
      end;
    finally
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.Imprimir(const eNomeImpressora, eMostrarPreview: PAnsiChar): Integer;
Var
  NomeImpressora, MostrarPreview: string;
begin
  try
    NomeImpressora := string(eNomeImpressora);
    MostrarPreview := string(eMostrarPreview);

    if Config.Log.Nivel > logNormal then
      GravarLog('GNRE_Imprimir(' + NomeImpressora + ',' + MostrarPreview + ' )', logCompleto, True)
    else
      GravarLog('GNRE_Imprimir', logNormal);

    GNReDM.Travar;
    try
      with  GNReDM.ACBrGNRe1 do
      begin
        if GuiasRetorno.Count = 0 then
          raise EACBrLibException.Create(ErrEnvio, Format(SInfGNReCarregados, [GuiasRetorno.Count]))
        else
        begin
          GNReDM.ConfigurarImpressao(False, NomeImpressora, MostrarPreview);
          GuiasRetorno.Imprimir;
          Result := SetRetorno(ErrOK);
        end;
        end;
    finally
      GNReDM.FinalizarImpressao;
      GNReDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.ImprimirPDF: Integer;
begin
  try
    GravarLog('GNRE_ImprimirPDF', logNormal);

    GNReDM.Travar;
    with  GNReDM.ACBrGNRe1 do
    begin
      try
        if GuiasRetorno.Count = 0 then
          raise EACBrLibException.Create(ErrEnvio, Format(SInfGNReCarregados, [GuiasRetorno.Count]))
        else
        begin
          GNReDM.ConfigurarImpressao(True);
          GuiasRetorno.ImprimirPDF;
          Result := SetRetorno(ErrOK);
        end;
      finally
        GNReDM.FinalizarImpressao;
        GNReDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibGNRe.SetRetornoGNReCarregados(const NumGNRe: Integer): Integer;
begin
  Result := SetRetorno( 0, {NumGNRe,} Format(SInfGNReCarregados, [NumGNRe]));
end;

end.
