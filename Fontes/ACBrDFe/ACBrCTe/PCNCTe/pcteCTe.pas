{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit pcteCTe;

interface

uses
  SysUtils, Classes,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  pcnConversao, pcnSignature, pcteProcCTe, pcteConversaoCTe;

type
  TInfCTe = class(TObject)
  private
    FId: string;
    FVersao: Double;
//    function GetVersaoStr: string;
  public
    property Id: string     read FId     write FId;
    property versao: Double read FVersao write FVersao;
//    property VersaoStr: string read GetVersaoStr;
  end;

  TToma03 = class(TObject)
  private
    Ftoma: TpcteTomador;
  public
    property Toma: TpcteTomador read Ftoma write Ftoma;
  end;

  TEndereco = class(TObject)
  private
    FxLgr: string;
    Fnro: string;
    FxCpl: string;
    FxBairro: string;
    FcMun: Integer;
    FxMun: string;
    FCEP: Integer;
    FUF: string;
    FcPais: Integer;
    FxPais: string;
  public
    property xLgr: string    read FxLgr    write FxLgr;
    property nro: string     read Fnro     write Fnro;
    property xCpl: string    read FxCpl    write FxCpl;
    property xBairro: string read FxBairro write FxBairro;
    property cMun: Integer   read FcMun    write FcMun;
    property xMun: string    read FxMun    write FxMun;
    property CEP: Integer    read FCEP     write FCEP;
    property UF: string      read FUF      write FUF;
    property cPais: Integer  read FcPais   write FcPais;
    property xPais: string   read FxPais   write FxPais;
  end;

  TToma4 = class(TObject)
  private
    Ftoma: TpcteTomador;
    FCNPJCPF: string;
    FIE: string;
    FxNome: string;
    FxFant: string;
    Ffone: string;
    FEnderToma: TEndereco;
    Femail: string;
  public
    constructor Create;
    destructor Destroy; override;

    property toma: TpcteTomador   read Ftoma      write Ftoma;
    property CNPJCPF: string      read FCNPJCPF   write FCNPJCPF;
    property IE: string           read FIE        write FIE;
    property xNome: string        read FxNome     write FxNome;
    property xFant: string        read FxFant     write FxFant;
    property fone: string         read Ffone      write Ffone;
    property enderToma: TEndereco read FEnderToma write FEnderToma;
    property email: string        read Femail     write Femail;
  end;

  TinfPercursoCollectionItem = class(TObject)
  private
    FUFPer: string;
  public
    property UFPer: string read FUFPer write FUFPer;
  end;

  TinfPercursoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfPercursoCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfPercursoCollectionItem);
  public
    function Add: TinfPercursoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TinfPercursoCollectionItem;
    property Items[Index: Integer]: TinfPercursoCollectionItem read GetItem write SetItem; default;
  end;

  TIde = class(TObject)
  private
    FcUF: Integer;
    FcCT: Integer;
    FCFOP: Integer;
    FnatOp: string;
    FforPag: TpCTeFormaPagamento;
    Fmodelo: Integer;
    Fserie: Integer;
    FnCT: Integer;
    FdhEmi: TDateTime;
    FtpImp: TpcnTipoImpressao;
    FtpEmis: TpcnTipoEmissao;
    FcDV: Integer;
    FtpAmb: TpcnTipoAmbiente;
    FtpCTe: TpcteTipoCTe;
    FprocEmi: TpcnProcessoEmissao;
    FverProc: string;
    FindGlobalizado: TIndicador;
    FrefCTe: string;
    FcMunEnv: Integer;
    FxMunEnv: string;
    FUFEnv: string;
    Fmodal: TpcteModal;
    FtpServ: TpcteTipoServico;
    FcMunIni: Integer;
    FxMunIni: string;
    FUFIni: string;
    FcMunFim: Integer;
    FxMunFim: string;
    FUFFim: string;
    Fretira: TpcteRetira;
    Fxdetretira: string;
    FindIEToma: TpcnindIEDest;
    FdhSaidaOrig: TDateTime;
    FdhChegadaDest: TDateTime;

    FToma03: TToma03;
    FToma4: TToma4;
    FinfPercurso: TinfPercursoCollection;

    FdhCont: TDateTime;
    FxJust: string;

    procedure SetinfPercurso(Value: TinfPercursoCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property cUF: Integer                 read FcUF            write FcUF;
    property cCT: Integer                 read FcCT            write FcCT;
    property CFOP: Integer                read FCFOP           write FCFOP;
    property natOp: string                read FnatOp          write FnatOp;
    property forPag: TpcteFormaPagamento  read FforPag         write FforPag;
    property modelo: Integer              read Fmodelo         write Fmodelo;
    property serie: Integer               read Fserie          write Fserie;
    property nCT: Integer                 read FnCT            write FnCT;
    property dhEmi: TDateTime             read FdhEmi          write FdhEmi;
    property tpImp: TpcnTipoImpressao     read FtpImp          write FtpImp;
    property tpEmis: TpcnTipoEmissao      read FtpEmis         write FtpEmis;
    property cDV: Integer                 read FcDV            write FcDV;
    property tpAmb: TpcnTipoAmbiente      read FtpAmb          write FtpAmb;
    property tpCTe: TpcteTipoCTe          read FtpCTe          write FtpCTe;
    property procEmi: TpcnProcessoEmissao read FprocEmi        write FprocEmi;
    property verProc: string              read FverProc        write FverProc;
    property indGlobalizado: TIndicador   read FindGlobalizado write FindGlobalizado default tiNao;
    property refCTe: string               read FrefCTe         write FrefCTe;
    property cMunEnv: Integer             read FcMunEnv        write FcMunEnv;
    property xMunEnv: string              read FxMunEnv        write FxMunEnv;
    property UFEnv: string                read FUFEnv          write FUFEnv;
    property modal: TpcteModal            read Fmodal          write Fmodal;
    property tpServ: TpcteTipoServico     read FtpServ         write FtpServ;
    property cMunIni: Integer             read FcMunIni        write FcMunIni;
    property xMunIni: string              read FxMunIni        write FxMunIni;
    property UFIni: string                read FUFIni          write FUFIni;
    property cMunFim: Integer             read FcMunFim        write FcMunFim;
    property xMunFim: string              read FxMunFim        write FxMunFim;
    property UFFim: string                read FUFFim          write FUFFim;
    property retira: TpcteRetira          read Fretira         write Fretira;
    property xDetRetira: string           read Fxdetretira     write Fxdetretira;
    property indIEToma: TpcnindIEDest     read FindIEToma      write FindIEToma;
    property dhSaidaOrig: TDateTime       read FdhSaidaOrig    write FdhSaidaOrig;
    property dhChegadaDest: TDateTime     read FdhChegadaDest  write FdhChegadaDest;

    property toma03: TToma03 read FToma03 write FToma03;
    property toma4: TToma4   read FToma4  write FToma4;

    property infPercurso: TinfPercursoCollection read FinfPercurso write SetinfPercurso;

    property dhCont: TDateTime read FdhCont write FdhCont;
    property xJust: string     read FxJust  write FxJust;
  end;

  TPassCollectionItem = class(TObject)
  private
    FxPass: string;
  public
    property xPass: string read FxPass write FxPass;
  end;

  TPassCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TPassCollectionItem;
    procedure SetItem(Index: Integer; Value: TPassCollectionItem);
  public
    function Add: TPassCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TPassCollectionItem;
    property Items[Index: Integer]: TPassCollectionItem read GetItem write SetItem; default;
  end;

  TFluxo = class(TObject)
  private
    FxOrig: string;
    Fpass: TPassCollection;
    FxDest: string;
    FxRota: string;

    procedure SetPass(Value: TPassCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property xOrig: string         read FxOrig write FxOrig;
    property pass: TPassCollection read Fpass  write SetPass;
    property xDest: string         read FxDest write FxDest;
    property xRota: string         read FxRota write FxRota;
  end;

  TSemData = class(TObject)
  private
   FtpPer: TpcteTipoDataPeriodo;
  public
    property tpPer: TpcteTipoDataPeriodo read FtpPer write FtpPer;
  end;

  TComData = class(TObject)
  private
   FtpPer: TpcteTipoDataPeriodo;
   FdProg: TDateTime;
  public
    property tpPer: TpcteTipoDataPeriodo read FtpPer write FtpPer;
    property dProg: TDateTime            read FdProg write FdProg;
  end;

  TNoPeriodo = class(TObject)
  private
   FtpPer: TpcteTipoDataPeriodo;
   FdIni: TDateTime;
   FdFim: TDateTime;
  public
    property tpPer: TpcteTipoDataPeriodo read FtpPer write FtpPer;
    property dIni: TDateTime             read FdIni  write FdIni;
    property dFim: TDateTime             read FdFim  write FdFim;
  end;

  TSemHora = class(TObject)
  private
   FtpHor: TpcteTipoHorarioIntervalo;
  public
    property tpHor: TpcteTipoHorarioIntervalo read FtpHor write FtpHor;
  end;

  TComHora = class(TObject)
  private
   FtpHor: TpcteTipoHorarioIntervalo;
   FhProg: TDateTime;
  public
    property tpHor: TpcteTipoHorarioIntervalo read FtpHor write FtpHor;
    property hProg: TDateTime                 read FhProg write FhProg;
  end;

  TNoInter = class(TObject)
  private
   FtpHor: TpcteTipoHorarioIntervalo;
   FhIni: TDateTime;
   FhFim: TDateTime;
  public
    property tpHor: TpcteTipoHorarioIntervalo read FtpHor write FtpHor;
    property hIni: TDateTime                  read FhIni  write FhIni;
    property hFim: TDateTime                  read FhFim  write FhFim;
  end;

  TEntrega = class(TObject)
  private
    FTipoData: TpcteTipoDataPeriodo;
    FTipoHora: TpcteTipoHorarioIntervalo;

    FsemData: TSemData;
    FcomData: TComData;
    FnoPeriodo: TNoPeriodo;
    FsemHora: TSemHora;
    FcomHora: TComHora;
    FnoInter: TNoInter;
  public
    constructor Create;
    destructor Destroy; override;

    property TipoData: TpcteTipoDataPeriodo      read FTipoData write FTipoData;
    property TipoHora: TpcteTipoHorarioIntervalo read FTipoHora write FTipoHora;

    property semData: TSemData     read FsemData   write FsemData;
    property comData: TComData     read FcomData   write FcomData;
    property noPeriodo: TNoPeriodo read FnoPeriodo write FnoPeriodo;
    property semHora: TSemHora     read FsemHora   write FsemHora;
    property comHora: TComHora     read FcomHora   write FcomHora;
    property noInter: TNoInter     read FnoInter   write FnoInter;
  end;

  TObsContCollectionItem = class(TObject)
  private
    FxCampo: string;
    FxTexto: string;
  public
    property xCampo: string read FxCampo write FxCampo;
    property xTexto: string read FxTexto write FxTexto;
  end;

  TObsContCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TObsContCollectionItem;
    procedure SetItem(Index: Integer; Value: TObsContCollectionItem);
  public
    function Add: TObsContCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TObsContCollectionItem;
    property Items[Index: Integer]: TObsContCollectionItem read GetItem write SetItem; default;
  end;

  TObsFiscoCollection = TObsContCollection;

  TCompl = class(TObject)
  private
    FxCaracAd: string;
    FxCaracSer: string;
    FxEmi: string;
    Ffluxo: TFluxo;
    FEntrega: TEntrega;
    ForigCalc: string;
    FdestCalc: string;
    FxObs: string;

    FObsCont: TObsContCollection;
    FObsFisco: TObsFiscoCollection;

    procedure SetObsCont(Value: TObsContCollection);
    procedure SetObsFisco(Value: TObsFiscoCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property xCaracAd: string  read FxCaracAd  write FxCaracAd;
    property xCaracSer: string read FxCaracSer write FxCaracSer;
    property xEmi: string      read FxEmi      write FxEmi;
    property fluxo: TFluxo     read Ffluxo     write Ffluxo;
    property Entrega: TEntrega read FEntrega   write FEntrega;
    property origCalc: string  read ForigCalc  write ForigCalc;
    property destCalc: string  read FdestCalc  write FdestCalc;
    property xObs: string      read FxObs      write FxObs;

    property ObsCont: TObsContCollection   read FObsCont  write SetObsCont;
    property ObsFisco: TObsFiscoCollection read FObsFisco write SetObsFisco;
  end;

  TEnderEmit = class(TObject)
  private
    FxLgr: string;
    Fnro: string;
    FxCpl: string;
    FxBairro: string;
    FcMun: Integer;
    FxMun: string;
    FCEP: Integer;
    FUF: string;
    Ffone: string;
  public
    property xLgr: string    read FxLgr    write FxLgr;
    property nro: string     read Fnro     write Fnro;
    property xCpl: string    read FxCpl    write FxCpl;
    property xBairro: string read FxBairro write FxBairro;
    property cMun: Integer   read FcMun    write FcMun;
    property xMun: string    read FxMun    write FxMun;
    property CEP: Integer    read FCEP     write FCEP;
    property UF: string      read FUF      write FUF;
    property fone: string    read Ffone    write Ffone;
  end;

  TEmit = class(TObject)
  private
    FCNPJ: string;
    FIE: string;
    FIEST: string;
    FxNome: string;
    FxFant: string;
    FEnderEmit: TEnderEmit;
    FCRT: TCRT;
  public
    constructor Create;
    destructor Destroy; override;

    property CNPJ: string          read FCNPJ      write FCNPJ;
    property IE: string            read FIE        write FIE;
    property IEST: string          read FIEST      write FIEST;
    property xNome: string         read FxNome     write FxNome;
    property xFant: string         read FxFant     write FxFant;
    property enderEmit: TEnderEmit read FEnderEmit write FEnderEmit;
    property CRT: TCRT             read FCRT       write FCRT;
  end;

  TToma = class(TObject)
  private
    FCNPJCPF: string;
    FIE: string;
    FxNome: string;
    FxFant: string;
    Ffone: string;
    FEnderToma: TEndereco;
    Femail: string;
    Ftoma: TpcteTomador;
    FindIEToma: TpcnindIEDest;
    FISUF: string;
  public
    constructor Create;
    destructor Destroy; override;

    property CNPJCPF: string      read FCNPJCPF   write FCNPJCPF;
    property IE: string           read FIE        write FIE;
    property xNome: string        read FxNome     write FxNome;
    property xFant: string        read FxFant     write FxFant;
    property fone: string         read Ffone      write Ffone;
    property enderToma: TEndereco read FEnderToma write FEnderToma;
    property email: string        read Femail     write Femail;
    {
      Campos usados somente no CT-e Simplificado
    }
    property Toma: TpcteTomador       read Ftoma      write Ftoma;
    property indIEToma: TpcnindIEDest read FindIEToma write FindIEToma;
    property ISUF: string             read FISUF      write FISUF;
  end;

  TLocColeta = class(TObject)
  private
    FCNPJCPF: string;
    FxNome: string;
    FxLgr: string;
    Fnro: string;
    FxCpl: string;
    FxBairro: string;
    FcMun: Integer;
    FxMun: string;
    FUF: string;
  public
    property CNPJCPF: string read FCNPJCPF write FCNPJCPF;
    property xNome: string   read FxNome   write FxNome;
    property xLgr: string    read FxLgr    write FxLgr;
    property nro: string     read Fnro     write Fnro;
    property xCpl: string    read FxCpl    write FxCpl;
    property xBairro: string read FxBairro write FxBairro;
    property cMun: Integer   read FcMun    write FcMun;
    property xMun: string    read FxMun    write FxMun;
    property UF: string      read FUF      write FUF;
  end;

  TRem = class(TObject)
  private
    FCNPJCPF: string;
    FIE: string;
    FxNome: string;
    FxFant: string;
    Ffone: string;
    FEnderReme: TEndereco;
    Femail: string;
    FlocColeta: TLocColeta;
  public
    constructor Create;
    destructor Destroy; override;

    property CNPJCPF: string       read FCNPJCPF   write FCNPJCPF;
    property IE: string            read FIE        write FIE;
    property xNome: string         read FxNome     write FxNome;
    property xFant: string         read FxFant     write FxFant;
    property fone: string          read Ffone      write Ffone;
    property enderReme: TEndereco  read FEnderReme write FEnderReme;
    property email: string         read Femail     write Femail;
    property locColeta: TLocColeta read FlocColeta write FlocColeta;
  end;

  TExped = class(TObject)
  private
    FCNPJCPF: string;
    FIE: string;
    FxNome: string;
    Ffone: string;
    FEnderExped: TEndereco;
    Femail: string;
  public
    constructor Create;
    destructor Destroy; override;

    property CNPJCPF: string       read FCNPJCPF    write FCNPJCPF;
    property IE: string            read FIE         write FIE;
    property xNome: string         read FxNome      write FxNome;
    property fone: string          read Ffone       write Ffone;
    property enderExped: TEndereco read FEnderExped write FEnderExped;
    property email: string         read Femail      write Femail;
  end;

  TReceb = class(TObject)
  private
    FCNPJCPF: string;
    FIE: string;
    FxNome: string;
    Ffone: string;
    FEnderReceb: TEndereco;
    Femail: string;
  public
    constructor Create;
    destructor Destroy; override;

    property CNPJCPF: string       read FCNPJCPF    write FCNPJCPF;
    property IE: string            read FIE         write FIE;
    property xNome: string         read FxNome      write FxNome;
    property fone: string          read Ffone       write Ffone;
    property enderReceb: TEndereco read FEnderReceb write FEnderReceb;
    property email: string         read Femail      write Femail;
  end;

  TLocEnt = class(TObject)
  private
    FCNPJCPF: string;
    FxNome: string;
    FxLgr: string;
    Fnro: string;
    FxCpl: string;
    FxBairro: string;
    FcMun: Integer;
    FxMun: string;
    FUF: string;
  public
    property CNPJCPF: string read FCNPJCPF write FCNPJCPF;
    property xNome: string   read FxNome   write FxNome;
    property xLgr: string    read FxLgr    write FxLgr;
    property nro: string     read Fnro     write Fnro;
    property xCpl: string    read FxCpl    write FxCpl;
    property xBairro: string read FxBairro write FxBairro;
    property cMun: Integer   read FcMun    write FcMun;
    property xMun: string    read FxMun    write FxMun;
    property UF: string      read FUF      write FUF;
  end;

  TDest = class(TObject)
  private
    FCNPJCPF: string;
    FIE: string;
    FxNome: string;
    Ffone: string;
    FISUF: string;
    FEnderDest: TEndereco;
    Femail: string;
    FlocEnt: TLocEnt;
  public
    constructor Create;
    destructor Destroy; override;

    property CNPJCPF: string      read FCNPJCPF   write FCNPJCPF;
    property IE: string           read FIE        write FIE;
    property xNome: string        read FxNome     write FxNome;
    property fone: string         read Ffone      write Ffone;
    property ISUF: string         read FISUF      write FISUF;
    property enderDest: TEndereco read FEnderDest write FEnderDest;
    property email: string        read Femail     write Femail;
    property locEnt: TLocEnt      read FlocEnt    write FlocEnt;
  end;

  TCompCollectionItem = class(TObject)
  private
    FxNome: string;
    FvComp: Currency;
  public
    property xNome: string   read FxNome write FxNome;
    property vComp: Currency read FvComp write FvComp;
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

  TCompCompCollection = TCompCollection;

  TVPrest = class(TObject)
  private
    FvTPrest: Currency;
    FvRec: Currency;
    FComp: TCompCollection;
    procedure SetComp(const Value: TCompCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property vTPrest: Currency     read FvTPrest write FvTPrest;
    property vRec: Currency        read FvRec    write FvRec;
    property Comp: TCompCollection read FComp    write SetComp;
  end;

  TCST00 = class(TObject)
  private
    FCST: TpcnCSTIcms;
    FvBC: Currency;
    FpICMS: Currency;
    FvICMS: Currency;
  public
    property CST: TpcnCSTIcms read FCST   write FCST default cst00;
    property vBC: Currency    read FvBC   write FvBC;
    property pICMS: Currency  read FpICMS write FpICMS;
    property vICMS: Currency  read FvICMS write FvICMS;
  end;

  TCST20 = class(TObject)
  private
    FCST: TpcnCSTIcms;
    FpRedBC: Currency;
    FvBC: Currency;
    FpICMS: Currency;
    FvICMS: Currency;
    FvICMSDeson: Double;
    FcBenef: string;
  public
    property CST: TpcnCSTIcms   read FCST        write FCST default cst20;
    property pRedBC: Currency   read FpRedBC     write FpRedBC;
    property vBC: Currency      read FvBC        write FvBC;
    property pICMS: Currency    read FpICMS      write FpICMS;
    property vICMS: Currency    read FvICMS      write FvICMS;
    property vICMSDeson: Double read FvICMSDeson write FvICMSDeson;
    property cBenef: string     read FcBenef     write FcBenef;
  end;

  TCST45 = class(TObject)
  private
    FCST: TpcnCSTIcms;
    FvICMSDeson: Double;
    FcBenef: string;
  public
    property CST: TpcnCSTIcms   read FCST        write FCST;
    property vICMSDeson: Double read FvICMSDeson write FvICMSDeson;
    property cBenef: string     read FcBenef     write FcBenef;
  end;

  TCST60 = class(TObject)
  private
    FCST: TpcnCSTIcms;
    FvBCSTRet: Currency;
    FvICMSSTRet: Currency;
    FpICMSSTRet: Currency;
    FvCred: Currency;
    FvICMSDeson: Double;
    FcBenef: string;
  public
    property CST: TpcnCSTIcms     read FCST        write FCST default cst60;
    property vBCSTRet: Currency   read FvBCSTRet   write FvBCSTRet;
    property vICMSSTRet: Currency read FvICMSSTRet write FvICMSSTRet;
    property pICMSSTRet: Currency read FpICMSSTRet write FpICMSSTRet;
    property vCred: Currency      read FvCred      write FvCred;
    property vICMSDeson: Double   read FvICMSDeson write FvICMSDeson;
    property cBenef: string       read FcBenef     write FcBenef;
  end;

  TCST90 = class(TObject)
  private
    FCST: TpcnCSTIcms;
    FpRedBC: Currency;
    FvBC: Currency;
    FpICMS: Currency;
    FvICMS: Currency;
    FvCred: Currency;
    FvICMSDeson: Double;
    FcBenef: string;
  public
    property CST: TpcnCSTIcms   read FCST        write FCST default cst90;
    property pRedBC: Currency   read FpRedBC     write FpRedBC;
    property vBC: Currency      read FvBC        write FvBC;
    property pICMS: Currency    read FpICMS      write FpICMS;
    property vICMS: Currency    read FvICMS      write FvICMS;
    property vCred: Currency    read FvCred      write FvCred;
    property vICMSDeson: Double read FvICMSDeson write FvICMSDeson;
    property cBenef: string     read FcBenef     write FcBenef;
  end;

  TICMSOutraUF = class(TObject)
  private
    FCST: TpcnCSTIcms;
    FpRedBCOutraUF: Currency;
    FvBCOutraUF: Currency;
    FpICMSOutraUF: Currency;
    FvICMSOutraUF: Currency;
    FvICMSDeson: Double;
    FcBenef: string;
  public
    property CST: TpcnCSTIcms        read FCST           write FCST default cst90;
    property pRedBCOutraUF: Currency read FpRedBCOutraUF write FpRedBCOutraUF;
    property vBCOutraUF: Currency    read FvBCOutraUF    write FvBCOutraUF;
    property pICMSOutraUF: Currency  read FpICMSOutraUF  write FpICMSOutraUF;
    property vICMSOutraUF: Currency  read FvICMSOutraUF  write FvICMSOutraUF;
    property vICMSDeson: Double      read FvICMSDeson    write FvICMSDeson;
    property cBenef: string          read FcBenef        write FcBenef;
  end;

  TICMSSN = class(TObject)
  private
    FCST: TpcnCSTIcms;
    FindSN: Integer;
  public
    property CST: TpcnCSTIcms read FCST   write FCST default cst90;
    property indSN: Integer   read FindSN write FindSN default 1;
  end;

  TICMS = class(TObject)
  private
    FSituTrib: TpcnCSTIcms;
    FCST00: TCST00;
    FCST20: TCST20;
    FCST45: TCST45;
    FCST60: TCST60;
    FCST90: TCST90;
    FICMSOutraUF: TICMSOutraUF;
    FICMSSN: TICMSSN;
  public
    constructor Create;
    destructor Destroy; override;

    property SituTrib: TpcnCSTIcms     read FSituTrib    write FSituTrib;
    property ICMS00: TCST00            read FCST00       write FCST00;
    property ICMS20: TCST20            read FCST20       write FCST20;
    property ICMS45: TCST45            read FCST45       write FCST45;
    property ICMS60: TCST60            read FCST60       write FCST60;
    property ICMS90: TCST90            read FCST90       write FCST90;
    property ICMSOutraUF: TICMSOutraUF read FICMSOutraUF write FICMSOutraUF;
    property ICMSSN: TICMSSN           read FICMSSN      write FICMSSN;
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
    property vBCUFFim: Currency       read FvBCUFFim       write FvBCUFFim;
    property pFCPUFFim: Currency      read FpFCPUFFim      write FpFCPUFFim;
    property pICMSUFFim: Currency     read FpICMSUFFim     write FpICMSUFFim;
    property pICMSInter: Currency     read FpICMSInter     write FpICMSInter;
    property pICMSInterPart: Currency read FpICMSInterPart write FpICMSInterPart;
    property vFCPUFFim: Currency      read FvFCPUFFim      write FvFCPUFFim;
    property vICMSUFFim: Currency     read FvICMSUFFim     write FvICMSUFFim;
    property vICMSUFIni: Currency     read FvICMSUFIni     write FvICMSUFIni;
  end;

  TinfTribFed = class(TObject)
  private
    FvPIS: Currency;
    FvCOFINS: Currency;
    FvIR: Currency;
    FvINSS: Currency;
    FvCSLL: Currency;
  public
    property vPIS: Currency    read FvPIS    write FvPIS;
    property vCOFINS: Currency read FvCOFINS write FvCOFINS;
    property vIR: Currency     read FvIR     write FvIR;
    property vINSS: Currency   read FvINSS   write FvINSS;
    property vCSLL: Currency   read FvCSLL   write FvCSLL;
  end;

  TImp = class(TObject)
  private
    FICMS: TICMS;
    FvTotTrib: Currency;
    FInfAdFisco: string;
    FICMSUFFim: TICMSUFFim;
    FinfTribFed: TinfTribFed;
  public
    constructor Create;
    destructor Destroy; override;

    property ICMS: TICMS             read FICMS        write FICMS;
    property vTotTrib: Currency      read FvTotTrib    write FvTotTrib;
    property infAdFisco: string      read FInfAdFisco  write FInfAdFisco;
    property ICMSUFFim: TICMSUFFim   read FICMSUFFim   write FICMSUFFim;
    property infTribFed: TinfTribFed read FinfTribFed  write FinfTribFed;
  end;

  TInfQCollectionItem = class(TObject)
  private
    FcUnid: TUnidMed;
    FtpMed: string;
    FqCarga: Currency;
  public
    property cUnid: TUnidMed  read FcUnid  write FcUnid;
    property tpMed: string    read FtpMed  write FtpMed;
    property qCarga: Currency read FqCarga write FqCarga;
  end;

  TInfQCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfQCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfQCollectionItem);
  public
    function Add: TInfQCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfQCollectionItem;
    property Items[Index: Integer]: TInfQCollectionItem read GetItem write SetItem; default;
  end;

  TInfCarga = class(TObject)
  private
    FvCarga: Currency;
    FproPred: string;
    FxOutCat: string;
    FinfQ: TInfQCollection;
    FvCargaAverb: Currency;

    procedure SetInfQ(const Value: TInfQCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property vCarga: Currency      read FvCarga      write FvCarga;
    property proPred: string       read FproPred     write FproPred;
    property xOutCat: string       read FxOutCat     write FxOutCat;
    property infQ: TInfQCollection read FinfQ        write SetInfQ;
    property vCargaAverb: Currency read FvCargaAverb write FvCargaAverb;
  end;

  TLacreCollectionItem = class(TObject)
  private
    FnLacre: string;
  public
    property nLacre: string read FnLacre write FnLacre;
  end;

  TLacreCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TLacreCollectionItem;
    procedure SetItem(Index: Integer; Value: TLacreCollectionItem);
  public
    function Add: TLacreCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TLacreCollectionItem;
    property Items[Index: Integer]: TLacreCollectionItem read GetItem write SetItem; default;
  end;

  TlacUnidTranspCollection = TLacreCollection;

  TlacUnidCargaCollection = TLacreCollection;

  TinfUnidCargaCollectionItem = class(TObject)
  private
    FtpUnidCarga: TpcnUnidCarga;
    FidUnidCarga: string;
    FlacUnidCarga: TlacUnidCargaCollection;
    FqtdRat: Double;
  public
    constructor Create;
    destructor Destroy; override;

    property tpUnidCarga: TpcnUnidCarga            read FtpUnidCarga  write FtpUnidCarga;
    property idUnidCarga: string                   read FidUnidCarga  write FidUnidCarga;
    property lacUnidCarga: TlacUnidCargaCollection read FlacUnidCarga write FlacUnidCarga;
    property qtdRat: Double                        read FqtdRat       write FqtdRat;
  end;

  TinfUnidCargaCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfUnidCargaCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfUnidCargaCollectionItem);
  public
    function Add: TinfUnidCargaCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TinfUnidCargaCollectionItem;
    property Items[Index: Integer]: TinfUnidCargaCollectionItem read GetItem write SetItem; default;
  end;

  TinfUnidTranspCollectionItem = class(TObject)
  private
    FtpUnidTransp: TpcnUnidTransp;
    FidUnidTransp: string;
    FlacUnidTransp: TlacUnidTranspCollection;
    FinfUnidCarga: TinfUnidCargaCollection;
    FqtdRat: Double;
  public
    constructor Create;
    destructor Destroy; override;

    property tpUnidTransp: TpcnUnidTransp            read FtpUnidTransp  write FtpUnidTransp;
    property idUnidTransp: string                    read FidUnidTransp  write FidUnidTransp;
    property lacUnidTransp: TlacUnidTranspCollection read FlacUnidTransp write FlacUnidTransp;
    property infUnidCarga: TinfUnidCargaCollection   read FinfUnidCarga  write FinfUnidCarga;
    property qtdRat: Double                          read FqtdRat        write FqtdRat;
  end;

  TinfUnidTranspNFCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfUnidTranspCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfUnidTranspCollectionItem);
  public
    function Add: TinfUnidTranspCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TinfUnidTranspCollectionItem;
    property Items[Index: Integer]: TinfUnidTranspCollectionItem read GetItem write SetItem; default;
  end;

  TinfUnidCargaNFCollection = TinfUnidCargaCollection;

  TInfNFCollectionItem = class(TObject)
  private
    FnRoma: string;
    FnPed: string;
    Fmodelo: TpcteModeloNF;
    Fserie: string;
    FnDoc: string;
    FdEmi: TDateTime;
    FvBC: Currency;
    FvICMS: Currency;
    FvBCST: Currency;
    FvST: Currency;
    FvProd: Currency;
    FvNF: Currency;
    FnCFOP: Integer;
    FnPeso: Currency;
    FPIN: string;
    FdPrev: TDateTime;
    FinfUnidTransp: TinfUnidTranspNFCollection;
    FinfUnidCarga: TinfUnidCargaNFCollection;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    property nRoma: string                             read FnRoma         write FnRoma;
    property nPed: string                              read FnPed          write FnPed;
    property modelo: TpcteModeloNF                     read Fmodelo        write Fmodelo;
    property serie: string                             read Fserie         write Fserie;
    property nDoc: string                              read FnDoc          write FnDoc;
    property dEmi: TDateTime                           read FdEmi          write FdEmi;
    property vBC: Currency                             read FvBC           write FvBC;
    property vICMS: Currency                           read FvICMS         write FvICMS;
    property vBCST: Currency                           read FvBCST         write FvBCST;
    property vST: Currency                             read FvST           write FvST;
    property vProd: Currency                           read FvProd         write FvProd;
    property vNF: Currency                             read FvNF           write FvNF;
    property nCFOP: Integer                            read FnCFOP         write FnCFOP;
    property nPeso: Currency                           read FnPeso         write FnPeso;
    property PIN: string                               read FPIN           write FPIN;
    property dPrev: TDateTime                          read FdPrev         write FdPrev;
    property infUnidTransp: TinfUnidTranspNFCollection read FinfUnidTransp write FinfUnidTransp;
    property infUnidCarga: TinfUnidCargaNFCollection   read FinfUnidCarga  write FinfUnidCarga;
  end;

  TInfNFCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfNFCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfNFCollectionItem);
  public
    function Add: TInfNFCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfNFCollectionItem;
    property Items[Index: Integer]: TInfNFCollectionItem read GetItem write SetItem; default;
  end;

  TinfUnidTranspNFeCollection = TinfUnidTranspNFCollection;

  TinfUnidCargaNFeCollection = TinfUnidCargaCollection;

  TInfNFeCollectionItem = class(TObject)
  private
    Fchave: string;
    FPIN: string;
    FdPrev: TDateTime;
    FinfUnidTransp: TinfUnidTranspNFeCollection;
    FinfUnidCarga: TinfUnidCargaNFeCollection;

  public
    constructor Create;
    destructor Destroy; override;

    property chave: string                              read Fchave         write Fchave;
    property PIN: string                                read FPIN           write FPIN;
    property dPrev: TDateTime                           read FdPrev         write FdPrev;
    property infUnidTransp: TinfUnidTranspNFeCollection read FinfUnidTransp write FinfUnidTransp;
    property infUnidCarga: TinfUnidCargaNFeCollection   read FinfUnidCarga  write FinfUnidCarga;
  end;

  TInfNFeCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfNFeCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfNFeCollectionItem);
  public
    function Add: TInfNFeCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfNFeCollectionItem;
    property Items[Index: Integer]: TInfNFeCollectionItem read GetItem write SetItem; default;
  end;

  TinfUnidTranspOutrosCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfUnidTranspCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfUnidTranspCollectionItem);
  public
    function Add: TinfUnidTranspCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TinfUnidTranspCollectionItem;
    property Items[Index: Integer]: TinfUnidTranspCollectionItem read GetItem write SetItem; default;
  end;

  TinfUnidCargaOutrosCollection = TinfUnidCargaCollection;

  TInfOutrosCollectionItem = class(TObject)
  private
    FtpDoc: TpcteTipoDocumento;
    FdescOutros: string;
    FnDoc: string;
    FdEmi: TdateTime;
    FvDocFisc: Currency;
    FdPrev: TDateTime;
    FinfUnidTransp: TinfUnidTranspOutrosCollection;
    FinfUnidCarga: TinfUnidCargaOutrosCollection;
  public
    constructor Create;
    destructor Destroy; override;

    property tpDoc: TpcteTipoDocumento                     read FtpDoc         write FtpDoc;
    property descOutros: string                            read FdescOutros    write FdescOutros;
    property nDoc: string                                  read FnDoc          write FnDoc;
    property dEmi: TdateTime                               read FdEmi          write FdEmi;
    property vDocFisc: Currency                            read FvDocFisc      write FvDocFisc;
    property dPrev: TDateTime                              read FdPrev         write FdPrev;
    property infUnidTransp: TinfUnidTranspOutrosCollection read FinfUnidTransp write FinfUnidTransp;
    property infUnidCarga: TinfUnidCargaOutrosCollection   read FinfUnidCarga  write FinfUnidCarga;
  end;

  TInfOutrosCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfOutrosCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfOutrosCollectionItem);
  public
    function Add: TInfOutrosCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfOutrosCollectionItem;
    property Items[Index: Integer]: TInfOutrosCollectionItem read GetItem write SetItem; default;
  end;

  TInfDoc = class(TObject)
  private
    FinfNF: TInfNFCollection;
    FinfNFe: TInfNFeCollection;
    FinfOutros: TInfOutrosCollection;

    procedure SetInfNF(const Value: TInfNFCollection);
    procedure SetInfNFe(const Value: TInfNFeCollection);
    procedure SetInfOutros(const Value: TInfOutrosCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property infNF: TInfNFCollection         read FinfNF     write SetInfNF;
    property infNFe: TInfNFeCollection       read FinfNFe    write SetInfNFe;
    property infOutros: TInfOutrosCollection read FinfOutros write SetInfOutros;
  end;

  TIdDocAntPapCollectionItem = class(TObject)
  private
    FtpDoc: TpcteTipoDocumentoAnterior;
    Fserie: string;
    Fsubser: string;
    FnDoc: string;
    FdEmi: TDateTime;
  public
    property tpDoc: TpcteTipoDocumentoAnterior read FtpDoc  write FtpDoc;
    property serie: string                     read Fserie  write Fserie;
    property subser: string                    read Fsubser write Fsubser;
    property nDoc: string                      read FnDoc   write FnDoc;
    property dEmi: TDateTime                   read FdEmi   write FdEmi;
  end;

  TIdDocAntPapCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TIdDocAntPapCollectionItem;
    procedure SetItem(Index: Integer; Value: TIdDocAntPapCollectionItem);
  public
    function Add: TIdDocAntPapCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TIdDocAntPapCollectionItem;
    property Items[Index: Integer]: TIdDocAntPapCollectionItem read GetItem write SetItem; default;
  end;

  TIdDocAntEleCollectionItem = class(TObject)
  private
    Fchave: string;
    FchCTe: string;
  public
    property chave: string read Fchave write Fchave;
    property chCTe: string read FchCTe write FchCTe;
  end;

  TIdDocAntEleCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TIdDocAntEleCollectionItem;
    procedure SetItem(Index: Integer; Value: TIdDocAntEleCollectionItem);
  public
    function Add: TIdDocAntEleCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TIdDocAntEleCollectionItem;
    property Items[Index: Integer]: TIdDocAntEleCollectionItem read GetItem write SetItem; default;
  end;

  TIdDocAntCollectionItem = class(TObject)
  private
    FidDocAntPap: TIdDocAntPapCollection;
    FidDocAntEle: TIdDocAntEleCollection;

    procedure SetIdDocAntPap(const Value: TIdDocAntPapCollection);
    procedure SetIdDocAntEle(const Value: TIdDocAntEleCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property idDocAntPap: TIdDocAntPapCollection read FidDocAntPap write SetIdDocAntPap;
    property idDocAntEle: TIdDocAntEleCollection read FidDocAntEle write SetIdDocAntEle;
  end;

  TIdDocAntCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TIdDocAntCollectionItem;
    procedure SetItem(Index: Integer; Value: TIdDocAntCollectionItem);
  public
    function Add: TIdDocAntCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TIdDocAntCollectionItem;
    property Items[Index: Integer]: TIdDocAntCollectionItem read GetItem write SetItem; default;
  end;

  TEmiDocAntCollectionItem = class(TObject)
  private
    FCNPJCPF: string;
    FIE: string;
    FUF: string;
    FxNome: string;
    FidDocAnt: TIdDocAntCollection;

    procedure SetIdDocAnt(const Value: TIdDocAntCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property CNPJCPF: string               read FCNPJCPF  write FCNPJCPF;
    property IE: string                    read FIE       write FIE;
    property UF: string                    read FUF       write FUF;
    property xNome: string                 read FxNome    write FxNome;
    property idDocAnt: TIdDocAntCollection read FidDocAnt write SetIdDocAnt;
  end;

  TEmiDocAntCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TEmiDocAntCollectionItem;
    procedure SetItem(Index: Integer; Value: TEmiDocAntCollectionItem);
  public
    function Add: TEmiDocAntCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TEmiDocAntCollectionItem;
    property Items[Index: Integer]: TEmiDocAntCollectionItem read GetItem write SetItem; default;
  end;

  TDocAnt = class(TObject)
  private
    FemiDocAnt: TEmiDocAntCollection;

    procedure SetEmiDocAnt(const Value: TEmiDocAntCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property emiDocAnt: TEmiDocAntCollection read FemiDocAnt write SetEmiDocAnt;
  end;

  TSegCollectionItem = class(TObject)
  private
    FrespSeg: TpcteRspSeg;
    FxSeg: string;
    FnApol: string;
    FnAver: string;
    FvCarga: Currency;
  public
    property respSeg: TpcteRspSeg read FrespSeg write FrespSeg;
    property xSeg: string         read FxSeg    write FxSeg;
    property nApol: string        read FnApol   write FnApol;
    property nAver: string        read FnAver   write FnAver;
    property vCarga: Currency     read FvCarga  write FvCarga;
  end;

  TSegCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TSegCollectionItem;
    procedure SetItem(Index: Integer; Value: TSegCollectionItem);
  public
    function Add: TSegCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TSegCollectionItem;
    property Items[Index: Integer]: TSegCollectionItem read GetItem write SetItem; default;
  end;

  TEmiOCC = class(TObject)
  private
    FCNPJ: string;
    FcInt: string;
    FIE: string;
    FUF: string;
    Ffone: string;
  public
    property CNPJ: string read FCNPJ write FCNPJ;
    property cInt: string read FcInt write FcInt;
    property IE: string   read FIE   write FIE;
    property UF: string   read FUF   write FUF;
    property fone: string read Ffone write Ffone;
  end;

  TOccCollectionItem = class(TObject)
  private
    Fserie: string;
    FnOcc: Integer;
    FdEmi: TDateTime;
    FemiOCC: TEmiOCC;
  public
    constructor Create;
    destructor Destroy; override;

    property serie: string   read Fserie  write Fserie;
    property nOcc: Integer   read FnOcc   write FnOcc;
    property dEmi: TDateTime read FdEmi   write FdEmi;
    property emiOcc: TEmiOCC read FemiOCC write FemiOCC;
  end;

  TOccCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TOccCollectionItem;
    procedure SetItem(Index: Integer; Value: TOccCollectionItem);
  public
    function Add: TOccCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TOccCollectionItem;
    property Items[Index: Integer]: TOccCollectionItem read GetItem write SetItem; default;
  end;

  TValePedCollectionItem = class(TObject)
  private
    FCNPJForn: string;
    FnCompra: string;
    FCNPJPg: string;
    FvValePed: Currency;
  public
    property CNPJForn: string   read FCNPJForn write FCNPJForn;
    property nCompra: string    read FnCompra  write FnCompra;
    property CNPJPg: string     read FCNPJPg   write FCNPJPg;
    property vValePed: Currency read FvValePed write FvValePed;
  end;

  TValePedCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TValePedCollectionItem;
    procedure SetItem(Index: Integer; Value: TValePedCollectionItem);
  public
    function Add: TValePedCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TValePedCollectionItem;
    property Items[Index: Integer]: TValePedCollectionItem read GetItem write SetItem; default;
  end;

  TProp = class(TObject)
  private
    FCNPJCPF: string;
    FRNTRC: string;
    FxNome: string;
    FIE: string;
    FUF: string;
    FtpProp: TpcteProp;
  public
    property CNPJCPF: string   read FCNPJCPF write FCNPJCPF;
    property RNTRC: string     read FRNTRC   write FRNTRC;
    property xNome: string     read FxNome   write FxNome;
    property IE: string        read FIE      write FIE;
    property UF: string        read FUF      write FUF;
    property tpProp: TpcteProp read FtpProp  write FtpProp;
  end;

  TVeicCollectionItem = class(TObject)
  private
    FcInt: string;
    FRENAVAM: string;
    Fplaca: string;
    Ftara: Integer;
    FcapKG: Integer;
    FcapM3: Integer;
    FtpProp: TpcteTipoPropriedade;
    FtpVeic: TpcteTipoVeiculo;
    FtpRod: TpcteTipoRodado;
    FtpCar: TpcteTipoCarroceria;
    FUF: string;
    Fprop: TProp;
  public
    constructor Create;
    destructor Destroy; override;

    property cInt: string                 read FcInt    write FcInt;
    property RENAVAM: string              read FRENAVAM write FRENAVAM;
    property placa: string                read Fplaca   write Fplaca;
    property tara: Integer                read Ftara    write Ftara;
    property capKG: Integer               read FcapKG   write FcapKG;
    property capM3: Integer               read FcapM3   write FcapM3;
    property tpProp: TpcteTipoPropriedade read FtpProp  write FtpProp;
    property tpVeic: TpcteTipoVeiculo     read FtpVeic  write FtpVeic;
    property tpRod: TpcteTipoRodado       read FtpRod   write FtpRod;
    property tpCar: TpcteTipoCarroceria   read FtpCar   write FtpCar;
    property UF: string                   read FUF      write FUF;
    property Prop: TProp                  read Fprop    write Fprop;
  end;

  TVeicCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TVeicCollectionItem;
    procedure SetItem(Index: Integer; Value: TVeicCollectionItem);
  public
    function Add: TVeicCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TVeicCollectionItem;
    property Items[Index: Integer]: TVeicCollectionItem read GetItem write SetItem; default;
  end;

  TLacRodoCollection = TLacreCollection;

  TMotoCollectionItem = class(TObject)
  private
    FxNome: string;
    FCPF: string;
  public
    property xNome: string read FxNome write FxNome;
    property CPF: string   read FCPF   write FCPF;
  end;

  TMotoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TMotoCollectionItem;
    procedure SetItem(Index: Integer; Value: TMotoCollectionItem);
  public
    function Add: TMotoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TMotoCollectionItem;
    property Items[Index: Integer]: TMotoCollectionItem read GetItem write SetItem; default;
  end;

  TRodo = class(TObject)
  private
    FRNTRC: string;
    FdPrev: tDateTime;
    FLota: TpcteLotacao;
    FCIOT: string;
    Focc: TOccCollection;
    FvalePed: TValePedCollection;
    Fveic: TVeicCollection;
    FlacRodo: TLacRodoCollection;
    Fmoto: TMotoCollection;

    procedure SetOcc(const Value: TOccCollection);
    procedure SetValePed(const Value: TValePedCollection);
    procedure SetVeic(const Value: TVeicCollection);
    procedure SetLacRodo(const Value: TLacRodoCollection);
    procedure SetMoto(const Value: TMotoCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property RNTRC: string               read FRNTRC   write FRNTRC;
    property dPrev: TDateTime            read FdPrev   write FdPrev;
    property lota: TpcteLotacao          read FLota    write FLota;
    property CIOT: string                read FCIOT    write FCIOT;
    property occ: TOccCollection         read Focc     write SetOcc;
    property valePed: TValePedCollection read FvalePed write SetValePed;
    property veic: TVeicCollection       read Fveic    write SetVeic;
    property lacRodo: TLacRodoCollection read FlacRodo write SetLacRodo;
    property moto: TMotoCollection       read Fmoto    write SetMoto;
  end;

  TPropOS = class(TObject)
  private
    FCNPJCPF: string;
    FTAF: string;
    FNroRegEstadual: string;
    FxNome: string;
    FIE: string;
    FUF: string;
    FtpProp: TpcteProp;
  public
    property CNPJCPF: string        read FCNPJCPF        write FCNPJCPF;
    property TAF: string            read FTAF            write FTAF;
    property NroRegEstadual: string read FNroRegEstadual write FNroRegEstadual;
    property xNome: string          read FxNome          write FxNome;
    property IE: string             read FIE             write FIE;
    property UF: string             read FUF             write FUF;
    property tpProp: TpcteProp      read FtpProp         write FtpProp;
  end;

  TVeicOS = class(TObject)
  private
    Fplaca: string;
    FRENAVAM: string;
    FUF: string;
    Fprop: TPropOS;
  public
    constructor Create;
    destructor Destroy; override;

    property placa: string   read Fplaca   write Fplaca;
    property RENAVAM: string read FRENAVAM write FRENAVAM;
    property prop: TPropOS   read Fprop    write Fprop;
    property UF: string      read FUF      write FUF;
  end;

  TinfFretamento = class(TObject)
  private
    FtpFretamento: TtpFretamento;
    FdhViagem: TDateTime;
  public
    property tpFretamento: TtpFretamento read FtpFretamento write FtpFretamento;
    property dhViagem: TDateTime         read FdhViagem     write FdhViagem;
  end;

  TRodoOS = class(TObject)
  private
    FNroRegEstadual: string;
    FTAF: string;
    Fveic: TVeicOS;
    FinfFretamento: TinfFretamento;
  public
    constructor Create;
    destructor Destroy; override;

    property TAF: string            read FTAF            write FTAF;
    property NroRegEstadual: string read FNroRegEstadual write FNroRegEstadual;
    property veic: TVeicOS          read Fveic           write Fveic;

    property infFretamento: TinfFretamento read FinfFretamento write FinfFretamento;
  end;

  TTarifa = class(TObject)
  private
    FCL: string;
    FcTar: string;
    FvTar: Currency;
  public
    property CL: string     read FCL   write FCL;
    property cTar: string   read FcTar write FcTar;
    property vTar: Currency read FvTar write FvTar;
  end;

  TpInfManuCollectionItem = class(TObject)
  private
    FnInfManu: TpInfManu;
  public
    property nInfManu: TpInfManu  read FnInfManu   write FnInfManu;
  end;

  TpInfManuCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TpInfManuCollectionItem;
    procedure SetItem(Index: Integer; Value: TpInfManuCollectionItem);
  public
    function Add: TpInfManuCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TpInfManuCollectionItem;
    property Items[Index: Integer]: TpInfManuCollectionItem read GetItem write SetItem; default;
  end;

  TNatCarga = class(TObject)
  private
    FxDime: string;
    FcinfManu: TpInfManuCollection;
    FcIMP: string;  // Alterar para ser uma lista

    procedure SetcinfManu(const Value: TpInfManuCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property xDime:    string              read FxDime    write FxDime;
    property cinfManu: TpInfManuCollection read FcinfManu write SetcinfManu;
    property cIMP:     string              read FcIMP     write FcIMP;
  end;

  TPeriCollectionItem = class(TObject)
  private
    FnONU: string;
    FxNomeAE: string;
    FxClaRisco: string;
    FgrEmb: string;
    FqTotProd: string;
    FqVolTipo: string;
    FpontoFulgor: string;
    FqTotEmb: string;
    FuniAP: TpUniMed;
  public
    property nONU: string        read FnONU        write FnONU;
    property xNomeAE: string     read FxNomeAE     write FxNomeAE;
    property xClaRisco: string   read FxClaRisco   write FxClaRisco;
    property grEmb: string       read FgrEmb       write FgrEmb;
    property qTotProd: string    read FqTotProd    write FqTotProd;
    property qVolTipo: string    read FqVolTipo    write FqVolTipo;
    property pontoFulgor: string read FpontoFulgor write FpontoFulgor;
    property qTotEmb: string     read FqTotEmb     write FqTotEmb;
    property uniAP: TpUniMed     read FuniAP       write FuniAP;
  end;

  TPeriCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TPeriCollectionItem;
    procedure SetItem(Index: Integer; Value: TPeriCollectionItem);
  public
    function Add: TPeriCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TPeriCollectionItem;
    property Items[Index: Integer]: TPeriCollectionItem read GetItem write SetItem; default;
  end;

  TAereo = class(TObject)
  private
    FnMinu: Integer;
    FnOCA: string;
    FdPrevAereo: tDateTime;
    FxLAgEmi: string;
    FIdT: string;
    Ftarifa: TTarifa;
    FnatCarga: TNatCarga;
    Fperi: TPeriCollection;

    procedure SetPeri(const Value: TPeriCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property nMinu: Integer        read FnMinu      write Fnminu;
    property nOCA: string          read FnOCA       write FnOCA;
    property dPrevAereo: TDateTime read FdPrevAereo write FdPrevAereo;
    property xLAgEmi: string       read FxLAgEmi    write FxLAgEmi;
    property IdT: string           read FIdT        write FIdT;
    property tarifa: TTarifa       read Ftarifa     write Ftarifa;
    property natCarga: TNatCarga   read FnatCarga   write FnatCarga;
    property peri: TPeriCollection read Fperi       write SetPeri;
  end;

  TBalsaCollectionItem = class(TObject)
  private
    FxBalsa: string;
  public
    property xBalsa: string read FxBalsa write FxBalsa;
  end;

  TBalsaCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TBalsaCollectionItem;
    procedure SetItem(Index: Integer; Value: TBalsaCollectionItem);
  public
    function Add: TBalsaCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TBalsaCollectionItem;
    property Items[Index: Integer]: TBalsaCollectionItem read GetItem write SetItem; default;
  end;

  TInfNFAquavCollectionItem = class(TObject)
  private
    Fserie: string;
    FnDoc: string;
    FunidRat: Double;
  public
    property serie: string   read Fserie   write Fserie;
    property nDoc: string    read FnDoc    write FnDoc;
    property unidRat: Double read FunidRat write FunidRat;
  end;

  TInfNFAquavCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfNFAquavCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfNFAquavCollectionItem);
  public
    function Add: TInfNFAquavCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfNFAquavCollectionItem;
    property Items[Index: Integer]: TInfNFAquavCollectionItem read GetItem write SetItem; default;
  end;

  TInfNFeAquavCollectionItem = class(TObject)
  private
    Fchave: string;
    FunidRat: Double;
  public
    property chave: string   read Fchave   write Fchave;
    property unidRat: Double read FunidRat write FunidRat;
  end;

  TInfNFeAquavCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfNFeAquavCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfNFeAquavCollectionItem);
  public
    function Add: TInfNFeAquavCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfNFeAquavCollectionItem;
    property Items[Index: Integer]: TInfNFeAquavCollectionItem read GetItem write SetItem; default;
  end;

  TInfDocAquav = class(TObject)
  private
    FinfNF: TInfNFAquavCollection;
    FinfNFe: TInfNFeAquavCollection;
  public
    constructor Create;
    destructor Destroy; override;

    property infNF: TInfNFAquavCollection   read FinfNF  write FinfNF;
    property infNFe: TInfNFeAquavCollection read FinfNFe write FinfNFe;
  end;

  TdetContCollectionItem = class(TObject)
  private
    FnCont: string;
    FLacre: TLacreCollection;
    FinfDoc: TinfDocAquav;

  public
    constructor Create;
    destructor Destroy; override;

    property nCont: string           read FnCont  write FnCont;
    property Lacre: TLacreCollection read FLacre  write FLacre;
    property infDoc: TinfDocAquav    read FinfDoc write FinfDoc;
  end;

  TdetContCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TdetContCollectionItem;
    procedure SetItem(Index: Integer; Value: TdetContCollectionItem);
  public
    function Add: TdetContCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TdetContCollectionItem;
    property Items[Index: Integer]: TdetContCollectionItem read GetItem write SetItem; default;
  end;

  TAquav = class(TObject)
  private
    FvPrest: Currency;
    FvAFRMM: Currency;
    FnBooking: string;
    FnCtrl: string;
    FxNavio: string;
    Fbalsa: TBalsaCollection;
    FnViag: string;
    Fdirec: TpcteDirecao;
    FprtEmb: string;
    FprtTrans: string;
    FprtDest: string;
    FtpNav: TTipoNavegacao;
    Firin: string;
    FdetCont: TdetContCollection;

    procedure SetBalsa(const Value: TbalsaCollection);
    procedure SetdetCont(const Value: TdetContCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property vPrest: Currency            read FvPrest   write FvPrest;
    property vAFRMM: Currency            read FvAFRMM   write FvAFRMM;
    property nBooking: string            read FnBooking write FnBooking;
    property nCtrl: string               read FnCtrl    write FnCtrl;
    property xNavio: string              read FxNavio   write FxNavio;
    property balsa: TBalsaCollection     read Fbalsa    write Setbalsa;
    property nViag: string               read FnViag    write FnViag;
    property direc: TpcteDirecao         read Fdirec    write Fdirec;
    property prtEmb: string              read FprtEmb   write FprtEmb;
    property prtTrans: string            read FprtTrans write FprtTrans;
    property prtDest: string             read FprtDest  write FprtDest;
    property tpNav: TTipoNavegacao       read FtpNav    write FtpNav;
    property irin: string                read Firin     write Firin;
    property detCont: TdetContCollection read FdetCont  write SetdetCont;
  end;

  TTrafMut = class(TObject)
  private
    FrespFat: TpcteTrafegoMutuo;
    FferrEmi: TpcteTrafegoMutuo;
    FchCTeFerroOrigem: string;
  public
    property respFat: TpcteTrafegoMutuo read FrespFat          write FrespFat;
    property ferrEmi: TpcteTrafegoMutuo read FferrEmi          write FferrEmi;
    property chCTeFerroOrigem: string   read FchCTeFerroOrigem write FchCTeFerroOrigem;
  end;

  TEnderFerro = class(TObject)
  private
    FxLgr: string;
    Fnro: string;
    FxCpl: string;
    FxBairro: string;
    FcMun: Integer;
    FxMun: string;
    FCEP: Integer;
    FUF: string;
  public
    property xLgr: string    read FxLgr    write FxLgr;
    property nro: string     read Fnro     write Fnro;
    property xCpl: string    read FxCpl    write FxCpl;
    property xBairro: string read FxBairro write FxBairro;
    property cMun: Integer   read FcMun    write FcMun;
    property xMun: string    read FxMun    write FxMun;
    property CEP: Integer    read FCEP     write FCEP;
    property UF: string      read FUF      write FUF;
  end;

  TFerroEnvCollectionItem = class(TObject)
  private
    FxNome: string;
    FIE: string;
    FCNPJ: string;
    FcInt: string;
    FenderFerro: TEnderFerro;
  public
    constructor Create;
    destructor Destroy; override;

    property CNPJ: string            read FCNPJ       write FCNPJ;
    property cInt: string            read FcInt       write FcInt;
    property IE: string              read FIE         write FIE;
    property xNome: string           read FxNome      write FxNome;
    property enderFerro: TEnderFerro read FenderFerro write FenderFerro;
  end;

  TFerroEnvCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TFerroEnvCollectionItem;
    procedure SetItem(Index: Integer; Value: TFerroEnvCollectionItem);
  public
    function Add: TFerroEnvCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TFerroEnvCollectionItem;
    property Items[Index: Integer]: TFerroEnvCollectionItem read GetItem write SetItem; default;
  end;

  TDetVagCollectionItem = class(TObject)
  private
    FnVag: Integer;
    Fcap: Currency;
    FtpVag: string;
    FpesoR: Currency;
    FpesoBC: Currency;
  public
    property nVag: Integer    read FnVag   write FnVag;
    property cap: Currency    read Fcap    write Fcap;
    property tpVag: string    read FtpVag  write FtpVag;
    property pesoR: Currency  read FpesoR  write FpesoR;
    property pesoBC: Currency read FpesoBC write FpesoBC;
  end;

  TDetVagCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TDetVagCollectionItem;
    procedure SetItem(Index: Integer; Value: TDetVagCollectionItem);
  public
    function Add: TDetVagCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TDetVagCollectionItem;
    property Items[Index: Integer]: TDetVagCollectionItem read GetItem write SetItem; default;
  end;

  TFerrov = class(TObject)
  private
    FtpTraf: TpcteTipoTrafego;
    FtrafMut: TTrafMut;
    Ffluxo: string;
    FidTrem: string;
    FvFrete: Currency;
    FferroEnv: TFerroEnvCollection;
    FdetVag: TDetVagCollection;

    procedure SetFerroEnv(const Value: TFerroEnvCollection);
    procedure SetDetVag(const Value: TDetVagCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property tpTraf: TpcteTipoTrafego      read FtpTraf   write FtpTraf;
    property trafMut: TTrafMut             read FtrafMut  write FTrafMut;
    property fluxo: string                 read Ffluxo    write Ffluxo;
    property idTrem: string                read FidTrem   write FidTrem;
    property vFrete: Currency              read FvFrete   write FvFrete;
    property ferroEnv: TFerroEnvCollection read FferroEnv write SetferroEnv;
    property detVag: TDetVagCollection     read FdetVag   write SetdetVag;
  end;

  TDuto = class(TObject)
  private
    FvTar: Currency;
    FdIni: TDateTime;
    FdFim: TDateTime;
  public
    property vTar: Currency  read FvTar write FvTar;
    property dIni: TDateTime read FdIni write FdIni;
    property dFim: TDateTime read FdFim write FdFim;
  end;

  TMultimodal = class(TObject)
  private
    FCOTM: string;
    FindNegociavel: TpcnindNegociavel;
    FxSeg: string;
    FCNPJ: string;
    FnApol: string;
    FnAver: string;
  public
    property COTM: string  read FCOTM write FCOTM;

    property indNegociavel: TpcnindNegociavel read FindNegociavel write FindNegociavel;

    property xSeg: string  read FxSeg  write FxSeg;
    property CNPJ: string  read FCNPJ  write FCNPJ;
    property nApol: string read FnApol write FnApol;
    property nAver: string read FnAver write FnAver;
  end;

  TVeicNovosCollectionItem = class(TObject)
  private
    Fchassi: string;
    FcCor: string;
    FxCor: string;
    FcMod: string;
    FvUnit: Currency;
    FvFrete: Currency;
  public
    property chassi: string   read Fchassi write Fchassi;
    property cCor: string     read FcCor   write FcCor;
    property xCor: string     read FxCor   write FxCor;
    property cMod: string     read FcMod   write FcMod;
    property vUnit: Currency  read FvUnit  write FvUnit;
    property vFrete: Currency read FvFrete write FvFrete;
  end;

  TVeicNovosCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TVeicNovosCollectionItem;
    procedure SetItem(Index: Integer; Value: TVeicNovosCollectionItem);
  public
    function Add: TVeicNovosCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TVeicNovosCollectionItem;
    property Items[Index: Integer]: TVeicNovosCollectionItem read GetItem write SetItem; default;
  end;

  TFat = class(TObject)
  private
    FnFat: string;
    FvOrig: Currency;
    FvDesc: Currency;
    FvLiq: Currency;
  public
    property nFat: string    read FnFat  write FnFat;
    property vOrig: Currency read FvOrig write FvOrig;
    property vDesc: Currency read FvDesc write FvDesc;
    property vLiq: Currency  read FvLiq  write FvLiq;
  end;

  TDupCollectionItem = class(TObject)
  private
    FnDup: string;
    FdVenc: TDateTime;
    FvDup: Currency;
  public
    property nDup: string     read FnDup  write FnDup;
    property dVenc: TDateTime read FdVenc write FdVenc;
    property vDup: Currency   read FvDup  write FvDup;
  end;

  TDupCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TDupCollectionItem;
    procedure SetItem(Index: Integer; Value: TDupCollectionItem);
  public
    function Add: TDupCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TDupCollectionItem;
    property Items[Index: Integer]: TDupCollectionItem read GetItem write SetItem; default;
  end;

  TCobr = class(TObject)
  private
    Ffat: TFat;
    Fdup: TDupCollection;

    procedure SetDup(Value: TDupCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property fat: TFat           read Ffat write Ffat;
    property dup: TDupCollection read Fdup write SetDup;
  end;

  TRefNF = class(TObject)
  private
    FCNPJCPF: string;
    Fmod: string;
    Fserie: Integer;
    Fsubserie: Integer;
    Fnro: Integer;
    Fvalor: Currency;
    FdEmi: TDateTime;
  public
    property CNPJCPF: string   read FCNPJCPF  write FCNPJCPF;
    property modelo: string    read Fmod      write Fmod;
    property serie: Integer    read Fserie    write Fserie;
    property subserie: Integer read Fsubserie write Fsubserie;
    property nro: Integer      read Fnro      write Fnro;
    property valor: Currency   read Fvalor    write Fvalor;
    property dEmi: TDateTime   read FdEmi     write FdEmi;
  end;

  TTomaICMS = class(TObject)
  private
    FrefNFe: string;
    FrefNF: TRefNF;
    FrefCte: string;
  public
    constructor Create;
    destructor Destroy; override;

    property refNFe: string read FrefNFe write FrefNFe;
    property refNF: TRefNF  read FrefNF  write FrefNF;
    property refCte: string read FrefCte write FrefCte;
  end;

  TTomaNaoICMS = class(TObject)
  private
    FrefCteAnu: string;
  public
    property refCteAnu: string read FrefCteAnu write FrefCteAnu;
  end;

  TInfCteSub = class(TObject)
  private
    FchCte: string;
    FrefCteAnu: string;
    FtomaICMS: TTomaICMS;
    FtomaNaoICMS: TTomaNaoICMS;
    FindAlteraToma: TIndicador;
  public
    constructor Create;
    destructor Destroy; override;

    property chCte: string             read FchCte         write FchCte;
    property refCteAnu: string         read FrefCteAnu     write FrefCteAnu;
    property tomaICMS: TTomaICMS       read FtomaICMS      write FtomaICMS;
    property tomaNaoICMS: TTomaNaoICMS read FtomaNaoICMS   write FtomaNaoICMS;
    property indAlteraToma: TIndicador read FindAlteraToma write FindAlteraToma default tiNao;
  end;

  TInfGlobalizado = class(TObject)
  private
    FxObs: string;
  public
    property xObs: string read FxObs write FxObs;
  end;

  TInfCTeMultimodalCollectionItem = class(TObject)
  private
    FchCTeMultimodal: string;
  public
    property chCTeMultimodal: string read FchCTeMultimodal write FchCTeMultimodal;
  end;

  TInfCTeMultimodalCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfCTeMultimodalCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfCTeMultimodalCollectionItem);
  public
    function Add: TInfCTeMultimodalCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfCTeMultimodalCollectionItem;
    property Items[Index: Integer]: TInfCTeMultimodalCollectionItem read GetItem write SetItem; default;
  end;

  TInfServVinc = class(TObject)
  private
    FinfCTeMultimodal: TinfCTeMultimodalCollection;
  public
    constructor Create;
    destructor Destroy; override;

    property infCTeMultimodal: TinfCTeMultimodalCollection read FinfCTeMultimodal write FinfCTeMultimodal;
  end;

  TInfServico = class(TObject)
  private
    FxDescServ: string;
    FqCarga: Currency;
  public
    property xDescServ: string read FxDescServ write FxDescServ;
    property qCarga: Currency read FqCarga write FqCarga;
  end;

  TinfDocRefCollectionItem = class(TObject)
  private
    FnDoc: string;
    Fserie: string;
    Fsubserie: string;
    FdEmi: TDateTime;
    FvDoc: Currency;
    FchBPe: string;
  public
    property nDoc: string     read FnDoc     write FnDoc;
    property serie: string    read Fserie    write Fserie;
    property subserie: string read Fsubserie write Fsubserie;
    property dEmi: TDateTime  read FdEmi     write FdEmi;
    property vDoc: Currency   read FvDoc     write FvDoc;
    property chBPe: string    read FchBPe    write FchBPe;
  end;

  TinfDocRefCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfDocRefCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfDocRefCollectionItem);
  public
    function Add: TinfDocRefCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TinfDocRefCollectionItem;
    property Items[Index: Integer]: TinfDocRefCollectionItem read GetItem write SetItem; default;
  end;

  TinfGTVeCompCollectionItem = class(TObject)
  private
    FtpComp: TtpComp;
    FvComp: Currency;
    FxComp: string;
  public
    property tpComp: TtpComp read FtpComp write FtpComp;
    property vComp: Currency read FvComp  write FvComp;
    property xComp: string   read FxComp  write FxComp;
  end;

  TinfGTVeCompCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfGTVeCompCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfGTVeCompCollectionItem);
  public
    function Add: TinfGTVeCompCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TinfGTVeCompCollectionItem;
    property Items[Index: Integer]: TinfGTVeCompCollectionItem read GetItem write SetItem; default;
  end;

  TinfGTVeCollectionItem = class(TObject)
  private
    FchCTe: string;
    FComp: TinfGTVeCompCollection;
    procedure SetComp(const Value: TinfGTVeCompCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property chCTe: string                read FchCTe write FchCTe;
    property Comp: TinfGTVeCompCollection read FComp  write SetComp;
  end;

  TinfGTVeCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfGTVeCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfGTVeCollectionItem);
  public
    function Add: TinfGTVeCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TinfGTVeCollectionItem;
    property Items[Index: Integer]: TinfGTVeCollectionItem read GetItem write SetItem; default;
  end;

  TInfCTeNorm = class(TObject)
  private
    FinfCarga: TInfCarga;
    FinfDoc: TInfDoc;
    FdocAnt: TDocAnt;
    Fseg: TSegCollection;

    Frodo: TRodo;             // Informa��es do modal Rodovi�rio
    FrodoOS: TRodoOS;         // Informa��es do modal Rodovi�rio Outros Servi�os
    Faereo: TAereo;           // Informa��es do modal A�reo
    Faquav: TAquav;           // Informa��es do modal Aquavi�rio
    Fferrov: TFerrov;         // Informa��es do modal Ferrovi�rio
    Fduto: TDuto;             // Informa��es do modal Dutovi�rio
    Fmultimodal: TMultimodal; // Informa��es do Multimodal

    Fperi: TPeriCollection;
    FveicNovos: TVeicNovosCollection;
    FCobr: TCobr;
    FinfCteSub: TInfCteSub;
    FinfGlobalizado: TinfGlobalizado;
    FinfServVinc: TinfServVinc;
    FinfServico: TinfServico;
    FinfDocRef: TinfDocRefCollection;
    FrefCTeCanc: string;
    FinfGTVe: TinfGTVeCollection;

    procedure SetSeg(const Value: TSegCollection);
    procedure SetVeicNovos(const Value: TVeicNovosCollection);
    procedure SetinfDocRef(const Value: TinfDocRefCollection);
    procedure SetinfGTVe(const Value: TinfGTVeCollection);
    procedure SetPeri(const Value: TPeriCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property infCarga: TInfCarga read FInfCarga write FInfCarga;
    property infDoc: TInfDoc     read FinfDoc   write FinfDoc;
    property docAnt: TDocAnt     read FdocAnt   write FdocAnt;
    property seg: TSegCollection read Fseg      write SetSeg;

    property rodo: TRodo             read Frodo       write Frodo;
    property rodoOS: TRodoOS         read FrodoOS     write FrodoOS;
    property aereo: TAereo           read Faereo      write Faereo;
    property aquav: TAquav           read Faquav      write Faquav;
    property ferrov: TFerrov         read Fferrov     write Fferrov;
    property duto: TDuto             read Fduto       write Fduto;
    property multimodal: TMultimodal read Fmultimodal write Fmultimodal;

    property peri: TPeriCollection           read Fperi           write SetPeri;
    property veicNovos: TVeicNovosCollection read FveicNovos      write SetVeicNovos;
    property cobr: TCobr                     read FCobr           write FCobr;
    property infCteSub: TInfCteSub           read FinfCteSub      write FinfCteSub;
    property infGlobalizado: TinfGlobalizado read FinfGlobalizado write FinfGlobalizado;
    property infServVinc: TinfServVinc       read FinfServVinc    write FinfServVinc;

    property infServico: TinfServico         read FinfServico write FinfServico;
    property infDocRef: TinfDocRefCollection read FinfDocRef  write SetinfDocRef;
    property refCTeCanc: string              read FrefCTeCanc write FrefCTeCanc;
    property infGTVe: TinfGTVeCollection     read FinfGTVe    write SetinfGTVe;
  end;

  TInfCteComp = class
  private
    FChave: string;
  public
    property chave: string read FChave write FChave;
  end;

  TInfCteCompCollectionItem = class(TObject)
  private
    FchCTe: string;
  public
    property chCTe: string read FchCTe write FchCTe;
  end;

  TInfCteCompCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfCteCompCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfCteCompCollectionItem);
  public
    function Add: TInfCteCompCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfCteCompCollectionItem;
    property Items[Index: Integer]: TInfCteCompCollectionItem read GetItem write SetItem; default;
  end;

  TInfCteAnu = class(TObject)
  private
    FchCTe: string;
    FdEmi: TDateTime;
  public
    property chCTe: string   read FchCTe write FchCTe;
    property dEmi: TDateTime read FdEmi  write FdEmi;
  end;

  TautXMLCollectionItem = class(TObject)
  private
    FCNPJCPF: string;
  public
    property CNPJCPF: string read FCNPJCPF write FCNPJCPF;
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

  TinfRespTec = class(TObject)
  private
    FCNPJ: string;
    FxContato: string;
    Femail: string;
    Ffone: string;
    FidCSRT: Integer;
    FhashCSRT: string;
  public
    property CNPJ: string     read FCNPJ     write FCNPJ;
    property xContato: string read FxContato write FxContato;
    property email: string    read Femail    write Femail;
    property fone: string     read Ffone     write Ffone;
    property idCSRT: Integer  read FidCSRT   write FidCSRT;
    property hashCSRT: string read FhashCSRT write FhashCSRT;
  end;

  TinfCTeSupl = class(TObject)
  private
    FqrCodCTe: string;
  public
    property qrCodCTe: string read FqrCodCTe write FqrCodCTe;
  end;

  TinfEspecieCollectionItem = class(TObject)
  private
    FtpEspecie: TEspecie;
    FvEspecie: Double;
    FtpNumerario: TtpNumerario;
    FxMoedaEstr: string;
  public
    property tpEspecie: TEspecie       read FtpEspecie   write FtpEspecie;
    property vEspecie: Double          read FvEspecie    write FvEspecie;
    property tpNumerario: TtpNumerario read FtpNumerario write FtpNumerario;
    property xMoedaEstr: string        read FxMoedaEstr  write FxMoedaEstr;
  end;

  TinfEspecieCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfEspecieCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfEspecieCollectionItem);
  public
    function Add: TinfEspecieCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TinfEspecieCollectionItem;
    property Items[Index: Integer]: TinfEspecieCollectionItem read GetItem write SetItem; default;
  end;

  TinfVeiculoCollectionItem = class(TObject)
  private
    Fplaca: string;
    FUF: string;
    FRNTRC: string;
  public
    property placa: string read Fplaca write Fplaca;
    property UF: string    read FUF    write FUF;
    property RNTRC: string read FRNTRC write FRNTRC;
  end;

  TinfVeiculoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfVeiculoCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfVeiculoCollectionItem);
  public
    function Add: TinfVeiculoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TinfVeiculoCollectionItem;
    property Items[Index: Integer]: TinfVeiculoCollectionItem read GetItem write SetItem; default;
  end;

  TdetGTV = class(TObject)
  private
    FqCarga: Double;
    FinfEspecie: TinfEspecieCollection;
    FinfVeiculo: TinfVeiculoCollection;

    procedure SetinfEspecie(const Value: TinfEspecieCollection);
    procedure SetinfVeiculo(const Value: TinfVeiculoCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property infEspecie: TinfEspecieCollection read FinfEspecie write SetinfEspecie;
    property qCarga: Double                    read FqCarga     write FqCarga;
    property infVeiculo: TinfVeiculoCollection read FinfVeiculo write SetinfVeiculo;
  end;

  TinfNFeTranspParcialCollectionItem = class(TObject)
  private
    FchNFe: string;
  public
    property chNFe: string read FchNFe write FchNFe;
  end;

  TinfNFeTranspParcialCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfNFeTranspParcialCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfNFeTranspParcialCollectionItem);
  public
    function Add: TinfNFeTranspParcialCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TinfNFeTranspParcialCollectionItem;
    property Items[Index: Integer]: TinfNFeTranspParcialCollectionItem read GetItem write SetItem; default;
  end;

  TinfDocAntCollectionItem = class(TObject)
  private
    FchCTe: string;
    FtpPrest: TtpPrest;
    FinfNFeTranspParcial: TinfNFeTranspParcialCollection;

    procedure SetinfNFeTranspParcial(
      const Value: TinfNFeTranspParcialCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property chCTe: string     read FchCTe   write FchCTe;
    property tpPrest: TtpPrest read FtpPrest write FtpPrest;

    property infNFeTranspParcial: TinfNFeTranspParcialCollection read FinfNFeTranspParcial write SetinfNFeTranspParcial;
  end;

  TinfDocAntCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfDocAntCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfDocAntCollectionItem);
  public
    function Add: TinfDocAntCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TinfDocAntCollectionItem;
    property Items[Index: Integer]: TinfDocAntCollectionItem read GetItem write SetItem; default;
  end;

  TdetCollectionItem = class(TObject)
  private
    FcMunIni: Integer;
    FxMunIni: string;
    FcMunFim: Integer;
    FxMunFim: string;
    FvPrest: Currency;
    FvRec: Currency;
    FComp: TCompCollection;
    FinfNFe: TInfNFeCollection;
    FinfdocAnt: TInfDocAntCollection;

    procedure SetComp(const Value: TCompCollection);
    procedure SetInfNFe(const Value: TInfNFeCollection);
    procedure SetinfdocAnt(const Value: TInfDocAntCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property cMunIni: Integer  read FcMunIni write FcMunIni;
    property xMunIni: string   read FxMunIni write FxMunIni;
    property cMunFim: Integer  read FcMunFim write FcMunFim;
    property xMunFim: string   read FxMunFim write FxMunFim;
    property vPrest: Currency  read FvPrest  write FvPrest;
    property vRec: Currency    read FvRec    write FvRec;

    property Comp: TCompCollection           read FComp      write SetComp;
    property infNFe: TInfNFeCollection       read FinfNFe    write SetInfNFe;
    property infdocAnt: TInfDocAntCollection read FinfdocAnt write SetinfdocAnt;
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

  TinfModal = class(TObject)
  private
    Frodo: TRodo;
    Faereo: TAereo;
    Faquav: TAquav;
  public

    constructor Create;
    destructor Destroy; override;

    property rodo: TRodo   read Frodo  write Frodo;
    property aereo: TAereo read Faereo write Faereo;
    property aquav: TAquav read Faquav write Faquav;
  end;

  Ttotal = class(TObject)
  private
    FvTPrest: Currency;
    FvTRec: Currency;
  public
    property vTPrest: Currency read FvTPrest write FvTPrest;
    property vTRec: Currency   read FvTRec   write FvTRec;
  end;

 TCTe = class(TObject)
  private
    FinfCTe: TInfCTe;
    Fide: TIde;
    Fcompl: TCompl;

    Femit: TEmit;
    Ftoma: TToma;
    Frem: TRem;
    Fexped: TExped;
    Freceb: TReceb;
    Fdest: TDest;

    FvPrest: TVPrest;
    Fimp: TImp;

    FinfCTeNorm: TInfCTeNorm;
    FinfCteComp: TInfCteComp;
    FinfCteComp10: TInfCteCompCollection;
    FInfCteAnu: TInfCteAnu;
    FautXML: TautXMLCollection;
    FinfRespTec: TinfRespTec;
    FinfCTeSupl: TinfCTeSupl;

    Forigem: TEnderEmit;
    Fdestino: TEnderEmit;
    FdetGTV: TdetGTV;

    FProcCTe: TProcCTe;
    FSignature: TSignature;
    {
      As propriedades abaixo s�o destinadas somente ao CT-e Simplificado
    }
    FinfCarga: TInfCarga;
    Fdet: TdetCollection;
    FinfModal: TinfModal;
    FCobr: TCobr;
    FinfCteSub: TInfCteSub;
    Ftotal: Ttotal;

    procedure SetinfCteComp10(const Value: TInfCteCompCollection);
    procedure SetautXML(const Value: TautXMLCollection);
    procedure Setdet(const Value: TdetCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property infCTe: TInfCTe read FinfCTe write FinfCTe;
    property ide: TIde       read Fide    write Fide;
    property compl: TCompl   read Fcompl  write Fcompl;

    property emit: TEmit     read Femit   write Femit;
    property toma: TToma     read Ftoma   write Ftoma;
    property rem: TRem       read Frem    write Frem;
    property exped: TExped   read Fexped  write Fexped;
    property receb: TReceb   read Freceb  write Freceb;
    property dest: TDest     read Fdest   write Fdest;

    property vPrest: TVPrest read FvPrest write FvPrest;
    property imp: TImp       read Fimp    write Fimp;

    property infCTeNorm: TInfCTeNorm read FinfCTeNorm write FinfCTeNorm;
    property infCteComp: TInfCteComp read FinfCteComp write FinfCteComp;

    property infCteComp10: TInfCteCompCollection read FinfCteComp10 write SetinfCteComp10;

    property infCteAnu: TInfCteAnu     read FinfCteAnu  write FinfCteAnu;
    property autXML: TautXMLCollection read FautXML     write SetautXML;
    property infRespTec: TinfRespTec   read FinfRespTec write FinfRespTec;
    property infCTeSupl: TinfCTeSupl   read FinfCTeSupl write FinfCTeSupl;

    property origem: TEnderEmit  read Forigem  write Forigem;
    property destino: TEnderEmit read Fdestino write Fdestino;
    property detGTV: TdetGTV     read FdetGTV  write FdetGTV;
    {
      As propriedades abaixo s�o destinadas somente ao CT-e Simplificado
    }
    property infCarga: TInfCarga   read FinfCarga  write FinfCarga;
    property det: TdetCollection   read Fdet       write Setdet;
    property infModal: TinfModal   read FinfModal  write FinfModal;
    property cobr: TCobr           read FCobr      write FCobr;
    property infCteSub: TInfCteSub read FinfCteSub write FinfCteSub;
    property total: Ttotal         read Ftotal     write Ftotal;

    property procCTe: TProcCTe     read FProcCTe   write FProcCTe;
    property signature: Tsignature read Fsignature write Fsignature;
  end;

const
  CMUN_EXTERIOR = 9999999;
  XMUN_EXTERIOR  = 'EXTERIOR';
  UF_EXTERIOR  = 'EX';

implementation

uses
  ACBrUtil.Base;

{ TCTe }

constructor TCTe.Create;
begin
  inherited Create;

  FinfCTe := TInfCTe.Create;
  Fide := TIde.Create;
  Fcompl := TCompl.Create;

  Femit := TEmit.Create;
  FToma := TToma.Create;
  Frem := TRem.Create;
  Fexped := TExped.Create;
  Freceb := TReceb.Create;
  Fdest := TDest.Create;

  FvPrest := TVPrest.Create;
  Fimp := TImp.Create;

  FinfCTeNorm := TInfCTeNorm.Create;
  FinfCTeComp := TInfCteComp.Create;
  FinfCTeComp10 := TInfCteCompCollection.Create;
  FinfCteAnu := TInfCteAnu.Create;
  FautXML := TautXMLCollection.Create;

  FinfRespTec := TinfRespTec.Create;
  FinfCTeSupl := TinfCTeSupl.Create;

  Forigem := TEnderEmit.Create;
  Fdestino := TEnderEmit.Create;
  FdetGTV := TdetGTV.Create;

  FProcCTe := TProcCTe.create;
  Fsignature := Tsignature.create;
  {
   CT-e Simplificado
  }
  FinfCarga := TInfCarga.Create;
  Fdet := TdetCollection.Create;
  FinfModal := TinfModal.Create;
  FCobr := TCobr.Create;
  FinfCteSub := TInfCteSub.Create;
  Ftotal := Ttotal.Create;
end;

destructor TCTe.Destroy;
begin
  FinfCTe.Free;
  Fide.Free;
  Fcompl.Free;

  Femit.Free;
  Ftoma.Free;
  Frem.Free;
  Fexped.Free;
  Freceb.Free;
  Fdest.Free;

  FvPrest.Free;
  Fimp.Free;

  FinfCTeNorm.Free;
  FInfCTeComp.Free;
  FInfCTeComp10.Free;
  FInfCTeAnu.Free;
  FautXML.Free;
  FinfRespTec.Free;
  FinfCTeSupl.Free;

  Forigem.Free;
  Fdestino.Free;
  FdetGTV.Free;

  FProcCTe.Free;
  Fsignature.Free;
  {
   CT-e Simplificado
  }
  FinfCarga.Free;
  Fdet.Free;
  FinfModal.Free;
  FCobr.Free;
  FinfCteSub.Free;
  Ftotal.Free;

  inherited Destroy;
end;

procedure TCTe.SetautXML(const Value: TautXMLCollection);
begin
  FautXML := Value;
end;

procedure TCTe.Setdet(const Value: TdetCollection);
begin
  Fdet := Value;
end;

procedure TCTe.SetinfCteComp10(const Value: TInfCteCompCollection);
begin
  FinfCteComp10 := Value;
end;

{ TInfCTe }
{
function TInfCTe.GetVersaoStr: string;
begin
  if FVersao <= 0 then
     Result := 'versao="2.00"'
  else
     Result := 'versao="' + FloatToString(FVersao, '.', '#0.00') + '"';
end;
}
{ TIde }

constructor TIde.Create;
begin
  inherited Create;

  FToma03 := TToma03.Create;
  FToma4 := TToma4.Create;
  FinfPercurso := TinfPercursoCollection.Create;
  FindGlobalizado := tiNao;
end;

destructor TIde.Destroy;
begin
  FToma03.Free;
  FToma4.Free;
  FinfPercurso.Free;

  inherited;
end;

procedure TIde.SetinfPercurso(Value: TinfPercursoCollection);
begin
  FinfPercurso.Assign(Value);
end;

{ TToma4 }

constructor TToma4.Create;
begin
  inherited Create;

  FEnderToma := TEndereco.Create;
end;

destructor TToma4.Destroy;
begin
  FEnderToma.Free;

  inherited;
end;

{ TinfPercursoCollection }

function TinfPercursoCollection.Add: TinfPercursoCollectionItem;
begin
  Result := Self.New;
end;

function TinfPercursoCollection.GetItem(
  Index: Integer): TinfPercursoCollectionItem;
begin
  Result := TinfPercursoCollectionItem(inherited Items[Index]);
end;

procedure TinfPercursoCollection.SetItem(Index: Integer;
  Value: TinfPercursoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TinfPercursoCollection.New: TinfPercursoCollectionItem;
begin
  Result := TinfPercursoCollectionItem.Create;
  Self.Add(Result);
end;

{ TCompl }

constructor TCompl.Create;
begin
  inherited Create;

  Ffluxo := TFluxo.Create;
  FEntrega := TEntrega.Create;
  FObsCont := TObsContCollection.Create;
  FObsFisco := TObsFiscoCollection.Create;
end;

destructor TCompl.Destroy;
begin
  Ffluxo.Free;
  FEntrega.Free;
  FObsCont.Free;
  FObsFisco.Free;

  inherited;
end;

procedure TCompl.SetObsCont(Value: TObsContCollection);
begin
 FObsCont.Assign(Value);
end;

procedure TCompl.SetObsFisco(Value: TObsFiscoCollection);
begin
 FObsFisco.Assign(Value);
end;

{ TFluxo }

constructor TFluxo.Create;
begin
  inherited Create;

  Fpass := TPassCollection.Create;
end;

destructor TFluxo.Destroy;
begin
  Fpass.Free;

  inherited;
end;

procedure TFluxo.SetPass(Value: TPassCollection);
begin
  Fpass.Assign(Value);
end;

{ TPassCollection }

function TPassCollection.Add: TPassCollectionItem;
begin
  Result := Self.New;
end;

function TPassCollection.GetItem(Index: Integer): TPassCollectionItem;
begin
  Result := TPassCollectionItem(inherited Items[Index]);
end;

procedure TPassCollection.SetItem(Index: Integer;
  Value: TPassCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TPassCollection.New: TPassCollectionItem;
begin
  Result := TPassCollectionItem.Create;
  Self.Add(Result);
end;

{ TEntrega }

constructor TEntrega.Create;
begin
  inherited Create;

  FsemData := TSemData.Create;
  FcomData := TComData.Create;
  FnoPeriodo := TNoPeriodo.Create;
  FsemHora := TSemHora.Create;
  FcomHora := TComHora.Create;
  FnoInter := TNoInter.Create;
end;

destructor TEntrega.Destroy;
begin
  FsemData.Free;
  FcomData.Free;
  FnoPeriodo.Free;
  FsemHora.Free;
  FcomHora.Free;
  FnoInter.Free;

  inherited;
end;

{ TObsContCollection }

function TObsContCollection.Add: TObsContCollectionItem;
begin
  Result := Self.New;
end;

function TObsContCollection.GetItem(
  Index: Integer): TObsContCollectionItem;
begin
  Result := TObsContCollectionItem(inherited Items[Index]);
end;

procedure TObsContCollection.SetItem(Index: Integer;
  Value: TObsContCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TObsContCollection.New: TObsContCollectionItem;
begin
  Result := TObsContCollectionItem.Create;
  Self.Add(Result);
end;

{ TEmit }

constructor TEmit.Create;
begin
  inherited Create;

  FEnderEmit := TEnderEmit.Create;
end;

destructor TEmit.Destroy;
begin
  FEnderEmit.Free;

  inherited;
end;

{ TRem }

constructor TRem.Create;
begin
  inherited Create;

  FEnderReme := TEndereco.Create;
  FlocColeta := TlocColeta.Create;
end;

destructor TRem.Destroy;
begin
  FEnderReme.Free;
  FlocColeta.Free;

  inherited;
end;

{ TExped }

constructor TExped.Create;
begin
  inherited Create;

  FEnderExped := TEndereco.Create;
end;

destructor TExped.Destroy;
begin
  FEnderExped.Free;

  inherited;
end;

{ TReceb }

constructor TReceb.Create;
begin
  inherited Create;

  FEnderReceb := TEndereco.Create;
end;

destructor TReceb.Destroy;
begin
  FEnderReceb.Free;

  inherited;
end;

{ TDest }

constructor TDest.Create;
begin
  inherited Create;

  FEnderDest := TEndereco.Create;
  FlocEnt := TlocEnt.Create;
end;

destructor TDest.Destroy;
begin
  FEnderDest.Free;
  FlocEnt.Free;

  inherited;
end;

{ TVPrest }

constructor TVPrest.Create;
begin
  inherited Create;

  FComp := TCompCollection.Create;
end;

destructor TVPrest.Destroy;
begin
  FComp.Free;

  inherited;
end;

procedure TVPrest.SetComp(const Value: TCompCollection);
begin
  Fcomp.Assign(Value);
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

procedure TCompCollection.SetItem(Index: Integer;
  Value: TCompCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TCompCollection.New: TCompCollectionItem;
begin
  Result := TCompCollectionItem.Create;
  Self.Add(Result);
end;

{ TImp }

constructor TImp.Create;
begin
  inherited Create;

  FICMS := TICMS.Create;
  FICMSUFFim := TICMSUFFim.Create;
  FinfTribFed := TinfTribFed.Create;
end;

destructor TImp.Destroy;
begin
  FICMS.free;
  FICMSUFFim.free;
  FinfTribFed.Free;

  inherited;
end;

{ TICMS }

constructor TICMS.Create;
begin
  inherited Create;

  FCST00   := TCST00.create;
  FCST20   := TCST20.create;
  FCST45   := TCST45.create;
  FCST60   := TCST60.create;
  FCST90   := TCST90.create;
  FICMSOutraUF := TICMSOutraUF.Create;
  FICMSSN  := TICMSSN.Create;
end;

destructor TICMS.Destroy;
begin
  FCST00.Free;
  FCST20.Free;
  FCST45.Free;
  FCST60.Free;
  FCST90.Free;
  FICMSOutraUF.Free;
  FICMSSN.Free;

  inherited;
end;

{ TInfCTeNorm }

constructor TInfCTeNorm.Create;
begin
  inherited Create;

  FinfCarga := TInfCarga.Create;
  FinfDoc := TInfDoc.Create;
  FdocAnt := TDocAnt.Create;
  Fseg  := TSegCollection.Create;

  Frodo   := TRodo.Create;
  FrodoOS := TRodoOS.Create;
  Faereo  := TAereo.Create;
  Faquav  := TAquav.Create;
  Fferrov := TFerrov.Create;
  Fduto   := TDuto.Create;
  Fmultimodal := TMultimodal.Create;

  Fperi := TPeriCollection.Create;
  FveicNovos := TVeicNovosCollection.Create;
  Fcobr  := TCobr.Create;
  FinfCteSub := TInfCteSub.Create;

  FinfGlobalizado := TinfGlobalizado.Create;
  FinfServVinc := TinfServVinc.Create;
  FinfDocRef  := TinfDocRefCollection.Create;
  FinfServico := TinfServico.Create;

  FinfGTVe := TinfGTVeCollection.Create;
end;

destructor TInfCTeNorm.Destroy;
begin
  FinfCarga.Free;
  FinfDoc.Free;
  FdocAnt.Free;
  Fseg.Free;

  Frodo.Free;
  FrodoOS.Free;
  Faereo.Free;
  Faquav.Free;
  Fferrov.Free;
  Fduto.Free;
  Fmultimodal.Free;

  Fperi.Free;
  FveicNovos.Free;
  Fcobr.Free;
  FinfCteSub.Free;
  FinfGlobalizado.Free;
  FinfServVinc.Free;
  FinfDocRef.Free;
  FinfServico.Free;
  FinfGTVe.Free;

  inherited;
end;

procedure TInfCTeNorm.SetSeg(const Value: TSegCollection);
begin
  Fseg := Value;
end;

procedure TInfCTeNorm.SetVeicNovos(const Value: TVeicNovosCollection);
begin
  FveicNovos := Value;
end;

procedure TInfCTeNorm.SetinfDocRef(const Value: TinfDocRefCollection);
begin
  FinfDocRef := Value;
end;

procedure TInfCTeNorm.SetinfGTVe(const Value: TinfGTVeCollection);
begin
  FinfGTVe := Value;
end;

procedure TInfCTeNorm.SetPeri(const Value: TPeriCollection);
begin
  Fperi := Value;
end;

{ TInfCarga }

constructor TInfCarga.Create;
begin
  inherited Create;

  FinfQ := TInfQCollection.Create;
end;

destructor TInfCarga.Destroy;
begin
  FinfQ.Free;

  inherited;
end;

procedure TInfCarga.SetInfQ(const Value: TInfQCollection);
begin
  FinfQ.Assign(Value);
end;

{ TInfQCollection }

function TInfQCollection.Add: TInfQCollectionItem;
begin
  Result := Self.New;
end;

function TInfQCollection.GetItem(Index: Integer): TInfQCollectionItem;
begin
  Result := TInfQCollectionItem(inherited Items[Index]);
end;

procedure TInfQCollection.SetItem(Index: Integer;
  Value: TInfQCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfQCollection.New: TInfQCollectionItem;
begin
  Result := TInfQCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfDoc }

constructor TInfDoc.Create;
begin
  inherited Create;

  FinfNF := TInfNFCollection.Create;
  FinfNFe := TInfNFeCollection.Create;
  FinfOutros := TInfOutrosCollection.Create;
end;

destructor TInfDoc.Destroy;
begin
  FinfNF.Free;
  FinfNFe.Free;
  FinfOutros.Free;

  inherited;
end;

procedure TInfDoc.SetInfNF(const Value: TInfNFCollection);
begin
  FinfNF.Assign(Value);
end;

procedure TInfDoc.SetInfNFe(const Value: TInfNFeCollection);
begin
  FinfNFe.Assign(Value);
end;

procedure TInfDoc.SetInfOutros(const Value: TInfOutrosCollection);
begin
  FinfOutros.Assign(Value);
end;

{ TInfNFCollection }

function TInfNFCollection.Add: TInfNFCollectionItem;
begin
  Result := Self.New;
end;

function TInfNFCollection.GetItem(Index: Integer): TInfNFCollectionItem;
begin
  Result := TInfNFCollectionItem(inherited Items[Index]);
end;

procedure TInfNFCollection.SetItem(Index: Integer;
  Value: TInfNFCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfNFCollection.New: TInfNFCollectionItem;
begin
  Result := TInfNFCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfNFCollectionItem }

constructor TInfNFCollectionItem.Create;
begin
  inherited Create;

  FinfUnidTransp := TInfUnidTranspNFCollection.Create;
  FinfUnidCarga := TInfUnidCargaNFCollection.Create;
end;

destructor TInfNFCollectionItem.Destroy;
begin
  FinfUnidTransp.Free;
  FinfUnidCarga.Free;

  inherited;
end;

{ TinfUnidTranspNFCollection }

function TinfUnidTranspNFCollection.Add: TinfUnidTranspCollectionItem;
begin
  Result := Self.New;
end;

function TinfUnidTranspNFCollection.GetItem(
  Index: Integer): TinfUnidTranspCollectionItem;
begin
  Result := TinfUnidTranspCollectionItem(inherited Items[Index]);
end;

procedure TinfUnidTranspNFCollection.SetItem(Index: Integer;
  Value: TinfUnidTranspCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TinfUnidTranspNFCollection.New: TinfUnidTranspCollectionItem;
begin
  Result := TinfUnidTranspCollectionItem.Create;
  Self.Add(Result);
end;

{ TinfUnidTranspCollectionItem }

constructor TinfUnidTranspCollectionItem.Create;
begin
  inherited Create;

  FlacUnidTransp := TlacUnidTranspCollection.Create;
  FinfUnidCarga := TinfUnidCargaCollection.Create;
end;

destructor TinfUnidTranspCollectionItem.Destroy;
begin
  FlacUnidTransp.Free;
  FinfUnidCarga.Free;

  inherited;
end;

{ TinfUnidCargaCollection }

function TinfUnidCargaCollection.Add: TinfUnidCargaCollectionItem;
begin
  Result := Self.New;
end;

function TinfUnidCargaCollection.GetItem(
  Index: Integer): TinfUnidCargaCollectionItem;
begin
  Result := TinfUnidCargaCollectionItem(inherited Items[Index]);
end;

procedure TinfUnidCargaCollection.SetItem(Index: Integer;
  Value: TinfUnidCargaCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TinfUnidCargaCollection.New: TinfUnidCargaCollectionItem;
begin
  Result := TinfUnidCargaCollectionItem.Create;
  Self.Add(Result);
end;

{ TinfUnidCargaCollectionItem }

constructor TinfUnidCargaCollectionItem.Create;
begin
  inherited Create;

  FlacUnidCarga := TlacUnidCargaCollection.Create;
end;

destructor TinfUnidCargaCollectionItem.Destroy;
begin
  FlacUnidCarga.Free;

  inherited;
end;

{ TInfNFeCollection }

function TInfNFeCollection.Add: TInfNFeCollectionItem;
begin
  Result := Self.New;
end;

function TInfNFeCollection.GetItem(Index: Integer): TInfNFeCollectionItem;
begin
  Result := TInfNFeCollectionItem(inherited Items[Index]);
end;

procedure TInfNFeCollection.SetItem(Index: Integer;
  Value: TInfNFeCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfNFeCollection.New: TInfNFeCollectionItem;
begin
  Result := TInfNFeCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfNFeCollectionItem }

constructor TInfNFeCollectionItem.Create;
begin
  inherited Create;

  FinfUnidTransp := TInfUnidTranspNFeCollection.Create;
  FinfUnidCarga := TInfUnidCargaNFeCollection.Create;
end;

destructor TInfNFeCollectionItem.Destroy;
begin
  FinfUnidTransp.Free;
  FinfUnidCarga.Free;

  inherited;
end;

{ TInfOutrosCollection }

function TInfOutrosCollection.Add: TInfOutrosCollectionItem;
begin
  Result := Self.New;
end;

function TInfOutrosCollection.GetItem(
  Index: Integer): TInfOutrosCollectionItem;
begin
  Result := TInfOutrosCollectionItem(inherited Items[Index]);
end;

procedure TInfOutrosCollection.SetItem(Index: Integer;
  Value: TInfOutrosCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfOutrosCollection.New: TInfOutrosCollectionItem;
begin
  Result := TInfOutrosCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfOutrosCollectionItem }

constructor TInfOutrosCollectionItem.Create;
begin
  inherited Create;

  FinfUnidTransp := TInfUnidTranspOutrosCollection.Create;
  FinfUnidCarga := TInfUnidCargaOutrosCollection.Create;
end;

destructor TInfOutrosCollectionItem.Destroy;
begin
  FinfUnidTransp.Free;
  FinfUnidCarga.Free;

  inherited;
end;

{ TinfUnidTranspOutrosCollection }

function TinfUnidTranspOutrosCollection.Add: TinfUnidTranspCollectionItem;
begin
  Result := Self.New;
end;

function TinfUnidTranspOutrosCollection.GetItem(
  Index: Integer): TinfUnidTranspCollectionItem;
begin
  Result := TinfUnidTranspCollectionItem(inherited Items[Index]);
end;

procedure TinfUnidTranspOutrosCollection.SetItem(Index: Integer;
  Value: TinfUnidTranspCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TinfUnidTranspOutrosCollection.New: TinfUnidTranspCollectionItem;
begin
  Result := TinfUnidTranspCollectionItem.Create;
  Self.Add(Result);
end;

{ TDocAnt }

constructor TDocAnt.Create;
begin
  inherited Create;

  FemiDocAnt := TEmiDocAntCollection.Create;
end;

destructor TDocAnt.Destroy;
begin
  FemiDocAnt.Free;

  inherited;
end;

procedure TDocAnt.SetEmiDocAnt(const Value: TEmiDocAntCollection);
begin
 FEmiDocAnt.Assign(Value);
end;

{ TEmiDocAntCollection }

function TEmiDocAntCollection.Add: TEmiDocAntCollectionItem;
begin
  Result := Self.New;
end;

function TEmiDocAntCollection.GetItem(
  Index: Integer): TEmiDocAntCollectionItem;
begin
  Result := TemiDocAntCollectionItem(inherited Items[Index]);
end;

procedure TEmiDocAntCollection.SetItem(Index: Integer;
  Value: TEmiDocAntCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TEmiDocAntCollection.New: TEmiDocAntCollectionItem;
begin
  Result := TEmiDocAntCollectionItem.Create;
  Self.Add(Result);
end;

{ TEmiDocAntCollectionItem }

constructor TEmiDocAntCollectionItem.Create;
begin
  inherited Create;

  FidDocAnt := TidDocAntCollection.Create;
end;

destructor TEmiDocAntCollectionItem.Destroy;
begin
  FidDocAnt.Free;

  inherited;
end;

procedure TEmiDocAntCollectionItem.SetIdDocAnt(
  const Value: TIdDocAntCollection);
begin
  FidDocAnt.Assign(Value);
end;

{ TIdDocAntCollection }

function TIdDocAntCollection.Add: TIdDocAntCollectionItem;
begin
  Result := Self.New;
end;

function TIdDocAntCollection.GetItem(
  Index: Integer): TIdDocAntCollectionItem;
begin
  Result := TidDocAntCollectionItem(inherited Items[Index]);
end;

procedure TIdDocAntCollection.SetItem(Index: Integer;
  Value: TIdDocAntCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TIdDocAntCollection.New: TIdDocAntCollectionItem;
begin
  Result := TIdDocAntCollectionItem.Create;
  Self.Add(Result);
end;

{ TIdDocAntCollectionItem }

constructor TIdDocAntCollectionItem.Create;
begin
  inherited Create;

  FidDocAntPap := TidDocAntPapCollection.Create;
  FidDocAntEle := TidDocAntEleCollection.Create;
end;

destructor TIdDocAntCollectionItem.Destroy;
begin
  FidDocAntPap.Free;
  FidDocAntEle.Free;

  inherited;
end;

procedure TIdDocAntCollectionItem.SetIdDocAntPap(
  const Value: TIdDocAntPapCollection);
begin
 FidDocAntPap.Assign(Value);
end;

procedure TIdDocAntCollectionItem.SetIdDocAntEle(
  const Value: TIdDocAntEleCollection);
begin
 FidDocAntEle.Assign(Value);
end;

{ TIdDocAntPapCollection }

function TIdDocAntPapCollection.Add: TIdDocAntPapCollectionItem;
begin
  Result := Self.New;
end;

function TIdDocAntPapCollection.GetItem(
  Index: Integer): TIdDocAntPapCollectionItem;
begin
  Result := TidDocAntPapCollectionItem(inherited Items[Index]);
end;

procedure TIdDocAntPapCollection.SetItem(Index: Integer;
  Value: TIdDocAntPapCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TIdDocAntPapCollection.New: TIdDocAntPapCollectionItem;
begin
  Result := TIdDocAntPapCollectionItem.Create;
  Self.Add(Result);
end;

{ TIdDocAntEleCollection }

function TIdDocAntEleCollection.Add: TIdDocAntEleCollectionItem;
begin
  Result := Self.New;
end;

function TIdDocAntEleCollection.GetItem(
  Index: Integer): TIdDocAntEleCollectionItem;
begin
  Result := TidDocAntEleCollectionItem(inherited Items[Index]);
end;

procedure TIdDocAntEleCollection.SetItem(Index: Integer;
  Value: TIdDocAntEleCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TIdDocAntEleCollection.New: TIdDocAntEleCollectionItem;
begin
  Result := TIdDocAntEleCollectionItem.Create;
  Self.Add(Result);
end;

{ TSegCollection }

function TSegCollection.Add: TSegCollectionItem;
begin
  Result := Self.New;
end;

function TSegCollection.GetItem(Index: Integer): TSegCollectionItem;
begin
  Result := TSegCollectionItem(inherited Items[Index]);
end;

procedure TSegCollection.SetItem(Index: Integer;
  Value: TSegCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TSegCollection.New: TSegCollectionItem;
begin
  Result := TSegCollectionItem.Create;
  Self.Add(Result);
end;

{ TRodo }

constructor TRodo.Create;
begin
  inherited Create;

  Focc := TOccCollection.Create;
  FvalePed := TValePedCollection.Create;
  Fveic := TVeicCollection.Create;
  FlacRodo := TLacRodoCollection.Create;
  Fmoto := TMotoCollection.Create;
end;

destructor TRodo.Destroy;
begin
  Focc.Free;
  FvalePed.Free;
  Fveic.Free;
  FlacRodo.Free;
  Fmoto.Free;

  inherited;
end;

procedure TRodo.SetOcc(const Value: TOccCollection);
begin
 Focc.Assign(Value);
end;

procedure TRodo.SetValePed(const Value: TValePedCollection);
begin
 FvalePed.Assign(Value);
end;

procedure TRodo.SetVeic(const Value: TVeicCollection);
begin
 Fveic.Assign(Value);
end;

procedure TRodo.SetLacRodo(const Value: TLacRodoCollection);
begin
  FlacRodo.Assign(Value);
end;

procedure TRodo.SetMoto(const Value: TMotoCollection);
begin
 Fmoto.Assign(Value);
end;

{ TOccCollection }

function TOccCollection.Add: TOccCollectionItem;
begin
  Result := Self.New;
end;

function TOccCollection.GetItem(Index: Integer): TOccCollectionItem;
begin
  Result := TOccCollectionItem(inherited Items[Index]);
end;

procedure TOccCollection.SetItem(Index: Integer;
  Value: TOccCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TOccCollection.New: TOccCollectionItem;
begin
  Result := TOccCollectionItem.Create;
  Self.Add(Result);
end;

{ TOccCollectionItem }

constructor TOccCollectionItem.Create;
begin
  inherited Create;

  FemiOCC := TEmiOCC.Create;
end;

destructor TOccCollectionItem.Destroy;
begin
  FemiOCC.Free;

  inherited;
end;

{ TValePedCollection }

function TValePedCollection.Add: TValePedCollectionItem;
begin
  Result := Self.New;
end;

function TValePedCollection.GetItem(
  Index: Integer): TValePedCollectionItem;
begin
  Result := TValePedCollectionItem(inherited Items[Index]);
end;

procedure TValePedCollection.SetItem(Index: Integer;
  Value: TValePedCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TValePedCollection.New: TValePedCollectionItem;
begin
  Result := TValePedCollectionItem.Create;
  Self.Add(Result);
end;

{ TVeicCollection }

function TVeicCollection.Add: TVeicCollectionItem;
begin
  Result := Self.New;
end;

function TVeicCollection.GetItem(Index: Integer): TVeicCollectionItem;
begin
  Result := TVeicCollectionItem(inherited Items[Index]);
end;

procedure TVeicCollection.SetItem(Index: Integer;
  Value: TVeicCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TVeicCollection.New: TVeicCollectionItem;
begin
  Result := TVeicCollectionItem.Create;
  Self.Add(Result);
end;

{ TVeicCollectionItem }

constructor TVeicCollectionItem.Create;
begin
  inherited Create;

  Fprop := TProp.Create;
end;

destructor TVeicCollectionItem.Destroy;
begin
  Fprop.Free;

  inherited;
end;

{ TMotoCollection }

function TMotoCollection.Add: TMotoCollectionItem;
begin
  Result := Self.New;
end;

function TMotoCollection.GetItem(Index: Integer): TMotoCollectionItem;
begin
  Result := TMotoCollectionItem(inherited Items[Index]);
end;

procedure TMotoCollection.SetItem(Index: Integer;
  Value: TMotoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TMotoCollection.New: TMotoCollectionItem;
begin
  Result := TMotoCollectionItem.Create;
  Self.Add(Result);
end;

{ TAereo }

constructor TAereo.Create;
begin
  inherited Create;

  Ftarifa := TTarifa.Create;
  FnatCarga := TNatCarga.Create;
  Fperi := TPeriCollection.Create;
end;

destructor TAereo.Destroy;
begin
  Ftarifa.Free;
  FnatCarga.Free;
  Fperi.Free;

  inherited;
end;

procedure TAereo.SetPeri(const Value: TPeriCollection);
begin
  Fperi := Value;
end;

constructor TNatCarga.Create;
begin
  inherited Create;

  FcinfManu := TpInfManuCollection.Create;
end;

destructor TNatCarga.Destroy;
begin
  FcinfManu.Free;

  inherited Destroy;
end;

procedure TNatCarga.SetcinfManu(const Value: TpInfManuCollection);
begin
  FcInfManu.Assign(Value);
end;

{ TpInfManuCollection }

function TpInfManuCollection.Add: TpInfManuCollectionItem;
begin
  Result := Self.New;
end;

function TpInfManuCollection.GetItem(Index: Integer): TpInfManuCollectionItem;
begin
  Result := TpInfManuCollectionItem(inherited Items[Index]);
end;

procedure TpInfManuCollection.SetItem(Index: Integer; Value: TpInfManuCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TpInfManuCollection.New: TpInfManuCollectionItem;
begin
  Result := TpInfManuCollectionItem.Create;
  Self.Add(Result);
end;

{ TAquav }

constructor TAquav.Create;
begin
  inherited Create;

  Fbalsa := TBalsaCollection.Create;
  FdetCont := TdetContCollection.Create;
end;

destructor TAquav.Destroy;
begin
  Fbalsa.Free;
  FdetCont.Free;

  inherited;
end;

procedure TAquav.SetBalsa(const Value: TbalsaCollection);
begin
  Fbalsa.Assign(Value);
end;

procedure TAquav.SetdetCont(const Value: TdetContCollection);
begin
  FdetCont := Value;
end;

{ TBalsaCollection }

function TBalsaCollection.Add: TBalsaCollectionItem;
begin
  Result := Self.New;
end;

function TBalsaCollection.GetItem(Index: Integer): TBalsaCollectionItem;
begin
  Result := TBalsaCollectionItem(inherited Items[Index]);
end;

procedure TBalsaCollection.SetItem(Index: Integer;
  Value: TBalsaCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TBalsaCollection.New: TBalsaCollectionItem;
begin
  Result := TBalsaCollectionItem.Create;
  Self.Add(Result);
end;

{ TdetContCollection }

function TdetContCollection.Add: TdetContCollectionItem;
begin
  Result := Self.New;
end;

function TdetContCollection.GetItem(
  Index: Integer): TdetContCollectionItem;
begin
  Result := TdetContCollectionItem(inherited Items[Index]);
end;

procedure TdetContCollection.SetItem(Index: Integer;
  Value: TdetContCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TdetContCollection.New: TdetContCollectionItem;
begin
  Result := TdetContCollectionItem.Create;
  Self.Add(Result);
end;

{ TdetContCollectionItem }

constructor TdetContCollectionItem.Create;
begin
  inherited Create;

  FLacre := TLacreCollection.Create;
  FinfDoc := TInfDocAquav.Create;
end;

destructor TdetContCollectionItem.Destroy;
begin
  FLacre.Free;
  FinfDoc.Free;

  inherited;
end;

{ TLacreCollection }

function TLacreCollection.Add: TLacreCollectionItem;
begin
  Result := Self.New;
end;

function TLacreCollection.GetItem(Index: Integer): TLacreCollectionItem;
begin
  Result := TLacreCollectionItem(inherited Items[Index]);
end;

procedure TLacreCollection.SetItem(Index: Integer;
  Value: TLacreCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TLacreCollection.New: TLacreCollectionItem;
begin
  Result := TLacreCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfDocAquav }

constructor TInfDocAquav.Create;
begin
  inherited Create;

  FinfNF := TinfNFAquavCollection.Create;
  FinfNFe := TinfNFeAquavCollection.Create;
end;

destructor TInfDocAquav.Destroy;
begin
  FinfNF.Free;
  FinfNFe.Free;

  inherited;
end;

{ TInfNFAquavCollection }

function TInfNFAquavCollection.Add: TInfNFAquavCollectionItem;
begin
  Result := Self.New;
end;

function TInfNFAquavCollection.GetItem(
  Index: Integer): TInfNFAquavCollectionItem;
begin
  Result := TinfNFAquavCollectionItem(inherited Items[Index]);
end;

procedure TInfNFAquavCollection.SetItem(Index: Integer;
  Value: TInfNFAquavCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfNFAquavCollection.New: TInfNFAquavCollectionItem;
begin
  Result := TInfNFAquavCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfNFeAquavCollection }

function TInfNFeAquavCollection.Add: TInfNFeAquavCollectionItem;
begin
  Result := Self.New;
end;

function TInfNFeAquavCollection.GetItem(
  Index: Integer): TInfNFeAquavCollectionItem;
begin
  Result := TinfNFeAquavCollectionItem(inherited Items[Index]);
end;

procedure TInfNFeAquavCollection.SetItem(Index: Integer;
  Value: TInfNFeAquavCollectionItem);
begin
  inherited Items[Index] := Value;
end;

//////////////////////////////////////////////////////////////////////////////
function TInfNFeAquavCollection.New: TInfNFeAquavCollectionItem;
begin
  Result := TInfNFeAquavCollectionItem.Create;
  Self.Add(Result);
end;

{ TFerrov }

constructor TFerrov.Create;
begin
  inherited Create;

  FtrafMut := TTrafMut.Create;
  FferroEnv := TFerroEnvCollection.Create;
  FdetVag := TDetVagCollection.Create;
end;

destructor TFerrov.Destroy;
begin
  FtrafMut.Free;
  FferroEnv.Free;
  FdetVag.Free;

  inherited;
end;

procedure TFerrov.SetFerroEnv(const Value: TFerroEnvCollection);
begin
 FferroEnv.Assign(Value);
end;

procedure TFerrov.SetDetVag(const Value: TDetVagCollection);
begin
 FdetVag.Assign(Value);
end;

{ TFerroEnvCollection }

function TFerroEnvCollection.Add: TFerroEnvCollectionItem;
begin
  Result := Self.New;
end;

function TFerroEnvCollection.GetItem(
  Index: Integer): TFerroEnvCollectionItem;
begin
  Result := TFerroEnvCollectionItem(inherited Items[Index]);
end;

procedure TFerroEnvCollection.SetItem(Index: Integer;
  Value: TFerroEnvCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TFerroEnvCollection.New: TFerroEnvCollectionItem;
begin
  Result := TFerroEnvCollectionItem.Create;
  Self.Add(Result);
end;

{ TFerroEnvCollectionItem }

constructor TFerroEnvCollectionItem.Create;
begin
  inherited Create;

  FenderFerro := TEnderFerro.Create;
end;

destructor TFerroEnvCollectionItem.Destroy;
begin
  FenderFerro.Free;

  inherited;
end;

{ TDetVagCollection }

function TDetVagCollection.Add: TDetVagCollectionItem;
begin
  Result := Self.New;
end;

function TDetVagCollection.GetItem(Index: Integer): TDetVagCollectionItem;
begin
  Result := TDetVagCollectionItem(inherited Items[Index]);
end;

procedure TDetVagCollection.SetItem(Index: Integer;
  Value: TDetVagCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TDetVagCollection.New: TDetVagCollectionItem;
begin
  Result := TDetVagCollectionItem.Create;
  Self.Add(Result);
end;

{ TPeriCollection }

function TPeriCollection.Add: TPeriCollectionItem;
begin
  Result := Self.New;
end;

function TPeriCollection.GetItem(Index: Integer): TPeriCollectionItem;
begin
  Result := TPeriCollectionItem(inherited Items[Index]);
end;

procedure TPeriCollection.SetItem(Index: Integer;
  Value: TPeriCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TPeriCollection.New: TPeriCollectionItem;
begin
  Result := TPeriCollectionItem.Create;
  Self.Add(Result);
end;

{ TVeicNovosCollection }

function TVeicNovosCollection.Add: TVeicNovosCollectionItem;
begin
  Result := Self.New;
end;

function TVeicNovosCollection.GetItem(
  Index: Integer): TVeicNovosCollectionItem;
begin
  Result := TVeicNovosCollectionItem(inherited Items[Index]);
end;

procedure TVeicNovosCollection.SetItem(Index: Integer;
  Value: TVeicNovosCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TVeicNovosCollection.New: TVeicNovosCollectionItem;
begin
  Result := TVeicNovosCollectionItem.Create;
  Self.Add(Result);
end;

{ TCobr }

constructor TCobr.Create;
begin
  inherited Create;

  Ffat := TFat.Create;
  Fdup := TDupCollection.Create;
end;

destructor TCobr.Destroy;
begin
  Ffat.Free;
  Fdup.Free;

  inherited;
end;

procedure TCobr.SetDup(Value: TDupCollection);
begin
  Fdup.Assign(Value);
end;

{ TDupCollection }

function TDupCollection.Add: TDupCollectionItem;
begin
  Result := Self.New;
end;

function TDupCollection.GetItem(Index: Integer): TDupCollectionItem;
begin
  Result := TDupCollectionItem(inherited Items[Index]);
end;

procedure TDupCollection.SetItem(Index: Integer;
  Value: TDupCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TDupCollection.New: TDupCollectionItem;
begin
  Result := TDupCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfCteSub }

constructor TInfCteSub.Create;
begin
  inherited Create;

  FtomaICMS := TTomaICMS.Create;
  FtomaNaoICMS := TTomaNaoICMS.Create;
  FindAlteraToma := tiNao;
end;

destructor TInfCteSub.Destroy;
begin
  FtomaICMS.Free;
  FtomaNaoICMS.Free;

  inherited;
end;

{ TTomaICMS }

constructor TTomaICMS.Create;
begin
  inherited Create;

  FrefNF := TRefNF.Create;
end;

destructor TTomaICMS.Destroy;
begin
  FrefNF.Free;

  inherited;
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

{ TInfCTeMultimodalCollection }

function TInfCTeMultimodalCollection.Add: TInfCTeMultimodalCollectionItem;
begin
  Result := Self.New;
end;

function TInfCTeMultimodalCollection.GetItem(
  Index: Integer): TInfCTeMultimodalCollectionItem;
begin
  Result := TInfCTeMultimodalCollectionItem(inherited Items[Index]);
end;

procedure TInfCTeMultimodalCollection.SetItem(Index: Integer;
  Value: TInfCTeMultimodalCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfCTeMultimodalCollection.New: TInfCTeMultimodalCollectionItem;
begin
  Result := TinfCTeMultimodalCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfServVinc }

constructor TInfServVinc.Create;
begin
  inherited Create;

  FinfCTeMultimodal := TinfCTeMultimodalCollection.Create;
end;

destructor TInfServVinc.Destroy;
begin
  FinfCTeMultimodal.Free;

  inherited;
end;

{ TToma }

constructor TToma.Create;
begin
  inherited Create;

  FEnderToma := TEndereco.Create;
end;

destructor TToma.Destroy;
begin
  FEnderToma.Free;

  inherited;
end;

{ TinfDocRefCollection }

function TinfDocRefCollection.Add: TinfDocRefCollectionItem;
begin
  Result := Self.New;
end;

function TinfDocRefCollection.GetItem(
  Index: Integer): TinfDocRefCollectionItem;
begin
  Result := TinfDocRefCollectionItem(inherited Items[Index]);
end;

procedure TinfDocRefCollection.SetItem(Index: Integer;
  Value: TinfDocRefCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TinfDocRefCollection.New: TinfDocRefCollectionItem;
begin
  Result := TinfDocRefCollectionItem.Create;
  Self.Add(Result);
end;

{ TVeicOS }

constructor TVeicOS.Create;
begin
  inherited Create;

  Fprop := TPropOS.Create;
end;

destructor TVeicOS.Destroy;
begin
  Fprop.Free;

  inherited;
end;

{ TRodoOS }

constructor TRodoOS.Create;
begin
  inherited Create;

  Fveic := TVeicOS.Create;
  FinfFretamento := TinfFretamento.Create;
end;

destructor TRodoOS.Destroy;
begin
  Fveic.Free;
  FinfFretamento.Free;

  inherited;
end;

{ TinfGTVeCollection }

function TinfGTVeCollection.Add: TinfGTVeCollectionItem;
begin
  Result := Self.New;
end;

function TinfGTVeCollection.GetItem(Index: Integer): TinfGTVeCollectionItem;
begin
  Result := TinfGTVeCollectionItem(inherited Items[Index]);
end;

function TinfGTVeCollection.New: TinfGTVeCollectionItem;
begin
  Result := TinfGTVeCollectionItem.Create;
  Self.Add(Result);
end;

procedure TinfGTVeCollection.SetItem(Index: Integer;
  Value: TinfGTVeCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TinfGTVeCollectionItem }

constructor TinfGTVeCollectionItem.Create;
begin
  inherited Create;

  FComp := TinfGTVeCompCollection.Create;
end;

destructor TinfGTVeCollectionItem.Destroy;
begin
  FComp.Free;

  inherited;
end;

procedure TinfGTVeCollectionItem.SetComp(const Value: TinfGTVeCompCollection);
begin
  FComp := Value;
end;

{ TinfGTVeCompCollection }

function TinfGTVeCompCollection.Add: TinfGTVeCompCollectionItem;
begin
  Result := Self.New;
end;

function TinfGTVeCompCollection.GetItem(
  Index: Integer): TinfGTVeCompCollectionItem;
begin
  Result := TinfGTVeCompCollectionItem(inherited Items[Index]);
end;

function TinfGTVeCompCollection.New: TinfGTVeCompCollectionItem;
begin
  Result := TinfGTVeCompCollectionItem.Create;
  Self.Add(Result);
end;

procedure TinfGTVeCompCollection.SetItem(Index: Integer;
  Value: TinfGTVeCompCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TinfEspecieCollection }

function TinfEspecieCollection.Add: TinfEspecieCollectionItem;
begin
  Result := Self.New;
end;

function TinfEspecieCollection.GetItem(
  Index: Integer): TinfEspecieCollectionItem;
begin
  Result := TinfEspecieCollectionItem(inherited Items[Index]);
end;

function TinfEspecieCollection.New: TinfEspecieCollectionItem;
begin
  Result := TinfEspecieCollectionItem.Create;
  Self.Add(Result);
end;

procedure TinfEspecieCollection.SetItem(Index: Integer;
  Value: TinfEspecieCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TdetGTV }

constructor TdetGTV.Create;
begin
  inherited Create;

  FinfEspecie := TinfEspecieCollection.Create;
  FinfVeiculo := TinfVeiculoCollection.Create;
end;

destructor TdetGTV.Destroy;
begin
  FinfEspecie.Free;
  FinfVeiculo.Free;

  inherited;
end;

procedure TdetGTV.SetinfEspecie(const Value: TinfEspecieCollection);
begin
  FinfEspecie := Value;
end;

procedure TdetGTV.SetinfVeiculo(const Value: TinfVeiculoCollection);
begin
  FinfVeiculo := Value;
end;

{ TinfVeiculoCollection }

function TinfVeiculoCollection.Add: TinfVeiculoCollectionItem;
begin
  Result := Self.New;
end;

function TinfVeiculoCollection.GetItem(
  Index: Integer): TinfVeiculoCollectionItem;
begin
  Result := TinfVeiculoCollectionItem(inherited Items[Index]);
end;

function TinfVeiculoCollection.New: TinfVeiculoCollectionItem;
begin
  Result := TinfVeiculoCollectionItem.Create;
  Self.Add(Result);
end;

procedure TinfVeiculoCollection.SetItem(Index: Integer;
  Value: TinfVeiculoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TInfCteCompCollection }

function TInfCteCompCollection.Add: TInfCteCompCollectionItem;
begin
  Result := Self.New;
end;

function TInfCteCompCollection.GetItem(
  Index: Integer): TInfCteCompCollectionItem;
begin
  Result := TInfCteCompCollectionItem(inherited Items[Index]);
end;

function TInfCteCompCollection.New: TInfCteCompCollectionItem;
begin
  Result := TInfCteCompCollectionItem.Create;
  Self.Add(Result);
end;

procedure TInfCteCompCollection.SetItem(Index: Integer;
  Value: TInfCteCompCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TdetCollectionItem }

constructor TdetCollectionItem.Create;
begin
  inherited Create;

  FComp := TCompCollection.Create;
  FinfNFe := TInfNFeCollection.Create;
  FinfdocAnt := TInfDocAntCollection.Create;
end;

destructor TdetCollectionItem.Destroy;
begin
  FComp.Free;
  FinfNFe.Free;
  FinfdocAnt.Free;

  inherited;
end;

procedure TdetCollectionItem.SetComp(const Value: TCompCollection);
begin
  FComp := Value;
end;

procedure TdetCollectionItem.SetinfdocAnt(const Value: TInfDocAntCollection);
begin
  FinfdocAnt := Value;
end;

procedure TdetCollectionItem.SetInfNFe(const Value: TInfNFeCollection);
begin
  FinfNFe := Value;
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

{ TinfNFeTranspParcialCollection }

function TinfNFeTranspParcialCollection.Add: TinfNFeTranspParcialCollectionItem;
begin
  Result := Self.New;
end;

function TinfNFeTranspParcialCollection.GetItem(
  Index: Integer): TinfNFeTranspParcialCollectionItem;
begin
  Result := TinfNFeTranspParcialCollectionItem(inherited Items[Index]);
end;

function TinfNFeTranspParcialCollection.New: TinfNFeTranspParcialCollectionItem;
begin
  Result := TinfNFeTranspParcialCollectionItem.Create;
  Self.Add(Result);
end;

procedure TinfNFeTranspParcialCollection.SetItem(Index: Integer;
  Value: TinfNFeTranspParcialCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TinfDocAntCollectionItem }

constructor TinfDocAntCollectionItem.Create;
begin
  inherited Create;

  FinfNFeTranspParcial := TinfNFeTranspParcialCollection.Create;
end;

destructor TinfDocAntCollectionItem.Destroy;
begin
  FinfNFeTranspParcial.Free;

  inherited;
end;

procedure TinfDocAntCollectionItem.SetinfNFeTranspParcial(
  const Value: TinfNFeTranspParcialCollection);
begin
  FinfNFeTranspParcial := Value;
end;

{ TinfDocAntCollection }

function TinfDocAntCollection.Add: TinfDocAntCollectionItem;
begin
  Result := Self.New;
end;

function TinfDocAntCollection.GetItem(Index: Integer): TinfDocAntCollectionItem;
begin
  Result := TinfDocAntCollectionItem(inherited Items[Index]);
end;

function TinfDocAntCollection.New: TinfDocAntCollectionItem;
begin
  Result := TinfDocAntCollectionItem.Create;
  Self.Add(Result);
end;

procedure TinfDocAntCollection.SetItem(Index: Integer;
  Value: TinfDocAntCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TinfModal }

constructor TinfModal.Create;
begin
  inherited Create;

  Faereo := TAereo.Create;
  Faquav := TAquav.Create;
  Frodo := TRodo.Create;
end;

destructor TinfModal.Destroy;
begin
  Faereo.Free;
  Faquav.Free;
  Frodo.Free;

  inherited;
end;

end.
