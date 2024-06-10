{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020   Daniel Simoes de Almeida             }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro                                 }
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

{******************************************************************************
|* Historico
|*
|* 29/03/2012: Isaque Pinheiro / R�gys Borges da Silveira
|*  - Cria��o e distribui��o da Primeira Versao
*******************************************************************************}
unit uPrincipal;

interface

uses
  Windows, Messages, FileCtrl, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, pngimage, Generics.Collections,
  IOUtils, UITypes, JclIDEUtils, JclCompilerUtils,
  Types, JvComponentBase, JvExControls, JvAnimatedImage,
  JvGIFCtrl, JvWizard, JvWizardRouteMapNodes, CheckLst,
  uFrameLista, ACBrPacotes, UACBrPlataformaInstalacaoAlvo,
  ACBrInstallDelphiComponentes;

type

  TfrmPrincipal = class(TForm)
    wizPrincipal: TJvWizard;
    wizMapa: TJvWizardRouteMapNodes;
    wizPgConfiguracao: TJvWizardInteriorPage;
    wizPgInstalacao: TJvWizardInteriorPage;
    wizPgFinalizar: TJvWizardInteriorPage;
    wizPgInicio: TJvWizardWelcomePage;
    Label2: TLabel;
    edtDirDestino: TEdit;
    Label6: TLabel;
    lstMsgInstalacao: TListBox;
    pnlTopo: TPanel;
    Label9: TLabel;
    btnSelecDirInstall: TSpeedButton;
    imgGifPropagandaACBrSAC: TJvGIFAnimator;
    Label3: TLabel;
    pgbInstalacao: TProgressBar;
    lblUrlACBrSac1: TLabel;
    lblUrlForum1: TLabel;
    lblUrlACBr1: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label10: TLabel;
    Label7: TLabel;
    btnInstalarACBr: TSpeedButton;
    btnVisualizarLogCompilacao: TSpeedButton;
    pnlInfoCompilador: TPanel;
    wizPgPacotes: TJvWizardInteriorPage;
    lbInfo: TListBox;
    Label22: TLabel;
    framePacotes1: TframePacotes;
    wizPgSelectIDEs: TJvWizardInteriorPage;
    grpCompilacao: TGroupBox;
    grpInstalacao: TGroupBox;
    ckbRemoveOpenSSL: TCheckBox;
    ckbRemoveCapicom: TCheckBox;
    ckbRemoveXMLSec: TCheckBox;
    ckbCargaDllTardia: TCheckBox;
    ckbRemoverCastWarnings: TCheckBox;
    ckbBCB: TCheckBox;
    Label8: TLabel;
    chkDeixarSomenteLIB: TCheckBox;
    ckbRemoverArquivosAntigos: TCheckBox;
    ckbUsarArquivoConfig: TCheckBox;
    ckbCopiarTodasDll: TCheckBox;
    rdgDLL: TRadioGroup;
    btnMarcarTodas: TButton;
    btnDesmarcarTodas: TButton;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    scrlbxDelphiVersion: TScrollBox;
    chkSobrescreverDLLs: TCheckBox;
    GroupBox1: TGroupBox;
    chkExportadorFastPNG: TCheckBox;
    chkExportadorFastSVG: TCheckBox;
    imgLogomarca: TImage;
    pnlLogo: TPanel;
    imgOK: TImage;
    procedure btnDesmarcarTodasClick(Sender: TObject);
    procedure imgPropaganda1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure wizPgInicioNextButtonClick(Sender: TObject; var Stop: Boolean);
    procedure URLClick(Sender: TObject);
    procedure btnSelecDirInstallClick(Sender: TObject);
    procedure wizPrincipalCancelButtonClick(Sender: TObject);
    procedure wizPrincipalFinishButtonClick(Sender: TObject);
    procedure wizPgConfiguracaoNextButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure btnInstalarACBrClick(Sender: TObject);
    procedure btnMarcarTodasClick(Sender: TObject);
    procedure wizPgInstalacaoNextButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure btnVisualizarLogCompilacaoClick(Sender: TObject);
    procedure wizPgInstalacaoEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure clbDelphiVersionClick(Sender: TObject);
    procedure wizPgPacotesNextButtonClick(Sender: TObject; var Stop: Boolean);
    procedure wizPgSelectIDEsNextButtonClick(Sender: TObject; var Stop: Boolean);
  private
    FUmaListaPlataformasAlvos: TListaPlataformasAlvos;
    FListaCheckBoxPlataformas: TList<TCheckBox>;

    FUltimoArquivoLog: string;
    procedure AbrirLinkEmNavegadorParaEnderecoDoACBrPro;
    procedure GravarConfiguracoesEmArquivoIni;
    procedure LerConfiguracoesEmArquivoIni;
    function PathArquivoIni: String;
    procedure AjustaConfiguracoesConformeTela(var OpcoesInstall: TACBrInstallOpcoes; var OpcoesCompilacao: TACBrCompilerOpcoes);
    procedure AjustaTelaConformeConfiguracoes(OpcoesInstall: TACBrInstallOpcoes; OpcoesCompilacao: TACBrCompilerOpcoes);

    procedure ValidarSeExistemPacotesNasPastas(var Stop: Boolean; const PastaACBr: string; ListaPacotes:
        TPacotes);
    function ProcedeInstalacao: Boolean;
    procedure AbrirArquivoLogAtual;

    procedure IncrementaBarraProgresso;
    procedure Logar(const AString: String);
    procedure IniciaNovaInstalacao(const MaximoPassosProgresso: Integer; const NomeCaminhoArquivoLog: string;
          const Cabecalho: string);
    procedure MontaListaIDEsSuportadas;
    procedure AtualizarArquivoIni;
  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  ShellApi, IniFiles, StrUtils, Math, Registry, ACBrUtil.FilesIO, ACBrInstallUtils;

{$R *.dfm}

// retornar o caminho completo para o arquivo .ini de configura��es
function TfrmPrincipal.PathArquivoIni: String;
begin
  Result := ChangeFileExt(ParamStr(0), '.ini');
end;

procedure TfrmPrincipal.ValidarSeExistemPacotesNasPastas(var Stop: Boolean; const PastaACBr: string;
      ListaPacotes: TPacotes);
var
  I: Integer;
  NomePacote: string;
  sDirPackage: string;
begin
  // verificar se os pacotes existem antes de seguir para o pr�ximo passo
  for I := 0 to ListaPacotes.Count - 1 do
  begin
    if ListaPacotes[I].MarcadoParaInstalar then
    begin
      NomePacote := ListaPacotes[I].GetNome;
      // Busca diret�rio do pacote
      sDirPackage := FindDirPackage(IncludeTrailingPathDelimiter(PastaACBr) + 'Pacotes\Delphi', NomePacote);
      if Trim(sDirPackage) = '' then
        raise Exception.Create('N�o foi poss�vel encontrar o diret�rio do pacote "' + NomePacote +'" no caminho: '+ PastaACBr);

      if IsDelphiPackage(NomePacote) then
      begin
        if not FileExists(IncludeTrailingPathDelimiter(sDirPackage) + NomePacote) then
        begin
          Stop := True;
          Application.MessageBox(PWideChar(Format('Pacote "%s" n�o encontrado, efetue novamente o download do reposit�rio', [NomePacote])), 'Erro.', MB_ICONERROR + MB_OK);
          Break;
        end;
      end;
    end;
  end;
end;

// ler o arquivo .ini de configura��es e setar os campos com os valores lidos
procedure TfrmPrincipal.LerConfiguracoesEmArquivoIni;
var
  ArqIni: TIniFile;
  I, J: Integer;
  PlataformasMarcadas: string;
  ListaPlataformasStrings: TStringList;
  OpcoesInstalacao:   TACBrInstallOpcoes;
  OpcoesCompilacao:   TACBrCompilerOpcoes;
begin
  AtualizarArquivoIni;

  OpcoesInstalacao.CarregarDeArquivoIni(PathArquivoIni);
  OpcoesCompilacao.CarregarDeArquivoIni(PathArquivoIni);
  AjustaTelaConformeConfiguracoes(OpcoesInstalacao, OpcoesCompilacao);

  ArqIni := TIniFile.Create(PathArquivoIni);
  try
    PlataformasMarcadas := ArqIni.ReadString('PLATAFORMAS', 'Marcadas', '');
  finally
    ArqIni.Free;
  end;

  if PlataformasMarcadas <> '' then
  begin
    ListaPlataformasStrings := TStringList.Create;
    try
      ListaPlataformasStrings.Delimiter := ';';
      ListaPlataformasStrings.StrictDelimiter := True;
      ListaPlataformasStrings.DelimitedText := PlataformasMarcadas;

      for I := 0 to ListaPlataformasStrings.Count - 1 do
      begin
        for J := 0 to scrlbxDelphiVersion.ControlCount - 1 do
        begin
          if (scrlbxDelphiVersion.Controls[J] as TCheckBox).Caption = ListaPlataformasStrings[I] then
          begin
            (scrlbxDelphiVersion.Controls[J] as TCheckBox).Checked := True;
          end;
        end;
      end;

    finally
      ListaPlataformasStrings.Free;
    end;
  end;

  framePacotes1.CarregarDeArquivoIni(PathArquivoIni);
end;

// gravar as configura��es efetuadas pelo usu�rio
procedure TfrmPrincipal.GravarConfiguracoesEmArquivoIni;
var
  ArqIni: TIniFile;
  I: Integer;
  PlataformasMarcadas: string;
  OpcoesInstalacao:   TACBrInstallOpcoes;
  OpcoesCompilacao:   TACBrCompilerOpcoes;
begin
  AjustaConfiguracoesConformeTela(OpcoesInstalacao, OpcoesCompilacao);
  OpcoesInstalacao.SalvarEmArquivoIni(PathArquivoIni);
  OpcoesCompilacao.SalvarEmArquivoIni(PathArquivoIni);

  PlataformasMarcadas := '';
  for i := 0 to scrlbxDelphiVersion.ControlCount - 1 do
  begin
    // s� instala as vers�o marcadas para instalar.
    if ((scrlbxDelphiVersion.Controls[i] as TCheckBox).Checked) then
    begin
      PlataformasMarcadas := PlataformasMarcadas + (scrlbxDelphiVersion.Controls[i] as TCheckBox).Caption +';';
    end;
  end;

  ArqIni := TIniFile.Create(PathArquivoIni);
  try
    ArqIni.EraseSection('PLATAFORMAS');
    ArqIni.WriteString('PLATAFORMAS', 'Marcadas', PlataformasMarcadas);
  finally
    ArqIni.Free;
  end;

  framePacotes1.SalvarEmArquivoIni(PathArquivoIni);
end;

procedure TfrmPrincipal.IniciaNovaInstalacao(const MaximoPassosProgresso: Integer; const
    NomeCaminhoArquivoLog: string; const Cabecalho: string);
begin
  // setar barra de progresso
  pgbInstalacao.Position := 0;

  pgbInstalacao.Max := MaximoPassosProgresso;

  // mostrar ao usu�rio as informa��es de compila��o
  FUltimoArquivoLog := NomeCaminhoArquivoLog;
  lbInfo.Clear;
  lbInfo.Items.Text := Cabecalho;
  lstMsgInstalacao.Clear;
end;

procedure TfrmPrincipal.MontaListaIDEsSuportadas;
var
  iFor: Integer;
  achk: TCheckBox;
  ValorTop: Integer;
begin
  for iFor := 0 to FUmaListaPlataformasAlvos.Count - 1 do
  begin
    achk := TCheckBox.Create(scrlbxDelphiVersion);
    try
      achk.Parent  := scrlbxDelphiVersion;
      achk.Name    := 'chk'+IntToStr(iFor);
      achk.Tag     := iFor;
      achk.Left    := 4;
      ValorTop     := 4;
      if (iFor > 0) then
      begin
        ValorTop   := FListaCheckBoxPlataformas[iFor-1].Top + FListaCheckBoxPlataformas[iFor-1].Height;
        if FUmaListaPlataformasAlvos[iFor].InstalacaoAtual.Name <> FUmaListaPlataformasAlvos[iFor-1].InstalacaoAtual.Name then
        begin
          ValorTop   := ValorTop + 8;
        end;
      end;
      achk.Width   := scrlbxDelphiVersion.Width - 16;
      achk.Top     := ValorTop;
      achk.Caption := FUmaListaPlataformasAlvos[iFor].GetNomeAlvo;
  //    if FUmaListaPlataformasAlvos[iFor].EhSuportadaPeloACBrBeta then
  //    begin
  //      achk.StyleName := Estilo.Suportado.Apenas.Delphi10.4;
  //      //achk.Font.Color :=
  //      //achk.Font.Style := [fsItalic];
  //    end;
      achk.Enabled := FUmaListaPlataformasAlvos[iFor].EhSuportadaPeloACBr;
      achk.OnClick := clbDelphiVersionClick;
    except
      on E: EConvertError do
      begin
        achk.Enabled := False;
        achk.Caption := 'Erro ao detectar vers�o.';
      {$IFDEF DEBUG}
        ShowMessage('Erro ao detectar vers�o. Erro: '+ E.Message);
      {$ENDIF}
//        achk.Visible := False;
      end;

    end;
    FListaCheckBoxPlataformas.Add(achk);
  end;
end;

procedure TfrmPrincipal.AtualizarArquivoIni;
var
  versao: string;
  ArqIni: TIniFile;
begin
  if not FilesExists(PathArquivoIni) then
  begin
    Exit;
  end;

  ArqIni := TIniFile.Create(PathArquivoIni);
  try
    versao := ArqIni.ReadString('CONFIG', 'VersaoArquivoIniConfig', '');
  finally
    ArqIni.Free;
  end;

  if versao <> cVersaoConfig then
  begin
    if MessageDlg('Encontramos um arquivo de configura��o antigo. Precisamos apag�-lo para continuar.' + sLineBreak +
                  'Deseja continuar?', mtWarning, mbYesNo, 0, mbNo) <> mrYes then
    begin
      Application.Terminate;
      Exit;
    end;

    DeleteFile(PathArquivoIni);
    ShowMessage('Por favor, confira as op��es de configura��o.');
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  Caption                   := Caption + ' ' + sVersaoInstalador;
  FUmaListaPlataformasAlvos := GeraListaPlataformasAlvos;
  FUltimoArquivoLog         := '';
  FListaCheckBoxPlataformas := TList<TCheckBox>.Create;

  MontaListaIDEsSuportadas;

  LerConfiguracoesEmArquivoIni;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FUmaListaPlataformasAlvos.Free;
  FListaCheckBoxPlataformas.Free;
end;

procedure TfrmPrincipal.Logar(const AString: String);
begin
  lstMsgInstalacao.Items.Add(AString);
  lstMsgInstalacao.ItemIndex := lstMsgInstalacao.Count - 1;
  Application.ProcessMessages;
end;

function TfrmPrincipal.ProcedeInstalacao: Boolean;

  function GeraListaVersoesMarcadas(): TList<Integer>;
  var
    i: integer;
  begin
    Result := TList<Integer>.Create;
    for i := 0 to scrlbxDelphiVersion.ControlCount - 1 do
    begin
      // s� instala as vers�o marcadas para instalar.
      if ((scrlbxDelphiVersion.Controls[i] as TCheckBox).Checked) then
      begin
        Result.Add(i)
      end;
    end;
  end;

var
  ACBrInstaladorAux: TACBrInstallComponentes;
  ListaPacotes: TPacotes;
  ListaVersoesInstalacao: TList<Integer>;
begin
  ListaPacotes := framePacotes1.Pacotes;

  ListaVersoesInstalacao := GeraListaVersoesMarcadas;
  try
    ACBrInstaladorAux := TACBrInstallComponentes.Create(Application);
    try
      ACBrInstaladorAux.OnIniciaNovaInstalacao := IniciaNovaInstalacao;
      ACBrInstaladorAux.OnProgresso            := IncrementaBarraProgresso;
      ACBrInstaladorAux.OnInformaSituacao      := Logar;

      AjustaConfiguracoesConformeTela(ACBrInstaladorAux.OpcoesInstall, ACBrInstaladorAux.OpcoesCompilacao);

      Result := ACBrInstaladorAux.Instalar(ListaPacotes, ListaVersoesInstalacao, FUmaListaPlataformasAlvos);
    finally
      ACBrInstaladorAux.Free;
    end;

  finally
    ListaVersoesInstalacao.Free;
  end;


  if Result then
  begin
    MessageDlg('Pacotes compilados e instalados com sucesso! ' + sLineBreak +
               'Clique em "Pr�ximo" para finalizar a instala��o.', mtInformation, [mbOK] , 0, mbOK);
  end
  else
  begin
    if MessageDlg('Ocorreram erros durante o processo de instala��o, ' + sLineBreak +
                  'para maiores informa��es verifique o arquivo de log gerado.' +
                  sLineBreak + sLineBreak +
                  'Deseja visualizar o arquivo de log gerado?', mtWarning, mbYesNo, 0, mbYes
                  ) = mrYes then
    begin
      AbrirArquivoLogAtual;
    end;
  end;

end;

procedure TfrmPrincipal.AbrirArquivoLogAtual;
begin
  if FUltimoArquivoLog = '' then
  begin
    Exit;
  end;
  ShellExecute(Handle, 'open', PWideChar(FUltimoArquivoLog), '', '', 1);
end;

procedure TfrmPrincipal.AbrirLinkEmNavegadorParaEnderecoDoACBrPro;
begin
  // ir para o endere�o do ACBrSAC
  ShellExecute(Handle, 'open', PWideChar(lblUrlACBrSac1.Caption), '', '', 1);
end;

procedure TfrmPrincipal.AjustaConfiguracoesConformeTela(var OpcoesInstall: TACBrInstallOpcoes; var OpcoesCompilacao: TACBrCompilerOpcoes);
begin
  OpcoesInstall.LimparArquivosACBrAntigos := ckbRemoverArquivosAntigos.Checked;
  OpcoesInstall.DeixarSomentePastasLib    := chkDeixarSomenteLIB.Checked;
  OpcoesInstall.DeveCopiarOutrasDLLs      := ckbCopiarTodasDll.Checked;
  OpcoesInstall.UsarCpp                   := ckbBCB.Checked;
  OpcoesInstall.UsarUsarArquivoConfig     := ckbUsarArquivoConfig.Checked;

  case rdgdll.ItemIndex of
    0 : OpcoesInstall.sDestinoDLLs := tdSystem;
    1 : OpcoesInstall.sDestinoDLLs := tdDelphi;
    2 : OpcoesInstall.sDestinoDLLs := tdNone;
  else
    OpcoesInstall.sDestinoDLLs     := tdNone;
  end;
  OpcoesInstall.DiretorioRaizACBr := IncludeTrailingPathDelimiter(edtDirDestino.Text);

  OpcoesCompilacao.DeveInstalarCapicom       := not ckbRemoveCapicom.Checked;
  OpcoesCompilacao.DeveInstalarOpenSSL       := not ckbRemoveOpenSSL.Checked;
  OpcoesCompilacao.DeveInstalarXMLSec        := not ckbRemoveXMLSec.Checked;
  OpcoesCompilacao.UsarCargaTardiaDLL        := ckbCargaDllTardia.Checked;
  OpcoesCompilacao.RemoverStringCastWarnings := ckbRemoverCastWarnings.Checked;
  OpcoesCompilacao.UsarExportadorFRSVG    := chkExportadorFastSVG.Checked;
  OpcoesCompilacao.UsarExportadorFRPNG    := chkExportadorFastPNG.Checked;
end;

procedure TfrmPrincipal.AjustaTelaConformeConfiguracoes(OpcoesInstall: TACBrInstallOpcoes; OpcoesCompilacao: TACBrCompilerOpcoes);
begin
  ckbRemoverArquivosAntigos.Checked := OpcoesInstall.LimparArquivosACBrAntigos;
  chkDeixarSomenteLIB.Checked       := OpcoesInstall.DeixarSomentePastasLib;
  ckbCopiarTodasDll.Checked         := OpcoesInstall.DeveCopiarOutrasDLLs;
  ckbBCB.Checked                    := OpcoesInstall.UsarCpp;
  ckbUsarArquivoConfig.Checked      := OpcoesInstall.UsarUsarArquivoConfig;

  case OpcoesInstall.sDestinoDLLs of
    tdSystem: rdgdll.ItemIndex := 0;
    tdDelphi: rdgdll.ItemIndex := 1;
    tdNone:   rdgdll.ItemIndex := 2;
  end;
  edtDirDestino.Text := IncludeTrailingPathDelimiter(OpcoesInstall.DiretorioRaizACBr);

  ckbRemoveCapicom.Checked          := not OpcoesCompilacao.DeveInstalarCapicom;
  ckbRemoveOpenSSL.Checked          := not OpcoesCompilacao.DeveInstalarOpenSSL;
  ckbRemoveXMLSec.Checked           := not OpcoesCompilacao.DeveInstalarXMLSec;
  ckbCargaDllTardia.Checked         := OpcoesCompilacao.UsarCargaTardiaDLL;
  ckbRemoverCastWarnings.Checked    := OpcoesCompilacao.RemoverStringCastWarnings;
  chkExportadorFastSVG.Checked      := OpcoesCompilacao.UsarExportadorFRSVG;
  chkExportadorFastPNG.Checked      := OpcoesCompilacao.UsarExportadorFRPNG;
end;

procedure TfrmPrincipal.btnDesmarcarTodasClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to FListaCheckBoxPlataformas.Count - 1 do
  begin
    if FListaCheckBoxPlataformas[i].Enabled then FListaCheckBoxPlataformas[i].Checked := False;
  end;
end;

procedure TfrmPrincipal.IncrementaBarraProgresso;
begin
  pgbInstalacao.Position := pgbInstalacao.Position + 1;
  Application.ProcessMessages;
end;

// bot�o de compila��o e instala��o dos pacotes selecionados no treeview
procedure TfrmPrincipal.btnInstalarACBrClick(Sender: TObject);
var
  Instalou: Boolean;
begin
  // limpar o log
  lstMsgInstalacao.Clear;

  Instalou := False;
  btnInstalarACBr.Enabled := False;
  btnVisualizarLogCompilacao.Enabled := False;
  wizPgInstalacao.EnableButton(bkBack, False);
  wizPgInstalacao.EnableButton(bkNext, False);
  wizPgInstalacao.EnableButton(TJvWizardButtonKind(bkCancel), False);
  try
    Instalou := ProcedeInstalacao;
  finally
    btnInstalarACBr.Enabled := True;
    btnVisualizarLogCompilacao.Enabled := True;
    wizPgInstalacao.EnableButton(bkBack, True);
    wizPgInstalacao.EnableButton(bkNext, Instalou);
    wizPgInstalacao.EnableButton(TJvWizardButtonKind(bkCancel), True);
  end;
end;

procedure TfrmPrincipal.btnMarcarTodasClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to FListaCheckBoxPlataformas.Count - 1 do
  begin
    if FListaCheckBoxPlataformas[i].Enabled then FListaCheckBoxPlataformas[i].Checked := True;
  end;
end;

// chama a caixa de dialogo para selecionar o diret�rio de instala��o
// seria bom que a caixa fosse aquele que possui o bot�o de criar pasta
procedure TfrmPrincipal.btnSelecDirInstallClick(Sender: TObject);
var
  Dir: String;
begin
  if SelectDirectory('Selecione o diret�rio de instala��o', '', Dir, [sdNewFolder, sdNewUI, sdValidateDir]) then
    edtDirDestino.Text := Dir;
end;

// quando trocar a vers�o verificar se libera ou n�o o combo
// da plataforma de compila��o
procedure TfrmPrincipal.clbDelphiVersionClick(Sender: TObject);
var
  I: Integer;
  ChkBoxClicado: TCheckBox;
begin
  ChkBoxClicado := TCheckBox(Sender);

  if not ChkBoxClicado.Enabled then
  begin
    Exit;
  end;

  if MatchText(FUmaListaPlataformasAlvos[ChkBoxClicado.Tag].InstalacaoAtual.VersionNumberStr,
               ['d7','d9','d10','d11']) then
  begin
    Application.MessageBox(
      'Aten��o: Embora o ACBr continue suportando vers�es anteriores do Delphi, incentivamos que voc� atualize o quanto antes para vers�es mais recentes do Delphi ou considere migrar para o Lazarus.',
      'Erro.',
      MB_OK + MB_ICONWARNING
    );
  end;

  if (FUmaListaPlataformasAlvos[ChkBoxClicado.Tag].tPlatformAtual <> bpWin32) and
     (ChkBoxClicado.Checked) then
  begin
    //Ligar instalacao win32 da IDE correspondente...
    I := (ChkBoxClicado.Tag - 1);
    while I >= 0 do
    begin
      if (FUmaListaPlataformasAlvos[ChkBoxClicado.Tag].InstalacaoAtual =
          FUmaListaPlataformasAlvos[i].InstalacaoAtual) and
         (FUmaListaPlataformasAlvos[i].tPlatformAtual = bpWin32) then
      begin
        FListaCheckBoxPlataformas[i].Checked := True;
      end;
      Dec(I);
    end;
  end
  else if (FUmaListaPlataformasAlvos[ChkBoxClicado.Tag].tPlatformAtual = bpWin32) and
     (not ChkBoxClicado.Checked) then
  begin
    //Desligar todas instalacoes nao win32.
    I := (ChkBoxClicado.Tag + 1);
    repeat
      if (FUmaListaPlataformasAlvos[ChkBoxClicado.Tag].InstalacaoAtual =
          FUmaListaPlataformasAlvos[i].InstalacaoAtual) and
         (FUmaListaPlataformasAlvos[i].tPlatformAtual <> bpWin32)then
      begin
        FListaCheckBoxPlataformas[i].Checked := False;
      end;
      Inc(I);
    until (I = FUmaListaPlataformasAlvos.Count);
  end;

//
//  // C++ Builder a partir do D2006, vers�es anteriores tem IDE independentes.
//  ckbBCB.Enabled := MatchText(UmaListaPlataformasAlvos[clbDelphiVersion.ItemIndex].InstalacaoAtual.VersionNumberStr, ['d10','d11','d12','d14','d15','d16','d17','d18','d19','d20','d21','d22','d23','d24','d25','d26']);
//  if not ckbBCB.Enabled then
     ckbBCB.Checked := False;
end;

// abrir o endere�o do ACBrSAC quando clicar na propaganda
procedure TfrmPrincipal.imgPropaganda1Click(Sender: TObject);
begin
  AbrirLinkEmNavegadorParaEnderecoDoACBrPro;
end;

// quando clicar em alguma das urls chamar o link mostrado no caption
procedure TfrmPrincipal.URLClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PWideChar(TLabel(Sender).Caption), '', '', 1);
end;

procedure TfrmPrincipal.wizPgInicioNextButtonClick(Sender: TObject; var Stop: Boolean);
var
  InstalacoesDelphi: TJclBorRADToolInstallations;
begin
  // Verificar se o delphi est� aberto
  InstalacoesDelphi := TJclBorRADToolInstallations.Create;
  try
    if InstalacoesDelphi.AnyInstanceRunning then
    begin
    {$IFDEF DEBUG}
      Stop := MessageDlg('Feche a IDE do delphi antes de continuar.', mtWarning, mbAbortIgnore, 0,
                         mbAbort) <> mrIgnore;
    {$ELSE}
      Stop := True;
      MessageDlg('Feche a IDE do delphi antes de continuar.', mtWarning, [mbOK], 0, mbOK);
    {$ENDIF}
    end;
  finally
    InstalacoesDelphi.Free;
  end;
end;

procedure TfrmPrincipal.wizPgInstalacaoEnterPage(Sender: TObject;
  const FromPage: TJvWizardCustomPage);
begin
//  // para 64 bit somente compilar
//  if tPlatform = bpWin32 then // Win32
//    btnInstalarACBr.Caption := 'Instalar'
//  else // win64
//    btnInstalarACBr.Caption := 'Compilar';
//
  lbInfo.Clear;
  lbInfo.Items.Add('Pressione o bot�o "'+ btnInstalarACBr.Caption +'" para prosseguir.');
  btnVisualizarLogCompilacao.Enabled := False;
end;

procedure TfrmPrincipal.wizPgInstalacaoNextButtonClick(Sender: TObject;
  var Stop: Boolean);
begin
  if (lstMsgInstalacao.Count <= 0) then
  begin
    Stop := True;
    Application.MessageBox(
      'Clique no bot�o instalar antes de continuar.',
      'Erro.',
      MB_OK + MB_ICONERROR
    );
  end;

//  N�o deve ser permitido clicar em Next caso tenha havido erros.
//  Assim o c�digo abaixo � desnecess�rio.
//  if (FCountErros > 0) then
//  begin
//    Stop := True;
//    Application.MessageBox(
//      'Ocorreram erros durante a compila��o e instala��o dos pacotes, verifique.',
//      'Erro.',
//      MB_OK + MB_ICONERROR
//    );
//  end;
end;

procedure TfrmPrincipal.wizPgConfiguracaoNextButtonClick(Sender: TObject;
  var Stop: Boolean);
begin
  // verificar se foi informado o diret�rio
  if Trim(edtDirDestino.Text) = EmptyStr then
  begin
    Stop := True;
    edtDirDestino.SetFocus;
    Application.MessageBox(
      'Diret�rio de instala��o n�o foi informado.',
      'Erro.',
      MB_OK + MB_ICONERROR
    );
  end;

  if not ckbRemoveXMLSec.Checked then
  begin
    if MessageDlg('Usar XMLSec n�o � recomendado. Sugerimos que marque a op��o "'+
                  ckbRemoveXMLSec.Caption + '" antes de continuar.'+ sLineBreak +
                  'Deseja continuar assim mesmo?', mtConfirmation, mbYesNo, 0, mbNo) <> mrYes  then
    begin
      Stop := True;
    end;
  end;

//  //Exibir mensagem abaixo apenas se n�o for o Delphi 7..
//  if not ckbRemoverCastWarnings.Checked then
//  begin
//    if MessageDlg('Se n�o estiver resolvendo os Warnings com strings sugerimos marcar a op��o "'+
//                  ckbRemoverCastWarnings.Caption + '" antes de continuar.'+ sLineBreak +
//                  'Deseja continuar assim mesmo?', mtConfirmation, mbYesNo, 0, mbNo) <> mrYes  then
//    begin
//      Stop := True;
//    end;
//  end;
//
  if (ckbRemoverArquivosAntigos.Checked) and
     (MessageDlg('Voc� optou por limpar arquivos antigos do ACBr do seu computador. Essa a��o pode demorar v�rios minutos.' + sLineBreak +
                 'Deseja realmente continuar?', mtConfirmation, mbYesNo, 0, mbNo) <> mrYes) then
  begin
    Stop := True;
    ckbRemoverArquivosAntigos.Checked := False;
  end;

  if not ckbCopiarTodasDll.Checked then
  begin
    if MessageDlg('N�o foi marcado a op��o para copiar as DLLs. Voc� ter� que copiar manualmente. ' + sLineBreak +
                  'Deseja continuar assim mesmo?', mtConfirmation, mbYesNo, 0, mbNo) <> mrYes  then
    begin
      Stop := True;
    end;
  end;

  ValidarSeExistemPacotesNasPastas(Stop, IncludeTrailingPathDelimiter(edtDirDestino.Text), framePacotes1.Pacotes);
end;

procedure TfrmPrincipal.btnVisualizarLogCompilacaoClick(Sender: TObject);
begin
  AbrirArquivoLogAtual;
end;

procedure TfrmPrincipal.wizPgPacotesNextButtonClick(Sender: TObject; var Stop: Boolean);
begin
  // Gravar as configura��es em um .ini para utilizar depois
  GravarConfiguracoesEmArquivoIni;
end;

procedure TfrmPrincipal.wizPgSelectIDEsNextButtonClick(Sender: TObject; var Stop: Boolean);
var
  iFor: Integer;
  bChk: Boolean;
begin
  bChk := False;
  for iFor := 0 to FListaCheckBoxPlataformas.Count -1 do
  begin
    if FListaCheckBoxPlataformas[iFor].Checked then
    begin
      bChk := True;
      Break;
    end;
  end;

  if not bChk then
  begin
    Stop := True;
    scrlbxDelphiVersion.SetFocus;
    Application.MessageBox(
      'Para continuar escolha a vers�o do Delphi para a qual deseja instalar o ACBr.',
      'Erro.',
      MB_OK + MB_ICONERROR
    );
  end;

end;

procedure TfrmPrincipal.wizPrincipalCancelButtonClick(Sender: TObject);
begin
  if Application.MessageBox(
    'Deseja realmente cancelar a instala��o?',
    'Fechar',
    MB_ICONQUESTION + MB_YESNO
  ) = ID_YES then
  begin
    Self.Close;
  end;
end;

procedure TfrmPrincipal.wizPrincipalFinishButtonClick(Sender: TObject);
begin
  Self.Close;
end;

end.
