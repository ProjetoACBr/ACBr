{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Leivio Ramos de Fontenele                       }
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

unit pcnReinfR2099;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  pcnConversao, pcnGerador, ACBrUtil.FilesIO,
  pcnCommonReinf, pcnConversaoReinf, pcnGeradorReinf;

type
  {Classes espec�ficas deste evento}

  { TinfoFech }

  TinfoFech = class(TObject)
  private
    FevtServTm: TtpSimNao;
    FevtServPr: TtpSimNao;
    FevtAssDespRec: TtpSimNao;
    FevtAssDespRep: TtpSimNao;
    FevtComProd: TtpSimNao;
    FevtCPRB: TtpSimNao;
    FevtPgtos: TtpSimNao;
    FcompSemMovto: string;
    FevtAquis: TtpSimNao;
  public
    property evtServTm: TtpSimNao read FevtServTm write FevtServTm;
    property evtServPr: TtpSimNao read FevtServPr write FevtServPr;
    property evtAssDespRec: TtpSimNao read FevtAssDespRec write FevtAssDespRec;
    property evtAssDespRep: TtpSimNao read FevtAssDespRep write FevtAssDespRep;
    property evtComProd: TtpSimNao read FevtComProd write FevtComProd;
    property evtCPRB: TtpSimNao read FevtCPRB write FevtCPRB;
    property evtAquis: TtpSimNao read FevtAquis write FevtAquis;
    property evtPgtos: TtpSimNao read FevtPgtos write FevtPgtos;
    property compSemMovto: string read FcompSemMovto write FcompSemMovto;
  end;

  { TideRespInf }

  TideRespInf = class(TObject)
  private
    FnmResp: string;
    FcpfResp: string;
    Ftelefone: string;
    Femail: string;
  public
    property nmResp: string read FnmResp write FnmResp;
    property cpfResp: string read FcpfResp write FcpfResp;
    property telefone: string read Ftelefone write Ftelefone;
    property email: string read Femail write Femail;
  end;

  TevtFechaEvPer = class(TReinfEvento) //Classe do elemento principal do XML do evento!
  private
    FIdeEvento: TIdeEvento2;
    FideContri: TideContri;
    FideRespInf: TideRespInf;
    FinfoFech: TinfoFech;

    {Geradores espec�ficos desta classe}
    procedure GerarideRespInf;
    procedure GerarinfoFech;
  public
    constructor Create(AACBrReinf: TObject); override;
    destructor  Destroy; override;

    function GerarXML: Boolean; overload;
    function LerArqIni(const AIniString: String): Boolean;

    property ideEvento: TIdeEvento2 read FIdeEvento write FIdeEvento;
    property ideContri: TideContri read FideContri write FideContri;
    property ideRespInf: TideRespInf read FideRespInf write FideRespInf;
    property infoFech: TinfoFech read FinfoFech write FinfoFech;
  end;

  TR2099CollectionItem = class(TObject)
  private
    FTipoEvento: TTipoEvento;
    FevtFechaEvPer: TevtFechaEvPer;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    property TipoEvento: TTipoEvento read FTipoEvento;
    property evtFechaEvPer: TevtFechaEvPer read FevtFechaEvPer write FevtFechaEvPer;
  end;

  TR2099Collection = class(TReinfCollection)
  private
    function GetItem(Index: Integer): TR2099CollectionItem;
    procedure SetItem(Index: Integer; Value: TR2099CollectionItem);
  public
    function Add: TR2099CollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TR2099CollectionItem;

    property Items[Index: Integer]: TR2099CollectionItem read GetItem write SetItem; default;
  end;

implementation

uses
  IniFiles,
  ACBrReinf, ACBrDFeUtil;

{ TR2099Collection }

function TR2099Collection.Add: TR2099CollectionItem;
begin
  Result := Self.New;
end;

function TR2099Collection.GetItem(Index: Integer): TR2099CollectionItem;
begin
  Result := TR2099CollectionItem(inherited Items[Index]);
end;

function TR2099Collection.New: TR2099CollectionItem;
begin
  Result := TR2099CollectionItem.Create(FACBrReinf);
  Self.Add(Result);
end;

procedure TR2099Collection.SetItem(Index: Integer; Value: TR2099CollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TR2099CollectionItem }

constructor TR2099CollectionItem.Create(AOwner: TComponent);
begin
  inherited Create;

  FTipoEvento    := teR2099;
  FevtFechaEvPer := TevtFechaEvPer.Create(AOwner);
end;

destructor TR2099CollectionItem.Destroy;
begin
  inherited;

  FevtFechaEvPer.Free;
end;

{ TevtFechaEvPer }

constructor TevtFechaEvPer.Create(AACBrReinf: TObject);
begin
  inherited Create(AACBrReinf);

  FideContri  := TideContri.create;
  FIdeEvento  := TIdeEvento2.create;
  FideRespInf := TideRespInf.Create;
  FinfoFech   := TinfoFech.Create;
end;

destructor TevtFechaEvPer.Destroy;
begin
  FideContri.Free;
  FIdeEvento.Free;
  FideRespInf.Free;
  FinfoFech.Free;

  inherited;
end;

procedure TevtFechaEvPer.GerarideRespInf;
begin
  if (FideRespInf.nmResp <> EmptyStr) and (FideRespInf.cpfResp <> EmptyStr) then
  begin
    Gerador.wGrupo('ideRespInf');

    Gerador.wCampo(tcStr, '', 'nmResp',    1, 70, 1, FideRespInf.nmResp);
    Gerador.wCampo(tcStr, '', 'cpfResp',  11, 11, 1, FideRespInf.cpfResp);
    Gerador.wCampo(tcStr, '', 'telefone',  1, 13, 0, FideRespInf.telefone);
    Gerador.wCampo(tcStr, '', 'email',     1, 60, 0, FideRespInf.email);

    Gerador.wGrupo('/ideRespInf');
  end;
end;

procedure TevtFechaEvPer.GerarinfoFech;
begin
  Gerador.wGrupo('infoFech');

  Gerador.wCampo(tcStr, '', 'evtServTm',     1, 1, 1, SimNaoToStr(FinfoFech.evtServTm));
  Gerador.wCampo(tcStr, '', 'evtServPr',     1, 1, 1, SimNaoToStr(FinfoFech.evtServPr));
  Gerador.wCampo(tcStr, '', 'evtAssDespRec', 1, 1, 1, SimNaoToStr(FinfoFech.evtAssDespRec));
  Gerador.wCampo(tcStr, '', 'evtAssDespRep', 1, 1, 1, SimNaoToStr(FinfoFech.evtAssDespRep));
  Gerador.wCampo(tcStr, '', 'evtComProd',    1, 1, 1, SimNaoToStr(FinfoFech.evtComProd));
  Gerador.wCampo(tcStr, '', 'evtCPRB',       1, 1, 1, SimNaoToStr(FinfoFech.evtCPRB));
  if VersaoDF >= v1_05_00 then
     Gerador.wCampo(tcStr, '', 'evtAquis',      1, 1, 1, SimNaoToStr(FinfoFech.evtAquis));

  // Exclu�dos na Vers�o 2.01
  if ((FIdeEvento.perApur <= '2018-10') and (VersaoDF <= v1_05_00)) then
  begin
    Gerador.wCampo(tcStr, '', 'evtPgtos',     1, 1, 1, SimNaoToStr(FinfoFech.evtPgtos));
    Gerador.wCampo(tcStr, '', 'compSemMovto', 1, 7, 0, FinfoFech.compSemMovto);
  end;

  Gerador.wGrupo('/infoFech');
end;

function TevtFechaEvPer.GerarXML: Boolean;
begin
  inherited GerarXML;

  try
    Self.Id := GerarChaveReinf(now, self.ideContri.NrInsc, self.Sequencial, self.ideContri.TpInsc);

    GerarCabecalho('evtFechamento');
    Gerador.wGrupo('evtFechaEvPer id="' + Self.Id + '"');

    GerarIdeEvento2(Self.IdeEvento, True, False);
    GerarideContri(Self.ideContri);

    GerarideRespInf;
    GerarinfoFech;

    Gerador.wGrupo('/evtFechaEvPer');

    GerarRodape;

    FXML := Gerador.ArquivoFormatoXML;
//    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtFechaEvPer');

//    Validar(schevtFechamento);
  except on e:exception do
    raise Exception.Create('ID: ' + Self.Id + sLineBreak + ' ' + e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '');
end;

function TevtFechaEvPer.LerArqIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  Ok: Boolean;
  sSecao: String;
begin
  Self.VersaoDF := TACBrReinf(FACBrReinf).Configuracoes.Geral.VersaoDF;

  Result := True;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    with Self do
    begin
      sSecao := 'evtFechaEvPer';
      Id         := INIRec.ReadString(sSecao, 'Id', '');
      Sequencial := INIRec.ReadInteger(sSecao, 'Sequencial', 0);

      sSecao := 'ideEvento';
      ideEvento.perApur := INIRec.ReadString(sSecao, 'perApur', EmptyStr);
      ideEvento.ProcEmi := StrToProcEmiReinf(Ok, INIRec.ReadString(sSecao, 'procEmi', '1'));
      ideEvento.VerProc := INIRec.ReadString(sSecao, 'verProc', EmptyStr);

      sSecao := 'ideContri';
      ideContri.OrgaoPublico := (TACBrReinf(FACBrReinf).Configuracoes.Geral.TipoContribuinte = tcOrgaoPublico);
      ideContri.TpInsc       := StrToTpInscricao(Ok, INIRec.ReadString(sSecao, 'tpInsc', '1'));
      ideContri.NrInsc       := INIRec.ReadString(sSecao, 'nrInsc', EmptyStr);

      sSecao := 'ideRespInf';
      if INIRec.ReadString(sSecao, 'nmResp', EmptyStr) <> '' then
      begin
        ideRespInf.nmResp   := INIRec.ReadString(sSecao, 'nmResp', EmptyStr);
        ideRespInf.cpfResp  := INIRec.ReadString(sSecao, 'cpfResp', EmptyStr);
        ideRespInf.telefone := INIRec.ReadString(sSecao, 'telefone', EmptyStr);
        ideRespInf.email    := INIRec.ReadString(sSecao, 'email', EmptyStr);
      end;

      sSecao := 'infoFech';
      infoFech.evtServTm     := StrToSimNao(Ok, INIRec.ReadString(sSecao, 'evtServTm', 'N'));
      infoFech.evtServPr     := StrToSimNao(Ok, INIRec.ReadString(sSecao, 'evtServPr', 'N'));
      infoFech.evtAssDespRec := StrToSimNao(Ok, INIRec.ReadString(sSecao, 'evtAssDespRec', 'N'));
      infoFech.evtAssDespRep := StrToSimNao(Ok, INIRec.ReadString(sSecao, 'evtAssDespRep', 'N'));
      infoFech.evtComProd    := StrToSimNao(Ok, INIRec.ReadString(sSecao, 'evtComProd', 'N'));
      infoFech.evtCPRB       := StrToSimNao(Ok, INIRec.ReadString(sSecao, 'evtCPRB', 'N'));
      if VersaoDF >= v1_05_00 then
         infoFech.evtAquis      := StrToSimNao(Ok, INIRec.ReadString(sSecao, 'evtAquis', 'N'));
      infoFech.evtPgtos      := StrToSimNao(Ok, INIRec.ReadString(sSecao, 'evtPgtos', 'N'));
      infoFech.compSemMovto  := INIRec.ReadString(sSecao, 'compSemMovto', EmptyStr);
    end;

    GerarXML;
    XML := FXML;
  finally
    INIRec.Free;
  end;
end;

end.
