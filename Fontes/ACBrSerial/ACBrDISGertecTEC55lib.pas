{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Igor Faria                                      }
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

unit ACBrDISGertecTEC55lib;

interface
uses
  Classes,
  ACBrDISClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

{ Nota: - Essa Unit depende da DLL da Gertec tec55.dll, a qual é carregada
  dinamicamente ao Ativar }

const
  CTEC55LIB = 'tec55.dll';

type

{ TACBrDISGertecTEC55lib }

TACBrDISGertecTEC55lib = class( TACBrDISClass )
  private
      xOpenTec55 : function : integer; stdcall;
      XCloseTec55: function : integer; stdcall;
      xGoToXY : function (lin, col: integer): integer; stdcall;
      xDispStr : function (Str: PAnsiChar): integer; stdcall;
      xFormFeed : function : integer; stdcall;

      procedure FunctionDetectLib(const FuncName: String; var LibPointer: Pointer);
      procedure LoadDLLFunctions;
      procedure UnLoadDLLFunctions;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Ativar ; override ;
    procedure Desativar; override;

    procedure LimparDisplay ; override ;

    procedure PosicionarCursor(Linha, Coluna: Integer ) ; override ;
    procedure Escrever( const Texto : String ) ; override ;
end ;

implementation
Uses ACBrUtil.Strings,
     ACBrUtil.FilesIO,
     SysUtils,
     {$IFDEF COMPILER6_UP} DateUtils {$ELSE} ACBrD5, Windows{$ENDIF} ;

{ ACBrDISGertecTEC55lib}

constructor TACBrDISGertecTEC55lib.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  fpModeloStr := 'GertecTeclado55lib' ;
  LinhasCount := 4 ;
  Colunas     := 33 ;
  fpIntervaloEnvioBytes := 0;
end;

destructor TACBrDISGertecTEC55lib.Destroy;
begin
  UnLoadDLLFunctions;
  inherited Destroy;
end;


procedure TACBrDISGertecTEC55lib.LimparDisplay;
begin
  if Assigned(xFormFeed) then
    xFormFeed ;
end;

procedure TACBrDISGertecTEC55lib.PosicionarCursor(Linha, Coluna: Integer);
begin
  if Assigned(xGoToXY) then
    xGoToXY( Linha, Coluna);
end;

procedure TACBrDISGertecTEC55lib.Escrever(const Texto: String);
begin
  if Assigned(xDispStr) then
    xDispStr( PAnsiChar( AnsiString(ACBrStrToAnsi(Texto))) );
end;

procedure TACBrDISGertecTEC55lib.Ativar;
begin
  LoadDLLFunctions;
  xOpenTec55;
  fpAtivo := true ;
end;

procedure TACBrDISGertecTEC55lib.Desativar;
begin
  if Assigned(XCloseTec55) then
    XCloseTec55;

  UnLoadDLLFunctions;
  fpAtivo := false ;
end;

procedure TACBrDISGertecTEC55lib.LoadDLLFunctions;
begin
  FunctionDetectLib( 'OpenTec55',  @xOpenTec55 );
  FunctionDetectLib( 'CloseTec55', @XCloseTec55 );
  FunctionDetectLib( 'GoToXY',     @xGoToXY) ;
  FunctionDetectLib( 'DispStr',    @xDispStr);
  FunctionDetectLib( 'FormFeed',   @xFormFeed);
end;

procedure TACBrDISGertecTEC55lib.FunctionDetectLib(const FuncName : String ;
  var LibPointer : Pointer) ;
begin
  if not Assigned( LibPointer )  then
  begin
    if not FunctionDetect( CTEC55LIB, FuncName, LibPointer) then
    begin
       LibPointer := NIL ;
       raise EACBrDISErro.Create( ACBrStr(Format('Erro ao carregar a função: %s na Biblioteca: %s', [FuncName,CTEC55LIB])) ) ;
    end ;
  end ;
end ;

procedure TACBrDISGertecTEC55lib.UnLoadDLLFunctions;
begin
  if not Assigned(xOpenTec55) then
    Exit;

  UnLoadLibrary( CTEC55LIB );

  xOpenTec55  := Nil;
  XCloseTec55 := Nil;
  xGoToXY     := Nil;
  xDispStr    := Nil;
  xFormFeed   := Nil;
end;



end.
