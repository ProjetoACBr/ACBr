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

unit ACBrBPeClass;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$Else}
   Contnrs,
  {$IfEnd}
  ACBrBase,
  ACBrXmlBase,
//  ACBrDFeConversao,
  ACBrBPeConversao,
  ACBrDFeComum.Proc,
//  ACBrDFeComum.Signature,
  pcnSignature;

type

  TBPe = class;
  TInfBPe = class;
  TIde = class;

  TEmit = class;
  TenderEmit = class;

  TComp = class;
  TenderComp = class;

  TAgencia = class;

  TInfBPeSub = class;
  TInfPassagem = class;
  TInfPassageiro = class;

  TInfViagemCollection = class;
  TInfViagemCollectionItem = class;
  TinfTravessia = class;

  TinfValorBPe = class;
  TCompCollection = class;
  TCompCollectionItem = class;

  TImp = class;
  TICMS = class;
  TICMSUFFim = class;

  TpagCollection = class;
  TpagCollectionItem = class;

  TautXMLCollection     = class;
  TautXMLCollectionItem = class;

  TInfAdic = class;
  TinfBPeSupl = class;

  {======== Inicio das Classes da Reforma Tribut�ria }
  { TgDif }

  TgDif = class(TObject)
  private
    FpDif: Double;
    FvDif: Double;
  public
    property pDif: Double read FpDif write FpDif;
    property vDif: Double read FvDif write FvDif;
  end;

  { TgDevTrib }

  TgDevTrib = class(TObject)
  private
    FvDevTrib: Double;
  public
    property vDevTrib: Double read FvDevTrib write FvDevTrib;
  end;

  { TgRed }

  TgRed = class(TObject)
  private
    FpRedAliq: Double;
    FpAliqEfet: Double;
  public
    property pRedAliq: Double read FpRedAliq write FpRedAliq;
    property pAliqEfet: Double read FpAliqEfet write FpAliqEfet;
  end;

  { TgDesonIBS }

  TgDesonIBS = class(TObject)
  private
//italo    FCST: Integer;
    FcClassTrib: Integer;
    FvBC: Double;
    FpAliq: Double;
    FvDeson: Double;
    FvIBS: Double;
  public
//italo    property CST: Integer read FCST write FCST;
    property cClassTrib: Integer read FcClassTrib write FcClassTrib;
    property vBC: Double read FvBC write FvBC;
    property pAliq: Double read FpAliq write FpAliq;
    property vDeson: Double read FvDeson write FvDeson;
    property vIBS: Double read FvIBS write FvIBS;
  end;

  { TgDesonCBS }

  TgDesonCBS = class(TObject)
  private
//italo    FCST: Integer;
    FcClassTrib: Integer;
    FvBC: Double;
    FpAliq: Double;
    FvDeson: Double;
    FvCBS: Double;
  public
//italo    property CST: Integer read FCST write FCST;
    property cClassTrib: Integer read FcClassTrib write FcClassTrib;
    property vBC: Double read FvBC write FvBC;
    property pAliq: Double read FpAliq write FpAliq;
    property vDeson: Double read FvDeson write FvDeson;
    property vCBS: Double read FvCBS write FvCBS;
  end;

  { TgIBSValores }

  TgIBSValores = class(TObject)
  private
    FpIBS: Double;
    FvTribOp: Double;
    FgDif: TgDif;
    FgDevTrib: TgDevTrib;
    FgRed: TgRed;
    FgDeson: TgDesonIBS;
  public
    constructor Create;
    destructor Destroy; override;

    property pIBS: Double read FpIBS write FpIBS;
    property vTribOp: Double read FvTribOp write FvTribOp;
    property gDif: TgDif read FgDif write FgDif;
    property gDevTrib: TgDevTrib read FgDevTrib write FgDevTrib;
    property gRed: TgRed read FgRed write FgRed;
    property gDeson: TgDesonIBS read FgDeson write FgDeson;
  end;

  { TgCBSValores }

  TgCBSValores = class(TObject)
  private
    FpCBS: Double;
    FvTribOp: Double;
    FgDif: TgDif;
    FgDevTrib: TgDevTrib;
    FgRed: TgRed;
    FgDeson: TgDesonCBS;
  public
    constructor Create;
    destructor Destroy; override;

    property pCBS: Double read FpCBS write FpCBS;
    property vTribOp: Double read FvTribOp write FvTribOp;
    property gDif: TgDif read FgDif write FgDif;
    property gDevTrib: TgDevTrib read FgDevTrib write FgDevTrib;
    property gRed: TgRed read FgRed write FgRed;
    property gDeson: TgDesonCBS read FgDeson write FgDeson;
  end;

  { TgIBSCBSCredPres }

  TgIBSCBSCredPres = class(TObject)
  private
    FcCredPres: Integer;
    FpCredPres: Double;
    FvCredPres: Double;
    FvCredPresConsSus: Double;
  public
    property cCredPres: Integer read FcCredPres write FcCredPres;
    property pCredPres: Double read FpCredPres write FpCredPres;
    property vCredPres: Double read FvCredPres write FvCredPres;
    property vCredPresConsSus: Double read FvCredPresConsSus write FvCredPresConsSus;
  end;

  { TgIBSCBS }

  TgIBSCBS = class(TObject)
  private
    FvBC: Double;
    FgIBSUF: TgIBSValores;
    FgIBSMun: TgIBSValores;
    FgCBS: TgCBSValores;
    FgIBSCredPres: TgIBSCBSCredPres;
    FgCBSCredPres: TgIBSCBSCredPres;
  public
    constructor Create;
    destructor Destroy; override;

    property vBC: Double read FvBC write FvBC;
    property gIBSUF: TgIBSValores read FgIBSUF write FgIBSUF;
    property gIBSMun: TgIBSValores read FgIBSMun write FgIBSMun;
    property gCBS: TgCBSValores read FgCBS write FgCBS;
    property gIBSCredPres: TgIBSCBSCredPres read FgIBSCredPres write FgIBSCredPres;
    property gCBSCredPres: TgIBSCBSCredPres read FgCBSCredPres write FgCBSCredPres;
  end;

  { TIBSCBS }

  TIBSCBS = class(TObject)
  private
//italo    FCST: TCSTIBSCBS;
    FcClassTrib: Integer;
    FgIBSCBS: TgIBSCBS;
  public
    constructor Create;
    destructor Destroy; override;

//italo    property CST: TCSTIBSCBS read FCST write FCST default cst00;
    property cClassTrib: Integer read FcClassTrib write FcClassTrib;
    property gIBSCBS: TgIBSCBS read FgIBSCBS write FgIBSCBS;
  end;

  { TgIBSUFTot }

  TgIBSUFTot = class(TObject)
  private
    FvDif: Double;
    FvDevTrib: Double;
    FvDeson: Double;
    FvIBSUF: Double;
  public
    property vDif: Double read FvDif write FvDif;
    property vDevTrib: Double read FvDevTrib write FvDevTrib;
    property vDeson: Double read FvDeson write FvDeson;
    property vIBSUF: Double read FvIBSUF write FvIBSUF;
  end;

  { TgIBSMunTot }

  TgIBSMunTot = class(TObject)
  private
    FvDif: Double;
    FvDevTrib: Double;
    FvDeson: Double;
    FvIBSMun: Double;
  public
    property vDif: Double read FvDif write FvDif;
    property vDevTrib: Double read FvDevTrib write FvDevTrib;
    property vDeson: Double read FvDeson write FvDeson;
    property vIBSMun: Double read FvIBSMun write FvIBSMun;
  end;

  { TgIBS }

  TgIBS = class(TObject)
  private
    FgIBSUFTot: TgIBSUFTot;
    FgIBSMunTot: TgIBSMunTot;
    FvCredPres: Double;
    FvCredPresConsSus: Double;
    FvIBSTot: Double;
  public
    constructor Create;
    destructor Destroy; override;

    property gIBSUFTot: TgIBSUFTot read FgIBSUFTot write FgIBSUFTot;
    property gIBSMunTot: TgIBSMunTot read FgIBSMunTot write FgIBSMunTot;
    property vCredPres: Double read FvCredPres write FvCredPres;
    property vCredPresConsSus: Double read FvCredPresConsSus write FvCredPresConsSus;
    property vIBSTot: Double read FvIBSTot write FvIBSTot;
  end;

  { TgCBS }

  TgCBS = class(TObject)
  private
    FvDif: Double;
    FvDevTrib: Double;
    FvDeson: Double;
    FvCredPresConsSus: Double;
    FvCBS: Double;
  public
    property vDif: Double read FvDif write FvDif;
    property vDevTrib: Double read FvDevTrib write FvDevTrib;
    property vDeson: Double read FvDeson write FvDeson;
    property vCredPresConsSus: Double read FvCredPresConsSus write FvCredPresConsSus;
    property vCBS: Double read FvCBS write FvCBS;
  end;

  { TIBSCBSTot }

  TIBSCBSTot = class(TObject)
  private
    FvBCCIBS: Double;
    FgIBS: TgIBS;
    FgCBS: TgCBS;
  public
    constructor Create;
    destructor Destroy; override;

    property vBCCIBS: Double read FvBCCIBS write FvBCCIBS;
    property gIBS: TgIBS read FgIBS write FgIBS;
    property gCBS: TgCBS read FgCBS write FgCBS;
  end;
  {======== Fim das Classes da Reforma Tribut�ria }

  TdetCompCollectionItem = class(TObject)
  private
    FxNome: string;
    FqComp: Integer;
  public
    procedure Assign(Source: TdetCompCollectionItem);

    property xNome: string  read FxNome write FxNome;
    property qComp: Integer read FqComp write FqComp;
  end;

  TdetCompCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TdetCompCollectionItem;
    procedure SetItem(Index: Integer; Value: TdetCompCollectionItem);
  public
    function Add: TdetCompCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TdetCompCollectionItem;
    property Items[Index: Integer]: TdetCompCollectionItem read GetItem write SetItem; default;
  end;

  Ttotal = class(TObject)
  private
    FqPass: Integer;
    FvBP: Double;
    FvBC: Double;
    FvICMS: Double;
    FIBSCBSTot: TIBSCBSTot;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: Ttotal);

    property qPass : Integer read FqPass write FqPass;
    property vBP: Double     read FvBP   write FvBP;
    property vBC: Double     read FvBC   write FvBC;
    property vICMS: Double   read FvICMS write FvICMS;
    // Reforma Tributaria
    property IBSCBSTot: TIBSCBSTot read FIBSCBSTot write FIBSCBSTot;
  end;

  TdetCollectionItem = class(TObject)
  private
    FnViagem: Integer;
    FcMunIni: Integer;
    FcMunFim: Integer;
    FnContInicio: String;
    FnContFim: String;
    FqPass: String;
    FvBP: Double;
    Fimp: TImp;
    FComp: TdetCompCollection;

    procedure SetComp(const Value: TdetCompCollection);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TdetCollectionItem);

    property nViagem : Integer        read FnViagem     write FnViagem;
    property cMunIni: Integer         read FcMunIni     write FcMunIni;
    property cMunFim: Integer         read FcMunFim     write FcMunFim;
    property nContInicio: String      read FnContInicio write FnContInicio;
    property nContFim: String         read FnContFim    write FnContFim;
    property qPass: String            read FqPass       write FqPass;
    property vBP: Double              read FvBP         write FvBP;
    property imp: TImp                read Fimp         write Fimp;
    property Comp: TdetCompCollection read FComp        write SetComp;
  end;

  TdetCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TdetCollectionItem;
    procedure SetItem(Index: Integer; Value: TdetCollectionItem);
  public
    function Add: TdetCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TdetCollectionItem;
    property Items[Index: Integer]: TdetCollectionItem read GetItem write SetItem; default;
  end;

  TdetBPeTMCollectionItem = class(TObject)
  private
    FidEqpCont: Integer;
    FUFIniViagem: String;
    FUFFimViagem: String;
    Fplaca: String;
    Fprefixo: String;
    Fdet: TdetCollection;

    procedure Setdet(const Value: TdetCollection);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TdetBPeTMCollectionItem);

    property idEqpCont : Integer read FidEqpCont   write FidEqpCont;
    property UFIniViagem: String read FUFIniViagem write FUFIniViagem;
    property UFFimViagem: String read FUFFimViagem write FUFFimViagem;
    property placa: String       read Fplaca       write Fplaca;
    property prefixo: String     read Fprefixo     write Fprefixo;
    property det: TdetCollection read Fdet         write Setdet;
  end;

  TdetBPeTMCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TdetBPeTMCollectionItem;
    procedure SetItem(Index: Integer; Value: TdetBPeTMCollectionItem);
  public
    function Add: TdetBPeTMCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TdetBPeTMCollectionItem;
    property Items[Index: Integer]: TdetBPeTMCollectionItem read GetItem write SetItem; default;
  end;

  { TinfRespTec }

  TinfRespTec = class(TObject)
  private
    FCNPJ: String;
    FxContato: String;
    Femail: String;
    Ffone: String;
    FidCSRT: Integer;
    FhashCSRT: String;
  public
    procedure Assign(Source: TinfRespTec);

    property CNPJ: String     read FCNPJ     write FCNPJ;
    property xContato: String read FxContato write FxContato;
    property email: String    read Femail    write Femail;
    property fone: String     read Ffone     write Ffone;
    property idCSRT: Integer  read FidCSRT   write FidCSRT;
    property hashCSRT: String read FhashCSRT write FhashCSRT;
  end;

  { TBPe }

  TBPe = class(TObject)
  private
    FinfBPe: TinfBPe;
    FIde: TIde;
    FEmit: TEmit;
    FComp: TComp;
    FAgencia: TAgencia;
    FinfBPeSub: TinfBPeSub;
    FinfPassagem: TinfPassagem;
    FinfViagem: TInfViagemCollection;
    FinfValorBPe: TinfValorBPe;
    FImp: TImp;
    FPag: TpagCollection;
    FautXML: TautXMLCollection;
    FInfAdic: TInfAdic;
    FinfBPeSupl: TinfBPeSupl;
    FinfRespTec: TinfRespTec;
    FdetBPeTM: TdetBPeTMCollection;
    Ftotal: Ttotal;

    FSignature: TSignature;
    FProcBPe: TProcDFe;

    procedure SetInfViagem(const Value: TInfViagemCollection);
    procedure SetPag(Value: TpagCollection);
    procedure SetautXML(const Value: TautXMLCollection);
    procedure SetdetBPeTM(const Value: TdetBPeTMCollection);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TBPe);

    property infBPe: TinfBPe read FinfBPe write FinfBPe;
    property Ide: TIde read FIde write FIde;
    property Emit: TEmit read FEmit write FEmit;
    property Comp: TComp read FComp write FComp;
    property Agencia: TAgencia read FAgencia write FAgencia;
    property infBPeSub: TinfBPeSub read FinfBPeSub write FinfBPeSub;
    property infPassagem: TinfPassagem read FinfPassagem write FinfPassagem;
    property infViagem: TInfViagemCollection read FinfViagem write SetInfViagem;
    property infValorBPe: TinfValorBPe read FinfValorBPe write FinfValorBPe;
    property Imp: TImp read FImp write FImp;
    property Pag: TpagCollection read Fpag write SetPag;
    property autXML: TautXMLCollection read FautXML write SetautXML;
    property InfAdic: TInfAdic read FInfAdic write FInfAdic;
    property infBPeSupl: TinfBPeSupl read FinfBPeSupl write FinfBPeSupl;
    property infRespTec: TinfRespTec read FinfRespTec write FinfRespTec;
    property detBPeTM: TdetBPeTMCollection read FdetBPeTM write SetdetBPeTM;
    property total: Ttotal read Ftotal write Ftotal;

    property Signature: TSignature read FSignature write FSignature;
    property procBPe: TProcDFe read FProcBPe write FProcBPe;
  end;

  TinfBPe = class(TObject)
  private
    FVersao: Double;
    FID: String;

  public
    procedure Assign(Source: TinfBPe);

    property Versao: Double read FVersao write FVersao;
    property ID: String read FID write FID;
  end;

  TIde = class(TObject)
  private
    FcUF: Integer;
    FtpAmb: TACBrTipoAmbiente;
    Fmodelo: Integer;
    Fserie: Integer;
    FnBP: Integer;
    FcBP: Integer;
    FcDV: Integer;
    Fmodal: TModalBPe;
    FdhEmi: TDateTime;
    FdCompet: TDateTime;
    FtpEmis: TACBrTipoEmissao;
    FverProc: String;
    FtpBPe: TTipoBPe;
    FindPres: TPresencaComprador;
    FUFIni: String;
    FcMunIni: Integer;
    FUFFim: String;
    FcMunFim: Integer;
    FdhCont : TDateTime;
    FxJust  : String;
    FCFOP: Integer;

  public
    procedure Assign(Source: TIde);

    property cUF: Integer read FcUF write FcUF;
    property tpAmb: TACBrTipoAmbiente read FtpAmb write FtpAmb default taHomologacao;
    property modelo: Integer read Fmodelo write Fmodelo;
    property serie: Integer read Fserie write Fserie;
    property nBP: Integer read FnBP write FnBP;
    property cBP: Integer read FcBP write FcBP;
    property cDV: Integer read FcDV write FcDV;
    property modal: TModalBPe read Fmodal write Fmodal;
    property dhEmi: TDateTime read FdhEmi write FdhEmi;
    property dCompet: TDateTime read FdCompet write FdCompet;
    property tpEmis: TACBrTipoEmissao read FtpEmis write FtpEmis;
    property verProc: String read FverProc write FverProc;
    property tpBPe: TTipoBPe read FtpBPe write FtpBPe default tbNormal;
    property indPres: TPresencaComprador read FindPres write FindPres;
    property UFIni: String read FUFIni write FUFIni;
    property cMunIni: Integer read FcMunIni write FcMunIni;
    property UFFim: String read FUFFim write FUFFim;
    property cMunFim: Integer read FcMunFim write FcMunFim;
    property dhCont: TDateTime read FdhCont write FdhCont;
    property xJust: String read FxJust write FxJust;
    property CFOP: Integer read FCFOP write FCFOP;
  end;

  TEmit = class(TObject)
  private
    FCNPJ: String;
    FIE: String;
    FIEST: String;
    FxNome: String;
    FxFant: String;
    FIM: String;
    FCNAE: String;
    FCRT: TCRT;
    FenderEmit: TenderEmit;
    FTAR: String;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TEmit);

    property CNPJ: String read FCNPJ write FCNPJ;
    property IE: String read FIE write FIE;
    property IEST: String read FIEST write FIEST;
    property xNome: String read FxNome write FxNome;
    property xFant: String read FxFant write FxFant;
    property IM: String read FIM write FIM;
    property CNAE: String read FCNAE write FCNAE;
    property CRT: TCRT read FCRT write FCRT;
    property EnderEmit: TEnderEmit read FEnderEmit write FEnderEmit;
    property TAR: String read FTAR write FTAR;
  end;

  TEnderEmit = class(TObject)
  private
    FxLgr: String;
    Fnro: String;
    fxCpl: String;
    FxBairro: String;
    FcMun: Integer;
    FxMun: String;
    FCEP: Integer;
    FUF: String;
    Ffone: String;
    FEmail: String;
  public
    procedure Assign(Source: TEnderEmit);

    property xLgr: String read FxLgr write FxLgr;
    property nro: String read Fnro write Fnro;
    property xCpl: String read FxCpl write FxCpl;
    property xBairro: String read FxBairro write FxBairro;
    property cMun: Integer read FcMun write FcMun;
    property xMun: String read FxMun write FxMun;
    property CEP: Integer read FCEP write FCEP;
    property UF: String read FUF write FUF;
    property Fone: String read Ffone write Ffone;
    property Email: String read FEmail write FEmail;
  end;

  TComp = class(TObject)
  private
    FxNome: String;
    FCNPJCPF: String;
    FidEstrangeiro: String;
    FIE: String;
    FenderComp: TenderComp;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TComp);

    property xNome: String read FxNome write FxNome;
    property CNPJCPF: String read FCNPJCPF write FCNPJCPF;
    property idEstrangeiro: String read FidEstrangeiro write FidEstrangeiro;
    property IE: String read FIE write FIE;
    property EnderComp: TEnderComp read FEnderComp write FEnderComp;
  end;

  TEnderComp = class(TObject)
  private
    FxLgr: String;
    Fnro: String;
    fxCpl: String;
    FxBairro: String;
    FcMun: Integer;
    FxMun: String;
    FCEP: Integer;
    FUF: String;
    FcPais: Integer;
    FxPais: String;
    Ffone: String;
    FEmail: String;
  public
    procedure Assign(Source: TEnderComp);

    property xLgr: String read FxLgr write FxLgr;
    property nro: String read Fnro write Fnro;
    property xCpl: String read FxCpl write FxCpl;
    property xBairro: String read FxBairro write FxBairro;
    property cMun: Integer read FcMun write FcMun;
    property xMun: String read FxMun write FxMun;
    property CEP: Integer read FCEP write FCEP;
    property UF: String read FUF write FUF;
    property cPais: Integer read FcPais write FcPais;
    property xPais: String read FxPais write FxPais;
    property Fone: String read Ffone write Ffone;
    property Email: String read FEmail write FEmail;
  end;

  TAgencia = class(TObject)
  private
    FxNome: String;
    FCNPJ: String;
    FenderAgencia: TenderComp;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TAgencia);

    property xNome: String read FxNome write FxNome;
    property CNPJ: String read FCNPJ write FCNPJ;
    property EnderAgencia: TEnderComp read FEnderAgencia write FEnderAgencia;
  end;

  TinfBPeSub = class(TObject)
  private
    FchBPe: String;
    FtpSub: TTipoSubstituicao;
  public
    procedure Assign(Source: TinfBPeSub);

    property chBPe: String read FchBPe write FchBPe;
    property tpSub: TTipoSubstituicao read FtpSub write FtpSub;
  end;

  TinfPassagem = class(TObject)
  private
    FcLocOrig: String;
    FxLocOrig: String;
    FcLocDest: String;
    FxLocDest: String;
    FdhEmb: TDateTime;
    FdhValidade: TDateTime;
    FinfPassageiro: TinfPassageiro;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TinfPassagem);

    property cLocOrig: String read FcLocOrig write FcLocOrig;
    property xLocOrig: String read FxLocOrig write FxLocOrig;
    property cLocDest: String read FcLocDest write FcLocDest;
    property xLocDest: String read FxLocDest write FxLocDest;
    property dhEmb: TDateTime read FdhEmb write FdhEmb;
    property dhValidade: TDateTime read FdhValidade write FdhValidade;
    property infPassageiro: TinfPassageiro read FinfPassageiro write FinfPassageiro;
  end;

  TinfPassageiro = class(TObject)
  private
    FxNome: String;
    FCPF: String;
    FtpDoc: TTipoDocumento;
    FnDoc: String;
    FxDoc: String;
    FdNasc: TDateTime;
    FFone: String;
    FEmail: String;
  public
    procedure Assign(Source: TinfPassageiro);

    property xNome: String read FxNome write FxNome;
    property CPF: String read FCPF write FCPF;
    property tpDoc: TTipoDocumento read FtpDoc write FtpDoc;
    property nDoc: String read FnDoc write FnDoc;
    property xDoc: String read FxDoc write FxDoc;
    property dNasc: TDateTime read FdNasc write FdNasc;
    property Fone: String read FFone write FFone;
    property Email: String read FEmail write FEmail;
  end;

  TInfViagemCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfViagemCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfViagemCollectionItem);
  public
    function Add: TInfViagemCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfViagemCollectionItem;
    property Items[Index: Integer]: TInfViagemCollectionItem read GetItem write SetItem; default;
  end;

  TInfViagemCollectionItem = class(TObject)
  private
    FcPercurso: String;
    FxPercurso: String;
    FtpViagem: TTipoViagem;
    FtpServ: TTipoServico;
    FtpAcomodacao: TTipoAcomodacao;
    FtpTrecho: TTipoTrecho;
    FdhViagem: TDateTime;
    FdhConexao: TDateTime;
    FPrefixo: String;
    FPoltrona: Integer;
    FPlataforma: String;
    FinfTravessia: TinfTravessia;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TInfViagemCollectionItem);

    property cPercurso: String read FcPercurso write FcPercurso;
    property xPercurso: String read FxPercurso write FxPercurso;
    property tpViagem: TTipoViagem read FtpViagem write FtpViagem;
    property tpServ: TTipoServico read FtpServ write FtpServ;
    property tpAcomodacao: TTipoAcomodacao read FtpAcomodacao write FtpAcomodacao;
    property tpTrecho: TTipoTrecho read FtpTrecho write FtpTrecho;
    property dhViagem: TDateTime read FdhViagem write FdhViagem;
    property dhConexao: TDateTime read FdhConexao write FdhConexao;
    property Prefixo: String read FPrefixo write FPrefixo;
    property Poltrona: Integer read FPoltrona write FPoltrona;
    property Plataforma: String read FPlataforma write FPlataforma;
    property infTravessia: TinfTravessia read FinfTravessia write FinfTravessia;
  end;

  TinfTravessia = class(TObject)
  private
    FtpVeiculo: TTipoVeiculo;
    FsitVeiculo: TSitVeiculo;
  public
    procedure Assign(Source: TinfTravessia);

    property tpVeiculo: TTipoVeiculo read FtpVeiculo write FtpVeiculo;
    property sitVeiculo: TSitVeiculo read FsitVeiculo write FsitVeiculo;
  end;

  TinfValorBPe = class(TObject)
  private
    FvBP: Currency;
    FvDesconto: Currency;
    FvPgto: Currency;
    FvTroco: Currency;
    FtpDesconto: TTipoDesconto;
    FxDesconto: String;
    FcDesconto: String;
    FComp: TCompCollection;

    procedure SetComp(const Value: TCompCollection);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TinfValorBPe);
    property vBP: Currency read FvBP write FvBP;
    property vDesconto: Currency read FvDesconto write FvDesconto;
    property vPgto: Currency read FvPgto write FvPgto;
    property vTroco: Currency read FvTroco write FvTroco;
    property tpDesconto: TTipoDesconto read FtpDesconto write FtpDesconto;
    property xDesconto: String read FxDesconto write FxDesconto;
    property cDesconto: String read FcDesconto write FcDesconto;
    property Comp: TCompCollection read FComp write SetComp;
  end;

  TCompCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TCompCollectionItem;
    procedure SetItem(Index: Integer; Value: TCompCollectionItem);
  public
    function Add: TCompCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TCompCollectionItem;
    property Items[Index: Integer]: TCompCollectionItem read GetItem write SetItem; default;
  end;

  TCompCollectionItem = class(TObject)
  private
    FtpComp: TTipoComponente;
    FvComp: Currency;
  public
    procedure Assign(Source: TCompCollectionItem);
    property tpComp: TTipoComponente read FtpComp write FtpComp;
    property vComp: Currency read FvComp write FvComp;
  end;

  TImp = class(TObject)
  private
    FICMS: TICMS;
    FvTotTrib: Currency;
    FinfAdFisco: String;
    FICMSUFFim: TICMSUFFim;
    FIBSCBS: TIBSCBS;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TImp);

    property ICMS: TICMS read FICMS write FICMS;
    property vTotTrib: Currency read FvTotTrib write FvTotTrib;
    property infAdFisco: String read FinfAdFisco write FinfAdFisco;
    property ICMSUFFim: TICMSUFFim read FICMSUFFim write FICMSUFFim;
    // Reforma Tributaria
    property IBSCBS: TIBSCBS read FIBSCBS write FIBSCBS;
  end;

  TICMS = class(TObject)
  private
    FCST: TCSTIcms;
    FvBC: Currency;
    FpICMS: Currency;
    FvICMS: Currency;
    FpRedBC: Currency;
    FvCred: Currency;
    FpRedBCOutraUF: Currency;
    FvBCOutraUF: Currency;
    FpICMSOutraUF: Currency;
    FvICMSOutraUF: Currency;
    FvICMSDeson: Currency;
    FcBenef: string;
  public
    procedure Assign(Source: TICMS);

    property CST: TCSTIcms read FCST write FCST default cst00;
    property vBC: Currency read FvBC write FvBC;
    property pICMS: Currency read FpICMS write FpICMS;
    property vICMS: Currency read FvICMS write FvICMS;
    property pRedBC: Currency read FpRedBC write FpRedBC;
    property vCred: Currency read FvCred write FvCred;
    property pRedBCOutraUF: Currency read FpRedBCOutraUF write FpRedBCOutraUF;
    property vBCOutraUF: Currency read FvBCOutraUF write FvBCOutraUF;
    property pICMSOutraUF: Currency read FpICMSOutraUF write FpICMSOutraUF;
    property vICMSOutraUF: Currency read FvICMSOutraUF write FvICMSOutraUF;
    property vICMSDeson: Currency read FvICMSDeson write FvICMSDeson;
    property cBenef: string read FcBenef write FcBenef;
  end;

  TICMSUFFim = class(TObject)
  private
    FvBCUFFim: Currency;
    FpFCPUFFim: Currency;
    FpICMSUFFim: Currency;
    FpICMSInter: Currency;
    FpICMSInterPart: Currency;
    FvFCPUFFim: Currency;
    FvICMSUFFim: Currency;
    FvICMSUFIni: Currency;    
  public
    procedure Assign(Source: TICMSUFFim);

    property vBCUFFim: Currency read FvBCUFFim write FvBCUFFim;
    property pFCPUFFim: Currency read FpFCPUFFim write FpFCPUFFim;
    property pICMSUFFim: Currency read FpICMSUFFim write FpICMSUFFim;
    property pICMSInter: Currency read FpICMSInter write FpICMSInter;
    property pICMSInterPart: Currency read FpICMSInterPart write FpICMSInterPart;
    property vFCPUFFim: Currency read FvFCPUFFim write FvFCPUFFim;
    property vICMSUFFim: Currency read FvICMSUFFim write FvICMSUFFim;
    property vICMSUFIni: Currency read FvICMSUFIni write FvICMSUFIni;
  end;

  { TpagCollection}

  TpagCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TpagCollectionItem;
    procedure SetItem(Index: Integer; Value: TpagCollectionItem);
  public
    function Add: TpagCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TpagCollectionItem;
    property Items[Index: Integer]: TpagCollectionItem read GetItem write SetItem; default;
  end;

  TpagCollectionItem = class(TObject)
  private
    FtPag: TFormaPagamento;
    FxPag: String;
    FnDocPag: String;
    FvPag: Currency;
    FtpIntegra: TtpIntegra;
    FCNPJ: String;
    FtBand: TBandeiraCard;
    FxBand: String;
    FcAut: String;
    FnsuTrans: String;
    FnsuHost: String;
    FnParcelas: Integer;
    FinfAdCard: String;
  public
    procedure Assign(Source: TpagCollectionItem);

    property tPag: TFormaPagamento read FtPag write FtPag;
    property xPag: String read FxPag write FxPag;
    property nDocPag: String read FnDocPag write FnDocPag;
    property vPag: Currency read FvPag write FvPag;
    property tpIntegra: TtpIntegra read FtpIntegra write FtpIntegra;
    property CNPJ: String read FCNPJ write FCNPJ;
    property tBand: TBandeiraCard read FtBand write FtBand;
    property xBand: String read FxBand write FxBand;
    property cAut: String read FcAut write FcAut;
    property nsuTrans: String read FnsuTrans write FnsuTrans;
    property nsuHost: String read FnsuHost write FnsuHost;
    property nParcelas: Integer read FnParcelas write FnParcelas;
    property infAdCard: String read FinfAdCard write FinfAdCard;
  end;

  TautXMLCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TautXMLCollectionItem;
    procedure SetItem(Index: Integer; Value: TautXMLCollectionItem);
  public
    function Add: TautXMLCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TautXMLCollectionItem;
    property Items[Index: Integer]: TautXMLCollectionItem read GetItem write SetItem; default;
  end;

  TautXMLCollectionItem = class(TObject)
  private
    FCNPJCPF: String;
  public
    procedure Assign(Source: TautXMLCollectionItem);
    property CNPJCPF: String read FCNPJCPF write FCNPJCPF;
  end;

  TInfAdic = class(TObject)
  private
    FinfAdFisco: String;
    FinfCpl: String;
  public
    procedure Assign(Source: TInfAdic);
    property infAdFisco: String read FinfAdFisco write FinfAdFisco;
    property infCpl: String read FinfCpl write FinfCpl;
  end;

  TinfBPeSupl = class(TObject)
  private
    FqrCodBPe: String;
    FboardPassBPe: String;
  public
    procedure Assign(Source: TinfBPeSupl);
    property qrCodBPe: String read FqrCodBPe write FqrCodBPe;
    property boardPassBPe: String read FboardPassBPe write FboardPassBPe;
  end;

implementation

uses
  ACBrUtil.Base,
  ACBrBPeConsts;

procedure TBPe.Assign(Source: TBPe);
begin
  infBPe.Assign(Source.infBPe);
  Ide.Assign(Source.Ide);
  Emit.Assign(Source.Emit);
  Comp.Assign(Source.Comp);
  Agencia.Assign(Source.Agencia);
  infBPeSub.Assign(Source.infBPeSub);
  infPassagem.Assign(Source.infPassagem);
  infViagem.Assign(Source.infViagem);
  infValorBPe.Assign(Source.infValorBPe);
  Imp.Assign(Source.Imp);
  Pag.Assign(Source.Pag);
  autXML.Assign(Source.autXML);
  InfAdic.Assign(Source.InfAdic);
  infBPeSupl.Assign(Source.infBPeSupl);
  infRespTec.Assign(Source.infRespTec);
  detBPeTM.Assign(Source.detBPeTM);
  total.Assign(Source.total);

  Signature.Assign(Source.Signature);
  procBPe.Assign(Source.procBPe);
end;

constructor TBPe.Create;
begin
  inherited Create;

  FinfBPe      := TinfBPe.Create;
  FIde         := TIde.Create;
  FEmit        := TEmit.Create;
  FComp        := TComp.Create;
  FAgencia     := TAgencia.Create;
  FinfBPeSub   := TinfBPeSub.Create;
  FinfPassagem := TinfPassagem.Create;
  FinfViagem   := TInfViagemCollection.Create;
  FinfValorBPe := TinfValorBPe.Create;
  FImp         := TImp.Create;
  Fpag         := TpagCollection.Create;
  FautXML      := TautXMLCollection.Create;
  FinfAdic     := TinfAdic.Create;
  FinfBPeSupl  := TinfBPeSupl.Create;
  FinfRespTec  := TinfRespTec.Create;
  FdetBPeTM    := TdetBPeTMCollection.Create;
  Ftotal       := Ttotal.Create;

  FSignature := TSignature.create;
  FProcBPe := TProcDFe.Create('1.00', NAME_SPACE_BPe, 'bpeProc', 'BPe');
end;

destructor TBPe.Destroy;
begin
  FinfBPe.Free;
  FIde.Free;
  FEmit.Free;
  FComp.Free;
  FAgencia.Free;
  FinfBPeSub.Free;
  FinfPassagem.Free;
  FinfViagem.Free;
  FinfValorBPe.Free;
  FImp.Free;
  Fpag.Free;
  FautXML.Free;
  FinfAdic.Free;
  FinfBPeSupl.Free;
  FinfRespTec.Free;
  FdetBPeTM.Free;
  Ftotal.Free;

  FSignature.Free;
  FProcBPe.Free;

  inherited Destroy;
end;

procedure TBPe.SetInfViagem(const Value: TInfViagemCollection);
begin
  FinfViagem := Value;
end;

procedure TBPe.SetPag(Value: TpagCollection);
begin
  Fpag.Assign(Value);
end;

procedure TBPe.SetautXML(const Value: TautXMLCollection);
begin
  FautXML := Value;
end;

procedure TBPe.SetdetBPeTM(const Value: TdetBPeTMCollection);
begin
  FdetBPeTM := Value;
end;

{ TinfBPe }

procedure TinfBPe.Assign(Source: TinfBPe);
begin
  ID     := Source.ID;
  Versao := Source.Versao;
end;

{Ide}

procedure TIde.Assign(Source: TIde);
begin
  cUF     := Source.cUF;
  tpAmb   := Source.tpAmb;
  modelo  := Source.modelo;
  serie   := Source.serie;
  nBP     := Source.nBP;
  cBP     := Source.cBP;
  cDV     := Source.cDV;
  Modal   := Source.modal;
  dhEmi   := Source.dhEmi;
  dCompet := Source.dCompet;
  tpEmis  := Source.tpEmis;
  verProc := Source.verProc;
  tpBPe   := Source.tpBPe;
  indPres := Source.indPres;
  UFIni   := Source.UFIni;
  cMunIni := Source.cMunIni;
  UFFim   := Source.UFFim;
  cMunFim := Source.cMunFim;
  dhCont  := Source.dhCont;
  xJust   := Source.xJust;
  CFOP    := Source.CFOP;
end;

{Emit}

procedure TEmit.Assign(Source: TEmit);
begin
  CNPJ  := Source.CNPJ;
  IE    := Source.IE;
  IEST  := Source.IEST;
  xNome := Source.xNome;
  xFant := Source.xFant;
  IM    := Source.IM;
  CNAE  := Source.CNAE;
  CRT   := Source.CRT;
  EnderEmit.Assign(Source.EnderEmit);
  TAR   := Source.TAR;
end;

constructor TEmit.Create;
begin
  inherited Create;
  FEnderEmit := TEnderEmit.Create;
  FCRT:= crtRegimeNormal;
end;

destructor TEmit.Destroy;
begin
  FEnderEmit.Free;
  inherited;
end;

{ TenderEmit }

procedure TenderEmit.Assign(Source: TEnderEmit);
begin
  xLgr    := Source.xLgr;
  nro     := Source.nro;
  xCpl    := Source.xCpl;
  xBairro := Source.xBairro;
  cMun    := Source.cMun;
  xMun    := Source.xMun;
  CEP     := Source.CEP;
  UF      := Source.UF;
  fone    := Source.fone;
  Email   := Source.Email;
end;

{ TComp }

procedure TComp.Assign(Source: TComp);
begin
  xNome         := Source.xNome;
  CNPJCPF       := Source.CNPJCPF;
  idEstrangeiro := Source.idEstrangeiro;
  IE            := Source.IE;
  EnderComp.Assign(Source.EnderComp);

end;

constructor TComp.Create;
begin
  inherited Create;
  FEnderComp := TEnderComp.Create;
end;

destructor TComp.Destroy;
begin
  FEnderComp.Free;
  inherited;
end;

{ TEnderComp }

procedure TEnderComp.Assign(Source: TEnderComp);
begin
  xLgr    := Source.xLgr;
  nro     := Source.nro;
  xCpl    := Source.xCpl;
  xBairro := Source.xBairro;
  cMun    := Source.cMun;
  xMun    := Source.xMun;
  UF      := Source.UF;
  CEP     := Source.CEP;
  cPais   := Source.cPais;
  xPais   := Source.xPais;
  fone    := Source.fone;
  Email   := Source.Email;
end;

{ TAgencia }

procedure TAgencia.Assign(Source: TAgencia);
begin
  xNome := Source.xNome;
  CNPJ  := Source.CNPJ;
  EnderAgencia.Assign(Source.EnderAgencia);
end;

constructor TAgencia.Create;
begin
  inherited Create;
  FEnderAgencia := TEnderComp.Create;
end;

destructor TAgencia.Destroy;
begin
  FEnderAgencia.Free;
  inherited;
end;

{ TinfBPeSub }

procedure TinfBPeSub.Assign(Source: TinfBPeSub);
begin
  chBPe := Source.chBPe;
  tpSub := Source.tpSub;
end;

{ TinfPassagem }

procedure TinfPassagem.Assign(Source: TinfPassagem);
begin
  cLocOrig   := Source.cLocOrig;
  xLocOrig   := Source.xLocOrig;
  cLocDest   := Source.cLocDest;
  xLocDest   := Source.xLocDest;
  dhEmb      := Source.dhEmb;
  dhValidade := Source.dhValidade;
  infPassageiro.Assign(Source.infPassageiro);
end;

constructor TinfPassagem.Create;
begin
  inherited Create;
  FinfPassageiro := TinfPassageiro.Create;
end;

destructor TinfPassagem.Destroy;
begin
  FinfPassageiro.Free;
  inherited;
end;

{ TinfPassageiro }

procedure TinfPassageiro.Assign(Source: TinfPassageiro);
begin
  xNome := Source.xNome;
  CPF   := Source.CPF;
  tpDoc := Source.tpDoc;
  nDoc  := Source.nDoc;
  xDoc  := Source.xDoc;
  dNasc := Source.dNasc;
  Fone  := Source.Fone;
  Email := Source.Email;
end;

{ TInfViagemCollection }

function TInfViagemCollection.GetItem(Index: Integer): TInfViagemCollectionItem;
begin
  Result := TInfViagemCollectionItem(inherited Items[Index]);
end;

procedure TInfViagemCollection.SetItem(Index: Integer; Value: TInfViagemCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfViagemCollection.Add: TInfViagemCollectionItem;
begin
  Result := Self.New;
end;

function TInfViagemCollection.New: TInfViagemCollectionItem;
begin
  Result := TInfViagemCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfViagemCollectionItem }

procedure TInfViagemCollectionItem.Assign(Source: TInfViagemCollectionItem);
begin
  cPercurso    := Source.cPercurso;
  xPercurso    := Source.xPercurso;
  tpViagem     := Source.tpViagem;
  tpServ       := Source.tpServ;
  tpAcomodacao := Source.tpAcomodacao;
  tpTrecho     := Source.tpTrecho;
  dhViagem     := Source.dhViagem;
  dhConexao    := Source.dhConexao;
  Prefixo      := Source.Prefixo;
  Poltrona     := Source.Poltrona;
  Plataforma   := Source.Plataforma;
  infTravessia.Assign(Source.infTravessia);
end;

constructor TInfViagemCollectionItem.Create;
begin
  inherited;
  FinfTravessia := TinfTravessia.Create;
end;

destructor TInfViagemCollectionItem.Destroy;
begin
  FinfTravessia.Free;
  inherited;
end;

{ TinfTravessia }

procedure TinfTravessia.Assign(Source: TinfTravessia);
begin
  tpVeiculo  := Source.tpVeiculo;
  sitVeiculo := Source.sitVeiculo;
end;

{ TinfValorBPe }

procedure TinfValorBPe.Assign(Source: TinfValorBPe);
begin
  vBP        := Source.vBP;
  vDesconto  := Source.vDesconto;
  vPgto      := Source.vPgto;
  vTroco     := Source.vTroco;
  tpDesconto := Source.tpDesconto;
  xDesconto  := Source.xDesconto;
  cDesconto  := Source.cDesconto;
  Comp       := Source.Comp;
end;

constructor TinfValorBPe.Create;
begin
  inherited Create;
  FComp := TCompCollection.Create;
end;

destructor TinfValorBPe.Destroy;
begin
  FComp.Free;

  inherited Destroy;
end;

procedure TinfValorBPe.SetComp(const Value: TCompCollection);
begin
  FComp := Value;
end;

{ TCompCollection }

function TCompCollection.Add: TCompCollectionItem;
begin
  Result := Self.New;
end;

function TCompCollection.GetItem(Index: Integer): TCompCollectionItem;
begin
  Result := TCompCollectionItem(inherited Items[Index]);
end;

procedure TCompCollection.SetItem(Index: Integer; Value: TCompCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TCompCollection.New: TCompCollectionItem;
begin
  Result := TCompCollectionItem.Create;
  Self.Add(Result);
end;

{ TCompCollectionItem }

procedure TCompCollectionItem.Assign(Source: TCompCollectionItem);
begin
  tpComp := Source.FtpComp;
  vComp  := Source.vComp;
end;

{ TImp }

procedure TImp.Assign(Source: TImp);
begin
  ICMS := Source.ICMS;
  vTotTrib := Source.vTotTrib;
  infAdFisco := Source.infAdFisco;
  ICMSUFFim := Source.ICMSUFFim;
  IBSCBS := Source.IBSCBS;
end;

constructor TImp.Create;
begin
  inherited Create;

  FICMS := TICMS.Create;
  FICMSUFFim := TICMSUFFim.Create;
  FIBSCBS := TIBSCBS.Create;
end;

destructor TImp.Destroy;
begin
  FICMS.Free;
  FICMSUFFim.Free;
  FIBSCBS.Free;

  inherited;
end;

{ TICMS }

procedure TICMS.Assign(Source: TICMS);
begin
  CST := Source.CST;
  vBC := Source.vBC;
  pICMS := Source.pICMS;
  vICMS := Source.vICMS;
  pRedBC := Source.pRedBC;
  vCred := Source.vCred;
  pRedBCOutraUF := Source.pRedBCOutraUF;
  vBCOutraUF := Source.vBCOutraUF;
  pICMSOutraUF := Source.pICMSOutraUF;
  vICMSOutraUF := Source.vICMSOutraUF;
  vICMSDeson := Source.vICMSDeson;
  cBenef := Source.cBenef;
end;

{ TICMSUFFim }

procedure TICMSUFFim.Assign(Source: TICMSUFFim);
begin
  vBCUFFim       := Source.vBCUFFim;
  pFCPUFFim      := Source.pFCPUFFim;
  pICMSUFFim     := Source.pICMSUFFim;
  pICMSInter     := Source.pICMSInter;
  pICMSInterPart := Source.pICMSInterPart;
  vFCPUFFim      := Source.vFCPUFFim;
  vICMSUFFim     := Source.vICMSUFFim;
  vICMSUFIni     := Source.vICMSUFIni;
end;

{ TpagCollection }

function TpagCollection.Add: TpagCollectionItem;
begin
  Result := Self.New;
end;

function TpagCollection.GetItem(Index: Integer): TpagCollectionItem;
begin
  Result := TpagCollectionItem(inherited Items[Index]);
end;

procedure TpagCollection.SetItem(Index: Integer;
  Value: TpagCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TpagCollection.New: TpagCollectionItem;
begin
  Result := TpagCollectionItem.Create;
  Self.Add(Result);
end;

{ TpagCollectionItem }

procedure TpagCollectionItem.Assign(Source: TpagCollectionItem);
begin
  tPag      := Source.tPag;
  xPag      := Source.xPag;
  nDocPag   := Source.nDocPag;
  vPag      := Source.vPag;
  tpIntegra := Source.tpIntegra;
  CNPJ      := Source.CNPJ;
  tBand     := Source.tBand;
  xBand     := Source.xBand;
  cAut      := Source.cAut;
  nsuTrans  := Source.nsuTrans;
  nsuHost   := Source.nsuHost;
  nParcelas := Source.nParcelas;
  infAdCard := Source.infAdCard;
end;

{ TautXMLCollection }

function TautXMLCollection.Add: TautXMLCollectionItem;
begin
  Result := Self.New;
end;

function TautXMLCollection.GetItem(Index: Integer): TautXMLCollectionItem;
begin
  Result := TautXMLCollectionItem(inherited Items[Index]);
end;

procedure TautXMLCollection.SetItem(Index: Integer;
  Value: TautXMLCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TautXMLCollection.New: TautXMLCollectionItem;
begin
  Result := TautXMLCollectionItem.Create;
  Self.Add(Result);
end;

{ TautXMLCollectionItem }

procedure TautXMLCollectionItem.Assign(Source: TautXMLCollectionItem);
begin
  CNPJCPF := Source.CNPJCPF;
end;

{infAdic}

procedure TInfAdic.Assign(Source: TInfAdic);
begin
  infAdFisco := Source.infAdFisco;
  infCpl     := Source.infCpl;
end;

{ TinfBPeSupl }

procedure TinfBPeSupl.Assign(Source: TinfBPeSupl);
begin
  qrCodBPe     := Source.qrCodBPe;
  boardPassBPe := Source.boardPassBPe;
end;

{ TinfRespTec }

procedure TinfRespTec.Assign(Source: TinfRespTec);
begin
  CNPJ     := Source.CNPJ;
  xContato := Source.xContato;
  email    := Source.email;
  fone     := Source.fone;
  idCSRT   := Source.idCSRT;
  hashCSRT := Source.hashCSRT;
end;

{ TdetBPeTMCollectionItem }

procedure TdetBPeTMCollectionItem.Assign(Source: TdetBPeTMCollectionItem);
begin
  idEqpCont   := Source.idEqpCont;
  UFIniViagem := Source.UFIniViagem;
  UFFimViagem := Source.UFFimViagem;
  Placa       := Source.Placa;
  Prefixo     := Source.Prefixo;

  det.Assign(Source.det);
end;

constructor TdetBPeTMCollectionItem.Create;
begin
  inherited Create;

  Fdet := TdetCollection.Create;
end;

destructor TdetBPeTMCollectionItem.Destroy;
begin
  Fdet.Free;

  inherited Destroy;
end;

procedure TdetBPeTMCollectionItem.Setdet(const Value: TdetCollection);
begin
  Fdet := Value;
end;

{ TdetBPeTMCollection }

function TdetBPeTMCollection.Add: TdetBPeTMCollectionItem;
begin
  Result := Self.New;
end;

function TdetBPeTMCollection.GetItem(Index: Integer): TdetBPeTMCollectionItem;
begin
  Result := TdetBPeTMCollectionItem(inherited Items[Index]);
end;

function TdetBPeTMCollection.New: TdetBPeTMCollectionItem;
begin
  Result := TdetBPeTMCollectionItem.Create;
  Self.Add(Result);
end;

procedure TdetBPeTMCollection.SetItem(Index: Integer;
  Value: TdetBPeTMCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TdetCollectionItem }

procedure TdetCollectionItem.Assign(Source: TdetCollectionItem);
begin
  nViagem     := Source.nViagem;
  cMunIni     := Source.cMunIni;
  cMunFim     := Source.cMunFim;
  nContInicio := Source.nContInicio;
  nContFim    := Source.nContFim;
  qPass       := Source.qPass;
  vBP         := Source.vBP;

  imp.Assign(Source.imp);
  Comp.Assign(Source.Comp);
end;

constructor TdetCollectionItem.Create;
begin
  inherited Create;

  Fimp  := TImp.Create;
  FComp := TdetCompCollection.Create;
end;

destructor TdetCollectionItem.Destroy;
begin
  Fimp.Free;
  FComp.Free;

  inherited Destroy;
end;

procedure TdetCollectionItem.SetComp(const Value: TdetCompCollection);
begin
  FComp := Value;
end;

{ TdetCollection }

function TdetCollection.Add: TdetCollectionItem;
begin
  Result := Self.New;
end;

function TdetCollection.GetItem(Index: Integer): TdetCollectionItem;
begin
  Result := TdetCollectionItem(inherited Items[Index]);
end;

function TdetCollection.New: TdetCollectionItem;
begin
  Result := TdetCollectionItem.Create;
  Self.Add(Result);
end;

procedure TdetCollection.SetItem(Index: Integer; Value: TdetCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TdetCompCollectionItem }

procedure TdetCompCollectionItem.Assign(Source: TdetCompCollectionItem);
begin
  xNome := Source.xNome;
  qComp := Source.qComp;
end;

{ TdetCompCollection }

function TdetCompCollection.Add: TdetCompCollectionItem;
begin
  Result := Self.New;
end;

function TdetCompCollection.GetItem(Index: Integer): TdetCompCollectionItem;
begin
  Result := TdetCompCollectionItem(inherited Items[Index]);
end;

function TdetCompCollection.New: TdetCompCollectionItem;
begin
  Result := TdetCompCollectionItem.Create;
  Self.Add(Result);
end;

procedure TdetCompCollection.SetItem(Index: Integer;
  Value: TdetCompCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ Ttotal }

procedure Ttotal.Assign(Source: Ttotal);
begin
  qPass := Source.qPass;
  vBP := Source.vBP;
  vBC := Source.vBC;
  vICMS := Source.vICMS;
  IBSCBSTot := Source.IBSCBSTot;
end;

constructor Ttotal.Create;
begin
  inherited Create;

  FIBSCBSTot := TIBSCBSTot.Create;
end;

destructor Ttotal.Destroy;
begin
  FIBSCBSTot.Free;

  inherited Destroy;
end;

{======== Inicio das Classes da Reforma Tribut�ria }
{ TgIBSCBS }

constructor TgIBSCBS.Create;
begin
  inherited Create;

  FgIBSUF := TgIBSValores.Create;
  FgIBSMun := TgIBSValores.Create;
  FgCBS := TgCBSValores.Create;
  FgIBSCredPres := TgIBSCBSCredPres.Create;
  FgCBSCredPres := TgIBSCBSCredPres.Create;
end;

destructor TgIBSCBS.Destroy;
begin
  FgIBSUF.Free;
  FgIBSMun.Free;
  FgCBS.Free;
  FgIBSCredPres.Free;
  FgCBSCredPres.Free;

  inherited Destroy;
end;

{ TIBSCBS }

constructor TIBSCBS.Create;
begin
  inherited Create;

  FgIBSCBS := TgIBSCBS.Create;
end;

destructor TIBSCBS.Destroy;
begin
  FgIBSCBS.Free;

  inherited Destroy;
end;

{ TgIBSValores }

constructor TgIBSValores.Create;
begin
  inherited Create;

  FgDif := TgDif.Create;
  FgDevTrib := TgDevTrib.Create;
  FgRed := TgRed.Create;
  FgDeson := TgDesonIBS.Create;
end;

destructor TgIBSValores.Destroy;
begin
  FgDif.Free;
  FgDevTrib.Free;
  FgRed.Free;
  FgDeson.Free;

  inherited Destroy;
end;

{ TgCBSValores }

constructor TgCBSValores.Create;
begin
  inherited Create;

  FgDif := TgDif.Create;
  FgDevTrib := TgDevTrib.Create;
  FgRed := TgRed.Create;
  FgDeson := TgDesonCBS.Create;
end;

destructor TgCBSValores.Destroy;
begin
  FgDif.Free;
  FgDevTrib.Free;
  FgRed.Free;
  FgDeson.Free;

  inherited Destroy;
end;

{ TIBSCBSTot }

constructor TIBSCBSTot.Create;
begin
  inherited Create;

  FgIBS := TgIBS.Create;
  FgCBS := TgCBS.Create;
end;

destructor TIBSCBSTot.Destroy;
begin
  FgIBS.Free;
  FgCBS.Free;

  inherited Destroy;
end;

{ TgIBS }

constructor TgIBS.Create;
begin
  inherited Create;

  FgIBSUFTot := TgIBSUFTot.Create;
  FgIBSMunTot := TgIBSMunTot.Create;
end;

destructor TgIBS.Destroy;
begin
  FgIBSUFTot.Free;
  FgIBSMunTot.Free;

  inherited Destroy;
end;
{======== Fim das Classes da Reforma Tribut�ria }

end.

