{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{																			   }
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

unit U_Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls, StdCtrls, Buttons,
  ACBrBase, ACBrSocket, ACBrConsultaCNPJ, Mask, ComCtrls;

{$IFDEF CONDITIONALEXPRESSIONS}
   {$IF CompilerVersion >= 20.0}
     {$DEFINE DELPHI2009_UP}
   {$IFEND}
{$ENDIF}

// Remova o Ponto do DEFINE abaixo, se seu Delphi suporta PNG. 
//    - Se n�o suportar (D7), 
//  	- Acesse: https://sourceforge.net/projects/pngdelphi/
//      - Instale o projeto e depois remova o Ponto da Linha abaixo

{$DEFINE SUPPORT_PNG}  

{$IFDEF DELPHI2009_UP}
  {$DEFINE SUPPORT_PNG}
{$ENDIF}

type
  TF_Principal = class(TForm)
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    EditTipo: TEdit;
    EditRazaoSocial: TEdit;
    EditAbertura: TEdit;
    EditEndereco: TEdit;
    EditNumero: TEdit;
    EditComplemento: TEdit;
    EditBairro: TEdit;
    EditCidade: TEdit;
    EditUF: TEdit;
    EditCEP: TEdit;
    EditSituacao: TEdit;
    Panel1: TPanel;
    EditFantasia: TEdit;
    Label13: TLabel;
    ACBrConsultaCNPJ1: TACBrConsultaCNPJ;
    ListCNAE2: TListBox;
    Label15: TLabel;
    EditCNAE1: TEdit;
    Label16: TLabel;
    EditEmail: TEdit;
    Label17: TLabel;
    EditTelefone: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    EditPorte: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label14: TLabel;
    EditCNPJ: TMaskEdit;
    cbbProvedor: TComboBox;
    ButBuscar: TBitBtn;
    Proxy: TTabSheet;
    Label20: TLabel;
    Label21: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    edtHost: TEdit;
    edtPort: TEdit;
    edtUsuario: TEdit;
    EdtSenha: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure ButBuscarClick(Sender: TObject);
    procedure EditCaptchaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Principal: TF_Principal;

implementation

uses
  JPEG
{$IFDEF SUPPORT_PNG}
  , pngimage, TypInfo
{$ENDIF}
  ;

{$R *.dfm}

procedure TF_Principal.FormCreate(Sender: TObject);
var Provedor : TACBrCNPJProvedorWS;
begin
  cbbProvedor.Items.Clear;

  for Provedor := Low(TACBrCNPJProvedorWS) to High(TACBrCNPJProvedorWS) do
    cbbProvedor.Items.AddObject( GetEnumName(TypeInfo(TACBrCNPJProvedorWS), integer(Provedor) ), TObject(integer(Provedor)) );

  cbbProvedor.ItemIndex := 0;
end;

procedure TF_Principal.ButBuscarClick(Sender: TObject);
var
  I: Integer;
begin
  ACBrConsultaCNPJ1.Provedor := TACBrCNPJProvedorWS(cbbProvedor.Items.Objects[cbbProvedor.ItemIndex]);
  ACBrConsultaCNPJ1.ProxyHost:= edtHost.Text;
  ACBrConsultaCNPJ1.ProxyPort:= edtPort.Text;
  ACBrConsultaCNPJ1.ProxyUser:= edtUsuario.Text;
  ACBrConsultaCNPJ1.ProxyPass:= EdtSenha.Text;
  if ACBrConsultaCNPJ1.Consulta(
    EditCNPJ.Text
  ) then
  begin
    EditTipo.Text        := ACBrConsultaCNPJ1.EmpresaTipo;
    EditRazaoSocial.Text := ACBrConsultaCNPJ1.RazaoSocial;
    EditPorte.Text       := ACBrConsultaCNPJ1.Porte;
    EditAbertura.Text    := DateToStr( ACBrConsultaCNPJ1.Abertura );
    EditFantasia.Text    := ACBrConsultaCNPJ1.Fantasia;
    EditEndereco.Text    := ACBrConsultaCNPJ1.Endereco;
    EditNumero.Text      := ACBrConsultaCNPJ1.Numero;
    EditComplemento.Text := ACBrConsultaCNPJ1.Complemento;
    EditBairro.Text      := ACBrConsultaCNPJ1.Bairro;
    EditComplemento.Text := ACBrConsultaCNPJ1.Complemento;
    EditCidade.Text      := ACBrConsultaCNPJ1.Cidade;
    EditUF.Text          := ACBrConsultaCNPJ1.UF;
    EditCEP.Text         := ACBrConsultaCNPJ1.CEP;
    EditSituacao.Text    := ACBrConsultaCNPJ1.Situacao;
    EditCNAE1.Text       := ACBrConsultaCNPJ1.CNAE1;
    EditEmail.Text       := ACBrConsultaCNPJ1.EndEletronico;
    EditTelefone.Text    := ACBrConsultaCNPJ1.Telefone;

    ListCNAE2.Clear;
    for I := 0 to ACBrConsultaCNPJ1.CNAE2.Count - 1 do
      ListCNAE2.Items.Add(ACBrConsultaCNPJ1.CNAE2[I]);
  end;
end;

procedure TF_Principal.EditCaptchaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    ButBuscarClick(ButBuscar);
end;

end.
