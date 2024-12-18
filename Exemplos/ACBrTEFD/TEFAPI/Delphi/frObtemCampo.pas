{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit frObtemCampo; 

interface

uses
  Classes, SysUtils, 
  Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, ExtCtrls;

type

{$R *.dfm}

  TTipoCampo = (tcoString, tcoNumeric, tcoCurrency, tcoAlfa, tcoAlfaNum, tcoDecimal) ;

{ TFormObtemCampo }

  TFormObtemCampo = class(TForm)
    btOk : TBitBtn;
    btCancel : TBitBtn;
    btVoltar: TBitBtn;
    edtResposta : TEdit;
    lTitulo: TLabel;
    pTitulo : TPanel;
    procedure edtRespostaChange(Sender: TObject);
    procedure edtRespostaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtRespostaKeyPress(Sender : TObject; var Key : char);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure FormCreate(Sender : TObject);
    procedure FormShow(Sender : TObject);
  private
    { private declarations }
    fMascara: String;
    fNaoRemoverMascaraResposta: Boolean;
    FTamanhoMaximo: Integer;
    FTamanhoMinimo: Integer;
    fTipoCampo: TTipoCampo;
    function GetOcultar: Boolean;
    function GetResposta: String;
    function GetTitulo: String;
    procedure SetMascara(AValue: String);
    procedure SetOcultar(AValue: Boolean);
    procedure SetResposta(AValue: String);
    procedure SetTitulo(AValue: String);
  public
    { public declarations }
    property TipoCampo: TTipoCampo read fTipoCampo write FTipoCampo;
    property TamanhoMinimo: Integer read FTamanhoMinimo write FTamanhoMinimo;
    property TamanhoMaximo: Integer read FTamanhoMaximo write FTamanhoMaximo;
    property Mascara: String read fMascara write SetMascara;
    property Titulo: String read GetTitulo write SetTitulo;
    property Resposta: String read GetResposta write SetResposta;
    property Ocultar: Boolean read GetOcultar write SetOcultar;
  end;

implementation

uses
  ACBrConsts, ACBrUtil.Base, ACBrUtil.Strings, ACBrValidador;

{ TFormObtemCampo }

procedure TFormObtemCampo.FormCreate(Sender : TObject);
begin
  fTamanhoMinimo := 0;
  fTamanhoMaximo := 0;
  fTipoCampo := tcoString;
  fMascara := '';
end;

procedure TFormObtemCampo.FormShow(Sender : TObject);
var
  TamMascara: Integer;
  TextVal: String;
begin
   if (fTipoCampo in [tcoCurrency, tcoDecimal]) then
   begin
     edtResposta.AutoSelect := False;
     TextVal := '0,00';
     if (fTipoCampo = tcoCurrency) then
       TextVal := 'R$ '+TextVal;

     edtResposta.Text := TextVal;
     edtResposta.SelStart := Length(edtResposta.Text);
     if TamanhoMaximo > 0 then
       TamanhoMaximo := TamanhoMaximo + 1;  // (Ponto Decimal)
   end
   else
   begin
     if (fMascara <> '') then
     begin
       TamMascara := CountStr(fMascara, '*');
       if TamanhoMaximo = 0 then
         TamanhoMaximo := TamMascara;

       if TamanhoMinimo = 0 then
         TamanhoMinimo := TamMascara;
     end;

     edtResposta.SetFocus;
   end;
end;

procedure TFormObtemCampo.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  if (ModalResult = mrOK) then
  begin
    if (TamanhoMinimo > 0) and (Length(Resposta) < TamanhoMinimo) then
    begin
      ShowMessage('O Tamanho M�nimo para este campo e: '+IntToStr(TamanhoMinimo) );
      CanClose := False;
      edtResposta.SetFocus;
    end
    else if (TamanhoMaximo > 0) and (Length(Resposta) > TamanhoMaximo) then
    begin
      ShowMessage('O Tamanho Maximo para este campo e: '+IntToStr(TamanhoMaximo) );
      CanClose := False;
      edtResposta.SetFocus;
    end
  end;
end;

procedure TFormObtemCampo.edtRespostaKeyPress(Sender : TObject; var Key : char);
var
  Ok: Boolean;
begin
   if (Key in [#8,#13,#27]) then  { BackSpace, Enter, Esc }
     Exit;

   case fTipoCampo of
     tcoNumeric, tcoCurrency, tcoDecimal:
       Ok := CharIsNum(Key);

     tcoAlfa:
     begin
       Key := upcase(Key);
       Ok := CharIsAlpha(Key);
     end;

     tcoAlfaNum:
     begin
       Ok := CharIsNum(Key);
       if not Ok then
       begin
         Key := upcase(Key);
         Ok := CharIsAlpha(Key);
       end;
     end;

   else
     Ok := True;
   end;

   if (not Ok) then
   begin
     Key := #0;
     Exit;
   end;

   if (TamanhoMaximo > 0) and (Length(Resposta) >= TamanhoMaximo) then
     Key := #0;
end;

procedure TFormObtemCampo.edtRespostaChange(Sender: TObject);
var
  AValor: Int64;
  TextVal: String;
begin
  if (fTipoCampo in [tcoCurrency, tcoDecimal]) then
  begin
    AValor := StrToIntDef(OnlyNumber(edtResposta.Text), 0);
    TextVal := FormatFloatBr(AValor/100, FloatMask(2, (fTipoCampo = tcoCurrency)));
    if (fTipoCampo = tcoCurrency) then
      TextVal := 'R$ '+TextVal;

    edtResposta.Text := TextVal;
    edtResposta.SelStart := Length(edtResposta.Text);
  end
  else if (fMascara <> '') then
  begin
    edtResposta.Text := FormatarMascaraDinamica( RemoverMascara(edtResposta.Text, fMascara), fMascara);
    edtResposta.SelStart := Length(edtResposta.Text);
  end;
end;

procedure TFormObtemCampo.edtRespostaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 13) then
  begin
    if (TamanhoMinimo > 0) and (Length(Resposta) < TamanhoMinimo) then
      Key := 0;
  end;
end;

function TFormObtemCampo.GetResposta: String;
var
  AValor: Int64;
begin
  if (TipoCampo in [tcoCurrency, tcoDecimal]) then
  begin
    AValor := StrToIntDef(OnlyNumber(edtResposta.Text), 0);
    Result := FloatToString(AValor/100, '.', '0.00');
  end
  else if (fMascara <> '') and (not fNaoRemoverMascaraResposta) then
    Result := ACBrValidador.RemoverMascara(edtResposta.Text, fMascara)
  else
    Result := edtResposta.Text;
end;

procedure TFormObtemCampo.SetResposta(AValue: String);
begin
  edtResposta.Text := AValue;
end;

function TFormObtemCampo.GetTitulo: String;
begin
  Result := lTitulo.Caption;
end;

procedure TFormObtemCampo.SetTitulo(AValue: String);
var
  NumLin, AltLin: Integer;
begin
  lTitulo.Caption := AValue;

  // Se houver quebra de linhas na msg, aumente o formul�rio...
  NumLin := CountStr(AValue, CR);
  if (NumLin > 0) then
  begin
    AltLin := lTitulo.Canvas.TextHeight('H');
    Height := Height + (NumLin * AltLin);
  end;
end;

procedure TFormObtemCampo.SetMascara(AValue: String);
begin
  if fMascara = AValue then
    Exit;

  fMascara := StringReplace(AValue, '@', '*', [rfReplaceAll]);
end;

function TFormObtemCampo.GetOcultar: Boolean;
begin
  Result := (edtResposta.PasswordChar <> #0);
end;


procedure TFormObtemCampo.SetOcultar(AValue: Boolean);
begin
  if AValue then
    edtResposta.PasswordChar := '*'
  else
    edtResposta.PasswordChar := #0;
end;

end.

