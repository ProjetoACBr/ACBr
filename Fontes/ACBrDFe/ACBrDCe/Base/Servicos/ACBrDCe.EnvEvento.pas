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

unit ACBrDCe.EnvEvento;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  ACBrDFeConsts,
  pcnConversao,
  pcnSignature,
  ACBrDCe.Consts,
  ACBrDCe.EventoClass,
  ACBrBase,
  ACBrXmlBase,
  ACBrXmlWriter,
  ACBrXmlDocument;

type
  TInfEventoCollectionItem = class(TObject)
  private
    FInfEvento: TInfEvento;
    Fsignature: Tsignature;
    FRetInfEvento: TRetInfEvento;
    FXML: string;
  public
    constructor Create;
    destructor Destroy; override;

    property InfEvento: TInfEvento       read FInfEvento    write FInfEvento;
    property signature: Tsignature       read Fsignature    write Fsignature;
    property RetInfEvento: TRetInfEvento read FRetInfEvento write FRetInfEvento;
    property XML: string                 read FXML          write FXML;
  end;

  TInfEventoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfEventoCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfEventoCollectionItem);
  public
    function Add: TInfEventoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New.'{$EndIf};
    function New: TInfEventoCollectionItem;
    property Items[Index: Integer]: TInfEventoCollectionItem read GetItem write SetItem; default;
  end;

  { TEventoDCe }

  TEventoDCe = class(TACBrXmlWriter)
  private
    FidLote: Int64;
    FEvento: TInfEventoCollection;
    FVersao: string;
    FXmlEnvio: string;

    procedure SetEvento(const Value: TInfEventoCollection);

    function GetOpcoes: TACBrXmlWriterOptions;
    procedure SetOpcoes(const Value: TACBrXmlWriterOptions);
  protected
    function CreateOptions: TACBrXmlWriterOptions; override;

    function Gerar_InfEvento(Idx: Integer): TACBrXmlNode;
    function Gerar_DetEvento(Idx: Integer): TACBrXmlNode;
    function Gerar_Evento_Cancelamento(Idx: Integer): TACBrXmlNode;

  public
    constructor Create;
    destructor Destroy; override;

    function GerarXml: Boolean; Override;

    function LerXML(const CaminhoArquivo: string): Boolean;
    function LerXMLFromString(const AXML: string): Boolean;
    function ObterNomeArquivo(tpEvento: TpcnTpEvento): string;
    function LerFromIni(const AIniString: string): Boolean;

    property idLote: Int64                read FidLote  write FidLote;
    property Evento: TInfEventoCollection read FEvento  write SetEvento;
    property Versao: string               read FVersao  write FVersao;

    property Opcoes: TACBrXmlWriterOptions read GetOpcoes write SetOpcoes;

    property XmlEnvio: string read FXmlEnvio write FXmlEnvio;
  end;

implementation

uses
  IniFiles,
  ACBrDFeUtil,
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.DateTime, ACBrUtil.FilesIO,
  ACBrDCe.RetEnvEvento,
  ACBrDCe.Conversao;

{ TEventoDCe }

constructor TEventoDCe.Create;
begin
  inherited Create;

  FEvento  := TInfEventoCollection.Create();
end;

function TEventoDCe.CreateOptions: TACBrXmlWriterOptions;
begin
  Result := TACBrXmlWriterOptions.Create();
end;

destructor TEventoDCe.Destroy;
begin
  FEvento.Free;

  inherited;
end;

function TEventoDCe.ObterNomeArquivo(tpEvento: TpcnTpEvento): string;
begin
  case tpEvento of
    teCancelamento: Result := IntToStr(Self.idLote) + '-can-eve.xml';
  else
    raise EventoException.Create('Obter nome do arquivo de Evento n�o Implementado!');
  end;
end;

function TEventoDCe.GerarXML: Boolean;
var
  EventoNode: TACBrXmlNode;
begin
  ListaDeAlertas.Clear;

  FDocument.Clear();

  EventoNode := CreateElement('eventoDCe');
  EventoNode.SetNamespace('http://www.portalfiscal.inf.br/dce');
  EventoNode.SetAttribute('versao', Versao);

  FDocument.Root := EventoNode;


  EventoNode.AppendChild(Gerar_InfEvento(0));

  // Incluir a assinatura no XML
  if Evento[0].signature.URI <> '' then
    EventoNode.AppendChild(GerarSignature(Evento[0].signature));

  Result := True;
  XmlEnvio := ChangeLineBreak(Document.Xml, '');
end;

function TEventoDCe.Gerar_Evento_Cancelamento(Idx: Integer): TACBrXmlNode;
begin
  Result := CreateElement('evCancDCe');

  Result.AppendChild(AddNode(tcStr, 'EP02', 'descEvento', 4, 60, 1,
                                            Evento[Idx].FInfEvento.DescEvento));

  Result.AppendChild(AddNode(tcStr, 'EP03', 'nProt', 15, 15, 1,
                                       Evento[Idx].FInfEvento.detEvento.nProt));

  Result.AppendChild(AddNode(tcStr, 'EP04', 'xJust', 15, 255, 1,
                                       Evento[Idx].FInfEvento.detEvento.xJust));

end;

function TEventoDCe.Gerar_DetEvento(Idx: Integer): TACBrXmlNode;
begin
  Result := CreateElement('detEvento');
  Result.SetAttribute('versaoEvento', Versao);

  case Evento[Idx].InfEvento.tpEvento of
    teCancelamento: Result.AppendChild(Gerar_Evento_Cancelamento(Idx));
  end;
end;

function TEventoDCe.Gerar_InfEvento(Idx: Integer): TACBrXmlNode;
var
  sDoc: string;
begin
  Evento[Idx].InfEvento.id := 'ID' + Evento[Idx].InfEvento.TipoEvento +
                             OnlyNumber(Evento[Idx].InfEvento.chDCe) +
                             Format('%.3d', [Evento[Idx].InfEvento.nSeqEvento]);

  if Length(Evento[Idx].InfEvento.id) < 54 then
    wAlerta('P04', 'ID', '', 'ID de Evento inv�lido');

  Result := CreateElement('infEvento');
  Result.SetAttribute('Id', Evento[Idx].InfEvento.id);

  Result.AppendChild(AddNode(tcInt, 'P05', 'cOrgao', 1, 2, 1,
                                                Evento[Idx].FInfEvento.cOrgao));

  Result.AppendChild(AddNode(tcStr, 'P06', 'tpAmb', 1, 1, 1,
                    TipoAmbienteToStr(Evento[Idx].InfEvento.tpAmb), DSC_TPAMB));

(*
  { Segundo o Schema}
  sDoc := OnlyNumber(Evento[Idx].InfEvento.CNPJCPF);

  if EstaVazio(sDoc) then
    sDoc := ExtrairCNPJCPFChaveAcesso(Evento[Idx].InfEvento.chDCe);

  // Verifica a S�rie do Documento, caso esteja no intervalo de 910-969
  // o emitente � pessoa fisica, logo na chave temos um CPF.
  Serie := ExtrairSerieChaveAcesso(Evento[Idx].InfEvento.chDCe);

  if (Length(sDoc) = 14) and (Serie >= 910) and (Serie <= 969) then
  begin
    sDoc := Copy(sDoc, 4, 11);
  end;

  if Length(sDoc) = 14 then
  begin
    Result.AppendChild(AddNode(tcStr, 'HP10', 'CNPJ', 14, 14, 1,
                                                              sDoc , DSC_CNPJ));

    if not ValidarCNPJ(sDoc) then
      wAlerta('HP10', 'CNPJ', DSC_CNPJ, ERR_MSG_INVALIDO);
  end
  else
  begin
    Result.AppendChild(AddNode(tcStr, 'HP11', 'CPF', 11, 11, 1,
                                                               sDoc , DSC_CPF));

    if not ValidarCPF(sDoc) then
      wAlerta('HP11', 'CPF', DSC_CPF, ERR_MSG_INVALIDO);
  end;
*)
  Result.AppendChild(AddNode(tcStr, 'P06a', 'tpEmit', 1, 1, 1,
                    EmitenteDCeToStr(Evento[Idx].InfEvento.tpEmit), DSC_TPEMIT));

  { Segundo o Manual }
  sDoc := OnlyNumber(Evento[Idx].InfEvento.CNPJCPF);

  if EstaVazio(sDoc) then
    sDoc := ExtrairCNPJCPFChaveAcesso(Evento[Idx].InfEvento.chDCe);

  Result.AppendChild(AddNode(tcStr, 'HP10', 'CNPJAutor', 14, 14, 1,
                                                              sDoc , DSC_CNPJ));

  if not ValidarCNPJ(sDoc) then
    wAlerta('HP10', 'CNPJAutor', DSC_CNPJ, ERR_MSG_INVALIDO);

  sDoc := OnlyNumber(Evento[Idx].InfEvento.IdOutrosEmit);

  if EstaVazio(sDoc) then
  begin
    sDoc := OnlyNumber(Evento[Idx].InfEvento.CNPJCPFEmit);

    if Length(sDoc) = 14 then
    begin
      Result.AppendChild(AddNode(tcStr, 'HP10', 'CNPJUsEmit', 14, 14, 1,
                                                              sDoc , DSC_CNPJ));

      if not ValidarCNPJ(sDoc) then
        wAlerta('HP10', 'CNPJUsEmit', DSC_CNPJ, ERR_MSG_INVALIDO);
    end
    else
    begin
      Result.AppendChild(AddNode(tcStr, 'HP11', 'CPFUsEmit', 11, 11, 1,
                                                               sDoc , DSC_CPF));

      if not ValidarCPF(sDoc) then
        wAlerta('HP11', 'CPFUsEmit', DSC_CPF, ERR_MSG_INVALIDO);
    end;
  end
  else
    Result.AppendChild(AddNode(tcStr, 'HP11', 'IdOutrosUsEmit', 2, 60, 1,
                                                          sDoc, DSC_IDOUTROS));

  Result.AppendChild(AddNode(tcStr, 'HP12', 'chDCe', 44, 44, 1,
                                      Evento[Idx].FInfEvento.chDCe, DSC_CHAVE));

  if not ValidarChave(Evento[Idx].InfEvento.chDCe) then
    wAlerta('HP12', 'chDCe', '', 'Chave de DCe inv�lida');

  Result.AppendChild(AddNode(tcStr, 'HP13', 'dhEvento', 1, 50, 1,
    FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', Evento[Idx].InfEvento.dhEvento)+
    GetUTC(CodigoUFparaUF(Evento[Idx].InfEvento.cOrgao),
    Evento[Idx].InfEvento.dhEvento)));

  Result.AppendChild(AddNode(tcInt, 'HP14', 'tpEvento', 6, 6, 1,
                                            Evento[Idx].FInfEvento.TipoEvento));

  Result.AppendChild(AddNode(tcInt, 'HP15', 'nSeqEvento', 1, 3, 1,
                                            Evento[Idx].FInfEvento.nSeqEvento));

//  Result.AppendChild(AddNode(tcStr, 'HP16', 'verEvento', 1, 4, 1, Versao));

  Result.AppendChild(Gerar_DetEvento(Idx));
end;

function TEventoDCe.GetOpcoes: TACBrXmlWriterOptions;
begin
  Result := TACBrXmlWriterOptions(FOpcoes);
end;

procedure TEventoDCe.SetEvento(const Value: TInfEventoCollection);
begin
  FEvento.Assign(Value);
end;

procedure TEventoDCe.SetOpcoes(const Value: TACBrXmlWriterOptions);
begin
  FOpcoes := Value;
end;

function TEventoDCe.LerXML(const CaminhoArquivo: string): Boolean;
var
  ArqEvento: TStringList;
begin
  ArqEvento := TStringList.Create;

  try
    ArqEvento.LoadFromFile(CaminhoArquivo);
    Result := LerXMLFromString(ArqEvento.Text);
  finally
    ArqEvento.Free;
  end;
end;

function TEventoDCe.LerXMLFromString(const AXML: string): Boolean;
var
  RetEventoDCe: TRetEventoDCe;
begin
  RetEventoDCe := TRetEventoDCe.Create;

  try
    RetEventoDCe.XmlRetorno := AXML;
    Result := RetEventoDCe.LerXml;

    with FEvento.New do
    begin
      XML := AXML;

      infEvento.ID := RetEventoDCe.InfEvento.id;
      infEvento.cOrgao := RetEventoDCe.InfEvento.cOrgao;
      infEvento.tpAmb := RetEventoDCe.InfEvento.tpAmb;
      infEvento.tpEmit := RetEventoDCe.InfEvento.tpEmit;
      infEvento.CNPJCPF := RetEventoDCe.InfEvento.CNPJCPF;
      infEvento.CNPJCPFEmit := RetEventoDCe.InfEvento.CNPJCPFEmit;
      infEvento.IdOutrosEmit := RetEventoDCe.InfEvento.IdOutrosEmit;
      infEvento.chDCe := RetEventoDCe.InfEvento.chDCe;
      infEvento.dhEvento := RetEventoDCe.InfEvento.dhEvento;
      infEvento.tpEvento := RetEventoDCe.InfEvento.tpEvento;
      infEvento.nSeqEvento := RetEventoDCe.InfEvento.nSeqEvento;

       infEvento.DetEvento.descEvento := RetEventoDCe.InfEvento.DetEvento.descEvento;
      infEvento.DetEvento.nProt := RetEventoDCe.InfEvento.DetEvento.nProt;
      infEvento.DetEvento.xJust := RetEventoDCe.InfEvento.DetEvento.xJust;

      signature.URI := RetEventoDCe.signature.URI;
      signature.DigestValue := RetEventoDCe.signature.DigestValue;
      signature.SignatureValue := RetEventoDCe.signature.SignatureValue;
      signature.X509Certificate := RetEventoDCe.signature.X509Certificate;

      if RetEventoDCe.retInfEvento.Count > 0 then
      begin
        RetInfEvento.Id := RetEventoDCe.retInfEvento[0].RetInfEvento.Id;
        RetInfEvento.tpAmb := RetEventoDCe.retInfEvento[0].RetInfEvento.tpAmb;
        RetInfEvento.verAplic := RetEventoDCe.retInfEvento[0].RetInfEvento.verAplic;
        RetInfEvento.cOrgao := RetEventoDCe.retInfEvento[0].RetInfEvento.cOrgao;
        RetInfEvento.cStat := RetEventoDCe.retInfEvento[0].RetInfEvento.cStat;
        RetInfEvento.xMotivo := RetEventoDCe.retInfEvento[0].RetInfEvento.xMotivo;
        RetInfEvento.chDCe := RetEventoDCe.retInfEvento[0].RetInfEvento.chDCe;
        RetInfEvento.tpEvento := RetEventoDCe.retInfEvento[0].RetInfEvento.tpEvento;
        RetInfEvento.xEvento := RetEventoDCe.retInfEvento[0].RetInfEvento.xEvento;
        RetInfEvento.nSeqEvento := RetEventoDCe.retInfEvento[0].RetInfEvento.nSeqEvento;
        RetInfEvento.dhRegEvento := RetEventoDCe.retInfEvento[0].RetInfEvento.dhRegEvento;
        RetInfEvento.nProt := RetEventoDCe.retInfEvento[0].RetInfEvento.nProt;
        RetInfEvento.XML := RetEventoDCe.retInfEvento[0].RetInfEvento.XML;
      end;
    end;
  finally
    RetEventoDCe.Free;
  end;
end;

function TEventoDCe.LerFromIni(const AIniString: string): Boolean;
var
  I: Integer;
  sSecao, sFim: string;
  INIRec: TMemIniFile;
begin
{$IFNDEF COMPILER23_UP}
  Result := False;
{$ENDIF}
  Self.Evento.Clear;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);
    idLote := INIRec.ReadInteger( 'EVENTO', 'idLote', 0);

    I := 1;
    while true do
    begin
      sSecao := 'EVENTO' + IntToStrZero(I, 3);
      sFim := INIRec.ReadString(sSecao, 'chNFe', 'FIM');
      if (sFim = 'FIM') or (Length(sFim) <= 0) then
        break ;

      with Self.Evento.New do
      begin
        infEvento.cOrgao := INIRec.ReadInteger(sSecao, 'cOrgao', 0);
        {
        infEvento.CNPJ   := INIRec.ReadString(sSecao, 'CNPJ', '');
        infEvento.chNFe  := sFim;
        infEvento.dhEvento := StringToDateTime(INIRec.ReadString(sSecao, 'dhEvento', ''));
        infEvento.tpEvento := StrToTpEventoNFe(ok,INIRec.ReadString(sSecao, 'tpEvento', ''));

        infEvento.nSeqEvento := INIRec.ReadInteger(sSecao, 'nSeqEvento', 1);
        infEvento.versaoEvento := INIRec.ReadString(sSecao, 'versaoEvento', '1.00');
        infEvento.detEvento.cOrgaoAutor := INIRec.ReadInteger(sSecao, 'cOrgaoAutor', 0);
        infEvento.detEvento.verAplic := INIRec.ReadString(sSecao, 'verAplic', '1.0');

        infEvento.detEvento.xCorrecao := INIRec.ReadString(sSecao, 'xCorrecao', '');
        infEvento.detEvento.xCondUso := INIRec.ReadString(sSecao, 'xCondUso', '');
        infEvento.detEvento.nProt := INIRec.ReadString(sSecao, 'nProt', '');
        infEvento.detEvento.xJust := INIRec.ReadString(sSecao, 'xJust', '');
        infEvento.detEvento.chNFeRef := INIRec.ReadString(sSecao, 'chNFeRef', '');
        infEvento.detEvento.nProtEvento := INIRec.ReadString(sSecao, 'nProtEvento', '');
        }
      end;

      Inc(I);
    end;

    Result := True;
  finally
    INIRec.Free;
  end;
end;

{ TInfEventoCollection }

function TInfEventoCollection.Add: TInfEventoCollectionItem;
begin
  Result := Self.New;
end;

function TInfEventoCollection.GetItem(
  Index: Integer): TInfEventoCollectionItem;
begin
  Result := TInfEventoCollectionItem(inherited Items[Index]);
end;

procedure TInfEventoCollection.SetItem(Index: Integer;
  Value: TInfEventoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfEventoCollection.New: TInfEventoCollectionItem;
begin
  Result := TInfEventoCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfEventoCollectionItem }

constructor TInfEventoCollectionItem.Create;
begin
  inherited Create;

  FInfEvento := TInfEvento.Create;
  Fsignature := Tsignature.Create;
  FRetInfEvento := TRetInfEvento.Create;
end;

destructor TInfEventoCollectionItem.Destroy;
begin
  FInfEvento.Free;
  fsignature.Free;
  FRetInfEvento.Free;

  inherited;
end;

end.

