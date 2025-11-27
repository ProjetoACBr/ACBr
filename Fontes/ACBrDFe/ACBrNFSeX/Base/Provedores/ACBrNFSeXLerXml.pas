{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit ACBrNFSeXLerXml;

interface

uses
  SysUtils, Classes, IniFiles, types,
  ACBrBase,
  ACBrXmlBase,
  ACBrDFe.Conversao,
  ACBrXmlReader,
  ACBrXmlDocument,
  ACBrNFSeXInterface, ACBrNFSeXClass, ACBrNFSeXConversao;

type
  { TNFSeRClass }

  TNFSeRClass = class(TACBrXmlReader)
  private
    FNFSe: TNFSe;
    FProvedor: TnfseProvedor;
    FtpXML: TtpXML;
    FAmbiente: TACBrTipoAmbiente;
    FIniParams: TMemIniFile;
    FParamsTab: TStrings;
    FIniParamsTab: TMemIniFile;

    procedure SetParamsTab(const Value: TStrings);
  protected
    FpAOwner: IACBrNFSeXProvider;
    FpQuebradeLinha: string;
    FpIniParamsTabCarregado: Boolean;

    procedure Configuracao; virtual;

    function NormatizarItemListaServico(const Codigo: string): string;
    function ItemListaServicoDescricao(const Codigo: string): string;
    function TipodeXMLLeitura(const aArquivo: string): TtpXML; virtual;
    function NormatizarXml(const aXml: string): string; virtual;
    function NormatizarAliquota(const Aliquota: Double): Double;
    function LerLinkURL: string;
    function ObterNomeMunicipioUF(ACodigoMunicipio: Integer; var xUF: string): string;
    function LerParamsTabIniServicos: AnsiString;
    function LerParamsTabInterno: AnsiString;
    function LerDescricaoServico(const ACodigo: string): string;
    function NormatizarCodigoMunicipio(const Codigo: string): string;

    function ExtrairLista(const ADiscriminacao: string): string;
    procedure VerificarSeConteudoEhLista(const aDiscriminacao: string);
    procedure LerListaJson(const aDiscriminacao: string);
    procedure LerListaTabulada(const aDiscriminacao: string);

    procedure LerParamsTabIni(ApenasSeNaoLido: Boolean);
    procedure LerParamsTab;

    // Reforma Tributária
    procedure LerXMLIBSCBSDPS(const ANode: TACBrXmlNode; IBSCBS: TIBSCBSDPS);
    procedure LerXMLgRefNFSe(const ANode: TACBrXmlNode);

    procedure LerXMLDestinatario(const ANode: TACBrXmlNode; Dest: TDadosdaPessoa);
    procedure LerXMLEnderecoDestinatario(const ANode: TACBrXmlNode; ender: Tender);
    procedure LerXMLEnderecoNacionalDestinatario(const ANode: TACBrXmlNode; endNac: TendNac);
    procedure LerXMLEnderecoExteriorDestinatario(const ANode: TACBrXmlNode; endExt: TendExt);

    procedure LerXMLImovel(const ANode: TACBrXmlNode; Imovel: TDadosimovel);
    procedure LerXMLEnderecoNacionalImovel(const ANode: TACBrXmlNode; ender: TenderImovel);
    procedure LerXMLEnderecoExteriorImovel(const ANode: TACBrXmlNode; endExt: TendExt);

    procedure LerXMLIBSCBSValores(const ANode: TACBrXmlNode; valores: Tvalorestrib);
    procedure LerXMLgReeRepRes(const ANode: TACBrXmlNode; gReeRepRes: TgReeRepRes);
    procedure LerXMLdFeNacional(const ANode: TACBrXmlNode; dFeNacional: TdFeNacional);
    procedure LerXMLdocFiscalOutro(const ANode: TACBrXmlNode; docFiscalOutro: TdocFiscalOutro);
    procedure LerXMLdocOutro(const ANode: TACBrXmlNode; docOutro: TdocOutro);
    procedure LerXMLfornec(const ANode: TACBrXmlNode; fornec: Tfornec);

    procedure LerXMLTributos(const ANode: TACBrXmlNode; trib: Ttrib);
    procedure LerXMLgIBSCBS(const ANode: TACBrXmlNode; gIBSCBS: TgIBSCBS);
    procedure LerXMLgTribRegular(const ANode: TACBrXmlNode; gTribRegular: TgTribRegular);
    procedure LerXMLgDif(const ANode: TACBrXmlNode; gDif: TgDif);

    procedure LerXMLIBSCBSNFSe(const ANode: TACBrXmlNode; IBSCBS: TIBSCBSNfse);
    procedure LerXMLValoresIBSCBSNFSe(const ANode: TACBrXmlNode; valores: TvaloresIBSCBS);
    procedure LerXMLUF(const ANode: TACBrXmlNode; uf: TUF);
    procedure LerXMLMun(const ANode: TACBrXmlNode; mun: TMun);
    procedure LerXMLFed(const ANode: TACBrXmlNode; Fed: TFed);

    procedure LerXMLTotCIBS(const ANode: TACBrXmlNode; totCIBS: TtotCIBS);
    procedure LerXMLgTribRegularNFSe(const ANode: TACBrXmlNode; gTribRegular: TgTribRegularNFSe);
    procedure LerXMLgTribCompraGov(const ANode: TACBrXmlNode; gTribCompraGov: TgTribCompraGov);

    procedure LerXMLTotgIBS(const ANode: TACBrXmlNode; gIBS: TgIBS);
    procedure LerXMLgIBSCredPres(const ANode: TACBrXmlNode; gIBSCredPres: TgIBSCredPres);

    procedure LerXMLTotgIBSUFTot(const ANode: TACBrXmlNode; gIBSUFTot: TgIBSUFTot);
    procedure LerXMLTotgIBSMunTot(const ANode: TACBrXmlNode; gIBSMunTot: TgIBSMunTot);

    procedure LerXMLTotgCBS(const ANode: TACBrXmlNode; gCBS: TgCBS);
    procedure LerXMLgCBSCredPres(const ANode: TACBrXmlNode; gCBSCredPres: TgCBSCredPres);

    //====== Ler o Arquivo INI===========================================
    // Reforma Tributária DPS
    procedure LerINIIBSCBS(AINIRec: TMemIniFile; IBSCBS: TIBSCBSDPS);
    procedure LerINIgRefNFSe(AINIRec: TMemIniFile; gRefNFSe: TgRefNFSeCollection);
    procedure LerINIDestinatario(AINIRec: TMemIniFile; Dest: TDadosdaPessoa);
    procedure LerINIImovel(AINIRec: TMemIniFile; Imovel: TDadosimovel);
    procedure LerINIIBSCBSValores(AINIRec: TMemIniFile; Valores: Tvalorestrib);
    procedure LerINIDocumentos(AINIRec: TMemIniFile; Documentos: TdocumentosCollection);
    procedure LerINITributacao(AINIRec: TMemIniFile; Tributacao: Ttrib);
    procedure LerINIgIBSCBS(AINIRec: TMemIniFile; gIBSCBS: TgIBSCBS);
    procedure LerINIgTribRegular(AINIRec: TMemIniFile; gTribRegular: TgTribRegular);
    procedure LerINIgDif(AINIRec: TMemIniFile; gDif: TgDif);
    // Reforma Tributária NFSe
    procedure LerINIIBSCBSNFSe(AINIRec: TMemIniFile; IBSCBS: TIBSCBSNfse);
    procedure LerINIIBSCBSValoresNFSe(AINIRec: TMemIniFile; Valores: TvaloresIBSCBS);
    procedure LerINITotCIBS(AINIRec: TMemIniFile; TotCIBS: TTotCIBS);
    procedure LerINIgTribRegularNFSe(AINIRec: TMemIniFile; gTribRegularNFSe: TgTribRegularNFSe);
    procedure LerINIgTribCompraGov(AINIRec: TMemIniFile; gTribCompraGov: TgTribCompraGov);
    procedure LerINITotgIBS(AINIRec: TMemIniFile; TotgIBS: TgIBS);
    procedure LerINITotgCBS(AINIRec: TMemIniFile; TotgCBS: TgCBS);

    function LerIniRps(AINIRec: TMemIniFile): Boolean;
    function LerIniNfse(AINIRec: TMemIniFile): Boolean;
  public
    constructor Create(AOwner: IACBrNFSeXProvider);
    destructor Destroy; override;

    function LerXml: Boolean; Override;
    function LerIni: Boolean; virtual;

    procedure LerCampoLink;

    property NFSe: TNFSe             read FNFSe     write FNFSe;
    property Provedor: TnfseProvedor read FProvedor write FProvedor;
    property tpXML: TtpXML           read FtpXML    write FtpXML;
    property Ambiente: TACBrTipoAmbiente read FAmbiente write FAmbiente default taHomologacao;
    property IniParams: TMemIniFile read FIniParams write FIniParams;
    property ParamsTab: TStrings read FParamsTab write SetParamsTab;
  end;

implementation

uses
  synautil,
  StrUtils, StrUtilsEx,
  ACBrJSON,
  ACBrUtil.Strings, ACBrUtil.XMLHTML, ACBrUtil.FilesIO,
  ACBrUtil.DateTime,
  ACBrUtil.Base,
  ACBrDFeException,
  ACBrDFeUtil;

{ TNFSeRClass }

procedure TNFSeRClass.Configuracao;
begin
  FpQuebradeLinha := FpAOwner.ConfigGeral.QuebradeLinha;

  FpAOwner.ConfigGeral.ImprimirLocalPrestServ := not FpAOwner.ConfigGeral.Params.TemParametro('NaoImprimirLocalPrestServ');
end;

constructor TNFSeRClass.Create(AOwner: IACBrNFSeXProvider);
begin
  FpAOwner := AOwner;
  FParamsTab := TStringList.Create;

  FIniParamsTab := TMemIniFile.Create('');
  FpIniParamsTabCarregado := False;

  Configuracao;
end;

destructor TNFSeRClass.Destroy;
begin
  FParamsTab.Free;
  FIniParamsTab.Free;
  inherited;
end;

function TNFSeRClass.ItemListaServicoDescricao(const Codigo: string): string;
var
  xCodigo: string;
begin
  xCodigo := OnlyNumber(Codigo);

  if FpAOwner.ConfigGeral.TabServicosExt then
    Result := ObterDescricaoServico(xCodigo)
  else
    Result := LerDescricaoServico(xCodigo);
end;

function TNFSeRClass.LerXml: Boolean;
begin
  Result := False;
  raise EACBrDFeException.Create(ClassName + '.LerXml, não implementado');
end;

function TNFSeRClass.NormatizarAliquota(const Aliquota: Double): Double;
begin
  if Aliquota < 1 then
    Result := Aliquota * 100
  else
    Result := Aliquota;
end;

function TNFSeRClass.NormatizarCodigoMunicipio(const Codigo: string): string;
begin
  if length(Codigo) < 7 then
    Result := Copy(Codigo, 1, 2) +
        FormatFloat('00000', StrToIntDef(Copy(Codigo, 3, 5), 0))
  else
    Result := Codigo;
end;

function TNFSeRClass.NormatizarItemListaServico(const Codigo: string): string;
var
  Item: Integer;
  xCodigo: string;
begin
  Result := Codigo;

  if Length(Codigo) <= 5 then
  begin
    xCodigo := Codigo;

    Item := StrToIntDef(OnlyNumber(xCodigo), 0);
    if Item < 100 then
      Item := Item * 100 + 1;

    xCodigo := FormatFloat('0000', Item);

    Result := Copy(xCodigo, 1, 2) + '.' + Copy(xCodigo, 3, 2);
  end;
end;

function TNFSeRClass.NormatizarXml(const aXml: string): string;
begin
{$IfDef FPC}
  Result := aXml;
{$Else}
  Result := ParseText(aXml);
//  Result := ParseText(aXml, True, False);
  Result := FastStringReplace(Result, '&', '&amp;', [rfReplaceAll]);
{$EndIf}
end;

function TNFSeRClass.ObterNomeMunicipioUF(ACodigoMunicipio: Integer; var xUF: string): string;
var
  CodIBGE: string;
begin
  CodIBGE := IntToStr(ACodigoMunicipio);

  xUF := IniParams.ReadString(CodIBGE, 'UF', '');
  Result := IniParams.ReadString(CodIBGE, 'Nome', '');
end;

procedure TNFSeRClass.SetParamsTab(const Value: TStrings);
begin
  FParamsTab.Assign(Value);
end;

function TNFSeRClass.TipodeXMLLeitura(const aArquivo: string): TtpXML;
var
  aXML: string;
begin
  aXML := RemoverPrefixosDesnecessarios(aArquivo);

  if (Pos('/infnfse>', LowerCase(aXML)) > 0) then
    Result := txmlNFSe
  else
    Result := txmlRPS;
end;

function TNFSeRClass.ExtrairLista(const ADiscriminacao: string): string;
var
  I, LContador: Integer;
  LInicio, LFim: Integer;
  LCaractereInicial, LCaractereFinal: Char;
begin
  Result := EmptyStr;

  if ADiscriminacao = EmptyStr then
    Exit;

  LInicio := 0;
  LCaractereInicial := ' ';
  LCaractereFinal := ' ';

  for I := 1 to Length(ADiscriminacao) do
  begin
    if ADiscriminacao[I] in ['{', '['] then
    begin
      LInicio := I;
      LCaractereInicial := ADiscriminacao[I];
      if LCaractereInicial = '{' then
        LCaractereFinal := '}'
      else
        LCaractereFinal := ']';
      Break;
    end;
  end;

  if LInicio = 0 then
  begin
    Result := ADiscriminacao;
    Exit;
  end;

  LContador := 1;
  LFim := LInicio + 1;
  while (LFim <= Length(ADiscriminacao)) and (LContador > 0) do
  begin
    if ADiscriminacao[LFim] = LCaractereInicial then
      Inc(LContador)
    else if ADiscriminacao[LFim] = LCaractereFinal then
      Dec(LContador);
    Inc(LFim);
  end;

  if LContador = 0 then
    Result := Copy(ADiscriminacao, LInicio, LFim - LInicio)
  else
    Result := ADiscriminacao;
end;

procedure TNFSeRClass.VerificarSeConteudoEhLista(const aDiscriminacao: string);
var
  LDiscriminacao: string;
begin
  FpAOwner.ConfigGeral.DetalharServico := False;

  LDiscriminacao := ExtrairLista(aDiscriminacao);
  if (Pos('[', LDiscriminacao) > 0) and (Pos(']', LDiscriminacao) > 0) and
     (Pos('{', LDiscriminacao) > 0) and (Pos('}', LDiscriminacao) > 0) then
  begin
    FpAOwner.ConfigGeral.DetalharServico := True;

    if Pos('":', LDiscriminacao) > 0 then
      LerListaJson(LDiscriminacao)
    else
      LerListaTabulada(LDiscriminacao);
  end;
end;

function TNFSeRClass.LerLinkURL: string;
var
  LinkNFSeParam: TLinkNFSeParam;
begin
  LinkNFSeParam := TLinkNFSeParam.Create;
  try
    LinkNFSeParam.Ambiente := Integer(FpAOwner.ConfigGeral.Ambiente);
    LinkNFSeParam.ProLinkURL := FpAOwner.ConfigWebServices.Producao.LinkURL;
    LinkNFSeParam.HomLinkURL := FpAOwner.ConfigWebServices.Homologacao.LinkURL;
    LinkNFSeParam.xMunicipio := FpAOwner.ConfigGeral.xMunicipio;

    Result := NFSe.LinkNFSe(LinkNFSeParam);
  finally
    LinkNFSeParam.Free;
  end;
end;

procedure TNFSeRClass.LerListaJson(const aDiscriminacao: string);
var
  xItemServico, xDiscriminacao: string;
  json, jsonItem: TACBrJsonObject;
  i: Integer;
begin
  xDiscriminacao := '{"a": ' + aDiscriminacao + '}';
  Json := TACBrJsonObject.Parse(xDiscriminacao);

  for i := 0 to json.AsJSONArray['a'].Count -1 do
  begin
    jsonItem := json.AsJSONArray['a'].ItemAsJSONObject[i];

    with NFSe.Servico.ItemServico.New do
    begin
      xItemServico := jsonItem.AsString['ItemServico'];

      if xItemServico = '' then
        xItemServico := NFSe.Servico.ItemListaServico;

      ItemListaServico := NormatizarItemListaServico(xItemServico);
      xItemListaServico := ItemListaServicoDescricao(ItemListaServico);
      Descricao := jsonItem.AsString['Descricao'];
      ValorUnitario := jsonItem.AsCurrency['ValorUnitario'];
      Quantidade := jsonItem.AsCurrency['Quantidade'];
      ValorTotal := jsonItem.AsCurrency['ValorTotal'];
      BaseCalculo := jsonItem.AsCurrency['ValorBaseCalculo'];
      Aliquota := jsonItem.AsCurrency['Aliquota'];
      ValorISS := jsonItem.AsCurrency['ValorISS'];

      if ValorTotal = 0 then
        ValorTotal := ValorUnitario * Quantidade;

      if BaseCalculo = 0 then
        BaseCalculo := ValorTotal;

      ValorBCINSS := BaseCalculo;

      if ValorISS = 0 then
        ValorISS := BaseCalculo * Aliquota/100;
    end;
  end;
end;

procedure TNFSeRClass.LerListaTabulada(const aDiscriminacao: string);
var
  xDiscriminacao, xDescricao, xItemServico: string;
  fQuantidade, fValorUnitario, fValorServico, fValorBC, fAliquota,
  fValorISS: Double;
  i, j, Idx: Integer;

  function ExtraiValorCampo(aCampo: string; aCampoNumerico: Boolean): string;
  begin
    i := PosEx(aCampo, xDiscriminacao, j) + Length(aCampo) + 1;

    if i = Length(aCampo) + 1 then
      Result := ''
    else
    begin
      j := PosEx(']', xDiscriminacao, i);
      Result := Copy(xDiscriminacao, i, j-i);

      if aCampoNumerico then
        Result := StringReplace(Result, '.', ',', [rfReplaceAll])
    end;
  end;
begin
  xDiscriminacao := aDiscriminacao;

  if Pos('{[[Descricao={[[Descricao=', xDiscriminacao) > 0 then
    xDiscriminacao := StringReplace(xDiscriminacao, '{[[Descricao={[[Descricao=',
                       '{[[Descricao=', [rfReplaceAll]);

  Idx := Pos(']]}][', xDiscriminacao);
  if Idx > 0 then
    xDiscriminacao := Copy(xDiscriminacao, 1, Idx + 2);

  J := 1;

  while true do
  begin
    xDescricao := ExtraiValorCampo('Descricao', False);

    if xDescricao = '' then
      Break;

    xItemServico := ExtraiValorCampo('ItemServico', False);

    if xItemServico = '' then
      xItemServico := NFSe.Servico.ItemListaServico;

    fQuantidade := StringToFloatDef(ExtraiValorCampo('Quantidade', True), 0);
    fValorUnitario := StringToFloatDef(ExtraiValorCampo('ValorUnitario', True), 0);
    fValorServico := StringToFloatDef(ExtraiValorCampo('ValorServico', True), 0);
    fValorBC := StringToFloatDef(ExtraiValorCampo('ValorBaseCalculo', True), 0);
    fAliquota := StringToFloatDef(ExtraiValorCampo('Aliquota', True), 0);
    fValorISS := StringToFloatDef(ExtraiValorCampo('ValorISS', True), 0);

    with NFSe.Servico.ItemServico.New do
    begin
      Descricao := xDescricao;
      ItemListaServico := NormatizarItemListaServico(xItemServico);
      xItemListaServico := ItemListaServicoDescricao(ItemListaServico);
      Quantidade := fQuantidade;
      ValorUnitario := fValorUnitario;
      ValorTotal := fValorServico;
      Aliquota := fAliquota;
      ValorISS := fValorISS;

      if ValorTotal = 0 then
        ValorTotal := ValorUnitario * Quantidade;

      if fValorBC = 0 then
        fValorBC := ValorTotal;

      ValorBCINSS := fValorBC;
      BaseCalculo := fValorBC;

      if ValorISS = 0 then
        ValorISS := BaseCalculo * Aliquota/100;
    end;
  end;
end;

procedure TNFSeRClass.LerParamsTab;
var
  ConteudoParams: AnsiString;
begin
  ConteudoParams := LerParamsTabIniServicos;

  if ConteudoParams = '' then
    ConteudoParams := LerParamsTabInterno;

  FParamsTab.Text := ConteudoParams;
end;

procedure TNFSeRClass.LerParamsTabIni(ApenasSeNaoLido: Boolean);
begin
  if ApenasSeNaoLido and FpIniParamsTabCarregado then
    exit;

  if ParamsTab.Count = 0 then
    LerParamsTab;

  FIniParamsTab.SetStrings(ParamsTab);
  FpIniParamsTabCarregado := True;
end;

function TNFSeRClass.LerParamsTabIniServicos: AnsiString;
var
  ArqIni: String;
  FS: TFileStream;
begin
  Result := '';
  ArqIni := Trim(FpAOwner.ConfigGeral.IniTabServicos);

  if (ArqIni <> '') and FileExists(ArqIni) then
  begin
    FS := TFileStream.Create(ArqIni, fmOpenRead or fmShareDenyNone);  // Thread Safe
    try
      FS.Position := 0;
      Result := ReadStrFromStream(FS, FS.Size);
    finally
      FS.Free;
    end;
  end;
end;

function TNFSeRClass.LerParamsTabInterno: AnsiString;
var
  RS: TResourceStream;
begin
  Result := '';

  RS := TResourceStream.Create(HInstance, 'TabServicos', RT_RCDATA);
  try
    RS.Position := 0;
    Result := ReadStrFromStream(RS, RS.Size);
  finally
    RS.Free;
  end;
end;

function TNFSeRClass.LerDescricaoServico(const ACodigo: string): string;
begin
  FIniParamsTab.SetStrings(ParamsTab);

  Result := ACBrStr(FIniParamsTab.ReadString(OnlyNumber(ACodigo), 'Descricao', ''));
end;

procedure TNFSeRClass.LerCampoLink;
var
  Link: string;
  i: Integer;

function ExtrairURL(PosIni: Integer; Texto: string): string;
var
  j: Integer;
  Url: string;
begin
  Url := '';
  j := PosIni;

  while (j <= Length(Texto)) and (Texto[j] <> ' ') do
  begin
    Url := Url + Texto[j];
    Inc(j);
  end;

  Result := Url;
end;

begin
  if NFSe.Link = '' then
  begin
    Link := '';

    i := pos('http://', LowerCase(NFSe.OutrasInformacoes));

    if i > 0 then
      Link := ExtrairURL(i, NFSe.OutrasInformacoes)
    else
    begin
      i := pos('https://', LowerCase(NFSe.OutrasInformacoes));

      if i > 0 then
        Link := ExtrairURL(i, NFSe.OutrasInformacoes);
    end;

    if Link = '' then
      Link := LerLinkURL;

    NFSe.Link := Trim(Link);
  end;
end;

function TNFSeRClass.LerIni: Boolean;
var
  INIRec: TMemIniFile;
  TipoXML: string;
begin
  INIRec := TMemIniFile.Create('');

  // Usar o FpAOwner em vez de  FProvider

  try
    LerIniArquivoOuString(Arquivo, INIRec);

    TipoXML := INIRec.ReadString('IdentificacaoNFSe', 'TipoXML', '');

    if (TipoXML = '') or (TipoXML = 'RPS') then
      LerIniRps(INIRec)
    else
      LerIniNfse(INIRec);

  finally
    INIRec.Free;
  end;

  Result := True;
//  Result := False;
//  raise EACBrDFeException.Create(ClassName + '.LerIni, não implementado');
end;

function TNFSeRClass.LerIniNfse(AINIRec: TMemIniFile): Boolean;
begin
  Result := False;
end;

function TNFSeRClass.LerIniRps(AINIRec: TMemIniFile): Boolean;
var
  sSecao, sFim, sData: string;
  Ok: Boolean;
  i: Integer;
  Item: TItemServicoCollectionItem;
  ItemParcelas: TParcelasCollectionItem;
begin
  Result := True;

  with FNFSe do
  begin
    // Provedor Infisc - Layout Proprio
    sSecao := 'IdentificacaoNFSe';
    if AINIRec.SectionExists(sSecao) then
    begin
      Numero := AINIRec.ReadString(sSecao, 'Numero', '');
      cNFSe := GerarCodigoDFe(StrToIntDef(Numero, 0));
      NumeroLote := AINIRec.ReadString(sSecao, 'NumeroLote', '');
      ModeloNFSe := AINIRec.ReadString(sSecao, 'ModeloNFSe', '');
      refNF := AINIRec.ReadString(sSecao, 'refNF', '');
      TipoEmissao := StrToTipoEmissao(Ok, AINIRec.ReadString(sSecao, 'TipoEmissao', 'N'));
      Canhoto := StrToCanhoto(Ok, AINIRec.ReadString(sSecao, 'Canhoto', '0'));
      EmpreitadaGlobal := StrToEmpreitadaGlobal(Ok, AINIRec.ReadString(sSecao, 'EmpreitadaGlobal', '2'));
      CodigoVerificacao := AINIRec.ReadString(sSecao, 'CodigoVerificacao', '');
      SituacaoNFSe := StrToStatusNFSe(Ok, AINIRec.ReadString(sSecao, 'StatusNFSe', ''));
      InfID.ID := AINIRec.ReadString(sSecao, 'ID', '');
      NfseSubstituida := AINIRec.ReadString(sSecao, 'NfseSubstituida', '');
      NfseSubstituidora := AINIRec.ReadString(sSecao, 'NfseSubstituidora', '');
      ValorCredito := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorCredito', ''), 0);
      ChaveAcesso := AINIRec.ReadString(sSecao, 'ChaveAcesso', '');
      Link := AINIRec.ReadString(sSecao, 'Link', '');
      DescricaoCodigoTributacaoMunicipio := AINIRec.ReadString(sSecao, 'DescricaoCodigoTributacaoMunicipio', '');
      Assinatura := AINIRec.ReadString(sSecao, 'Assinatura', '');
      // 1 = True; 2 = False
      Transacao := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'Transacao', '1'));
    end;

    sSecao := 'IdentificacaoRps';
    if AINIRec.SectionExists(sSecao) then
    begin
      SituacaoTrib := FpAOwner.StrToSituacaoTrib(Ok, AINIRec.ReadString(sSecao, 'SituacaoTrib', 'tp'));

      //Provedores CTA, ISSBarueri, ISSSDSF, ISSSaoPaulo, Simple e SmarAPD.
      if AINIRec.ReadString(sSecao, 'TipoTributacaoRPS', 'FIM') <> 'FIM' then
        TipoTributacaoRPS := FpAOwner.StrToTipoTributacaoRPS(Ok, AINIRec.ReadString(sSecao, 'TipoTributacaoRPS', ''));

      // Provedor AssessorPublico
      Situacao := AINIRec.ReadInteger(sSecao, 'Situacao', 0);

      Producao := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'Producao', '1'));
      StatusRps := FpAOwner.StrToStatusRPS(Ok, AINIRec.ReadString(sSecao, 'Status', '1'));
      OutrasInformacoes := AINIRec.ReadString(sSecao, 'OutrasInformacoes', '');
      OutrasInformacoes := StringReplace(OutrasInformacoes, FpAOwner.ConfigGeral.QuebradeLinha, sLineBreak, [rfReplaceAll]);

      // Provedores: Infisc, ISSDSF e Siat
      SeriePrestacao := AINIRec.ReadString(sSecao, 'SeriePrestacao', '');

      IdentificacaoRemessa := AINIRec.ReadString(sSecao, 'IdentificacaoRemessa', '');
      IdentificacaoRps.Numero := AINIRec.ReadString(sSecao, 'Numero', '0');
      IdentificacaoRps.Serie := AINIRec.ReadString(sSecao, 'Serie', '0');
      IdentificacaoRps.Tipo := FpAOwner.StrToTipoRPS(Ok, AINIRec.ReadString(sSecao, 'Tipo', '1'));

      sData := AINIRec.ReadString(sSecao, 'DataEmissao', '');
      if sData <> '' then
        DataEmissao := StringToDateTimeDef(sData, 0);

      sData := AINIRec.ReadString(sSecao, 'Competencia', '');
      if sData <> '' then
        Competencia := StringToDateTimeDef(sData, 0);

      sData := AINIRec.ReadString(sSecao, 'DataEmissaoRps', '');
      if sData <> '' then
        DataEmissaoRps := StringToDateTimeDef(sData, 0)
      else
        DataEmissaoRPS := DataEmissao;

      sData := AINIRec.ReadString(sSecao, 'Vencimento', '');
      if sData <> '' then
        Vencimento := StringToDateTimeDef(sData, 0);

      sData := AINIRec.ReadString(sSecao, 'DataPagamento', '');
      if sData <> '' then
        DataPagamento := StringToDateTimeDef(sData, 0);

      sData := AINIRec.ReadString(sSecao, 'dhRecebimento', '');
      if sData <> '' then
        dhRecebimento := StringToDateTimeDef(sData, 0);

      NaturezaOperacao := StrToNaturezaOperacao(Ok, AINIRec.ReadString(sSecao, 'NaturezaOperacao', '0'));

      // Provedor Tecnos
      PercentualCargaTributaria := StringToFloatDef(AINIRec.ReadString(sSecao, 'PercentualCargaTributaria', ''), 0);
      ValorCargaTributaria := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorCargaTributaria', ''), 0);
      PercentualCargaTributariaMunicipal := StringToFloatDef(AINIRec.ReadString(sSecao, 'PercentualCargaTributariaMunicipal', ''), 0);
      ValorCargaTributariaMunicipal := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorCargaTributariaMunicipal', ''), 0);
      PercentualCargaTributariaEstadual := StringToFloatDef(AINIRec.ReadString(sSecao, 'PercentualCargaTributariaEstadual', ''), 0);
      ValorCargaTributariaEstadual := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorCargaTributariaEstadual', ''), 0);

      // Provedor PadraoNacional
      verAplic := AINIRec.ReadString(sSecao, 'verAplic', 'ACBrNFSeX-1.00');
      tpEmit := StrTotpEmit(Ok, AINIRec.ReadString(sSecao, 'tpEmit', '1'));

      // Provedor Governa
      RegRec := StrToRegRec(Ok, AINIRec.ReadString(sSecao, 'RegRec', ''));
      // Provedor Governa e Prescon
      FrmRec := StrToFrmRec(Ok, AINIRec.ReadString(sSecao, 'FrmRec', ''));

      InformacoesComplementares := AINIRec.ReadString(sSecao, 'InformacoesComplementares', '');

      EqptoRecibo := AINIRec.ReadString(sSecao, 'EqptoRecibo', '');
      TipoRecolhimento := AINIRec.ReadString(sSecao, 'TipoRecolhimento', '');
      TipoNota := AINIRec.ReadInteger(sSecao, 'TipoNota', 0);
      // Provedor Tecnos
      SiglaUF := AINIRec.ReadString(sSecao, 'SiglaUF', '');
      EspecieDocumento := AINIRec.ReadInteger(sSecao, 'EspecieDocumento', 0);
      SerieTalonario := AINIRec.ReadInteger(sSecao, 'SerieTalonario', 0);
      FormaPagamento := AINIRec.ReadInteger(sSecao, 'FormaPagamento', 0);
      NumeroParcelas := AINIRec.ReadInteger(sSecao, 'NumeroParcelas', 0);
      id_sis_legado := AINIRec.ReadInteger(sSecao, 'id_sis_legado', 0);
      DeducaoMateriais := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'DeducaoMateriais', ''));
    end;

    sSecao := 'RpsSubstituido';
    if AINIRec.SectionExists(sSecao) then
    begin
      RpsSubstituido.Numero := AINIRec.ReadString(sSecao, 'Numero', '');
      RpsSubstituido.Serie := AINIRec.ReadString(sSecao, 'Serie', '');
      RpsSubstituido.Tipo := FpAOwner.StrToTipoRPS(Ok, AINIRec.ReadString(sSecao, 'Tipo', '1'));
    end;

    sSecao := 'NFSeSubstituicao';
    if AINIRec.SectionExists(sSecao) then
    begin
      subst.chSubstda := AINIRec.ReadString(sSecao, 'chSubstda', '');
      subst.cMotivo := StrTocMotivo(Ok, AINIRec.ReadString(sSecao, 'cMotivo', ''));
      subst.xMotivo := AINIRec.ReadString(sSecao, 'xMotivo', '');
    end;

    sSecao := 'NFSeCancelamento';
    if AINIRec.SectionExists(sSecao) then
    begin
      MotivoCancelamento := AINIRec.ReadString(sSecao, 'MotivoCancelamento', '');
      JustificativaCancelamento := AINIRec.ReadString(sSecao, 'JustificativaCancelamento', '');
      CodigoCancelamento := AINIRec.ReadString(sSecao, 'CodigoCancelamento', '');
      NFSeCancelamento.Pedido.IdentificacaoNfse.Numero := AINIRec.ReadString(sSecao, 'NumeroNFSe', '');
      NfseCancelamento.Pedido.IdentificacaoNfse.Cnpj := AINIRec.ReadString(sSecao, 'CNPJ', '');
      NFSeCancelamento.Pedido.IdentificacaoNfse.InscricaoMunicipal := AINIRec.ReadString(sSecao, 'InscricaoMunicipal', '');
      NFSeCancelamento.Pedido.IdentificacaoNfse.CodigoMunicipio := AINIRec.ReadString(sSecao, 'CodigoMunicipio', '');
      NfseCancelamento.Pedido.CodigoCancelamento := AINIRec.ReadString(sSecao, 'CodCancel', '');
      NFSeCancelamento.Sucesso := AINIRec.ReadBool(sSecao, 'Sucesso', True);
      NfSeCancelamento.DataHora := AINIRec.ReadDateTime(sSecao, 'DataHora', 0);
    end;

    sSecao := 'Prestador';
    if AINIRec.SectionExists(sSecao) then
    begin
      RegimeEspecialTributacao := FpAOwner.StrToRegimeEspecialTributacao(Ok, AINIRec.ReadString(sSecao, 'Regime', '0'));
      OptanteSimplesNacional := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'OptanteSN', '1'));
      OptanteSN := StrToOptanteSN(Ok, AINIRec.ReadString(sSecao, 'opSimpNac', '2'));
      OptanteMEISimei := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'OptanteMEISimei', ''));
      DataOptanteSimplesNacional := AINIRec.ReadDateTime(sSecao, 'DataOptanteSimplesNacional', 0);

      IncentivadorCultural := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'IncentivadorCultural', '1'));

      if AINIRec.ReadString(sSecao, 'RegimeApuracaoSN', '') <> '' then
        RegimeApuracaoSN := StrToRegimeApuracaoSN(Ok, AINIRec.ReadString(sSecao, 'RegimeApuracaoSN', '1'));

      Prestador.IdentificacaoPrestador.CpfCnpj := AINIRec.ReadString(sSecao, 'CNPJ', '');
      Prestador.IdentificacaoPrestador.InscricaoMunicipal := AINIRec.ReadString(sSecao, 'InscricaoMunicipal', '');
      Prestador.IdentificacaoPrestador.InscricaoEstadual := AINIRec.ReadString(sSecao, 'InscricaoEstadual', '');

      Prestador.IdentificacaoPrestador.Nif := AINIRec.ReadString(sSecao, 'NIF', '');
      Prestador.IdentificacaoPrestador.cNaoNIF := StrToNaoNIF(Ok, AINIRec.ReadString(sSecao, 'cNaoNIF', '0'));
      Prestador.IdentificacaoPrestador.CAEPF := AINIRec.ReadString(sSecao, 'CAEPF', '');
      Prestador.IdentificacaoPrestador.Tipo := FpAOwner.StrToTipoPessoa(Ok, AINIRec.ReadString(sSecao, 'TipoPessoa', ''));

      // Para o provedor ISSDigital deve-se informar também:
      Prestador.cUF := UFparaCodigoUF(AINIRec.ReadString(sSecao, 'UF', 'SP'));

      Prestador.crc := AINIRec.ReadString(sSecao, 'crc', '');
      Prestador.crc_estado := AINIRec.ReadString(sSecao, 'crc_estado', '');

      Prestador.RazaoSocial := AINIRec.ReadString(sSecao, 'RazaoSocial', '');
      Prestador.NomeFantasia := AINIRec.ReadString(sSecao, 'NomeFantasia', '');

      Prestador.Endereco.TipoLogradouro := AINIRec.ReadString(sSecao, 'TipoLogradouro', '');
      Prestador.Endereco.Endereco := AINIRec.ReadString(sSecao, 'Logradouro', '');
      Prestador.Endereco.Numero := AINIRec.ReadString(sSecao, 'Numero', '');
      Prestador.Endereco.Complemento := AINIRec.ReadString(sSecao, 'Complemento', '');
      Prestador.Endereco.Bairro := UTF8ToNativeString(AINIRec.ReadString(sSecao, 'Bairro', ''));
      Prestador.Endereco.CodigoMunicipio := AINIRec.ReadString(sSecao, 'CodigoMunicipio', '');
      Prestador.Endereco.xMunicipio := AINIRec.ReadString(sSecao, 'xMunicipio', '');
      Prestador.Endereco.UF := AINIRec.ReadString(sSecao, 'UF', '');
      Prestador.Endereco.CodigoPais := AINIRec.ReadInteger(sSecao, 'CodigoPais', 0);
      Prestador.Endereco.xPais := AINIRec.ReadString(sSecao, 'xPais', '');
      Prestador.Endereco.CEP := AINIRec.ReadString(sSecao, 'CEP', '');

      Prestador.Contato.DDD := AINIRec.ReadString(sSecao, 'DDD', '');
      Prestador.Contato.Telefone := AINIRec.ReadString(sSecao, 'Telefone', '');
      Prestador.Contato.Email := AINIRec.ReadString(sSecao, 'Email', '');
      Prestador.Contato.xSite := AINIRec.ReadString(sSecao, 'xSite', '');

      // Para o provedor WebFisco
      Prestador.Anexo := AINIRec.ReadString(sSecao, 'Anexo', '');
      Prestador.ValorReceitaBruta := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorReceitaBruta', ''), 0);
      Prestador.DataInicioAtividade := StringToDateTimeDef(AINIRec.ReadString(sSecao, 'DataInicioAtividade', ''), 0);
    end;

    sSecao := 'Tomador';
    if AINIRec.SectionExists(sSecao) then
    begin
      Tomador.IdentificacaoTomador.Tipo := FpAOwner.StrToTipoPessoa(Ok, AINIRec.ReadString(sSecao, 'Tipo', '1'));
      Tomador.IdentificacaoTomador.CpfCnpj := AINIRec.ReadString(sSecao, 'CNPJCPF', '');
      Tomador.IdentificacaoTomador.InscricaoMunicipal := AINIRec.ReadString(sSecao, 'InscricaoMunicipal', '');
      Tomador.IdentificacaoTomador.InscricaoEstadual := AINIRec.ReadString(sSecao, 'InscricaoEstadual', '');

      Tomador.IdentificacaoTomador.Nif := AINIRec.ReadString(sSecao, 'NIF', '');
      Tomador.IdentificacaoTomador.cNaoNIF := StrToNaoNIF(Ok, AINIRec.ReadString(sSecao, 'cNaoNIF', '0'));
      Tomador.IdentificacaoTomador.CAEPF := AINIRec.ReadString(sSecao, 'CAEPF', '');
      Tomador.IdentificacaoTomador.DocEstrangeiro := AINIRec.ReadString(sSecao, 'DocEstrangeiro', '');

      Tomador.RazaoSocial := AINIRec.ReadString(sSecao, 'RazaoSocial', '');
      Tomador.NomeFantasia := AINIRec.ReadString(sSecao, 'NomeFantasia', '');

      Tomador.Endereco.EnderecoInformado := FpAOwner.StrToSimNaoOpc(Ok, AINIRec.ReadString(sSecao, 'EnderecoInformado', ''));
      Tomador.Endereco.TipoLogradouro := AINIRec.ReadString(sSecao, 'TipoLogradouro', '');
      Tomador.Endereco.Endereco := AINIRec.ReadString(sSecao, 'Logradouro', '');
      Tomador.Endereco.Numero := AINIRec.ReadString(sSecao, 'Numero', '');
      Tomador.Endereco.Complemento := AINIRec.ReadString(sSecao, 'Complemento', '');
      Tomador.Endereco.PontoReferencia := AINIRec.ReadString(sSecao, 'PontoReferencia', '');
      Tomador.Endereco.Bairro := AINIRec.ReadString(sSecao, 'Bairro', '');
      Tomador.Endereco.TipoBairro := AINIRec.ReadString(sSecao, 'TipoBairro', '');
      Tomador.Endereco.CodigoMunicipio := AINIRec.ReadString(sSecao, 'CodigoMunicipio', '');
      Tomador.Endereco.xMunicipio := AINIRec.ReadString(sSecao, 'xMunicipio', '');
      Tomador.Endereco.UF := AINIRec.ReadString(sSecao, 'UF', '');
      Tomador.Endereco.CodigoPais := AINIRec.ReadInteger(sSecao, 'CodigoPais', 0);
      Tomador.Endereco.CEP := AINIRec.ReadString(sSecao, 'CEP', '');
      // Provedor Equiplano é obrigatório o pais e IE
      Tomador.Endereco.xPais := AINIRec.ReadString(sSecao, 'xPais', '');

      Tomador.Contato.DDD := AINIRec.ReadString(sSecao, 'DDD', '');
      Tomador.Contato.TipoTelefone := AINIRec.ReadString(sSecao, 'TipoTelefone', '');
      Tomador.Contato.Telefone := AINIRec.ReadString(sSecao, 'Telefone', '');
      Tomador.Contato.Email := AINIRec.ReadString(sSecao, 'Email', '');

      Tomador.AtualizaTomador := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'AtualizaTomador', '1'));
      Tomador.TomadorExterior := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'TomadorExterior', '2'));
    end;

    sSecao := 'Intermediario';
    if AINIRec.SectionExists(sSecao)then
    begin
      Intermediario.Identificacao.CpfCnpj := AINIRec.ReadString(sSecao, 'CNPJCPF', '');
      Intermediario.Identificacao.InscricaoMunicipal := AINIRec.ReadString(sSecao, 'InscricaoMunicipal', '');
      Intermediario.Identificacao.Nif := AINIRec.ReadString(sSecao, 'NIF', '');
      Intermediario.Identificacao.cNaoNIF := StrToNaoNIF(Ok, AINIRec.ReadString(sSecao, 'cNaoNIF', '0'));
      Intermediario.Identificacao.CAEPF := AINIRec.ReadString(sSecao, 'CAEPF', '');

      Intermediario.IssRetido := FpAOwner.StrToSituacaoTributaria(Ok, AINIRec.ReadString(sSecao, 'IssRetido', ''));
      Intermediario.RazaoSocial := AINIRec.ReadString(sSecao, 'RazaoSocial', '');

      Intermediario.Endereco.CodigoMunicipio := AINIRec.ReadString(sSecao, 'CodigoMunicipio', '');
      Intermediario.Endereco.CEP := AINIRec.ReadString(sSecao, 'CEP', '');
      Intermediario.Endereco.CodigoPais := AINIRec.ReadInteger(sSecao, 'CodigoPais', 0);
      Intermediario.Endereco.xMunicipio := AINIRec.ReadString(sSecao, 'xMunicipio', '');
      Intermediario.Endereco.UF := AINIRec.ReadString(sSecao, 'UF', '');
      Intermediario.Endereco.Endereco := AINIRec.ReadString(sSecao, 'Logradouro', '');
      Intermediario.Endereco.Numero := AINIRec.ReadString(sSecao, 'Numero', '');
      Intermediario.Endereco.Complemento := AINIRec.ReadString(sSecao, 'Complemento', '');
      Intermediario.Endereco.Bairro := AINIRec.ReadString(sSecao, 'Bairro', '');

      Intermediario.Contato.Telefone := AINIRec.ReadString(sSecao, 'Telefone', '');
      Intermediario.Contato.Email := AINIRec.ReadString(sSecao, 'Email', '');
    end;

    //SmarAPD, Infisc.
    sSecao := 'Transportadora';
    if AINIRec.SectionExists(sSecao) then
    begin
      Transportadora.xNomeTrans := AINIRec.ReadString(sSecao, 'xNomeTrans', '');
      Transportadora.xCpfCnpjTrans := AINIRec.ReadString(sSecao, 'xCpfCnpjTrans', '');
      Transportadora.xInscEstTrans := AINIRec.ReadString(sSecao, 'xInscEstTrans', '');
      Transportadora.xPlacaTrans := AINIRec.ReadString(sSecao, 'xPlacaTrans', '');
      Transportadora.xEndTrans := AINIRec.ReadString(sSecao, 'xEndTrans', '');
      Transportadora.cMunTrans := AINIRec.ReadInteger(sSecao, 'cMunTrans', 0);
      Transportadora.xMunTrans := AINIRec.ReadString(sSecao, 'xMunTrans', '');
      Transportadora.xUFTrans := AINIRec.ReadString(sSecao, 'xUFTrans', '');
      Transportadora.xPaisTrans := AINIRec.ReadString(sSecao, 'xPaisTrans', '');
      Transportadora.vTipoFreteTrans := StrToTipoFrete(Ok, AINIRec.ReadString(sSecao, 'vTipoFreteTrans', ''));
    end;

    sSecao := 'ConstrucaoCivil';
    if AINIRec.SectionExists(sSecao) then
    begin
      ConstrucaoCivil.CodigoObra := AINIRec.ReadString(sSecao, 'CodigoObra', '');
      ConstrucaoCivil.Art := AINIRec.ReadString(sSecao, 'Art', '');
      ConstrucaoCivil.inscImobFisc := AINIRec.ReadString(sSecao, 'inscImobFisc', '');
      ConstrucaoCivil.nCei := AINIRec.ReadString(sSecao, 'nCei', '');
      ConstrucaoCivil.nProj := AINIRec.ReadString(sSecao, 'nProj', '');
      ConstrucaoCivil.nMatri := AINIRec.ReadString(sSecao, 'nMatri', '');
      ConstrucaoCivil.nNumeroEncapsulamento := AINIRec.ReadString(sSecao, 'nNumeroEncapsulamento', '');

      ConstrucaoCivil.Endereco.CEP := AINIRec.ReadString(sSecao, 'CEP', '');
      ConstrucaoCivil.Endereco.xMunicipio := AINIRec.ReadString(sSecao, 'xMunicipio', '');
      ConstrucaoCivil.Endereco.UF := AINIRec.ReadString(sSecao, 'UF', '');
      ConstrucaoCivil.Endereco.Endereco := AINIRec.ReadString(sSecao, 'Logradouro', '');
      ConstrucaoCivil.Endereco.Numero := AINIRec.ReadString(sSecao, 'Numero', '');
      ConstrucaoCivil.Endereco.Complemento := AINIRec.ReadString(sSecao, 'Complemento', '');
      ConstrucaoCivil.Endereco.Bairro := AINIRec.ReadString(sSecao, 'Bairro', '');
    end;

    sSecao := 'Servico';
    if AINIRec.SectionExists(sSecao) then
    begin
      Servico.ItemListaServico := AINIRec.ReadString(sSecao, 'ItemListaServico', '');
      Servico.xItemListaServico := AINIRec.ReadString(sSecao, 'xItemListaServico', '');
      Servico.CodigoCnae := AINIRec.ReadString(sSecao, 'CodigoCnae', '');
      Servico.CodigoTributacaoMunicipio := AINIRec.ReadString(sSecao, 'CodigoTributacaoMunicipio', '');
      Servico.xCodigoTributacaoMunicipio := AINIRec.ReadString(sSecao, 'xCodigoTributacaoMunicipio', '');
      Servico.Discriminacao := AINIRec.ReadString(sSecao, 'Discriminacao', '');
      Servico.Discriminacao := StringReplace(Servico.Discriminacao, FpAOwner.ConfigGeral.QuebradeLinha, sLineBreak, [rfReplaceAll]);
      Servico.Descricao := AINIRec.ReadString(sSecao, 'Descricao', '');
      Servico.Descricao := StringReplace(Servico.Descricao, FpAOwner.ConfigGeral.QuebradeLinha, sLineBreak, [rfReplaceAll]);
      Servico.CodigoMunicipio := AINIRec.ReadString(sSecao, 'CodigoMunicipio', '');
      Servico.CodigoPais := AINIRec.ReadInteger(sSecao, 'CodigoPais', 0);
      Servico.xPais := AINIRec.ReadString(sSecao, 'xPais', '');
      Servico.ExigibilidadeISS := FpAOwner.StrToExigibilidadeISS(Ok, AINIRec.ReadString(sSecao, 'ExigibilidadeISS', '1'));
      Servico.IdentifNaoExigibilidade := AINIRec.ReadString(sSecao, 'IdentifNaoExigibilidade', '');
      Servico.MunicipioIncidencia := AINIRec.ReadInteger(sSecao, 'MunicipioIncidencia', 0);
      Servico.xMunicipioIncidencia := AINIRec.ReadString(sSecao, 'xMunicipioIncidencia', '');
      Servico.NumeroProcesso := AINIRec.ReadString(sSecao, 'NumeroProcesso', '');
      Servico.MunicipioPrestacaoServico := AINIRec.ReadString(sSecao, 'MunicipioPrestacaoServico', '');
      if Trim(Servico.MunicipioPrestacaoServico) <> '' then
        FpAOwner.ConfigGeral.ImprimirLocalPrestServ := True
      else
        FpAOwner.ConfigGeral.ImprimirLocalPrestServ := False;
      Servico.UFPrestacao := AINIRec.ReadString(sSecao, 'UFPrestacao', '');
      Servico.ResponsavelRetencao := FpAOwner.StrToResponsavelRetencao(Ok, AINIRec.ReadString(sSecao, 'ResponsavelRetencao', ''));
      Servico.TipoLancamento := StrToTipoLancamento(Ok, AINIRec.ReadString(sSecao, 'TipoLancamento', 'P'));

      // Provedor ISSDSF
      Servico.Operacao := StrToOperacao(Ok, AINIRec.ReadString(sSecao, 'Operacao', ''));
      Servico.Tributacao := FpAOwner.StrToTributacao(Ok, AINIRec.ReadString(sSecao, 'Tributacao', ''));
      // Provedor ISSSaoPaulo
      Servico.ValorTotalRecebido := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorTotalRecebido', ''), 0);
      Servico.ValorCargaTributaria := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorCargaTributaria', ''), 0);
      Servico.PercentualCargaTributaria := StringToFloatDef(AINIRec.ReadString(sSecao, 'PercentualCargaTributaria', ''), 0);
      Servico.FonteCargaTributaria := AINIRec.ReadString(sSecao, 'FonteCargaTributaria', '');

      // Provedor IssNet e Padrão Nacional
      Servico.CodigoNBS := AINIRec.ReadString(sSecao, 'CodigoNBS', '');
      Servico.CodigoInterContr := AINIRec.ReadString(sSecao, 'CodigoInterContr', '');

      // Provedor SoftPlan
      Servico.CFPS := AINIRec.ReadString(sSecao, 'CFPS', '');

      // Provedor Giap Informações sobre o Endereço da Prestação de Serviço
      Servico.Endereco.Bairro := AINIRec.ReadString(sSecao, 'Bairro', '');
      Servico.Endereco.CEP := AINIRec.ReadString(sSecao, 'CEP', '');
      Servico.Endereco.xMunicipio := AINIRec.ReadString(sSecao, 'xMunicipio', '');
      Servico.Endereco.Complemento := AINIRec.ReadString(sSecao, 'Complemento', '');
      Servico.Endereco.Endereco := AINIRec.ReadString(sSecao, 'Logradouro', '');
      Servico.Endereco.Numero := AINIRec.ReadString(sSecao, 'Numero', '');
      Servico.Endereco.xPais := AINIRec.ReadString(sSecao, 'xPais', '');
      Servico.Endereco.UF := AINIRec.ReadString(sSecao, 'UF', '');

      // Provedor ISSBarueri
      Servico.LocalPrestacao := StrToLocalPrestacao(Ok, AINIRec.ReadString(sSecao, 'LocalPrestacao', '1'));
      Servico.PrestadoEmViasPublicas := AINIRec.ReadBool(sSecao, 'PrestadoEmViasPublicas', True);

      // Provedor Megasoft
      Servico.InfAdicional := AINIRec.ReadString(sSecao, 'InfAdicional', '');

      // Provedor SigISSWeb
      Servico.xFormaPagamento := AINIRec.ReadString(sSecao, 'xFormaPagamento', '');

      // Provedor ISSSalvador
      Servico.cClassTrib := AINIRec.ReadString(sSecao, 'cClassTrib', '');
      Servico.INDOP := AINIRec.ReadString(sSecao, 'INDOP', '');
    end;

    i := 1;
    while true do
    begin
      sSecao := 'Deducoes' + IntToStrZero(I + 1, 3);
      sFim := AINIRec.ReadString(sSecao, 'ValorDeduzir', 'FIM');
      if (Length(sFim) <= 0) or (sFim = 'FIM') then
        break;

      with Servico.Deducao.New do
      begin
        DeducaoPor := FpAOwner.StrToDeducaoPor(Ok, AINIRec.ReadString(sSecao, 'DeducaoPor', ''));
        TipoDeducao := FpAOwner.StrToTipoDeducao(Ok, AINIRec.ReadString(sSecao, 'TipoDeducao', ''));
        CpfCnpjReferencia := AINIRec.ReadString(sSecao, 'CpfCnpjReferencia', '');
        NumeroNFReferencia := AINIRec.ReadString(sSecao, 'NumeroNFReferencia', '');
        ValorTotalReferencia := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorTotalReferencia', ''), 0);
        PercentualDeduzir := StringToFloatDef(AINIRec.ReadString(sSecao, 'PercentualDeduzir', ''), 0);
        ValorDeduzir := StringToFloatDef(sFim, 0);
      end;

      Inc(i);
    end;

    i := 1;
    while true do
    begin
      sSecao := 'Impostos' + IntToStrZero(I + 1, 3);
      sFim := AINIRec.ReadString(sSecao, 'Valor', 'FIM');

      if (Length(sFim) <= 0) or (sFim = 'FIM') then
        break;

      with Servico.Imposto.New do
      begin
        Codigo := AINIRec.ReadInteger(sSecao, 'Codigo', 0);
        Descricao := AINIRec.ReadString(sSecao, 'Descricao', '');
        Aliquota := StringToFloatDef(AINIRec.ReadString(sSecao, 'Aliquota', ''), 0);
        Valor := StringToFloatDef(sFim, 0);
      end;
      Inc(i);
    end;

    //Infisc
    i := 1;
    while true do
    begin
      sSecao := 'Despesas' + IntToStrZero(I + 1, 3);
      sFim := AINIRec.ReadString(sSecao, 'vDesp', 'FIM');

      if (Length(sFim) <= 0) or (sFim='FIM') then
        break;

      with Despesa.New do
      begin
        nItemDesp := AINIRec.ReadString(sSecao, 'nItemDesp', '');
        xDesp := AINIRec.ReadString(sSecao, 'xDesp', '');
        dDesp := AINIRec.ReadDateTime(sSecao, 'dDesp', 0);
        vDesp := StringToFloatDef(sFim, 0);
      end;

      Inc(i);
    end;

    i := 1;
    while true do
    begin
      sSecao := 'Genericos' + IntToStrZero(I + 1, 1);
      if not AINIRec.SectionExists(sSecao) then
        break;

      with Genericos.New do
      begin
        Titulo := AINIRec.ReadString(sSecao, 'Titulo', '');
        Descricao := AINIRec.ReadString(sSecao, 'Descricao', '');
      end;

      Inc(i);
    end;

    i := 1;
    while true do
    begin
      sSecao := 'Quartos' + IntToStrZero(i, 3);
      sFim := AINIRec.ReadString(sSecao, 'CodigoInternoQuarto', 'FIM');

      if(Length(sFim) <= 0) or (sFim = 'FIM')then
        break;

      with Quartos.New do
      begin
        CodigoInternoQuarto := StrToIntDef(sFim, 0);
        QtdHospedes := AINIRec.ReadInteger(sSecao, 'QtdHospedes', 0);
        CheckIn := AINIRec.ReadDateTime(sSecao, 'CheckIn', 0);
        QtdDiarias := AINIRec.ReadInteger(sSecao, 'QtdDiarias', 0);
        ValorDiaria := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorDiaria', ''), 0);
      end;

      Inc(i);
    end;

    i := 1;
    while true do
    begin
      sSecao := 'Itens' + IntToStrZero(i, 3);
      sFim := AINIRec.ReadString(sSecao, 'Descricao'  ,'FIM');

      if (sFim = 'FIM') then
        break;

      Item := Servico.ItemServico.New;

      Item.Descricao := StringReplace(sFim, FpAOwner.ConfigGeral.QuebradeLinha, sLineBreak, [rfReplaceAll]);
      Item.ItemListaServico := AINIRec.ReadString(sSecao, 'ItemListaServico', '');
      Item.xItemListaServico := AINIRec.ReadString(sSecao, 'xItemListaServico', '');
      Item.CodServ := AINIRec.ReadString(sSecao, 'CodServico', '');
      Item.codLCServ := AINIRec.ReadString(sSecao, 'codLCServico', '');
      Item.CodigoCnae := AINIRec.ReadString(sSecao, 'CodigoCnae', '');

      Item.TipoUnidade := StrToUnidade(Ok, AINIRec.ReadString(sSecao, 'TipoUnidade', '2'));
      Item.Unidade := AINIRec.ReadString(sSecao, 'Unidade', '');
      Item.Quantidade := StringToFloatDef(AINIRec.ReadString(sSecao, 'Quantidade', ''), 0);
      Item.ValorUnitario := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorUnitario', ''), 0);

      Item.QtdeDiaria := StringToFloatDef(AINIRec.ReadString(sSecao, 'QtdeDiaria', ''), 0);
      Item.ValorTaxaTurismo := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorTaxaTurismo', ''), 0);

      Item.ValorDeducoes := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorDeducoes', ''), 0);
      Item.xJustDeducao := AINIRec.ReadString(sSecao, 'xJustDeducao', '');

      Item.AliqReducao := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliqReducao', ''), 0);
      Item.ValorReducao := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorReducao', ''), 0);

      Item.ValorISS := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorISS', ''), 0);
      Item.Aliquota := StringToFloatDef(AINIRec.ReadString(sSecao, 'Aliquota', ''), 0);
      Item.BaseCalculo := StringToFloatDef(AINIRec.ReadString(sSecao, 'BaseCalculo', ''), 0);
      Item.DescontoIncondicionado := StringToFloatDef(AINIRec.ReadString(sSecao, 'DescontoIncondicionado', ''), 0);
      Item.DescontoCondicionado := StringToFloatDef(AINIRec.ReadString(sSecao, 'DescontoCondicionado', ''), 0);

      Item.AliqISSST := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliqISSST', ''), 0);
      Item.ValorISSST := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorISSST', ''), 0);

      Item.ValorBCCSLL := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorBCCSLL', ''), 0);
      Item.AliqRetCSLL := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliqRetCSLL', ''), 0);
      Item.ValorCSLL := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorCSLL', ''), 0);

      Item.ValorBCPIS := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorBCPIS', ''), 0);
      Item.AliqRetPIS := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliqRetPIS', ''), 0);
      Item.ValorPIS := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorPIS', ''), 0);

      Item.ValorBCCOFINS := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorBCCOFINS', ''), 0);
      Item.AliqRetCOFINS := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliqRetCOFINS', ''), 0);
      Item.ValorCOFINS := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorCOFINS', ''), 0);

      Item.ValorBCINSS := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorBCINSS', ''), 0);
      Item.AliqRetINSS := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliqRetINSS', ''), 0);
      Item.ValorINSS := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorINSS', ''), 0);

      Item.ValorBCRetIRRF := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorBCRetIRRF', ''), 0);
      Item.AliqRetIRRF := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliqRetIRRF', ''), 0);
      Item.ValorIRRF := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorIRRF', ''), 0);

      Item.ValorTotal := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorTotal', ''), 0);

      Item.Tributavel := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'Tributavel', '1'));

      // IPM
      Item.TribMunPrestador := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'TribMunPrestador', '1'));
      Item.CodMunPrestacao := AINIRec.ReadString(sSecao, 'CodMunPrestacao', '');
      Item.SituacaoTributaria := AINIRec.ReadInteger(sSecao, 'SituacaoTributaria', 0);
      Item.ValorISSRetido := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorISSRetido', ''), 0);
      Item.ValorTributavel := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorTributavel', ''), 0);
      Item.CodCNO := AINIRec.ReadString(sSecao, 'CodCNO', '');

      Item.idCnae := AINIRec.ReadString(sSecao, 'idCnae', '');

      // Provedor Infisc
      Item.totalAproxTribServ := StringToFloatDef(AINIRec.ReadString(sSecao, 'totalAproxTribServ', ''), 0);

      sSecao := 'DadosDeducao' + IntToStrZero(I + 1, 3);
      if AINIRec.SectionExists(sSecao) then
      begin
        Item.DadosDeducao.TipoDeducao := FpAOwner.StrToTipoDeducao(Ok, AINIRec.ReadString(sSecao, 'TipoDeducao', ''));
        Item.DadosDeducao.CpfCnpj := AINIRec.ReadString(sSecao, 'CpfCnpj', '');
        Item.DadosDeducao.NumeroNotaFiscalReferencia := AINIRec.ReadString(sSecao, 'NumeroNotaFiscalReferencia', '');
        Item.DadosDeducao.ValorTotalNotaFiscal := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorTotalNotaFiscal', ''), 0);
        Item.DadosDeducao.PercentualADeduzir := StringToFloatDef(AINIRec.ReadString(sSecao, 'PercentualADeduzir', ''), 0);
        Item.DadosDeducao.ValorADeduzir := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorADeduzir', ''), 0);
      end;

      Inc(i);
    end;

    sSecao := 'Valores';
    if AINIRec.SectionExists(sSecao) then
    begin
      Servico.Valores.ValorServicos := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorServicos', ''), 0);
      Servico.Valores.ValorDeducoes := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorDeducoes', ''), 0);
      Servico.Valores.AliquotaDeducoes := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliquotaDeducoes', ''), 0);
      Servico.Valores.JustificativaDeducao := AINIRec.ReadString(sSecao, 'JustificativaDeducao', '');

      Servico.Valores.ValorPis := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorPis', ''), 0);
      Servico.Valores.AliquotaPis := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliquotaPis', ''), 0);
      Servico.Valores.RetidoPis := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'RetidoPis', ''));

      Servico.Valores.ValorCofins := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorCofins', ''), 0);
      Servico.Valores.AliquotaCofins := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliquotaCofins', ''), 0);
      Servico.Valores.RetidoCofins := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'RetidoCofins', ''));

      Servico.Valores.ValorInss := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorInss', ''), 0);
      Servico.Valores.AliquotaInss := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliquotaInss', ''), 0);
      Servico.Valores.RetidoInss := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'RetidoInss', ''));

      Servico.Valores.ValorIr := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorIr', ''), 0);
      Servico.Valores.AliquotaIr := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliquotaIr', ''), 0);
      Servico.Valores.RetidoIr := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'RetidoIr', ''));

      Servico.Valores.ValorCsll := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorCsll', ''), 0);
      Servico.Valores.AliquotaCsll := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliquotaCsll', ''), 0);
      Servico.Valores.RetidoCsll := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'RetidoCsll', ''));

      Servico.Valores.AliquotaCpp := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliquotaCpp', ''), 0);
      Servico.Valores.ValorCpp := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorCpp', ''), 0);
      Servico.Valores.RetidoCpp := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'RetidoCpp', ''));
      Servico.Valores.ISSRetido := FpAOwner.StrToSituacaoTributaria(Ok, AINIRec.ReadString(sSecao, 'ISSRetido', '0'));

      Servico.Valores.valorOutrasRetencoes := StringToFloatDef(AINIRec.ReadString(sSecao, 'valorOutrasRetencoes', ''), 0);
      Servico.Valores.OutrasRetencoes := StringToFloatDef(AINIRec.ReadString(sSecao, 'OutrasRetencoes', ''), 0);
      Servico.Valores.DescricaoOutrasRetencoes := AINIRec.ReadString(sSecao, 'DescricaoOutrasRetencoes', '');
      Servico.Valores.DescontoIncondicionado := StringToFloatDef(AINIRec.ReadString(sSecao, 'DescontoIncondicionado', ''), 0);
      Servico.Valores.DescontoCondicionado := StringToFloatDef(AINIRec.ReadString(sSecao, 'DescontoCondicionado', ''), 0);
      Servico.Valores.OutrosDescontos := StringToFloatDef(AINIRec.ReadString(sSecao, 'OutrosDescontos', ''), 0);

      Servico.Valores.ValorRepasse := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorRepasse', ''), 0);

      Servico.Valores.BaseCalculo := StringToFloatDef(AINIRec.ReadString(sSecao, 'BaseCalculo', ''), 0);
      Servico.Valores.Aliquota := StringToFloatDef(AINIRec.ReadString(sSecao, 'Aliquota', ''), 0);
      Servico.Valores.AliquotaSN := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliquotaSN', ''), 0);
      Servico.Valores.ValorIss := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorIss', ''), 0);
      Servico.Valores.ValorIssRetido := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorIssRetido', ''), 0);

      Servico.Valores.ValorLiquidoNfse := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorLiquidoNfse', ''), 0);

      Servico.Valores.ValorTotalNotaFiscal := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorTotalNotaFiscal', ''), 0);
      if Servico.Valores.ValorTotalNotaFiscal = 0 then
        Servico.Valores.ValorTotalNotaFiscal := Servico.Valores.ValorServicos - Servico.Valores.DescontoCondicionado - Servico.Valores.DescontoIncondicionado;

      Servico.Valores.ValorTotalTributos := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorTotalTributos', ''), 0);

      Servico.Valores.IrrfIndenizacao := StringtoFloatDef(AINIRec.ReadString(sSecao, 'IrrfIndenizacao', ''), 0);
      Servico.Valores.RetencoesFederais := StringToFloatDef(AINIRec.ReadString(sSecao, 'RetencoesFederais', ''), 0);

      //Padrão Nacional
      Servico.Valores.ValorRecebido := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorRecebido', ''), 0);

      // Provedor Infisc
      Servico.Valores.totalAproxTrib := StringToFloatDef(AINIRec.ReadString(sSecao, 'totalAproxTrib', ''), 0);

      // Provedor Equiplano
      Servico.Valores.dsImpostos := AINIRec.ReadString(sSecao, 'dsImpostos', '');
    end;

    sSecao := 'ValoresNFSe';
    if AINIRec.SectionExists(sSecao) then
    begin
      ValoresNfse.BaseCalculo := StringToFloatDef(AINIRec.ReadString(sSecao, 'BaseCalculo', ''), 0);
      ValoresNfse.Aliquota := StringToFloatDef(AINIRec.ReadString(sSecao, 'Aliquota', ''), 0);
      ValoresNfse.ValorLiquidoNfse := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorLiquidoNfse', ''), 0);
      ValoresNfse.ValorIss := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorIss', ''), 0);
    end;

    // Condição de Pagamento usado pelo provedor Betha versão 1 do Layout da ABRASF
    sSecao := 'CondicaoPagamento';
    if AINIRec.SectionExists(sSecao) then
    begin
      CondicaoPagamento.QtdParcela := AINIRec.ReadInteger(sSecao, 'QtdParcela', 0);
      // Provedor Publica/IPM/Betha
      CondicaoPagamento.Condicao := FpAOwner.StrToCondicaoPag(Ok, AINIRec.ReadString(sSecao, 'Condicao', 'A_VISTA'));

      // Provedor NFEletronica
      CondicaoPagamento.DataVencimento := AINIRec.ReadDate(sSecao, 'DataVencimento', Now);
      CondicaoPagamento.InstrucaoPagamento := AINIRec.ReadString(sSecao, 'InstrucaoPagamento', '');
      CondicaoPagamento.CodigoVencimento := AINIRec.ReadInteger(sSecao, 'CodigoVencimento', 0);
    end;

    //GeisWeb, ISSCambe, ISSLencois
    sSecao := 'OrgaoGerador';
    if AINIRec.SectionExists(sSecao) then
    begin
      OrgaoGerador.CodigoMunicipio := AINIRec.ReadString(sSecao, 'CodigoMunicipio', '');
      OrgaoGerador.Uf := AINIRec.ReadString(sSecao, 'UF', '');
    end;

    i := 1;
    while true do
    begin
      sSecao := 'Parcelas' + IntToStrZero(i, 2);
      sFim := AINIRec.ReadString(sSecao, 'Parcela'  ,'FIM');

      if (sFim = 'FIM') then
        break;

      ItemParcelas := CondicaoPagamento.Parcelas.New;
      ItemParcelas.Parcela := sFim;
      ItemParcelas.DataVencimento := AINIRec.ReadDate(sSecao, 'DataVencimento', Now);
      ItemParcelas.Valor := StringToFloatDef(AINIRec.ReadString(sSecao, 'Valor', ''), 0);
      ItemParcelas.Condicao := FpAOwner.StrToCondicaoPag(Ok, AINIRec.ReadString(sSecao, 'Condicao', ''));

      Inc(i);
    end;

    LerINIIBSCBS(AINIRec, IBSCBS);
  end;
end;

// Reforma Tributária
procedure TNFSeRClass.LerXMLIBSCBSDPS(const ANode: TACBrXmlNode;
  IBSCBS: TIBSCBSDPS);
var
  ANodeAux: TACBrXmlNode;
  ANodes: TACBrXmlNodeArray;
  i: Integer;
begin
  if not Assigned(ANode) then Exit;

  IBSCBS.finNFSe := StrTofinNFSe(ObterConteudo(ANode.Childrens.FindAnyNs('finNFSe'), tcStr));
  IBSCBS.indFinal := StrToindFinal(ObterConteudo(ANode.Childrens.FindAnyNs('indFinal'), tcStr));
  IBSCBS.cIndOp := ObterConteudo(ANode.Childrens.FindAnyNs('cIndOp'), tcStr);
  IBSCBS.tpOper := StrTotpOperGovNFSe(ObterConteudo(ANode.Childrens.FindAnyNs('tpOper'), tcStr));

  ANodeAux := ANode.Childrens.Find('gRefNFSe');

  if Assigned(ANodeAux) then
  begin
    ANodes := ANodeAux.Childrens.FindAll('refNFSe');
    for i := 0 to Length(ANodes) - 1 do
      LerXMLgRefNFSe(ANodes[i]);
  end;

  IBSCBS.tpEnteGov := StrTotpEnteGov(ObterConteudo(ANode.Childrens.FindAnyNs('tpEnteGov'), tcStr));
  IBSCBS.indDest := StrToindDest(ObterConteudo(ANode.Childrens.FindAnyNs('indDest'), tcStr));

  LerXMLDestinatario(ANode.Childrens.FindAnyNs('dest'), IBSCBS.dest);
  LerXMLImovel(ANode.Childrens.FindAnyNs('imovel'), IBSCBS.imovel);
  LerXMLIBSCBSValores(ANode.Childrens.FindAnyNs('valores'), IBSCBS.valores);
end;

procedure TNFSeRClass.LerXMLgRefNFSe(const ANode: TACBrXmlNode);
var
  Item: TgRefNFSeCollectionItem;
begin
  if not Assigned(ANode) then Exit;

  Item := NFSe.IBSCBS.gRefNFSe.New;

  Item.refNFSe := ANode.Content;
end;

procedure TNFSeRClass.LerXMLDestinatario(const ANode: TACBrXmlNode;
  Dest: TDadosdaPessoa);
var
  oK: Boolean;
begin
  if not Assigned(ANode) then Exit;

  Dest.CNPJCPF := ObterCNPJCPF(ANode);
  Dest.NIF := ObterConteudo(ANode.Childrens.FindAnyNs('NIF'), tcStr);
  Dest.cNaoNIF := StrToNaoNIF(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('cNaoNIF'), tcStr));

  Dest.xNome := ObterConteudo(ANode.Childrens.FindAnyNs('xNome'), tcStr);

  LerXMLEnderecoDestinatario(ANode.Childrens.FindAnyNs('end'), Dest.ender);

  Dest.fone := ObterConteudo(ANode.Childrens.FindAnyNs('fone'), tcStr);
  Dest.email := ObterConteudo(ANode.Childrens.FindAnyNs('email'), tcStr);
end;

procedure TNFSeRClass.LerXMLEnderecoDestinatario(
  const ANode: TACBrXmlNode; ender: Tender);
begin
  if not Assigned(ANode) then Exit;

  LerXMLEnderecoNacionalDestinatario(ANode.Childrens.FindAnyNs('endNac'), ender.endNac);
  LerXMLEnderecoExteriorDestinatario(ANode.Childrens.FindAnyNs('endExt'), ender.endExt);

  ender.xLgr := ObterConteudo(ANode.Childrens.FindAnyNs('xLgr'), tcStr);
  ender.nro := ObterConteudo(ANode.Childrens.FindAnyNs('nro'), tcStr);
  ender.xCpl := ObterConteudo(ANode.Childrens.FindAnyNs('xCpl'), tcStr);
  ender.xBairro := ObterConteudo(ANode.Childrens.FindAnyNs('xBairro'), tcStr);
end;

procedure TNFSeRClass.LerXMLEnderecoNacionalDestinatario(
  const ANode: TACBrXmlNode; endNac: TendNac);
begin
  if not Assigned(ANode) then Exit;

  endNac.cMun := ObterConteudo(ANode.Childrens.FindAnyNs('cMun'), tcInt);
  endNac.CEP := ObterConteudo(ANode.Childrens.FindAnyNs('CEP'), tcStr);
end;

procedure TNFSeRClass.LerXMLEnderecoExteriorDestinatario(
  const ANode: TACBrXmlNode; endExt: TendExt);
begin
  if not Assigned(ANode) then Exit;

  endExt.cPais := SiglaISO2ToCodIBGEPais(ObterConteudo(ANode.Childrens.FindAnyNs('cPais'), tcStr));
  endExt.cEndPost := ObterConteudo(ANode.Childrens.FindAnyNs('cEndPost'), tcStr);
  endExt.xCidade := ObterConteudo(ANode.Childrens.FindAnyNs('xCidade'), tcStr);
  endExt.xEstProvReg := ObterConteudo(ANode.Childrens.FindAnyNs('xEstProvReg'), tcStr);
end;

procedure TNFSeRClass.LerXMLImovel(const ANode: TACBrXmlNode;
  Imovel: TDadosimovel);
begin
  if not Assigned(ANode) then Exit;

  Imovel.inscImobFisc := ObterConteudo(ANode.Childrens.FindAnyNs('inscImobFisc'), tcStr);
  Imovel.cCIB := ObterConteudo(ANode.Childrens.FindAnyNs('cCIB'), tcStr);

  LerXMLEnderecoNacionalImovel(ANode.Childrens.FindAnyNs('end'), Imovel.ender);
end;

procedure TNFSeRClass.LerXMLEnderecoNacionalImovel(
  const ANode: TACBrXmlNode; ender: TenderImovel);
begin
  if not Assigned(ANode) then Exit;

  ender.CEP := ObterConteudo(ANode.Childrens.FindAnyNs('CEP'), tcStr);

  LerXMLEnderecoExteriorImovel(ANode.Childrens.FindAnyNs('endExt'), ender.endExt);

  ender.xLgr := ObterConteudo(ANode.Childrens.FindAnyNs('xLgr'), tcStr);
  ender.nro := ObterConteudo(ANode.Childrens.FindAnyNs('nro'), tcStr);
  ender.xCpl := ObterConteudo(ANode.Childrens.FindAnyNs('xCpl'), tcStr);
  ender.xBairro := ObterConteudo(ANode.Childrens.FindAnyNs('xBairro'), tcStr);
end;

procedure TNFSeRClass.LerXMLEnderecoExteriorImovel(
  const ANode: TACBrXmlNode; endExt: TendExt);
begin
  if not Assigned(ANode) then Exit;

  endExt.cEndPost := ObterConteudo(ANode.Childrens.FindAnyNs('cEndPost'), tcStr);
  endExt.xCidade := ObterConteudo(ANode.Childrens.FindAnyNs('xCidade'), tcStr);
  endExt.xEstProvReg := ObterConteudo(ANode.Childrens.FindAnyNs('xEstProvReg'), tcStr);
end;

procedure TNFSeRClass.LerXMLIBSCBSValores(const ANode: TACBrXmlNode;
  valores: Tvalorestrib);
begin
  if not Assigned(ANode) then Exit;

  LerXMLgReeRepRes(ANode.Childrens.FindAnyNs('gReeRepRes'), valores.gReeRepRes);
  LerXMLTributos(ANode.Childrens.FindAnyNs('trib'), valores.trib);
end;

procedure TNFSeRClass.LerXMLgReeRepRes(const ANode: TACBrXmlNode;
  gReeRepRes: TgReeRepRes);
var
  ANodes: TACBrXmlNodeArray;
  i: Integer;
begin
  if not Assigned(ANode) then Exit;

  ANodes := ANode.Childrens.FindAllAnyNs('documentos');

  for i := 0 to Length(ANodes) - 1 do
  begin
    gReeRepRes.documentos.New;
    with gReeRepRes.documentos[i] do
    begin
      LerXMLdFeNacional(ANodes[i].Childrens.FindAnyNs('dFeNacional'), gReeRepRes.documentos[i].dFeNacional);
      LerXMLdocFiscalOutro(ANodes[i].Childrens.FindAnyNs('docFiscalOutro'), gReeRepRes.documentos[i].docFiscalOutro);
      LerXMLdocOutro(ANodes[i].Childrens.FindAnyNs('docOutro'), gReeRepRes.documentos[i].docOutro);
      LerXMLfornec(ANodes[i].Childrens.FindAnyNs('fornec'), gReeRepRes.documentos[i].fornec);

      dtEmiDoc := ObterConteudo(ANode.Childrens.FindAnyNs('dtEmiDoc'), tcDat);
      dtCompDoc := ObterConteudo(ANode.Childrens.FindAnyNs('dtCompDoc'), tcDat);
      tpReeRepRes := StrTotpReeRepRes(ObterConteudo(ANode.Childrens.FindAnyNs('tpReeRepRes'), tcStr));
      xTpReeRepRes := ObterConteudo(ANode.Childrens.FindAnyNs('xTpReeRepRes'), tcStr);
      vlrReeRepRes := ObterConteudo(ANode.Childrens.FindAnyNs('vlrReeRepRes'), tcDe2);
    end;
  end;
end;

procedure TNFSeRClass.LerXMLdFeNacional(const ANode: TACBrXmlNode;
  dFeNacional: TdFeNacional);
begin
  if not Assigned(ANode) then Exit;

  dFeNacional.tipoChaveDFe := StrTotipoChaveDFe(ObterConteudo(ANode.Childrens.FindAnyNs('tipoChaveDFe'), tcStr));
  dFeNacional.xTipoChaveDFe := ObterConteudo(ANode.Childrens.FindAnyNs('xTipoChaveDFe'), tcStr);
  dFeNacional.chaveDFe := ObterConteudo(ANode.Childrens.FindAnyNs('chaveDFe'), tcStr);
end;

procedure TNFSeRClass.LerXMLdocFiscalOutro(const ANode: TACBrXmlNode;
  docFiscalOutro: TdocFiscalOutro);
begin
  if not Assigned(ANode) then Exit;

  docFiscalOutro.cMunDocFiscal := ObterConteudo(ANode.Childrens.FindAnyNs('cMunDocFiscal'), tcInt);
  docFiscalOutro.nDocFiscal := ObterConteudo(ANode.Childrens.FindAnyNs('nDocFiscal'), tcStr);
  docFiscalOutro.xDocFiscal := ObterConteudo(ANode.Childrens.FindAnyNs('xDocFiscal'), tcStr);
end;

procedure TNFSeRClass.LerXMLdocOutro(const ANode: TACBrXmlNode;
  docOutro: TdocOutro);
begin
  if not Assigned(ANode) then Exit;

  docOutro.nDoc := ObterConteudo(ANode.Childrens.FindAnyNs('nDoc'), tcStr);
  docOutro.xDoc := ObterConteudo(ANode.Childrens.FindAnyNs('xDoc'), tcStr);
end;

procedure TNFSeRClass.LerXMLfornec(const ANode: TACBrXmlNode;
  fornec: Tfornec);
var
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  fornec.CNPJCPF := ObterCNPJCPF(ANode);
  fornec.NIF := ObterConteudo(ANode.Childrens.FindAnyNs('NIF'), tcStr);
  fornec.cNaoNIF := StrToNaoNIF(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('cNaoNIF'), tcStr));
  fornec.NIF := ObterConteudo(ANode.Childrens.FindAnyNs('NIF'), tcStr);
  fornec.xNome := ObterConteudo(ANode.Childrens.FindAnyNs('xNome'), tcStr);
end;

procedure TNFSeRClass.LerXMLTributos(const ANode: TACBrXmlNode;
  trib: Ttrib);
begin
  if not Assigned(ANode) then Exit;

  LerXMLgIBSCBS(ANode.Childrens.FindAnyNs('gIBSCBS'), trib.gIBSCBS);
end;

procedure TNFSeRClass.LerXMLgIBSCBS(const ANode: TACBrXmlNode;
  gIBSCBS: TgIBSCBS);
begin
  if not Assigned(ANode) then Exit;

  gIBSCBS.CST := StrToCSTIBSCBS(ObterConteudo(ANode.Childrens.FindAnyNs('CST'), tcStr));
  gIBSCBS.cClassTrib := ObterConteudo(ANode.Childrens.FindAnyNs('cClassTrib'), tcStr);
  gIBSCBS.cCredPres := StrTocCredPres(ObterConteudo(ANode.Childrens.FindAnyNs('cCredPres'), tcStr));

  LerXMLgTribRegular(ANode.Childrens.FindAnyNs('gTribRegular'), gIBSCBS.gTribRegular);
  LerXMLgDif(ANode.Childrens.FindAnyNs('gDif'), gIBSCBS.gDif);
end;

procedure TNFSeRClass.LerXMLgTribRegular(const ANode: TACBrXmlNode;
  gTribRegular: TgTribRegular);
begin
  if not Assigned(ANode) then Exit;

  gTribRegular.CSTReg := StrToCSTIBSCBS(ObterConteudo(ANode.Childrens.FindAnyNs('CSTReg'), tcStr));
  gTribRegular.cClassTribReg := ObterConteudo(ANode.Childrens.FindAnyNs('cClassTribReg'), tcStr);
end;

procedure TNFSeRClass.LerXMLgDif(const ANode: TACBrXmlNode;
  gDif: TgDif);
begin
  if not Assigned(ANode) then Exit;

  gDif.pDifUF := ObterConteudo(ANode.Childrens.FindAnyNs('pDifUF'), tcDe2);
  gDif.pDifMun := ObterConteudo(ANode.Childrens.FindAnyNs('pDifMun'), tcDe2);
  gDif.pDifCBS := ObterConteudo(ANode.Childrens.FindAnyNs('pDifCBS'), tcDe2);
end;

procedure TNFSeRClass.LerXMLIBSCBSNFSe(const ANode: TACBrXmlNode;
  IBSCBS: TIBSCBSNfse);
begin
  if not Assigned(ANode) then Exit;

  IBSCBS.cLocalidadeIncid := ObterConteudo(ANode.Childrens.FindAnyNs('cLocalidadeIncid'), tcInt);
  IBSCBS.xLocalidadeIncid := ObterConteudo(ANode.Childrens.FindAnyNs('xLocalidadeIncid'), tcStr);
  IBSCBS.pRedutor := ObterConteudo(ANode.Childrens.FindAnyNs('pRedutor'), tcDe2);

  LerXMLValoresIBSCBSNFSe(ANode.Childrens.FindAnyNs('valores'), IBSCBS.valores);

  LerXMLTotCIBS(ANode.Childrens.FindAnyNs('totCIBS'), IBSCBS.totCIBS);
end;

procedure TNFSeRClass.LerXMLValoresIBSCBSNFSe(const ANode: TACBrXmlNode;
  valores: TvaloresIBSCBS);
begin
  if not Assigned(ANode) then Exit;

  valores.vBC := ObterConteudo(ANode.Childrens.FindAnyNs('vBC'), tcDe2);
  valores.vCalcReeRepRes := ObterConteudo(ANode.Childrens.FindAnyNs('vCalcReeRepRes'), tcDe2);

  LerXMLUF(ANode.Childrens.FindAnyNs('uf'), valores.uf);
  LerXMLMun(ANode.Childrens.FindAnyNs('mun'), valores.mun);
  LerXMLFed(ANode.Childrens.FindAnyNs('fed'), valores.fed);
end;

procedure TNFSeRClass.LerXMLUF(const ANode: TACBrXmlNode; uf: TUF);
begin
  if not Assigned(ANode) then Exit;

  uf.pIBSUF := ObterConteudo(ANode.Childrens.FindAnyNs('pIBSUF'), tcDe2);
  uf.pRedAliqUF := ObterConteudo(ANode.Childrens.FindAnyNs('pRedAliqUF'), tcDe2);
  uf.pAliqEfetUF := ObterConteudo(ANode.Childrens.FindAnyNs('pAliqEfetUF'), tcDe2);
end;

procedure TNFSeRClass.LerXMLMun(const ANode: TACBrXmlNode; mun: TMun);
begin
  if not Assigned(ANode) then Exit;

  mun.pIBSMun := ObterConteudo(ANode.Childrens.FindAnyNs('pIBSMun'), tcDe2);
  mun.pRedAliqMun := ObterConteudo(ANode.Childrens.FindAnyNs('pRedAliqMun'), tcDe2);
  mun.pAliqEfetMun := ObterConteudo(ANode.Childrens.FindAnyNs('pAliqEfetMun'), tcDe2);
end;

procedure TNFSeRClass.LerXMLFed(const ANode: TACBrXmlNode; Fed: TFed);
begin
  if not Assigned(ANode) then Exit;

  Fed.pCBS := ObterConteudo(ANode.Childrens.FindAnyNs('pCBS'), tcDe2);
  Fed.pRedAliqCBS := ObterConteudo(ANode.Childrens.FindAnyNs('pRedAliqCBS'), tcDe2);
  Fed.pAliqEfetCBS := ObterConteudo(ANode.Childrens.FindAnyNs('pAliqEfetCBS'), tcDe2);
end;

procedure TNFSeRClass.LerXMLTotCIBS(const ANode: TACBrXmlNode;
  totCIBS: TtotCIBS);
begin
  if not Assigned(ANode) then Exit;

  totCIBS.vTotNF := ObterConteudo(ANode.Childrens.FindAnyNs('vTotNF'), tcDe2);

  LerXMLgTribRegularNFSe(ANode.Childrens.FindAnyNs('gTribRegular'), totCIBS.gTribRegular);
  LerXMLgTribCompraGov(ANode.Childrens.FindAnyNs('gTribCompraGov'), totCIBS.gTribCompraGov);
  LerXMLTotgIBS(ANode.Childrens.FindAnyNs('gIBS'), totCIBS.gIBS);
  LerXMLTotgCBS(ANode.Childrens.FindAnyNs('gCBS'), totCIBS.gCBS);
end;

procedure TNFSeRClass.LerXMLgTribRegularNFSe(const ANode: TACBrXmlNode;
  gTribRegular: TgTribRegularNFSe);
begin
  if not Assigned(ANode) then Exit;

  gTribRegular.pAliqEfeRegIBSUF := ObterConteudo(ANode.Childrens.FindAnyNs('pAliqEfeRegIBSUF'), tcDe2);
  gTribRegular.vTribRegIBSUF := ObterConteudo(ANode.Childrens.FindAnyNs('vTribRegIBSUF'), tcDe2);
  gTribRegular.pAliqEfeRegIBSMun := ObterConteudo(ANode.Childrens.FindAnyNs('pAliqEfeRegIBSMun'), tcDe2);
  gTribRegular.vTribRegIBSMun := ObterConteudo(ANode.Childrens.FindAnyNs('vTribRegIBSMun'), tcDe2);
  gTribRegular.pAliqEfeRegCBS := ObterConteudo(ANode.Childrens.FindAnyNs('pAliqEfeRegCBS'), tcDe2);
  gTribRegular.vTribRegCBS := ObterConteudo(ANode.Childrens.FindAnyNs('vTribRegCBS'), tcDe2);
end;

procedure TNFSeRClass.LerXMLgTribCompraGov(const ANode: TACBrXmlNode;
  gTribCompraGov: TgTribCompraGov);
begin
  if not Assigned(ANode) then Exit;

  gTribCompraGov.pIBSUF := ObterConteudo(ANode.Childrens.FindAnyNs('pIBSUF'), tcDe2);
  gTribCompraGov.vIBSUF := ObterConteudo(ANode.Childrens.FindAnyNs('vIBSUF'), tcDe2);
  gTribCompraGov.pIBSMun := ObterConteudo(ANode.Childrens.FindAnyNs('pIBSMun'), tcDe2);
  gTribCompraGov.vIBSMun := ObterConteudo(ANode.Childrens.FindAnyNs('vIBSMun'), tcDe2);
  gTribCompraGov.pCBS := ObterConteudo(ANode.Childrens.FindAnyNs('pCBS'), tcDe2);
  gTribCompraGov.vCBS := ObterConteudo(ANode.Childrens.FindAnyNs('vCBS'), tcDe2);
end;

procedure TNFSeRClass.LerXMLTotgIBS(
  const ANode: TACBrXmlNode; gIBS: TgIBS);
begin
  if not Assigned(ANode) then Exit;

  gIBS.vIBSTot := ObterConteudo(ANode.Childrens.FindAnyNs('vIBSTot'), tcDe2);

  LerXMLgIBSCredPres(ANode.Childrens.FindAnyNs('gIBSCredPres'), gIBS.gIBSCredPres);
  LerXMLTotgIBSUFTot(ANode.Childrens.FindAnyNs('gIBSUFTot'), gIBS.gIBSUFTot);
  LerXMLTotgIBSMunTot(ANode.Childrens.FindAnyNs('gIBSMunTot'), gIBS.gIBSMunTot);
end;

procedure TNFSeRClass.LerXMLgIBSCredPres(const ANode: TACBrXmlNode;
  gIBSCredPres: TgIBSCredPres);
begin
  if not Assigned(ANode) then Exit;

  gIBSCredPres.pCredPresIBS := ObterConteudo(ANode.Childrens.FindAnyNs('pCredPresIBS'), tcDe2);
  gIBSCredPres.vCredPresIBS := ObterConteudo(ANode.Childrens.FindAnyNs('vCredPresIBS'), tcDe2);
end;

procedure TNFSeRClass.LerXMLTotgIBSUFTot(
  const ANode: TACBrXmlNode; gIBSUFTot: TgIBSUFTot);
begin
  if not Assigned(ANode) then Exit;

  gIBSUFTot.vDifUF := ObterConteudo(ANode.Childrens.FindAnyNs('vDifUF'), tcDe2);
  gIBSUFTot.vIBSUF := ObterConteudo(ANode.Childrens.FindAnyNs('vIBSUF'), tcDe2);
end;

procedure TNFSeRClass.LerXMLTotgIBSMunTot(
  const ANode: TACBrXmlNode; gIBSMunTot: TgIBSMunTot);
begin
  if not Assigned(ANode) then Exit;

  gIBSMunTot.vDifMun := ObterConteudo(ANode.Childrens.FindAnyNs('vDifMun'), tcDe2);
  gIBSMunTot.vIBSMun := ObterConteudo(ANode.Childrens.FindAnyNs('vIBSMun'), tcDe2);
end;

procedure TNFSeRClass.LerXMLTotgCBS(
  const ANode: TACBrXmlNode; gCBS: TgCBS);
begin
  if not Assigned(ANode) then Exit;

  LerXMLgCBSCredPres(ANode.Childrens.FindAnyNs('gCBSCredPres'), gCBS.gCBSCredPres);

  gCBS.vDifCBS := ObterConteudo(ANode.Childrens.FindAnyNs('vDifCBS'), tcDe2);
  gCBS.vCBS := ObterConteudo(ANode.Childrens.FindAnyNs('vCBS'), tcDe2);
end;

procedure TNFSeRClass.LerXMLgCBSCredPres(const ANode: TACBrXmlNode;
  gCBSCredPres: TgCBSCredPres);
begin
  if not Assigned(ANode) then Exit;

  gCBSCredPres.pCredPresCBS := ObterConteudo(ANode.Childrens.FindAnyNs('pCredPresCBS'), tcDe2);
  gCBSCredPres.vCredPresCBS := ObterConteudo(ANode.Childrens.FindAnyNs('vCredPresCBS'), tcDe2);
end;

// Reforma Tributária
procedure TNFSeRClass.LerINIIBSCBS(AINIRec: TMemIniFile;
  IBSCBS: TIBSCBSDPS);
var
  sSecao: string;
begin
  sSecao := 'IBSCBSDPS';
  if AINIRec.SectionExists(sSecao) then
  begin
    IBSCBS.finNFSe := StrTofinNFSe(AINIRec.ReadString(sSecao, 'finNFSe', ''));
    IBSCBS.indFinal := StrToindFinal(AINIRec.ReadString(sSecao, 'indFinal', ''));
    IBSCBS.cIndOp := AINIRec.ReadString(sSecao, 'cIndOp', '');
    IBSCBS.tpOper := StrTotpOperGovNFSe(AINIRec.ReadString(sSecao, 'tpOper', ''));
    IBSCBS.tpEnteGov := StrTotpEnteGov(AINIRec.ReadString(sSecao, 'tpEnteGov', ''));
    IBSCBS.indDest := StrToindDest(AINIRec.ReadString(sSecao, 'indDest', ''));

    LerINIgRefNFSe(AINIRec, IBSCBS.gRefNFSe);
    LerINIDestinatario(AINIRec, IBSCBS.dest);
    LerINIImovel(AINIRec, IBSCBS.imovel);
    LerINIIBSCBSValores(AINIRec, IBSCBS.valores);
  end;
end;

procedure TNFSeRClass.LerINIgRefNFSe(AINIRec: TMemIniFile;
  gRefNFSe: TgRefNFSeCollection);
var
  i: Integer;
  sSecao, sFim: string;
begin
  i := 1;
  while true do
  begin
    sSecao := 'gRefNFSe' + IntToStrZero(i, 2);
    sFim := AINIRec.ReadString(sSecao,'refNFSe', 'FIM');
    if sFim = 'FIM' then
      break;

    gRefNFSe.New.refNFSe := sFim;
  end;
end;

procedure TNFSeRClass.LerINIDestinatario(AINIRec: TMemIniFile; Dest: TDadosdaPessoa);
var
  sSecao: string;
  Ok: Boolean;
begin
  sSecao := 'Destinatario';
  if AINIRec.SectionExists(sSecao) then
  begin
    Dest.CNPJCPF := AINIRec.ReadString(sSecao, 'CNPJCPF', '');
    Dest.Nif := AINIRec.ReadString(sSecao, 'NIF', '');
    Dest.cNaoNIF := StrToNaoNIF(Ok, AINIRec.ReadString(sSecao, 'cNaoNIF', '0'));
    Dest.xNome := AINIRec.ReadString(sSecao, 'xNome', '');

    Dest.ender.endNac.CEP := AINIRec.ReadString(sSecao, 'CEP', '');
    Dest.ender.endNac.cMun := AINIRec.ReadInteger(sSecao, 'cMun', 0);
    Dest.ender.endExt.cPais := AINIRec.ReadInteger(sSecao, 'cPais', 0);
    Dest.ender.endExt.cEndPost := AINIRec.ReadString(sSecao, 'cEndPost', '');
    Dest.ender.endExt.xCidade := AINIRec.ReadString(sSecao, 'xCidade', '');
    Dest.ender.endExt.xEstProvReg := AINIRec.ReadString(sSecao, 'xEstProvReg', '');

    Dest.ender.xLgr := AINIRec.ReadString(sSecao, 'Logradouro', '');
    Dest.ender.nro := AINIRec.ReadString(sSecao, 'Numero', '');
    Dest.ender.xCpl := AINIRec.ReadString(sSecao, 'Complemento', '');
    Dest.ender.xBairro := AINIRec.ReadString(sSecao, 'Bairro', '');

    Dest.fone := AINIRec.ReadString(sSecao, 'Telefone', '');
    Dest.email := AINIRec.ReadString(sSecao, 'Email', '');
  end;
end;

procedure TNFSeRClass.LerINIImovel(AINIRec: TMemIniFile;
  Imovel: TDadosimovel);
var
  sSecao: string;
begin
  sSecao := 'Imovel';
  if AINIRec.SectionExists(sSecao) then
  begin
    Imovel.inscImobFisc := AINIRec.ReadString(sSecao, 'inscImobFisc', '');
    Imovel.cCIB := AINIRec.ReadString(sSecao, 'cCIB', '');

    Imovel.ender.CEP := AINIRec.ReadString(sSecao, 'CEP', '');
    Imovel.ender.xLgr := AINIRec.ReadString(sSecao, 'Logradouro', '');
    Imovel.ender.nro := AINIRec.ReadString(sSecao, 'Numero', '');
    Imovel.ender.xCpl := AINIRec.ReadString(sSecao, 'Complemento', '');
    Imovel.ender.xBairro := AINIRec.ReadString(sSecao, 'Bairro', '');

    Imovel.ender.endExt.cEndPost := AINIRec.ReadString(sSecao, 'cEndPost', '');
    Imovel.ender.endExt.xCidade := AINIRec.ReadString(sSecao, 'xCidade', '');
    Imovel.ender.endExt.xEstProvReg := AINIRec.ReadString(sSecao, 'xEstProvReg', '');
  end;
end;

procedure TNFSeRClass.LerINIIBSCBSValores(AINIRec: TMemIniFile;
  Valores: Tvalorestrib);
begin
  LerINIDocumentos(AINIRec, Valores.gReeRepRes.documentos);
  LerINITributacao(AINIRec, Valores.trib);
end;

procedure TNFSeRClass.LerINIDocumentos(AINIRec: TMemIniFile;
  Documentos: TdocumentosCollection);
var
  i: Integer;
  sSecao, sFim: string;
  Ok: Boolean;
begin
  i := 1;
  while true do
  begin
    sSecao := 'Documentos' + IntToStrZero(i, 4);
    sFim := AINIRec.ReadString(sSecao,'chaveDFe', '') +
            AINIRec.ReadString(sSecao,'nDocFiscal', '') +
            AINIRec.ReadString(sSecao,'nDoc', '') +
            AINIRec.ReadString(sSecao,'xNome', '');
    if sFim = '' then
      break;

    with Documentos.New do
    begin
      dFeNacional.tipoChaveDFe := StrTotipoChaveDFe(AINIRec.ReadString(sSecao, 'tipoChaveDFe', ''));
      dFeNacional.xTipoChaveDFe := AINIRec.ReadString(sSecao, 'xTipoChaveDFe', '');
      dFeNacional.chaveDFe := AINIRec.ReadString(sSecao, 'chaveDFe', '');

      docFiscalOutro.cMunDocFiscal := AINIRec.ReadInteger(sSecao, 'cMunDocFiscal', 0);
      docFiscalOutro.nDocFiscal := AINIRec.ReadString(sSecao, 'nDocFiscal', '');
      docFiscalOutro.xDocFiscal := AINIRec.ReadString(sSecao, 'xDocFiscal', '');

      docOutro.nDoc := AINIRec.ReadString(sSecao, 'nDoc', '');
      docOutro.xDoc := AINIRec.ReadString(sSecao, 'xDoc', '');

      fornec.CNPJCPF := AINIRec.ReadString(sSecao, 'CNPJCPF', '');
      fornec.NIF := AINIRec.ReadString(sSecao, 'NIF', '');
      fornec.cNaoNIF := StrToNaoNIF(Ok, AINIRec.ReadString(sSecao, 'cNaoNIF', ''));
      fornec.xNome := AINIRec.ReadString(sSecao, 'xNome', '');

      dtEmiDoc := AINIRec.ReadDate(sSecao, 'dtEmiDoc', 0);
      dtCompDoc := AINIRec.ReadDate(sSecao, 'dtCompDoc', 0);
      tpReeRepRes := StrTotpReeRepRes(AINIRec.ReadString(sSecao, 'tpReeRepRes', ''));
      xTpReeRepRes := AINIRec.ReadString(sSecao, 'xTpReeRepRes', '');
      vlrReeRepRes := StringToFloatDef(AINIRec.ReadString(sSecao, 'vlrReeRepRes', ''), 0);
    end;
  end;
end;

procedure TNFSeRClass.LerINITributacao(AINIRec: TMemIniFile;
  Tributacao: Ttrib);
begin
  LerINIgIBSCBS(AINIRec, Tributacao.gIBSCBS);
end;

procedure TNFSeRClass.LerINIgIBSCBS(AINIRec: TMemIniFile;
  gIBSCBS: TgIBSCBS);
var
  sSecao: string;
begin
  sSecao := 'gIBSCBS';

  if AINIRec.SectionExists(sSecao) then
  begin
    gIBSCBS.CST := StrToCSTIBSCBS(AINIRec.ReadString(sSecao, 'CST', ''));
    gIBSCBS.cClassTrib := AINIRec.ReadString(sSecao, 'cClassTrib', '');
    gIBSCBS.cCredPres := StrTocCredPres(AINIRec.ReadString(sSecao, 'cCredPres', ''));

    LerINIgTribRegular(AINIRec, gIBSCBS.gTribRegular);
    LerINIgDif(AINIRec, gIBSCBS.gDif);
  end;
end;

procedure TNFSeRClass.LerINIgTribRegular(AINIRec: TMemIniFile;
  gTribRegular: TgTribRegular);
var
  sSecao: string;
begin
  sSecao := 'gTribRegular';

  if AINIRec.SectionExists(sSecao) then
  begin
    gTribRegular.CSTReg := StrToCSTIBSCBS(AINIRec.ReadString(sSecao, 'CSTReg', ''));
    gTribRegular.cClassTribReg := AINIRec.ReadString(sSecao, 'cClassTribReg', '');
  end;
end;

procedure TNFSeRClass.LerINIgDif(AINIRec: TMemIniFile; gDif: TgDif);
var
  sSecao: string;
begin
  sSecao := 'gDif';

  if AINIRec.SectionExists(sSecao) then
  begin
    gDif.pDifUF := StringToFloatDef(AINIRec.ReadString(sSecao, 'pDifUF', ''), 0);
    gDif.pDifMun := StringToFloatDef(AINIRec.ReadString(sSecao, 'pDifMun', ''), 0);
    gDif.pDifCBS := StringToFloatDef(AINIRec.ReadString(sSecao, 'pDifCBS', ''), 0);
  end;
end;

procedure TNFSeRClass.LerINIIBSCBSNFSe(AINIRec: TMemIniFile;
  IBSCBS: TIBSCBSNfse);
var
  sSecao: string;
begin
  sSecao := 'IBSCBSNFSE';

  if AINIRec.SectionExists(sSecao) then
  begin
    IBSCBS.cLocalidadeIncid := AINIRec.ReadInteger(sSecao, 'cLocalidadeIncid', 0);
    IBSCBS.xLocalidadeIncid := AINIRec.ReadString(sSecao, 'xLocalidadeIncid', '');
    IBSCBS.pRedutor := StringToFloatDef(AINIRec.ReadString(sSecao, 'pRedutor', ''), 0);

    LerINIIBSCBSValoresNFSe(AINIRec, IBSCBS.valores);
    LerINITotCIBS(AINIRec, IBSCBS.totCIBS);
  end;
end;

procedure TNFSeRClass.LerINIIBSCBSValoresNFSe(AINIRec: TMemIniFile;
  Valores: TvaloresIBSCBS);
var
  sSecao: string;
begin
  sSecao := 'IBSCBSValoresNFSE';

  if AINIRec.SectionExists(sSecao) then
  begin
    Valores.vBC := StringToFloatDef(AINIRec.ReadString(sSecao, 'vBC', ''), 0);
    Valores.vCalcReeRepRes := StringToFloatDef(AINIRec.ReadString(sSecao, 'vCalcReeRepRes', ''), 0);

    Valores.uf.pIBSUF := StringToFloatDef(AINIRec.ReadString(sSecao, 'pIBSUF', ''), 0);
    Valores.uf.pRedAliqUF := StringToFloatDef(AINIRec.ReadString(sSecao, 'pRedAliqUF', ''), 0);
    Valores.uf.pAliqEfetUF := StringToFloatDef(AINIRec.ReadString(sSecao, 'pAliqEfetUF', ''), 0);

    Valores.mun.pIBSMun := StringToFloatDef(AINIRec.ReadString(sSecao, 'pIBSMun', ''), 0);
    Valores.mun.pRedAliqMun := StringToFloatDef(AINIRec.ReadString(sSecao, 'pRedAliqMun', ''), 0);
    Valores.mun.pAliqEfetMun := StringToFloatDef(AINIRec.ReadString(sSecao, 'pAliqEfetMun', ''), 0);

    Valores.Fed.pCBS := StringToFloatDef(AINIRec.ReadString(sSecao, 'pCBS', ''), 0);
    Valores.Fed.pRedAliqCBS := StringToFloatDef(AINIRec.ReadString(sSecao, 'pRedAliqCBS', ''), 0);
    Valores.Fed.pAliqEfetCBS := StringToFloatDef(AINIRec.ReadString(sSecao, 'pAliqEfetCBS', ''), 0);
  end;
end;

procedure TNFSeRClass.LerINITotCIBS(AINIRec: TMemIniFile;
  TotCIBS: TTotCIBS);
var
  sSecao: string;
begin
  sSecao := 'TotCIBS';

  if AINIRec.SectionExists(sSecao) then
  begin
    TotCIBS.vTotNF := StringToFloatDef(AINIRec.ReadString(sSecao, 'vTotNF', ''), 0);

    LerINIgTribRegularNFSe(AINIRec, TotCIBS.gTribRegular);
    LerINIgTribCompraGov(AINIRec, TotCIBS.gTribCompraGov);
    LerINITotgIBS(AINIRec, TotCIBS.gIBS);
    LerINITotgCBS(AINIRec, TotCIBS.gCBS);
  end;
end;

procedure TNFSeRClass.LerINIgTribRegularNFSe(AINIRec: TMemIniFile;
  gTribRegularNFSe: TgTribRegularNFSe);
var
  sSecao: string;
begin
  sSecao := 'gTribRegularNFSe';

  if AINIRec.SectionExists(sSecao) then
  begin
    gTribRegularNFSe.pAliqEfeRegIBSUF := StringToFloatDef(AINIRec.ReadString(sSecao, 'pAliqEfeRegIBSUF', ''), 0);
    gTribRegularNFSe.vTribRegIBSUF := StringToFloatDef(AINIRec.ReadString(sSecao, 'vTribRegIBSUF', ''), 0);
    gTribRegularNFSe.pAliqEfeRegIBSMun := StringToFloatDef(AINIRec.ReadString(sSecao, 'pAliqEfeRegIBSMun', ''), 0);
    gTribRegularNFSe.vTribRegIBSMun := StringToFloatDef(AINIRec.ReadString(sSecao, 'vTribRegIBSMun', ''), 0);
    gTribRegularNFSe.pAliqEfeRegCBS := StringToFloatDef(AINIRec.ReadString(sSecao, 'pAliqEfeRegCBS', ''), 0);
    gTribRegularNFSe.vTribRegCBS := StringToFloatDef(AINIRec.ReadString(sSecao, 'vTribRegCBS', ''), 0);
  end;
end;

procedure TNFSeRClass.LerINIgTribCompraGov(AINIRec: TMemIniFile;
  gTribCompraGov: TgTribCompraGov);
var
  sSecao: string;
begin
  sSecao := 'gTribCompraGov';

  if AINIRec.SectionExists(sSecao) then
  begin
    gTribCompraGov.pIBSUF := StringToFloatDef(AINIRec.ReadString(sSecao, 'pIBSUF', ''), 0);
    gTribCompraGov.vIBSUF := StringToFloatDef(AINIRec.ReadString(sSecao, 'vIBSUF', ''), 0);
    gTribCompraGov.pIBSMun := StringToFloatDef(AINIRec.ReadString(sSecao, 'pIBSMun', ''), 0);
    gTribCompraGov.vIBSMun := StringToFloatDef(AINIRec.ReadString(sSecao, 'vIBSMun', ''), 0);
    gTribCompraGov.pCBS := StringToFloatDef(AINIRec.ReadString(sSecao, 'pCBS', ''), 0);
    gTribCompraGov.vCBS := StringToFloatDef(AINIRec.ReadString(sSecao, 'vCBS', ''), 0);
  end;
end;

procedure TNFSeRClass.LerINITotgIBS(AINIRec: TMemIniFile;
  TotgIBS: TgIBS);
var
  sSecao: string;
begin
  sSecao := 'TotgIBS';

  if AINIRec.SectionExists(sSecao) then
  begin
    TotgIBS.vIBSTot := StringToFloatDef(AINIRec.ReadString(sSecao, 'vIBSTot', ''), 0);

    TotgIBS.gIBSCredPres.pCredPresIBS := StringToFloatDef(AINIRec.ReadString(sSecao, 'pCredPresIBS', ''), 0);
    TotgIBS.gIBSCredPres.vCredPresIBS := StringToFloatDef(AINIRec.ReadString(sSecao, 'vCredPresIBS', ''), 0);

    TotgIBS.gIBSUFTot.vDifUF := StringToFloatDef(AINIRec.ReadString(sSecao, 'vDifUF', ''), 0);
    TotgIBS.gIBSUFTot.vIBSUF := StringToFloatDef(AINIRec.ReadString(sSecao, 'vIBSUF', ''), 0);

    TotgIBS.gIBSMunTot.vDifMun := StringToFloatDef(AINIRec.ReadString(sSecao, 'vDifMun', ''), 0);
    TotgIBS.gIBSMunTot.vIBSMun := StringToFloatDef(AINIRec.ReadString(sSecao, 'vIBSMun', ''), 0);
  end;
end;

procedure TNFSeRClass.LerINITotgCBS(AINIRec: TMemIniFile;
  TotgCBS: TgCBS);
var
  sSecao: string;
begin
  sSecao := 'TotgCBS';

  if AINIRec.SectionExists(sSecao) then
  begin
    TotgCBS.vDifCBS := StringToFloatDef(AINIRec.ReadString(sSecao, 'vDifCBS', ''), 0);
    TotgCBS.vCBS := StringToFloatDef(AINIRec.ReadString(sSecao, 'vCBS', ''), 0);

    TotgCBS.gCBSCredPres.pCredPresCBS := StringToFloatDef(AINIRec.ReadString(sSecao, 'pCredPresCBS', ''), 0);
    TotgCBS.gCBSCredPres.vCredPresCBS := StringToFloatDef(AINIRec.ReadString(sSecao, 'vCredPresCBS', ''), 0);
  end;
end;

end.
