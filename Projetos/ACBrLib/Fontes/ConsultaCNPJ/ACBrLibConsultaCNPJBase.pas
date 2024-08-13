{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo: Antonio Carlos Junior                           }

{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }

{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }

{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }

{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrLibConsultaCNPJBase;

interface

uses
  Classes, SysUtils, ACBrUtil.FilesIO, ACBrUtil.Strings,
  ACBrLibComum, ACBrLibConsultaCNPJDataModule, ACBrTCP, ACBrConsultaCNPJ, ACBrUtil.Base;

Const
  CCAPTCHA_CNPJ = 'CaptchaCNPJ';

type

  { TACBrLibConsultaCNPJ }
  TACBrLibConsultaCNPJ = class (TACBrLib)
    private
      FConsultaCNPJDM: TLibConsultaCNPJDM;

    protected
      procedure CriarConfiguracao(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
      procedure Executar; override;

    public
      constructor Create (ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
      destructor Destroy; override;

      property ConsultaCNPJDM: TLibConsultaCNPJDM read FConsultaCNPJDM;

      function ConsultarCaptcha (ePathDownload: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
      function Consultar (eCNPJ: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer):Integer;


  end;

implementation

Uses
  ACBrLibConsts, ACBrLibConfig,
  ACBrLibConsultaCNPJConfig, ACBrLibConsultaCNPJRespostas;

{ TACBrLibConsultaCNPJ }

constructor TACBrLibConsultaCNPJ.Create(ArqConfig: string; ChaveCrypt: ansistring);
begin
  inherited Create(ArqConfig, ChaveCrypt);

  FConsultaCNPJDM := TLibConsultaCNPJDM.Create(Nil);
  FConsultaCNPJDM.Lib := Self;
end;

destructor TACBrLibConsultaCNPJ.Destroy;
begin
  FConsultaCNPJDM.Free;

  inherited Destroy;
end;

procedure TACBrLibConsultaCNPJ.CriarConfiguracao(ArqConfig: string; ChaveCrypt: ansistring);
begin
  fpConfig := TLibConsultaCNPJConfig.Create(Self, ArqConfig, ChaveCrypt);
end;

procedure TACBrLibConsultaCNPJ.Executar;
begin
  inherited Executar;
  FConsultaCNPJDM.AplicarConfiguracoes;
end;

function TACBrLibConsultaCNPJ.ConsultarCaptcha(ePathDownload: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer):Integer;
var
  AStream: TMemoryStream;
  Resposta, Path: String;

begin
  try
    Path:= ConverterStringEntrada(ePathDownload);

    if Config.Log.Nivel > logNormal then
       GravarLog('CNPJ_ConsultarCaptcha ( ' + Path + ' )', logCompleto, True)
    else
       GravarLog('CNPJ_ConsultarCaptcha', logNormal);

    ConsultaCNPJDM.Travar;

    if (Path <> '') and not( DirectoryExists( PathWithDelim( Path ) )) then
      raise Exception.Create('Diretorio: ' + PathWithDelim( Path ) +' não encontrado.');

    AStream := TMemoryStream.Create;

    try

    ConsultaCNPJDM.ACBrConsultaCNPJ1.Captcha(AStream);
    Resposta := StreamToBase64(AStream);

    MoverStringParaPChar(Resposta, sResposta, esTamanho);
    Result := SetRetorno(ErrOK, Resposta);

    if (Path <> '') then
    begin
      try
        AStream.SaveToFile( PathWithDelim(Path) + CCAPTCHA_CNPJ + '.png');
      except
        raise Exception.Create(ACBrStr('Falha ao gravar arquivo ' + CCAPTCHA_CNPJ + '.png'));
      end;
    end;

    finally
      AStream.Free;
      ConsultaCNPJDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

function TACBrLibConsultaCNPJ.Consultar(eCNPJ: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
var
  AResposta: String;
  CNPJ: AnsiString;
  Resp: TLibConsultaCNPJConsulta;
begin
  try
    //Captcha:= ConverterAnsiParaUTF8(eCaptcha);
    CNPJ:= ConverterStringEntrada(eCNPJ);

    if Config.Log.Nivel > logNormal then
       GravarLog('CNPJ_Consultar (' + CNPJ + ' - Provedor:' + IntToStr(integer(ConsultaCNPJDM.ACBrConsultaCNPJ1.Provedor)) + ' )', logCompleto, True)
    else
       GravarLog('CNPJ_Consultar', logNormal);

    ConsultaCNPJDM.Travar;
    try
  

      ConsultaCNPJDM.ACBrConsultaCNPJ1.Consulta(CNPJ);
      AResposta:= '';

      Resp := TLibConsultaCNPJConsulta.Create(Config.TipoResposta, Config.CodResposta);
      try

        Resp.Processar(ConsultaCNPJDM.ACBrConsultaCNPJ1);
        AResposta:= Resp.Gerar;
      finally
        Resp.Free;
      end;
    finally
      ConsultaCNPJDM.Destravar;
    end;

    MoverStringParaPChar(AResposta, sResposta, esTamanho);
    Result := SetRetorno(ErrOK, StrPas(sResposta));

  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

end.

