{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:   R�gys Silveira                                }
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
|* 15/07/2013: Primeira Versao
|*    R�gys Borges da Silveira
|*
|* mais informa��es
|* https://www4.bcb.gov.br/pec/taxas/batch/cotacaomoedas.asp
|* https://www4.bcb.gov.br/pec/taxas/batch/tabmoedas.asp
******************************************************************************}

{$I ACBr.inc}

unit ACBrCotacao;

interface

uses
  SysUtils, Variants, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$Else}
   Contnrs,
  {$IfEnd}
  ACBrBase, ACBrSocket,
  ACBrUtil.Strings;

type
  EACBrCotacao = class(Exception);

  TACBrCotacaoItem = class
  private
    FTaxaVenda: Real;
    FDataCotacao: TDateTime;
    FTaxaCompra: Real;
    FMoeda: String;
    FParidadeVenda: Real;
    FCodPais: integer;
    FParidadeCompra: Real;
    FCodigoMoeda: Integer;
    FNome: String;
    FTipo: String;
    FPais: String;
  public
    property DataCotacao: TDateTime read FDataCotacao     write FDataCotacao;
    property CodigoMoeda: Integer   read FCodigoMoeda     write FCodigoMoeda;
    property Tipo: String           read FTipo            write FTipo;
    property Moeda: String          read FMoeda           write FMoeda;
    property Nome: String           read FNome            write FNome;
    property CodPais: integer       read FCodPais         write FCodPais;
    property Pais: String           read FPais            write FPais;
    property TaxaCompra: Real       read FTaxaCompra      write FTaxaCompra;
    property TaxaVenda: Real        read FTaxaVenda       write FTaxaVenda;
    property ParidadeCompra: Real   read FParidadeCompra  write FParidadeCompra;
    property ParidadeVenda: Real    read FParidadeVenda   write FParidadeVenda;

  end;

  TACBrCotacaoItens = class(TObjectList{$IfDef HAS_SYSTEM_GENERICS}<TACBrCotacaoItem>{$EndIf})
  private
    function GetItem(Index: integer): TACBrCotacaoItem;
    procedure SetItem(Index: integer; const Value: TACBrCotacaoItem);
  public
    function New: TACBrCotacaoItem;
    property Items[Index: integer]: TACBrCotacaoItem read GetItem write SetItem; default;
  end;
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrCotacao = class(TACBrHTTP)
  private
    FTabela: TACBrCotacaoItens;
    function GetURLTabela(const AData: TDateTime): String;
    function GetURLMoedas: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AtualizarTabela(const AData: TDateTime);
    function Procurar(const ASimbolo: String): TACBrCotacaoItem; overload;
    function Procurar(const ACodigoMoeda: Double): TACBrCotacaoItem; overload;
  published
    property Tabela: TACBrCotacaoItens read FTabela write FTabela;
  end;

implementation

{ TACBrCotacaoItens }

function TACBrCotacaoItens.GetItem(Index: integer): TACBrCotacaoItem;
begin
  Result := TACBrCotacaoItem(inherited Items[Index]);
end;

function TACBrCotacaoItens.New: TACBrCotacaoItem;
begin
  Result := TACBrCotacaoItem.Create;
  Add(Result);
end;

procedure TACBrCotacaoItens.SetItem(Index: integer;
  const Value: TACBrCotacaoItem);
begin
  inherited Items[Index] := Value;
end;

{ TACBrCotacao }

constructor TACBrCotacao.Create(AOwner: TComponent);
begin
  inherited;
  FTabela := TACBrCotacaoItens.Create;
  FTabela.Clear;
end;

destructor TACBrCotacao.Destroy;
begin
  FTabela.Free;
  inherited;
end;

function TACBrCotacao.GetURLMoedas: String;
var
  StrTmp: String;
  PosCp: Integer;
begin
  Self.HTTPGet('https://ptax.bcb.gov.br/ptax_internet/consultarTabelaMoedas.do?method=consultaTabelaMoedas');
  StrTmp := DecodeToString(HTTPResponse, RespIsUTF8);

  PosCp := Pos('https://www4.bcb.gov.br/Download/fechamento/', StrTmp);
  StrTmp := Copy(StrTmp, PosCp, Length(StrTmp) - PosCp);

  PosCp := Pos('.csv', strTmp) + 3;
  StrTmp := Copy(StrTmp, 0, PosCp);

  Result := StrTmp;
end;

function TACBrCotacao.GetURLTabela(const AData: TDateTime): String;
var
  StrTmp: String;
  PosCp: Integer;
begin
  // alterado pois o endere�o antigo come�ou a utilizar frame
  // ent�o agora abrimos direto o frame
  //Self.HTTPGet('https://www4.bcb.gov.br/pec/taxas/batch/cotacaomoedas.asp');
  if AData > 0 then
  begin
    Result := 'https://www4.bcb.gov.br/Download/fechamento/' + FormatDateTime('yyyymmdd', AData) + '.csv';
  end
  else
  begin
    Self.HTTPGet('https://ptax.bcb.gov.br/ptax_internet/consultarTodasAsMoedas.do?method=consultaTodasMoedas');
    StrTmp := DecodeToString(HTTPResponse, RespIsUTF8);

    PosCp := Pos('https://www4.bcb.gov.br/Download/fechamento/', StrTmp);
    StrTmp := Copy(StrTmp, PosCp, Length(StrTmp) - PosCp);

    PosCp := Pos('.csv', strTmp) + 3;
    StrTmp := Copy(StrTmp, 0, PosCp);

    Result := StrTmp;
  end;
end;

function TACBrCotacao.Procurar(const ACodigoMoeda: Double): TACBrCotacaoItem;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Tabela.Count - 1 do
  begin
    if Tabela[I].CodigoMoeda = ACodigoMoeda then
    begin
      Result := Tabela[I];
      Exit;
    end;
  end;
end;

function TACBrCotacao.Procurar(const ASimbolo: String): TACBrCotacaoItem;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Tabela.Count - 1 do
  begin
    if Tabela[I].Moeda = ASimbolo then
    begin
      Result := Tabela[I];
      Exit;
    end;
  end;
end;

procedure TACBrCotacao.AtualizarTabela(const AData: TDateTime);
var
  ItemCotacao: TStringList;
  ItemMoeda: TStringList;
  ArqCotacao: TStringList;
  ArqMoedas: TStringList;
  I: Integer;
  LinhaMoeda: String;

  function GetLinhaMoeda(const CodMoeda: String): String;
  var
    I: Integer;
  begin
    for I := 0 to ArqMoedas.Count - 1 do
    begin
      if CodMoeda = Copy(ArqMoedas[I], 0, 3)  then
      begin
        Result := ArqMoedas[I];
        Exit;
      end;
    end;
  end;

begin
  // verificar a data
  if AData > 0 then
  begin
    if DayOfWeek(AData) in [1, 7] then
      raise Exception.Create('Data informada � um final de semana!');
  end;

  if AData > Date then
    raise Exception.Create('Data informado n�o pode ser maior que a data atual!');

  ArqCotacao  := TStringList.Create;
  ArqMoedas   := TStringList.Create;
  ItemCotacao := TStringList.Create;
  ItemMoeda   := TStringList.Create;
  try
    // baixar .csv com dados da cota��o
    HTTPGet(GetURLTabela(AData));
    ArqCotacao.Clear;
    ArqCotacao.Text := DecodeToString(HTTPResponse, RespIsUTF8);

    // baixar .csv com dados das moedas
    HTTPGet(GetURLMoedas);
    ArqMoedas.Clear;
    ArqMoedas.Text := DecodeToString(HTTPResponse, RespIsUTF8);

    // varrer a tabela preenchendo o componente
    Tabela.Clear;
    for I := 0 to ArqCotacao.Count - 1 do
    begin
      QuebrarLinha(ArqCotacao[I], ItemCotacao);

      if ItemCotacao.Count = 8 then
      begin
        // buscar os dados da moeda para a cota��o atual
        LinhaMoeda := GetLinhaMoeda(ItemCotacao[1]);
        QuebrarLinha(LinhaMoeda, ItemMoeda);

        // adicionar nova cota��o a lista
        with Tabela.New do
        begin
          // dados da cota��o
          DataCotacao    := StrToDateDef(ItemCotacao[0], 0.0);
          CodigoMoeda    := StrToIntDef(ItemCotacao[1], 0);
          Tipo           := ItemCotacao[2];
          Moeda          := ItemCotacao[3];
          TaxaCompra     := StrToFloatDef(ItemCotacao[4], 0);
          TaxaVenda      := StrToFloatDef(ItemCotacao[5], 0);
          ParidadeCompra := StrToFloatDef(ItemCotacao[6], 0);
          ParidadeVenda  := StrToFloatDef(ItemCotacao[7], 0);

          // dados da moeda
          if ItemMoeda.Count = 7 then
          begin
            Nome        := ItemMoeda[1];
            CodPais     := StrToIntDef(ItemMoeda[3], 0);
            Pais        := ItemMoeda[4];
          end;
        end;
      end;
    end;
  finally
    ArqCotacao.Free;
    ArqMoedas.Free;
    ItemCotacao.Free;
    ItemMoeda.Free;
  end;

end;

end.
