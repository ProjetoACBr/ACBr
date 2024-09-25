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

unit ACBrDCe.XmlWriter;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrXmlWriter,
  ACBrDCe.Classes,
  ACBrDCe.Conversao;

type

  TDCeXmlWriterOptions = class(TACBrXmlWriterOptions)
  private
    FAjustarTagNro: boolean;
    FGerarTagIPIparaNaoTributado: boolean;
    FNormatizarMunicipios: boolean;
    FGerarTagAssinatura: TACBrTagAssinatura;
    FPathArquivoMunicipios: string;
    FValidarInscricoes: boolean;
    FValidarListaServicos: boolean;

  published
    property AjustarTagNro: boolean read FAjustarTagNro write FAjustarTagNro;
    property GerarTagIPIparaNaoTributado: boolean read FGerarTagIPIparaNaoTributado write FGerarTagIPIparaNaoTributado;
    property NormatizarMunicipios: boolean read FNormatizarMunicipios write FNormatizarMunicipios;
    property GerarTagAssinatura: TACBrTagAssinatura read FGerarTagAssinatura write FGerarTagAssinatura;
    property PathArquivoMunicipios: string read FPathArquivoMunicipios write FPathArquivoMunicipios;
    property ValidarInscricoes: boolean read FValidarInscricoes write FValidarInscricoes;
    property ValidarListaServicos: boolean read FValidarListaServicos write FValidarListaServicos;

  end;

  TDCeXmlWriter = class(TACBrXmlWriter)
  private
    FDCe: TDCe;

    FVersaoDF: TVersaoDCe;
    FModeloDF: Integer;
    FtpAmb: TACBrTipoAmbiente;
    FtpEmis: TACBrTipoEmissao;

    function Gerar_InfDCe: TACBrXmlNode;
    function Gerar_Ide: TACBrXmlNode;
    function Gerar_Emit: TACBrXmlNode;
    function Gerar_EnderEmit: TACBrXmlNode;
    function Gerar_Fisco: TACBrXmlNode;
    function Gerar_Marketplace: TACBrXmlNode;
    function Gerar_Transportadora: TACBrXmlNode;
    function Gerar_EmpEmisProp: TACBrXmlNode;
    function Gerar_Dest: TACBrXmlNode;
    function Gerar_EnderDest: TACBrXmlNode;
    function Gerar_autXML: TACBrXmlNodeArray;
    function Gerar_Det: TACBrXmlNodeArray;
    function Gerar_DetProd(const i: Integer): TACBrXmlNode;
    function Gerar_Total: TACBrXmlNode;
    function Gerar_Transp: TACBrXmlNode;
    function Gerar_InfAdic: TACBrXmlNode;
    function Gerar_ObsCont: TACBrXmlNodeArray;
    function Gerar_ObsMarketplace: TACBrXmlNodeArray;
    function Gerar_InfDec: TACBrXmlNode;
    {
    function GerarProtDCe: TACBrXmlNode;
    }
    function GetOpcoes: TDCeXmlWriterOptions;
    procedure SetOpcoes(AValue: TDCeXmlWriterOptions);

    procedure AjustarMunicipioUF(out xUF: string; out xMun: string;
      out cMun: integer; cPais: integer; const vxUF, vxMun: string; vcMun: integer);

    function GerarChaveAcesso(AUF: Integer; ADataEmissao: TDateTime;
      const ACNPJ:String; ASerie, ANumero, AtpEmi, ATipoEmit, AnSiteAut,
      ACodigo: Integer; AModelo: Integer = 99): String;
  protected
    function CreateOptions: TACBrXmlWriterOptions; override;

  public
    constructor Create(AOwner: TDCe); reintroduce;
    destructor Destroy; override;

    function GerarXml: boolean; override;
    function ObterNomeArquivo: string; overload;

    property Opcoes: TDCeXmlWriterOptions read GetOpcoes write SetOpcoes;
    property DCe: TDCe read FDCe write FDCe;

    property VersaoDF: TVersaoDCe read FVersaoDF write FVersaoDF;
    property ModeloDF: Integer read FModeloDF write FModeloDF;
    property tpAmb: TACBrTipoAmbiente read FtpAmb write FtpAmb;
    property tpEmis: TACBrTipoEmissao read FtpEmis write FtpEmis;
  end;

implementation

uses
  StrUtils,
  Math,
  ACBrValidador,
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrUtil.DateTime,
  ACBrDFeUtil,
  ACBrDFeConsts,
  ACBrDCe,
  ACBrDCe.Consts;

{ TDCeXmlWriter }

constructor TDCeXmlWriter.Create(AOwner: TDCe);
begin
  inherited Create;

  Opcoes.AjustarTagNro := True;
  Opcoes.GerarTagIPIparaNaoTributado := True;
  Opcoes.NormatizarMunicipios := False;
  Opcoes.PathArquivoMunicipios := '';
  Opcoes.GerarTagAssinatura := taSomenteSeAssinada;
  Opcoes.ValidarInscricoes := False;
  Opcoes.ValidarListaServicos := False;

  FDCe := AOwner;
end;

function TDCeXmlWriter.CreateOptions: TACBrXmlWriterOptions;
begin
  Result := TDCeXmlWriterOptions.Create();
end;

destructor TDCeXmlWriter.Destroy;
begin
  inherited Destroy;
end;

function TDCeXmlWriter.GetOpcoes: TDCeXmlWriterOptions;
begin
  Result := TDCeXmlWriterOptions(FOpcoes);
end;

function TDCeXmlWriter.ObterNomeArquivo: string;
begin
  Result := OnlyNumber(FDCe.infDCe.ID) + '-dce.xml';
end;

procedure TDCeXmlWriter.SetOpcoes(AValue: TDCeXmlWriterOptions);
begin
  FOpcoes := AValue;
end;

procedure TDCeXmlWriter.AjustarMunicipioUF(out xUF: string; out xMun: string;
  out cMun: integer; cPais: integer; const vxUF, vxMun: string; vcMun: integer);
var
  PaisBrasil: boolean;
begin
  PaisBrasil := cPais = CODIGO_BRASIL;

  cMun := IfThen(PaisBrasil, vcMun, CMUN_EXTERIOR);
  xMun := IfThen(PaisBrasil, vxMun, XMUN_EXTERIOR);
  xUF  := IfThen(PaisBrasil, vxUF, UF_EXTERIOR);

  if Opcoes.NormatizarMunicipios then
    if ((EstaZerado(cMun)) and (xMun <> XMUN_EXTERIOR)) then
      cMun := ObterCodigoMunicipio(xMun, xUF, Opcoes.FPathArquivoMunicipios)
    else if ( ( EstaVazio(xMun)) and (cMun <> CMUN_EXTERIOR) ) then
      xMun := ObterNomeMunicipio(cMun, xUF, Opcoes.FPathArquivoMunicipios);
end;

function TDCeXmlWriter.GerarChaveAcesso(AUF: Integer; ADataEmissao: TDateTime;
  const ACNPJ: String; ASerie, ANumero, AtpEmi, ATipoEmit, AnSiteAut, ACodigo,
  AModelo: Integer): String;
var
  vUF, vDataEmissao, vSerie, vNumero, vCodigo, vModelo, vCNPJ, vtpEmi,
  vTipoEmit, vnSiteAut: String;
begin
  // Se o usuario informar 0 ou -1; o c�digo numerico sera gerado de maneira aleat�ria //
  if ACodigo = -1 then
    ACodigo := 0;

  if ACodigo = 0 then
    ACodigo := GerarCodigoDFe(ANumero);

  // Se o usuario informar um c�digo inferior ou igual a -2 a chave ser� gerada
  // com o c�digo igual a zero, mas poder� n�o ser autorizada pela SEFAZ.
  if ACodigo <= -2 then
    ACodigo := 0;

  vUF          := Poem_Zeros(AUF, 2);
  vDataEmissao := FormatDateTime('YYMM', ADataEmissao);
  vCNPJ        := PadLeft(OnlyNumber(ACNPJ), 14, '0');
  vModelo      := Poem_Zeros(AModelo, 2);
  vSerie       := Poem_Zeros(ASerie, 3);
  vNumero      := Poem_Zeros(ANumero, 9);
  vtpEmi       := Poem_Zeros(AtpEmi, 1);
  vTipoEmit    := Poem_Zeros(ATipoEmit, 1);
  vnSiteAut    := Poem_Zeros(AnSiteAut, 1);
  vCodigo      := Poem_Zeros(ACodigo, 6);

  Result := vUF + vDataEmissao + vCNPJ + vModelo + vSerie + vNumero + vtpEmi +
            vTipoEmit + vnSiteAut + vCodigo;
  Result := Result + Modulo11(Result);
end;

function TDCeXmlWriter.Gerar_InfDCe: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: integer;
begin
  Result := FDocument.CreateElement('infDCe');

  Result.SetAttribute('Id', DCe.infDCe.ID);
  Result.SetAttribute('versao', FloatToString(DCe.infDCe.Versao, '.', '#0.00'));

  Result.AppendChild(Gerar_Ide);
  Result.AppendChild(Gerar_Emit);

  Result.AppendChild(Gerar_Fisco);
  Result.AppendChild(Gerar_Marketplace);
  Result.AppendChild(Gerar_Transportadora);
  Result.AppendChild(Gerar_EmpEmisProp);

  Result.AppendChild(Gerar_Dest);

  nodeArray := Gerar_autXML;

  for i := 0 to DCe.autXML.Count - 1 do
  begin
    Result.AppendChild(nodeArray[i]);
  end;

  nodeArray := Gerar_Det;

  for i := 0 to DCe.Det.Count - 1 do
  begin
    Result.AppendChild(nodeArray[i]);
  end;

  Result.AppendChild(Gerar_Total);
  Result.AppendChild(Gerar_Transp);
  Result.AppendChild(Gerar_InfAdic);

  nodeArray := Gerar_ObsCont;

  for i := 0 to DCe.obsCont.Count - 1 do
  begin
    Result.AppendChild(nodeArray[i]);
  end;

  nodeArray := Gerar_ObsMarketplace;
  for i := 0 to DCe.obsMarketplace.Count - 1 do
  begin
    Result.AppendChild(nodeArray[i]);
  end;

  Result.AppendChild(Gerar_InfDec);
end;

function TDCeXmlWriter.Gerar_Ide: TACBrXmlNode;
begin
  Result := FDocument.CreateElement('ide');

  Result.AppendChild(AddNode(tcInt, 'B02', 'cUF', 2, 2, 1, DCe.ide.cUF, DSC_CUF));

  if not ValidarCodigoUF(DCe.ide.cUF) then
    wAlerta('B02', 'cUF', DSC_CUF, ERR_MSG_INVALIDO);

  Result.AppendChild(AddNode(tcInt, 'B03', 'cDC', 6, 6, 1,
                                                         DCe.Ide.cDC, DSC_CDF));

  Result.AppendChild(AddNode(tcInt, 'B04', 'mod', 2, 2, 1, DCe.Ide.modelo, ''));

  Result.AppendChild(AddNode(tcInt, 'B05', 'serie', 1, 3, 1,
                                                     DCe.ide.serie, DSC_SERIE));

  Result.AppendChild(AddNode(tcInt, 'B06', 'nDC', 1, 9, 1, DCe.ide.nDC, DSC_NDF));

  Result.AppendChild(AddNode(tcStr, 'B07', 'dhEmi', 25, 25, 1,
      DateTimeTodh(DCe.ide.dhEmi) +
      GetUTC(CodigoUFparaUF(DCe.ide.cUF), DCe.ide.dhEmi), DSC_DEMI));

  Result.AppendChild(AddNode(tcStr, 'B08', 'tpEmis', 1, 1, 1,
                                 TipoEmissaoToStr(DCe.Ide.tpEmis), DSC_TPEMIS));

  Result.AppendChild(AddNode(tcStr, 'B09', 'tpEmit', 1, 1, 1,
                                 EmitenteDCeToStr(DCe.Ide.tpEmit), DSC_TPEMIT));

  Result.AppendChild(AddNode(tcInt, 'B10', 'nSiteAutoriz', 1, 1, 1,
                                                DCe.ide.nSiteAutoriz, DSC_NDF));

  Result.AppendChild(AddNode(tcInt, 'B11', 'cDV', 1, 1, 1, DCe.Ide.cDV, DSC_CDV));

  Result.AppendChild(AddNode(tcStr, 'B12', 'tpAmb', 1, 1, 1,
                                  TipoAmbienteToStr(DCe.Ide.tpAmb), DSC_TPAMB));

  Result.AppendChild(AddNode(tcStr, 'B13', 'verProc', 1, 20, 1,
                                                 DCe.Ide.verProc, DSC_VERPROC));
end;

function TDCeXmlWriter.Gerar_Emit: TACBrXmlNode;
begin
  Result := FDocument.CreateElement('emit');

  if DCe.emit.idOutros = '' then
    Result.AppendChild(AddNodeCNPJCPF('C02', 'C02a', DCe.Emit.CNPJCPF))
  else
    Result.AppendChild(AddNode(tcStr, 'C02b', 'idOutros', 2, 60, 1,
                                                 DCe.Emit.idOutros, DSC_XNOME));

  Result.AppendChild(AddNode(tcStr, 'C03', 'xNome', 2, 60, 1,
                                                    DCe.Emit.xNome, DSC_XNOME));

  Result.AppendChild(Gerar_EnderEmit);
end;

function TDCeXmlWriter.Gerar_EnderEmit: TACBrXmlNode;
var
  cMun: integer;
  xMun: string;
  xUF: string;
begin
  AjustarMunicipioUF(xUF, xMun, cMun, CODIGO_BRASIL, DCe.Emit.enderEmit.UF,
    DCe.Emit.enderEmit.xMun, DCe.Emit.EnderEmit.cMun);

  Result := FDocument.CreateElement('enderEmit');

  Result.AppendChild(AddNode(tcStr, 'C05', 'xLgr', 2, 60, 1,
                                            DCe.Emit.enderEmit.xLgr, DSC_XLGR));

  Result.AppendChild(AddNode(tcStr, 'C06', 'nro', 1, 60, 1,
    ExecutarAjusteTagNro(Opcoes.FAjustarTagNro, DCe.Emit.enderEmit.nro), DSC_NRO));

  Result.AppendChild(AddNode(tcStr, 'C07', 'xCpl', 1, 60, 0,
                                            DCe.Emit.enderEmit.xCpl, DSC_XCPL));

  Result.AppendChild(AddNode(tcStr, 'C08', 'xBairro', 2, 60, 1,
                                      DCe.Emit.enderEmit.xBairro, DSC_XBAIRRO));

  Result.AppendChild(AddNode(tcInt, 'C09', 'cMun', 7, 7, 1, cMun, DSC_CMUN));

  if not ValidarMunicipio(cMun) then
    wAlerta('C09', 'cMun', DSC_CMUN, ERR_MSG_INVALIDO);

  Result.AppendChild(AddNode(tcStr, 'C10', 'xMun', 2, 60, 1, xMun, DSC_XMUN));

  Result.AppendChild(AddNode(tcStr, 'C11', 'UF', 2, 2, 1, xUF, DSC_UF));

  if not ValidarUF(xUF) then
    wAlerta('C11', 'UF', DSC_UF, ERR_MSG_INVALIDO);

  Result.AppendChild(AddNode(tcInt, 'C12', 'CEP', 8, 8, 1,
                                              DCe.Emit.enderEmit.CEP, DSC_CEP));

  Result.AppendChild(AddNode(tcInt, 'C13', 'cPais', 4, 4, 0,
                                                     CODIGO_BRASIL, DSC_CPAIS));

  if DCe.Emit.enderEmit.xPais = '' then
    DCe.Emit.enderEmit.xPais := 'BRASIL';

  Result.AppendChild(AddNode(tcStr, 'C14', 'xPais', 1, 60, 1,
                                          DCe.Emit.enderEmit.xPais, DSC_XPAIS));

  Result.AppendChild(AddNode(tcStr, 'C15', 'fone', 6, 14, 0,
                                OnlyNumber(DCe.Emit.enderEmit.fone), DSC_FONE));
end;

function TDCeXmlWriter.Gerar_Fisco: TACBrXmlNode;
begin
  Result := nil;

  if DCe.Fisco.CNPJ <> '' then
  begin
    Result := FDocument.CreateElement('Fisco');

    Result.AppendChild(AddNode(tcStr, 'D02', 'CNPJ', 14, 14, 1,
                                                     DCe.Fisco.CNPJ, DSC_CNPJ));

    Result.AppendChild(AddNode(tcStr, 'D03', 'xOrgao', 1, 60, 1,
                                                  DCe.Fisco.xOrgao, DSC_XNOME));

    Result.AppendChild(AddNode(tcStr, 'D07', 'UF', 2, 2, 1,
                                                         DCe.Fisco.UF, DSC_UF));
  end;
end;

function TDCeXmlWriter.Gerar_Marketplace: TACBrXmlNode;
begin
  Result := nil;

  if DCe.Marketplace.CNPJ <> '' then
  begin
    Result := FDocument.CreateElement('Marketplace');

    Result.AppendChild(AddNode(tcStr, 'D09', 'CNPJ', 14, 14, 1,
                                               DCe.Marketplace.CNPJ, DSC_CNPJ));

    Result.AppendChild(AddNode(tcStr, 'D10', 'xNome', 1, 60, 1,
                                             DCe.Marketplace.xNome, DSC_XNOME));

    Result.AppendChild(AddNode(tcStr, 'D11', 'Site', 1, 120, 1,
                                                 DCe.Marketplace.Site, DSC_UF));
  end;
end;

function TDCeXmlWriter.Gerar_Transportadora: TACBrXmlNode;
begin
  Result := nil;

  if DCe.Transportadora.CNPJ <> '' then
  begin
    Result := FDocument.CreateElement('Transportadora');

    Result.AppendChild(AddNode(tcStr, 'D13', 'CNPJ', 14, 14, 1,
                                               DCe.Transportadora.CNPJ, DSC_CNPJ));

    Result.AppendChild(AddNode(tcStr, 'D14', 'xNome', 1, 60, 1,
                                             DCe.Transportadora.xNome, DSC_XNOME));
  end;
end;

function TDCeXmlWriter.Gerar_EmpEmisProp: TACBrXmlNode;
begin
  Result := nil;

  if DCe.EmpEmisProp.CNPJ <> '' then
  begin
    Result := FDocument.CreateElement('EmpEmisProp');

    Result.AppendChild(AddNode(tcStr, 'D16', 'CNPJ', 14, 14, 1,
                                               DCe.EmpEmisProp.CNPJ, DSC_CNPJ));

    Result.AppendChild(AddNode(tcStr, 'D17', 'xNome', 1, 60, 1,
                                             DCe.EmpEmisProp.xNome, DSC_XNOME));
  end;
end;

function TDCeXmlWriter.Gerar_Dest: TACBrXmlNode;
const
  HOM_NOME_DEST = 'DCE EMITIDA EM AMBIENTE DE HOMOLOGACAO';
begin
  Result := FDocument.CreateElement('dest');

  if DCe.dest.idOutros = '' then
    Result.AppendChild(AddNodeCNPJCPF('E02', 'E03', DCe.dest.CNPJCPF))
  else
    Result.AppendChild(AddNode(tcStr, 'E03a', 'idOutros', 2, 60, 1,
                                                 DCe.dest.idOutros, DSC_XNOME));

  if DCe.Ide.tpAmb = taProducao then
    Result.AppendChild(AddNode(tcStr, 'E04', 'xNome', 2, 60, 1,
                                                     DCe.dest.xNome, DSC_XNOME))
  else
    Result.AppendChild(AddNode(tcStr, 'E04', 'xNome', 2, 60, 1,
                                                     HOM_NOME_DEST, DSC_XNOME));

  Result.AppendChild(Gerar_EnderDest);
end;

function TDCeXmlWriter.Gerar_EnderDest: TACBrXmlNode;
var
  cMun: integer;
  xMun: string;
  xUF: string;
begin
  AjustarMunicipioUF(xUF, xMun, cMun, DCe.Dest.enderDest.cPais,
       DCe.Dest.enderDest.UF, DCe.Dest.enderDest.xMun, DCe.Dest.enderDest.cMun);

  Result := FDocument.CreateElement('enderDest');

  Result.AppendChild(AddNode(tcStr, 'E06', 'xLgr', 2, 60, 1,
                                            DCe.dest.enderDest.xLgr, DSC_XLGR));

  Result.AppendChild(AddNode(tcStr, 'E07', 'nro', 1, 60, 1,
    ExecutarAjusteTagNro(Opcoes.FAjustarTagNro, DCe.dest.enderDest.nro), DSC_NRO));

  Result.AppendChild(AddNode(tcStr, 'E08', 'xCpl', 1, 60, 0,
                                            DCe.dest.enderDest.xCpl, DSC_XCPL));

  Result.AppendChild(AddNode(tcStr, 'E09', 'xBairro', 2, 60, 1,
                                      DCe.dest.enderDest.xBairro, DSC_XBAIRRO));

  Result.AppendChild(AddNode(tcInt, 'E10', 'cMun', 7, 7, 1, cMun, DSC_CMUN));

  if not ValidarMunicipio(cMun) then
    wAlerta('E10', 'cMun', DSC_CMUN, ERR_MSG_INVALIDO);

  Result.AppendChild(AddNode(tcStr, 'E11', 'xMun', 2, 60, 1, xMun, DSC_XMUN));

  Result.AppendChild(AddNode(tcStr, 'E12', 'UF', 2, 2, 1, xUF, DSC_UF));

  if not ValidarUF(xUF) then
    wAlerta('E12', 'UF', DSC_UF, ERR_MSG_INVALIDO);

  Result.AppendChild(AddNode(tcInt, 'E13', 'CEP', 8, 8, 1,
                                              DCe.dest.enderDest.CEP, DSC_CEP));

  Result.AppendChild(AddNode(tcInt, 'E14', 'cPais', 4, 4, 0,
                                          DCe.dest.enderDest.cPais, DSC_CPAIS));

  if DCe.Dest.enderDest.cPais > 0 then
    if ValidarCodigoPais(DCe.Dest.enderDest.cPais) <> 1 then
      wAlerta('E14', 'cPais', DSC_CPAIS, ERR_MSG_INVALIDO);

  Result.AppendChild(AddNode(tcStr, 'E15', 'xPais', 1, 60, 0,
                                          DCe.dest.enderDest.xPais, DSC_XPAIS));

  Result.AppendChild(AddNode(tcStr, 'E16', 'fone', 6, 14, 0,
                                OnlyNumber(DCe.dest.enderDest.fone), DSC_FONE));

  Result.AppendChild(AddNode(tcStr, 'E19', 'email', 1, 60, 0,
                              OnlyNumber(DCe.dest.enderDest.email), DSC_EMAIL));
end;

function TDCeXmlWriter.Gerar_autXML: TACBrXmlNodeArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, DCe.autXML.Count);

  for i := 0 to DCe.autXML.Count - 1 do
  begin
    Result[i] := FDocument.CreateElement('autXML');
    Result[i].AppendChild(AddNodeCNPJCPF('F02', 'F03', DCe.autXML[i].CNPJCPF));
  end;

  if DCe.autXML.Count > 10 then
    wAlerta('F01', 'autXML', '', ERR_MSG_MAIOR_MAXIMO + '10');
end;

function TDCeXmlWriter.Gerar_Det: TACBrXmlNodeArray;
var
  i: integer;
begin
  SetLength(Result, DCe.Det.Count);

  for i := 0 to DCe.Det.Count - 1 do
  begin
    Result[i] := FDocument.CreateElement('det');
    Result[i].SetAttribute('nItem', IntToStr(DCe.Det[i].Prod.nItem));

    Result[i].AppendChild(Gerar_DetProd(i));

    Result[i].AppendChild(AddNode(tcStr, 'V01', 'infAdProd', 01, 500, 0,
                                          DCe.Det[i].infAdProd, DSC_INFADPROD));
  end;

  if DCe.Det.Count > 999 then
    wAlerta('H02', 'nItem', DSC_NITEM, ERR_MSG_MAIOR_MAXIMO + '999');
end;

function TDCeXmlWriter.Gerar_DetProd(const i: Integer): TACBrXmlNode;
const
  HOM_XPROD = 'DECLARACAO EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL';
begin
  Result := FDocument.CreateElement('prod');

  if (DCe.Det[i].Prod.nItem = 1) and (TACBrTipoAmbiente(DCe.Ide.tpAmb) = taHomologacao) then
    Result.AppendChild(AddNode(tcStr, 'I02', 'xProd', 1, 120, 1,
                                                          HOM_XPROD, DSC_XPROD))
  else
    Result.AppendChild(AddNode(tcStr, 'I02', 'xProd', 1, 120, 1,
                                             DCe.Det[i].Prod.xProd, DSC_XPROD));

  Result.AppendChild(AddNode(tcStr, 'I03', 'NCM', 2, 8, 1,
                                                 DCe.Det[i].Prod.NCM, DSC_NCM));

  Result.AppendChild(AddNode(tcDe4, 'I04', 'qCom', 0, 15, 1,
                                               DCe.Det[i].Prod.qCom, DSC_QCOM));

  Result.AppendChild(AddNode(tcDe8, 'I05', 'vUnCom', 0, 21, 1,
                                           DCe.Det[i].Prod.vUnCom, DSC_VUNCOM));

  Result.AppendChild(AddNode(tcDe2, 'I06 ', 'vProd', 0, 15, 1,
                                             DCe.Det[i].Prod.vProd, DSC_VPROD));
end;

function TDCeXmlWriter.Gerar_Total: TACBrXmlNode;
begin
  Result := FDocument.CreateElement('total');

  Result.AppendChild(AddNode(tcDe2, 'W16', 'vDC', 1, 15, 1,
                                               DCe.Total.vDC, DSC_VDF));
end;

function TDCeXmlWriter.Gerar_Transp: TACBrXmlNode;
begin
  Result := FDocument.CreateElement('transp');

  Result.AppendChild(AddNode(tcStr, 'X02', 'modTrans', 1, 1, 1,
                                       ModTransToStr(DCe.Transp.modTrans), ''));

  Result.AppendChild(AddNode(tcStr, 'X03','CNPJTransp', 14, 14, 0,
                                               DCe.Transp.CNPJTrans, DSC_CNPJ));
end;

function TDCeXmlWriter.Gerar_InfAdic: TACBrXmlNode;
begin
  Result := nil;

  if (trim(DCe.InfAdic.infAdFisco) <> '') or
     (trim(DCe.InfAdic.infCpl) <> '') or
     (trim(DCe.InfAdic.infadMarketplace) <> '') or
     (trim(DCe.InfAdic.infadTransp) <> '') then
  begin
    Result := FDocument.CreateElement('infAdic');

    Result.AppendChild(AddNode(tcStr, 'Z02', 'infAdFisco', 01, 5000, 0,
                                       DCe.InfAdic.infAdFisco, DSC_INFADFISCO));

    Result.AppendChild(AddNode(tcStr, 'Z03', 'infCpl', 01, 5000, 0,
                                               DCe.InfAdic.infCpl, DSC_INFCPL));

    Result.AppendChild(AddNode(tcStr, 'Z04', 'infAdMarketplace', 01, 5000, 0,
                                     DCe.InfAdic.infadMarketplace, DSC_INFCPL));

    Result.AppendChild(AddNode(tcStr, 'Z04a', 'infAdTransp', 01, 5000, 0,
                                          DCe.InfAdic.infadTransp, DSC_INFCPL));
  end;
end;

function TDCeXmlWriter.Gerar_ObsCont: TACBrXmlNodeArray;
var
  i: Integer;
begin
  Result := nil;
  SetLength(Result, DCe.obsCont.Count);

  for i := 0 to DCe.obsCont.Count - 1 do
  begin
    Result[i] := FDocument.CreateElement('obsCont');

    Result[i].SetAttribute('xCampo', DCe.obsCont[i].xCampo);

    if length(trim(DCe.obsCont[i].xCampo)) > 20 then
      wAlerta('Z06', 'xCampo', DSC_XCAMPO, ERR_MSG_MAIOR);

    if length(trim(DCe.obsCont[i].xCampo)) = 0 then
      wAlerta('Z06', 'xCampo', DSC_XCAMPO, ERR_MSG_VAZIO);

    Result[i].AppendChild(AddNode(tcStr, 'Z06', 'xTexto', 01, 60, 1,
                                    DCe.obsCont[i].xTexto, DSC_XTEXTO));
  end;

  if DCe.obsCont.Count > 10 then
    wAlerta('Z05', 'obsCont', DSC_OBSCONT, ERR_MSG_MAIOR_MAXIMO + '10');
end;

function TDCeXmlWriter.Gerar_ObsMarketplace: TACBrXmlNodeArray;
var
  i: Integer;
begin
  Result := nil;
  SetLength(Result, DCe.obsMarketplace.Count);

  for i := 0 to DCe.obsMarketplace.Count - 1 do
  begin
    Result[i] := FDocument.CreateElement('obsMarketplace');

    Result[i].SetAttribute('xCampo', DCe.obsMarketplace[i].xCampo);

    if length(trim(DCe.obsMarketplace[i].xCampo)) > 20 then
      wAlerta('Z08', 'xCampo', DSC_XCAMPO, ERR_MSG_MAIOR);

    if length(trim(DCe.obsMarketplace[i].xCampo)) = 0 then
      wAlerta('Z08', 'xCampo', DSC_XCAMPO, ERR_MSG_VAZIO);

    Result[i].AppendChild(AddNode(tcStr, 'Z09', 'xTexto', 01, 60, 1,
                                    DCe.obsMarketplace[i].xTexto, DSC_XTEXTO));
  end;

  if DCe.obsMarketplace.Count > 10 then
    wAlerta('Z07', 'obsMarketplace', DSC_OBSCONT, ERR_MSG_MAIOR_MAXIMO + '10');
end;

function TDCeXmlWriter.Gerar_InfDec: TACBrXmlNode;
var
  xObs1, xObs2: string;
begin
  xObs1 := '� contribuinte de ICMS qualquer pessoa ' +
           'f�sica ou jur�dica, que realize, com habitualidade ou em volume ' +
           'que caracterize intuito comercial, opera��es de circula��o de ' +
           'mercadoria ou presta��es de servi�os de transportes interestadual e ' +
           'intermunicipal e de comunica��o, ainda que as opera��es e ' +
           'presta��es de iniciem no exterior (Lei Complementar n. 87/96, Art. 4�)';

  xObs2 := 'Constitui crime contra a ordem ' +
           'tribut�ria suprimir ou reduzir tributo, ou contribui��o social ' +
           'e qualquer acess�rio: quando negar ou deixar de fornecer, ' +
           'quando obrigat�rio, nota fiscal ou documento equivalente, ' +
           'relativa a venda de mercadoria ou presta��o de servi�o, ' +
           'efetivamente realizada ou fornece-la em desacordo com a ' +
           'legisla��o. Sob pena de reclus�o de 2 (dois) e 5 (cinco) anos, e ' +
           'multa (Lei 8.137/90, Art 1a, V)';

  Result := FDocument.CreateElement('infDec');

  Result.AppendChild(AddNode(tcStr, 'ZA02', 'xObs1', 1, 2000, 1, xObs1, ''));

  Result.AppendChild(AddNode(tcStr, 'ZA03', 'xObs2', 1, 2000, 1, xObs2, ''));
end;

function TDCeXmlWriter.GerarXml: boolean;
var
  Gerar: boolean;
  ChaveDCe, xCNPJCPF: string;
  DCeNode, xmlNode: TACBrXmlNode;
begin
  Result := False;

  ListaDeAlertas.Clear;

  {
    Os campos abaixo tem que ser os mesmos da configura��o
  }
  DCe.Ide.modelo := ModeloDF;
  DCe.infDCe.Versao := VersaoDCeToDbl(VersaoDF);
  DCe.Ide.tpAmb := tpAmb;
//  DCe.ide.tpEmis := tpEmis;

  case DCe.Ide.tpEmit of
    teFisco:
      xCNPJCPF := DCe.Fisco.CNPJ;

    teMarketplace:
      xCNPJCPF := DCe.Marketplace.CNPJ;

    teEmissorProprio:
      xCNPJCPF := DCe.EmpEmisProp.CNPJ;

  else
    xCNPJCPF := DCe.Transportadora.CNPJ;
  end;

  DCe.Ide.modelo := 99;

  ChaveDCe := GerarChaveAcesso(DCe.ide.cUF, DCe.ide.dhEmi, xCNPJCPF,
      DCe.ide.serie, DCe.ide.nDC, StrToInt(TipoEmissaoToStr(DCe.ide.tpEmis)),
      StrToInt(EmitenteDCeToStr(DCe.Ide.tpEmit)), DCe.Ide.nSiteAutoriz,
      DCe.ide.cDC, DCe.Ide.modelo);

  DCe.infDCe.ID := 'DCe' + ChaveDCe;
  DCe.ide.cDV := ExtrairDigitoChaveAcesso(DCe.infDCe.ID);

  FDocument.Clear();
  DCeNode := FDocument.CreateElement('DCe', ACBRDCE_NAMESPACE);

  if DCe.procDCe.nProt <> '' then
  begin
    xmlNode := FDocument.CreateElement('DCeProc', ACBRDCE_NAMESPACE);
    xmlNode.SetAttribute('versao', FloatToString(DCe.infDCe.Versao, '.', '#0.00'));
    xmlNode.AppendChild(DCeNode);
    FDocument.Root := xmlNode;
  end
  else
    FDocument.Root := DCeNode;

  xmlNode := Gerar_InfDCe;
  DCeNode.AppendChild(xmlNode);

  if DCe.infDCeSupl.qrCode <> '' then
  begin
    xmlNode := DCeNode.AddChild('infDCeSupl');
    xmlNode.AppendChild(AddNode(tcStr, 'ZX02', 'qrCodDCe', 100, 600, 1,
                       '<![CDATA[' + DCe.infDCeSupl.qrCode + ']]>', '', False));

    xmlNode.AppendChild(AddNode(tcStr, 'ZX03', 'urlChave', 21,85, 1,
                                           DCe.infDCeSupl.urlChave, '', False));
  end;

  Gerar := (Opcoes.GerarTagAssinatura = taSempre) or
    (
      (Opcoes.GerarTagAssinatura = taSomenteSeAssinada) and
        (DCe.signature.DigestValue <> '') and
        (DCe.signature.SignatureValue <> '') and
        (DCe.signature.X509Certificate <> '')
    ) or
    (
      (Opcoes.GerarTagAssinatura = taSomenteParaNaoAssinada) and
        (DCe.signature.DigestValue = '') and
        (DCe.signature.SignatureValue = '') and
        (DCe.signature.X509Certificate = '')
    );

  if Gerar then
  begin
    FDCe.signature.URI := '#DCe' + OnlyNumber(DCe.infDCe.ID);
    xmlNode := GerarSignature(FDCe.signature);
    DCeNode.AppendChild(xmlNode);
  end;

  if DCe.procDCe.nProt <> '' then
  begin
//    xmlNode := GerarProtDCe;
    FDocument.Root.AppendChild(xmlNode);
  end;
end;

end.
