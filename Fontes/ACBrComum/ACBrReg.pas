{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Alexandre Rocha Lima e Marcondes                }
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

Unit ACBrReg ;

interface
uses Classes, SysUtils, ACBrConsts, ACBrBase,
    {$IFDEF VisualCLX}
      QDialogs
    {$ELSE}
      Dialogs
      {$IFNDEF FPC}
        {$WARN UNIT_PLATFORM OFF}, FileCtrl {$WARN UNIT_PLATFORM ON}
      {$ENDIF}
    {$ENDIF},

    {$IFDEF FPC}
        LResources, LazarusPackageIntf, PropEdits, componenteditors
     {$ELSE}
     {$IFDEF DELPHI9_UP}ToolsApi, Windows, Graphics,{$ENDIF}
        {$IFNDEF COMPILER6_UP}
           DsgnIntf
        {$ELSE}
           DesignIntf,
           DesignEditors
        {$ENDIF}
     {$ENDIF} ;

type
  { Editor de Proriedades de Componente para mostrar o AboutACBr }
  TACBrAboutDialogProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;

  { Editor de Proriedades de Componente para chamar OpenDialog }

  { TACBrFileProperty }

  TACBrFileProperty = class( TStringProperty )
  protected
    function GetFilter: String; virtual;
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  { TACBrFileINIProperty }

  TACBrFileINIProperty = class( TACBrFileProperty )
  protected
    function GetFilter: String; override;
  end;

  { Editor de Proriedades de Componente para chamar OpenDialog }
  TACBrDirProperty = class( TStringProperty )
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;


procedure Register ;

//{$IFDEF  RTL170_UP}
//	{$R ACBr_Comum.res}
//{$ENDIF}
implementation

Uses ACBrUtil.Base, ACBrAAC ;
{$IFNDEF FPC}
   {$R DCLACBrComum.dcr}
{$ENDIF}

{$IFDEF  RTL170_UP}
var
  AboutBoxServices: IOTAAboutBoxServices = nil;
  AboutBoxIndex: Integer = 0;

procedure RegisterAboutBox;
var
  ProductImage: HBITMAP;
begin
  Supports(BorlandIDEServices,IOTAAboutBoxServices, AboutBoxServices);
  Assert(Assigned(AboutBoxServices), '');

  if FindResource(HInstance, 'ACBR', RT_BITMAP) <> 0 then
  begin
    ProductImage := LoadBitmap(FindResourceHInstance(HInstance), 'ACBR');
    AboutBoxIndex := AboutBoxServices.AddPluginInfo(cACBrSobreTitulo , cACBrSobreDescricao,
      ProductImage, False, cACBrSobreLicencaStatus);
  end;
end;

procedure UnregisterAboutBox;
begin
  if (AboutBoxIndex <> 0) and Assigned(AboutBoxServices) then
  begin
    AboutBoxServices.RemovePluginInfo(AboutBoxIndex);
    AboutBoxIndex := 0;
    AboutBoxServices := nil;
  end;
end;

procedure AddSplash;
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  try
    if FindResource(HInstance, 'ACBR', RT_BITMAP) <> 0 then
    begin
      bmp.LoadFromResourceName(HInstance, 'ACBR');
      SplashScreenServices.AddPluginBitmap(cACBrSobreDialogoTitulo,bmp.Handle,false,cACBrSobreLicencaStatus,'');
    end;
  finally
    bmp.Free;
  end;
end;
{$ENDIF}

procedure Register;
begin
  {$IFDEF DELPHICOMPILER9_UP}
  ForceDemandLoadState(dlDisable);
  {$ENDIF}
  RegisterComponents('ACBrDiversos', [TACBrAAC]);

  RegisterPropertyEditor(TypeInfo(TACBrAboutInfo), nil, 'AboutACBr',
     TACBrAboutDialogProperty);
end;

{ TACBrFileINIProperty }

function TACBrFileINIProperty.GetFilter: String;
begin
  Result := 'Arquivos INI|*.ini'
end;

{ TACBrAboutDialogProperty }
procedure TACBrAboutDialogProperty.Edit;
begin
  ACBrAboutDialog ;
end;

function TACBrAboutDialogProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TACBrAboutDialogProperty.GetValue: string;
begin
  Result := 'https://projetoacbr.com.br' ;
end;

{ TACBrFileProperty }

function TACBrFileProperty.GetFilter: String;
begin
  Result := '';
end;

procedure TACBrFileProperty.Edit;
var Dlg : TOpenDialog ;
begin
  Dlg := TOpenDialog.Create( nil );
  try
     Dlg.FileName   := GetValue ;
     Dlg.InitialDir := ExtractFilePath( GetValue ) ;
     Dlg.Filter     := GetFilter ;

     if Dlg.Execute then
        SetValue( Dlg.FileName );
  finally
     Dlg.Free ;
  end ;
end;

function TACBrFileProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

{ TACBrDirProperty }

procedure TACBrDirProperty.Edit;
Var
{$IFNDEF VisualCLX} Dir : String ; {$ELSE} Dir : WideString ; {$ENDIF}
begin
  {$IFNDEF VisualCLX}
  Dir := GetValue ;
  if SelectDirectory(Dir,[],0) then
     SetValue( Dir ) ;
  {$ELSE}
  Dir := '' ;
  if SelectDirectory('Selecione o Diret�rio','',Dir) then
     SetValue( Dir ) ;
  {$ENDIF}
end;

function TACBrDirProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

{$IFDEF RTL170_UP}
initialization
	AddSplash;
	RegisterAboutBox;
	
finalization
	UnregisterAboutBox;
{$ENDIF}

{$IFDEF FPC}
initialization
   {$I ACBrComum.lrs}
{$ENDIF}

end.

