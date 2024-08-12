{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Teno Dias                                }
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

unit ACBrDeviceConfig;

interface

uses
  Classes, SysUtils, IniFiles;

type

  { TDeviceConfig }

  TDeviceConfig = class
  private
    FSessao: String;
    FBaud: Integer;
    FData : Integer;
    FTimeOut : Integer;
    FParity: Integer;
    FStop: Integer;
    FMaxBandwidth: Integer;
    FSendBytesCount: Integer;
    FSendBytesInterval: Integer;
    FHandShake: Integer;
    FHardFlow: Boolean;
    FSoftFlow: Boolean;


  public
    constructor Create(ASessao: String);

    procedure DefinirValoresPadroes;
    procedure LerIni(const AIni: TCustomIniFile);
    procedure GravarIni(const AIni: TCustomIniFile);

    property Baud: Integer read FBaud write FBaud;
    property Data: Integer read FData write FData;
    property TimeOut : Integer read FTimeOut write FTimeOut;
    property Parity: Integer read FParity write FParity;
    property Stop: Integer read FStop write FStop;
    property MaxBandwidth: Integer read  FMaxBandwidth write FMaxBandwidth;
    property SendBytesCount: Integer read  FSendBytesCount write FSendBytesCount;
    property SendBytesInterval: Integer read  FSendBytesInterval write FSendBytesInterval;
    property HandShake: Integer read FHandShake write FHandShake;
    property SoftFlow: Boolean read FSoftFlow write FSoftFlow;
    property HardFlow: Boolean read FHardFlow write FHardFlow;

  end;

implementation

uses
  ACBrLibConsts;

{ TLogConfig }

constructor TDeviceConfig.Create(ASessao: String);
begin
  inherited Create;
  FSessao := ASessao;
  DefinirValoresPadroes;
end;

procedure TDeviceConfig.DefinirValoresPadroes;
begin
  FBaud := 9600;
  FData := 8;
  FTimeOut := 3;
  FParity := 0;
  FStop := 0;
  FMaxBandwidth := 0;
  FSendBytesCount := 0;
  FSendBytesInterval := 0;
  FHandShake := 0;
  FHardFlow := False;
  FSoftFlow := False;
end;

procedure TDeviceConfig.LerIni(const AIni: TCustomIniFile);
begin
  FBaud := AIni.ReadInteger(FSessao, CChaveBaud, FBaud);
  FData := AIni.ReadInteger(FSessao, CChaveData, FData);
  FTimeOut := AIni.ReadInteger(FSessao, CChaveTimeOut, FTimeOut);
  FParity := AIni.ReadInteger(FSessao, CChaveParity, Integer(FParity));
  FStop := AIni.ReadInteger(FSessao, CChaveStop, Integer(FStop));
  FMaxBandwidth := AIni.ReadInteger(FSessao, CChaveMaxBandwidth, FMaxBandwidth);
  FSendBytesCount := AIni.ReadInteger(FSessao, CChaveSendBytesCount, FSendBytesCount);
  FSendBytesInterval := AIni.ReadInteger(FSessao, CChaveSendBytesInterval, FSendBytesInterval);
  FHandShake := AIni.ReadInteger(FSessao, CChaveHandShake, Integer(FHandShake));
  FHardFlow := AIni.ReadBool(FSessao, CChaveSoftFlow, FHardFlow);
  FSoftFlow := AIni.ReadBool(FSessao, CChaveHardFlow, FSoftFlow);
end;

procedure TDeviceConfig.GravarIni(const AIni: TCustomIniFile);
begin
  AIni.WriteInteger(FSessao, CChaveBaud, FBaud);
  AIni.WriteInteger(FSessao, CChaveData, FData);
  AIni.WriteInteger(FSessao, CChaveTimeOut, FTimeOut);
  AIni.WriteInteger(FSessao, CChaveParity, Integer(FParity));
  AIni.WriteInteger(FSessao, CChaveStop, Integer(FStop));
  AIni.WriteInteger(FSessao, CChaveMaxBandwidth, FMaxBandwidth);
  AIni.WriteInteger(FSessao, CChaveSendBytesCount, FSendBytesCount);
  AIni.WriteInteger(FSessao, CChaveSendBytesInterval, FSendBytesInterval);
  AIni.WriteInteger(FSessao, CChaveHandShake, Integer(FHandShake));
  AIni.WriteBool(FSessao, CChaveSoftFlow, FHardFlow);
  AIni.WriteBool(FSessao, CChaveHardFlow, FSoftFlow);
end;

end.
