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

unit ACBrDFeComum.RetDistDFeInt;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  ACBrBase,
  ACBrDFe,
  pcnConversao,
  ACBrXmlBase,
  ACBrXmlDocument;

type
  TDetEventoCTe = class(TObject)
  private
    FchCTe: string;
    Fmodal: TpcteModal;
    FdhEmi: TDateTime;
    FnProt: string;
    FdhRecbto: TDateTime;
  public
    property chCTe: string       read FchCTe    write FchCTe;
    property modal: TpcteModal   read Fmodal    write Fmodal;
    property dhEmi: TDateTime    read FdhEmi    write FdhEmi;
    property nProt: string       read FnProt    write FnProt;
    property dhRecbto: TDateTime read FdhRecbto write FdhRecbto;
  end;

  TDetEventoEmit = class(TObject)
  private
    FCNPJ: string;
    FIE: string;
    FxNome: string;
  public
    property CNPJ: string  read FCNPJ  write FCNPJ;
    property IE: string    read FIE    write FIE;
    property xNome: string read FxNome write FxNome;
  end;

  TitensAverbadosCollectionItem = class(TObject)
  private
    FdhEmbarque: TDateTime;
    FdhAverbacao: TDateTime;
    FnDue: string;
    FnItem: Integer;
    FnItemDue: Integer;
    FqItem: Integer;
    FmotAlteracao: Integer;

  public
    property dhEmbarque: TDateTime  read FdhEmbarque   write FdhEmbarque;
    property dhAverbacao: TDateTime read FdhAverbacao  write FdhAverbacao;
    property nDue: string           read FnDue         write FnDue;
    property nItem: Integer         read FnItem        write FnItem;
    property nItemDue: Integer      read FnItemDue     write FnItemDue;
    property qItem: Integer         read FqItem        write FqItem;
    property motAlteracao: Integer  read FmotAlteracao write FmotAlteracao;
  end;

  TitensAverbadosCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TitensAverbadosCollectionItem;
    procedure SetItem(Index: Integer; Value: TitensAverbadosCollectionItem);
  public
    function New: TitensAverbadosCollectionItem;
    property Items[Index: Integer]: TitensAverbadosCollectionItem read GetItem write SetItem; default;
  end;

  TprocEvento_DetEvento = class(TObject)
  private
    FVersao: string;
    FDescEvento: string;
    FnProt: string;
    FxJust: string;
    FxCorrecao: string;
    FtpAutor: Integer;
    FverAplic: string;

    FCTe: TDetEventoCTe;
    Femit: TDetEventoEmit;
    FitensAverbados: TitensAverbadosCollection;

    procedure SetitensAverbados(const Value: TitensAverbadosCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property versao: string     read FVersao     write FVersao;
    property descEvento: string read FDescEvento write FDescEvento;
    property nProt: string      read FnProt      write FnProt;
    property xJust: string      read FxJust      write FxJust;
    property xCorrecao: string  read FxCorrecao  write FxCorrecao;
    property tpAutor: Integer   read FtpAutor    write FtpAutor;
    property verAplic: string   read FverAplic   write FverAplic;

    property CTe: TDetEventoCTe   read FCTe  write FCTe;
    property emit: TDetEventoEmit read Femit write Femit;
    property itensAverbados: TitensAverbadosCollection read FitensAverbados write SetitensAverbados;
  end;

  TprocEvento_RetInfEvento = class(TObject)
  private
    FId: string;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: string;
    FcOrgao: Integer;
    FcStat: Integer;
    FxMotivo: string;
    FchDFe: string;
    FtpEvento: TpcnTpEvento;
    FxEvento: string;
    FnSeqEvento: Integer;
    FCNPJDest: string;
    FemailDest: string;
    FcOrgaoAutor: Integer;
    FdhRegEvento: TDateTime;
    FnProt: string;
  public
    property Id: string              read FId          write FId;
    property tpAmb: TpcnTipoAmbiente read FtpAmb       write FtpAmb;
    property verAplic: string        read FverAplic    write FverAplic;
    property cOrgao: Integer         read FcOrgao      write FcOrgao;
    property cStat: Integer          read FcStat       write FcStat;
    property xMotivo: string         read FxMotivo     write FxMotivo;
    property chDFe: string           read FchDFe       write FchDFe;
    property tpEvento: TpcnTpEvento  read FtpEvento    write FtpEvento;
    property xEvento: string         read FxEvento     write FxEvento;
    property nSeqEvento: Integer     read FnSeqEvento  write FnSeqEvento;
    property CNPJDest: string        read FCNPJDest    write FCNPJDest;
    property emailDest: string       read FemailDest   write FemailDest;
    property cOrgaoAutor: Integer    read FcOrgaoAutor write FcOrgaoAutor;
    property dhRegEvento: TDateTime  read FdhRegEvento write FdhRegEvento;
    property nProt: string           read FnProt       write FnProt;
  end;

  TresDFe = class(TObject)
  private
    FchDFe: string;
    FCNPJCPF: string;
    FxNome: string;
    FIE: string;
    FdhEmi: TDateTime;
    FtpNF: TpcnTipoNFe;
    FvNF: Currency;
    FdigVal: string;
    FdhRecbto: TDateTime;
    FnProt: string;
    FcSitDFe: TSituacaoDFe;
  public
    property chDFe: string            read FchDFe    write FchDFe;
    property CNPJCPF: string          read FCNPJCPF  write FCNPJCPF;
    property xNome: string            read FxNome    write FxNome;
    property IE: string               read FIE       write FIE;
    property dhEmi: TDateTime         read FdhEmi    write FdhEmi;
    property tpNF: TpcnTipoNFe        read FtpNF     write FtpNF;
    property vNF: Currency            read FvNF      write FvNF;
    property digVal: string           read FdigVal   write FdigVal;
    property dhRecbto: TDateTime      read FdhRecbto write FdhRecbto;
    property nProt: string            read FnProt    write FnProt;
    property cSitDFe: TSituacaoDFe    read FcSitDFe  write FcSitDFe;
  end;

  TresEvento = class(TObject)
  private
    FcOrgao: Integer;
    FCNPJCPF: string;
    FchDFe: string;
    FdhEvento: TDateTime;
    FtpEvento: TpcnTpEvento;
    FnSeqEvento: ShortInt;
    FxEvento: string;
    FdhRecbto: TDateTime;
    FnProt: string;
  public
    property cOrgao: Integer        read FcOrgao     write FcOrgao;
    property CNPJCPF: string        read FCNPJCPF    write FCNPJCPF;
    property chDFe: string          read FchDFe      write FchDFe;
    property dhEvento: TDateTime    read FdhEvento   write FdhEvento;
    property tpEvento: TpcnTpEvento read FtpEvento   write FtpEvento;
    property nSeqEvento: ShortInt   read FnSeqEvento write FnSeqEvento;
    property xEvento: string        read FxEvento    write FxEvento;
    property dhRecbto: TDateTime    read FdhRecbto   write FdhRecbto;
    property nProt: string          read FnProt      write FnProt;
  end;

  TprocEvento = class(TObject)
  private
    FId: string;
    FcOrgao: Integer;
    FtpAmb: TpcnTipoAmbiente;
    FCNPJ: string;
    FchDFe: string;
    FdhEvento: TDateTime;
    FtpEvento: TpcnTpEvento;
    FnSeqEvento: Integer;
    FverEvento: string;

    FDetEvento: TprocEvento_DetEvento;
    FRetInfEvento: TprocEvento_RetInfEvento;
  public
    constructor Create;
    destructor Destroy; override;

    property Id: string              read FId             write FId;
    property cOrgao: Integer         read FcOrgao         write FcOrgao;
    property tpAmb: TpcnTipoAmbiente read FtpAmb          write FtpAmb;
    property CNPJ: string            read FCNPJ           write FCNPJ;
    property chDFe: string           read FchDFe          write FchDFe;
    property dhEvento: TDateTime     read FdhEvento       write FdhEvento;
    property tpEvento: TpcnTpEvento  read FtpEvento       write FtpEvento;
    property nSeqEvento: Integer     read FnSeqEvento     write FnSeqEvento;
    property verEvento: string       read FverEvento      write FverEvento;

    property detEvento: TprocEvento_DetEvento read FDetEvento write FDetEvento;
    property RetinfEvento: TprocEvento_RetInfEvento read FRetInfEvento write FRetInfEvento;
  end;

  TdocZipCollectionItem = class(TObject)
  private
    // Atributos do resumo do DFe ou Evento
    FNSU: string;
    Fschema: TSchemaDFe;

    // A propriedade InfZip contem a informa��o Resumida ou documento fiscal
    // eletr�nico Compactado no padr�o gZip
    FInfZip: string;

    // Resumos e Processamento de Eventos Descompactados
    FresDFe: TresDFe;
    FresEvento: TresEvento;
    FprocEvento: TprocEvento;

    // XML do Resumo ou Documento descompactado
    FXML: string;
    FNomeArq: string;

  public
    constructor Create;
    destructor Destroy; override;

    property NSU: string             read FNSU        write FNSU;
    property schema: TSchemaDFe      read Fschema     write Fschema;
    property InfZip: string          read FInfZip     write FInfZip;
    property resDFe: TresDFe         read FresDFe     write FresDFe;
    property resEvento: TresEvento   read FresEvento  write FresEvento;
    property procEvento: TprocEvento read FprocEvento write FprocEvento;
    property XML: string             read FXML        write FXML;
    property NomeArq: string         read FNomeArq    write FNomeArq;
  end;

  TdocZipCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TdocZipCollectionItem;
    procedure SetItem(Index: Integer; Value: TdocZipCollectionItem);
  public
    function New: TdocZipCollectionItem;
    property Items[Index: Integer]: TdocZipCollectionItem read GetItem write SetItem; default;
  end;

  TRetDistDFeInt = class(TObject)
  private
    FOwner: TACBrDFe;

    Fversao: string;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: string;
    FcStat: Integer;
    FxMotivo: string;
    FdhResp: TDateTime;
    FultNSU: string;
    FmaxNSU: string;
    FdocZip: TdocZipCollection;
    FXML: AnsiString;

    FptpDFe: string;

    FXmlRetorno: string;

    procedure SetdocZip(const Value: TdocZipCollection);
  public
    constructor Create(AOwner: TACBrDFe; const AtpDFe: string);
    destructor Destroy; override;

    procedure LerResumo(const ANode: TACBrXmlNode; Indice: Integer);
    procedure LerResumoEvento(const ANode: TACBrXmlNode; Indice: Integer);
    procedure LerDocumento(const ANode: TACBrXmlNode; Indice: Integer);
    procedure LerGrupo_ide(const ANode: TACBrXmlNode; Indice: Integer);
    procedure LerGrupo_emit(const ANode: TACBrXmlNode; Indice: Integer);
    procedure LerGrupo_total(const ANode: TACBrXmlNode; Indice: Integer);
    procedure LerGrupo_vPrest(const ANode: TACBrXmlNode; Indice: Integer);
    procedure LerGrupo_infProt(const ANode: TACBrXmlNode; Indice: Integer);

    procedure LerGrupo_detEvento(const ANode: TACBrXmlNode; Indice: Integer);
    procedure LerGrupo_retEvento(const ANode: TACBrXmlNode; Indice: Integer);
    procedure LerGrupo_detEvento_CTe(const ANode: TACBrXmlNode; Indice: Integer);
    procedure LerGrupo_detEvento_emit(const ANode: TACBrXmlNode; Indice: Integer);
    procedure LerGrupo_detEvento_itensAverbados(const ANodes: TACBrXmlNodeArray;
      Indice: Integer);

    procedure LerEvento(const ANode: TACBrXmlNode; Indice: Integer);

    procedure LerDocumentoDecodificado(const DocDecod: AnsiString; Indice: Integer);
    procedure LerLoteDistDFeInt(const ANode: TACBrXmlNode);

    function LerXml: boolean;
    function LerXMLFromFile(Const CaminhoArquivo: string;
      const AtpDFe: string = 'NFe'): Boolean;
    function GerarPathDistribuicao(AItem :TdocZipCollectionItem): string;
    function GerarNomeArquivo(AItem :TdocZipCollectionItem): string;

    property versao: string            read Fversao   write Fversao;
    property tpAmb: TpcnTipoAmbiente   read FtpAmb    write FtpAmb;
    property verAplic: string          read FverAplic write FverAplic;
    property cStat: Integer            read FcStat    write FcStat;
    property xMotivo: string           read FxMotivo  write FxMotivo;
    property dhResp: TDateTime         read FdhResp   write FdhResp;
    property ultNSU: string            read FultNSU   write FultNSU;
    property maxNSU: string            read FmaxNSU   write FmaxNSU;
    property docZip: TdocZipCollection read FdocZip   write SetdocZip;
    property XML: AnsiString           read FXML      write FXML;

    property XmlRetorno: string read FXmlRetorno write FXmlRetorno;
  end;

implementation

uses 
  synacode,
  ACBrDFeException,
  ACBrUtil.Strings, ACBrUtil.XMLHTML, ACBrUtil.FilesIO;

{ TitensAverbadosCollection }

function TitensAverbadosCollection.GetItem(
  Index: Integer): TitensAverbadosCollectionItem;
begin
  Result := TitensAverbadosCollectionItem(inherited Items[Index]);
end;

function TitensAverbadosCollection.New: TitensAverbadosCollectionItem;
begin
  Result := TitensAverbadosCollectionItem.Create;
  Add(Result);
end;

procedure TitensAverbadosCollection.SetItem(Index: Integer;
  Value: TitensAverbadosCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TprocEvento_DetEvento }

constructor TprocEvento_DetEvento.Create;
begin
  inherited Create;

  FCTe  := TDetEventoCTe.Create;
  Femit := TDetEventoEmit.Create;
  FitensAverbados := TitensAverbadosCollection.Create();
end;

destructor TprocEvento_DetEvento.Destroy;
begin
  FCTe.Free;
  Femit.Free;
  FitensAverbados.Free;

  inherited;
end;

procedure TprocEvento_DetEvento.SetitensAverbados(
  const Value: TitensAverbadosCollection);
begin
  FitensAverbados := Value;
end;

{ TprocEvento }

constructor TprocEvento.Create;
begin
  inherited Create;
  FdetEvento    := TprocEvento_detEvento.Create;
  FRetInfEvento := TprocEvento_RetInfEvento.Create;
end;

destructor TprocEvento.Destroy;
begin
  FdetEvento.Free;
  FRetInfEvento.Free;

  inherited;
end;

{ TdocZipCollection }

function TdocZipCollection.GetItem(Index: Integer): TdocZipCollectionItem;
begin
  Result := TdocZipCollectionItem(inherited Items[Index]);
end;

procedure TdocZipCollection.SetItem(Index: Integer;
  Value: TdocZipCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TdocZipCollection.New: TdocZipCollectionItem;
begin
  Result := TdocZipCollectionItem.Create;
  Add(Result);
end;

{ TdocZipCollectionItem }

constructor TdocZipCollectionItem.Create;
begin
  inherited Create;
  FresDFe     := TresDFe.Create;
  FresEvento  := TresEvento.Create;
  FprocEvento := TprocEvento.Create;
end;

destructor TdocZipCollectionItem.Destroy;
begin
  FresDFe.Free;
  FresEvento.Free;
  FprocEvento.Free;

  inherited;
end;

{ TRetDistDFeInt }

constructor TRetDistDFeInt.Create(AOwner: TACBrDFe; const AtpDFe: string);
begin
  inherited Create;

  FdocZip := TdocZipCollection.Create();

  FOwner := AOwner;
  FptpDFe := AtpDFe;
end;

destructor TRetDistDFeInt.Destroy;
begin
  FdocZip.Free;

  inherited;
end;

procedure TRetDistDFeInt.SetdocZip(const Value: TdocZipCollection);
begin
  FdocZip := Value;
end;

procedure TRetDistDFeInt.LerResumo(const ANode: TACBrXmlNode; Indice: Integer);
var
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  docZip[Indice].XML := InserirDeclaracaoXMLSeNecessario(ANode.OuterXml);
  docZip[Indice].resDFe.chDFe := ObterConteudoTag(ANode.Childrens.FindAnyNs('ch' + FptpDFe), tcStr);
  docZip[Indice].resDFe.CNPJCPF := ObterConteudoTag(ANode.Childrens.FindAnyNs('CNPJ'), tcStr);

  if docZip[Indice].resDFe.CNPJCPF = '' then
    docZip[Indice].resDFe.CNPJCPF := ObterConteudoTag(ANode.Childrens.FindAnyNs('CPF'), tcStr);

  docZip[Indice].resDFe.xNome := ObterConteudoTag(ANode.Childrens.FindAnyNs('xNome'), tcStr);
  docZip[Indice].resDFe.IE := ObterConteudoTag(ANode.Childrens.FindAnyNs('IE'), tcStr);
  docZip[Indice].resDFe.dhEmi := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhEmi'), tcDatHor);
  docZip[Indice].resDFe.tpNF := StrToTpNF(Ok, ObterConteudoTag(ANode.Childrens.FindAnyNs('tpNF'), tcStr));
  docZip[Indice].resDFe.vNF := ObterConteudoTag(ANode.Childrens.FindAnyNs('vNF'), tcDe2);
  docZip[Indice].resDFe.digVal := ObterConteudoTag(ANode.Childrens.FindAnyNs('digVal'), tcStr);
  docZip[Indice].resDFe.dhRecbto := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhRecbto'), tcDatHor);
  docZip[Indice].resDFe.nProt := ObterConteudoTag(ANode.Childrens.FindAnyNs('nProt'), tcStr);
  docZip[Indice].resDFe.cSitDFe := StrToSituacaoDFe(Ok, ObterConteudoTag(ANode.Childrens.FindAnyNs('cSitNFe'), tcStr));
end;

procedure TRetDistDFeInt.LerResumoEvento(const ANode: TACBrXmlNode; Indice: Integer);
var
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  docZip[Indice].XML := InserirDeclaracaoXMLSeNecessario(ANode.OuterXml);
  docZip[Indice].resEvento.chDFe := ObterConteudoTag(ANode.Childrens.FindAnyNs('ch' + FptpDFe), tcStr);
  docZip[Indice].resEvento.CNPJCPF := ObterConteudoTag(ANode.Childrens.FindAnyNs('CNPJ'), tcStr);

  if docZip[Indice].resEvento.CNPJCPF = '' then
    docZip[Indice].resEvento.CNPJCPF := ObterConteudoTag(ANode.Childrens.FindAnyNs('CPF'), tcStr);

  docZip[Indice].resEvento.cOrgao := ObterConteudoTag(ANode.Childrens.FindAnyNs('cOrgao'), tcInt);
  docZip[Indice].resEvento.dhEvento := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhEvento'), tcDatHor);
  // � preciso identificar o DF-e para usar a fun��o de convers�o correta.
  docZip[Indice].resEvento.tpEvento := StrToTpEventoDFe(Ok, ObterConteudoTag(ANode.Childrens.FindAnyNs('tpEvento'), tcStr), FptpDFe);
  docZip[Indice].resEvento.nSeqEvento := ObterConteudoTag(ANode.Childrens.FindAnyNs('nSeqEvento'), tcInt);
  docZip[Indice].resEvento.xEvento := ObterConteudoTag(ANode.Childrens.FindAnyNs('xEvento'), tcStr);
  docZip[Indice].resEvento.dhRecbto := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhRecbto'), tcDatHor);
  docZip[Indice].resEvento.nProt := ObterConteudoTag(ANode.Childrens.FindAnyNs('nProt'), tcStr);
end;

procedure TRetDistDFeInt.LerGrupo_ide(const ANode: TACBrXmlNode;
  Indice: Integer);
var
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  docZip[Indice].resDFe.dhEmi := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhEmi'), tcDatHor);

  // Se for Vers�o 2.00 a data de emiss�o est� em dEmi
  if docZip[Indice].resDFe.dhEmi  = 0 then
    docZip[Indice].resDFe.dhEmi := ObterConteudoTag(ANode.Childrens.FindAnyNs('dEmi'), tcDat);

  docZip[Indice].resDFe.tpNF := StrToTpNF(Ok, ObterConteudoTag(ANode.Childrens.FindAnyNs('tpNF'), tcStr));
end;

procedure TRetDistDFeInt.LerGrupo_emit(const ANode: TACBrXmlNode;
  Indice: Integer);
begin
  if not Assigned(ANode) then Exit;

  docZip[Indice].resDFe.CNPJCPF := ObterConteudoTag(ANode.Childrens.FindAnyNs('CNPJ'), tcStr);

  if docZip[Indice].resDFe.CNPJCPF = '' then
    docZip[Indice].resDFe.CNPJCPF := ObterConteudoTag(ANode.Childrens.FindAnyNs('CPF'), tcStr);

  docZip[Indice].resDFe.xNome := ObterConteudoTag(ANode.Childrens.FindAnyNs('xNome'), tcStr);
  docZip[Indice].resDFe.IE := ObterConteudoTag(ANode.Childrens.FindAnyNs('IE'), tcStr);
end;

procedure TRetDistDFeInt.LerGrupo_total(const ANode: TACBrXmlNode;
  Indice: Integer);
begin
  if not Assigned(ANode) then Exit;

  // Leitura do valor da nota fiscal - NF-e
  docZip[Indice].resDFe.vNF := ObterConteudoTag(ANode.Childrens.FindAnyNs('vNF'), tcDe2);
end;

procedure TRetDistDFeInt.LerGrupo_vPrest(const ANode: TACBrXmlNode;
  Indice: Integer);
begin
  if not Assigned(ANode) then Exit;

  // Leitura do valor total da presta��o - CT-e
  docZip[Indice].resDFe.vNF := ObterConteudoTag(ANode.Childrens.FindAnyNs('vTPrest'), tcDe2);
end;

procedure TRetDistDFeInt.LerGrupo_infProt(const ANode: TACBrXmlNode;
  Indice: Integer);
var
  Status: Integer;
begin
  if not Assigned(ANode) then Exit;

  docZip[Indice].resDFe.digVal := ObterConteudoTag(ANode.Childrens.FindAnyNs('digVal'), tcStr);
  docZip[Indice].resDFe.dhRecbto := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhRecbto'), tcDatHor);
  docZip[Indice].resDFe.nProt := ObterConteudoTag(ANode.Childrens.FindAnyNs('nProt'), tcStr);
  Status := ObterConteudoTag(ANode.Childrens.FindAnyNs('cStat'), tcInt);

  case Status of
    100: docZip[Indice].resDFe.cSitDFe := snAutorizado;
    101: docZip[Indice].resDFe.cSitDFe := snCancelado;
    110: docZip[Indice].resDFe.cSitDFe := snDenegado;
    132: docZip[Indice].resDFe.cSitDFe := snEncerrado;
  end;
end;

procedure TRetDistDFeInt.LerDocumento(const ANode: TACBrXmlNode; Indice: Integer);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) then Exit;

  docZip[Indice].XML := InserirDeclaracaoXMLSeNecessario(ANode.OuterXml);

  AuxNode := ANode.Childrens.FindAnyNs(FptpDFe);

  if Assigned(AuxNode) then
  begin
    // no caso do cte n�o � CTe e sim Cte.
    if FptpDFe = 'CTe' then
      AuxNode := AuxNode.Childrens.FindAnyNs('infCte')
    else
      AuxNode := AuxNode.Childrens.FindAnyNs('inf' + FptpDFe);

    if Assigned(AuxNode) then
    begin
      docZip[Indice].resDFe.chDFe := ObterConteudoTag(AuxNode.Attributes.Items['Id']);

      LerGrupo_ide(AuxNode.Childrens.FindAnyNs('ide'), Indice);
      LerGrupo_emit(AuxNode.Childrens.FindAnyNs('emit'), Indice);
      LerGrupo_total(AuxNode.Childrens.FindAnyNs('total'), Indice);
      LerGrupo_vPrest(AuxNode.Childrens.FindAnyNs('vPrest'), Indice);
    end;
  end;

  AuxNode := ANode.Childrens.FindAnyNs('prot' + FptpDFe);

  if Assigned(AuxNode) then
    LerGrupo_infProt(AuxNode.Childrens.FindAnyNs('infProt'), Indice);
end;

procedure TRetDistDFeInt.LerGrupo_detEvento_CTe(const ANode: TACBrXmlNode;
  Indice: Integer);
var
  Ok: Boolean;
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('CTe');

  if Assigned(AuxNode) then
  begin
    docZip[Indice].procEvento.detEvento.CTe.chCTe := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('chCTe'), tcStr);
    docZip[Indice].procEvento.detEvento.CTe.modal := StrToTpModal(Ok, ObterConteudoTag(AuxNode.Childrens.FindAnyNs('modal'), tcStr));
    docZip[Indice].procEvento.detEvento.CTe.dhEmi := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('dhEmi'), tcDatHor);
    docZip[Indice].procEvento.detEvento.CTe.nProt := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nProt'), tcStr);
    docZip[Indice].procEvento.detEvento.CTe.dhRecbto := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('dhRecbto'), tcDatHor);
  end;
end;

procedure TRetDistDFeInt.LerGrupo_detEvento_emit(const ANode: TACBrXmlNode;
  Indice: Integer);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('emit');

  if Assigned(AuxNode) then
  begin
    docZip[Indice].procEvento.detEvento.emit.CNPJ := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('CNPJ'), tcStr);
    docZip[Indice].procEvento.detEvento.emit.IE := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('IE'), tcStr);
    docZip[Indice].procEvento.detEvento.emit.xNome := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('xNome'), tcStr);
  end;
end;

procedure TRetDistDFeInt.LerGrupo_detEvento_itensAverbados(
  const ANodes: TACBrXmlNodeArray; Indice: Integer);
var
  i: Integer;
begin
  if not Assigned(ANodes) then Exit;

  docZip.Items[Indice].procEvento.detEvento.itensAverbados.Clear;

  for i := 0 to Length(ANodes) - 1 do
  begin
    docZip.Items[Indice].procEvento.detEvento.itensAverbados.New;

    docZip.Items[Indice].procEvento.detEvento.itensAverbados[i].dhEmbarque := ObterConteudoTag(ANodes[i].Childrens.FindAnyNs('dhEmbarque'), tcDatHor);
    docZip.Items[Indice].procEvento.detEvento.itensAverbados[i].dhAverbacao := ObterConteudoTag(ANodes[i].Childrens.FindAnyNs('dhAverbacao'), tcDatHor);
    docZip.Items[Indice].procEvento.detEvento.itensAverbados[i].nDue := ObterConteudoTag(ANodes[i].Childrens.FindAnyNs('nDue'), tcStr);
    docZip.Items[Indice].procEvento.detEvento.itensAverbados[i].nItem := ObterConteudoTag(ANodes[i].Childrens.FindAnyNs('nItem'), tcInt);
    docZip.Items[Indice].procEvento.detEvento.itensAverbados[i].nItemDue := ObterConteudoTag(ANodes[i].Childrens.FindAnyNs('nItemDue'), tcInt);
    docZip.Items[Indice].procEvento.detEvento.itensAverbados[i].qItem := ObterConteudoTag(ANodes[i].Childrens.FindAnyNs('qItem'), tcInt);
    docZip.Items[Indice].procEvento.detEvento.itensAverbados[i].motAlteracao := ObterConteudoTag(ANodes[i].Childrens.FindAnyNs('motAlteracao'), tcInt);
  end;
end;

procedure TRetDistDFeInt.LerGrupo_detEvento(const ANode: TACBrXmlNode;
  Indice: Integer);
begin
  if not Assigned(ANode) then Exit;

  docZip[Indice].procEvento.detEvento.versao := ObterConteudoTag(ANode.Attributes.Items['versao']);
  docZip[Indice].procEvento.detEvento.nProt := ObterConteudoTag(ANode.Childrens.FindAnyNs('nProt'), tcStr);
  docZip[Indice].procEvento.detEvento.xJust := ObterConteudoTag(ANode.Childrens.FindAnyNs('xJust'), tcStr);
  docZip[Indice].procEvento.detEvento.xCorrecao := ObterConteudoTag(ANode.Childrens.FindAnyNs('xCorrecao'), tcStr);
  docZip[Indice].procEvento.detEvento.descEvento := ObterConteudoTag(ANode.Childrens.FindAnyNs('descEvento'), tcStr);
  docZip[Indice].procEvento.detEvento.tpAutor := ObterConteudoTag(ANode.Childrens.FindAnyNs('tpAutor'), tcInt);
  docZip[Indice].procEvento.detEvento.verAplic := ObterConteudoTag(ANode.Childrens.FindAnyNs('verAplic'), tcStr);

  LerGrupo_detEvento_CTe(ANode.Childrens.FindAnyNs('CTe'), Indice);
  LerGrupo_detEvento_emit(ANode.Childrens.FindAnyNs('emit'), Indice);
  LerGrupo_detEvento_itensAverbados(ANode.Childrens.FindAllAnyNs('itensAverbados'), Indice);
end;

procedure TRetDistDFeInt.LerGrupo_retEvento(const ANode: TACBrXmlNode;
  Indice: Integer);
var
  Ok: Boolean;
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('infEvento');

  if Assigned(AuxNode) then
  begin
    docZip[Indice].procEvento.RetinfEvento.Id := ObterConteudoTag(AuxNode.Attributes.Items['Id']);
    docZip[Indice].procEvento.RetinfEvento.tpAmb := StrToTpAmb(Ok, ObterConteudoTag(AuxNode.Childrens.FindAnyNs('tpAmb'), tcStr));
    docZip[Indice].procEvento.RetinfEvento.verAplic := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('verAplic'), tcStr);
    docZip[Indice].procEvento.RetinfEvento.cOrgao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('cOrgao'), tcInt);
    docZip[Indice].procEvento.RetinfEvento.cStat := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('cStat'), tcInt);
    docZip[Indice].procEvento.RetinfEvento.xMotivo := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('xMotivo'), tcStr);
    docZip[Indice].procEvento.RetinfEvento.chDFe := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('ch' + FptpDFe), tcStr);
    // � preciso identificar o DF-e para usar a fun��o de convers�o correta.
    docZip[Indice].procEvento.RetinfEvento.tpEvento := StrToTpEventoDFe(Ok, ObterConteudoTag(AuxNode.Childrens.FindAnyNs('tpEvento'), tcStr), FptpDFe);
    docZip[Indice].procEvento.RetinfEvento.xEvento := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('xEvento'), tcStr);
    docZip[Indice].procEvento.RetinfEvento.nSeqEvento := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nSeqEvento'), tcInt);
    docZip[Indice].procEvento.RetinfEvento.CNPJDest := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('CNPJDest'), tcStr);
    docZip[Indice].procEvento.RetinfEvento.dhRegEvento := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('dhRegEvento'), tcDatHor);
    docZip[Indice].procEvento.RetinfEvento.nProt := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nProt'), tcStr);
  end;
end;

procedure TRetDistDFeInt.LerEvento(const ANode: TACBrXmlNode; Indice: Integer);
var
  Ok: Boolean;
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) then Exit;

  docZip[Indice].XML := InserirDeclaracaoXMLSeNecessario(ANode.OuterXml);

  AuxNode := ANode.Childrens.FindAnyNs('infEvento');

  if Assigned(AuxNode) then
  begin
    docZip[Indice].procEvento.Id := ObterConteudoTag(AuxNode.Attributes.Items['Id']);
    docZip[Indice].procEvento.tpAmb := StrToTpAmb(Ok, ObterConteudoTag(AuxNode.Childrens.FindAnyNs('tpAmb'), tcStr));
    docZip[Indice].procEvento.CNPJ := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('CNPJ'), tcStr);

    if docZip[Indice].procEvento.CNPJ = '' then
      docZip[Indice].procEvento.CNPJ := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('CPF'), tcStr);

    docZip[Indice].procEvento.chDFe := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('ch' + FptpDFe), tcStr);
    docZip[Indice].procEvento.dhEvento := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('dhEvento'), tcDatHor);
    // � preciso identificar o DF-e para usar a fun��o de convers�o correta.
    docZip[Indice].procEvento.tpEvento := StrToTpEventoDFe(Ok, ObterConteudoTag(AuxNode.Childrens.FindAnyNs('tpEvento'), tcStr), FptpDFe);
    docZip[Indice].procEvento.nSeqEvento := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nSeqEvento'), tcInt);
    docZip[Indice].procEvento.verEvento := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('verEvento'), tcStr);
  end;
end;

procedure TRetDistDFeInt.LerDocumentoDecodificado(const DocDecod: AnsiString; Indice: Integer);
var
  Document: TACBrXmlDocument;
  ANode: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    XML := DocDecod;
    Document.LoadFromXml(DocDecod);

    ANode := Document.Root;

    if Assigned(ANode) then
    begin
      if ANode.Name = 'res' + FptpDFe then
        LerResumo(ANode, Indice);

      if ANode.Name = 'resEvento' then
        LerResumoEvento(ANode, Indice);

      if ANode.Name = LowerCase(FptpDFe) + 'Proc' then
        LerDocumento(ANode, Indice);

      if ANode.Name = LowerCase(FptpDFe) + 'OSProc' then
        LerDocumento(ANode, Indice);

      if ANode.Name = 'GTVeProc' then
        LerDocumento(ANode, Indice);

      if ANode.Name = 'procEvento' + FptpDFe then
      begin
        LerEvento(ANode.Childrens.FindAnyNs('evento'), Indice);
        LerEvento(ANode.Childrens.FindAnyNs('evento' + FptpDFe), Indice);

        LerGrupo_detEvento(ANode.Childrens.FindAnyNs('detEvento'), Indice);
        LerGrupo_retEvento(ANode.Childrens.FindAnyNs('retEvento'), Indice);
        LerGrupo_retEvento(ANode.Childrens.FindAnyNs('retEvento' + FptpDFe), Indice);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TRetDistDFeInt.LerLoteDistDFeInt(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  ANodes: TACBrXmlNodeArray;
  i: Integer;
  StrAux, StrDecod: AnsiString;
  xPath, xNomeArq: string;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('loteDistDFeInt');

  if Assigned(AuxNode) then
  begin
    ANodes := AuxNode.Childrens.FindAllAnyNs('docZip');

    docZip.Clear;

    for i := 0 to Length(ANodes) - 1 do
    begin
      docZip.New;

      docZip[i].NSU := ObterConteudoTag(ANodes[i].Attributes.Items['NSU']);
      docZip[i].schema := StrToSchemaDFe(ObterConteudoTag(ANodes[i].Attributes.Items['schema']));

      StrAux := ANodes[i].Content;
      docZip[i].InfZip := StrAux;
      StrDecod := UnZip(DecodeBase64(StrAux));

      LerDocumentoDecodificado(StrDecod, i);

      xPath := GerarPathDistribuicao(docZip[I]);
      xNomeArq := GerarNomeArquivo(docZip[I]);

      docZip[I].NomeArq := xPath + PathDelim + xNomeArq;
    end;
  end;
end;

function TRetDistDFeInt.LerXml: boolean;
var
  Ok: boolean;
  Document: TACBrXmlDocument;
  ANode: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      Result := False;

      if XmlRetorno = '' then Exit;

      XML := XmlRetorno;
      Document.LoadFromXml(XmlRetorno);

      ANode := Document.Root;

      if Assigned(ANode) then
      begin
        versao := ObterConteudoTag(ANode.Attributes.Items['versao']);
        tpAmb := StrToTpAmb(Ok, ObterConteudoTag(Anode.Childrens.FindAnyNs('tpAmb'), tcStr));
        verAplic := ObterConteudoTag(ANode.Childrens.FindAnyNs('verAplic'), tcStr);
        cStat := ObterConteudoTag(ANode.Childrens.FindAnyNs('cStat'), tcInt);
        xMotivo := ACBrStr(ObterConteudoTag(ANode.Childrens.FindAnyNs('xMotivo'), tcStr));
        dhResp := ObterConteudoTag(Anode.Childrens.FindAnyNs('dhResp'), tcDatHor);
        ultNSU := ACBrStr(ObterConteudoTag(ANode.Childrens.FindAnyNs('ultNSU'), tcStr));
        maxNSU := ACBrStr(ObterConteudoTag(ANode.Childrens.FindAnyNs('maxNSU'), tcStr));

        LerLoteDistDFeInt(ANode);
      end;

      Result := True;
    except
      Result := False;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

function TRetDistDFeInt.LerXMLFromFile(Const CaminhoArquivo: string;
  const AtpDFe: string): Boolean;
var
  ArqDist: TStringList;
  xml: string;
begin
  ArqDist := TStringList.Create;
  try
    FptpDFe := AtpDFe;

    ArqDist.LoadFromFile(CaminhoArquivo);

    XmlRetorno := ArqDist.Text;

    Result := LerXml;
  finally
    ArqDist.Free;
  end;
end;

function TRetDistDFeInt.GerarPathDistribuicao(
  AItem: TdocZipCollectionItem): string;
begin
  case AItem.schema of
    schresEvento:
      Result := FOwner.Configuracoes.Arquivos.GetPathDownloadEvento(AItem.resEvento.tpEvento,
                                                      AItem.resDFe.xNome,
                                                      AItem.resEvento.CNPJCPF,
                                                      AItem.resDFe.IE,
                                                      AItem.resEvento.dhEvento);

    schprocEventoNFe,
    schprocEventoCTe,
    schprocEventoMDFe:
      Result := FOwner.Configuracoes.Arquivos.GetPathDownloadEvento(AItem.procEvento.tpEvento,
                                                     AItem.resDFe.xNome,
                                                     AItem.procEvento.CNPJ,
                                                     AItem.resDFe.IE,
                                                     AItem.procEvento.dhEvento);

    schresNFe,
    schprocNFe,
    schprocCTe,
    schprocCTeOS,
    schprocGTVe,
    schprocMDFe:
      Result := FOwner.Configuracoes.Arquivos.GetPathDownload(AItem.resDFe.xNome,
                                                           AItem.resDFe.CNPJCPF,
                                                           AItem.resDFe.IE,
                                                           AItem.resDFe.dhEmi);
  end;
end;

function TRetDistDFeInt.GerarNomeArquivo(AItem: TdocZipCollectionItem): string;
begin
  case AItem.schema of
    schresNFe:
      Result := AItem.resDFe.chDFe + '-resNFe.xml';

    schresEvento:
      Result := OnlyNumber(TpEventoToStr(AItem.resEvento.tpEvento) +
                  AItem.resEvento.chDFe +
                  Format('%.2d', [AItem.resEvento.nSeqEvento])) +
                  '-resEventoNFe.xml';

    schprocNFe:
      Result := AItem.resDFe.chDFe + '-nfe.xml';

    schprocEventoNFe:
      Result := OnlyNumber(AItem.procEvento.Id) + '-procEventoNFe.xml';

    schprocCTe,
    schprocCTeOS,
    schprocGTVe:
      Result := AItem.resDFe.chDFe + '-cte.xml';

    schprocEventoCTe:
      Result := OnlyNumber(AItem.procEvento.Id) + '-procEventoCTe.xml';

    schprocMDFe:
      Result := AItem.resDFe.chDFe + '-mdfe.xml';

    schprocEventoMDFe:
      Result := OnlyNumber(AItem.procEvento.Id) + '-procEventoMDFe.xml';
  end;
end;

end.

