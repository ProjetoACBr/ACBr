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

unit ACBrInstallUtils;

interface

uses SysUtils, Windows, Messages, Classes, Forms;

  function RunAsAdminAndWaitForCompletion(hWnd: HWND; const filename: string; Fapp: TApplication): Boolean;
  function PathSystem: String;
  procedure GetDriveLetters(AList: TStrings);
  function RegistrarActiveXServer(const AServerLocation: string; const ARegister: Boolean): Boolean;
  procedure DesligarDefineACBrInc(const ArquivoACBrInc: TFileName; const ADefineName: String; const ADesligar: Boolean);
  function FindDirPackage(const aDir: String; const sPacote: String): string;

  function VersionNumberToNome(const AVersionStr: string): string;
  function GetSystemWindowsDirectory(lpBuffer: LPWSTR; uSize: UINT): UINT; stdcall;

implementation

uses
  ShellApi, Types, IOUtils;

function GetSystemWindowsDirectory; external kernel32 name 'GetSystemWindowsDirectoryW';

procedure GetDriveLetters(AList: TStrings);
var
  vDrivesSize: Cardinal;
  vDrives: array[0..128] of Char;
  vDrive: PChar;
  vDriveType: Cardinal;
begin
  AList.BeginUpdate;
  try
    // clear the list from possible leftover from prior operations
    AList.Clear;
    vDrivesSize := GetLogicalDriveStrings(SizeOf(vDrives), vDrives);
    if vDrivesSize = 0 then
      Exit;

    vDrive := vDrives;
    while vDrive^ <> #0 do
    begin
      // adicionar somente drives fixos
      vDriveType := GetDriveType(vDrive);
      if vDriveType = DRIVE_FIXED then
        AList.Add(StrPas(vDrive));

      Inc(vDrive, SizeOf(vDrive));
    end;
  finally
	  AList.EndUpdate;
  end;
end;

function RunAsAdminAndWaitForCompletion(hWnd: HWND; const filename: string; Fapp: TApplication): Boolean;
{
    See Step 3: Redesign for UAC Compatibility (UAC)
    http://msdn.microsoft.com/en-us/library/bb756922.aspx
}
var
  sei: TShellExecuteInfo;
  ExitCode: DWORD;
begin
  ZeroMemory(@sei, SizeOf(sei));
  sei.cbSize       := SizeOf(TShellExecuteInfo);
  sei.Wnd          := hwnd;
  sei.fMask        := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI or SEE_MASK_NOCLOSEPROCESS;
  sei.lpVerb       := PWideChar('runas');
  sei.lpFile       := PWideChar(Filename);
  sei.lpParameters := PWideChar('');
  sei.nShow        := SW_HIDE;

  if ShellExecuteEx(@sei) then
  begin
    repeat
      FApp.ProcessMessages;
      GetExitCodeProcess(sei.hProcess, ExitCode) ;
    until (ExitCode <> STILL_ACTIVE) or  FApp.Terminated;
  end;
  Result := True;
end;

function RegistrarActiveXServer(const AServerLocation: string;
  const ARegister: Boolean): Boolean;
var
  ServerDllRegisterServer: function: HResult; stdcall;
  ServerDllUnregisterServer: function: HResult; stdcall;
  ServerHandle: THandle;

  procedure UnloadServerFunctions;
  begin
    @ServerDllRegisterServer := nil;
    @ServerDllUnregisterServer := nil;
    FreeLibrary(ServerHandle);
  end;

  function LoadServerFunctions: Boolean;
  begin
    Result := False;
    ServerHandle := SafeLoadLibrary(AServerLocation);

    if (ServerHandle <> 0) then
    begin
      @ServerDllRegisterServer := GetProcAddress(ServerHandle, 'DllRegisterServer');
      @ServerDllUnregisterServer := GetProcAddress(ServerHandle, 'DllUnregisterServer');

      if (@ServerDllRegisterServer = nil) or (@ServerDllUnregisterServer = nil) then
        UnloadServerFunctions
      else
        Result := True;
    end;
  end;
begin
  Result := False;
  try
    if LoadServerFunctions then
    try
      if ARegister then
        Result := ServerDllRegisterServer = S_OK
      else
        Result := ServerDllUnregisterServer = S_OK;
    finally
      UnloadServerFunctions;
    end;
  except
    //pra que esse try..except??
  end;
end;

procedure DesligarDefineACBrInc(const ArquivoACBrInc: TFileName; const ADefineName: String; const ADesligar: Boolean);
var
  F: TStringList;
  I: Integer;
begin
  F := TStringList.Create;
  try
    F.LoadFromFile(ArquivoACBrInc);
    for I := 0 to F.Count - 1 do
    begin
      if Pos(ADefineName.ToUpper, F[I].ToUpper) > 0 then
      begin
        if ADesligar then
          F[I] := '{$DEFINE ' + ADefineName + '}'
        else
          F[I] := '{.$DEFINE ' + ADefineName + '}';

        Break;
      end;
    end;
    F.SaveToFile(ArquivoACBrInc);
  finally
    F.Free;
  end;
end;

function FindDirPackage(const aDir: String; const sPacote: String): string;
var
  oDirList: TSearchRec;
  sDir: String;
begin
  //Retorna uma string vazia caso n�o tenha encontrado o diret�rio do pacote.
  Result := '';
  sDir := IncludeTrailingPathDelimiter(aDir);
  if not DirectoryExists(sDir) then
    Exit;

  if SysUtils.FindFirst(sDir + '*.*', faAnyFile, oDirList) = 0 then
  begin
    try
      repeat
        if (oDirList.Name = '.')  or (oDirList.Name = '..') or (oDirList.Name = '__history') or
           (oDirList.Name = '__recovery') or (oDirList.Name = 'backup') then
          Continue;

        if DirectoryExists(sDir + oDirList.Name) then
        begin
          Result := FindDirPackage(sDir + oDirList.Name, sPacote);
        end
        else
        begin
          if UpperCase(oDirList.Name) = UpperCase(sPacote) then
            Result := IncludeTrailingPathDelimiter(sDir);
        end;

      until (SysUtils.FindNext(oDirList) <> 0) or (Result <> '');
    finally
      SysUtils.FindClose(oDirList);
    end;
  end;
end;

function PathSystem: String;
var
  strTmp: array[0..MAX_PATH] of char;
  DirWindows: String;
const
  SYS_64 = 'SysWOW64';
  SYS_32 = 'System32';
begin
  // retorna o diret�rio de sistema atual
  Result := '';

  // verifica se aplicacao esta rodando em sessao de terminal server.
  if GetSystemWindowsDirectory(strTmp, MAX_PATH) > 0 then
  begin
    DirWindows := Trim(StrPas(strTmp));
    DirWindows := IncludeTrailingPathDelimiter(DirWindows);

    if DirectoryExists(DirWindows + SYS_64) then
      Result := DirWindows + SYS_64
    else
    if DirectoryExists(DirWindows + SYS_32) then
      Result := DirWindows + SYS_32
    else
      raise EFileNotFoundException.Create('Diret�rio de sistema n�o encontrado.');
  end
  else
    raise EFileNotFoundException.Create('Ocorreu um erro ao tentar obter o diret�rio do windows.');
end;

function VersionNumberToNome(const AVersionStr: string): string;
begin
  if      AVersionStr = 'd3' then
    Result := 'Delphi 3'
  else if AVersionStr = 'd4' then
    Result := 'Delphi 4'
  else if AVersionStr = 'd5' then
    Result := 'Delphi 5'
  else if AVersionStr = 'd6' then
    Result := 'Delphi 6'
  else if AVersionStr = 'd7' then
    Result := 'Delphi 7'
  else if AVersionStr = 'd9' then
    Result := 'Delphi 2005'
  else if AVersionStr = 'd10' then
    Result := 'Delphi 2006'
  else if AVersionStr = 'd11' then
    Result := 'Delphi 2007'
  else if AVersionStr = 'd12' then
    Result := 'Delphi 2009'
  else if AVersionStr = 'd14' then
    Result := 'Delphi 2010'
  else if AVersionStr = 'd15' then
    Result := 'Delphi XE'
  else if AVersionStr = 'd16' then
    Result := 'Delphi XE2'
  else if AVersionStr = 'd17' then
    Result := 'Delphi XE3'
  else if AVersionStr = 'd18' then
    Result := 'Delphi XE4'
  else if AVersionStr = 'd19' then
    Result := 'Delphi XE5'
  else if AVersionStr = 'd20' then
    Result := 'Delphi XE6'
  else if AVersionStr = 'd21' then
    Result := 'Delphi XE7'
  else if AVersionStr = 'd22' then
    Result := 'Delphi XE8'
  else if AVersionStr = 'd23' then
    Result := 'Delphi 10 Seattle'
  else if AVersionStr = 'd24' then
    Result := 'Delphi 10.1 Berlin'
  else if AVersionStr = 'd25' then
    Result := 'Delphi 10.2 Tokyo'
  else if AVersionStr = 'd26' then
    Result := 'Delphi 10.3 Rio'
  else if AVersionStr = 'd27' then
    Result := 'Delphi 10.4 Sydney'
  else if AVersionStr = 'd28' then
    Result := 'Delphi 11 Alexandria'
  else if AVersionStr = 'd29' then
    Result := 'Delphi 12 Athens'
  else
    Result := ' - ';
end;

end.
