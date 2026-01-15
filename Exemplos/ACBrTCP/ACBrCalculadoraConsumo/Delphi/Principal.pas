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
{                                                                              }
{  Algumas funçoes dessa Unit foram extraidas de outras Bibliotecas, veja no   }
{ cabeçalho das Funçoes no código abaixo a origem das informaçoes, e autores...}
{                                                                              }
{******************************************************************************}

{$I ACBr.inc}

unit Principal;

interface

uses
  Classes, Windows, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtDlgs, ExtCtrls, Buttons, StdCtrls, Spin, Grids,
  {$IfDef FPC}DateTimePicker,{$EndIf}
  ACBrCalculadoraConsumo, ImgList, ACBrBase, ACBrSocket;

const
  CURL_ACBR = 'https://projetoacbr.com.br/tef/';

type

  { TfrPrincipal }

  TfrPrincipal = class(TForm)
    ACBrCalculadoraConsumo1: TACBrCalculadoraConsumo;
    btBaseCalculoCIBS: TBitBtn;
    btBaseCalculoIS: TBitBtn;
    btConfigLerParametros: TBitBtn;
    btConfigLogArquivo: TSpeedButton;
    btConfigProxySenha: TSpeedButton;
    btConfigAuthPass: TSpeedButton;
    btConfigSalvar: TBitBtn;
    btDadosAbertosAliquotaMun: TBitBtn;
    btDadosAbertosAliquotaUF: TBitBtn;
    btDadosAbertosAliquotaUniao: TBitBtn;
    btDadosAbertosClassifIdSTConsultar: TBitBtn;
    btDadosAbertosClassifImpostoSeletivo: TBitBtn;
    btDadosAbertosClassifCbsIbs: TBitBtn;
    btDadosAbertosMunicipiosConsultar: TBitBtn;
    btDadosAbertosFundConsultar: TBitBtn;
    btDadosAbertosNBSConsultar: TBitBtn;
    btDadosAbertosNCMConsultar: TBitBtn;
    btValidarXml: TBitBtn;
    btRegimeGeralGerarXml: TBitBtn;
    btGerarXML: TBitBtn;
    btRegimeGeralItensAdd: TButton;
    btRegimeGeralItensLimpar: TButton;
    btRegimeGeralCalcular: TBitBtn;
    btDadosAbertosVersao: TBitBtn;
    btEndpointsLogLimpar: TBitBtn;
    btDadosAbertosUFsConsultar: TBitBtn;
    btRegimeGeralPreencher: TBitBtn;
    cbConfigLogNivel: TComboBox;
    cbDadosAbertosMunicipiosUF: TComboBox;
    edBaseCalculoCIBSAcrescimos: TEdit;
    edBaseCalculoCIBSAjusteValorOper: TEdit;
    edBaseCalculoCIBSCOFINS: TEdit;
    edBaseCalculoCIBSDemaisImp: TEdit;
    edBaseCalculoCIBSDescontosCond: TEdit;
    edBaseCalculoCIBSEncargos: TEdit;
    edBaseCalculoCIBSFrete: TEdit;
    edBaseCalculoCIBSICMS: TEdit;
    edBaseCalculoCIBSImpostoSeletivo: TEdit;
    edBaseCalculoCIBSISS: TEdit;
    edBaseCalculoCIBSJuros: TEdit;
    edBaseCalculoCIBSMultas: TEdit;
    edBaseCalculoCIBSOutrosTrib: TEdit;
    edBaseCalculoCIBSPIS: TEdit;
    edBaseCalculoCIBSValorFornec: TEdit;
    edBaseCalculoISAcrescimos: TEdit;
    edBaseCalculoISAjusteValorOper: TEdit;
    edBaseCalculoISBonificacao: TEdit;
    edBaseCalculoISCOFINS: TEdit;
    edBaseCalculoISDemaisImp: TEdit;
    edBaseCalculoISDescontosCond: TEdit;
    edBaseCalculoISDevol: TEdit;
    edBaseCalculoISEncargos: TEdit;
    edBaseCalculoISFrete: TEdit;
    edBaseCalculoISICMS: TEdit;
    edBaseCalculoISISS: TEdit;
    edBaseCalculoISJuros: TEdit;
    edBaseCalculoISMultas: TEdit;
    edBaseCalculoISOutrosTrib: TEdit;
    edBaseCalculoISPIS: TEdit;
    edBaseCalculoISValor: TEdit;
    edConfigLogArquivo: TEdit;
    edConfigProxyHost: TEdit;
    edConfigProxyPorta: TSpinEdit;
    edConfigProxySenha: TEdit;
    edConfigProxyUsuario: TEdit;
    edConfigAuthPass: TEdit;
    edConfigCalcTimeout: TEdit;
    edConfigCalcUrl: TEdit;
    edConfigAuthUser: TEdit;
    edDadosAbertosAliquotaMunCod: TEdit;
    edDadosAbertosAliquotasData: TDateTimePicker;
    edDadosAbertosAliquotaUFCod: TEdit;
    edDadosAbertosClassifData: TDateTimePicker;
    edDadosAbertosFundData: TDateTimePicker;
    edDadosAbertosClassifIdST: TEdit;
    edDadosAbertosNBS: TEdit;
    edDadosAbertosNBSData: TDateTimePicker;
    edDadosAbertosNCM: TEdit;
    edDadosAbertosNCMData: TDateTimePicker;
    edRegimeGeralId: TEdit;
    edValidarXMLTipo: TEdit;
    edValidarXMLSubtipo: TEdit;
    edRegimeGeralVersao: TEdit;
    edRegimeGeralCodMun: TEdit;
    edRegimeGeralUF: TEdit;
    edRegimeGeralItensCST: TEdit;
    edRegimeGeralItensBC: TEdit;
    edRegimeGeralItenscClassTrib: TEdit;
    gbConfigAuth: TGroupBox;
    gbConfigLog: TGroupBox;
    gbConfigProxy: TGroupBox;
    gbConfig: TGroupBox;
    gbDadosAbertosAliquotaMun: TGroupBox;
    gbDadosAbertosAliquotasData: TGroupBox;
    gbDadosAbertosAliquotaUF: TGroupBox;
    gbDadosAbertosAliquotaUniao: TGroupBox;
    gbDadosAbertosClassifData: TGroupBox;
    gbDadosAbertosClassifIdST: TGroupBox;
    gbDadosAbertosClassifImpostoSeletivo: TGroupBox;
    gbDadosAbertosClassifCbsIbs: TGroupBox;
    gbGerarXML: TGroupBox;
    gbValidarXml: TGroupBox;
    gbRegimeGeralItens: TGroupBox;
    gbRegimeGeral: TGroupBox;
    lbRegimeGeralId: TLabel;
    lbValidarXMLTipo: TLabel;
    lbValidarXMLSubtipo: TLabel;
    lbRegimeGeralVersao: TLabel;
    lbRegimeGeralCodMun: TLabel;
    lbRegimeGeralUF: TLabel;
    lbBaseCalculoCIBSAcrescimos: TLabel;
    lbBaseCalculoCIBSAcrescimos1: TLabel;
    lbBaseCalculoCIBSAjusteValorOper: TLabel;
    lbBaseCalculoCIBSCOFINS: TLabel;
    lbBaseCalculoCIBSDemaisImp: TLabel;
    lbBaseCalculoCIBSDescontosCond: TLabel;
    lbBaseCalculoCIBSEncargos: TLabel;
    lbBaseCalculoCIBSFrete: TLabel;
    lbBaseCalculoCIBSICMS: TLabel;
    lbBaseCalculoCIBSImpostoSeletivo: TLabel;
    lbBaseCalculoCIBSISS: TLabel;
    lbBaseCalculoCIBSJuros: TLabel;
    lbBaseCalculoCIBSMultas: TLabel;
    lbBaseCalculoCIBSOutrosTrib: TLabel;
    lbBaseCalculoCIBSPIS: TLabel;
    lbBaseCalculoCIBSValorFornec: TLabel;
    lbBaseCalculoISAjusteValorOper: TLabel;
    lbBaseCalculoISBonificacao: TLabel;
    lbBaseCalculoISCOFINS: TLabel;
    lbBaseCalculoISDemaisImp: TLabel;
    lbBaseCalculoISDescontosCond: TLabel;
    lbBaseCalculoISDevol: TLabel;
    lbBaseCalculoISEncargos: TLabel;
    lbBaseCalculoISFrete: TLabel;
    lbBaseCalculoISICMS: TLabel;
    lbBaseCalculoISISS: TLabel;
    lbBaseCalculoISJuros: TLabel;
    lbBaseCalculoISMultas: TLabel;
    lbBaseCalculoISOutrosTrib: TLabel;
    lbBaseCalculoISPIS: TLabel;
    lbBaseCalculoISValor: TLabel;
    lbConfigAuthPass: TLabel;
    lbConfigCalcTimeout: TLabel;
    lbConfigAuthUser: TLabel;
    lbDadosAbertosMunicipiosUF: TLabel;
    lbConfigLogArquivo: TLabel;
    lbConfigLogNivel: TLabel;
    lbConfigProxyHost: TLabel;
    lbConfigProxyPorta: TLabel;
    lbConfigProxySenha: TLabel;
    lbConfigProxyUsuario: TLabel;
    lbConfigCalcUrl: TLabel;
    lbDadosAbertosFundData: TLabel;
    lbDadosAbertosNBS: TLabel;
    lbDadosAbertosNBSData: TLabel;
    lbDadosAbertosNCM: TLabel;
    lbDadosAbertosNCMData: TLabel;
    lbEndpointsLog: TLabel;
    lbRegimeGeralItensCST: TLabel;
    lbRegimeGeralItensBC: TLabel;
    lbRegimeGeralItenscClassTrib: TLabel;
    mmValidarXml: TMemo;
    mmGerarXmlResponse: TMemo;
    mmGerarXML: TMemo;
    mmBaseCalculoCIBS: TMemo;
    mmDadosAbertosNCM: TMemo;
    mmDadosAbertosNBS: TMemo;
    mmDadosAbertosAliquotas: TMemo;
    mmBaseCalculoIS: TMemo;
    mmDadosAbertosVersao: TMemo;
    mmEndpointsLog: TMemo;
    mmRegimeGeralResponse: TMemo;
    OpenPictureDialog1: TOpenPictureDialog;
    pcCalculadora: TPageControl;
    pnEndpointsLogRodape1: TPanel;
    pnGerarXMLBotoes: TPanel;
    pnDadosAbertosVersaoCab: TPanel;
    pnBaseCalculoCIBSCab: TPanel;
    pnBaseCalculoISCab: TPanel;
    pnDadosAbertosNCMCab: TPanel;
    pnDadosAbertosNBSCab: TPanel;
    pnDadosAbertosAliqCab: TPanel;
    pcBaseCalculo: TPageControl;
    pnConfigAuth: TPanel;
    pnDadosAbertosAliquotaMun: TPanel;
    pnDadosAbertosAliquotas: TPanel;
    pnDadosAbertosAliquotasData: TPanel;
    pnDadosAbertosAliquotaUF: TPanel;
    pnDadosAbertosAliquotaUniao: TPanel;
    pnDadosAbertosClassifIdST: TPanel;
    pnDadosAbertosClassifImpostoSeletivo: TPanel;
    pnDadosAbertosClassifCbsIbs: TPanel;
    pnDadosAbertosClassif: TPanel;
    pnDadosAbertosClassifData: TPanel;
    pnBaseCalculoCIBS: TPanel;
    pnDadosAbertosNCM: TPanel;
    pnDadosAbertosNBS: TPanel;
    pnBaseCalculoIS: TPanel;
    pnDadosAbertosVersao: TPanel;
    pnDadosAbertosUFs: TPanel;
    pcEndpoints: TPageControl;
    pcDadosAbertos: TPageControl;
    pcPrincipal: TPageControl;
    pnConfig: TPanel;
    pnConfigLog: TPanel;
    pnConfigPainel: TPanel;
    pnConfigProxy: TPanel;
    pnConfigRodape: TPanel;
    pnConfigCalc: TPanel;
    pnDadosAbertosMunicipios: TPanel;
    pnDadosAbertosFund: TPanel;
    pnEndpointsLog: TPanel;
    pnEndpointsLogRodape: TPanel;
    pnValidarXmlBotoes: TPanel;
    pnRegimeGeralItens: TPanel;
    pnRegimeGeralBotoes: TPanel;
    sgDadosAbertosClassif: TStringGrid;
    sgDadosAbertosUFs: TStringGrid;
    sgDadosAbertosMunicipios: TStringGrid;
    sgDadosAbertosFund: TStringGrid;
    sgRegimeGeralItens: TStringGrid;
    Splitter1: TSplitter;
    tsCalculadora: TTabSheet;
    tsGerarXML: TTabSheet;
    tsValidarXml: TTabSheet;
    tsRegimeGeral: TTabSheet;
    tsDadosAbertosAliquotas: TTabSheet;
    tsDadosAbertosClassif: TTabSheet;
    tsDadosAbertosFund: TTabSheet;
    tsDadosAbertosNBS: TTabSheet;
    tsBaseCalculoCIBS: TTabSheet;
    tsDadosAbertosNCM: TTabSheet;
    tsDadosAbertosMunicipios: TTabSheet;
    tsBaseCalculoIS: TTabSheet;
    tsDadosAbertosUFs: TTabSheet;
    tsConfig: TTabSheet;
    tsEndpoints: TTabSheet;
    tsBaseCalculo: TTabSheet;
    tsDadosAbertos: TTabSheet;
    tsDadosAbertosVersao: TTabSheet;
    ImageList1: TImageList;
    procedure btBaseCalculoCIBSClick(Sender: TObject);
    procedure btBaseCalculoISClick(Sender: TObject);
    procedure btConfigAuthPassClick(Sender: TObject);
    procedure btConfigLerParametrosClick(Sender: TObject);
    procedure btConfigProxySenhaClick(Sender: TObject);
    procedure btConfigSalvarClick(Sender: TObject);
    procedure btDadosAbertosAliquotaMunClick(Sender: TObject);
    procedure btDadosAbertosAliquotaUFClick(Sender: TObject);
    procedure btDadosAbertosAliquotaUniaoClick(Sender: TObject);
    procedure btDadosAbertosClassifCbsIbsClick(Sender: TObject);
    procedure btDadosAbertosClassifIdSTConsultarClick(Sender: TObject);
    procedure btDadosAbertosClassifImpostoSeletivoClick(Sender: TObject);
    procedure btDadosAbertosFundConsultarClick(Sender: TObject);
    procedure btDadosAbertosMunicipiosConsultarClick(Sender: TObject);
    procedure btDadosAbertosNBSConsultarClick(Sender: TObject);
    procedure btDadosAbertosNCMConsultarClick(Sender: TObject);
    procedure btDadosAbertosUFsConsultarClick(Sender: TObject);
    procedure btEndpointsLogLimparClick(Sender: TObject);
    procedure btValidarXmlClick(Sender: TObject);
    procedure btGerarXMLClick(Sender: TObject);
    procedure btDadosAbertosVersaoClick(Sender: TObject);
    procedure btRegimeGeralCalcularClick(Sender: TObject);
    procedure btRegimeGeralGerarXmlClick(Sender: TObject);
    procedure btRegimeGeralItensAddClick(Sender: TObject);
    procedure btRegimeGeralItensLimparClick(Sender: TObject);
    procedure btRegimeGeralPreencherClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mmRegimeGeralResponseChange(Sender: TObject);
  private
    function CriarId: String;
    function FormatarJSON(const AJSON: String): String;

    procedure LerConfiguracao;
    procedure GravarConfiguracao;
    procedure AplicarConfiguracao;
    procedure InicializarBitmaps;
    procedure InicializarComponentesDefault;
    procedure AdicionarLog(aMsg: String);

    procedure PreencherClassificacoes(aObj: IACBrCalcClassifTributariasResponse);
  public
    function NomeArquivoConfig: String;
  end;

var
  frPrincipal: TfrPrincipal;

implementation

uses
  {$IfDef FPC}
   fpjson, jsonparser, jsonscanner,
  {$Else}
    {$IFDEF DELPHI26_UP}JSON,{$ENDIF}
  {$EndIf}
  synautil, synacode, IniFiles, DateUtils, StrUtils,
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrUtil.FilesIO,
  ACBrUtil.XMLHTML;
              
{$IfDef FPC}
  {$R *.lfm}
{$Else}
  {$R *.dfm}
{$EndIf}

{ TfrPrincipal }

procedure TfrPrincipal.btDadosAbertosVersaoClick(Sender: TObject);
var
  wOk: Boolean;
  resp: IACBrCalcVersaoResponse;
begin
  wOk := ACBrCalculadoraConsumo1.DadosAbertos.ConsultarVersao(resp);
  if wOk then
  begin
    AdicionarLog('[CONSULTADO COM SUCESSO]');
    mmDadosAbertosVersao.Lines.Text := FormatarJSON(resp.ToJson);
  end
  else
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.DadosAbertos.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btRegimeGeralCalcularClick(Sender: TObject);
var
  wOk: Boolean;
  i: Integer;
  resp: IACBrCalcRegimeGeralResponse;
begin
  with ACBrCalculadoraConsumo1.RegimeGeralRequest do
  begin
    id := edRegimeGeralId.Text;
    versao := edRegimeGeralVersao.Text;
    dataHoraEmissao := Now;
    municipio := StrToIntDef(edRegimeGeralCodMun.Text, 0);
    uf := edRegimeGeralUF.Text;

    for i := 1 to sgRegimeGeralItens.RowCount-1 do
    with ACBrCalculadoraConsumo1.RegimeGeralRequest.itens.New do
    begin
      numero := StrToIntDef(sgRegimeGeralItens.Cells[0, i], 0);
      cst := sgRegimeGeralItens.Cells[1, i];
      baseCalculo := StrToFloatDef(sgRegimeGeralItens.Cells[2, i], 0);
      cClassTrib := sgRegimeGeralItens.Cells[3, i];
    end;
  end;

  wOk := ACBrCalculadoraConsumo1.RegimeGeral(resp);
  if wOk then
  begin
    AdicionarLog('[CALCULADO COM SUCESSO]');
    mmRegimeGeralResponse.Lines.Text := FormatarJSON(resp.ToJson);
  end
  else
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btRegimeGeralGerarXmlClick(Sender: TObject);
begin
  pcCalculadora.ActivePage := tsGerarXML;
  mmGerarXML.Lines.Text := mmRegimeGeralResponse.Lines.Text;
end;

procedure TfrPrincipal.btRegimeGeralItensAddClick(Sender: TObject);
var
  i: Integer;
begin
  i := sgRegimeGeralItens.RowCount;
  sgRegimeGeralItens.RowCount := i+1;
  sgRegimeGeralItens.Cells[0, i] := IntToStr(i+1);
  sgRegimeGeralItens.Cells[1, i] := edRegimeGeralItensCST.Text;
  sgRegimeGeralItens.Cells[2, i] := edRegimeGeralItensBC.Text;
  sgRegimeGeralItens.Cells[3, i] := edRegimeGeralItenscClassTrib.Text;
  edRegimeGeralItensCST.Text := EmptyStr;
  edRegimeGeralItensBC.Text := EmptyStr;
  edRegimeGeralItenscClassTrib.Text := EmptyStr;
end;

procedure TfrPrincipal.btRegimeGeralItensLimparClick(Sender: TObject);
begin
  sgRegimeGeralItens.RowCount := 1;
end;

procedure TfrPrincipal.btRegimeGeralPreencherClick(Sender: TObject);
begin
  edRegimeGeralId.Text := CriarId;
  edRegimeGeralVersao.Text := '1.0.0';
  edRegimeGeralCodMun.Text := '3550308';
  edRegimeGeralUF.Text := 'SP';

  sgRegimeGeralItens.RowCount := 2;
  sgRegimeGeralItens.Cells[0, 1] := '1';
  sgRegimeGeralItens.Cells[1, 1] := '000';
  sgRegimeGeralItens.Cells[2, 1] := '500';
  sgRegimeGeralItens.Cells[3, 1] := '000001';
end;

procedure TfrPrincipal.FormCreate(Sender: TObject);
begin
  InicializarBitmaps;
  InicializarComponentesDefault;
  LerConfiguracao;
end;

procedure TfrPrincipal.mmRegimeGeralResponseChange(Sender: TObject);
begin
  btRegimeGeralGerarXml.Enabled := NaoEstaVazio(mmRegimeGeralResponse.Lines.Text);
end;

function TfrPrincipal.CriarId: String;
var
  guid: TGUID;
begin
  CreateGUID(guid);
  Result := OnlyAlphaNum(GUIDToString(guid));
end;

procedure TfrPrincipal.btDadosAbertosMunicipiosConsultarClick(Sender: TObject);
var
  wUF: String;
  wOk: Boolean;
  resp: IACBrCalcMunicipiosResponse;
  i: Integer;
begin
  {$IfDef FPC}wUF := EmptyStr;{$EndIf}
  if (cbDadosAbertosMunicipiosUF.ItemIndex = -1) then
  begin
    ShowMessage('Selecione uma UF para consultar!');
    Exit;
  end;

  wUF := Copy(cbDadosAbertosMunicipiosUF.Text, 1, 2);
  wOk := ACBrCalculadoraConsumo1.DadosAbertos.ConsultarMunicipios(wUF, resp);
  if (not wOk) then
  begin
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.DadosAbertos.RespostaErro.AsJSON));
    Exit;
  end;

  AdicionarLog('[CONSULTADO COM SUCESSO]');
  sgDadosAbertosMunicipios.RowCount := (resp.municipios.Count + 1);
  sgDadosAbertosMunicipios.Cells[0, 0] := 'Codigo';
  sgDadosAbertosMunicipios.Cells[1, 0] := 'Nome';
  for i := 0 to resp.municipios.Count-1 do
  begin
    sgDadosAbertosMunicipios.Cells[0, i+1] := IntToStr(resp.municipios[i].codigo);
    sgDadosAbertosMunicipios.Cells[1, i+1] := resp.municipios[i].nome;
  end;
end;

procedure TfrPrincipal.btDadosAbertosNBSConsultarClick(Sender: TObject);
var
  wOk: Boolean;
  wNBS: String;
  resp: IACBrCalcNBSResponse;
begin
  wNBS := Trim(OnlyNumber(edDadosAbertosNBS.Text));
  if EstaVazio(wNBS) or EstaZerado(edDadosAbertosNBSData.DateTime) then
  begin
    ShowMessage('Preencha os campos NBS e Data!');
    Exit;
  end;

  wOk := ACBrCalculadoraConsumo1.DadosAbertos.ConsultarNBS(wNBS, edDadosAbertosNBSData.DateTime, resp);
  if (not wOk) then
  begin
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.DadosAbertos.RespostaErro.AsJSON));
    Exit;
  end;

  AdicionarLog('[CONSULTADO COM SUCESSO]');
  mmDadosAbertosNBS.Lines.Text := FormatarJSON(resp.ToJson);
end;

procedure TfrPrincipal.btDadosAbertosNCMConsultarClick(Sender: TObject);
var
  wOk: Boolean;
  wNCM: String;
  resp: IACBrCalcNCMResponse;
begin
  wNCM := Trim(OnlyNumber(edDadosAbertosNCM.Text));
  if EstaVazio(wNCM) or EstaZerado(edDadosAbertosNCMData.DateTime) then
  begin
    ShowMessage('Preencha os campos NCM e Data!');
    Exit;
  end;

  wOk := ACBrCalculadoraConsumo1.DadosAbertos.ConsultarNCM(wNCM, edDadosAbertosNCMData.DateTime, resp);
  if (not wOk) then
  begin
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.DadosAbertos.RespostaErro.AsJSON));
    Exit;
  end;

  AdicionarLog('[CONSULTADO COM SUCESSO]');
  mmDadosAbertosNCM.Lines.Text := FormatarJSON(resp.ToJson);
end;

procedure TfrPrincipal.btDadosAbertosUFsConsultarClick(Sender: TObject);
var
  wOk: Boolean;
  resp: IACBrCalcUFsResponse;
  i: Integer;
begin
  wOk := ACBrCalculadoraConsumo1.DadosAbertos.ConsultarUFs(resp);
  if (not wOk) then
  begin
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.DadosAbertos.RespostaErro.AsJSON));
    Exit;
  end;

  AdicionarLog('[CONSULTADO COM SUCESSO]');
  sgDadosAbertosUFs.RowCount := (resp.ufs.Count + 1);
  sgDadosAbertosUFs.Cells[0, 0] := 'Codigo';
  sgDadosAbertosUFs.Cells[1, 0] := 'Sigla';
  sgDadosAbertosUFs.Cells[2, 0] := 'Nome';
  for i := 0 to resp.ufs.Count-1 do
  begin
    sgDadosAbertosUFs.Cells[0, i+1] := IntToStr(resp.ufs[i].codigo);
    sgDadosAbertosUFs.Cells[1, i+1] := resp.ufs[i].sigla;
    sgDadosAbertosUFs.Cells[2, i+1] := resp.ufs[i].nome;
  end;
end;

procedure TfrPrincipal.btEndpointsLogLimparClick(Sender: TObject);
begin
  mmEndpointsLog.Lines.Text := EmptyStr;
end;

procedure TfrPrincipal.btValidarXmlClick(Sender: TObject);
var
  wOk: Boolean;
begin
  if EstaVazio(edValidarXMLTipo.Text) or EstaVazio(edValidarXMLSubtipo.Text) then
  begin
    ShowMessage('Preencha os campos tipo/subtipo!');
    Exit;
  end;

  wOk := ACBrCalculadoraConsumo1.ValidarXML(
           edValidarXMLTipo.Text,
           edValidarXMLSubtipo.Text,
           mmValidarXml.Lines.Text);
  if wOk then
  begin
    AdicionarLog('[VALIDADO COM SUCESSO]');
    ShowMessage('Validado com sucesso!');
  end
  else
    AdicionarLog(' [INVALIDO] ' + sLineBreak +
      FormatarJSON(ACBrCalculadoraConsumo1.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btGerarXMLClick(Sender: TObject);
var
  wOk: Boolean;
  resp: AnsiString;
begin
  if EstaVazio(mmGerarXML.Lines.Text) then
  begin
    ShowMessage('Preencha o Json de requisição!');
    Exit;
  end;

  ACBrCalculadoraConsumo1.GerarXMLRequest.AsJSON := mmGerarXML.Lines.Text;
  wOk := ACBrCalculadoraConsumo1.GerarXML(resp);
  if wOk then
  begin
    AdicionarLog('[GERADO COM SUCESSO]');
    mmGerarXmlResponse.Lines.Text := resp;
  end
  else
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btConfigSalvarClick(Sender: TObject);
begin
  GravarConfiguracao;
end;

procedure TfrPrincipal.btDadosAbertosAliquotaMunClick(Sender: TObject);
var
  wOk: Boolean;
  wCodMun: Integer;
  resp: IACBrCalcAliquotaResponse;
begin
  wCodMun := StrToIntDef(edDadosAbertosAliquotaMunCod.Text, 0);
  if (wCodMun < 1) then
  begin
    ShowMessage('Preencha o campo codigo do Municipio!');
    Exit;
  end;

  wOk := ACBrCalculadoraConsumo1.DadosAbertos.ConsultarAliquotaMunicipio(wCodMun, edDadosAbertosAliquotasData.DateTime, resp);
  if (not wOk) then
  begin
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.DadosAbertos.RespostaErro.AsJSON));
    Exit;
  end;

  AdicionarLog('[CONSULTADO COM SUCESSO]');
  mmDadosAbertosAliquotas.Lines.Text := FormatarJSON(resp.ToJson);
end;

procedure TfrPrincipal.btDadosAbertosAliquotaUFClick(Sender: TObject);
var
  wOk: Boolean;
  wCodUF: Integer;
  resp: IACBrCalcAliquotaResponse;
begin
  wCodUF := StrToIntDef(edDadosAbertosAliquotaUFCod.Text, 0);
  if (wCodUF < 1) then
  begin
    ShowMessage('Preencha o campo codigo UF!');
    Exit;
  end;

  wOk := ACBrCalculadoraConsumo1.DadosAbertos.ConsultarAliquotaUF(wCodUF, edDadosAbertosAliquotasData.DateTime, resp);
  if (not wOk) then
  begin
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.DadosAbertos.RespostaErro.AsJSON));
    Exit;
  end;

  AdicionarLog('[CONSULTADO COM SUCESSO]');
  mmDadosAbertosAliquotas.Lines.Text := FormatarJSON(resp.ToJson);
end;

procedure TfrPrincipal.btDadosAbertosAliquotaUniaoClick(Sender: TObject);
var
  wOk: Boolean;
  resp: IACBrCalcAliquotaResponse;
begin
  wOk := ACBrCalculadoraConsumo1.DadosAbertos.ConsultarAliquotaUniao(edDadosAbertosAliquotasData.DateTime, resp);
  if (not wOk) then
  begin
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.DadosAbertos.RespostaErro.AsJSON));
    Exit;
  end;

  AdicionarLog('[CONSULTADO COM SUCESSO]');
  mmDadosAbertosAliquotas.Lines.Text := FormatarJSON(resp.ToJson);
end;

procedure TfrPrincipal.btDadosAbertosClassifCbsIbsClick(Sender: TObject);
var
  wOk: Boolean;
  resp: IACBrCalcClassifTributariasResponse;
begin
  wOk := ACBrCalculadoraConsumo1.DadosAbertos.ConsultarClassTribCbsIbs(edDadosAbertosClassifData.DateTime, resp);
  if (not wOk) then
  begin
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.DadosAbertos.RespostaErro.AsJSON));
    Exit;
  end;

  AdicionarLog('[CONSULTADO COM SUCESSO]');
  PreencherClassificacoes(resp);
end;

procedure TfrPrincipal.btDadosAbertosClassifIdSTConsultarClick(Sender: TObject);
var
  wOk: Boolean;
  wIdST: Integer;
  resp: IACBrCalcClassifTributariasResponse;
begin
  wIdST := StrToIntDef(edDadosAbertosClassifIdST.Text, 0);
  if (wIdST < 1) then
  begin
    ShowMessage('Preencha o campo Id Situacao Tributaria!');
    Exit;
  end;

  wOk := ACBrCalculadoraConsumo1.DadosAbertos.ConsultarClassTrib(wIdST, edDadosAbertosClassifData.DateTime, resp);
  if (not wOk) then
  begin
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.DadosAbertos.RespostaErro.AsJSON));
    Exit;
  end;

  AdicionarLog('[CONSULTADO COM SUCESSO]');
  PreencherClassificacoes(resp);
end;

procedure TfrPrincipal.btDadosAbertosClassifImpostoSeletivoClick(Sender: TObject);
var
  wOk: Boolean;
  resp: IACBrCalcClassifTributariasResponse;
begin
  wOk := ACBrCalculadoraConsumo1.DadosAbertos.ConsultarClassTribImpostoSeletivo(edDadosAbertosClassifData.DateTime, resp);
  if (not wOk) then
  begin
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.DadosAbertos.RespostaErro.AsJSON));
    Exit;
  end;

  AdicionarLog('[CONSULTADO COM SUCESSO]');
  PreencherClassificacoes(resp);
end;

procedure TfrPrincipal.btDadosAbertosFundConsultarClick(Sender: TObject);
var
  wOk: Boolean;
  resp: IACBrCalcFundamentacoesResponse;
  i: Integer;
begin
  if EstaZerado(edDadosAbertosNCMData.DateTime) then
  begin
    ShowMessage('Preencha o campo Data!');
    Exit;
  end;

  wOk := ACBrCalculadoraConsumo1.DadosAbertos.ConsultarFundamentacoes(edDadosAbertosFundData.DateTime, resp);
  if (not wOk) then
  begin
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.DadosAbertos.RespostaErro.AsJSON));
    Exit;
  end;

  AdicionarLog('[CONSULTADO COM SUCESSO]');
  sgDadosAbertosFund.RowCount := (resp.fundamentacoes.Count + 1);
  sgDadosAbertosFund.Cells[0, 0] := 'Situacao Trib.';
  sgDadosAbertosFund.Cells[1, 0] := 'Classif. Trib.';
  sgDadosAbertosFund.Cells[2, 0] := 'Conjunto';
  sgDadosAbertosFund.Cells[3, 0] := 'Texto Curto';
  sgDadosAbertosFund.Cells[4, 0] := 'Descrição Situacao. Trib.';
  sgDadosAbertosFund.Cells[5, 0] := 'Descrição Classif. Tributaria';
  sgDadosAbertosFund.Cells[6, 0] := 'Texto';
  sgDadosAbertosFund.Cells[7, 0] := 'Referencia Normativa';
  for i := 0 to resp.fundamentacoes.Count-1 do
  begin
    sgDadosAbertosFund.Cells[0, i+1] := resp.fundamentacoes[i].codigoSituacaoTributaria;
    sgDadosAbertosFund.Cells[1, i+1] := resp.fundamentacoes[i].codigoClassificacaoTributaria;
    sgDadosAbertosFund.Cells[2, i+1] := resp.fundamentacoes[i].conjuntoTributo;
    sgDadosAbertosFund.Cells[3, i+1] := resp.fundamentacoes[i].textoCurto;
    sgDadosAbertosFund.Cells[4, i+1] := resp.fundamentacoes[i].descricaoSituacaoTributaria;
    sgDadosAbertosFund.Cells[5, i+1] := resp.fundamentacoes[i].descricaoClassificacaoTributaria;
    sgDadosAbertosFund.Cells[6, i+1] := resp.fundamentacoes[i].texto;
    sgDadosAbertosFund.Cells[7, i+1] := resp.fundamentacoes[i].referenciaNormativa;
  end;
end;

procedure TfrPrincipal.btConfigLerParametrosClick(Sender: TObject);
begin
  LerConfiguracao;
end;

procedure TfrPrincipal.btConfigProxySenhaClick(Sender: TObject);
begin
  {$IfDef FPC}
  if btConfigProxySenha.Down then
    edConfigProxySenha.EchoMode := emNormal
  else
    edConfigProxySenha.EchoMode := emPassword;
  {$Else}
  if btConfigProxySenha.Down then
    edConfigProxySenha.PasswordChar := #0
  else
    edConfigProxySenha.PasswordChar := '*';
  {$EndIf}
end;

procedure TfrPrincipal.btBaseCalculoISClick(Sender: TObject);
var
  wOk: Boolean;
  resp: IACBrCalcBaseCalculoResponse;
begin
  with ACBrCalculadoraConsumo1.BaseCalculo.ISMercadorias do
  begin
    valorIntegralCobrado := StrToFloatDef(edBaseCalculoISValor.Text, 0);
    ajusteValorOperacao := StrToFloatDef(edBaseCalculoISAjusteValorOper.Text, 0);
    juros := StrToFloatDef(edBaseCalculoISJuros.Text, 0);
    multas := StrToFloatDef(edBaseCalculoISMultas.Text, 0);
    acrescimos := StrToFloatDef(edBaseCalculoISAcrescimos.Text, 0);
    encargos := StrToFloatDef(edBaseCalculoISEncargos.Text, 0);
    descontosCondicionais := StrToFloatDef(edBaseCalculoISDescontosCond.Text, 0);
    fretePorDentro := StrToFloatDef(edBaseCalculoISFrete.Text, 0);
    outrosTributos := StrToFloatDef(edBaseCalculoISOutrosTrib.Text, 0);
    demaisImportancias := StrToFloatDef(edBaseCalculoISDemaisImp.Text, 0);
    icms := StrToFloatDef(edBaseCalculoISICMS.Text, 0);
    iss := StrToFloatDef(edBaseCalculoISISS.Text, 0);
    pis := StrToFloatDef(edBaseCalculoISPIS.Text, 0);
    cofins := StrToFloatDef(edBaseCalculoISCOFINS.Text, 0);
    bonificacao := StrToFloatDef(edBaseCalculoISBonificacao.Text, 0);
    devolucaoVendas := StrToFloatDef(edBaseCalculoISDevol.Text, 0);
  end;

  wOk := ACBrCalculadoraConsumo1.BaseCalculo.CalcularPorIS(resp);
  if (wOk) then
  begin
    AdicionarLog('[CALCULADO COM SUCESSO]');
    mmBaseCalculoIS.Lines.Text := FormatarJSON(resp.ToJson);
  end
  else
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.BaseCalculo.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btConfigAuthPassClick(Sender: TObject);
begin
  {$IfDef FPC}
  if btConfigAuthPass.Down then
    edConfigAuthPass.EchoMode := emNormal
  else
    edConfigAuthPass.EchoMode := emPassword;
  {$Else}
  if btConfigAuthPass.Down then
    edConfigAuthPass.PasswordChar := #0
  else
    edConfigAuthPass.PasswordChar := '*';
  {$EndIf}
end;

procedure TfrPrincipal.btBaseCalculoCIBSClick(Sender: TObject);
var
  wOk: Boolean;
  resp: IACBrCalcBaseCalculoResponse;
begin
  with ACBrCalculadoraConsumo1.BaseCalculo.CIBSMercadorias do
  begin
    valorFornecimento := StrToFloatDef(edBaseCalculoCIBSValorFornec.Text, 0);
    ajusteValorOperacao := StrToFloatDef(edBaseCalculoCIBSAjusteValorOper.Text, 0);
    juros := StrToFloatDef(edBaseCalculoCIBSJuros.Text, 0);
    multas := StrToFloatDef(edBaseCalculoCIBSMultas.Text, 0);
    acrescimos := StrToFloatDef(edBaseCalculoCIBSAcrescimos.Text, 0);
    encargos := StrToFloatDef(edBaseCalculoCIBSEncargos.Text, 0);
    descontosCondicionais := StrToFloatDef(edBaseCalculoCIBSDescontosCond.Text, 0);
    fretePorDentro := StrToFloatDef(edBaseCalculoCIBSFrete.Text, 0);
    outrosTributos := StrToFloatDef(edBaseCalculoCIBSOutrosTrib.Text, 0);
    impostoSeletivo := StrToFloatDef(edBaseCalculoCIBSImpostoSeletivo.Text, 0);
    demaisImportancias := StrToFloatDef(edBaseCalculoCIBSDemaisImp.Text, 0);
    icms := StrToFloatDef(edBaseCalculoCIBSICMS.Text, 0);
    iss := StrToFloatDef(edBaseCalculoCIBSISS.Text, 0);
    pis := StrToFloatDef(edBaseCalculoCIBSPIS.Text, 0);
    cofins := StrToFloatDef(edBaseCalculoCIBSCOFINS.Text, 0);
  end;

  wOk := ACBrCalculadoraConsumo1.BaseCalculo.CalcularPorCIBS(resp);
  if (wOk) then
  begin
    AdicionarLog('[CALCULADO COM SUCESSO]');
    mmBaseCalculoCIBS.Lines.Text := FormatarJSON(resp.ToJson);
  end
  else
    AdicionarLog(FormatarJSON(ACBrCalculadoraConsumo1.BaseCalculo.RespostaErro.AsJSON));
end;

function TfrPrincipal.FormatarJSON(const AJSON: String): String;
{$IfDef FPC}
var
  jpar: TJSONParser;
  jdata: TJSONData;
  ms: TMemoryStream;
{$ELSE}
  {$IFDEF DELPHI26_UP}
  var
    wJsonValue: TJSONValue;
  {$ENDIF}
{$ENDIF}
begin
  Result := AJSON;
  try
    {$IFDEF FPC}
    ms := TMemoryStream.Create;
    try
      ms.Write(Pointer(AJSON)^, Length(AJSON));
      ms.Position := 0;
      jpar := TJSONParser.Create(ms, [joUTF8]);
      jdata := jpar.Parse;
      if Assigned(jdata) then
        Result := jdata.FormatJSON;
    finally
      ms.Free;
      if Assigned(jpar) then
        jpar.Free;
      if Assigned(jdata) then
        jdata.Free;
    end;
    {$ELSE}
      {$IFDEF DELPHI26_UP}
      wJsonValue := TJSONObject.ParseJSONValue(AJSON);
      try
        if Assigned(wJsonValue) then
        begin
          Result := wJsonValue.Format(2);
        end;
      finally
        wJsonValue.Free;
      end;
      {$ENDIF}
    {$ENDIF}
  except
    Result := AJSON;
  end;
end;

procedure TfrPrincipal.LerConfiguracao;
var
  wIni: TIniFile;
begin
  AdicionarLog('- LerConfiguracao: ' + NomeArquivoConfig);
  wIni := TIniFile.Create(NomeArquivoConfig);
  try
    edConfigCalcUrl.Text := wIni.ReadString('Calculadora', 'URL', ACBrCalculadoraConsumo1.URL);
    edConfigCalcTimeout.Text := IntToStr(wIni.ReadInteger('Calculadora', 'Timeout', 9000));

    edConfigAuthUser.Text := wIni.ReadString('Auth', 'Username', EmptyStr);
    edConfigAuthPass.Text := wIni.ReadString('Auth', 'Password', EmptyStr);

    edConfigProxyHost.Text := wIni.ReadString('Proxy', 'Host', '');
    edConfigProxyPorta.Text := wIni.ReadString('Proxy', 'Porta', '');
    edConfigProxyUsuario.Text := wIni.ReadString('Proxy', 'Usuario', '');
    edConfigProxySenha.Text := StrCrypt(DecodeBase64(wIni.ReadString('Proxy', 'Senha', '')), CURL_ACBR);

    edConfigLogArquivo.Text := wIni.ReadString('Log', 'Arquivo', '');
    cbConfigLogNivel.ItemIndex := wIni.ReadInteger('Log', 'Nivel', 4);
  finally
    wIni.Free;
  end;

  AplicarConfiguracao;
end;

procedure TfrPrincipal.GravarConfiguracao;
var
  wIni: TIniFile;
begin
  AdicionarLog('- GravarConfiguracao: ' + NomeArquivoConfig);
  wIni := TIniFile.Create(NomeArquivoConfig);
  try
    wIni.WriteString('Calculadora', 'URL', edConfigCalcUrl.Text);
    wIni.WriteInteger('Calculadora', 'Timeout', StrToIntDef(edConfigCalcTimeout.Text, 9000));

    wIni.WriteString('Auth', 'Username', edConfigAuthUser.Text);
    wIni.WriteString('Auth', 'Password', edConfigAuthPass.Text);

    wIni.WriteString('Proxy', 'Host', edConfigProxyHost.Text);
    wIni.WriteString('Proxy', 'Porta', edConfigProxyPorta.Text);
    wIni.WriteString('Proxy', 'Usuario', edConfigProxyUsuario.Text);
    wIni.WriteString('Proxy', 'Senha', EncodeBase64(StrCrypt(edConfigProxySenha.Text, CURL_ACBR)));

    wIni.WriteString('Log', 'Arquivo', edConfigLogArquivo.Text);
    wIni.WriteInteger('Log', 'Nivel', cbConfigLogNivel.ItemIndex);
  finally
    wIni.Free;
  end;

  AplicarConfiguracao;
end;

procedure TfrPrincipal.AplicarConfiguracao;
begin
  AdicionarLog('  - ConfigurarACBrPIXCD');

  if NaoEstaVazio(edConfigCalcUrl.Text) and (edConfigCalcUrl.Text <> ACBrCalculadoraConsumo1.URL) then
    ACBrCalculadoraConsumo1.URL := edConfigCalcUrl.Text;

  ACBrCalculadoraConsumo1.HTTPSend.UserName := edConfigAuthUser.Text;
  ACBrCalculadoraConsumo1.HTTPSend.Password := edConfigAuthPass.Text;

  ACBrCalculadoraConsumo1.ProxyHost := edConfigProxyHost.Text;
  ACBrCalculadoraConsumo1.ProxyPort := edConfigProxyPorta.Text;
  ACBrCalculadoraConsumo1.ProxyUser := edConfigProxyUsuario.Text;
  ACBrCalculadoraConsumo1.ProxyPass := edConfigProxySenha.Text;

  ACBrCalculadoraConsumo1.ArqLOG := edConfigLogArquivo.Text;
  ACBrCalculadoraConsumo1.NivelLog := cbConfigLogNivel.ItemIndex;
end;

procedure TfrPrincipal.InicializarBitmaps;
begin
  ImageList1.GetBitmap(7, btConfigProxySenha.Glyph);
  ImageList1.GetBitmap(9, btConfigLogArquivo.Glyph);
  ImageList1.GetBitmap(10, btConfigSalvar.Glyph);
  ImageList1.GetBitmap(11, btConfigLerParametros.Glyph);
  ImageList1.GetBitmap(18, btEndpointsLogLimpar.Glyph);
                                                     
  ImageList1.GetBitmap(8, btDadosAbertosVersao.Glyph); 
  ImageList1.GetBitmap(8, btDadosAbertosUFsConsultar.Glyph);
  ImageList1.GetBitmap(8, btDadosAbertosMunicipiosConsultar.Glyph);
  ImageList1.GetBitmap(8, btDadosAbertosNCMConsultar.Glyph);
  ImageList1.GetBitmap(8, btDadosAbertosFundConsultar.Glyph);

  ImageList1.GetBitmap(8, btDadosAbertosClassifIdSTConsultar.Glyph);
  ImageList1.GetBitmap(8, btDadosAbertosClassifImpostoSeletivo.Glyph);
  ImageList1.GetBitmap(8, btDadosAbertosClassifCbsIbs.Glyph);

  ImageList1.GetBitmap(8, btDadosAbertosAliquotaMun.Glyph);
  ImageList1.GetBitmap(8, btDadosAbertosAliquotaUF.Glyph);
  ImageList1.GetBitmap(8, btDadosAbertosAliquotaUniao.Glyph);
  
  ImageList1.GetBitmap(8, btBaseCalculoIS.Glyph);
  ImageList1.GetBitmap(8, btBaseCalculoCIBS.Glyph);
  
  ImageList1.GetBitmap(14, btGerarXML.Glyph);
  ImageList1.GetBitmap(14, btValidarXml.Glyph);
  ImageList1.GetBitmap(14, btRegimeGeralCalcular.Glyph);
  ImageList1.GetBitmap(29, btRegimeGeralPreencher.Glyph);
  ImageList1.GetBitmap(16, btRegimeGeralGerarXml.Glyph);
end;

procedure TfrPrincipal.InicializarComponentesDefault;
begin
  //
end;

procedure TfrPrincipal.AdicionarLog(aMsg: String);
begin
  if Assigned(mmEndpointsLog) then
    mmEndpointsLog.Lines.Add(aMsg);
end;

procedure TfrPrincipal.PreencherClassificacoes(aObj: IACBrCalcClassifTributariasResponse);
var
  i: Integer;
begin
  sgDadosAbertosClassif.RowCount := (aObj.classificacoes.Count + 1);
  sgDadosAbertosClassif.Cells[0, 0] := 'Codigo';
  sgDadosAbertosClassif.Cells[1, 0] := 'Nomenclatura';
  sgDadosAbertosClassif.Cells[2, 0] := 'Tipo Aliquota';
  sgDadosAbertosClassif.Cells[3, 0] := 'Descricao';
  sgDadosAbertosClassif.Cells[4, 0] := 'Descricao Trat.Tributario';
  sgDadosAbertosClassif.Cells[5, 0] := 'Incompativel com Suspensao';
  sgDadosAbertosClassif.Cells[6, 0] := 'Exige Desoneracao';
  sgDadosAbertosClassif.Cells[7, 0] := 'Possui % Reducao';
  for i := 0 to aObj.classificacoes.Count-1 do
  begin
    sgDadosAbertosClassif.Cells[0, i+1] := aObj.classificacoes[i].codigo;
    sgDadosAbertosClassif.Cells[1, i+1] := aObj.classificacoes[i].nomenclatura;
    sgDadosAbertosClassif.Cells[2, i+1] := aObj.classificacoes[i].tipoAliquota;
    sgDadosAbertosClassif.Cells[3, i+1] := aObj.classificacoes[i].descricao;
    sgDadosAbertosClassif.Cells[4, i+1] := aObj.classificacoes[i].descricaoTratamentoTributario;
    sgDadosAbertosClassif.Cells[5, i+1] := IfThen(aObj.classificacoes[i].incompativelComSuspensao, 'Sim', 'Nao');
    sgDadosAbertosClassif.Cells[6, i+1] := IfThen(aObj.classificacoes[i].exigeGrupoDesoneracao, 'Sim', 'Nao');
    sgDadosAbertosClassif.Cells[7, i+1] := IfThen(aObj.classificacoes[i].possuiPercentualReducao, 'Sim', 'Nao');
  end;
end;

function TfrPrincipal.NomeArquivoConfig: String;
begin
  Result := ChangeFileExt(Application.ExeName, '.ini');
end;

end.

