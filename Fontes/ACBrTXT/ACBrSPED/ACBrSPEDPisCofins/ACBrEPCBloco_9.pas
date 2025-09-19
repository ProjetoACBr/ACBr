{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro e Claudio Roberto de Souza      }
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

unit ACBrEPCBloco_9;

{$I ACBr.inc}

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrEPCBlocos;

type
  TRegistro9900List = class;

  //REGISTRO 9001: ABERTURA DO BLOCO 9
  TRegistro9001 = class(TOpenBlocos)
  private
    FRegistro9900: TRegistro9900List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property Registro9900: TRegistro9900List read FRegistro9900 write FRegistro9900;
  end;

  //REGISTRO 9900: REGISTROS DO ARQUIVO
  TRegistro9900 = class
  private
    fREG_BLC: string;	            //02	REG_BLC	Registro que ser� totalizado no pr�ximo campo.	C	004	-
    fQTD_REG_BLC: Integer;        //03	QTD_REG_BLC	Total de registros do tipo informado no campo anterior.	N	-	-
  public
    property REG_BLC: string read FREG_BLC write FREG_BLC;
    property QTD_REG_BLC: Integer read FQTD_REG_BLC write FQTD_REG_BLC;
  end;

  // Registro 9900 - Lista
  TRegistro9900List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro9900;
    procedure SetItem(Index: Integer; const Value: TRegistro9900);
  public
    function New: TRegistro9900;
    property Items[Index: Integer]: TRegistro9900 read GetItem write SetItem;
  end;

  //REGISTRO 9990: ENCERRAMENTO DO BLOCO 9
  TRegistro9990 = class
  private
    fQTD_LIN_9: Integer;       //02	QTD_LIN_9	Quantidade total de linhas do Bloco 9.	N	-	-
  public
    property QTD_LIN_9: Integer read FQTD_LIN_9 write FQTD_LIN_9;
  end;

  //REGISTRO 9999: ENCERRAMENTO DO ARQUIVO DIGITAL
  TRegistro9999 = class
  private
    fQTD_LIN: Integer;     //02	QTD_LIN	Quantidade total de linhas do arquivo digital.	N	-	-
  public
    property QTD_LIN: Integer read FQTD_LIN write FQTD_LIN;
  end;

implementation

{ TRegistro9001 }

constructor TRegistro9001.Create;
begin
  inherited Create;
  FRegistro9900 := TRegistro9900List.Create;
end;

destructor TRegistro9001.Destroy;
begin
  FRegistro9900.Free;
  inherited;
end;

{ TRegistro9990 }

function TRegistro9900List.GetItem(Index: Integer): TRegistro9900;
begin
  Result := TRegistro9900(Inherited Items[Index]);
end;

function TRegistro9900List.New: TRegistro9900;
begin
  Result := TRegistro9900.Create;
  Add(Result);
end;

procedure TRegistro9900List.SetItem(Index: Integer; const Value: TRegistro9900);
begin
  Put(Index, Value);
end;

end.
