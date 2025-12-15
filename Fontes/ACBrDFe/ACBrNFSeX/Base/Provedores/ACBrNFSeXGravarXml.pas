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

unit ACBrNFSeXGravarXml;

interface

uses
  SysUtils, Classes, StrUtils, IniFiles,
  ACBrXmlBase, ACBrDFe.Conversao, ACBrXmlDocument, ACBrXmlWriter,
  ACBrNFSeXInterface, ACBrNFSeXClass, ACBrNFSeXConversao, ACBrUtil.Base;

type

  TXmlWriterOptions = class(TACBrXmlWriterOptions)
  private
    FAjustarTagNro: boolean;
    FNormatizarMunicipios: boolean;
    FGerarTagAssinatura: TACBrTagAssinatura;
    FPathArquivoMunicipios: string;
    FValidarInscricoes: boolean;
    FValidarListaServicos: boolean;

  public
    property AjustarTagNro: boolean read FAjustarTagNro write FAjustarTagNro;
    property NormatizarMunicipios: boolean read FNormatizarMunicipios write FNormatizarMunicipios;
    property GerarTagAssinatura: TACBrTagAssinatura read FGerarTagAssinatura write FGerarTagAssinatura;
    property PathArquivoMunicipios: string read FPathArquivoMunicipios write FPathArquivoMunicipios;
    property ValidarInscricoes: boolean read FValidarInscricoes write FValidarInscricoes;
    property ValidarListaServicos: boolean read FValidarListaServicos write FValidarListaServicos;

  end;

  TNFSeWClass = class(TACBrXmlWriter)
  private
    FNFSe: TNFSe;

    FVersaoNFSe: TVersaoNFSe;
    FAmbiente: TACBrTipoAmbiente;
    FCodMunEmit: Integer;
    FUsuario: string;
    FSenha: string;
    FChaveAcesso: string;
    FChaveAutoriz: string;
    FFraseSecreta: string;
    FCNPJPrefeitura: string;
    FProvedor: TnfseProvedor;

    FFormatoEmissao: TACBrTipoCampo;
    FFormatoCompetencia: TACBrTipoCampo;
    FFormItemLServico: TFormatoItemListaServico;
    FFormDiscriminacao: TFormatoDiscriminacao;
    FFormatoAliq: TACBrTipoCampo;
    FDivAliq100: Boolean;

    FNrMinExigISS: Integer;
    FNrMaxExigISS: Integer;

    FNrOcorrItemListaServico: Integer;

    // Gera ou não o atributo ID no grupo <Rps> da versão 2 do layout da ABRASF.
    FGerarIDRps: Boolean;
    // Gera ou não o NameSpace no grupo <Rps> da versão 2 do layout da ABRASF.
    FGerarNSRps: Boolean;
    FIniParams: TMemIniFile;
    // Reforma Tributária
    FNrOcorrtpOper: Integer;
    FNrOcorrindDest: Integer;
    FNrOcorrCST: Integer;
    FNrOcorrcCredPres: Integer;
    FNrOcorrCSTReg: Integer;
    FGerarDest: Boolean;
    FGerarImovel: Boolean;
    FGerargReeRepRes: Boolean;
    FGerarTribRegular: Boolean;
    FGerargDif: Boolean;
    FNrOcorrtpAmb: Integer;

    function GetOpcoes: TACBrXmlWriterOptions;
    procedure SetOpcoes(AValue: TACBrXmlWriterOptions);
  protected
    FpAOwner: IACBrNFSeXProvider;
    LSecao: string;

    FConteudoTxt: TStringList;

    function CreateOptions: TACBrXmlWriterOptions; override;

    procedure Configuracao; virtual;

    procedure DefinirIDRps; virtual;
    procedure DefinirIDDeclaracao; virtual;
    procedure ConsolidarVariosItensServicosEmUmSo;

    function GerarTabulado(const xDescricao: string; const xCodigoItem: string;
      aQuantidade, aValorUnitario, aValorServico, aBaseCalculo,
      aAliquota: Double; aDescontoIncondicionado: Double): string;
    function GerarJson(const xDescricao: string; const xCodigoItem: string;
      aQuantidade, aValorUnitario, aValorServico, aBaseCalculo,
      aAliquota: Double): string;

    function GerarCNPJ(const CNPJ: string): TACBrXmlNode; virtual;
    function GerarCPFCNPJ(const CPFCNPJ: string): TACBrXmlNode; virtual;
    function NormatizarItemServico(const Codigo: string): string;
    function FormatarItemServico(const Codigo: string; Formato: TFormatoItemListaServico): string;
    function NormatizarAliquota(const Aliquota: Double; DivPor100: Boolean = False): Double;
    function ObterNomeMunicipioUF(ACodigoMunicipio: Integer; var xUF: string): string;

    // Reforma Tributária
    function GerarXMLIBSCBS(IBSCBS: TIBSCBSDPS): TACBrXmlNode;
    function GerarXMLgRefNFSe(gRefNFSe: TgRefNFSeCollection): TACBrXmlNode;

    function GerarXMLDestinatario(Dest: TDadosdaPessoa): TACBrXmlNode;
    function GerarXMLEnderecoDestinatario(ender: Tender): TACBrXmlNode;
    function GerarXMLEnderecoNacionalDestinatario(endNac: TendNac): TACBrXmlNode;
    function GerarXMLEnderecoExteriorDestinatario(endExt: TendExt): TACBrXmlNode;

    function GerarXMLImovel(Imovel: TDadosimovel): TACBrXmlNode;
    function GerarXMLEnderecoNacionalImovel(ender: TenderImovel): TACBrXmlNode;
    function GerarXMLEnderecoExteriorImovel(endExt: TendExt): TACBrXmlNode;

    function GerarXMLIBSCBSValores(valores: Tvalorestrib): TACBrXmlNode; virtual;
    function GerarXMLgReeRepRes(gReeRepRes: TgReeRepRes): TACBrXmlNode;
    function GerarXMLDocumentos: TACBrXmlNodeArray;
    function GerarXMLdFeNacional(dFeNacional: TdFeNacional): TACBrXmlNode;
    function GerarXMLdocFiscalOutro(docFiscalOutro: TdocFiscalOutro): TACBrXmlNode;
    function GerarXMLdocOutro(docOutro: TdocOutro): TACBrXmlNode;
    function GerarXMLfornec(fornec: Tfornec): TACBrXmlNode;

    function GerarXMLTributos(trib: Ttrib): TACBrXmlNode;
    function GerarXMLgIBSCBS(gIBSCBS: TgIBSCBS): TACBrXmlNode;
    function GerarXMLgTribRegular(gTribRegular: TgTribRegular): TACBrXmlNode;
    function GerarXMLgDif(gDif: TgDif): TACBrXmlNode;
    // Reforma Tributária DPS
    procedure GerarINIIBSCBS(AINIRec: TMemIniFile; IBSCBS: TIBSCBSDPS);
    procedure GerarINIgRefNFSe(AINIRec: TMemIniFile; gRefNFSe: TgRefNFSeCollection);
    procedure GerarINIDestinatario(AINIRec: TMemIniFile; Dest: TDadosdaPessoa);
    procedure GerarINIImovel(AINIRec: TMemIniFile; Imovel: TDadosimovel);
    procedure GerarINIIBSCBSValores(AINIRec: TMemIniFile; Valores: Tvalorestrib);
    procedure GerarINIDocumentos(AINIRec: TMemIniFile; Documentos: TdocumentosCollection);
    procedure GerarINITributacao(AINIRec: TMemIniFile; Tributacao: Ttrib);
    procedure GerarINIgIBSCBS(AINIRec: TMemIniFile; gIBSCBS: TgIBSCBS);
    procedure GerarINIgTribRegular(AINIRec: TMemIniFile; gTribRegular: TgTribRegular);
    procedure GerarINIgDif(AINIRec: TMemIniFile; gDif: TgDif);
    // Reforma Tributária NFSe
    procedure GerarINIIBSCBSNFSe(AINIRec: TMemIniFile; IBSCBS: TIBSCBSNfse);
    procedure GerarINIIBSCBSValoresNFSe(AINIRec: TMemIniFile; Valores: TvaloresIBSCBS);
    procedure GerarINITotCIBS(AINIRec: TMemIniFile; TotCIBS: TTotCIBS);
    procedure GerarINIgTribRegularNFSe(AINIRec: TMemIniFile; gTribRegularNFSe: TgTribRegularNFSe);
    procedure GerarINIgTribCompraGov(AINIRec: TMemIniFile; gTribCompraGov: TgTribCompraGov);
    procedure GerarINITotgIBS(AINIRec: TMemIniFile; TotgIBS: TgIBS);
    procedure GerarINITotgCBS(AINIRec: TMemIniFile; TotgCBS: TgCBS);

    function GerarIniRps: string;
    function GerarIniNfse: string;
 public
    constructor Create(AOwner: IACBrNFSeXProvider); virtual;
    destructor Destroy; override;

    function ObterNomeArquivo: String; overload;
    function ConteudoTxt: String;

    function GerarXml: Boolean; Override;
    function GerarIni: string; virtual;

    property Opcoes: TACBrXmlWriterOptions read GetOpcoes write SetOpcoes;

    property NFSe: TNFSe                 read FNFSe           write FNFSe;
    property VersaoNFSe: TVersaoNFSe     read FVersaoNFSe     write FVersaoNFSe;
    property Ambiente: TACBrTipoAmbiente read FAmbiente       write FAmbiente default taHomologacao;
    property CodMunEmit: Integer         read FCodMunEmit     write FCodMunEmit;
    property Usuario: string             read FUsuario        write FUsuario;
    property Senha: string               read FSenha          write FSenha;
    property ChaveAcesso: string         read FChaveAcesso    write FChaveAcesso;
    property ChaveAutoriz: string        read FChaveAutoriz   write FChaveAutoriz;
    property FraseSecreta: string        read FFraseSecreta   write FFraseSecreta;
    property CNPJPrefeitura: string      read FCNPJPrefeitura write FCNPJPrefeitura;
    property Provedor: TnfseProvedor     read FProvedor       write FProvedor;

    property FormatoEmissao: TACBrTipoCampo     read FFormatoEmissao     write FFormatoEmissao;
    property FormatoCompetencia: TACBrTipoCampo read FFormatoCompetencia write FFormatoCompetencia;

    property FormatoItemListaServico: TFormatoItemListaServico read FFormItemLServico write FFormItemLServico;
    property FormatoDiscriminacao: TFormatoDiscriminacao read FFormDiscriminacao write FFormDiscriminacao;

    property FormatoAliq: TACBrTipoCampo read FFormatoAliq  write FFormatoAliq;
    property DivAliq100: Boolean         read FDivAliq100   write FDivAliq100;
    property NrMinExigISS: Integer       read FNrMinExigISS write FNrMinExigISS;
    property NrMaxExigISS: Integer       read FNrMaxExigISS write FNrMaxExigISS;

    property NrOcorrItemListaServico: Integer read FNrOcorrItemListaServico write FNrOcorrItemListaServico;

    property GerarIDRps: Boolean read FGerarIDRps write FGerarIDRps;
    property GerarNSRps: Boolean read FGerarNSRps write FGerarNSRps;
    property IniParams: TMemIniFile read FIniParams write FIniParams;
    // Reforma Tributária NFSe
    property NrOcorrtpOper: Integer read FNrOcorrtpOper write FNrOcorrtpOper;
    property NrOcorrindDest: Integer read FNrOcorrindDest write FNrOcorrindDest;
    property NrOcorrCST: Integer read FNrOcorrCST write FNrOcorrCST;
    property NrOcorrcCredPres: Integer read FNrOcorrcCredPres write FNrOcorrcCredPres;
    property NrOcorrCSTReg: Integer read FNrOcorrCSTReg write FNrOcorrCSTReg;
    property NrOcorrtpAmb: Integer read FNrOcorrtpAmb write FNrOcorrtpAmb;

    property GerarDest: Boolean read FGerarDest write FGerarDest;
    property GerarImovel: Boolean read FGerarImovel write FGerarImovel;
    property GerargReeRepRes: Boolean read FGerargReeRepRes write FGerargReeRepRes;
    property GerarTribRegular: Boolean read FGerarTribRegular write FGerarTribRegular;
    property GerargDif: Boolean read FGerargDif write FGerargDif;
  end;

implementation

uses
  ACBrUtil.Strings,
  ACBrDFeConsts,
  ACBrDFeException,
  ACBrNFSeX,
  ACBrNFSeXConsts;

{ TNFSeWClass }

constructor TNFSeWClass.Create(AOwner: IACBrNFSeXProvider);
begin
  inherited Create;

  FpAOwner := AOwner;

  TXmlWriterOptions(Opcoes).AjustarTagNro := True;
  TXmlWriterOptions(Opcoes).NormatizarMunicipios := False;
  TXmlWriterOptions(Opcoes).PathArquivoMunicipios := '';
  TXmlWriterOptions(Opcoes).ValidarInscricoes := False;
  TXmlWriterOptions(Opcoes).ValidarListaServicos := False;

  FConteudoTxt := TStringList.Create;
  FConteudoTxt.Clear;

  Configuracao;
end;

procedure TNFSeWClass.Configuracao;
begin
  // Propriedades de Formatação de informações
  FFormatoEmissao := tcDatHor;
  FFormatoCompetencia := tcDatHor;
  FFormDiscriminacao := fdNenhum;
  FFormItemLServico := filsComFormatacao;

  // Os 4 IF abaixo vão configurar o componente conforme a presença do
  // parâmetro no arquivo ACBrNFSeXServicos.ini
  // Ou seja, configuração a nível de cidade.
  if FpAOwner.ConfigGeral.Params.TemParametro('NaoFormatarItemServico') then
    FFormItemLServico := filsSemFormatacao;

  if FpAOwner.ConfigGeral.Params.TemParametro('NaoFormatarItemServicoSemZeroEsquerda') then
    FFormItemLServico := filsSemFormatacaoSemZeroEsquerda;

  if FpAOwner.ConfigGeral.Params.TemParametro('FormatarItemServicoSemZeroEsquerda') then
    FFormItemLServico := filsComFormatacaoSemZeroEsquerda;

  if FpAOwner.ConfigGeral.Params.TemParametro('FormatarItemServicoNaoSeAplica') then
    FFormItemLServico := filsNaoSeAplica;

  FFormatoAliq := tcDe4;

  if FpAOwner.ConfigGeral.Params.TemParametro('Aliquota2Casas') then
    FFormatoAliq := tcDe2;

  FDivAliq100  := False;

  if FpAOwner.ConfigGeral.Params.TemParametro('Dividir100') then
    FDivAliq100 := True;

  FNrMinExigISS := 1;
  FNrMaxExigISS := 1;

  FNrOcorrItemListaServico := 1;

  // Gera ou não o atributo ID no grupo <Rps> da versão 2 do layout da ABRASF.
  FGerarIDRps := False;
  // Gera ou não o NameSpace no grupo <Rps> da versão 2 do layout da ABRASF.
  FGerarNSRps := True;

  // Reforma Tributária
  FNrOcorrtpOper := 0;
  FNrOcorrindDest := 1;
  FNrOcorrCST := 1;
  FNrOcorrcCredPres := 0;
  FNrOcorrCSTReg := 1;
  FNrOcorrtpAmb := 1;

  FGerarDest := True;
  FGerarImovel := True;
  FGerargReeRepRes := True;
  FGerarTribRegular := True;
  FGerargDif := True;
end;

procedure TNFSeWClass.ConsolidarVariosItensServicosEmUmSo;
var
  i: Integer;
  xDiscriminacao, xItemListaServ: string;
  vValorDeducoes, vValorServicos, vDescontoCondicionado, vAliquota, vBaseCalculo,
  vDescontoIncondicionado, vValorPis, vValorCofins, vValorInss, vValorIr,
  vValorCsll, vValorIss, vAliquotaPis, vAliquotaCofins, vAliquotaInss,
  vAliquotaIr, vAliquotaCsll, vValorIssRetido: Double;
begin
  if NFSe.Servico.ItemServico.Count > 0 then
  begin
    xDiscriminacao := '';
    vValorDeducoes := 0;
    vValorServicos := 0;
    vDescontoCondicionado := 0;
    vDescontoIncondicionado := 0;
    vBaseCalculo := 0;
    vValorPis := 0;
    vValorCofins := 0;
    vValorInss := 0;
    vValorIr := 0;
    vValorCsll := 0;
    vValorIss := 0;
    vValorIssRetido := 0;
    vAliquota := 0;
    vAliquotaPis := 0;
    vAliquotaCofins := 0;
    vAliquotaInss := 0;
    vAliquotaIr := 0;
    vAliquotaCsll := 0;

    with FNFSe.Servico do
    begin
      for i := 0 to ItemServico.Count -1 do
      begin
        xItemListaServ := ItemServico[i].ItemListaServico;
        vAliquota := ItemServico[i].Aliquota;
        vAliquotaPis := ItemServico[i].AliqRetPIS;
        vAliquotaCofins := ItemServico[i].AliqRetCOFINS;
        vAliquotaInss := ItemServico[i].AliqRetINSS;
        vAliquotaIr := ItemServico[i].AliqRetIRRF;
        vAliquotaCsll := ItemServico[i].AliqRetCSLL;

        vValorDeducoes := vValorDeducoes + ItemServico[i].ValorDeducoes;
        vValorServicos := vValorServicos + ItemServico[i].ValorTotal;
        vDescontoCondicionado := vDescontoCondicionado + ItemServico[i].DescontoCondicionado;
        vDescontoIncondicionado := vDescontoIncondicionado + ItemServico[i].DescontoIncondicionado;
        vBaseCalculo := vBaseCalculo + ItemServico[i].BaseCalculo;
        vValorPis := vValorPis + ItemServico[i].ValorPis;
        vValorCofins := vValorCofins + ItemServico[i].ValorCofins;
        vValorInss := vValorInss + ItemServico[i].ValorInss;
        vValorIr := vValorIr + ItemServico[i].ValorIRRF;
        vValorCsll := vValorCsll + ItemServico[i].ValorCsll;
        vValorIss := vValorIss + ItemServico[i].ValorIss;
        vValorIssRetido := vValorIssRetido + ItemServico[i].ValorIssRetido;

        case FormatoDiscriminacao of
          fdTabulado:
            xDiscriminacao := xDiscriminacao +
                                GerarTabulado(ItemServico[i].Descricao,
                                  ItemServico[i].ItemListaServico,
                                  ItemServico[i].Quantidade,
                                  ItemServico[i].ValorUnitario,
                                  ItemServico[i].ValorTotal,
                                  ItemServico[i].BaseCalculo,
                                  ItemServico[i].Aliquota,
                                  ItemServico[i].DescontoIncondicionado);

          fdJson:
            begin
              if i > 0 then
                xDiscriminacao := xDiscriminacao + ',';

              xDiscriminacao := xDiscriminacao +
                                  GerarJson(ItemServico[i].Descricao,
                                    ItemServico[i].ItemListaServico,
                                    ItemServico[i].Quantidade,
                                    ItemServico[i].ValorUnitario,
                                    ItemServico[i].ValorTotal,
                                    ItemServico[i].BaseCalculo,
                                    ItemServico[i].Aliquota);
            end;
        else
          xDiscriminacao := xDiscriminacao +
                  FpAOwner.ConfigGeral.QuebradeLinha + ItemServico[i].Descricao;
        end;
      end;
    end;

    // Leva em consideração a informação do ultimo item da lista.
    NFSe.Servico.ItemListaServico := xItemListaServ;
    NFSe.Servico.Valores.Aliquota := vAliquota;
    NFSe.Servico.Valores.AliquotaPis := vAliquotaPis;
    NFSe.Servico.Valores.AliquotaCofins := vAliquotaCofins;
    NFSe.Servico.Valores.AliquotaInss := vAliquotaInss;
    NFSe.Servico.Valores.AliquotaIr := vAliquotaIr;
    NFSe.Servico.Valores.AliquotaCsll := vAliquotaCsll;

    // Consolida todos os itens da lista.
    case FormatoDiscriminacao of
      fdTabulado:
        NFSe.Servico.Discriminacao := '{' + xDiscriminacao + '}';

      fdJson:
        NFSe.Servico.Discriminacao := '[' + xDiscriminacao + ']';
    else
      NFSe.Servico.Discriminacao := xDiscriminacao;
    end;

    NFSe.Servico.Valores.ValorDeducoes := vValorDeducoes;
    NFSe.Servico.Valores.ValorServicos := vValorServicos;
    NFSe.Servico.Valores.DescontoCondicionado := vDescontoCondicionado;
    NFSe.Servico.Valores.DescontoIncondicionado := vDescontoIncondicionado;
    NFSe.Servico.Valores.BaseCalculo := vBaseCalculo;
    NFSe.Servico.Valores.ValorPis := vValorPis;
    NFSe.Servico.Valores.ValorCofins := vValorCofins;
    NFSe.Servico.Valores.ValorInss := vValorInss;
    NFSe.Servico.Valores.ValorIr := vValorIr;
    NFSe.Servico.Valores.ValorCsll := vValorCsll;
    NFSe.Servico.Valores.ValorIss := vValorIss;
    NFSe.Servico.Valores.ValorIssRetido := vValorIssRetido;
  end;
end;

function TNFSeWClass.GerarTabulado(const xDescricao, xCodigoItem: string;
  aQuantidade, aValorUnitario, aValorServico, aBaseCalculo,
  aAliquota: Double; aDescontoIncondicionado: Double): string;
begin
  Result := '[[Descricao=' + xDescricao + ']' +
             '[ItemServico=' + xCodigoItem + ']' +
             '[Quantidade=' + FloatToString(aQuantidade, Opcoes.DecimalChar) + ']' +
             '[ValorUnitario=' + FloatToString(aValorUnitario, Opcoes.DecimalChar) + ']' +
             '[ValorServico=' + FloatToString(aValorServico, Opcoes.DecimalChar) + ']' +
             '[ValorBaseCalculo=' + FloatToString(aBaseCalculo, Opcoes.DecimalChar) + ']' +
             '[Aliquota=' + FloatToString(aAliquota, Opcoes.DecimalChar) + ']' +
             '[DescontoIncondicionado=' + FloatToString(aDescontoIncondicionado, Opcoes.DecimalChar) + ']]';
end;

function TNFSeWClass.GerarJson(const xDescricao, xCodigoItem: string;
  aQuantidade, aValorUnitario, aValorServico, aBaseCalculo,
  aAliquota: Double): string;
begin
  Result := '{"Descricao":"' + xDescricao + '",' +
             '"ItemServico":"' + xCodigoItem + '",' +
             '"ValorUnitario":' + FloatToStr(aValorUnitario) + ',' +
             '"Quantidade":' + FloatToStr(aQuantidade) + ',' +
             '"ValorServico":' + FloatToStr(aValorServico) + ',' +
             '"ValorBaseCalculo":' + FloatToStr(aBaseCalculo) + ',' +
             '"Aliquota":' + FloatToStr(aAliquota) + '}';
end;

function TNFSeWClass.ConteudoTxt: String;
begin
  Result := FConteudoTxt.Text;
end;

procedure TNFSeWClass.DefinirIDRps;
begin
  FNFSe.InfID.ID := 'Rps_' + OnlyNumber(FNFSe.IdentificacaoRps.Numero) +
                    FNFSe.IdentificacaoRps.Serie;
end;

destructor TNFSeWClass.Destroy;
begin
  FConteudoTxt.Free;

  inherited Destroy;
end;

function TNFSeWClass.FormatarItemServico(const Codigo: string;
  Formato: TFormatoItemListaServico): string;
var
  item: string;
begin
  item := Codigo;

  if Formato <> filsNaoSeAplica then
    item := NormatizarItemServico(item);

  case Formato of
    filsSemFormatacao:
      Result := OnlyNumber(item);

    filsComFormatacaoSemZeroEsquerda:
      if Copy(item, 1, 1) = '0' then
        Result := Copy(item, 2, 4)
      else
        Result := item;

    filsSemFormatacaoSemZeroEsquerda:
      begin
        Result := OnlyNumber(item);

        if Copy(Result, 1, 1) = '0' then
          Result := Copy(Result, 2, 4);
      end
  else
    Result := item;
  end;
end;

procedure TNFSeWClass.DefinirIDDeclaracao;
begin
  FNFSe.InfID.ID := 'Dec_' + OnlyNumber(FNFSe.IdentificacaoRps.Numero) +
                    FNFSe.IdentificacaoRps.Serie;
end;

function TNFSeWClass.CreateOptions: TACBrXmlWriterOptions;
begin
  Result := TXmlWriterOptions.Create();
end;

function TNFSeWClass.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

function TNFSeWClass.ObterNomeMunicipioUF(ACodigoMunicipio: Integer;
  var xUF: string): string;
var
  CodIBGE: string;
begin
  CodIBGE := IntToStr(ACodigoMunicipio);

  xUF := IniParams.ReadString(CodIBGE, 'UF', '');
  Result := IniParams.ReadString(CodIBGE, 'Nome', '');
end;

function TNFSeWClass.NormatizarAliquota(const Aliquota: Double; DivPor100: Boolean = False): Double;
var
  Aliq: Double;
begin
  if Aliquota < 1 then
    Aliq := Aliquota * 100
  else
    Aliq := Aliquota;

  if DivPor100 then
    Result := Aliq / 100
  else
    Result := Aliq;
end;

function TNFSeWClass.NormatizarItemServico(const Codigo: string): string;
var
  i: Integer;
  item: string;
begin
  if Length(Codigo) <= 5 then
  begin
    item := OnlyNumber(Codigo);

    i := StrToIntDef(item, 0);
    item := Poem_Zeros(i, 4);

    Result := Copy(item, 1, 2) + '.' + Copy(item, 3, 2);
  end
  else
    Result := Codigo;
end;

function TNFSeWClass.GetOpcoes: TACBrXmlWriterOptions;
begin
  Result := TXmlWriterOptions(FOpcoes);
end;

procedure TNFSeWClass.SetOpcoes(AValue: TACBrXmlWriterOptions);
begin
  FOpcoes := AValue;
end;

function TNFSeWClass.GerarCNPJ(const CNPJ: string): TACBrXmlNode;
begin
  Result := AddNode(tcStr, '#34', 'Cnpj', 14, 14, 1, OnlyNumber(CNPJ), DSC_CNPJ);
end;

function TNFSeWClass.GerarCPFCNPJ(const CPFCNPJ: string): TACBrXmlNode;
var
  aDoc: string;
begin
  // Em conformidade com a versão 1 do layout da ABRASF não deve ser alterado
  aDoc := OnlyNumber(CPFCNPJ);

  Result := CreateElement('CpfCnpj');

  if length(aDoc) <= 11 then
    Result.AppendChild(AddNode(tcStr, '#34', 'Cpf ', 11, 11, 1, aDoc, DSC_CPF))
  else
    Result.AppendChild(AddNode(tcStr, '#34', 'Cnpj', 14, 14, 1, aDoc, DSC_CNPJ));
end;

function TNFSeWClass.GerarXml: Boolean;
begin
  Result := False;
  raise EACBrNFSeException.Create(ClassName + '.GerarXml, não implementado');
end;

function TNFSeWClass.GerarIni: string;
begin
  // Usar o FpAOwner em vez de  FProvider

//  if NFSe.tpXML = txmlRPS then
  Result := GerarIniRps
//  else
//    Result := GerarIniNfse;

//  Result := '';
//  raise EACBrNFSeException.Create(ClassName + '.GerarIni, não implementado');
end;

function TNFSeWClass.GerarIniNfse: string;
begin
  Result := '';
end;

function TNFSeWClass.GerarIniRps: string;
var
  I: integer;
  sSecao: string;
  INIRec: TMemIniFile;
  IniNFSe: TStringList;
  fornec: TInfoPessoa;
begin
  Result:= '';

  INIRec := TMemIniFile.Create('');
  try
    with FNFSe do
    begin
      //Provedor Infisc - Layout Proprio
      sSecao:= 'IdentificacaoNFSe';

      if tpXML = txmlRPS then
        INIRec.WriteString(sSecao, 'TipoXML', 'RPS')
      else
        INIRec.WriteString(sSecao, 'TipoXML', 'NFSE');

      INIRec.WriteString(sSecao, 'Numero', Numero);
      INIRec.WriteString(sSecao, 'NumeroLote', NumeroLote);
      INIRec.WriteString(sSecao, 'StatusNFSe', StatusNFSeToStr(SituacaoNfse));

      if CodigoVerificacao <> '' then
        INIRec.WriteString(sSecao, 'CodigoVerificacao', CodigoVerificacao);

      if InfNFSe.Id <> '' then
        INIRec.WriteString(sSecao, 'ID', InfNFse.ID);

      if NfseSubstituida <> '' then
        INIRec.WriteString(sSecao, 'NfseSubstituida', NfseSubstituida);

      if NfseSubstituidora <> '' then
        INIRec.WriteString(sSecao, 'NfseSubstituidora', NfseSubstituidora);

      INIRec.WriteFloat(sSecao, 'ValorCredito', ValorCredito);
      INIRec.WriteString(sSecao, 'ChaveAcesso', ChaveAcesso);
      INIRec.WriteString(sSecao, 'Link', Link);
      INIRec.WriteString(sSecao, 'DescricaoCodigoTributacaoMunicipio', DescricaoCodigoTributacaoMunicipio);
      INIRec.WriteString(sSecao, 'refNF', refNF);
      INIRec.WriteString(sSecao, 'TipoEmissao', TipoEmissaoToStr(TipoEmissao));
      INIRec.WriteString(sSecao, 'EmpreitadaGlobal', EmpreitadaGlobalToStr(EmpreitadaGlobal));
      INIRec.WriteString(sSecao, 'ModeloNFSe', ModeloNFSe);
      INIRec.WriteString(sSecao, 'Canhoto', CanhotoToStr(Canhoto));

      if Trim(Assinatura) <> '' then
        INIRec.WriteString(sSecao, 'Assinatura', Assinatura);

      INIRec.WriteString(sSecao, 'Transacao', FpAOwner.SimNaoToStr(Transacao));

      sSecao:= 'IdentificacaoRps';
      INIRec.WriteString(sSecao, 'SituacaoTrib', FpAOwner.SituacaoTribToStr(SituacaoTrib));
      INIRec.WriteString(sSecao, 'Producao', FpAOwner.SimNaoToStr(Producao));
      INIRec.WriteString(sSecao, 'Status', FpAOwner.StatusRPSToStr(StatusRps));
      INIRec.WriteString(sSecao, 'OutrasInformacoes', StringReplace(OutrasInformacoes, sLineBreak, FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]));

      //Provedores CTA, ISSBarueri, ISSSDSF, ISSSaoPaulo, Simple e SmarAPD.
      INIRec.WriteString(sSecao, 'TipoTributacaoRps', FpAOwner.TipoTributacaoRPSToStr(TipoTributacaoRPS));

      INIRec.WriteString(sSecao, 'TipoRecolhimento', TipoRecolhimento);

      // Provedores ISSDSF e Siat
      INIRec.WriteString(sSecao, 'SeriePrestacao', SeriePrestacao);
      INIRec.WriteString(sSecao, 'IdentificacaoRemessa', IdentificacaoRemessa);
      INIRec.WriteString(sSecao, 'Numero', IdentificacaoRps.Numero);
      INIRec.WriteString(sSecao, 'Serie', IdentificacaoRps.Serie);
      INIRec.WriteString(sSecao, 'Tipo', FpAOwner.TipoRPSToStr(IdentificacaoRps.Tipo));

      if DataEmissao > 0 then
        INIRec.WriteDateTime(sSecao, 'DataEmissao', DataEmissao)
      else
        INIRec.WriteDateTime(sSecao, 'DataEmissao', Now);

      if DataEmissaoRps > 0 then
        INIRec.WriteDateTime(sSecao, 'DataEmissaoRps', DataEmissaoRps);

      if Competencia > 0 then
        INIRec.WriteDate(sSecao, 'Competencia', Competencia)
      else
        IniRec.WriteDate(sSecao, 'Competencia', Now);

      if Vencimento > 0 then
        INIRec.WriteDate(sSecao, 'Vencimento', Vencimento)
      else
        INIRec.WriteDate(sSecao, 'Vencimento', Now);

      if DataPagamento > 0 then
        INIRec.WriteDate(sSecao, 'DataPagamento', DataPagamento)
      else
        INIRec.WriteDate(sSecao, 'DataPagamento', Now);

      if dhRecebimento > 0 then
        INIRec.WriteDate(sSecao, 'dhRecebimento', dhRecebimento)
      else
        INIRec.WriteDate(sSecao, 'dhRecebimento', Now);

      INIRec.WriteString(sSecao, 'NaturezaOperacao', NaturezaOperacaoToStr(NaturezaOperacao));

      // Provedor Tecnos
      INIRec.WriteFloat(sSecao, 'PercentualCargaTributaria', PercentualCargaTributaria);
      INIRec.WriteFloat(sSecao, 'ValorCargaTributaria', ValorCargaTributaria);
      INIRec.WriteFloat(sSecao, 'PercentualCargaTributariaMunicipal', PercentualCargaTributariaMunicipal);
      INIRec.WriteFloat(sSecao, 'ValorCargaTributariaMunicipal', ValorCargaTributariaMunicipal);
      INIRec.WriteFloat(sSecao, 'PercentualCargaTributariaEstadual', PercentualCargaTributariaEstadual);
      INIRec.WriteFloat(sSecao, 'ValorCargaTributariaEstadual', ValorCargaTributariaEstadual);

      //Padrão Nacional
      INIRec.WriteString(sSecao, 'verAplic', verAplic);
      INIRec.WriteString(sSecao, 'tpEmit', tpEmitToStr(tpEmit));

      //Provedor Governa
      INIRec.WriteString(sSecao, 'RegRec', RegRecToStr(RegRec));
      INIRec.WriteString(sSecao, 'FrmRec', FrmRecToStr(FrmRec));

      INIRec.WriteString(sSecao, 'InformacoesComplementares', InformacoesComplementares);
      INIRec.WriteInteger(sSecao, 'Situacao', Situacao);
      INIRec.WriteString(sSecao, 'EqptoRecibo', EqptoRecibo);
      INIRec.WriteInteger(sSecao, 'TipoNota', TipoNota);
      //Tecnos
      INIRec.WriteString(sSecao, 'SiglaUF', SiglaUF);
      INIRec.WriteInteger(sSecao, 'EspecieDocumento', EspecieDocumento);
      INIRec.WriteInteger(sSecao, 'SerieTalonario', SerieTalonario);
      INIRec.WriteInteger(sSecao, 'FormaPagamento', FormaPagamento);
      INIRec.WriteInteger(sSecao, 'NumeroParcelas', NumeroParcelas);
      INIRec.WriteInteger(sSecao, 'id_sis_legado', id_sis_legado);
      INIRec.WriteString(sSecao, 'DeducaoMateriais', FpAOwner.SimNaoToStr(DeducaoMateriais));

      if RpsSubstituido.Numero <> '' then
      begin
        sSecao:= 'RpsSubstituido';
        INIRec.WriteString(sSecao, 'Numero', RpsSubstituido.Numero);
        INIRec.WriteString(sSecao, 'Serie', RpsSubstituido.Serie);
        INIRec.WriteString(sSecao, 'Tipo', FpAOwner.TipoRPSToStr(RpsSubstituido.Tipo));
      end;

      //Padrão Nacional
      if Trim(subst.chSubstda) <> '' then
      begin
        sSecao := 'NFSeSubstituicao';
        INIRec.WriteString(sSecao, 'chSubstda', subst.chSubstda);
        INIRec.WriteString(sSecao, 'cMotivo', cMotivoToStr(subst.cMotivo));
        INIRec.WriteString(sSecao, 'xMotivo', subst.xMotivo);
      end;

      if (NfseCancelamento.DataHora > 0) or (Trim(MotivoCancelamento) <> '')then
      begin
        sSecao := 'NFSeCancelamento';
        INIRec.WriteString(sSecao, 'MotivoCancelamento', MotivoCancelamento);
        INIRec.WriteString(sSecao, 'JustificativaCancelamento', JustificativaCancelamento);
        INIRec.WriteString(sSecao, 'CodigoCancelamento', CodigoCancelamento);
        INIRec.WriteString(sSecao, 'NumeroNFSe', NFSeCancelamento.Pedido.IdentificacaoNfse.Numero);
        INIRec.WriteString(sSecao, 'CNPJ', NfseCancelamento.Pedido.IdentificacaoNfse.Cnpj);
        INIRec.WriteString(sSecao, 'InscricaoMunicipal', NFSeCancelamento.Pedido.IdentificacaoNfse.InscricaoMunicipal);
        INIRec.WriteString(sSecao, 'CodigoMunicipio', NFSeCancelamento.Pedido.IdentificacaoNfse.CodigoMunicipio);
        INIRec.WriteString(sSecao, 'CodCancel', NfseCancelamento.Pedido.CodigoCancelamento);
        INIRec.WriteBool(sSecao, 'Sucesso', NFSeCancelamento.Sucesso);
        INIRec.WriteDateTime(sSecao, 'DataHora', NfSeCancelamento.DataHora);
      end;

      sSecao:= 'Prestador';
      INIRec.WriteString(sSecao, 'Regime', FpAOwner.RegimeEspecialTributacaoToStr(RegimeEspecialTributacao));
      INIRec.WriteString(sSecao, 'OptanteSN', FpAOwner.SimNaoToStr(OptanteSimplesNacional));
      INIRec.WriteString(sSecao, 'opSimpNac', OptanteSNToStr(OptanteSN));
      INIRec.WriteString(sSecao, 'OptanteMEISimei', FpAOwner.SimNaoToStr(OptanteMEISimei));
      if DataOptanteSimplesNacional > 0 then
        INIRec.WriteDateTime(sSecao, 'DataOptanteSimplesNacional', DataOptanteSimplesNacional);
      INIRec.WriteString(sSecao, 'crc', Prestador.crc);
      INIRec.WriteString(sSecao, 'crc_estado', Prestador.crc_estado);
      INIRec.WriteString(sSecao, 'IncentivadorCultural', FpAOwner.SimNaoToStr(IncentivadorCultural));
      INIRec.WriteString(sSecao, 'CNPJ', Prestador.IdentificacaoPrestador.CpfCnpj);
      INIRec.WriteString(sSecao, 'InscricaoMunicipal', Prestador.IdentificacaoPrestador.InscricaoMunicipal);
      INIRec.WriteString(sSecao, 'RegimeApuracaoSN', RegimeApuracaoSNToStr(RegimeApuracaoSN));
      INIRec.WriteString(sSecao, 'InscricaoEstadual', Prestador.IdentificacaoPrestador.InscricaoEstadual);
      INIRec.WriteString(sSecao, 'NIF', Prestador.IdentificacaoPrestador.NIF);
      INIRec.WriteString(sSecao, 'cNaoNIF', NaoNIFToStr(Prestador.IdentificacaoPrestador.cNaoNIF));
      INIRec.WriteString(sSecao, 'CAEPF', Prestador.IdentificacaoPrestador.CAEPF);
      INIRec.WriteString(sSecao, 'TipoPessoa', FpAOwner.TipoPessoaToStr(Prestador.IdentificacaoPrestador.Tipo));

      // Para o provedor ISSDigital deve-se informar tambem:
      INIRec.WriteString(sSecao, 'RazaoSocial', Prestador.RazaoSocial);
      INIRec.WriteString(sSecao, 'NomeFantasia', Prestador.NomeFantasia);
      INIRec.WriteString(sSecao, 'TipoLogradouro', Prestador.Endereco.TipoLogradouro);
      INIRec.WriteString(sSecao, 'Logradouro', Prestador.Endereco.Endereco);
      INIRec.WriteString(sSecao, 'Numero', Prestador.Endereco.Numero);
      INIRec.WriteString(sSecao, 'Complemento', Prestador.Endereco.Complemento);
      INIRec.WriteString(sSecao, 'Bairro', Prestador.Endereco.Bairro);
      INIRec.WriteString(sSecao, 'CodigoMunicipio', Prestador.Endereco.CodigoMunicipio);
      INIRec.WriteString(sSecao, 'xMunicipio', Prestador.Endereco.xMunicipio);
      INIRec.WriteString(sSecao, 'UF',  Prestador.Endereco.UF);
      INIRec.WriteInteger(sSecao, 'CodigoPais', Prestador.Endereco.CodigoPais);
      INIRec.WriteString(sSecao, 'xPais', Prestador.Endereco.xPais);
      INIRec.WriteString(sSecao, 'CEP', Prestador.Endereco.CEP);
      INIRec.WriteString(sSecao, 'DDD', Prestador.Contato.DDD);
      INIRec.WriteString(sSecao, 'Telefone', Prestador.Contato.Telefone);
      INIRec.WriteString(sSecao, 'Email', Prestador.Contato.Email);
      INIRec.WriteString(sSecao, 'xSite', Prestador.Contato.xSite);

      // Para o provedor WebFisco
      if Prestador.Anexo <> '' then
        INIRec.WriteString(sSecao, 'Anexo', Prestador.Anexo);

      if Prestador.ValorReceitaBruta > 0 then
        INIRec.WriteFloat(sSecao, 'ValorReceitaBruta', Prestador.ValorReceitaBruta);

      if Prestador.DataInicioAtividade > 0 then
        INIRec.WriteDate(sSecao, 'DataInicioAtividade', Prestador.DataInicioAtividade);

      sSecao:= 'Tomador';
      INIRec.WriteString(sSecao, 'Tipo', FpAOwner.TipoPessoaToStr(Tomador.IdentificacaoTomador.Tipo));
      INIRec.WriteString(sSecao, 'CNPJCPF', Tomador.IdentificacaoTomador.CpfCnpj);
      INIRec.WriteString(sSecao, 'InscricaoMunicipal', Tomador.IdentificacaoTomador.InscricaoMunicipal);
      INIRec.WriteString(sSecao, 'NIF', Tomador.IdentificacaoTomador.NIF);
      INIRec.WriteString(sSecao, 'cNaoNIF', NaoNIFToStr(Tomador.IdentificacaoTomador.cNaoNIF));
      INIRec.WriteString(sSecao, 'CAEPF', Tomador.IdentificacaoTomador.CAEPF);
      INIRec.WriteString(sSecao, 'DocEstrangeiro', Tomador.IdentificacaoTomador.DocEstrangeiro);
      //Exigido pelo provedor Equiplano
      INIRec.WriteString(sSecao, 'InscricaoEstadual', Tomador.IdentificacaoTomador.InscricaoEstadual);
      INIRec.WriteString(sSecao, 'RazaoSocial', Tomador.RazaoSocial);
      INIRec.WriteString(sSecao, 'NomeFantasia', Tomador.NomeFantasia);

      INIRec.WriteString(sSecao, 'EnderecoInformado', FpAOwner.SimNaoOpcToStr(Tomador.Endereco.EnderecoInformado));
      INIRec.WriteString(sSecao, 'TipoLogradouro', Tomador.Endereco.TipoLogradouro);
      INIRec.WriteString(sSecao, 'Logradouro', Tomador.Endereco.Endereco);
      INIRec.WriteString(sSecao, 'Numero', Tomador.Endereco.Numero);
      INIRec.WriteString(sSecao, 'Complemento', Tomador.Endereco.Complemento);
      INIRec.WriteString(sSecao, 'Bairro', Tomador.Endereco.Bairro);
      INIRec.WriteString(sSecao, 'TipoBairro', Tomador.Endereco.TipoBairro);
      INIRec.WriteString(sSecao, 'CodigoMunicipio', Tomador.Endereco.CodigoMunicipio);
      INIRec.WriteString(sSecao, 'xMunicipio', Tomador.Endereco.xMunicipio);
      INIRec.WriteString(sSecao, 'UF', Tomador.Endereco.UF);
      INIRec.WriteInteger(sSecao, 'CodigoPais', Tomador.Endereco.CodigoPais);
      INIRec.WriteString(sSecao, 'CEP', Tomador.Endereco.CEP);
      INIRec.WriteString(sSecao, 'PontoReferencia', Tomador.Endereco.PontoReferencia);
      //Exigido pelo provedor Equiplano
      INIRec.WriteString(sSecao, 'xPais', Tomador.Endereco.xPais);
      INIRec.WriteString(sSecao, 'DDD', Tomador.Contato.DDD);
      INIRec.WriteString(sSecao, 'TipoTelefone', Tomador.Contato.TipoTelefone);
      INIRec.WriteString(sSecao, 'Telefone', Tomador.Contato.Telefone);
      INIRec.WriteString(sSecao, 'Email', Tomador.Contato.Email);
      INIRec.WriteString(sSecao, 'AtualizaTomador', FpAOwner.SimNaoToStr(Tomador.AtualizaTomador));
      INIRec.WriteString(sSecao, 'TomadorExterior', FpAOwner.SimNaoToStr(Tomador.TomadorExterior));

      if Intermediario.Identificacao.CpfCnpj <> '' then
      begin
        sSecao:= 'Intermediario';
        INIRec.WriteString(sSecao, 'CNPJCPF', Intermediario.Identificacao.CpfCnpj);
        INIRec.WriteString(sSecao, 'InscricaoMunicipal', Intermediario.Identificacao.InscricaoMunicipal);
        INIRec.WriteString(sSecao, 'NIF', Intermediario.Identificacao.NIF);
        INIRec.WriteString(sSecao, 'cNaoNIF', NaoNIFToStr(Intermediario.Identificacao.cNaoNIF));
        INIRec.WriteString(sSecao, 'CAEPF', Intermediario.Identificacao.CAEPF);
        INIRec.WriteString(sSecao, 'RazaoSocial', Intermediario.RazaoSocial);
        INIRec.WriteString(sSecao, 'IssRetido', FpAOwner.SituacaoTributariaToStr(Intermediario.IssRetido));

        if (Intermediario.Endereco.Endereco <> '') or (Intermediario.Endereco.CEP <> '')then
        begin
          INIRec.WriteString(sSecao, 'Logradouro', Intermediario.Endereco.Endereco);
          INIRec.WriteString(sSecao, 'Numero', Intermediario.Endereco.Numero);
          INIRec.WriteString(sSecao, 'Complemento', Intermediario.Endereco.Complemento);
          INIRec.WriteString(sSecao, 'Bairro', Intermediario.Endereco.Bairro);
          INIRec.WriteString(sSecao, 'CodigoMunicipio', Intermediario.Endereco.CodigoMunicipio);
          INIRec.WriteString(sSecao, 'xMunicipio', Intermediario.Endereco.xMunicipio);
          INIRec.WriteString(sSecao, 'UF', Intermediario.Endereco.UF);
          INIRec.WriteInteger(sSecao, 'CodigoPais', Intermediario.Endereco.CodigoPais);
          INIRec.WriteString(sSecao, 'CEP', Intermediario.Endereco.CEP);
          INIRec.WriteString(sSecao, 'xPais', Intermediario.Endereco.xPais);
        end;

        INIRec.WriteString(sSecao, 'Telefone', Intermediario.Contato.Telefone);
        INIRec.WriteString(sSecao, 'Email', Intermediario.Contato.Email);
      end;

      if Trim(Transportadora.xCpfCnpjTrans) <> '' then
      begin
        //SmarAPD, Infisc.
        sSecao := 'Transportadora';
        INIRec.WriteString(sSecao, 'xNomeTrans', Transportadora.xNomeTrans);
        INIRec.WriteString(sSecao, 'xCpfCnpjTrans', Transportadora.xCpfCnpjTrans);
        INIRec.WriteString(sSecao, 'xInscEstTrans', Transportadora.xInscEstTrans);
        INIRec.WriteString(sSecao, 'xPlacaTrans', Transportadora.xPlacaTrans);
        INIRec.WriteString(sSecao, 'xEndTrans', Transportadora.xEndTrans);
        INIRec.WriteInteger(sSecao, 'cMunTrans', Transportadora.cMunTrans);
        INIRec.WriteString(sSecao, 'xMunTrans', Transportadora.xMunTrans);
        INIRec.WriteString(sSecao, 'xUFTrans', Transportadora.xUFTrans);
        INIRec.WriteString(sSecao, 'xPaisTrans', Transportadora.xPaisTrans);
        INIRec.WriteString(sSecao, 'vTipoFreteTrans', TipoFreteToStr(Transportadora.vTipoFreteTrans));
      end;

      if (ConstrucaoCivil.CodigoObra <> '') or (ConstrucaoCivil.nCei <> '') or
         (ConstrucaoCivil.Endereco.CEP <> '') then
      begin
        sSecao:= 'ConstrucaoCivil';

        if ConstrucaoCivil.Tipo > 0 then
        begin
          INIRec.WriteInteger(sSecao, 'TipoIdentificacaoObra', ConstrucaoCivil.Tipo);

          if (ConstrucaoCivil.Tipo = 2) and (ConstrucaoCivil.CodigoObra <> '') then
            INIRec.WriteString(sSecao, 'CodigoObra', ConstrucaoCivil.CodigoObra);

          if (ConstrucaoCivil.Tipo = 2) and (ConstrucaoCivil.nCei <> '') then
            INIRec.WriteString(sSecao, 'CodigoObra', ConstrucaoCivil.nCei);

          if (ConstrucaoCivil.Tipo = 1) then
          begin
            if (ConstrucaoCivil.Endereco.Endereco <> '') or (ConstrucaoCivil.Endereco.CEP <> '') then
            begin
              INIRec.WriteString(sSecao, 'CEP', ConstrucaoCivil.Endereco.CEP);
              INIRec.WriteString(sSecao, 'xMunicipio', ConstrucaoCivil.Endereco.XMunicipio);
              INIRec.WriteString(sSecao, 'UF', ConstrucaoCivil.Endereco.UF);
              INIRec.WriteString(sSecao, 'Logradouro', ConstrucaoCivil.Endereco.Endereco);
              INIRec.WriteString(sSecao, 'Numero', ConstrucaoCivil.Endereco.Numero);
              INIRec.WriteString(sSecao, 'Complemento', ConstrucaoCivil.Endereco.Complemento);
              INIRec.WriteString(sSecao, 'Bairro', ConstrucaoCivil.Endereco.Bairro);
            end;
          end;

          INIRec.WriteString(sSecao, 'Art', ConstrucaoCivil.Art);
          INIRec.WriteString(sSecao, 'nCei', ConstrucaoCivil.nCei);
          INIRec.WriteString(sSecao, 'nProj', ConstrucaoCivil.nProj);
          INIRec.WriteString(sSecao, 'nMatri', ConstrucaoCivil.nMatri);
          INIRec.WriteString(sSecao, 'nNumeroEncapsulamento', ConstrucaoCivil.nNumeroEncapsulamento);
          //Padrão Nacional
          INIRec.WriteString(sSecao, 'inscImobFisc', ConstrucaoCivil.inscImobFisc);
        end;
      end;

      sSecao:= 'Servico';
      INIRec.WriteString(sSecao, 'ItemListaServico', Servico.ItemListaServico);
      INIRec.WriteString(sSecao, 'xItemListaServico', Servico.xItemListaServico);
      INIRec.WriteString(sSecao, 'CodigoCnae', Servico.CodigoCnae);
      INIRec.WriteString(sSecao, 'CodigoTributacaoMunicipio', Servico.CodigoTributacaoMunicipio);
      INIRec.WriteString(sSecao, 'xCodigoTributacaoMunicipio', Servico.xCodigoTributacaoMunicipio);
      INIRec.WriteString(sSecao, 'Discriminacao', ChangeLineBreak(Servico.Discriminacao, FpAOwner.ConfigGeral.QuebradeLinha));
      INIRec.WriteString(sSecao, 'Descricao', ChangeLineBreak(Servico.Descricao, FpAOwner.ConfigGeral.QuebradeLinha));
      INIRec.WriteString(sSecao, 'CodigoMunicipio', Servico.CodigoMunicipio);
      INIRec.WriteInteger(sSecao, 'CodigoPais', Servico.CodigoPais);
      INIRec.WriteString(sSecao, 'ExigibilidadeISS', FpAOwner.ExigibilidadeISSToStr(Servico.ExigibilidadeISS));
      INIRec.WriteString(sSecao, 'IdentifNaoExigibilidade', Servico.IdentifNaoExigibilidade);
      INIRec.WriteInteger(sSecao, 'MunicipioIncidencia', Servico.MunicipioIncidencia);
      INIRec.WriteString(sSecao, 'xMunicipioIncidencia',Servico.xMunicipioIncidencia);
      INIRec.WriteString(sSecao, 'NumeroProcesso', Servico.NumeroProcesso);
      INIRec.WriteString(sSecao, 'MunicipioPrestacaoServico', Servico.MunicipioPrestacaoServico);
      INIRec.WriteString(sSecao, 'UFPrestacao', Servico.UFPrestacao);
      INIRec.WriteString(sSecao, 'ResponsavelRetencao', FpAOwner.ResponsavelRetencaoToStr(Servico.ResponsavelRetencao));
      INIRec.WriteString(sSecao, 'TipoLancamento', TipoLancamentoToStr(Servico.TipoLancamento));
      INIRec.WriteFloat(sSecao,'ValorTotalRecebido', Servico.ValorTotalRecebido);
      //Provedor ISSDSF
      INIRec.WriteString(sSecao, 'Operacao', OperacaoToStr(Servico.Operacao));
      INIRec.WriteString(sSecao, 'Tributacao', FpAOwner.TributacaoToStr(Servico.Tributacao));
      //Padrão Nacional e IssNet
      INIRec.WriteString(sSecao, 'CodigoNBS', Servico.CodigoNBS);
      INIRec.WriteString(sSecao, 'CodigoInterContr', Servico.CodigoInterContr);

      // Provedor SoftPlan
      INIRec.WriteString(sSecao, 'CFPS', '');

      // Provedor Giap Informações sobre o Endereço da Prestação de Serviço
      INIRec.WriteString(sSecao, 'Bairro', Servico.Endereco.Bairro);
      INIRec.WriteString(sSecao, 'CEP', Servico.Endereco.CEP);
      INIRec.WriteString(sSecao, 'xMunicipio', Servico.Endereco.xMunicipio);
      INIRec.WriteString(sSecao, 'Complemento', Servico.Endereco.Complemento);
      INIRec.WriteString(sSecao, 'Logradouro', Servico.Endereco.Endereco);
      INIRec.WriteString(sSecao, 'Numero', Servico.Endereco.Numero);
      INIRec.WriteString(sSecao, 'xPais', Servico.Endereco.xPais);
      INIRec.WriteString(sSecao, 'UF', Servico.Endereco.UF);

      //Provedor IssSaoPaulo
      INIRec.WriteFloat(sSecao, 'ValorTotalRecebido', Servico.ValorTotalRecebido);
      INIRec.WriteFloat(sSecao, 'ValorCargaTributaria', Servico.ValorCargaTributaria);
      INIRec.WriteFloat(sSecao, 'PercentualCargaTributaria', Servico.PercentualCargaTributaria);
      INIRec.WriteString(sSecao, 'FonteCargaTributaria', Servico.FonteCargaTributaria);

      INIRec.WriteString(sSecao,'LocalPrestacao', LocalPrestacaoToStr(Servico.LocalPrestacao));
      INIRec.WriteBool(sSecao, 'PrestadoEmViasPublicas',Servico.PrestadoEmViasPublicas);

      //Provedor Megasoft
      INIRec.WriteString(sSecao, 'InfAdicional', Servico.InfAdicional);
      INIRec.WriteString(sSecao, 'xFormaPagamento', Servico.xFormaPagamento);

      //Provedor IssSalvador
      INIRec.WriteString(sSecao, 'cClassTrib', Servico.cClassTrib);
      INIRec.WriteString(sSecao, 'INDOP', Servico.INDOP);

      for I := 0 to Servico.Deducao.Count - 1 do
      begin
        sSecao := 'Deducoes' + IntToStrZero(I + 1, 3);
        INIRec.WriteString(sSecao, 'DeducaoPor', FpAOwner.DeducaoPorToStr(Servico.Deducao[I].DeducaoPor));
        INIRec.WriteString(sSecao, 'TipoDeducao', FpAOwner.TipoDeducaoToStr(Servico.Deducao[I].TipoDeducao));
        INIRec.WriteString(sSecao, 'CpfCnpjReferencia', Servico.Deducao[I].CpfCnpjReferencia);
        INIRec.WriteString(sSecao, 'NumeroNFReferencia', Servico.Deducao[I].NumeroNFReferencia);
        INIRec.WriteFloat(sSecao, 'ValorTotalReferencia', Servico.Deducao[I].ValorTotalReferencia);
        INIRec.WriteFloat(sSecao, 'PercentualDeduzir', Servico.Deducao[I].PercentualDeduzir);
        INIRec.WriteFloat(sSecao, 'ValorDeduzir', Servico.Deducao[I].ValorDeduzir);
      end;

      //Quartos, ussado provedor iiBrasil
      for I := 0 to Quartos.Count - 1 do
      begin
        sSecao := 'Quartos' + IntToStrZero(I + 1, 3);
        INIRec.WriteInteger(sSecao, 'CodigoInternoQuarto', Quartos[I].CodigoInternoQuarto);
        INIRec.WriteInteger(sSecao, 'QtdHospedes', Quartos[I].QtdHospedes);
        INIRec.WriteDateTime(sSecao, 'CheckIn', Quartos[I].CheckIn);
        INIRec.WriteFloat(sSecao, 'QtdDiarias', Quartos[I].ValorDiaria);
      end;

      for I := 0 to email.Count - 1 do
      begin
        sSecao := 'Email' + IntToStrZero(I + 1, 1);
        INIRec.WriteString(sSecao, 'emailCC', email[I].emailCC);
      end;

      //IPM
      for I := 0 to Genericos.Count - 1 do
      begin
        sSecao := 'Genericos' + IntToStrZero(I + 1, 1);
        INIRec.WriteString(sSecao, 'Titulo', Genericos[I].Titulo);
        INIRec.WriteString(sSecao, 'Descricao', Genericos[I].Descricao);
      end;

      for I := 0 to Servico.Imposto.Count - 1 do
      begin
        sSecao := 'Impostos' + IntToStrZero(I + 1, 3);
        INIRec.WriteInteger(sSecao, 'Codigo', Servico.Imposto[I].Codigo);
        INIRec.WriteString(sSecao, 'Descricao', Servico.Imposto[I].Descricao);
        INIRec.WriteFloat(sSecao, 'Aliquota', Servico.Imposto[I].Aliquota);
        INIRec.WriteFloat(sSecao, 'Valor', Servico.Imposto[I].Valor);
      end;

      for I := 0 to Despesa.Count - 1 do
      begin
        sSecao := 'Despesas' + IntToStrZero(I + 1, 3);
        INIRec.WriteString(sSecao, 'nItemDesp', Despesa.Items[I].nItemDesp);
        INIRec.WriteString(sSecao, 'xDesp', Despesa.Items[I].xDesp);
        INIRec.WriteDateTime(sSecao, 'dDesp', Despesa.Items[I].dDesp);
        INIRec.WriteFloat(sSecao, 'vDesp', Despesa.Items[I].vDesp);
      end;

      //Lista de Itens, xxx pode variar de 001-999
      for I := 0 to Servico.ItemServico.Count - 1 do
      begin
        sSecao:= 'Itens' + IntToStrZero(I + 1, 3);

        INIRec.WriteString(sSecao, 'Descricao', ChangeLineBreak(Servico.ItemServico.Items[I].Descricao, FpAOwner.ConfigGeral.QuebradeLinha));
        INIRec.WriteString(sSecao, 'CodServico', Servico.ItemServico.Items[I].CodServ);
        INIRec.WriteString(sSecao, 'codLCServico', Servico.ItemServico.Items[I].CodLCServ);
        INIRec.WriteString(sSecao, 'CodigoCnae', Servico.ItemServico.Items[I].CodigoCnae);
        INIRec.WriteString(sSecao, 'ItemListaServico', Servico.ItemServico.Items[I].ItemListaServico);
        INIRec.WriteString(sSecao, 'xItemListaServico', Servico.ItemServico.Items[I].xItemListaServico);
        INIRec.WriteFloat(sSecao, 'Quantidade', Servico.ItemServico.Items[I].Quantidade);
        INIRec.WriteFloat(sSecao, 'ValorUnitario', Servico.ItemServico.Items[I].ValorUnitario);
        INIRec.WriteFloat(sSecao, 'QtdeDiaria', Servico.ItemServico.Items[I].QtdeDiaria);
        INIRec.WriteFloat(sSecao, 'ValorTaxaTurismo', Servico.ItemServico.Items[I].ValorTaxaTurismo);
        INIRec.WriteFloat(sSecao, 'ValorDeducoes', Servico.ItemServico.Items[I].ValorDeducoes);
        INIRec.WriteString(sSecao, 'xJustDeducao', Servico.ItemServico.Items[I].xJustDeducao);
        INIRec.WriteFloat(sSecao, 'AliqReducao', Servico.ItemServico.Items[I].AliqReducao);
        INIRec.WriteFloat(sSecao, 'ValorReducao', Servico.ItemServico.Items[I].ValorReducao);
        INIRec.WriteFloat(sSecao, 'ValorIss', Servico.ItemServico.Items[I].ValorISS);
        INIRec.WriteFloat(sSecao, 'Aliquota', Servico.ItemServico.Items[I].Aliquota);
        INIRec.WriteFloat(sSecao, 'BaseCalculo', Servico.ItemServico.Items[I].BaseCalculo);
        INIRec.WriteFloat(sSecao, 'DescontoIncondicionado', Servico.ItemServico.Items[I].DescontoIncondicionado);
        INIRec.WriteFloat(sSecao, 'DescontoCondicionado', Servico.ItemServico.Items[I].DescontoCondicionado);
        INIRec.WriteFloat(sSecao, 'ValorTotal', Servico.ItemServico.Items[I].ValorTotal);
        INIRec.WriteString(sSecao, 'Tributavel', FpAOwner.SimNaoToStr(Servico.ItemServico.Items[I].Tributavel));
        INIRec.WriteString(sSecao, 'TipoUnidade', UnidadeToStr(Servico.ItemServico.Items[I].TipoUnidade));
        INIRec.WriteString(sSecao, 'Unidade', Servico.ItemServico.Items[I].Unidade);
        INIRec.WriteFloat(sSecao, 'ValorISSRetido', Servico.ItemServico.Items[I].ValorISSRetido);
        INIRec.WriteFloat(sSecao, 'AliqISSST', Servico.ItemServico.Items[I].AliqISSST);
        INIRec.WriteFloat(sSecao, 'ValorISSST', Servico.ItemServico.Items[I].ValorISSST);
        INIRec.WriteFloat(sSecao, 'ValorBCCSLL', Servico.ItemServico.Items[I].ValorBCCSLL);
        INIRec.WriteFloat(sSecao, 'AliqRetCSLL', Servico.ItemServico.Items[I].AliqRetCSLL);
        INIRec.WriteFloat(sSecao, 'ValorCSLL', Servico.ItemServico.Items[I].ValorCSLL);
        INIRec.WriteFloat(sSecao, 'ValorBCPIS', Servico.ItemServico.Items[I].ValorBCPIS);
        INIRec.WriteFloat(sSecao, 'AliqRetPIS', Servico.ItemServico.Items[I].AliqRetPIS);
        INIRec.WriteFloat(sSecao, 'ValorPIS', Servico.ItemServico.Items[I].ValorPIS);
        INIRec.WriteFloat(sSecao, 'ValorBCCOFINS', Servico.ItemServico.Items[I].ValorBCCOFINS);
        INIRec.WriteFloat(sSecao, 'AliqRetCOFINS', Servico.ItemServico.Items[I].AliqRetCOFINS);
        INIRec.WriteFloat(sSecao, 'ValorCOFINS', Servico.ItemServico.Items[I].ValorCOFINS);
        INIRec.WriteFloat(sSecao, 'ValorBCINSS', Servico.ItemServico.Items[I].ValorBCINSS);
        INIRec.WriteFloat(sSecao, 'AliqRetINSS', Servico.ItemServico.Items[I].AliqRetINSS);
        INIRec.WriteFloat(sSecao, 'ValorINSS', Servico.ItemServico.Items[I].ValorINSS);
        INIRec.WriteFloat(sSecao, 'ValorBCRetIRRF', Servico.ItemServico.Items[I].ValorBCRetIRRF);
        INIRec.WriteFloat(sSecao, 'AliqRetIRRF', Servico.ItemServico.Items[I].AliqRetIRRF);
        INIRec.WriteFloat(sSecao, 'ValorIRRF', Servico.ItemServico.Items[I].ValorIRRF);
        INIRec.WriteString(sSecao, 'TribMunPrestador', FpAOwner.SimNaoToStr(Servico.ItemServico.Items[I].TribMunPrestador));
        INIRec.WriteString(sSecao, 'CodMunPrestacao', Servico.ItemServico.Items[I].CodMunPrestacao);
        INIRec.WriteInteger(sSecao, 'SituacaoTributaria', Servico.ItemServico.Items[I].SituacaoTributaria);
        INIRec.WriteString(sSecao, 'CodCNO', Servico.ItemServico.Items[I].CodCNO);
        INIRec.WriteFloat(sSecao, 'ValorTributavel', Servico.ItemServico.Items[I].ValorTributavel);
        INIRec.WriteString(sSecao, 'idCnae', Servico.ItemServico.Items[I].idCnae);

        //Provedor Elotech
        sSecao := 'DadosDeducao' + IntToStrZero(I + 1, 3);
        INIRec.WriteString(sSecao, 'TipoDeducao', FpAOwner.TipoDeducaoToStr(Servico.ItemServico.Items[I].DadosDeducao.TipoDeducao));
        INIRec.WriteString(sSecao, 'CpfCnpj', Servico.ItemServico.Items[I].DadosDeducao.CpfCnpj);
        INIRec.WriteString(sSecao, 'NumeroNotaFiscalReferencia', Servico.ItemServico.Items[I].DadosDeducao.NumeroNotaFiscalReferencia);
        INIRec.WriteFloat(sSecao, 'ValorTotalNotaFiscal', Servico.ItemServico.Items[I].DadosDeducao.ValorTotalNotaFiscal);
        INIRec.WriteFloat(sSecao, 'PercentualADeduzir', Servico.ItemServico.Items[I].DadosDeducao.PercentualADeduzir);
        INIRec.WriteFloat(sSecao, 'ValorADeduzir', Servico.ItemServico.Items[I].DadosDeducao.ValorADeduzir);

        //Provedor Agili
        sSecao := 'DadosProssionalParceiro' + IntToStrZero(I + 1, 3);
        INIRec.WriteString(sSecao, 'CpfCnpj', Servico.ItemServico.Items[I].DadosProfissionalParceiro.IdentificacaoParceiro.CpfCnpj);
        INIRec.WriteString(sSecao, 'InscricaoMunicipal', Servico.ItemServico.Items[I].DadosProfissionalParceiro.IdentificacaoParceiro.InscricaoMunicipal);
        INIRec.WriteString(sSecao, 'RazaoSocial', Servico.ItemServico.Items[I].DadosProfissionalParceiro.RazaoSocial);
        INIRec.WriteFloat(sSecao, 'PercentualProfissionalParceiro', Servico.ItemServico.Items[I].DadosProfissionalParceiro.PercentualProfissionalParceiro);

        // Provedor Infisc
        INIRec.WriteFloat(sSecao, 'totalAproxTribServ', Servico.ItemServico[I].totalAproxTribServ);
      end;

      //Padrão Nacional
      if (Servico.comExt.tpMoeda <> 0) or (Servico.comExt.vServMoeda > 0) then
      begin
        sSecao := 'ComercioExterior';
        INIRec.WriteString(sSecao, 'mdPrestacao', mdPrestacaoToStr(Servico.comExt.mdPrestacao));
        INIRec.WriteString(sSecao, 'vincPrest', vincPrestToStr(Servico.comExt.vincPrest));
        INIRec.WriteInteger(sSecao, 'tpMoeda', Servico.comExt.tpMoeda);
        INIRec.WriteFloat(sSecao, 'vServMoeda', Servico.comExt.vServMoeda);
        INIRec.WriteString(sSecao, 'mecAFComexP', mecAFComexPToStr(Servico.comExt.mecAFComexP));
        INIRec.WriteString(sSecao, 'mecAFComexT', mecAFComexTToStr(Servico.comExt.mecAFComexT));
        INIRec.WriteString(sSecao, 'movTempBens', MovTempBensToStr(Servico.comExt.movTempBens));
        INIRec.WriteString(sSecao, 'nDI', Servico.comExt.nDI);
        INIRec.WriteString(sSecao, 'nRE', Servico.comExt.nRE);
        INIRec.WriteInteger(sSecao, 'mdic', Servico.comExt.mdic);
      end;

      //Padrão Nacional
      if (Servico.Locacao.extensao <> '') or (Servico.Locacao.nPostes > 0)then
      begin
        sSecao := 'LocacaoSubLocacao';
        INIRec.WriteString(sSecao, 'categ', categToStr(Servico.Locacao.categ));
        INIRec.WriteString(sSecao, 'objeto', objetoToStr(Servico.Locacao.objeto));
        INIRec.WriteString(sSecao, 'extensao', Servico.Locacao.extensao);
        INIRec.WriteInteger(sSecao, 'nPostes', Servico.Locacao.nPostes);
      end;

      //Padrão Nacional
      if (Servico.Evento.xNome <> '') or (Servico.Evento.dtIni > 0) or (Servico.Evento.dtFim > 0)then
      begin
        sSecao := 'Evento';
        INIRec.WriteString(sSecao, 'xNome', Servico.Evento.xNome);
        INIRec.WriteDate(sSecao, 'dtIni', Servico.Evento.dtIni);
        INIRec.WriteDate(sSecao, 'dtFim', Servico.Evento.dtFim);
        INIRec.WriteString(sSecao, 'idAtvEvt', Servico.Evento.idAtvEvt);
        INIRec.WriteString(sSecao, 'CEP', Servico.Evento.Endereco.CEP);
        INIRec.WriteString(sSecao, 'xMunicipio', Servico.Evento.Endereco.xMunicipio);
        INIRec.WriteString(sSecao, 'UF', Servico.Evento.Endereco.UF);
        INIRec.WriteString(sSecao, 'Logradouro', Servico.Evento.Endereco.Endereco);
        INIRec.WriteString(sSecao, 'Complemento', Servico.Evento.Endereco.Complemento);
        INIRec.WriteString(sSecao, 'Bairro', Servico.Evento.Endereco.Bairro);
      end;

      //Padrão Nacional
      if (Servico.explRod.placa <> '') then
      begin
        sSecao := 'Rodoviaria';
        INIRec.WriteString(sSecao, 'categVeic', categVeicToStr(Servico.ExplRod.categVeic));
        INIRec.WriteInteger(sSecao, 'nEixos', Servico.ExplRod.nEixos);
        INIRec.WriteString(sSecao, 'rodagem', rodagemToStr(Servico.ExplRod.rodagem));
        INIRec.WriteString(sSecao, 'placa', Servico.ExplRod.placa);
        INIRec.WriteString(sSecao, 'sentido', Servico.ExplRod.sentido);
        INIRec.WriteString(sSecao, 'codAcessoPed', Servico.ExplRod.codAcessoPed);
        INIRec.WriteString(sSecao, 'codContrato', Servico.ExplRod.codContrato);
      end;

      if (Servico.infoCompl.idDocTec <> '') or (Servico.infoCompl.docRef <> '') or (Servico.infoCompl.xInfComp <> '') then
      begin
        sSecao := 'InformacoesComplementares';
        INIRec.WriteString(sSecao, 'idDocTec', Servico.infoCompl.idDocTec);
        INIRec.WriteString(sSecao, 'docRef', Servico.infoCompl.docRef);
        INIRec.WriteString(sSecao, 'xInfComp', Servico.infoCompl.xInfComp);
      end;

      sSecao:= 'Valores';
      INIRec.WriteFloat(sSecao, 'ValorServicos', Servico.Valores.ValorServicos);
      INIRec.WriteFloat(sSecao, 'ValorDeducoes', Servico.Valores.ValorDeducoes);
      INIRec.WriteFloat(sSecao, 'AliquotaDeducoes', Servico.Valores.AliquotaDeducoes);
      INIRec.WriteString(sSecao, 'JustificativaDeducao', Servico.Valores.JustificativaDeducao);
      INIRec.WriteFloat(sSecao, 'ValorPis', Servico.Valores.ValorPis);
      INIRec.WriteFloat(sSecao, 'AliquotaPis', Servico.Valores.AliquotaPis);
      INIRec.WriteString(sSecao, 'RetidoPis', FpAOwner.SimNaoToStr(Servico.Valores.RetidoPis));
      INIRec.WriteFloat(sSecao, 'ValorCofins', Servico.Valores.ValorCofins);
      INIRec.WriteFloat(sSecao, 'AliquotaCofins', Servico.Valores.AliquotaCofins);
      INIRec.WriteString(sSecao, 'RetidoCofins', FpAOwner.SimNaoToStr(Servico.Valores.RetidoCofins));
      INIRec.WriteFloat(sSecao, 'ValorInss', Servico.Valores.ValorInss);
      INIRec.WriteFloat(sSecao, 'AliquotaInss', Servico.Valores.AliquotaInss);
      INIRec.WriteString(sSecao, 'RetidoInss', FpAOwner.SimNaoToStr(Servico.Valores.RetidoInss));
      INIRec.WriteFloat(sSecao, 'ValorIr', Servico.Valores.ValorIr);
      INIRec.WriteFloat(sSecao, 'AliquotaIr', Servico.Valores.AliquotaIr);
      INIRec.WriteString(sSecao, 'RetidoIr', FpAOwner.SimNaoToStr(Servico.Valores.RetidoIr));
      INIRec.WriteFloat(sSecao, 'ValorCsll', Servico.Valores.ValorCsll);
      INIRec.WriteFloat(sSecao, 'AliquotaCsll', Servico.Valores.AliquotaCsll);
      INIRec.WriteString(sSecao, 'RetidoCsll', FpAOwner.SimNaoToStr(Servico.Valores.RetidoCsll));
      INIRec.WriteString(sSecao, 'ISSRetido', FpAOwner.SituacaoTributariaToStr(Servico.Valores.IssRetido));
      INIRec.WriteFloat(sSecao, 'AliquotaCpp', Servico.Valores.AliquotaCpp);
      INIRec.WriteFloat(sSecao, 'ValorCpp', Servico.Valores.ValorCpp);
      INIRec.WriteString(sSecao, 'RetidoCpp', FpAOwner.SimNaoToStr(Servico.Valores.RetidoCpp));
      INIRec.WriteFloat(sSecao, 'valorOutrasRetencoes', Servico.Valores.valorOutrasRetencoes);
      INIRec.WriteFloat(sSecao, 'OutrasRetencoes', Servico.Valores.OutrasRetencoes);
      INIRec.WriteString(sSecao, 'DescricaoOutrasRetencoes', Servico.Valores.DescricaoOutrasRetencoes);
      INIRec.WriteFloat(sSecao, 'DescontoIncondicionado', Servico.Valores.DescontoIncondicionado);
      INIRec.WriteFloat(sSecao, 'DescontoCondicionado', Servico.Valores.DescontoCondicionado);
      INIRec.WriteFloat(sSecao, 'OutrosDescontos', Servico.Valores.OutrosDescontos);
      INIRec.WriteFloat(sSecao, 'ValorRepasse', Servico.Valores.ValorRepasse);
      INIRec.WriteFloat(sSecao, 'BaseCalculo', Servico.Valores.BaseCalculo);
      INIRec.WriteFloat(sSecao, 'Aliquota', Servico.Valores.Aliquota);
      INIRec.WriteFloat(sSecao, 'AliquotaSN', Servico.Valores.AliquotaSN);
      INIRec.WriteFloat(sSecao, 'ValorIss', Servico.Valores.ValorIss);
      INIRec.WriteFloat(sSecao, 'ValorIssRetido', Servico.Valores.ValorIssRetido);
      INIRec.WriteFloat(sSecao, 'ValorLiquidoNfse', Servico.Valores.ValorLiquidoNfse);
      INIRec.WriteFloat(sSecao, 'ValorTotalNotaFiscal', Servico.Valores.ValorTotalNotaFiscal);
      INIRec.WriteFloat(sSecao, 'ValorTotalTributos', Servico.Valores.ValorTotalTributos);
      INIRec.WriteFloat(sSecao, 'ValorRecebido', Servico.Valores.ValorRecebido);
      INIRec.WriteFloat(sSecao, 'IrrfIndenizacao', Servico.Valores.IrrfIndenizacao);
      INIRec.WriteFloat(sSecao, 'RetencoesFederais', Servico.Valores.RetencoesFederais);

      // Provedor Infisc
      INIRec.WriteFloat(sSecao, 'totalAproxTrib', Servico.Valores.totalAproxTrib);

      sSecao := 'ValoresNFSe';
      INIRec.WriteFloat(sSecao, 'BaseCalculo', ValoresNfse.BaseCalculo);
      INIRec.WriteFloat(sSecao, 'Aliquota', ValoresNfse.Aliquota);
      INIRec.WriteFloat(sSecao, 'ValorLiquidoNfse', ValoresNfse.ValorLiquidoNfse);
      INIRec.WriteFloat(sSecao, 'ValorIss', ValoresNfse.ValorIss);

      //Padrão Nacional
      for i := 0 to Servico.Valores.DocDeducao.Count - 1 do
      begin
        sSecao := 'DocumentosDeducoes' + IntToStrZero(i+1, 3);
        INIRec.WriteString(sSecao, 'chNFSe', Servico.Valores.DocDeducao[i].chNFSe);
        INIRec.WriteString(sSecao, 'chNFe', Servico.Valores.DocDeducao[i].chNFe);
        INIRec.WriteString(sSecao, 'nDoc', Servico.Valores.DocDeducao[i].nDoc);
        INIRec.WriteString(sSecao, 'tpDedRed', tpDedRedToStr(Servico.Valores.DocDeducao[i].tpDedRed));
        INIRec.WriteString(sSecao, 'xDescOutDed', Servico.Valores.DocDeducao[i].xDescOutDed);
        INIRec.WriteDate(sSecao, 'dtEmiDoc', Servico.Valores.DocDeducao[i].dtEmiDoc);
        INIRec.WriteFloat(sSecao, 'vDedutivelRedutivel', Servico.Valores.DocDeducao[i].vDedutivelRedutivel);
        INIRec.WriteFloat(sSecao, 'vDeducaoReducao', Servico.Valores.DocDeducao[i].vDeducaoReducao);
        INIRec.WriteString(sSecao, 'cMunNFSeMun', Servico.Valores.DocDeducao[i].NFSeMun.cMunNFSeMun);
        INIRec.WriteString(sSecao, 'nNFSeMun', Servico.Valores.DocDeducao[i].NFSeMun.nNFSeMun);
        INIRec.WriteString(sSecao, 'cVerifNFSeMun', Servico.Valores.DocDeducao[i].NFseMun.cVerifNFSeMun);
        INIRec.WriteString(sSecao, 'nNFS', Servico.Valores.DocDeducao[i].NFNFS.nNFS);
        INIRec.WriteString(sSecao, 'modNFS', Servico.Valores.DocDeducao[i].NFNFS.modNFS);
        INIRec.WriteString(sSecao, 'serieNFS', Servico.Valores.DocDeducao[i].NFNFS.serieNFS);

        if Servico.Valores.DocDeducao[i].fornec.Identificacao.CpfCnpj <> '' then
        begin
          sSecao := 'DocumentosDeducoesFornecedor' + IntToStrZero(i+1, 3);
          fornec := Servico.Valores.DocDeducao[i].fornec;

          INIRec.WriteString(sSecao, 'CNPJCPF', fornec.Identificacao.CpfCnpj);
          INIRec.WriteString(sSecao, 'InscricaoMunicipal', fornec.Identificacao.InscricaoMunicipal);
          INIRec.WriteString(sSecao, 'NIF', fornec.Identificacao.NIF);
          INIRec.WriteString(sSecao, 'cNaoNIF', NaoNIFToStr(fornec.Identificacao.cNaoNIF));
          INIRec.WriteString(sSecao, 'CAEEPF', fornec.Identificacao.CAEPF);

          INIRec.WriteString(sSecao, 'Logradouro', fornec.Endereco.Endereco);
          INIRec.WriteString(sSecao, 'Numero', fornec.Endereco.Numero);
          INIRec.WriteString(sSecao, 'Complemento', fornec.Endereco.Complemento);
          INIRec.WriteString(sSecao, 'Bairro', fornec.Endereco.Bairro);
          INIRec.WriteString(sSecao, 'CEP', fornec.Endereco.CEP);
          INIRec.WriteString(sSecao, 'xMunicipio', fornec.Endereco.xMunicipio);
          INIRec.WriteString(sSecao, 'UF', fornec.Endereco.UF);

          INIRec.WriteString(sSecao, 'Telefone', fornec.Contato.Telefone);
          INIRec.WriteString(sSecao, 'Email', fornec.Contato.Email);
        end;
      end;

      //Padrão Nacional
      if (Servico.Valores.tribMun.pAliq > 0) or (Servico.Valores.tribMun.pRedBCBM > 0) or
         (Servico.Valores.tribMun.vRedBCBM > 0) or (Servico.Valores.tribMun.cPaisResult > 0) then
      begin
        sSecao := 'tribMun';
        INIRec.WriteString(sSecao, 'tribISSQN', tribISSQNToStr(Servico.Valores.tribMun.tribISSQN));
        INIRec.WriteInteger(sSecao, 'cPaisResult', Servico.Valores.tribMun.cPaisResult);
        INIRec.WriteString(sSecao, 'tpBM', tpBMToStr(Servico.Valores.tribMun.tpBM));
        INIRec.WriteString(sSecao, 'nBM', Servico.Valores.TribMun.nBM);
        INIRec.WriteFloat(sSecao, 'vRedBCBM', Servico.Valores.tribMun.vRedBCBM);
        INIRec.WriteFloat(sSecao, 'pRedBCBM', Servico.Valores.tribMun.pRedBCBM);
        INIRec.WriteString(sSecao, 'tpSusp', tpSuspToStr(Servico.Valores.tribMun.tpSusp));
        INIRec.WriteString(sSecao, 'nProcesso', Servico.Valores.tribMun.nProcesso);
        INIRec.WriteString(sSecao, 'tpImunidade', tpImunidadeToStr(Servico.Valores.tribMun.tpImunidade));
        INIRec.WriteFloat(sSecao, 'pAliq', Servico.Valores.tribMun.pAliq);
        INIRec.WriteString(sSecao, 'tpRetISSQN', tpRetISSQNToStr(Servico.Valores.tribMun.tpRetISSQN));
      end;

      //Padrão Nacional
      if (Servico.Valores.tribFed.pAliqPis > 0) or (Servico.Valores.tribFed.pAliqCofins > 0) or
         (Servico.Valores.tribFed.vRetIRRF > 0) or (Servico.Valores.tribFed.vRetCP > 0) then
      begin
        sSecao := 'tribFederal';
        INIRec.WriteString(sSecao, 'CST', CSTToStr(Servico.Valores.tribFed.CST));
        INIRec.WriteFloat(sSecao, 'vBCPisCofins', Servico.Valores.tribFed.vBCPisCofins);
        INIRec.WriteFloat(sSecao, 'pAliqPis', Servico.Valores.tribFed.pAliqPis);
        INIRec.WriteFloat(sSecao, 'pAliqCofins', Servico.Valores.tribFed.pAliqCofins);
        INIRec.WriteFloat(sSecao, 'vPis', Servico.Valores.tribFed.vPis);
        INIRec.WriteFloat(sSecao, 'vCofins', Servico.Valores.tribFed.vCofins);
        INIRec.WriteString(sSecao, 'tpRetPisCofins', tpRetPisCofinsToStr(Servico.Valores.tribFed.tpRetPisCofins));
        INIRec.WriteFloat(sSecao, 'vRetCP', Servico.Valores.tribFed.vRetCP);
        INIRec.WriteFloat(sSecao, 'vRetIRRF', Servico.Valores.tribFed.vRetIRRF);
        INIRec.WriteFloat(sSecao, 'vRetCSLL', Servico.Valores.tribFed.vRetCSLL);
      end;

      sSecao := 'totTrib';
      INIRec.WriteString(sSecao, 'indTotTrib', indTotTribToStr(Servico.Valores.totTrib.indTotTrib));
      INIRec.WriteFloat(sSecao, 'pTotTribSN', Servico.Valores.totTrib.pTotTribSN);
      INIRec.WriteFloat(sSecao, 'vTotTribFed', Servico.Valores.totTrib.vTotTribFed);
      INIRec.WriteFloat(sSecao, 'vTotTribEst', Servico.Valores.totTrib.vTotTribEst);
      INIRec.WriteFloat(sSecao, 'vTotTribMun', Servico.Valores.totTrib.vTotTribMun);
      INIRec.WriteFloat(sSecao, 'pTotTribFed', Servico.Valores.totTrib.pTotTribFed);
      INIRec.WriteFloat(sSecao, 'pTotTribEst', Servico.Valores.totTrib.pTotTribEst);
      INIRec.WriteFloat(sSecao, 'pTotTribMun', Servico.Valores.totTrib.pTotTribMun);

      //Condição de Pagamento usado pelo provedor Betha versão 1 do Layout da ABRASF
      if CondicaoPagamento.QtdParcela > 0 then
      begin
        sSecao:= 'CondicaoPagamento';
        INIRec.WriteInteger(sSecao, 'QtdParcela', CondicaoPagamento.QtdParcela);
        INIRec.WriteString(sSecao, 'Condicao', FpAOwner.CondicaoPagToStr(CondicaoPagamento.Condicao));

        // Provedor NFEletronica
        if CondicaoPagamento.DataVencimento > 0 then
        begin
          INIRec.WriteDate(sSecao, 'DataVencimento', CondicaoPagamento.DataVencimento);
          INIRec.WriteString(sSecao, 'InstrucaoPagamento', CondicaoPagamento.InstrucaoPagamento);
          INIRec.WriteInteger(sSecao, 'CodigoVencimento', CondicaoPagamento.CodigoVencimento);
          if CondicaoPagamento.DataCriacao > 0 then
            INIRec.ReadDateTime(sSecao, 'DataCriacao', CondicaoPagamento.DataCriacao)
          else
            INIRec.ReadDateTime(sSecao, 'DataCriacao', Now);
        end;

        if Trim(OrgaoGerador.Uf) <> '' then
        begin
          sSecao := 'OrgaoGerador';
          INIRec.WriteString(sSecao, 'CodigoMunicipio', OrgaoGerador.CodigoMunicipio);
          INIRec.WriteString(sSecao, 'UF', OrgaoGerador.Uf);
        end;

        //Lista de parcelas, xx pode variar de 01-99 (provedor Betha versão 1 do Layout da ABRASF)
        for I := 0 to CondicaoPagamento.Parcelas.Count - 1 do
        begin
          sSecao:= 'Parcelas' + IntToStrZero(I + 1, 2);

          INIRec.WriteString(sSecao, 'Parcela', CondicaoPagamento.Parcelas.Items[I].Parcela);
          INIRec.WriteDate(sSecao, 'DataVencimento', CondicaoPagamento.Parcelas.Items[I].DataVencimento);
          INIRec.WriteFloat(sSecao, 'Valor', CondicaoPagamento.Parcelas.Items[I].Valor);
          INIRec.WriteString(sSecao, 'Condicao', FpAOwner.CondicaoPagToStr(CondicaoPagamento.Parcelas.Items[I].Condicao));

        end;

        // Reforma Tributária
        if (NFSe.IBSCBS.dest.xNome <> '') or (NFSe.IBSCBS.imovel.cCIB <> '') or
           (NFSe.IBSCBS.imovel.ender.CEP <> '') or
           (NFSe.IBSCBS.imovel.ender.endExt.cEndPost <> '') or
           (NFSe.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) then
          GerarINIIBSCBS(INIRec, NFSe.IBSCBS);
      end;
    end;
  finally
    IniNFSe := TStringList.Create;
    try
      INIRec.GetStrings(IniNFSe);
      INIRec.Free;

      Result := StringReplace(IniNFSe.Text, sLineBreak + sLineBreak, sLineBreak, [rfReplaceAll]);
    finally
      IniNFSe.Free;
    end;
  end;
end;

// Reforma Tributária
function TNFSeWClass.GerarXMLIBSCBS(IBSCBS: TIBSCBSDPS): TACBrXmlNode;
begin
  Result := CreateElement('IBSCBS');

  Result.AppendChild(AddNode(tcStr, '#1', 'finNFSe', 1, 1, 1,
                                             finNFSeToStr(IBSCBS.finNFSe), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'indFinal', 1, 1, 1,
                                           indFinalToStr(IBSCBS.indFinal), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cIndOp', 6, 6, 1,
                                                            IBSCBS.cIndOp, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tpOper', 1, 1, NrOcorrtpOper,
                                        tpOperGovNFSeToStr(IBSCBS.tpOper), ''));

  if IBSCBS.gRefNFSe.Count > 0 then
    Result.AppendChild(GerarXMLgRefNFSe(IBSCBS.gRefNFSe));

  Result.AppendChild(AddNode(tcStr, '#1', 'tpEnteGov', 1, 1, 0,
                                         tpEnteGovToStr(IBSCBS.tpEnteGov), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'indDest', 1, 1, NrOcorrindDest,
                                             indDestToStr(IBSCBS.indDest), ''));

  if (IBSCBS.dest.xNome <> '') and GerarDest then
    Result.AppendChild(GerarXMLDestinatario(IBSCBS.dest));

  if ((IBSCBS.imovel.cCIB <> '') or (IBSCBS.imovel.ender.xLgr <> '')) and
     GerarImovel then
    Result.AppendChild(GerarXMLImovel(IBSCBS.imovel));

  Result.AppendChild(GerarXMLIBSCBSValores(IBSCBS.valores));
end;

function TNFSeWClass.GerarXMLgRefNFSe(
  gRefNFSe: TgRefNFSeCollection): TACBrXmlNode;
var
  i: Integer;
begin
  Result := nil;

  if gRefNFSe.Count > 0 then
  begin
    if gRefNFSe.Count > 99 then
      wAlerta('BB02', 'gRefNFSe', DSC_REFNFSE, ERR_MSG_MAIOR_MAXIMO + '99');

    Result := FDocument.CreateElement('gRefNFSe');

    for i := 0 to gRefNFSe.Count - 1 do
    begin
      Result.AppendChild(AddNode(tcStr, '#1','refNFSe', 50, 50, 1,
                                             gRefNFSe[i].refNFSe, DSC_REFNFSE));
    end;
  end;
end;

function TNFSeWClass.GerarXMLDestinatario(Dest: TDadosdaPessoa): TACBrXmlNode;
begin
  Result := CreateElement('dest');

  if Dest.CNPJCPF <> '' then
    Result.AppendChild(AddNodeCNPJCPF('#1', '#1', Dest.CNPJCPF))
  else
  if Dest.Nif <> '' then
    Result.AppendChild(AddNode(tcStr, '#1', 'NIF', 1, 40, 1, Dest.Nif, ''))
  else
    Result.AppendChild(AddNode(tcStr, '#1', 'cNaoNIF', 1, 1, 1,
                                                NaoNIFToStr(Dest.cNaoNIF), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xNome', 1, 300, 1, Dest.xNome, ''));

  Result.AppendChild(GerarXMLEnderecoDestinatario(Dest.ender));

  Result.AppendChild(AddNode(tcStr, '#1', 'fone', 6, 20, 0, Dest.fone, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'email', 1, 80, 0, Dest.email, ''));
end;

function TNFSeWClass.GerarXMLEnderecoDestinatario(
  ender: Tender): TACBrXmlNode;
begin
  Result := nil;

  if (ender.endNac.cMun <> 0) or (ender.endExt.cPais <> 0) then
  begin
    Result := CreateElement('end');

    if (ender.endNac.cMun <> 0) then
      Result.AppendChild(GerarXMLEnderecoNacionalDestinatario(ender.endNac))
    else
      Result.AppendChild(GerarXMLEnderecoExteriorDestinatario(ender.endExt));

    Result.AppendChild(AddNode(tcStr, '#1', 'xLgr', 1, 255, 1, ender.xLgr, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'nro', 1, 60, 1, ender.nro, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xCpl', 1, 156, 0, ender.xCpl, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xBairro', 1, 60, 1,
                                                            ender.xBairro, ''));
  end;
end;

function TNFSeWClass.GerarXMLEnderecoNacionalDestinatario(
  endNac: TendNac): TACBrXmlNode;
begin
  Result := nil;

  if endNac.CEP <> '' then
  begin
    Result := CreateElement('endNac');

    Result.AppendChild(AddNode(tcInt, '#1', 'cMun', 7, 7, 1, endNac.cMun, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'CEP', 8, 8, 1, endNac.CEP, ''));
  end;
end;

function TNFSeWClass.GerarXMLEnderecoExteriorDestinatario(
  endExt: TendExt): TACBrXmlNode;
begin
  Result := CreateElement('endExt');

  Result.AppendChild(AddNode(tcStr, '#1', 'cPais', 2, 2, 1,
                                     CodIBGEPaisToSiglaISO2(endExt.cPais), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cEndPost', 1, 11, 1,
                                                          endExt.cEndPost, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xCidade', 1, 60, 1,
                                                           endExt.xCidade, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xEstProvReg', 1, 60, 1,
                                                       endExt.xEstProvReg, ''));
end;

function TNFSeWClass.GerarXMLImovel(Imovel: TDadosimovel): TACBrXmlNode;
begin
  Result := nil;

  if (Imovel.cCIB <> '') or (Imovel.ender.CEP <> '') or
     (Imovel.ender.endExt.cEndPost <> '') then
  begin
    Result := CreateElement('imovel');

    Result.AppendChild(AddNode(tcStr, '#1', 'inscImobFisc', 1, 30, 0,
                                                      Imovel.inscImobFisc, ''));

    if (Imovel.cCIB <> '') then
      Result.AppendChild(AddNode(tcStr, '#1', 'cCIB', 1, 8, 1,
                                                               Imovel.cCIB, ''))
    else
      Result.AppendChild(GerarXMLEnderecoNacionalImovel(Imovel.ender));
  end;
end;

function TNFSeWClass.GerarXMLEnderecoNacionalImovel(
  ender: TenderImovel): TACBrXmlNode;
begin
  Result := nil;

  if (ender.CEP <> '') or (ender.endExt.cEndPost <> '') then
  begin
    Result := CreateElement('end');

    if (ender.CEP <> '') then
      Result.AppendChild(AddNode(tcStr, '#1', 'CEP', 8, 8, 1, ender.CEP, ''))
    else
      Result.AppendChild(GerarXMLEnderecoExteriorImovel(ender.endExt));

    Result.AppendChild(AddNode(tcStr, '#1', 'xLgr', 1, 255, 1, ender.xLgr, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'nro', 1, 60, 1, ender.nro, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xCpl', 1, 156, 0, ender.xCpl, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xBairro', 1, 60, 1,
                                                            ender.xBairro, ''));
  end;
end;

function TNFSeWClass.GerarXMLEnderecoExteriorImovel(
  endExt: TendExt): TACBrXmlNode;
begin
  Result := CreateElement('endExt');

  Result.AppendChild(AddNode(tcStr, '#1', 'cEndPost', 1, 11, 1,
                                                          endExt.cEndPost, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xCidade', 1, 60, 1,
                                                           endExt.xCidade, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xEstProvReg', 1, 60, 1,
                                                       endExt.xEstProvReg, ''));
end;

function TNFSeWClass.GerarXMLIBSCBSValores(
  valores: Tvalorestrib): TACBrXmlNode;
begin
  Result := CreateElement('valores');

  if (valores.gReeRepRes.documentos.Count > 0) and GerargReeRepRes then
    Result.AppendChild(GerarXMLgReeRepRes(valores.gReeRepRes));

  Result.AppendChild(GerarXMLTributos(valores.trib));
end;

function TNFSeWClass.GerarXMLgReeRepRes(
  gReeRepRes: TgReeRepRes): TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  Result := CreateElement('gReeRepRes');

  nodeArray := GerarXMLDocumentos;

  if nodeArray <> nil then
  begin
    for i := 0 to Length(nodeArray) - 1 do
    begin
      Result.AppendChild(nodeArray[i]);
    end;
  end;
end;

function TNFSeWClass.GerarXMLDocumentos: TACBrXmlNodeArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, NFSe.IBSCBS.valores.gReeRepRes.documentos.Count);

  for i := 0 to NFSe.IBSCBS.valores.gReeRepRes.documentos.Count - 1 do
  begin
    Result[i] := CreateElement('documentos');

    if NFSe.IBSCBS.valores.gReeRepRes.documentos[i].dFeNacional.chaveDFe <> '' then
      Result[i].AppendChild(GerarXMLdFeNacional(NFSe.IBSCBS.valores.gReeRepRes.documentos[i].dFeNacional))
    else
    if NFSe.IBSCBS.valores.gReeRepRes.documentos[i].docFiscalOutro.cMunDocFiscal > 0 then
      Result[i].AppendChild(GerarXMLdocFiscalOutro(NFSe.IBSCBS.valores.gReeRepRes.documentos[i].docFiscalOutro))
    else
    if NFSe.IBSCBS.valores.gReeRepRes.documentos[i].docOutro.nDoc <> '' then
      Result[i].AppendChild(GerarXMLdocOutro(NFSe.IBSCBS.valores.gReeRepRes.documentos[i].docOutro));

    if NFSe.IBSCBS.valores.gReeRepRes.documentos[i].fornec.xNome <> '' then
      Result[i].AppendChild(GerarXMLfornec(NFSe.IBSCBS.valores.gReeRepRes.documentos[i].fornec));

    Result[i].AppendChild(AddNode(tcDat, '#1', 'dtEmiDoc', 10, 10, 1,
                    NFSe.IBSCBS.valores.gReeRepRes.documentos[i].dtEmiDoc, ''));

    Result[i].AppendChild(AddNode(tcDat, '#1', 'dtCompDoc', 10, 10, 1,
                   NFSe.IBSCBS.valores.gReeRepRes.documentos[i].dtCompDoc, ''));

    Result[i].AppendChild(AddNode(tcStr, '#1', 'tpReeRepRes', 2, 2, 1,
      tpReeRepResToStr(NFSe.IBSCBS.valores.gReeRepRes.documentos[i].tpReeRepRes), ''));

    Result[i].AppendChild(AddNode(tcStr, '#1', 'xTpReeRepRes', 0, 150, 0,
                NFSe.IBSCBS.valores.gReeRepRes.documentos[i].xTpReeRepRes, ''));

    Result[i].AppendChild(AddNode(tcDe2, '#1', 'vlrReeRepRes', 1, 15, 1,
                NFSe.IBSCBS.valores.gReeRepRes.documentos[i].vlrReeRepRes, ''));
  end;

  if NFSe.Servico.Valores.DocDeducao.Count > 1000 then
    wAlerta('#1', 'documentos', '', ERR_MSG_MAIOR_MAXIMO + '1000');
end;

function TNFSeWClass.GerarXMLdFeNacional(
  dFeNacional: TdFeNacional): TACBrXmlNode;
begin
  Result := CreateElement('dFeNacional');

  Result.AppendChild(AddNode(tcStr, '#1', 'tipoChaveDFe', 1, 1, 1,
                              tipoChaveDFeToStr(dFeNacional.tipoChaveDFe), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xTipoChaveDFe', 1, 255, 0,
                                                dFeNacional.xTipoChaveDFe, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'chaveDFe', 1, 50, 1,
                                                     dFeNacional.chaveDFe, ''));
end;

function TNFSeWClass.GerarXMLdocFiscalOutro(
  docFiscalOutro: TdocFiscalOutro): TACBrXmlNode;
begin
  Result := CreateElement('docFiscalOutro');

  Result.AppendChild(AddNode(tcInt, '#1', 'cMunDocFiscal', 7, 7, 1,
                                             docFiscalOutro.cMunDocFiscal, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'nDocFiscal', 1, 255, 1,
                                                docFiscalOutro.nDocFiscal, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xDocFiscal', 1, 255, 1,
                                                docFiscalOutro.xDocFiscal, ''));
end;

function TNFSeWClass.GerarXMLdocOutro(docOutro: TdocOutro): TACBrXmlNode;
begin
  Result := CreateElement('docOutro');

  Result.AppendChild(AddNode(tcStr, '#1', 'nDoc', 1, 255, 1,
                                                            docOutro.nDoc, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xDoc', 1, 255, 1,
                                                            docOutro.xDoc, ''));
end;

function TNFSeWClass.GerarXMLfornec(fornec: Tfornec): TACBrXmlNode;
begin
  Result := CreateElement('fornec');

  if fornec.CNPJCPF <> '' then
    Result.AppendChild(AddNodeCNPJCPF('#1', '#1', fornec.CNPJCPF))
  else
  if fornec.Nif <> '' then
    Result.AppendChild(AddNode(tcStr, '#1', 'NIF', 1, 40, 1,
                                                     fornec.Nif, ''))
  else
    Result.AppendChild(AddNode(tcStr, '#1', 'cNaoNIF', 1, 1, 1,
                                   NaoNIFToStr(fornec.cNaoNIF), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xNome', 1, 150, 1,
                                                             fornec.xNome, ''));
end;

function TNFSeWClass.GerarXMLTributos(
  trib: Ttrib): TACBrXmlNode;
begin
  Result := CreateElement('trib');

  Result.AppendChild(GerarXMLgIBSCBS(trib.gIBSCBS));
end;

function TNFSeWClass.GerarXMLgIBSCBS(
  gIBSCBS: TgIBSCBS): TACBrXmlNode;
begin
  Result := CreateElement('gIBSCBS');

  Result.AppendChild(AddNode(tcStr, '#1', 'CST', 3, 3, NrOcorrCST,
                                              CSTIBSCBSToStr(gIBSCBS.CST), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cClassTrib', 6, 6, 1,
                                                       gIBSCBS.cClassTrib, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cCredPres', 2, 2, NrOcorrcCredPres,
                                        cCredPresToStr(gIBSCBS.cCredPres), ''));

  if (gIBSCBS.gTribRegular.CSTReg <> cstNenhum) and GerarTribRegular then
    Result.AppendChild(GerarXMLgTribRegular(gIBSCBS.gTribRegular));

  if ((gIBSCBS.gDif.pDifUF > 0) or (gIBSCBS.gDif.pDifMun > 0) or
     (gIBSCBS.gDif.pDifCBS > 0)) and GerargDif then
    Result.AppendChild(GerarXMLgDif(gIBSCBS.gDif));
end;

function TNFSeWClass.GerarXMLgTribRegular(
  gTribRegular: TgTribRegular): TACBrXmlNode;
begin
  Result := CreateElement('gTribRegular');

  Result.AppendChild(AddNode(tcStr, '#1', 'CSTReg', 3, 3, NrOcorrCSTReg,
                                      CSTIBSCBSToStr(gTribRegular.CSTReg), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cClassTribReg', 6, 6, 1,
                                               gTribRegular.cClassTribReg, ''));
end;

function TNFSeWClass.GerarXMLgDif(gDif: TgDif): TACBrXmlNode;
begin
  Result := CreateElement('gDif');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pDifUF', 1, 15, 1,
                                                              gDif.pDifUF, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pDifMun', 1, 15, 1,
                                                             gDif.pDifMun, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pDifCBS', 1, 15, 1,
                                                             gDif.pDifCBS, ''));
end;

procedure TNFSeWClass.GerarINIIBSCBS(AINIRec: TMemIniFile;
  IBSCBS: TIBSCBSDPS);
begin
  LSecao := 'IBSCBSDPS';

  AINIRec.WriteString(LSecao, 'finNFSe', finNFSeToStr(IBSCBS.finNFSe));
  AINIRec.WriteString(LSecao, 'indFinal', indFinalToStr(IBSCBS.indFinal));
  AINIRec.WriteString(LSecao, 'cIndOp', IBSCBS.cIndOp);
  AINIRec.WriteString(LSecao, 'tpOper', tpOperGovNFSeToStr(IBSCBS.tpOper));
  AINIRec.WriteString(LSecao, 'tpEnteGov', tpEnteGovToStr(IBSCBS.tpEnteGov));
  AINIRec.WriteString(LSecao, 'indDest', indDestToStr(IBSCBS.indDest));

  GerarINIgRefNFSe(AINIRec, IBSCBS.gRefNFSe);
  GerarINIDestinatario(AINIRec, IBSCBS.dest);
  GerarINIImovel(AINIRec, IBSCBS.imovel);
  GerarINIIBSCBSValores(AINIRec, IBSCBS.valores);
end;

procedure TNFSeWClass.GerarINIgRefNFSe(AINIRec: TMemIniFile;
  gRefNFSe: TgRefNFSeCollection);
var
  i: Integer;
begin
  for i := 0 to gRefNFSe.Count - 1 do
  begin
    LSecao := 'gRefNFSe' + IntToStrZero(i+1, 2);

    AINIRec.WriteString(LSecao, 'refNFSe', gRefNFSe[i].refNFSe);
  end;
end;

procedure TNFSeWClass.GerarINIDestinatario(AINIRec: TMemIniFile;
  Dest: TDadosdaPessoa);
begin
  LSecao := 'Destinatario';

  AINIRec.WriteString(LSecao, 'CNPJCPF', Dest.CNPJCPF);
  AINIRec.WriteString(LSecao, 'NIF', Dest.NIF);
  AINIRec.WriteString(LSecao, 'cNaoNIF', NaoNIFToStr(Dest.cNaoNIF));
  AINIRec.WriteString(LSecao, 'xNome', Dest.xNome);

  AINIRec.WriteString(LSecao, 'CEP', Dest.ender.endNac.CEP);
  AINIRec.WriteInteger(LSecao, 'cMun', Dest.ender.endNac.cMun);
  AINIRec.WriteInteger(LSecao, 'cPais', Dest.ender.endExt.cPais);
  AINIRec.WriteString(LSecao, 'cEndPost', Dest.ender.endExt.cEndPost);
  AINIRec.WriteString(LSecao, 'xCidade', Dest.ender.endExt.xCidade);
  AINIRec.WriteString(LSecao, 'xEstProvReg', Dest.ender.endExt.xEstProvReg);

  AINIRec.WriteString(LSecao, 'Logradouro', Dest.ender.xLgr);
  AINIRec.WriteString(LSecao, 'Numero', Dest.ender.nro);
  AINIRec.WriteString(LSecao, 'Complemento', Dest.ender.xCpl);
  AINIRec.WriteString(LSecao, 'Bairro', Dest.ender.xBairro);

  AINIRec.WriteString(LSecao, 'Telefone', Dest.fone);
  AINIRec.WriteString(LSecao, 'Email', Dest.email);
end;

procedure TNFSeWClass.GerarINIImovel(AINIRec: TMemIniFile;
  Imovel: TDadosimovel);
begin
  LSecao := 'Imovel';

  AINIRec.WriteString(LSecao, 'inscImobFisc', Imovel.inscImobFisc);
  AINIRec.WriteString(LSecao, 'cCIB', Imovel.cCIB);

  AINIRec.WriteString(LSecao, 'CEP', Imovel.ender.CEP);
  AINIRec.WriteString(LSecao, 'Logradouro', Imovel.ender.xLgr);
  AINIRec.WriteString(LSecao, 'Numero', Imovel.ender.nro);
  AINIRec.WriteString(LSecao, 'Complemento', Imovel.ender.xCpl);
  AINIRec.WriteString(LSecao, 'Bairro', Imovel.ender.xBairro);

  AINIRec.WriteString(LSecao, 'cEndPost', Imovel.ender.endExt.cEndPost);
  AINIRec.WriteString(LSecao, 'xCidade', Imovel.ender.endExt.xCidade);
  AINIRec.WriteString(LSecao, 'xEstProvReg', Imovel.ender.endExt.xEstProvReg);
end;

procedure TNFSeWClass.GerarINIIBSCBSValores(AINIRec: TMemIniFile;
  Valores: Tvalorestrib);
begin
  GerarINIDocumentos(AINIRec, Valores.gReeRepRes.documentos);
  GerarINITributacao(AINIRec, Valores.trib);
end;

procedure TNFSeWClass.GerarINIDocumentos(AINIRec: TMemIniFile;
  Documentos: TdocumentosCollection);
var
  i: Integer;
begin
  for i := 0 to Documentos.Count - 1 do
  begin
    LSecao := 'Documentos' + IntToStrZero(i+1, 4);

    AINIRec.WriteString(LSecao, 'tipoChaveDFe', tipoChaveDFeToStr(Documentos[i].dFeNacional.tipoChaveDFe));
    AINIRec.WriteString(LSecao, 'chaveDFe', Documentos[i].dFeNacional.chaveDFe);

    AINIRec.WriteInteger(LSecao, 'cMunDocFiscal', Documentos[i].docFiscalOutro.cMunDocFiscal);
    AINIRec.WriteString(LSecao, 'nDocFiscal', Documentos[i].docFiscalOutro.nDocFiscal);
    AINIRec.WriteString(LSecao, 'xDocFiscal', Documentos[i].docFiscalOutro.xDocFiscal);

    AINIRec.WriteString(LSecao, 'nDoc', Documentos[i].docOutro.nDoc);
    AINIRec.WriteString(LSecao, 'xDoc', Documentos[i].docOutro.xDoc);

    AINIRec.WriteString(LSecao, 'CNPJCPF', Documentos[i].fornec.CNPJCPF);
    AINIRec.WriteString(LSecao, 'NIF', Documentos[i].fornec.NIF);
    AINIRec.WriteString(LSecao, 'cNaoNIF', NaoNIFToStr(Documentos[i].fornec.cNaoNIF));
    AINIRec.WriteString(LSecao, 'xNome', Documentos[i].fornec.xNome);

    AINIRec.WriteString(LSecao, 'dtEmiDoc', DateToStr(Documentos[i].dtEmiDoc));
    AINIRec.WriteString(LSecao, 'dtCompDoc', DateToStr(Documentos[i].dtCompDoc));
    AINIRec.WriteString(LSecao, 'tpReeRepRes', tpReeRepResToStr(Documentos[i].tpReeRepRes));
    AINIRec.WriteString(LSecao, 'xTpReeRepRes', Documentos[i].xTpReeRepRes);
    AINIRec.WriteFloat(LSecao, 'vlrReeRepRes', Documentos[i].vlrReeRepRes);
  end;
end;

procedure TNFSeWClass.GerarINITributacao(AINIRec: TMemIniFile;
  Tributacao: Ttrib);
begin
  GerarINIgIBSCBS(AINIRec, Tributacao.gIBSCBS);
end;

procedure TNFSeWClass.GerarINIgIBSCBS(AINIRec: TMemIniFile;
  gIBSCBS: TgIBSCBS);
begin
  LSecao := 'gIBSCBS';

  AINIRec.WriteString(LSecao, 'CST', CSTIBSCBSToStr(gIBSCBS.CST));
  AINIRec.WriteString(LSecao, 'cClassTrib', gIBSCBS.cClassTrib);
  AINIRec.WriteString(LSecao, 'cCredPres', cCredPresToStr(gIBSCBS.cCredPres));

  GerarINIgTribRegular(AINIRec, gIBSCBS.gTribRegular);
  GerarINIgDif(AINIRec, gIBSCBS.gDif);
end;

procedure TNFSeWClass.GerarINIgTribRegular(AINIRec: TMemIniFile;
  gTribRegular: TgTribRegular);
begin
  LSecao := 'gTribRegular';

  AINIRec.WriteString(LSecao, 'CSTReg', CSTIBSCBSToStr(gTribRegular.CSTReg));
  AINIRec.WriteString(LSecao, 'cClassTribReg', gTribRegular.cClassTribReg);
end;

procedure TNFSeWClass.GerarINIgDif(AINIRec: TMemIniFile; gDif: TgDif);
begin
  LSecao := 'gDif';

  AINIRec.WriteFloat(LSecao, 'pDifUF', gDif.pDifUF);
  AINIRec.WriteFloat(LSecao, 'pDifMun', gDif.pDifMun);
  AINIRec.WriteFloat(LSecao, 'pDifCBS', gDif.pDifCBS);
end;

procedure TNFSeWClass.GerarINIIBSCBSNFSe(AINIRec: TMemIniFile;
  IBSCBS: TIBSCBSNfse);
begin
  LSecao := 'IBSCBSNFSE';

  AINIRec.WriteInteger(LSecao, 'cLocalidadeIncid', IBSCBS.cLocalidadeIncid);
  AINIRec.WriteString(LSecao, 'xLocalidadeIncid', IBSCBS.xLocalidadeIncid);
  AINIRec.WriteFloat(LSecao, 'pRedutor', IBSCBS.pRedutor);

  GerarINIIBSCBSValoresNFSe(AINIRec, IBSCBS.valores);
  GerarINITotCIBS(AINIRec, IBSCBS.totCIBS);
end;

procedure TNFSeWClass.GerarINIIBSCBSValoresNFSe(AINIRec: TMemIniFile;
  Valores: TvaloresIBSCBS);
begin
  LSecao := 'IBSCBSValoresNFSE';

  AINIRec.WriteFloat(LSecao, 'vBC', Valores.vBC);
  AINIRec.WriteFloat(LSecao, 'vCalcReeRepRes', Valores.vCalcReeRepRes);

  AINIRec.WriteFloat(LSecao, 'pIBSUF', Valores.uf.pIBSUF);
  AINIRec.WriteFloat(LSecao, 'pRedAliqUF', Valores.uf.pRedAliqUF);
  AINIRec.WriteFloat(LSecao, 'pAliqEfetUF', Valores.uf.pAliqEfetUF);

  AINIRec.WriteFloat(LSecao, 'pIBSMun', Valores.mun.pIBSMun);
  AINIRec.WriteFloat(LSecao, 'pRedAliqMun', Valores.mun.pRedAliqMun);
  AINIRec.WriteFloat(LSecao, 'pAliqEfetMun', Valores.mun.pAliqEfetMun);

  AINIRec.WriteFloat(LSecao, 'pCBS', Valores.Fed.pCBS);
  AINIRec.WriteFloat(LSecao, 'pRedAliqCBS', Valores.Fed.pRedAliqCBS);
  AINIRec.WriteFloat(LSecao, 'pAliqEfetCBS', Valores.Fed.pAliqEfetCBS);
end;

procedure TNFSeWClass.GerarINITotCIBS(AINIRec: TMemIniFile;
  TotCIBS: TTotCIBS);
begin
  LSecao := 'TotCIBS';

  AINIRec.WriteFloat(LSecao, 'vTotNF', TotCIBS.vTotNF);

  GerarINIgTribRegularNFSe(AINIRec, TotCIBS.gTribRegular);
  GerarINIgTribCompraGov(AINIRec, TotCIBS.gTribCompraGov);
  GerarINITotgIBS(AINIRec, TotCIBS.gIBS);
  GerarINITotgCBS(AINIRec, TotCIBS.gCBS);
end;

procedure TNFSeWClass.GerarINIgTribRegularNFSe(AINIRec: TMemIniFile;
  gTribRegularNFSe: TgTribRegularNFSe);
begin
  LSecao := 'gTribRegularNFSe';

  AINIRec.WriteFloat(LSecao, 'pAliqEfeRegIBSUF', gTribRegularNFSe.pAliqEfeRegIBSUF);
  AINIRec.WriteFloat(LSecao, 'vTribRegIBSUF', gTribRegularNFSe.vTribRegIBSUF);
  AINIRec.WriteFloat(LSecao, 'pAliqEfeRegIBSMun', gTribRegularNFSe.pAliqEfeRegIBSMun);
  AINIRec.WriteFloat(LSecao, 'vTribRegIBSMun', gTribRegularNFSe.vTribRegIBSMun);
  AINIRec.WriteFloat(LSecao, 'pAliqEfeRegCBS', gTribRegularNFSe.pAliqEfeRegCBS);
  AINIRec.WriteFloat(LSecao, 'vTribRegCBS', gTribRegularNFSe.vTribRegCBS);
end;

procedure TNFSeWClass.GerarINIgTribCompraGov(AINIRec: TMemIniFile;
  gTribCompraGov: TgTribCompraGov);
begin
  LSecao := 'gTribCompraGov';

  AINIRec.WriteFloat(LSecao, 'pIBSUF', gTribCompraGov.pIBSUF);
  AINIRec.WriteFloat(LSecao, 'vIBSUF', gTribCompraGov.vIBSUF);
  AINIRec.WriteFloat(LSecao, 'pIBSMun', gTribCompraGov.pIBSMun);
  AINIRec.WriteFloat(LSecao, 'vIBSMun', gTribCompraGov.vIBSMun);
  AINIRec.WriteFloat(LSecao, 'pCBS', gTribCompraGov.pCBS);
  AINIRec.WriteFloat(LSecao, 'vCBS', gTribCompraGov.vCBS);
end;

procedure TNFSeWClass.GerarINITotgIBS(AINIRec: TMemIniFile;
  TotgIBS: TgIBS);
begin
  LSecao := 'TotgIBS';

  AINIRec.WriteFloat(LSecao, 'vIBSTot', TotgIBS.vIBSTot);

  AINIRec.WriteFloat(LSecao, 'pCredPresIBS', TotgIBS.gIBSCredPres.pCredPresIBS);
  AINIRec.WriteFloat(LSecao, 'vCredPresIBS', TotgIBS.gIBSCredPres.vCredPresIBS);

  AINIRec.WriteFloat(LSecao, 'vDifUF', TotgIBS.gIBSUFTot.vDifUF);
  AINIRec.WriteFloat(LSecao, 'vIBSUF', TotgIBS.gIBSUFTot.vIBSUF);

  AINIRec.WriteFloat(LSecao, 'vDifMun', TotgIBS.gIBSMunTot.vDifMun);
  AINIRec.WriteFloat(LSecao, 'vIBSMun', TotgIBS.gIBSMunTot.vIBSMun);
end;

procedure TNFSeWClass.GerarINITotgCBS(AINIRec: TMemIniFile;
  TotgCBS: TgCBS);
begin
  LSecao := 'TotgCBS';

  AINIRec.WriteFloat(LSecao, 'vDifCBS', TotgCBS.vDifCBS);
  AINIRec.WriteFloat(LSecao, 'vCBS', TotgCBS.vCBS);

  AINIRec.WriteFloat(LSecao, 'pCredPresCBS', TotgCBS.gCBSCredPres.pCredPresCBS);
  AINIRec.WriteFloat(LSecao, 'vCredPresCBS', TotgCBS.gCBSCredPres.vCredPresCBS);
end;

end.
