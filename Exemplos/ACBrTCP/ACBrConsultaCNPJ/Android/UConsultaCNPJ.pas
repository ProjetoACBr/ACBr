unit UConsultaCNPJ;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Edit, FMX.Objects, ACBrBase,
  ACBrSocket, ACBrConsultaCNPJ, FMX.ListBox, System.ImageList, FMX.ImgList,
  FMX.Gestures;

{$IFDEF CONDITIONALEXPRESSIONS}
   {$IF CompilerVersion >= 20.0}
     {$DEFINE DELPHI2009_UP}
   {$IFEND}
{$ENDIF}

type
  TF_ConsultaCNPJ = class(TForm)
    vrtlayCorpo: TListBox;
    ToolBar1: TToolBar;
    Label1: TLabel;
    Button1: TButton;
   // FlowLayout1: TFlowLayout;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    EditCNPJ: TEdit;
    ACBrConsultaCNPJ1: TACBrConsultaCNPJ;
    Timer1: TTimer;
    Panel4: TPanel;
    Label4: TLabel;
    EditTipo: TEdit;
    Label5: TLabel;
    EditAbertura: TEdit;
    Label6: TLabel;
    EditRazaoSocial: TEdit;
    EditFantasia: TEdit;
    Label7: TLabel;
    EditEndereco: TEdit;
    Label8: TLabel;
    EditNumero: TEdit;
    Label9: TLabel;
    EditComplemento: TEdit;
    Label10: TLabel;
    EditBairro: TEdit;
    Label11: TLabel;
    EditCidade: TEdit;
    Label12: TLabel;
    EditUF: TEdit;
    Label13: TLabel;
    EditCEP: TEdit;
    Label14: TLabel;
    EditSituacao: TEdit;
    Label15: TLabel;
    EditTelefone: TEdit;
    Label16: TLabel;
    EditEmail: TEdit;
    Label17: TLabel;
    EditCNAE1: TEdit;
    Label18: TLabel;
    ListCNAE2: TListBox;
    Label19: TLabel;
    btnBuscar: TCornerButton;
    AniIndicator1: TAniIndicator;
    ckRemoverEspacosDuplos: TCheckBox;
    layPrinc: TLayout;
    GestureManager1: TGestureManager;
    StyleBook1: TStyleBook;
    ImageList1: TImageList;
    cnpjProvedoresCmbox: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    procedure btnBuscarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cnpjProvedoresCmboxClick(Sender: TObject);
  private
    { Private declarations }
    procedure Consultar;
  public
    { Public declarations }
  end;

var
  F_ConsultaCNPJ: TF_ConsultaCNPJ;

implementation

uses
  System.typinfo, System.IniFiles,System.Permissions, System.IOUtils,
  {$IfDef ANDROID}
  Androidapi.Helpers, Androidapi.JNI.Os, Androidapi.JNI.JavaTypes, Androidapi.IOUtils,
  Androidapi.JNI.Widget, FMX.Helpers.Android,
  {$EndIf}
  FMX.DialogService.Async, FMX.Platform, Xml.XMLDoc, System.Zip, System.Math,
  ssl_openssl_lib, blcksock, ACBrLibXml2,
  pcnConversao, pcnConversaoNFe,
  ACBrUtil, ACBrConsts, ACBrValidador,
  ACBrDFeSSL, ACBrDFeUtil
{$IFDEF WIN}
   ,JPEG
  {$IFDEF DELPHI2009_UP}
   ,pngimage
  {$ENDIF}
{$ENDIF WIN}
 ;

{$R *.fmx}

procedure TF_ConsultaCNPJ.btnBuscarClick(Sender: TObject);
begin
  AniIndicator1.Visible := True;
  AniIndicator1.Enabled := True;
  TThread.CreateAnonymousThread(Consultar).Start;
end;

procedure TF_ConsultaCNPJ.Button1Click(Sender: TObject);
begin
   Application.Terminate;
end;

procedure TF_ConsultaCNPJ.Consultar;

begin

  begin
          try
               if ACBrConsultaCNPJ1.Consulta(
                        EditCNPJ.Text,
                        '',
                        ckRemoverEspacosDuplos.IsChecked
                      ) then
                begin
                  TThread.Synchronize(nil, procedure
                  var
                      I: Integer;
                  begin
                      EditTipo.Text        := ACBrConsultaCNPJ1.EmpresaTipo;
                      EditRazaoSocial.Text := ACBrConsultaCNPJ1.RazaoSocial;
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

                      // TerminarTelaDeEspera;
                       AniIndicator1.Enabled := False;
                       AniIndicator1.Visible := False;
                  end);
                end;
       except
          On E: Exception do
          begin
            TThread.Synchronize(nil, procedure
            begin
            {
              lMsgAguarde.Text := 'Erro ao consultar o CEP: '+Editcep.Text;
              mLog.Lines.Add(E.ClassName);
              mLog.Lines.Add(E.Message);
              }
              ShowMessage(E.Message);
            end);
            // TerminarTelaDeEspera;
             AniIndicator1.Enabled := False;
             AniIndicator1.Visible := False;
           // Sleep(1500);
          end;
       end;
  end;
end;


procedure TF_ConsultaCNPJ.FormCreate(Sender: TObject);
var
provedor : TACBrCNPJProvedorWS;
begin

  cnpjProvedoresCmbox.ItemIndex := 0;
  // preenche cnpjProvedorCmbox com os nomes dos provedores
  for provedor := Low(TACBrCNPJProvedorWS) to High(TACBrCNPJProvedorWS) do
        cnpjProvedoresCmbox.Items.add(GetEnumName(TypeInfo(TACBrCNPJProvedorWs), Ord(provedor)));

end;

procedure TF_ConsultaCNPJ.cnpjProvedoresCmboxClick(Sender: TObject);
var
index : integer;
begin
  index := cnpjProvedoresCmbox.ItemIndex;
  ACBrConsultaCNPJ1.Provedor := TACBrCNPJProvedorWS(index);
end;

end.
