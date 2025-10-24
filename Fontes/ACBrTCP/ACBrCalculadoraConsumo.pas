{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{ - Elias César Vieira                                                         }
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

unit ACBrCalculadoraConsumo;

interface

uses
  Classes, SysUtils, Contnrs,
  ACBrAPIBase, ACBrJSON, ACBrBase, ACBrSocket,
  ACBrCalculadoraConsumo.Schemas,
  ACBrUtil.Base;

type

  { IACBrCalcVersaoResponse }

  IACBrCalcVersaoResponse = interface
  ['{64162846-BB7D-4D60-8A1D-58A4C668135D}']
    procedure LoadJson(aJson: String);
    function versaoApp: String;
    function versaoDb: String;
    function descricaoVersaoDb: String;
    function dataVersaoDb: String;
    function ambiente: String;
    function ToJson: String;
  end;

  { IACBrCalcUFsResponse }

  IACBrCalcUFsResponse = interface
  ['{9D650273-F9EC-4EEF-BC12-D5845CE35CB5}']
    procedure LoadJson(aJson: String);
    function ToJson: String;
    function ufs: TACBrCalcUFs;
  end;

  { IACBrCalcMunicipiosResponse }

  IACBrCalcMunicipiosResponse = interface
  ['{82F2BD4E-B4ED-4789-91C4-7C191843750F}']
    procedure LoadJson(aJson: String);
    function ToJson: String;
    function municipios: TACBrCalcMunicipios;
  end;

  { IACBrCalcNCMResponse }

  IACBrCalcNCMResponse = interface
  ['{6CAAAA57-1BD3-4FFC-B1E8-8DCDBFB55D7D}']
    procedure LoadJson(aJson: String);
    function tributadoPeloImpostoSeletivo: Boolean;
    function aliquotaAdValorem: Double;
    function aliquotaAdRem: Double;
    function capitulo: String;
    function posicao: String;
    function subposicao: String;
    function item: String;
    function subitem: String;
    function ToJson: String;
  end;

  { IACBrCalcNBSResponse }

  IACBrCalcNBSResponse = interface
  ['{744DB4E4-81C1-45F9-91C6-17FA7B873A65}']
    procedure LoadJson(aJson: String);
    function tributadoPeloImpostoSeletivo: Boolean;
    function aliquotaAdValorem: Double;
    function capitulo: String;
    function posicao: String;
    function subposicao1: String;
    function subposicao2: String;
    function item: String;
    function ToJson: String;
  end;

  { IACBrCalcFundamentacoesResponse }

  IACBrCalcFundamentacoesResponse = interface
  ['{82F2BD4E-B4ED-4789-91C4-7C191843750F}']
    procedure LoadJson(aJson: String);
    function ToJson: String;
    function fundamentacoes: TACBrCalcFundamentacoesLegais;
  end;

  { IACBrCalcClassifTributariasResponse }

  IACBrCalcClassifTributariasResponse = interface
  ['{0F1DC039-B982-46DD-B85E-3423BAE37DA7}']
    procedure LoadJson(aJson: String);
    function ToJson: String;
    function classificacoes: TACBrCalcClassifTributarias;
  end;

  { IACBrCalcAliquotaResponse }

  IACBrCalcAliquotaResponse = interface
  ['{6DF6862A-BCA1-4726-93ED-C7C74D15E23F}']
    procedure LoadJson(aJson: String);
    function aliquotaReferencia: Double;
    function aliquotaPropria: Double;
    function formaAplicacao: String;
    function ToJson: String;
  end;

  { IACBrCalcBaseCalculoResponse }

  IACBrCalcBaseCalculoResponse = interface
  ['{0F1DC039-B982-46DD-B85E-3423BAE37DA7}']
    procedure LoadJson(aJson: String);
    function ToJson: String;
    function baseCalculo: Double;
  end;

  { IACBrCalcRegimeGeralResponse }

  IACBrCalcRegimeGeralResponse = interface
  ['{4BA12425-07CA-47FA-B9B3-82B6ADE8C788}']
    procedure LoadJson(aJson: String);
    function ToJson: String;
    function objetos: TACBrCalcObjetos;
    function total: TACBrCalcValoresTotais;
  end;

  { TACBrCalcUFsResponse }

  TACBrCalcUFsResponse = class(TInterfacedObject, IACBrCalcUFsResponse)
  private
    fufs: TACBrCalcUFs;
  public
    destructor destroy; override;

    procedure LoadJson(aJson: String);
    function ToJson: String;
    function ufs: TACBrCalcUFs;
  end;

  { TACBrCalcMunicipiosResponse }

  TACBrCalcMunicipiosResponse = class(TInterfacedObject, IACBrCalcMunicipiosResponse)
  private
    fmunicipios: TACBrCalcMunicipios;
  public
    destructor destroy; override;

    procedure LoadJson(aJson: String);
    function ToJson: String;
    function municipios: TACBrCalcMunicipios;
  end;

  { TACBrCalcNCMResponse }

  TACBrCalcNCMResponse = class(TInterfacedObject, IACBrCalcNCMResponse)
  private
    fncm: TACBrCalcNCM;
  protected
    function ncm: TACBrCalcNCM;
  public
    destructor Destroy; override;

    procedure LoadJson(aJson: String);
    function tributadoPeloImpostoSeletivo: Boolean;
    function aliquotaAdValorem: Double;
    function aliquotaAdRem: Double;
    function capitulo: String;
    function posicao: String;
    function subposicao: String;
    function item: String;
    function subitem: String;
    function ToJson: String;
  end;

  { TACBrCalcNBSResponse }

  TACBrCalcNBSResponse = class(TInterfacedObject, IACBrCalcNBSResponse)
  private
    fnbs: TACBrCalcNBS;
  protected
    function nbs: TACBrCalcNBS;
  public
    destructor Destroy; override;

    procedure LoadJson(aJson: String);
    function tributadoPeloImpostoSeletivo: Boolean;
    function aliquotaAdValorem: Double;
    function capitulo: String;
    function posicao: String;
    function subposicao1: String;
    function subposicao2: String;
    function item: String;
    function ToJson: String;
  end;

  { TACBrCalcFundamentacoesResponse }

  TACBrCalcFundamentacoesResponse = class(TInterfacedObject, IACBrCalcFundamentacoesResponse)
  private
    ffundamentacoes: TACBrCalcFundamentacoesLegais;
  public
    destructor destroy; override;

    procedure LoadJson(aJson: String);
    function ToJson: String;
    function fundamentacoes: TACBrCalcFundamentacoesLegais;
  end;

  { TACBrCalcClassifTributariasResponse }

  TACBrCalcClassifTributariasResponse = class(TInterfacedObject, IACBrCalcClassifTributariasResponse)
  private
    fclassificacoes: TACBrCalcClassifTributarias;
  public
    destructor destroy; override;

    procedure LoadJson(aJson: String);
    function ToJson: String;
    function classificacoes: TACBrCalcClassifTributarias;
  end;

  { TACBrCalcAliquotaResponse }

  TACBrCalcAliquotaResponse = class(TInterfacedObject, IACBrCalcAliquotaResponse)
  private
    faliquota: TACBrCalcAliquota;
  protected
    function aliquota: TACBrCalcAliquota;
  public
    destructor Destroy; override;

    procedure LoadJson(aJson: String);
    function aliquotaReferencia: Double;
    function aliquotaPropria: Double;
    function formaAplicacao: String;
    function ToJson: String;
  end;

  { TACBrCalcVersaoResponse }

  TACBrCalcVersaoResponse = class(TInterfacedObject, IACBrCalcVersaoResponse)
  private
    fversao: TACBrCalcVersao;
  protected
    function versao: TACBrCalcVersao;
  public
    destructor Destroy; override;

    procedure LoadJson(aJson: String);
    function versaoApp: String;
    function versaoDb: String;
    function descricaoVersaoDb: String;
    function dataVersaoDb: String;
    function ambiente: String;
    function ToJson: String;
  end;

  { TACBrCalcBaseCalculoResponse }

  TACBrCalcBaseCalculoResponse = class(TInterfacedObject, IACBrCalcBaseCalculoResponse)
  private
    fObj: TACBrCalcBaseCalculoModel;
  protected
    function Obj: TACBrCalcBaseCalculoModel;
  public
    destructor Destroy; override;

    procedure LoadJson(aJson: String);
    function ToJson: String;
    function baseCalculo: Double;
  end;

  { TACBrCalcRegimeGeralResponse }

  TACBrCalcRegimeGeralResponse = class(TInterfacedObject, IACBrCalcRegimeGeralResponse)
  private
    fresponse: TACBrCalcROC;
  protected
    function response: TACBrCalcROC;
  public
    destructor destroy; override;
    procedure LoadJson(aJson: String);
    function ToJson: String;

    function objetos: TACBrCalcObjetos;
    function total: TACBrCalcValoresTotais;
  end;

  TACBrCalculadoraConsumo = class;

  { TACBrCalcBaseCalculo }

  TACBrCalcBaseCalculo = class
  private
    fOwner: TACBrCalculadoraConsumo;
    fRespostaErro: TACBrCalcErro;
    fISMercadorias: TACBrCalcBCISMercadorias;
    fCIBSMercadorias: TACBrCalcBCCIBSMercadorias;
    function GetCIBSMercadorias: TACBrCalcBCCIBSMercadorias;
    function GetISMercadorias: TACBrCalcBCISMercadorias;
    function GetRespostaErro: TACBrCalcErro;
    procedure SetRespostaErro(aJson: String);
  public
    constructor Create(aOwner: TACBrCalculadoraConsumo);
    destructor Destroy; override;
    procedure Clear;

    function CalcularPorIS(out aResponse: IACBrCalcBaseCalculoResponse): Boolean;
    function CalcularPorCIBS(out aResponse: IACBrCalcBaseCalculoResponse): Boolean;

    property ISMercadorias: TACBrCalcBCISMercadorias read GetISMercadorias;
    property CIBSMercadorias: TACBrCalcBCCIBSMercadorias read GetCIBSMercadorias;
    property RespostaErro: TACBrCalcErro read GetRespostaErro;
  end;

  { TACBrCalcDadosAbertos }

  TACBrCalcDadosAbertos = class
  private
    fOwner: TACBrCalculadoraConsumo;
    fRespostaErro: TACBrCalcErro;
    function GetRespostaErro: TACBrCalcErro;
    procedure SetRespostaErro(aJson: String);
  public
    constructor Create(aOwner: TACBrCalculadoraConsumo);
    destructor Destroy; override;
    procedure Clear;

    function ConsultarVersao(out aResponse: IACBrCalcVersaoResponse): Boolean;
    function ConsultarUFs(out aResponse: IACBrCalcUFsResponse): Boolean;
    function ConsultarMunicipios(aSiglaUF: String; out aResponse: IACBrCalcMunicipiosResponse): Boolean;
    function ConsultarNCM(aNCM: String; aData: TDateTime; out aResponse: IACBrCalcNCMResponse): Boolean;
    function ConsultarNBS(aNBS: String; aData: TDateTime; out aResponse: IACBrCalcNBSResponse): Boolean;
    function ConsultarFundamentacoes(aData: TDateTime; out aResponse: IACBrCalcFundamentacoesResponse): Boolean;
    function ConsultarClassTrib(aIdST: Integer; aData: TDateTime; out aResponse: IACBrCalcClassifTributariasResponse): Boolean;
    function ConsultarClassTribImpostoSeletivo(aData: TDateTime; out aResponse: IACBrCalcClassifTributariasResponse): Boolean;
    function ConsultarClassTribCbsIbs(aData: TDateTime; out aResponse: IACBrCalcClassifTributariasResponse): Boolean;
    function ConsultarAliquotaUniao(aData: TDateTime; out aResponse: IACBrCalcAliquotaResponse): Boolean;
    function ConsultarAliquotaUF(aCodUF: Integer; aData: TDateTime; out aResponse: IACBrCalcAliquotaResponse): Boolean;
    function ConsultarAliquotaMunicipio(aCodMunicipio: Integer; aData: TDateTime; out aResponse: IACBrCalcAliquotaResponse): Boolean;

    property RespostaErro: TACBrCalcErro read GetRespostaErro;
  end;

  { TACBrCalculadoraConsumo }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrCalculadoraConsumo = class(TACBrHTTP)
  private
    fURL: String;
    fRespostaErro: TACBrCalcErro;
    fGerarXMLRequest: TACBrCalcROC;
    fBaseCalculo: TACBrCalcBaseCalculo;
    fDadosAbertos: TACBrCalcDadosAbertos;
    fRegimeGeralRequest: TACBrCalcOperacao;
    function GetGerarXMLRequest: TACBrCalcROC;
    function GetRegimeGeralRequest: TACBrCalcOperacao;
    function GetRespostaErro: TACBrCalcErro;
    function GetURL: String;
  protected
    procedure PrepararHTTP;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;

    function DadosAbertos: TACBrCalcDadosAbertos;
    function BaseCalculo: TACBrCalcBaseCalculo;
    function GerarXML(out aXMLResponse: AnsiString): Boolean;
    function ValidarXML(const aTipo, aSubTipo: String; const aXML: AnsiString): Boolean;
    function RegimeGeral(out aResponse: IACBrCalcRegimeGeralResponse): Boolean;

    property GerarXMLRequest: TACBrCalcROC read GetGerarXMLRequest;
    property RegimeGeralRequest: TACBrCalcOperacao read GetRegimeGeralRequest;
    property RespostaErro: TACBrCalcErro read GetRespostaErro;
  published
    property URL: String read GetURL write fURL;
  end;

implementation

uses
  StrUtils, synautil,
  ACBrUtil.Strings,
  ACBrUtil.FilesIO,
  ACBrUtil.DateTime;

{ TACBrCalcUFsResponse }

destructor TACBrCalcUFsResponse.destroy;
begin
  if Assigned(fufs) then
    fufs.Free;
  inherited destroy;
end;

procedure TACBrCalcUFsResponse.LoadJson(aJson: String);
begin
  ufs.AsJSON := aJson;
end;

function TACBrCalcUFsResponse.ToJson: String;
begin
  Result := ufs.AsJSON;
end;

function TACBrCalcUFsResponse.ufs: TACBrCalcUFs;
begin
  if (not Assigned(fufs)) then
    fufs := TACBrCalcUFs.Create;
  Result := fufs;
end;

{ TACBrCalcMunicipiosResponse }

destructor TACBrCalcMunicipiosResponse.destroy;
begin
  if Assigned(fmunicipios) then
    fmunicipios.Free;
  inherited destroy;
end;

procedure TACBrCalcMunicipiosResponse.LoadJson(aJson: String);
begin
  municipios.AsJSON := aJson;
end;

function TACBrCalcMunicipiosResponse.ToJson: String;
begin
  Result := municipios.AsJSON;
end;

function TACBrCalcMunicipiosResponse.municipios: TACBrCalcMunicipios;
begin
  if (not Assigned(fmunicipios)) then
    fmunicipios := TACBrCalcMunicipios.Create;
  Result := fmunicipios;
end;

{ TACBrCalcNCMResponse }

function TACBrCalcNCMResponse.ncm: TACBrCalcNCM;
begin
  if (not Assigned(fncm)) then
    fncm := TACBrCalcNCM.Create;
  Result := fncm;
end;

destructor TACBrCalcNCMResponse.Destroy;
begin
  if Assigned(fncm) then
    fncm.Free;
  inherited Destroy;
end;

procedure TACBrCalcNCMResponse.LoadJson(aJson: String);
begin
  ncm.AsJSON := aJson;
end;

function TACBrCalcNCMResponse.tributadoPeloImpostoSeletivo: Boolean;
begin
  Result := ncm.tributadoPeloImpostoSeletivo;
end;

function TACBrCalcNCMResponse.aliquotaAdValorem: Double;
begin
  Result := ncm.aliquotaAdValorem;
end;

function TACBrCalcNCMResponse.aliquotaAdRem: Double;
begin
  Result := ncm.aliquotaAdRem;
end;

function TACBrCalcNCMResponse.capitulo: String;
begin
  Result := ncm.capitulo;
end;

function TACBrCalcNCMResponse.posicao: String;
begin
  Result := ncm.posicao;
end;

function TACBrCalcNCMResponse.subposicao: String;
begin
  Result := ncm.subposicao;
end;

function TACBrCalcNCMResponse.item: String;
begin
  Result := ncm.item;
end;

function TACBrCalcNCMResponse.subitem: String;
begin
  Result := ncm.subitem;
end;

function TACBrCalcNCMResponse.ToJson: String;
begin
  Result := ncm.AsJSON;
end;

{ TACBrCalcNBSResponse }

function TACBrCalcNBSResponse.nbs: TACBrCalcNBS;
begin
  if (not Assigned(fnbs)) then
    fnbs := TACBrCalcNBS.Create;
  Result := fnbs;
end;

destructor TACBrCalcNBSResponse.Destroy;
begin
  if Assigned(fnbs) then
    fnbs.Free;
  inherited Destroy;
end;

procedure TACBrCalcNBSResponse.LoadJson(aJson: String);
begin
  nbs.AsJSON := aJson;
end;

function TACBrCalcNBSResponse.tributadoPeloImpostoSeletivo: Boolean;
begin
  Result := nbs.tributadoPeloImpostoSeletivo;
end;

function TACBrCalcNBSResponse.aliquotaAdValorem: Double;
begin
  Result := nbs.aliquotaAdValorem;
end;

function TACBrCalcNBSResponse.capitulo: String;
begin
  Result := nbs.capitulo;
end;

function TACBrCalcNBSResponse.posicao: String;
begin
  Result := nbs.posicao;
end;

function TACBrCalcNBSResponse.subposicao1: String;
begin
  Result := nbs.subposicao1;
end;

function TACBrCalcNBSResponse.subposicao2: String;
begin
  Result := nbs.subposicao2;
end;

function TACBrCalcNBSResponse.item: String;
begin
  Result := nbs.item;
end;

function TACBrCalcNBSResponse.ToJson: String;
begin
  Result := nbs.AsJSON;
end;

{ TACBrCalcFundamentacoesResponse }

destructor TACBrCalcFundamentacoesResponse.destroy;
begin
  if Assigned(ffundamentacoes) then
    ffundamentacoes.Free;
  inherited destroy;
end;

procedure TACBrCalcFundamentacoesResponse.LoadJson(aJson: String);
begin
  fundamentacoes.AsJSON := aJson;
end;

function TACBrCalcFundamentacoesResponse.ToJson: String;
begin
  Result := fundamentacoes.AsJSON;
end;

function TACBrCalcFundamentacoesResponse.fundamentacoes: TACBrCalcFundamentacoesLegais;
begin
  if (not Assigned(ffundamentacoes)) then
    ffundamentacoes := TACBrCalcFundamentacoesLegais.Create;
  Result := ffundamentacoes;
end;

{ TACBrCalcClassifTributariasResponse }

destructor TACBrCalcClassifTributariasResponse.destroy;
begin
  if Assigned(fclassificacoes) then
    fclassificacoes.Free;
  inherited destroy;
end;

procedure TACBrCalcClassifTributariasResponse.LoadJson(aJson: String);
begin
  classificacoes.AsJSON := aJson;
end;

function TACBrCalcClassifTributariasResponse.ToJson: String;
begin
  Result := classificacoes.AsJSON;
end;

function TACBrCalcClassifTributariasResponse.classificacoes: TACBrCalcClassifTributarias;
begin
  if (not Assigned(fclassificacoes)) then
    fclassificacoes := TACBrCalcClassifTributarias.Create;
  Result := fclassificacoes;
end;

{ TACBrCalcAliquotaResponse }

function TACBrCalcAliquotaResponse.aliquota: TACBrCalcAliquota;
begin
  if (not Assigned(faliquota)) then
    faliquota := TACBrCalcAliquota.Create;
  Result := faliquota;
end;

destructor TACBrCalcAliquotaResponse.Destroy;
begin
  if Assigned(faliquota) then
    faliquota.Free;
  inherited Destroy;
end;

procedure TACBrCalcAliquotaResponse.LoadJson(aJson: String);
begin
  aliquota.AsJSON := aJson;
end;

function TACBrCalcAliquotaResponse.aliquotaReferencia: Double;
begin
  Result := aliquota.aliquotaReferencia;
end;

function TACBrCalcAliquotaResponse.aliquotaPropria: Double;
begin
  Result := aliquota.aliquotaPropria;
end;

function TACBrCalcAliquotaResponse.formaAplicacao: String;
begin
  Result := aliquota.formaAplicacao;
end;

function TACBrCalcAliquotaResponse.ToJson: String;
begin
  Result := aliquota.AsJSON;
end;

{ TACBrCalcVersaoResponse }

function TACBrCalcVersaoResponse.versao: TACBrCalcVersao;
begin
  if (not Assigned(fversao)) then
    fversao := TACBrCalcVersao.Create;
  Result := fversao;
end;

destructor TACBrCalcVersaoResponse.Destroy;
begin
  if Assigned(fversao) then
    fversao.Free;
  inherited Destroy;
end;

procedure TACBrCalcVersaoResponse.LoadJson(aJson: String);
begin
  versao.AsJSON := aJson;
end;

function TACBrCalcVersaoResponse.versaoApp: String;
begin
  Result := versao.versaoApp;
end;

function TACBrCalcVersaoResponse.versaoDb: String;
begin
  Result := versao.versaoDb;
end;

function TACBrCalcVersaoResponse.descricaoVersaoDb: String;
begin
  Result := versao.descricaoVersaoDb;
end;

function TACBrCalcVersaoResponse.dataVersaoDb: String;
begin
  Result := versao.dataVersaoDb;
end;

function TACBrCalcVersaoResponse.ambiente: String;
begin
  Result := versao.ambiente;
end;

function TACBrCalcVersaoResponse.ToJson: String;
begin
  Result := versao.AsJSON;
end;

{ TACBrCalcBaseCalculoResponse }

function TACBrCalcBaseCalculoResponse.Obj: TACBrCalcBaseCalculoModel;
begin
  if (not Assigned(fObj)) then
    fObj := TACBrCalcBaseCalculoModel.Create;
  Result := fObj;
end;

destructor TACBrCalcBaseCalculoResponse.Destroy;
begin
  if Assigned(fObj) then
    fObj.Free;
  inherited Destroy;
end;

procedure TACBrCalcBaseCalculoResponse.LoadJson(aJson: String);
begin
  Obj.AsJSON := aJson;
end;

function TACBrCalcBaseCalculoResponse.ToJson: String;
begin
  Result := Obj.AsJSON;
end;

function TACBrCalcBaseCalculoResponse.baseCalculo: Double;
begin
  Result := Obj.baseCalculo;
end;

{ TACBrCalcRegimeGeralResponse }

function TACBrCalcRegimeGeralResponse.response: TACBrCalcROC;
begin
  if (not Assigned(fresponse)) then
    fresponse := TACBrCalcROC.Create;
  Result := fresponse;
end;

destructor TACBrCalcRegimeGeralResponse.destroy;
begin
  if Assigned(fresponse) then
    fresponse.Free;
  inherited destroy;
end;

procedure TACBrCalcRegimeGeralResponse.LoadJson(aJson: String);
begin
  response.AsJSON := aJson;
end;

function TACBrCalcRegimeGeralResponse.ToJson: String;
begin
  Result := response.AsJSON;
end;

function TACBrCalcRegimeGeralResponse.objetos: TACBrCalcObjetos;
begin
  Result := response.objetos;
end;

function TACBrCalcRegimeGeralResponse.total: TACBrCalcValoresTotais;
begin
  Result := response.total;
end;

{ TACBrCalcBaseCalculo }

function TACBrCalcBaseCalculo.GetRespostaErro: TACBrCalcErro;
begin
  if (not Assigned(fRespostaErro)) then
    fRespostaErro := TACBrCalcErro.Create;
  Result := fRespostaErro;
end;

function TACBrCalcBaseCalculo.GetCIBSMercadorias: TACBrCalcBCCIBSMercadorias;
begin
  if (not Assigned(fCIBSMercadorias)) then
    fCIBSMercadorias := TACBrCalcBCCIBSMercadorias.Create;
  Result := fCIBSMercadorias;
end;

function TACBrCalcBaseCalculo.GetISMercadorias: TACBrCalcBCISMercadorias;
begin
  if (not Assigned(fISMercadorias)) then
    fISMercadorias := TACBrCalcBCISMercadorias.Create;
  Result := fISMercadorias;
end;

procedure TACBrCalcBaseCalculo.SetRespostaErro(aJson: String);
begin
  RespostaErro.AsJSON := aJson;
  if Assigned(fOwner) then
    fOwner.RespostaErro.AsJSON := aJson;
end;

constructor TACBrCalcBaseCalculo.Create(aOwner: TACBrCalculadoraConsumo);
begin
  inherited Create;
  fOwner := aOwner;
end;

destructor TACBrCalcBaseCalculo.Destroy;
begin
  if Assigned(fISMercadorias) then
    fISMercadorias.Free;
  if Assigned(fCIBSMercadorias) then
    fCIBSMercadorias.Free;
  if Assigned(fRespostaErro) then
    fRespostaErro.Free;
  inherited Destroy;
end;

procedure TACBrCalcBaseCalculo.Clear;
begin
  if Assigned(fISMercadorias) then
    fISMercadorias.Clear;
  if Assigned(fCIBSMercadorias) then
    fCIBSMercadorias.Clear;
  if Assigned(fRespostaErro) then
    fRespostaErro.Clear;
end;

function TACBrCalcBaseCalculo.CalcularPorIS(out aResponse: IACBrCalcBaseCalculoResponse): Boolean;
begin
  Result := False;
  if not Assigned(fOwner) then
    Exit;

  if ISMercadorias.IsEmpty then
    raise EACBrAPIException.Create(ACBrStr(Format(sErroObjetoNaoPrenchido, ['ISMercadorias'])));

  aResponse := TACBrCalcBaseCalculoResponse.Create;
  fOwner.PrepararHTTP;
  WriteStrToStream(fOwner.HTTPSend.Document, ISMercadorias.AsJSON);
  fOwner.HTTPSend.MimeType := CContentTypeApplicationJSon;
  fOwner.URLPathParams.Add(cACBrCalcEndpointCalculadora);
  fOwner.URLPathParams.Add(cACBrCalcEndpointBaseCalculo);
  fOwner.URLPathParams.Add(cACBrCalcEndpointISMercadorias);

  try
    fOwner.HTTPMethod(cHTTPMethodPOST, fOwner.URL);
  except
    SetRespostaErro(fOwner.HTTPResponse);
    if RespostaErro.IsEmpty then
      raise;
  end;

  Result := (fOwner.HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(fOwner.HTTPResponse)
  else
    SetRespostaErro(fOwner.HTTPResponse);
end;

function TACBrCalcBaseCalculo.CalcularPorCIBS(out aResponse: IACBrCalcBaseCalculoResponse): Boolean;
begin
  Result := False;
  if not Assigned(fOwner) then
    Exit;

  if CIBSMercadorias.IsEmpty then
    raise EACBrAPIException.Create(ACBrStr(Format(sErroObjetoNaoPrenchido, ['CIBSMercadorias'])));

  aResponse := TACBrCalcBaseCalculoResponse.Create;
  fOwner.PrepararHTTP;
  WriteStrToStream(fOwner.HTTPSend.Document, CIBSMercadorias.AsJSON);
  fOwner.HTTPSend.MimeType := CContentTypeApplicationJSon;
  fOwner.URLPathParams.Add(cACBrCalcEndpointCalculadora);
  fOwner.URLPathParams.Add(cACBrCalcEndpointBaseCalculo);
  fOwner.URLPathParams.Add(cACBrCalcEndpointCIBSMercadorias);

  try
    fOwner.HTTPMethod(cHTTPMethodPOST, fOwner.URL);
  except
    SetRespostaErro(fOwner.HTTPResponse);
    if RespostaErro.IsEmpty then
      raise;
  end;

  Result := (fOwner.HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(fOwner.HTTPResponse)
  else
    SetRespostaErro(fOwner.HTTPResponse);
end;

{ TACBrCalcDadosAbertos }

function TACBrCalcDadosAbertos.GetRespostaErro: TACBrCalcErro;
begin
  if (not Assigned(fRespostaErro)) then
    fRespostaErro := TACBrCalcErro.Create;
  Result := fRespostaErro;
end;

procedure TACBrCalcDadosAbertos.SetRespostaErro(aJson: String);
begin
  RespostaErro.AsJSON := aJson;
  if Assigned(fOwner) then
    fOwner.RespostaErro.AsJSON := aJson;
end;

constructor TACBrCalcDadosAbertos.Create(aOwner: TACBrCalculadoraConsumo);
begin
  inherited Create;
  fOwner := aOwner;
end;

destructor TACBrCalcDadosAbertos.Destroy;
begin
  if Assigned(fRespostaErro) then
    fRespostaErro.Free;
  inherited Destroy;
end;

procedure TACBrCalcDadosAbertos.Clear;
begin
  if Assigned(fRespostaErro) then
    fRespostaErro.Clear;
end;

function TACBrCalcDadosAbertos.ConsultarVersao(out aResponse: IACBrCalcVersaoResponse): Boolean;
begin
  Result := False;
  if not Assigned(fOwner) then
    Exit;

  aResponse := TACBrCalcVersaoResponse.Create;
  fOwner.PrepararHTTP;
  fOwner.URLPathParams.Add(cACBrCalcEndpointCalculadora);
  fOwner.URLPathParams.Add(cACBrCalcEndpointDadosAbertos);
  fOwner.URLPathParams.Add(cACBrCalcEndpointVersao);

  try
    fOwner.HTTPMethod(cHTTPMethodGET, fOwner.URL);
  except
    SetRespostaErro(fOwner.HTTPResponse);
    if RespostaErro.IsEmpty then
      raise;
  end;

  Result := (fOwner.HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(fOwner.HTTPResponse)
  else
    SetRespostaErro(fOwner.HTTPResponse);
end;

function TACBrCalcDadosAbertos.ConsultarUFs(out aResponse: IACBrCalcUFsResponse): Boolean;
begin
  Result := False;
  if not Assigned(fOwner) then
    Exit;

  aResponse := TACBrCalcUFsResponse.Create;
  fOwner.PrepararHTTP;
  fOwner.URLPathParams.Add(cACBrCalcEndpointCalculadora);
  fOwner.URLPathParams.Add(cACBrCalcEndpointDadosAbertos);
  fOwner.URLPathParams.Add(cACBrCalcEndpointUFs);

  try
    fOwner.HTTPMethod(cHTTPMethodGET, fOwner.URL);
  except
    SetRespostaErro(fOwner.HTTPResponse);
    if RespostaErro.IsEmpty then
      raise;
  end;

  Result := (fOwner.HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(fOwner.HTTPResponse)
  else
    SetRespostaErro(fOwner.HTTPResponse);
end;

function TACBrCalcDadosAbertos.ConsultarMunicipios(aSiglaUF: String; out aResponse: IACBrCalcMunicipiosResponse): Boolean;
begin
  Result := False;
  if EstaVazio(aSiglaUF) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['SiglaUF']));

  if not Assigned(fOwner) then
    Exit;

  fOwner.PrepararHTTP;
  fOwner.URLQueryParams.Values['siglaUf'] := aSiglaUF;
  fOwner.URLPathParams.Add(cACBrCalcEndpointCalculadora);
  fOwner.URLPathParams.Add(cACBrCalcEndpointDadosAbertos);
  fOwner.URLPathParams.Add(cACBrCalcEndpointUFs);
  fOwner.URLPathParams.Add(cACBrCalcEndpointMunicipios);

  try
    fOwner.HTTPMethod(cHTTPMethodGET, fOwner.URL);
  except
    SetRespostaErro(fOwner.HTTPResponse);
    if RespostaErro.IsEmpty then
      raise;
  end;
  
  aResponse := TACBrCalcMunicipiosResponse.Create;
  Result := (fOwner.HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(fOwner.HTTPResponse)
  else
    SetRespostaErro(fOwner.HTTPResponse);
end;

function TACBrCalcDadosAbertos.ConsultarNCM(aNCM: String; aData: TDateTime; out aResponse: IACBrCalcNCMResponse): Boolean;
begin
  Result := False;
  if EstaVazio(aNCM) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['NCM']));
  if EstaZerado(aData) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['Data']));

  if not Assigned(fOwner) then
    Exit;

  fOwner.PrepararHTTP;
  fOwner.URLQueryParams.Values['ncm'] := aNCM;
  fOwner.URLQueryParams.Values['data'] := FormatDateBr(aData, 'YYYY-MM-DD');
  fOwner.URLPathParams.Add(cACBrCalcEndpointCalculadora);
  fOwner.URLPathParams.Add(cACBrCalcEndpointDadosAbertos);
  fOwner.URLPathParams.Add(cACBrCalcEndpointNCM);

  try
    fOwner.HTTPMethod(cHTTPMethodGET, fOwner.URL);
  except
    SetRespostaErro(fOwner.HTTPResponse);
    if RespostaErro.IsEmpty then
      raise;
  end;

  aResponse := TACBrCalcNCMResponse.Create;
  Result := (fOwner.HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(fOwner.HTTPResponse)
  else
    SetRespostaErro(fOwner.HTTPResponse);
end;

function TACBrCalcDadosAbertos.ConsultarNBS(aNBS: String; aData: TDateTime; out aResponse: IACBrCalcNBSResponse): Boolean;
begin
  Result := False;
  if EstaVazio(aNBS) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['NBS']));
  if EstaZerado(aData) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['Data']));

  if not Assigned(fOwner) then
    Exit;

  fOwner.PrepararHTTP;
  fOwner.URLQueryParams.Values['nbs'] := aNBS;
  fOwner.URLQueryParams.Values['data'] := FormatDateBr(aData, 'YYYY-MM-DD');
  fOwner.URLPathParams.Add(cACBrCalcEndpointCalculadora);
  fOwner.URLPathParams.Add(cACBrCalcEndpointDadosAbertos);
  fOwner.URLPathParams.Add(cACBrCalcEndpointNBS);

  try
    fOwner.HTTPMethod(cHTTPMethodGET, fOwner.URL);
  except
    SetRespostaErro(fOwner.HTTPResponse);
    if RespostaErro.IsEmpty then
      raise;
  end;

  aResponse := TACBrCalcNBSResponse.Create;
  Result := (fOwner.HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(fOwner.HTTPResponse)
  else
    SetRespostaErro(fOwner.HTTPResponse);
end;

function TACBrCalcDadosAbertos.ConsultarFundamentacoes(aData: TDateTime; out aResponse: IACBrCalcFundamentacoesResponse): Boolean;
begin
  Result := False;
  if EstaZerado(aData) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['Data']));

  if not Assigned(fOwner) then
    Exit;

  fOwner.PrepararHTTP;
  fOwner.URLQueryParams.Values['data'] := FormatDateBr(aData, 'YYYY-MM-DD');
  fOwner.URLPathParams.Add(cACBrCalcEndpointCalculadora);
  fOwner.URLPathParams.Add(cACBrCalcEndpointDadosAbertos);
  fOwner.URLPathParams.Add(cACBrCalcEndpointFundamentLegais);

  try
    fOwner.HTTPMethod(cHTTPMethodGET, fOwner.URL);
  except
    SetRespostaErro(fOwner.HTTPResponse);
    if RespostaErro.IsEmpty then
      raise;
  end;

  aResponse := TACBrCalcFundamentacoesResponse.Create;
  Result := (fOwner.HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(fOwner.HTTPResponse)
  else
    SetRespostaErro(fOwner.HTTPResponse);
end;

function TACBrCalcDadosAbertos.ConsultarClassTrib(aIdST: Integer; aData: TDateTime; out aResponse: IACBrCalcClassifTributariasResponse): Boolean;
begin
  Result := False;
  if (aIdST < 1) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['IdST']));
  if EstaZerado(aData) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['Data']));

  if not Assigned(fOwner) then
    Exit;

  fOwner.PrepararHTTP;
  fOwner.URLQueryParams.Values['data'] := FormatDateBr(aData, 'YYYY-MM-DD');
  fOwner.URLPathParams.Add(cACBrCalcEndpointCalculadora);
  fOwner.URLPathParams.Add(cACBrCalcEndpointDadosAbertos);
  fOwner.URLPathParams.Add(cACBrCalcEndpointClassificTribs);
  fOwner.URLPathParams.Add(IntToStr(aIdST));

  try
    fOwner.HTTPMethod(cHTTPMethodGET, fOwner.URL);
  except
    SetRespostaErro(fOwner.HTTPResponse);
    if RespostaErro.IsEmpty then
      raise;
  end;

  aResponse := TACBrCalcClassifTributariasResponse.Create;
  Result := (fOwner.HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(fOwner.HTTPResponse)
  else
    SetRespostaErro(fOwner.HTTPResponse);
end;

function TACBrCalcDadosAbertos.ConsultarClassTribImpostoSeletivo(aData: TDateTime; out aResponse: IACBrCalcClassifTributariasResponse): Boolean;
begin
  Result := False;
  if EstaZerado(aData) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['Data']));

  if not Assigned(fOwner) then
    Exit;

  fOwner.PrepararHTTP;
  fOwner.URLQueryParams.Values['data'] := FormatDateBr(aData, 'YYYY-MM-DD');
  fOwner.URLPathParams.Add(cACBrCalcEndpointCalculadora);
  fOwner.URLPathParams.Add(cACBrCalcEndpointDadosAbertos);
  fOwner.URLPathParams.Add(cACBrCalcEndpointClassificTribs);
  fOwner.URLPathParams.Add(cACBrCalcEndpointImpostoSeletivo);

  try
    fOwner.HTTPMethod(cHTTPMethodGET, fOwner.URL);
  except
    SetRespostaErro(fOwner.HTTPResponse);
    if RespostaErro.IsEmpty then
      raise;
  end;

  aResponse := TACBrCalcClassifTributariasResponse.Create;
  Result := (fOwner.HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(fOwner.HTTPResponse)
  else
    SetRespostaErro(fOwner.HTTPResponse);
end;

function TACBrCalcDadosAbertos.ConsultarClassTribCbsIbs(aData: TDateTime; out aResponse: IACBrCalcClassifTributariasResponse): Boolean;
begin
  Result := False;
  if EstaZerado(aData) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['Data']));

  if not Assigned(fOwner) then
    Exit;

  fOwner.PrepararHTTP;
  fOwner.URLQueryParams.Values['data'] := FormatDateBr(aData, 'YYYY-MM-DD');
  fOwner.URLPathParams.Add(cACBrCalcEndpointCalculadora);
  fOwner.URLPathParams.Add(cACBrCalcEndpointDadosAbertos);
  fOwner.URLPathParams.Add(cACBrCalcEndpointClassificTribs);
  fOwner.URLPathParams.Add(cACBrCalcEndpointCbsIbs);

  try
    fOwner.HTTPMethod(cHTTPMethodGET, fOwner.URL);
  except
    SetRespostaErro(fOwner.HTTPResponse);
    if RespostaErro.IsEmpty then
      raise;
  end;

  aResponse := TACBrCalcClassifTributariasResponse.Create;
  Result := (fOwner.HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(fOwner.HTTPResponse)
  else
    SetRespostaErro(fOwner.HTTPResponse);
end;

function TACBrCalcDadosAbertos.ConsultarAliquotaUniao(aData: TDateTime; out aResponse: IACBrCalcAliquotaResponse): Boolean;
begin
  Result := False;
  if EstaZerado(aData) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['Data']));

  if not Assigned(fOwner) then
    Exit;

  fOwner.PrepararHTTP;
  fOwner.URLQueryParams.Values['data'] := FormatDateBr(aData, 'YYYY-MM-DD');
  fOwner.URLPathParams.Add(cACBrCalcEndpointCalculadora);
  fOwner.URLPathParams.Add(cACBrCalcEndpointDadosAbertos);
  fOwner.URLPathParams.Add(cACBrCalcEndpointAliqUniao);

  try
    fOwner.HTTPMethod(cHTTPMethodGET, fOwner.URL);
  except
    SetRespostaErro(fOwner.HTTPResponse);
    if RespostaErro.IsEmpty then
      raise;
  end;

  aResponse := TACBrCalcAliquotaResponse.Create;
  Result := (fOwner.HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(fOwner.HTTPResponse)
  else
    SetRespostaErro(fOwner.HTTPResponse);
end;

function TACBrCalcDadosAbertos.ConsultarAliquotaUF(aCodUF: Integer; aData: TDateTime; out aResponse: IACBrCalcAliquotaResponse): Boolean;
begin
  Result := False;
  if (aCodUF < 1) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['CodUF']));
  if EstaZerado(aData) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['Data']));

  if not Assigned(fOwner) then
    Exit;

  fOwner.PrepararHTTP;
  fOwner.URLQueryParams.Values['data'] := FormatDateBr(aData, 'YYYY-MM-DD');
  fOwner.URLQueryParams.Values['codigoUf'] := IntToStr(aCodUF);
  fOwner.URLPathParams.Add(cACBrCalcEndpointCalculadora);
  fOwner.URLPathParams.Add(cACBrCalcEndpointDadosAbertos);
  fOwner.URLPathParams.Add(cACBrCalcEndpointAliqUF);

  try
    fOwner.HTTPMethod(cHTTPMethodGET, fOwner.URL);
  except
    SetRespostaErro(fOwner.HTTPResponse);
    if RespostaErro.IsEmpty then
      raise;
  end;

  aResponse := TACBrCalcAliquotaResponse.Create;
  Result := (fOwner.HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(fOwner.HTTPResponse)
  else
    SetRespostaErro(fOwner.HTTPResponse);
end;

function TACBrCalcDadosAbertos.ConsultarAliquotaMunicipio(aCodMunicipio: Integer; aData: TDateTime; out aResponse: IACBrCalcAliquotaResponse): Boolean;
begin
  Result := False;
  if (aCodMunicipio < 1) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['CodMunicipio']));
  if EstaZerado(aData) then
    raise EACBrAPIException.Create(Format(sErroParametroNaoPrenchido, ['Data']));

  if not Assigned(fOwner) then
    Exit;

  fOwner.PrepararHTTP;
  fOwner.URLQueryParams.Values['data'] := FormatDateBr(aData, 'YYYY-MM-DD');
  fOwner.URLQueryParams.Values['codigoMunicipio'] := IntToStr(aCodMunicipio);
  fOwner.URLPathParams.Add(cACBrCalcEndpointCalculadora);
  fOwner.URLPathParams.Add(cACBrCalcEndpointDadosAbertos);
  fOwner.URLPathParams.Add(cACBrCalcEndpointAliqMun);

  try
    fOwner.HTTPMethod(cHTTPMethodGET, fOwner.URL);
  except
    SetRespostaErro(fOwner.HTTPResponse);
    if RespostaErro.IsEmpty then
      raise;
  end;

  aResponse := TACBrCalcAliquotaResponse.Create;
  Result := (fOwner.HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(fOwner.HTTPResponse)
  else
    SetRespostaErro(fOwner.HTTPResponse);
end;

{ TACBrCalculadoraConsumo }

function TACBrCalculadoraConsumo.GetRespostaErro: TACBrCalcErro;
begin
  if (not Assigned(fRespostaErro)) then
    fRespostaErro := TACBrCalcErro.Create;
  Result := fRespostaErro;
end;

function TACBrCalculadoraConsumo.GetGerarXMLRequest: TACBrCalcROC;
begin
  if (not Assigned(fGerarXMLRequest)) then
    fGerarXMLRequest := TACBrCalcROC.Create;
  Result := fGerarXMLRequest;
end;

function TACBrCalculadoraConsumo.GetRegimeGeralRequest: TACBrCalcOperacao;
begin
  if (not Assigned(fRegimeGeralRequest)) then
    fRegimeGeralRequest := TACBrCalcOperacao.Create;
  Result := fRegimeGeralRequest;
end;

function TACBrCalculadoraConsumo.GetURL: String;
begin
  Result := IfThen(EstaVazio(fURL), cACBrCalcURL, fURL);
end;

procedure TACBrCalculadoraConsumo.PrepararHTTP;
begin
  RespostaErro.Clear;
  RegistrarLog('PrepararHTTP', 3);
  LimparHTTP;
end;

constructor TACBrCalculadoraConsumo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TACBrCalculadoraConsumo.Destroy;
begin
  if Assigned(fBaseCalculo) then
    fBaseCalculo.Free;
  if Assigned(fDadosAbertos) then
    fDadosAbertos.Free;
  if Assigned(fRespostaErro) then
    fRespostaErro.Free;
  if Assigned(fGerarXMLRequest) then
    fGerarXMLRequest.Free;
  if Assigned(fRegimeGeralRequest) then
    fRegimeGeralRequest.Free;
  inherited Destroy;
end;

procedure TACBrCalculadoraConsumo.Clear;
begin
  if Assigned(fBaseCalculo) then
    fBaseCalculo.Clear;
  if Assigned(fDadosAbertos) then
    fDadosAbertos.Clear;
  if Assigned(fRespostaErro) then
    fRespostaErro.Clear;
  if Assigned(fGerarXMLRequest) then
    fGerarXMLRequest.Clear;
  if Assigned(fRegimeGeralRequest) then
    fRegimeGeralRequest.Clear;
end;

function TACBrCalculadoraConsumo.DadosAbertos: TACBrCalcDadosAbertos;
begin
  if (not Assigned(fDadosAbertos)) then
    fDadosAbertos := TACBrCalcDadosAbertos.Create(Self);
  Result := fDadosAbertos;
end;

function TACBrCalculadoraConsumo.BaseCalculo: TACBrCalcBaseCalculo;
begin
  if (not Assigned(fBaseCalculo)) then
    fBaseCalculo := TACBrCalcBaseCalculo.Create(Self);
  Result := fBaseCalculo;
end;

function TACBrCalculadoraConsumo.GerarXML(out aXMLResponse: AnsiString): Boolean;
begin
  Result := False;
  if GerarXMLRequest.IsEmpty then
    raise EACBrAPIException.Create(ACBrStr(Format(sErroObjetoNaoPrenchido, ['GerarXMLRequest'])));

  PrepararHTTP;
  WriteStrToStream(HTTPSend.Document, GerarXMLRequest.AsJSON);
  HTTPSend.MimeType := CContentTypeApplicationJSon;
  URLPathParams.Add(cACBrCalcEndpointCalculadora);
  URLPathParams.Add(cACBrCalcEndpointGerarXml);

  try
    HTTPMethod(cHTTPMethodPOST, URL);
  except
    RespostaErro.AsJSON := HTTPResponse;
    if RespostaErro.IsEmpty then
      raise;
  end;

  Result := (HTTPResultCode = HTTP_OK);
  if Result then
    aXMLResponse := HTTPResponse
  else
    RespostaErro.AsJSON := HTTPResponse;
end;

function TACBrCalculadoraConsumo.ValidarXML(const aTipo, aSubTipo: String; const aXML: AnsiString): Boolean;
begin
  Result := False;

  if EstaVazio(aTipo) or EstaVazio(aSubTipo) then
    raise EACBrAPIException.Create(ACBrStr(Format(sErroParametroNaoPrenchido, ['tipo/subtipo'])));

  PrepararHTTP;
  WriteStrToStream(HTTPSend.Document, aXML);
  HTTPSend.MimeType := cContentTypeApplicationXml;
  URLPathParams.Add(cACBrCalcEndpointCalculadora);
  URLPathParams.Add(cACBrCalcEndpointValidarXml);
  URLQueryParams.Values[cACBrCalcQueryParamTipo] := aTipo;
  URLQueryParams.Values[cACBrCalcQueryParamSubtipo] := aSubTipo;

  try
    HTTPMethod(cHTTPMethodPOST, URL);
  except
    RespostaErro.AsJSON := HTTPResponse;
    if RespostaErro.IsEmpty then
      raise;
  end;

  Result := (HTTPResultCode = HTTP_OK);
  if not Result then
    RespostaErro.AsJSON := HTTPResponse;
end;

function TACBrCalculadoraConsumo.RegimeGeral(out aResponse: IACBrCalcRegimeGeralResponse): Boolean;
begin
  Result := False;
  if RegimeGeralRequest.IsEmpty then
    raise EACBrAPIException.Create(ACBrStr(Format(sErroObjetoNaoPrenchido, ['RegimeGeralRequest'])));

  PrepararHTTP;
  aResponse := TACBrCalcRegimeGeralResponse.Create;
  WriteStrToStream(HTTPSend.Document, RegimeGeralRequest.AsJSON);
  HTTPSend.MimeType := CContentTypeApplicationJSon;
  URLPathParams.Add(cACBrCalcEndpointCalculadora);
  URLPathParams.Add(cACBrCalcEndpointRegimeGeral);

  try
    HTTPMethod(cHTTPMethodPOST, URL);
  except
    RespostaErro.AsJSON := HTTPResponse;
    if RespostaErro.IsEmpty then
      raise;
  end;

  Result := (HTTPResultCode = HTTP_OK);
  if Result then
    aResponse.LoadJson(HTTPResponse)
  else
    RespostaErro.AsJSON := HTTPResponse;
end;

end. 
