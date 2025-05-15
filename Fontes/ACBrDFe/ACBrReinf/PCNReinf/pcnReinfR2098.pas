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

unit pcnReinfR2098;

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

  TevtReabreEvPer = class(TReinfEvento) //Classe do elemento principal do XML do evento!
  private
    FIdeEvento: TIdeEvento2;
    FideContri: TideContri;

  public
    constructor Create(AACBrReinf: TObject); override;
    destructor  Destroy; override;

    function GerarXML: Boolean; overload;
    function LerArqIni(const AIniString: String): Boolean;

    property ideEvento: TIdeEvento2 read FIdeEvento write FIdeEvento;
    property ideContri: TideContri read FideContri write FideContri;
  end;

  TR2098CollectionItem = class(TObject)
  private
    FTipoEvento: TTipoEvento;
    FevtReabreEvPer: TevtReabreEvPer;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    property TipoEvento: TTipoEvento read FTipoEvento;
    property evtReabreEvPer: TevtReabreEvPer read FevtReabreEvPer write FevtReabreEvPer;
  end;

  TR2098Collection = class(TReinfCollection)
  private
    function GetItem(Index: Integer): TR2098CollectionItem;
    procedure SetItem(Index: Integer; Value: TR2098CollectionItem);
  public
    function Add: TR2098CollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TR2098CollectionItem;

    property Items[Index: Integer]: TR2098CollectionItem read GetItem write SetItem; default;
  end;

implementation

uses
  IniFiles,
  ACBrReinf, ACBrDFeUtil;

{ TR2098Collection }

function TR2098Collection.Add: TR2098CollectionItem;
begin
  Result := Self.New;
end;

function TR2098Collection.GetItem(Index: Integer): TR2098CollectionItem;
begin
  Result := TR2098CollectionItem(inherited Items[Index]);
end;

function TR2098Collection.New: TR2098CollectionItem;
begin
  Result := TR2098CollectionItem.Create(FACBrReinf);
  Self.Add(Result);
end;

procedure TR2098Collection.SetItem(Index: Integer; Value: TR2098CollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TR2098CollectionItem }

constructor TR2098CollectionItem.Create(AOwner: TComponent);
begin
  inherited Create;

  FTipoEvento     := teR2098;
  FevtReabreEvPer := TevtReabreEvPer.Create(AOwner);
end;

destructor TR2098CollectionItem.Destroy;
begin
  inherited;

  FevtReabreEvPer.Free;
end;

{ TevtReabreEvPer }

constructor TevtReabreEvPer.Create(AACBrReinf: TObject);
begin
  inherited Create(AACBrReinf);

  FideContri := TideContri.create;
  FIdeEvento := TIdeEvento2.create;
end;

destructor TevtReabreEvPer.Destroy;
begin
  FideContri.Free;
  FIdeEvento.Free;

  inherited;
end;

function TevtReabreEvPer.GerarXML: Boolean;
begin
  inherited GerarXML;

  try
    Self.Id := GerarChaveReinf(now, self.ideContri.NrInsc, self.Sequencial, self.ideContri.TpInsc);

    GerarCabecalho('evtReabreEvPer');
    Gerador.wGrupo('evtReabreEvPer id="' + Self.Id + '"');

    GerarIdeEvento2(Self.IdeEvento, True, False);
    GerarideContri(Self.ideContri);

    Gerador.wGrupo('/evtReabreEvPer');

    GerarRodape;

    FXML := Gerador.ArquivoFormatoXML;
//    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtReabreEvPer');

//    Validar(schevtReabreEvPer);
  except on e:exception do
    raise Exception.Create('ID: ' + Self.Id + sLineBreak + ' ' + e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '');
end;

function TevtReabreEvPer.LerArqIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  Ok: Boolean;
  sSecao: String;
begin
  Result := True;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    with Self do
    begin
      sSecao := 'evtReabreEvPer';
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
    end;

    GerarXML;
    XML := FXML;
  finally
    INIRec.Free;
  end;
end;

end.
