{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit ACBrANe;

interface

uses
  Classes, SysUtils,
  ACBrBase,
  ACBrDFe, ACBrDFeException, ACBrDFeConfiguracoes,
  ACBrANeConfiguracoes, ACBrANeDocumentos, ACBrANeWebServices,
  ACBrANe.Classes, ACBrANeInterface, ACBrANe.Conversao,
  ACBrANe.WebServicesBase;

resourcestring
  ERR_SEM_Seguradora = 'Nenhuma seguradora selecionada';

type
  EACBrANeException = class(EACBrDFeException);

  { TACBrANe }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrANe = class(TACBrDFe)
  private
    FProvider: IACBrANeProvider;
    FDocumentos: TDocumentos;
    FStatus: TStatusACBrANe;
    FWebService: TWebServices;

    function GetConfiguracoes: TConfiguracoesANe;
    procedure SetConfiguracoes(AValue: TConfiguracoesANe);
  protected
    function CreateConfiguracoes: TConfiguracoes; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetSeguradora(aSeguradora: TSeguradora = segNenhum;
      aVersao: TVersaoANe = ve200);
    procedure SetProvider;

    procedure EnviarEmail(const sPara, sAssunto: string;
      sMensagem: TStrings = nil; sCC: TStrings = nil; Anexos: TStrings = nil;
      StreamANe: TStream = nil; const NomeArq: string = ''; sReplyTo: TStrings = nil; sBCC: TStrings = nil); override;

    function AverbarCTe: Boolean;
    function AverbarNFe: Boolean;
    function DeclararMDFe: Boolean;
    function AddBackMail: Boolean;

    function Enviar: Boolean;
    function Consultar(const AChave: string): Boolean;

    // Usado pelos Seguradoraes que seguem a vers�o 1 do layout da ABRASF.
    function GetNomeModeloDFe: string; override;
    function GetNameSpaceURI: string; override;

    procedure SetStatus(const stNewStatus: TStatusACBrANe);
    procedure LerSeguradoras;

    property Documentos: TDocumentos  read FDocumentos write FDocumentos;
    property Status: TStatusACBrANe     read FStatus;
    property Provider: IACBrANeProvider read FProvider;
    property WebService: TWebServices   read FWebService;

  published
    property Configuracoes: TConfiguracoesANe read GetConfiguracoes write SetConfiguracoes;
  end;

implementation

uses
  Math,
  ACBrUtil.Strings,
  ACBrUtil.Compatibilidade,
  ACBrDFeSSL,
  ACBrANe.ProviderManager;

{$IFDEF FPC}
 {$R ACBrANeServicos.rc}
{$ELSE}
 {$R ACBrANeServicos.res}
{$ENDIF}

{ TACBrANe }

function TACBrANe.AverbarCTe: Boolean;
begin
  Result := True;

  if Documentos.Count <= 0 then
    GerarException(ACBrStr('ERRO: Nenhum CT-e adicionado'));

  if Documentos.Count > 1 then
    GerarException(ACBrStr('ERRO: Conjunto de CT-e transmitidos (m�ximo de 1 CT-e)' +
      ' excedido. Quantidade atual: ' + IntToStr(Documentos.Count)));
end;

function TACBrANe.AverbarNFe: Boolean;
begin
  Result := True;

  if Documentos.Count <= 0 then
    GerarException(ACBrStr('ERRO: Nenhum NF-e adicionado'));

  if Documentos.Count > 1 then
    GerarException(ACBrStr('ERRO: Conjunto de NF-e transmitidos (m�ximo de 1 NF-e)' +
      ' excedido. Quantidade atual: ' + IntToStr(Documentos.Count)));
end;

function TACBrANe.DeclararMDFe: Boolean;
begin
  Result := True;

  if Documentos.Count <= 0 then
    GerarException(ACBrStr('ERRO: Nenhum MDF-e adicionado'));

  if Documentos.Count > 1 then
    GerarException(ACBrStr('ERRO: Conjunto de MDF-e transmitidos (m�ximo de 1 MDF-e)' +
      ' excedido. Quantidade atual: ' + IntToStr(Documentos.Count)));
end;

function TACBrANe.AddBackMail: Boolean;
begin
  { Falta ser Implementado}
  Result := True;
end;

function TACBrANe.Enviar: Boolean;
begin
  case Configuracoes.Geral.TipoDoc of
    tdNFe:  AverbarNFe;
    tdCTe:  AverbarCTe;
    tdMDFe: DeclararMDFe;
  end;

  if not Assigned(FProvider) then
    raise EACBrANeException.Create(ERR_SEM_Seguradora);

  FWebService.Enviar.Clear;

  FProvider.Enviar;

  Result := True;
end;

function TACBrANe.Consultar(const AChave: string): Boolean;
begin
  if not Assigned(FProvider) then
    raise EACBrANeException.Create(ERR_SEM_Seguradora);

  FWebService.Consultar.Clear;
  FWebService.Consultar.Chave := AChave;

  FProvider.Consultar;

  Result := True;
end;

constructor TACBrANe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDocumentos := TDocumentos.Create(Self);
  FWebService := TWebservices.Create;
end;

destructor TACBrANe.Destroy;
begin
  FDocumentos.Free;
  FWebService.Free;

  if Assigned(FProvider) then FProvider := nil;

  inherited Destroy;
end;

procedure TACBrANe.EnviarEmail(const sPara, sAssunto: string; sMensagem: TStrings;
  sCC: TStrings; Anexos: TStrings; StreamANe: TStream; const NomeArq: string;
  sReplyTo: TStrings; sBCC: TStrings);
begin
  SetStatus( stANeEmail );

  try
    inherited EnviarEmail(sPara, sAssunto, sMensagem, sCC, Anexos, StreamANe,
                          NomeArq, sReplyTo, sBCC);
  finally
    SetStatus( stANeIdle );
  end;
end;

procedure TACBrANe.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

end;

function TACBrANe.CreateConfiguracoes: TConfiguracoes;
begin
  Result := TConfiguracoesANe.Create(Self);
end;

procedure TACBrANe.SetSeguradora(aSeguradora: TSeguradora; aVersao: TVersaoANe);
begin
  Configuracoes.Geral.Seguradora := aSeguradora;
  Configuracoes.Geral.VersaoDF := aVersao;

  if aSeguradora <> segNenhum then
    SetProvider;
end;

procedure TACBrANe.SetProvider;
begin
  if Assigned(FProvider) then
    FProvider := nil;

  FProvider := TACBrANeProviderManager.GetProvider(Self);

  if not Assigned(FProvider) then Exit;
end;

function TACBrANe.GetNomeModeloDFe: string;
begin
  Result := 'ANe';
end;

procedure TACBrANe.LerSeguradoras;
begin
  LerParamsIni(True);
end;

function TACBrANe.GetNameSpaceURI: string;
begin
  Result := '';
end;

function TACBrANe.GetConfiguracoes: TConfiguracoesANe;
begin
  Result := TConfiguracoesANe(FPConfiguracoes);
end;

procedure TACBrANe.SetConfiguracoes(AValue: TConfiguracoesANe);
begin
  FPConfiguracoes := AValue;
end;

procedure TACBrANe.SetStatus(const stNewStatus: TStatusACBrANe);
begin
  if stNewStatus <> FStatus then
  begin
    FStatus := stNewStatus;
    if Assigned(OnStatusChange) then
      OnStatusChange(Self);
  end;
end;

end.

