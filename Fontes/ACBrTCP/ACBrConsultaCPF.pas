{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrConsultaCPF;

interface

uses
  SysUtils, Classes, types, IniFiles,
  ACBrBase, ACBrSocket;

type
  EACBrConsultaCPFException = class ( Exception );

  { TACBrConsultaCPF }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrConsultaCPF = class(TACBrHTTP)
  private
    FDataNascimento: String;
    FDataInscricao: String;
    FNome: String;
    FNomeSocial : String;
    FSituacao: String;
    FCPF: String;
    FDigitoVerificador: String;
    FEmissao: String;
    FCodCtrlControle: String;
    FTokenCaptcha: String;
    FIniServicos: string;
    FResourceName: String;
    FParams: TStrings;

    function VerificarErros(const Str: String): String;
    function LerCampo(Texto: TStringList; NomeCampo: String): String;
    function GetCaptchaURL : String ;
    function GetIniServicos: String;
    procedure LerParams;
    function LerSessaoChaveIni(const Sessao, Chave : String):String;
    function LerParamsIniServicos: AnsiString;
    function LerParamsInterno: AnsiString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Captcha(Stream: TStream);
    function Consulta(const ACPF, DataNasc, ACaptcha: String;
      ARemoverEspacosDuplos: Boolean = False): Boolean;
  published
    property CPF: String Read FCPF Write FCPF;
    property DataNascimento : String Read FDataNascimento write FDataNascimento;
    property DataInscricao : String Read FDataInscricao write FDataInscricao;
    property Nome: String Read FNome;
    property Situacao: String Read FSituacao;
    property DigitoVerificador: String Read FDigitoVerificador;
    property Emissao: String Read FEmissao;
    property CodCtrlControle: String Read FCodCtrlControle;
    property IniServicos : string read GetIniServicos write FIniServicos;

  end;

implementation

{$IFDEF FPC}
 {$R ACBrConsultaCPFServicos.rc}
{$ELSE}
 {$R ACBrConsultaCPFServicos.res}
{$ENDIF}

uses
  strutils,
  ACBrUtil.Strings,
  ACBrUtil.XMLHTML,
  ACBrValidador,
  ACBrUtil.FilesIO,
  synacode, synautil, blcksock;

constructor TACBrConsultaCPF.Create(AOwner: TComponent);
begin
  {$MESSAGE WARN 'Informamos que o suporte ao Componente ACBrConsultaCPF foi descontinuado devido ao encerramento do suporte a URL da Receita Federal do Brasil. '}
  {$MESSAGE WARN 'No momento, este componente n�o � funcional. Qualquer atualiza��o ou novo suporte ser� notificado no f�rum. Estamos � disposi��o para esclarecer eventuais d�vidas.'}
  inherited Create(AOwner);
  HTTPSend.Sock.SSL.SSLType := LT_TLSv1;
  FResourceName := 'ACBrConsultaCPFServicos';
  FParams := TStringList.Create;
  LerParams;
end;

destructor TACBrConsultaCPF.Destroy;
begin
  FParams.Free;
  inherited;
end;

function TACBrConsultaCPF.GetCaptchaURL : String ;
var
  AURL, Html: String;
begin
  try
    Self.HTTPGet(LerSessaoChaveIni('ENDERECOS','CAPTCH'));
    Html := DecodeToString(HTTPResponse, RespIsUTF8);
    //Debug
    //WriteToTXT('C:\TEMP\ACBrConsultaCPF-Captcha.TXT',Html);
    AURL := RetornarConteudoEntre(Html, 'src="data:image/png;base64,', '">');
    
    Result := StringReplace(AURL, 'amp;', '', []);
  except
    on E: Exception do
    begin
      raise EACBrConsultaCPFException.Create('Erro na hora de obter a URL do captcha.'+#13#10+E.Message);
    end;
  end;
end;

function TACBrConsultaCPF.GetIniServicos: String;
begin
  if FIniServicos = '' then
    FIniServicos := ApplicationPath + FResourceName +'.ini';
  Result := FIniServicos;
end;

procedure TACBrConsultaCPF.Captcha(Stream: TStream);
var
  LErro : String;
begin
  LErro := 'Informamos que o suporte ao Componente ACBrConsultaCPF foi descontinuado devido ao encerramento do suporte a URL da Receita Federal do Brasil. '+
           'No momento, este componente n�o � funcional. Qualquer atualiza��o ou novo suporte ser� notificado no f�rum. Estamos � disposi��o para esclarecer eventuais d�vidas.';
  raise EACBrConsultaCPFException.Create(LErro);


  try
    Stream.Size := 0; // Trunca o Stream
    WriteStrToStream(Stream, DecodeBase64(GetCaptchaURL));
    Stream.Position:= 0;
  Except
    on E: Exception do
    begin
      LErro := 'Erro na hora de fazer o download da imagem do captcha.';
      if HttpSend.ResultCode = 404 then
        LErro := LErro + sLineBreak + 'Servi�o depreciado/descontinuado pela Receita Federal do Brasil! n�o disponivel para consulta.'
      else
        LErro := LErro + sLineBreak + E.Message;

      raise EACBrConsultaCPFException.Create(LErro);
    end;
  end;
end;

function TACBrConsultaCPF.VerificarErros(const Str: String): String;
var
  Res: String;
begin
  Res := '';
  if Res = '' then
    if Pos( ACBrStr('Os caracteres da imagem n�o foram preenchidos corretamente'), Str) > 0 then
      Res := 'Os caracteres da imagem n�o foram preenchidos corretamente.';

  if Res = '' then
    if Pos(ACBrStr('O n�mero do CPF n�o � v�lido. Verifique se o mesmo foi digitado corretamente.'), Str) > 0 then
      Res := 'O n�mero do CPF n�o � v�lido. Verifique se o mesmo foi digitado corretamente.';

  if Res = '' then
    if Pos(ACBrStr('N�o existe no Cadastro de Pessoas Jur�dicas o n�mero de CPF informado. '+
                   'Verifique se o mesmo foi digitado corretamente.'), Str) > 0 then
      Res := 'N�o existe no Cadastro de Pessoas Jur�dicas o n�mero de CPF informado. '+
             'Verifique se o mesmo foi digitado corretamente.';

  if Res = '' then
    if Pos(ACBrStr('a. No momento n�o podemos atender a sua solicita��o. Por favor tente mais tarde.'), Str) > 0 then
      Res := 'Erro no site da receita federal. Tente mais tarde.';

  Result := ACBrStr(Res);
end;

function TACBrConsultaCPF.LerCampo(Texto : TStringList ; NomeCampo : String
  ) : String ;
var
  i : integer;
  linha : String;
begin
  NomeCampo := ACBrStr(NomeCampo);
  Result := '';
  for i := 0 to Texto.Count-1 do
  begin
    linha := Texto[i];
    if Pos(NomeCampo, linha) > 0 then
    begin
      Result := Trim(StringReplace(linha, NomeCampo, ' ',[rfReplaceAll]));
      break;
    end;
  end
end;

procedure TACBrConsultaCPF.LerParams;
var
  ConteudoParams: AnsiString;
begin
  ConteudoParams := LerParamsIniServicos;

  if ConteudoParams = '' then
    ConteudoParams := LerParamsInterno;

  FParams.Text := ConteudoParams;
end;

function TACBrConsultaCPF.LerParamsIniServicos: AnsiString;
var
  ArqIni: String;
  FS: TFileStream;
begin
  Result := '';
  ArqIni := Trim(IniServicos);
  if (ArqIni <> '') and FileExists(ArqIni) then
  begin
    FS := TFileStream.Create(ArqIni, fmOpenRead or fmShareDenyNone);
    try
      FS.Position := 0;
      Result := ReadStrFromStream(FS, FS.Size);
    finally
      FS.Free;
    end;
  end;
end;

function TACBrConsultaCPF.LerParamsInterno: AnsiString;
var
  RS: TResourceStream;
begin
  Result := '';

  RS := TResourceStream.Create(HInstance, FResourceName, RT_RCDATA);
  try
    RS.Position := 0;
    Result := ReadStrFromStream(RS, RS.Size);
  finally
    RS.Free;
  end;
end;

function TACBrConsultaCPF.LerSessaoChaveIni(const Sessao,
  Chave: String): String;
begin
  Result := FParams.Values[Chave];
end;

function TACBrConsultaCPF.Consulta(const ACPF, DataNasc,  ACaptcha: String;
  ARemoverEspacosDuplos: Boolean): Boolean;
var
  Post: TStringStream;
  Erro: String;
  Resposta : TStringList;
begin
  Erro := ValidarCPF( ACPF ) ;
  if Erro <> '' then
     raise EACBrConsultaCPFException.Create(Erro);

  //txtCPF=11122334410&txtToken_captcha_serpro_gov_br=299218104152138191166941752496584741018616278361624164&txtTexto_captcha_serpro_gov_br=ZCI8B9&Enviar=Consultar
  Post:= TStringStream.Create('');
  try
    {Post.WriteString('txtCPF='+OnlyNumber(ACPF)+'&');
    //Post.WriteString('tempTxtNascimento='+dataNasc+'&');
    Post.WriteString('txtToken_captcha_serpro_gov_br='+FTokenCaptcha+'&');
    Post.WriteString('txtTexto_captcha_serpro_gov_br='+Trim(ACaptcha)+'&');
    Post.WriteString('Enviar=Consultar');}

    Post.WriteString('TxtCPF='+ACPF+'&');
    Post.WriteString('txtDataNascimento='+datanasc+'&');
    Post.WriteString('txtToken_captcha_serpro_gov_br='+FTokenCaptcha+'&');
    Post.WriteString('txtTexto_captcha_serpro_gov_br='+Trim(ACaptcha)+'&');
    //Post.WriteString('txtTexto_captcha_serpro_gov_br='+Trim(ACaptcha)+'&');
    Post.WriteString('Enviar=Consultar');

    Post.Position:= 0;

    HttpSend.Clear;
    HttpSend.Document.Position:= 0;
    HttpSend.Document.CopyFrom(Post, Post.Size);
    HTTPSend.MimeType := 'application/x-www-form-urlencoded';
    HTTPPost(LerSessaoChaveIni('ENDERECOS','POST'));

    //Debug
    //RespHTTP.SaveToFile('C:\TEMP\ACBrConsultaCPF-1.TXT');

    Erro := VerificarErros(DecodeToString(HTTPResponse, RespIsUTF8));

    if Erro = '' then
    begin
      Result:= True;
      Resposta := TStringList.Create;
      try
        Resposta.Text := StripHTML(DecodeToString(HTTPResponse, RespIsUTF8));
        Resposta.Text := ACBrUtil.XMLHTML.ParseText( Resposta.Text );
        RemoveEmptyLines( Resposta );

        //Debug
        //Resposta.SaveToFile('C:\TEMP\ACBrConsultaCPF-2.TXT');

        FCPF      := LerCampo(Resposta,'No do CPF:');
        FNome     := LerCampo(Resposta,'Nome:');
        if FNome = '' then
          FNome   := LerCampo(Resposta,'Nome Civil:');

        FNomeSocial   := LerCampo(Resposta,'Nome Social:');

        FDataNascimento := LerCampo(Resposta,'Data de Nascimento:');
        FSituacao := LerCampo(Resposta,'Situa��o Cadastral:');
        FDataInscricao := LerCampo(Resposta,'Data da Inscri��o:');
        FEmissao  := LerCampo(Resposta,'Comprovante emitido �s:');
        FCodCtrlControle   := LerCampo(Resposta,'C�digo de controle do comprovante:');
        FDigitoVerificador := LerCampo(Resposta,'Digito Verificador:');

        if Trim(FNome) = '' then
        begin
          Erro     := LerCampo(Resposta,'Data de nascimento informada');
          if Trim(Erro) <> '' then
            Erro := 'Erro de data';
        end;
      finally
        Resposta.Free;
      end ;

      if Trim(Erro) = 'Erro de data' then
        raise EACBrConsultaCPFException.Create('Data de nascimento divergente da base da Receita Federal.');

      if Trim(FNome) = '' then
        raise EACBrConsultaCPFException.Create(ACBrStr('N�o foi poss�vel obter os dados.'));

      if ARemoverEspacosDuplos then
      begin
        FNome := RemoverEspacosDuplos(FNome);
      end;
    end
    else
    begin
      //Se est� sendo levantada uma exception, n�o faz sentido ter retorno na fun��o.
//      Result:= False;
      raise EACBrConsultaCPFException.Create(Erro);
    end;
  finally
    Post.Free;
  end;
end;

end.

