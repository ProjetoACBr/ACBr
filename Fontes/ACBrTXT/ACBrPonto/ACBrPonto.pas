{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Albert Eije                                     }
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
unit ACBrPonto;

interface

uses
  SysUtils, Classes, DateUtils, ACBrBase,
  {$IFNDEF Framework}
    {$IFDEF FPC}
      LResources,
    {$ENDIF}
  {$ENDIF}
  Forms,
  ACBrTXTClass, ACBrUtil.Strings,
  ACBrPonto_AFD, ACBrPonto_AFD_Class,
  ACBrPonto_AFDT, ACBrPonto_AFDT_Class,
  ACBrPonto_ACJEF, ACBrPonto_ACJEF_Class,
  ACBrPonto.AEJ;

type

  // DECLARANDO O COMPONENTE:

  { TACBrPonto }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrPonto = class(TACBrComponent)
  private
    FOnError: TErrorEvent;

    FPath: String; // Path do arquivo a ser gerado
    FDelimitador: String; // Caracter delimitador de campos
    FReplaceDelimitador: Boolean;
    FTrimString: boolean; // Retorna a string sem espa�os em branco iniciais e finais
    FCurMascara: String; // Mascara para valores tipo currency

    FPonto_AFD: TPonto_AFD;
    FPonto_AFDT: TPonto_AFDT;
    FPonto_ACJEF: TPonto_ACJEF;
    FAEJ: TAEJ;

    function GetDelimitador: String;
    function GetReplaceDelimitador: Boolean;
    function GetTrimString: boolean;
    function GetCurMascara: String;
    procedure SetDelimitador(const Value: String);
    procedure SetReplaceDelimitador(const Value: Boolean);
    procedure SetTrimString(const Value: boolean);
    procedure SetCurMascara(const Value: String);

    function GetOnError: TErrorEvent; // M�todo do evento OnError
    procedure SetOnError(const Value: TErrorEvent); // M�todo SetError

  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override; // Create
    destructor Destroy; override; // Destroy

    function SaveFileTXT_AFD(const Arquivo: String): boolean; // M�todo que escreve o arquivo texto no caminho passado como par�metro
    function SaveFileTXT_AFDT(const Arquivo: String): boolean; // M�todo que escreve o arquivo texto no caminho passado como par�metro
    function SaveFileTXT_ACJEF(const Arquivo: String): boolean; // M�todo que escreve o arquivo texto no caminho passado como par�metro
    function SaveFileTXT_AEJ(const Arquivo: String): boolean;

    function ProcessarArquivo_AFD(const Arquivo: String): TPonto_AFD;
    function ProcessarArquivo_AFDT(const Arquivo: String): TPonto_AFDT;

    property Ponto_AFD: TPonto_AFD read FPonto_AFD write FPonto_AFD;
    property Ponto_AFDT: TPonto_AFDT read FPonto_AFDT write FPonto_AFDT;
    property Ponto_ACJEF: TPonto_ACJEF read FPonto_ACJEF write FPonto_ACJEF;
    property AEJ: TAEJ read FAEJ write FAEJ;

  published
    property Path: String read FPath write FPath;

    property Delimitador: String read GetDelimitador write SetDelimitador;
    property ReplaceDelimitador: Boolean read GetReplaceDelimitador write SetReplaceDelimitador;
    property TrimString: boolean read GetTrimString write SetTrimString default True;
    property CurMascara: String read GetCurMascara write SetCurMascara;

    property OnError: TErrorEvent read GetOnError write SetOnError;
  end;

implementation

Uses
{$IFDEF COMPILER6_UP} StrUtils {$ELSE} ACBrD5 {$ENDIF};
{$IFNDEF FPC}
{$R ACBrPonto.dcr}
{$ENDIF}

constructor TACBrPonto.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPonto_AFD := TPonto_AFD.Create;
  FPonto_AFDT := TPonto_AFDT.Create;
  FPonto_ACJEF := TPonto_ACJEF.Create;
  FAEJ := TAEJ.Create;


  FPath := ExtractFilePath(ParamStr(0));

  Delimitador        := '';    //N�o chamamos a vari�vel diretamente pois precisa-se alterar os registros filhos tamb�m.
  CurMascara         := '';    //N�o chamamos a vari�vel diretamente pois precisa-se alterar os registros filhos tamb�m.
  TrimString         := True;  //N�o chamamos a vari�vel diretamente pois precisa-se alterar os registros filhos tamb�m.
  ReplaceDelimitador := False; //N�o chamamos a vari�vel diretamente pois precisa-se alterar os registros filhos tamb�m.
end;

destructor TACBrPonto.Destroy;
begin
  FPonto_AFD.Free;
  FPonto_AFDT.Free;
  FPonto_ACJEF.Free;
  FAEJ.Free;

  inherited;
end;

function TACBrPonto.GetDelimitador: String;
begin
  Result := FDelimitador;
end;

procedure TACBrPonto.SetDelimitador(const Value: String);
begin
  FDelimitador := Value;

  FPonto_AFD.Delimitador   := Value;
  FPonto_AFDT.Delimitador  := Value;
  FPonto_ACJEF.Delimitador := Value;
  FAEJ.Delimitador := Value;
end;

function TACBrPonto.GetCurMascara: String;
begin
  Result := FCurMascara;
end;

procedure TACBrPonto.SetCurMascara(const Value: String);
begin
  FCurMascara := Value;

  FPonto_AFD.CurMascara := Value;
  FPonto_AFDT.CurMascara := Value;
  FPonto_ACJEF.CurMascara := Value;
  FAEJ.CurMascara := Value;
end;

function TACBrPonto.GetTrimString: boolean;
begin
  Result := FTrimString;
end;

procedure TACBrPonto.SetTrimString(const Value: boolean);
begin
  FTrimString := Value;

  FPonto_AFD.TrimString := Value;
  FPonto_AFDT.TrimString := Value;
  FPonto_ACJEF.TrimString := Value;
  FAEJ.TrimString := Value;
end;

function TACBrPonto.GetOnError: TErrorEvent;
begin
  Result := FOnError;
end;

function TACBrPonto.GetReplaceDelimitador: Boolean;
begin
  Result := FReplaceDelimitador;
end;

procedure TACBrPonto.SetOnError(const Value: TErrorEvent);
begin
  FOnError := Value;

  FPonto_AFD.OnError := Value;
  FPonto_AFDT.OnError := Value;
  FPonto_ACJEF.OnError := Value;
  FAEJ.OnError := Value;
end;

procedure TACBrPonto.SetReplaceDelimitador(const Value: Boolean);
begin
  FReplaceDelimitador := Value;

  FPonto_AFD.ReplaceDelimitador   := Value;
  FPonto_AFDT.ReplaceDelimitador  := Value;
  FPonto_ACJEF.ReplaceDelimitador := Value;
  FAEJ.ReplaceDelimitador := Value;
end;

function TACBrPonto.SaveFileTXT_AFD(const Arquivo: String): boolean;
var
  txtFile: TextFile;
begin
  Result := True;

  if (Trim(Arquivo) = '') or (Trim(FPath) = '') then
    raise Exception.Create('Caminho ou nome do arquivo n�o informado!');

  try
    AssignFile(txtFile, FPath + Arquivo);
    try
      Rewrite(txtFile);

      Write(txtFile, FPonto_AFD.WriteCabecalho);

      Write(txtFile, FPonto_AFD.WriteRegistro2);

      if FPonto_AFD.Registro3.Count > 0 then
        Write(txtFile, FPonto_AFD.WriteRegistro3);

      if FPonto_AFD.Registro4.Count > 0 then
        Write(txtFile, FPonto_AFD.WriteRegistro4);

      if FPonto_AFD.Registro5.Count > 0 then
        Write(txtFile, FPonto_AFD.WriteRegistro5);

      Write(txtFile, FPonto_AFD.WriteTrailer);

    finally
      CloseFile(txtFile);
    end;

    // Limpa todos os registros.
    FPonto_AFD.LimpaRegistros;
  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TACBrPonto.SaveFileTXT_AFDT(const Arquivo: String): boolean;
var
  txtFile: TextFile;
begin
  Result := True;

  if (Trim(Arquivo) = '') or (Trim(FPath) = '') then
    raise Exception.Create('Caminho ou nome do arquivo n�o informado!');

  try
    AssignFile(txtFile, FPath + Arquivo);
    try
      Rewrite(txtFile);

      Write(txtFile, FPonto_AFDT.WriteCabecalho);

      if FPonto_AFDT.Registro2.Count > 0 then
        Write(txtFile, FPonto_AFDT.WriteRegistro2);

      Write(txtFile, FPonto_AFDT.WriteTrailer);

    finally
      CloseFile(txtFile);
    end;

    // Limpa de todos os Blocos as listas de todos os registros.
    FPonto_AFDT.LimpaRegistros;
  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TACBrPonto.SaveFileTXT_ACJEF(const Arquivo: String): boolean;
var
  txtFile: TextFile;
begin
  Result := True;

  if (Trim(Arquivo) = '') or (Trim(FPath) = '') then
    raise Exception.Create('Caminho ou nome do arquivo n�o informado!');

  try
    AssignFile(txtFile, FPath + Arquivo);
    try
      Rewrite(txtFile);

      Write(txtFile, FPonto_ACJEF.WriteCabecalho);

      if FPonto_ACJEF.Registro2.Count > 0 then
        Write(txtFile, FPonto_ACJEF.WriteRegistro2);

      if FPonto_ACJEF.Registro3.Count > 0 then
        Write(txtFile, FPonto_ACJEF.WriteRegistro3);

      Write(txtFile, FPonto_ACJEF.WriteTrailer);

    finally
      CloseFile(txtFile);
    end;

    // Limpa todos os registros.
    FPonto_ACJEF.LimpaRegistros;
  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TACBrPonto.SaveFileTXT_AEJ(const Arquivo: String): boolean;
var
  txtFile: TextFile;
begin
  Result := True;

  if (Trim(Arquivo) = '') or (Trim(FPath) = '') then
    raise Exception.Create('Caminho ou nome do arquivo n�o informado!');

  try
    AssignFile(txtFile, FPath + Arquivo);
    try
      Rewrite(txtFile);

      if FAEJ.Cabecalho.Count > 0 then
        Write(txtFile, FAEJ.Cabecalho.GetStr);

      if FAEJ.Registro02.Count > 0 then
        Write(txtFile, FAEJ.Registro02.GetStr);

      if FAEJ.Registro03.Count > 0 then
        Write(txtFile, FAEJ.Registro03.GetStr);

      if FAEJ.Registro04.Count > 0 then
        Write(txtFile, FAEJ.Registro04.GetStr);

      if FAEJ.Registro05.Count > 0 then
        Write(txtFile, FAEJ.Registro05.GetStr);

      if FAEJ.Registro06.Count > 0 then
        Write(txtFile, FAEJ.Registro06.GetStr);

      if FAEJ.Registro07.Count > 0 then
        Write(txtFile, FAEJ.Registro07.GetStr);

      if FAEJ.Registro08.Count > 0 then
        Write(txtFile, FAEJ.Registro08.GetStr);

      Write(txtFile, FAEJ.Trailer.GetStr);

      Write(txtFile, FAEJ.AssinaturaDigital.GetStr);

    finally
      CloseFile(txtFile);
    end;

    AEJ.LimpaRegistros;
  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TACBrPonto.ProcessarArquivo_AFD(const Arquivo: String): TPonto_AFD;
var
  LerArquivo: TStringList;
  i: Integer;
begin
  Result := TPonto_AFD.Create;

  LerArquivo := TStringList.Create;
	try
		LerArquivo.LoadFromFile(Arquivo);
		for i := 0 to LerArquivo.Count - 1 do
		begin
			//cabecalho
			if Copy(LerArquivo[i], 10, 1) = '1' then
			begin
				with Result.Cabecalho.Create do
				begin
					Campo01 := Copy(LerArquivo[i], 1, 9);
					Campo02 := Copy(LerArquivo[i], 10, 1);
					Campo03 := Copy(LerArquivo[i], 11, 1);
					Campo04 := Copy(LerArquivo[i], 12, 14);
					Campo05 := Copy(LerArquivo[i], 26, 12);
					Campo06 := Copy(LerArquivo[i], 38, 150);
					Campo07 := Copy(LerArquivo[i], 188, 17);
					Campo08 := Copy(LerArquivo[i], 205, 8);
					Campo09 := Copy(LerArquivo[i], 213, 8);
					Campo10 := Copy(LerArquivo[i], 221, 8);
					Campo11 := Copy(LerArquivo[i], 229, 4);
				end;
			end

			//registro tipo 2
			else if Copy(LerArquivo[i], 10, 1) = '2' then
			begin
				with Result.Registro2.Create do
				begin
					Campo01 := Copy(LerArquivo[i], 1, 9);
					Campo02 := Copy(LerArquivo[i], 10, 1);
					Campo03 := Copy(LerArquivo[i], 11, 8);
					Campo04 := Copy(LerArquivo[i], 19, 4);
					Campo05 := Copy(LerArquivo[i], 23, 1);
					Campo06 := Copy(LerArquivo[i], 24, 14);
					Campo07 := Copy(LerArquivo[i], 38, 12);
					Campo08 := Copy(LerArquivo[i], 50, 150);
					Campo09 := Copy(LerArquivo[i], 200, 100);
				end;
			end

			//registros tipo 3
			else if Copy(LerArquivo[i], 10, 1) = '3' then
			begin
				with Result.Registro3.New do
				begin
					Campo01 := Copy(LerArquivo[i], 1, 9);
					Campo02 := Copy(LerArquivo[i], 10, 1);
					Campo03 := Copy(LerArquivo[i], 11, 8);
					Campo04 := Copy(LerArquivo[i], 19, 4);
					Campo05 := Copy(LerArquivo[i], 23, 12);
				end;
			end

			//registros tipo 4
			else if Copy(LerArquivo[i], 10, 1) = '4' then
			begin
				with Result.Registro4.New do
				begin
					Campo01 := Copy(LerArquivo[i], 1, 9);
					Campo02 := Copy(LerArquivo[i], 10, 1);
					Campo03 := Copy(LerArquivo[i], 11, 8);
					Campo04 := Copy(LerArquivo[i], 19, 4);
					Campo05 := Copy(LerArquivo[i], 23, 8);
					Campo06 := Copy(LerArquivo[i], 31, 4);
				end;
			end

			//registros tipo 5
			else if Copy(LerArquivo[i], 10, 1) = '5' then
			begin
				with Result.Registro5.New do
				begin
					Campo01 := Copy(LerArquivo[i], 1, 9);
					Campo02 := Copy(LerArquivo[i], 10, 1);
					Campo03 := Copy(LerArquivo[i], 11, 8);
					Campo04 := Copy(LerArquivo[i], 19, 4);
					Campo05 := Copy(LerArquivo[i], 23, 1);
					Campo06 := Copy(LerArquivo[i], 24, 12);
					Campo07 := Copy(LerArquivo[i], 36, 52);
				end;
			end

			//trailer
			else if Copy(LerArquivo[i], 1, 9) = '999999999' then
			begin
				with Result.Trailer.Create do
				begin
					Campo01 := Copy(LerArquivo[i], 1, 9);
					Campo02 := StrToInt(Copy(LerArquivo[i], 10, 9));
					Campo03 := StrToInt(Copy(LerArquivo[i], 19, 9));
					Campo04 := StrToInt(Copy(LerArquivo[i], 28, 9));
					Campo05 := StrToInt(Copy(LerArquivo[i], 37, 9));
					Campo06 := Copy(LerArquivo[i], 46, 1);
				end;
			end;

		end;
	finally
		LerArquivo.Free;
	end;
end;

function TACBrPonto.ProcessarArquivo_AFDT(const Arquivo: String): TPonto_AFDT;
var
  LerArquivo: TStringList;
  i: Integer;
begin
  Result := TPonto_AFDT.Create;

  LerArquivo := TStringList.Create;
	try
		LerArquivo.LoadFromFile(Arquivo);
		for i := 0 to LerArquivo.Count - 1 do
		begin
			// cabecalho
			if Copy(LerArquivo[i], 10, 1) = '1' then
			begin
				with Result.Cabecalho.Create do
				begin
					Campo01 := Copy(LerArquivo[i], 1, 9); // Sequencial
					Campo02 := Copy(LerArquivo[i], 10, 1); // Tipo do registro
					Campo03 := Copy(LerArquivo[i], 11, 1); // Identificador do empregador
					Campo04 := Copy(LerArquivo[i], 12, 14); // CNPJ/CPF
					Campo05 := Copy(LerArquivo[i], 26, 12); // CEI
					Campo06 := Copy(LerArquivo[i], 38, 150); // Raz�o
					Campo07 := Copy(LerArquivo[i], 188, 8); // Data inicial
					Campo08 := Copy(LerArquivo[i], 196, 8); // Data final
					Campo09 := Copy(LerArquivo[i], 204, 8); // Data da gera��o
					Campo10 := Copy(LerArquivo[i], 212, 4); // Hora da gera��o
				end;
			end

			// registro tipo 2
			else if Copy(LerArquivo[i], 10, 1) = '2' then
			begin
				with Result.Registro2.New do
				begin
					Campo01 := Copy(LerArquivo[i], 1, 9); // Seq�encial do registro no arquivo.
					Campo02 := Copy(LerArquivo[i], 10, 1); // Tipo do registro, �2�.
					Campo03 := Copy(LerArquivo[i], 11, 8); // Data da marca��o do ponto, no formato �ddmmaaaa�.
					Campo04 := Copy(LerArquivo[i], 19, 4); // Hor�rio da marca��o do ponto, no formato �hhmm�.
					Campo05 := Copy(LerArquivo[i], 23, 12); // N�mero do PIS do empregado.
					Campo06 := Copy(LerArquivo[i], 35, 17); // N�mero de fabrica��o do REP onde foi feito o registro.
					Campo07 := Copy(LerArquivo[i], 52, 1);
					// Tipo de marca��o, �E� para ENTRADA, �S� para SA�DA ou �D� para registro a ser DESCONSIDERADO.
					Campo08 := Copy(LerArquivo[i], 53, 2);
					// N�mero seq�encial por empregado e jornada para o conjunto Entrada/Sa�da. Vide observa��o.
					Campo09 := Copy(LerArquivo[i], 55, 1);
					// Tipo de registro: �O� para registro eletr�nico ORIGINAL, �I� para registro INCLU�DO por digita��o, �P� para intervalo PR�-ASSINALADO.
					Campo10 := Copy(LerArquivo[i], 56, 100); // Motivo: Campo a ser preenchido se o campo 7 for �D� ou se o campo 9 for �I�.
				end;
			end

			// trailer
			else if Copy(LerArquivo[i], 1, 9) = '999999999' then
			begin
				with Result.Trailer.Create do
				begin
					Campo01 := Copy(LerArquivo[i], 1, 9);
					Campo02 := Copy(LerArquivo[i], 10, 1);
				end;
			end;

		end;
	finally
		LerArquivo.free;
	end;
end;

procedure TACBrPonto.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
end;

{$IFDEF FPC}
initialization
   {$I ACBrPonto.lrs}
{$ENDIF}

end.
