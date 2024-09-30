{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

{$I ACBr.inc}

unit ISSBarueri.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils, MaskUtils,
  ACBrNFSeXGravarXml,
  ACBrNFSeXConversao;

type
  { Provedor com layout pr�prio }

  { TNFSeW_ISSBarueri }

  TNFSeW_ISSBarueri = class(TNFSeWClass)
  private

  protected
    procedure GerarRegistroTipo1(const AIdentificacaoRemessa: String);
    procedure GerarRegistroTipo2;
    procedure GerarRegistroTipo3;
    procedure GerarRegistroTipo9;
  public
    function GerarXml: Boolean; override;
  end;

implementation

uses
  {$IFDEF MSWINDOWS} Windows, {$ENDIF MSWINDOWS}
  synacode, synautil,
  ACBrUtil.Strings,
  ACBrConsts;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS da prefeitura de:
//     ISSBarueri
//==============================================================================

{ TNFSeW_ISSBarueri }

procedure TNFSeW_ISSBarueri.GerarRegistroTipo1(const AIdentificacaoRemessa: String);
begin
  FConteudoTxt.Add(
    '1'+ // Tipo do Registro S Num�rico 1 1 1 1
    PadRight(NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal, 7, ' ')+ // Inscri��o do Contribuinte S Texto 7 2 8 Inscri��o do Prestador de Servi�o
    'PMB002'+ // Vers�o do Lay-Out S Texto 6 9 14 Vers�o do Lay-Out "PMB002"
    PadLeft(AIdentificacaoRemessa, 11, '0') // Identifica��o da Remessa do Contribuinte
  );
end;

procedure TNFSeW_ISSBarueri.GerarRegistroTipo2;
var
  Quantidade: Integer;
  SituacaoRPS, CodCancelamento, MotCancelamento, Discriminacao: String;
  ValorTotalRetencoes: Double;
begin
  SituacaoRPS := 'E';

  CodCancelamento := '';
  MotCancelamento := '';
  Quantidade := 1;

  if NFSe.StatusRps = srCancelado then
  begin
    SituacaoRPS := 'C';
    CodCancelamento := NFSe.CodigoCancelamento;
    MotCancelamento := NFSe.MotivoCancelamento;
  end;

  Discriminacao := StringReplace(NFSe.Servico.Discriminacao, ';', Opcoes.QuebraLinha, [rfReplaceAll, rfIgnoreCase]);

  if (Assigned(NFSe.Servico.ItemServico)) and
     (Pred(NFSe.Servico.ItemServico.Count) > 0) then
    Quantidade := Trunc(NFSe.Servico.ItemServico.Items[0].Quantidade);

  ValorTotalRetencoes := NFSe.Servico.Valores.ValorIr +
                         NFSe.Servico.Valores.ValorPis +
                         NFSe.Servico.Valores.ValorCofins +
                         NFSe.Servico.Valores.ValorCsll;

  FConteudoTxt.Add(
    '2'+ // Tipo do Registro S Num�rico 1 1 1 2
    'RPS  '+ // Tipo do RPS S Texto 5 2 6 RPS
    PadRight(NFSe.IdentificacaoRps.Serie, 4, ' ')+ // S�rie do RPS N Texto 4 7 10 S�rie do RPS
    PadRight('', 5, ' ')+ // S�rie da NF-e S* Texto 5 11 15 S�rie do NF-e. * Obrigat�rio somente para contribuintes com regime especial.
    '000'+PadLeft(NFSe.IdentificacaoRps.Numero, 7, '0')+ // N�mero do RPS N�mero do RPS, iniciar no n�mero 1, com zeros a esquerda, sendo que obrigatoriamente os 3 primeiros d�gitos sejam zero
    FormatDateTime('YYYYMMDD', NFSe.DataEmissaoRps)+ // Data do RPS S AAAAMMDD 8 26 33 Data de Emiss�o do RPS
    FormatDateTime('HHMMSS', Trunc(NFSe.DataEmissaoRps))+ // Hora do RPS S HHMMSS 6 34 39 Hora de Emiss�o do RPS
    SituacaoRPS+ // Situa��o do RPS S Texto 1 40 40 E para RPS Enviado / C para RPS Cancelado
    PadRight(CodCancelamento, 2, ' ')+ // C�digo de Motivo de Cancelamento S* Texto 2 41 42
    PadRight(IfThen(SituacaoRPS = 'C', NFSe.Numero, ''), 7, ' ')+ // N�mero da NF-e a ser cancelada/substituida S* Num�rico 7 43
    PadRight(IfThen(SituacaoRPS = 'C', NFSe.SeriePrestacao, ''), 5, ' ')+ // S�rie da NF-e a ser cancelada/substituida N Texto 5 50 54
    PadRight(IfThen(SituacaoRPS = 'C', FormatDateTime('YYYYMMDD', NFSe.DataEmissao), ''), 8, ' ')+ // Data de emiss�o da NF-e a ser cancelada/substituida S* AAAAMMDD 8 55 62
    PadRight(IfThen(SituacaoRPS = 'C', MotCancelamento, ''), 180, ' ')+ // Descricao do Cancelamento S* Texto 180 63 242
    PadRight(NFSe.Servico.CodigoTributacaoMunicipio, 9, ' ')+ // C�digo do Servi�o Prestado S Num�rico 9 243 251

    LocalPrestacaoToStr(NFSe.Servico.LocalPrestacao)+ // Local da Presta��o do Servi�o S* Texto 1 252 252
    IfThen(NFSe.Servico.PrestadoEmViasPublicas, '1', '2')+ // Servi�o Prestado em Vias Publicas S* Texto 1 253 253

    PadRight(NFSe.Servico.Endereco.Endereco, 75, ' ')+ // Endere�o Logradouro do local do Servi�o Prestado S* Texto 75 254 328
    PadRight(NFSe.Servico.Endereco.Numero, 9, ' ')+ // Numero Logradouro do local do Servi�o Prestado S* Texto 9 329 337
    PadRight(NFSe.Servico.Endereco.Complemento, 30, ' ')+ // Complemento Logradouro do local do Servi�o Prestado S* Texto 30 338 367
    PadRight(NFSe.Servico.Endereco.Bairro, 40, ' ')+ // Bairro Logradouro do local do Servi�o Prestado S* Texto 40 368 407
    PadRight(NFSe.Servico.Endereco.xMunicipio, 40, ' ')+ // Cidade Logradouro do local do Servi�o Prestado S* Texto 40 408 447
    PadRight(NFSe.Servico.Endereco.UF, 2, ' ')+ // UF Logradouro do local do Servi�o Prestado S* Texto 2 448 449
    PadRight(NFSe.Servico.Endereco.CEP, 8, ' ')+ // CEP Logradouro do local do Servi�o Prestado S* Texto 8 450 457

    PadLeft(IntToStr(Quantidade), 6, '0')+ // Quantidade de Servi�o S Num�rico 6 458 463
    PadLeft(FloatToStr(NFSe.Servico.Valores.ValorServicos * 100), 15, '0')+ // Valor do Servi�o S Num�rico 15 464 478 Exemplo: R$10,25 = 000000000001025
    '     '+ //  Reservado N Texto 5 479 483
    PadLeft(FloatToStr(ValorTotalRetencoes * 100), 15, '0')+ // Valor Total das Reten��es S Num�rico 15 484 498

    IfThen(Length(NFSe.Tomador.IdentificacaoTomador.CpfCnpj) >= 11, '2', '1')+ // Tomador Estrangeiro S Num�rico 1 499 499 1 Para Tomador Estrangeiro 2 para Tomador Brasileiro
    PadRight('', 3, ' ')+ // Pais da Nacionalidade do Tomador Estrangeiro S* Num�rico 3 500 502 C�dido do pais de nacionalidade do tomador, conforme tabela de paises, quando o tomador for estrangeiro
    '2'+ // Servi�o Prestado � exporta��o S* Num�rico 1 503 503 1 Para Servi�o exportado 2 para Servi�o n�o exportado

    IfThen(Length(NFSe.Tomador.IdentificacaoTomador.CpfCnpj) > 11, '2', '1')+ // Indicador do CPF/CNPJ do Tomador, pegar do Pessoas a constante S* Num�rico 1 504 504 1 para CPF / 2 para CNPJ
    PadLeft(NFSe.Tomador.IdentificacaoTomador.CpfCnpj, 14, ' ')+ // CPF/ CNPJ do Tomador S* Num�rico 14 505 518
    PadRight(NFSe.Tomador.RazaoSocial, 60, ' ')+ // Raz�o Social / Nome do Tomador S Texto 60 519 578
    PadRight(NFSe.Tomador.Endereco.Endereco, 75, ' ')+ // Endere�o Logradouro Tomador S* Texto 75 579 653
    PadRight(NFSe.Tomador.Endereco.Numero, 9, ' ')+ // Numero Logradouro Tomador S* Texto 9 654 662
    PadRight(NFSe.Tomador.Endereco.Complemento, 30, ' ')+ // Complemento Logradouro Tomador S* Texto 30 663 692
    PadRight(NFSe.Tomador.Endereco.Bairro, 40, ' ')+ // Bairro Logradouro Tomador S* Texto 40 693 732
    PadRight(NFSe.Tomador.Endereco.xMunicipio, 40, ' ')+ // Cidade Logradouro Tomador S* Texto 40 733 772
    PadRight(NFSe.Tomador.Endereco.UF, 2, ' ')+ // UF Logradouro Tomador S* Texto 2 773 774
    PadRight(NFSe.Tomador.Endereco.CEP, 8, ' ')+ // CEP Logradouro Tomador S* Texto 8 775 782
    PadRight(NFSe.Tomador.Contato.Email, 152, ' ')+ // e-mail Tomador S* Texto 152 783 934

    PadRight('', 6, ' ')+ // Fatura N Num�rico 6 935 940 N�mero da Fatura
    PadLeft('', 15, ' ')+ // Valor Fatura S* Num�rico 15 941 955
    PadRight('', 15, ' ')+ // Forma de Pagamento S* Texto 15 956 970
    PadRight(Discriminacao, 1000, ' ') // Discrimina��o do Servi�o S Texto 1000 971 1970
  );
end;

procedure TNFSeW_ISSBarueri.GerarRegistroTipo3;
begin
  if (NFSe.Servico.Valores.RetidoIr = snSim) and
     (NFSe.Servico.Valores.ValorIr > 0) then
  begin
    FConteudoTxt.Add(
      '3'+ // Tipo do Registro S* Num�rico 1 1 1
      '01'+ // C�digo de Outros Valores S Texto 2 2 3 01 - para IRRF
      PadLeft(FloatToStr(NFSe.Servico.Valores.ValorIr * 100), 15, '0')
    );
  end;

  if (NFSe.Servico.Valores.RetidoPis = snSim) and
     (NFSe.Servico.Valores.ValorPis > 0) then
  begin
    FConteudoTxt.Add(
      '3'+ // Tipo do Registro S* Num�rico 1 1 1
      '02'+ // C�digo de Outros Valores S Texto 2 2 3 02 - para PIS/PASEP
      PadLeft(FloatToStr(NFSe.Servico.Valores.ValorPis * 100), 15, '0')
    );
  end;

  if (NFSe.Servico.Valores.RetidoCofins = snSim) and
     (NFSe.Servico.Valores.ValorCofins > 0) then
  begin
    FConteudoTxt.Add(
      '3'+ // Tipo do Registro S* Num�rico 1 1 1
      '03'+ // C�digo de Outros Valores S Texto 2 2 3 03 - para COFINS
      PadLeft(FloatToStr(NFSe.Servico.Valores.ValorCofins * 100), 15, '0')
    );
  end;

  if (NFSe.Servico.Valores.RetidoCsll = snSim) and
     (NFSe.Servico.Valores.ValorCsll > 0) then
  begin
    FConteudoTxt.Add(
      '3'+ // Tipo do Registro S* Num�rico 1 1 1
      '04'+ // C�digo de Outros Valores S Texto 2 2 3 04 - para CSLL
      PadLeft(FloatToStr(NFSe.Servico.Valores.ValorCsll * 100), 15, '0')
    );
  end;
end;

procedure TNFSeW_ISSBarueri.GerarRegistroTipo9;
var
  ValorTotalRetencoes: Double;
begin
  ValorTotalRetencoes := NFSe.Servico.Valores.ValorIr +
                         NFSe.Servico.Valores.ValorPis +
                         NFSe.Servico.Valores.ValorCofins +
                         NFSe.Servico.Valores.ValorCsll;

  FConteudoTxt.Add(
    '9'+ // Tipo do Registro S Num�rico 1 1 1 9
    PadRight(IntToStr(FConteudoTxt.Count + 1), 7, ' ')+ // N�mero Total de Linhas do Arquivo S Num�rico 7 2 8
    PadLeft(FloatToStr(NFSe.Servico.Valores.ValorServicos * 100), 15, '0')+ // Valor Total dos Servi�os contidos no Arquivo S Num�rico 15 9 23
    PadLeft(FloatToStr(ValorTotalRetencoes * 100), 15, '0') // Valor Total dos Valores contidos no registro 3 S Num�rico 15 24 38 Valor Total das Reten��es e outros valores informados no registro 3
  );
end;

function TNFSeW_ISSBarueri.GerarXml: Boolean;
begin
  Configuracao;

  Opcoes.QuebraLinha := FpAOwner.ConfigGeral.QuebradeLinha;

  ListaDeAlertas.Clear;

  FDocument.Clear();

  FConteudoTxt.Clear;

  {$IFDEF FPC}
  FConteudoTxt.LineBreak := CRLF;
  {$ELSE}
    {$IFDEF DELPHI2006_UP}
    FConteudoTxt.LineBreak := CRLF;
    {$ENDIF}
  {$ENDIF}

  if NFSe.IdentificacaoRemessa = '' then
    NFSe.IdentificacaoRemessa := NFSe.IdentificacaoRps.Numero;

  if NFSe.StatusRps = srCancelado then
    GerarRegistroTipo1(FormatDateTime('yyyymmddzzz', Now))
  else
    GerarRegistroTipo1(NFSe.IdentificacaoRemessa);

  GerarRegistroTipo2;
  GerarRegistroTipo3;
  GerarRegistroTipo9;

  Result := True;
end;

end.
