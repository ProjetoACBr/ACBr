{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
|* 28/08/2017: Leivio Fontenele - leivio@yahoo.com.br
|*  - Implementa��o comunica��o, envelope, status e retorno do componente com webservice.
******************************************************************************}

{$I ACBr.inc}

unit pcesRetDownloadEvt;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  ACBrBase,
  pcnConversao, pcnLeitor,
  pcesRetornoClass, pcesConversaoeSocial;

type
  TArquivoCollectionItem = class(TObject)
  private
    FStatus: TStatus;
    FProcessamento: TProcessamento;
    FId: string;
    FnrRec: string;
    FXML: string;
  public
    constructor Create;
    destructor Destroy; override;

    property Status: TStatus read FStatus write FStatus;
    property Processamento: TProcessamento read FProcessamento write FProcessamento;
    property Id: string read FId write FId;
    property nrRec: string read FnrRec write FnrRec;
    property XML: string read FXML write FXML;
  end;

  TArquivoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TArquivoCollectionItem;
    procedure SetItem(Index: Integer; Value: TArquivoCollectionItem);
  public
    function Add: TArquivoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TArquivoCollectionItem;
    property Items[Index: Integer]: TArquivoCollectionItem read GetItem write SetItem; default;
  end;

  TRetDownloadEvt = class(TObject)
  private
    FLeitor: TLeitor;
    FStatus: TStatus;
    FArquivo: TArquivoCollection;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: boolean;
    property Leitor: TLeitor read FLeitor write FLeitor;
    property Status: TStatus read FStatus write FStatus;
    property Arquivo: TArquivoCollection read FArquivo write FArquivo;
  end;

implementation

uses
  ACBrUtil.Strings;
{ TRetIdentEvtsCollection }

function TArquivoCollection.Add: TArquivoCollectionItem;
begin
  Result := Self.New;
end;

function TArquivoCollection.GetItem(Index: Integer) : TArquivoCollectionItem;
begin
  Result := TArquivoCollectionItem(inherited Items[Index]);
end;

procedure TArquivoCollection.SetItem(Index: Integer;
  Value: TArquivoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TRetIdentEvtsCollectionItem }

constructor TArquivoCollectionItem.Create;
begin
  inherited Create;
  FStatus := TStatus.Create;
  FProcessamento := TProcessamento.Create;
end;

destructor TArquivoCollectionItem.Destroy;
begin
  FStatus.Free;
  FProcessamento.Free;

  inherited;
end;

{ TRetDownloadEvt }

constructor TRetDownloadEvt.Create;
begin
  inherited Create;
  FLeitor := TLeitor.Create;
  FStatus := TStatus.Create;
  FArquivo := TArquivoCollection.Create;
end;

destructor TRetDownloadEvt.Destroy;
begin
  FLeitor.Free;
  FStatus.Free;
  FArquivo.Free;

  inherited;
end;

function TRetDownloadEvt.LerXml: boolean;
var
//  ok: boolean;
  i, j{, k}: Integer;
  LOcc: TOcorrenciasProcCollectionItem;
begin
  Result := False;
  try
    Leitor.Grupo := Leitor.Arquivo;
    if Leitor.rExtrai(1, 'download') <> '' then
    begin

      if Leitor.rExtrai(2, 'status') <> '' then
      begin
        Status.cdResposta := Leitor.rCampo(tcInt, 'cdResposta');
        Status.descResposta := Leitor.rCampo(tcStr, 'descResposta');
      end;

      if Leitor.rExtrai(2, 'retornoSolicDownloadEvts') <> '' then
      begin
        if Leitor.rExtrai(3, 'arquivos') <> '' then
        begin
          i := 0;
          while Leitor.rExtrai(4, 'arquivo', '', i + 1) <> '' do
          begin
            Arquivo.New;

            if Leitor.rExtrai(5, 'status') <> '' then
            begin
              Arquivo.Items[i].Status.cdResposta   := Leitor.rCampo(tcInt, 'cdResposta');
              Arquivo.Items[i].Status.descResposta := Leitor.rCampo(tcStr, 'descResposta');
            end;

            if Leitor.rExtrai(5, 'evt') <> '' then
            begin
              Arquivo.Items[i].Id  := FLeitor.rAtributo('Id=', 'evt');
              Arquivo.Items[i].XML := RetornarConteudoEntre(Leitor.Grupo, '>', '</evt');
            end;

            if Leitor.rExtrai(5, 'rec') <> '' then
            begin
              Arquivo.Items[i].nrRec := FLeitor.rAtributo('nrRec=', 'rec');
              Arquivo.Items[i].XML   := RetornarConteudoEntre(Leitor.Grupo, '>', '</rec');

              if Leitor.rExtrai(6, 'eSocial') <> '' then
              begin
                if Leitor.rExtrai(7, 'retornoEvento') <> '' then
                begin
                  if Leitor.rExtrai(8, 'processamento') <> '' then
                  begin
                    Arquivo.Items[i].Processamento.cdResposta := Leitor.rCampo(tcInt, 'cdResposta');
                    Arquivo.Items[i].Processamento.descResposta := Leitor.rCampo(tcStr, 'descResposta');

                    if Leitor.rExtrai(9, 'ocorrencias') <> '' then
                    begin
                      j := 0;
                      while Leitor.rExtrai(10, 'ocorrencia', '', j + 1) <> '' do
                      begin
                        LOcc := Arquivo.Items[i].Processamento.Ocorrencias.New;
                        LOcc.Tipo := Leitor.rCampo(tcInt, 'tipo');
                        LOcc.Codigo := Leitor.rCampo(tcInt, 'codigo');
                        LOcc.Descricao := Leitor.rCampo(tcStr, 'descricao');
                        LOcc.Localizacao := Leitor.rCampo(tcStr, 'localizacao');
                        inc(j);
                      end;
                    end;
                  end;
                end;
              end;
            end;

            inc(i);
          end;
        end;
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TArquivoCollection.New: TArquivoCollectionItem;
begin
  Result := TArquivoCollectionItem.Create;
  Self.Add(Result);
end;

end.
