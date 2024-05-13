{******************************************************************************}
{ Projeto: ACBr Monitor                                                        }
{  Executavel multiplataforma que faz uso do conjunto de componentes ACBr para }
{ criar uma interface de comunica��o com equipamentos de automacao comercial.  }
{                                                                              }
{ Direitos Autorais Reservados (c) 2010 Daniel Sim�es de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na p�gina do Projeto ACBr     }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Este programa � software livre; voc� pode redistribu�-lo e/ou modific�-lo   }
{ sob os termos da Licen�a P�blica Geral GNU, conforme publicada pela Free     }
{ Software Foundation; tanto a vers�o 2 da Licen�a como (a seu crit�rio)       }
{ qualquer vers�o mais nova.                                                   }
{                                                                              }
{  Este programa � distribu�do na expectativa de ser �til, mas SEM NENHUMA     }
{ GARANTIA; nem mesmo a garantia impl�cita de COMERCIALIZA��O OU DE ADEQUA��O A}
{ QUALQUER PROP�SITO EM PARTICULAR. Consulte a Licen�a P�blica Geral GNU para  }
{ obter mais detalhes. (Arquivo LICENCA.TXT ou LICENSE.TXT)                    }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral GNU junto com este}
{ programa; se n�o, escreva para a Free Software Foundation, Inc., 59 Temple   }
{ Place, Suite 330, Boston, MA 02111-1307, USA. Voc� tamb�m pode obter uma     }
{ copia da licen�a em:  http://www.opensource.org/licenses/gpl-license.php     }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{       Rua Coronel Aureliano de Camargo, 973 - Tatu� - SP - 18270-170         }
{                                                                              }
{******************************************************************************}
unit configuraserial;

interface

uses
  ACBrDevice,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, Spin;

type

  { TfrConfiguraSerial }

  TfrConfiguraSerial = class(TForm)
    gbSendBytes: TGroupBox;
    lEsperaBuffer: TLabel;
    lBuffer: TLabel;
    Label5: TLabel;
    cmbBaudRate: TComboBox;
    Label6: TLabel;
    cmbDataBits: TComboBox;
    Label7: TLabel;
    cmbParity: TComboBox;
    Label11: TLabel;
    cmbStopBits: TComboBox;
    Label8: TLabel;
    cmbHandShaking: TComboBox;
    Label4: TLabel;
    cmbPortaSerial: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    chHardFlow: TCheckBox;
    chSoftFlow: TCheckBox;
    seSendBytesCount: TSpinEdit;
    seSendBytesInterval: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure cmbPortaSerialChange(Sender: TObject);
    procedure cmbBaudRateChange(Sender: TObject);
    procedure cmbDataBitsChange(Sender: TObject);
    procedure cmbParityChange(Sender: TObject);
    procedure cmbStopBitsChange(Sender: TObject);
    procedure cmbHandShakingChange(Sender: TObject);
    procedure chHardFlowClick(Sender: TObject);
    procedure chSoftFlowClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure seSendBytesCountChange(Sender: TObject);
    procedure seSendBytesIntervalChange(Sender: TObject);
  private
    { Private declarations }
    procedure VerificaFlow;
  public
    { Public declarations }
    Device : TACBrDevice;
  end;

var
  frConfiguraSerial: TfrConfiguraSerial;

implementation

uses
  ACBrDeviceSerial;

{$R *.dfm}

{ TfrConfiguraSerial }

procedure TfrConfiguraSerial.FormCreate(Sender: TObject);
begin
  Device := TACBrDevice.Create(self);
end;

procedure TfrConfiguraSerial.FormDestroy(Sender: TObject);
begin
  Device.Free;
end;

procedure TfrConfiguraSerial.FormShow(Sender: TObject);
begin
  cmbBaudRate.ItemIndex     := cmbBaudRate.Items.IndexOf(IntToStr( Device.Baud ));
  cmbDataBits.ItemIndex     := cmbDataBits.Items.IndexOf(IntToStr( Device.Data ));
  cmbParity.ItemIndex       := Integer( Device.Parity );
  cmbStopBits.ItemIndex     := Integer( Device.Stop );
  chHardFlow.Checked        := Device.HardFlow;
  chSoftFlow.Checked        := Device.SoftFlow;
  cmbHandShaking.ItemIndex  := Integer( Device.HandShake );
  seSendBytesCount.Value    := Device.SendBytesCount;
  seSendBytesInterval.Value := Device.SendBytesInterval;
end;

procedure TfrConfiguraSerial.seSendBytesCountChange(Sender: TObject);
begin
  Device.SendBytesCount := seSendBytesCount.Value;
end;

procedure TfrConfiguraSerial.seSendBytesIntervalChange(Sender: TObject);
begin
  Device.SendBytesInterval := seSendBytesInterval.Value;
end;

procedure TfrConfiguraSerial.cmbPortaSerialChange(Sender: TObject);
begin
  Device.Porta := cmbPortaSerial.Text;
end;

procedure TfrConfiguraSerial.cmbBaudRateChange(Sender: TObject);
begin
  Device.Baud := StrToInt(cmbBaudRate.Text);
end;

procedure TfrConfiguraSerial.cmbDataBitsChange(Sender: TObject);
begin
  Device.Data := StrToInt(cmbDataBits.Text);
end;

procedure TfrConfiguraSerial.cmbParityChange(Sender: TObject);
begin
  Device.Parity := TACBrSerialParity( cmbParity.ItemIndex );
end;

procedure TfrConfiguraSerial.cmbStopBitsChange(Sender: TObject);
begin
  Device.Stop := TACBrSerialStop( cmbStopBits.ItemIndex );
end;

procedure TfrConfiguraSerial.cmbHandShakingChange(Sender: TObject);
begin
  Device.HandShake := TACBrHandShake( cmbHandShaking.ItemIndex );
  VerificaFlow;
end;

procedure TfrConfiguraSerial.chHardFlowClick(Sender: TObject);
begin
  Device.HardFlow := chHardFlow.Checked;
  VerificaFlow;
end;

procedure TfrConfiguraSerial.chSoftFlowClick(Sender: TObject);
begin
  Device.SoftFlow := chSoftFlow.Checked;
  VerificaFlow;
end;

procedure TfrConfiguraSerial.VerificaFlow;
begin
  cmbHandShaking.ItemIndex := Integer( Device.HandShake );
  chHardFlow.Checked := Device.HardFlow;
  chSoftFlow.Checked := Device.SoftFlow;
end;

end.

