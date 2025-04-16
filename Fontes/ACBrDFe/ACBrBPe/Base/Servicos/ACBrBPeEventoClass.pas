{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrBPeEventoClass;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  ACBrXmlBase,
  pcnConversao,
  ACBrUtil.Strings,
  ACBrBPeConversao,
  ACBrBPeClass;

type
  EventoException = class(Exception);

  TDetEvento = class
  private
    FVersao: string;
    FDescEvento: string;
    FnProt: string;        // Cancelamento
    FxJust: string;        // Cancelamento
    Fpoltrona: Integer;
    FqBagagem: Integer;
    FvTotBag: Currency;

    FidPedidoCancelado: string;
    FIBSCBS: TIBSCBS;
  public
    property versao: string     read FVersao     write FVersao;
    property descEvento: string read FDescEvento write FDescEvento;
    property nProt: string      read FnProt      write FnProt;
    property xJust: string      read FxJust      write FxJust;
    property poltrona: Integer  read Fpoltrona   write Fpoltrona;
    property qBagagem: Integer  read FqBagagem   write FqBagagem;
    property vTotBag: Currency  read FvTotBag    write FvTotBag;

    property idPedidoCancelado: string read FidPedidoCancelado write FidPedidoCancelado;
    // Reforma Tribut�ria
    property IBSCBS: TIBSCBS read FIBSCBS write FIBSCBS;
  end;

  TInfEvento = class
  private
    FID: string;
    FtpAmbiente: TACBrTipoAmbiente;
    FCNPJ: string;
    FcOrgao: Integer;
    FChave: string;
    FDataEvento: TDateTime;
    FTpEvento: TpcnTpEvento;
    FnSeqEvento: Integer;
    FDetEvento: TDetEvento;

    function getcOrgao: Integer;
    function getDescEvento: string;
    function getTipoEvento: string;
  public
    constructor Create;
    destructor Destroy; override;

    function DescricaoTipoEvento(TipoEvento:TpcnTpEvento): string;

    property id: string               read FID             write FID;
    property cOrgao: Integer          read getcOrgao       write FcOrgao;
    property tpAmb: TACBrTipoAmbiente read FtpAmbiente     write FtpAmbiente;
    property CNPJ: string             read FCNPJ           write FCNPJ;
    property chBPe: string            read FChave          write FChave;
    property dhEvento: TDateTime      read FDataEvento     write FDataEvento;
    property tpEvento: TpcnTpEvento   read FTpEvento       write FTpEvento;
    property nSeqEvento: Integer      read FnSeqEvento     write FnSeqEvento;
    property detEvento: TDetEvento    read FDetEvento      write FDetEvento;
    property DescEvento: string       read getDescEvento;
    property TipoEvento: string       read getTipoEvento;
  end;

  { TRetInfEvento }

  TRetInfEvento = class(TObject)
  private
    FId: string;
    FNomeArquivo: string;
    FtpAmb: TACBrTipoAmbiente;
    FverAplic: string;
    FcOrgao: Integer;
    FcStat: Integer;
    FxMotivo: string;
    FchBPe: string;
    FtpEvento: TpcnTpEvento;
    FxEvento: string;
    FnSeqEvento: Integer;
    FCNPJDest: string;
    FemailDest: string;
    FcOrgaoAutor: Integer;
    FdhRegEvento: TDateTime;
    FnProt: string;
    FXML: AnsiString;
  public
    property Id: string               read FId          write FId;
    property tpAmb: TACBrTipoAmbiente read FtpAmb       write FtpAmb;
    property verAplic: string         read FverAplic    write FverAplic;
    property cOrgao: Integer          read FcOrgao      write FcOrgao;
    property cStat: Integer           read FcStat       write FcStat;
    property xMotivo: string          read FxMotivo     write FxMotivo;
    property chBPe: string            read FchBPe       write FchBPe;
    property tpEvento: TpcnTpEvento   read FtpEvento    write FtpEvento;
    property xEvento: string          read FxEvento     write FxEvento;
    property nSeqEvento: Integer      read FnSeqEvento  write FnSeqEvento;
    property CNPJDest: string         read FCNPJDest    write FCNPJDest;
    property emailDest: string        read FemailDest   write FemailDest;
    property cOrgaoAutor: Integer     read FcOrgaoAutor write FcOrgaoAutor;
    property dhRegEvento: TDateTime   read FdhRegEvento write FdhRegEvento;
    property nProt: string            read FnProt       write FnProt;
    property XML: AnsiString          read FXML         write FXML;
    property NomeArquivo: string      read FNomeArquivo write FNomeArquivo;
  end;

implementation

{ TInfEvento }

constructor TInfEvento.Create;
begin
  inherited Create;

  FDetEvento := TDetEvento.Create();
end;

destructor TInfEvento.Destroy;
begin
  FDetEvento.Free;

  inherited;
end;

function TInfEvento.getcOrgao: Integer;
//  (AC,AL,AP,AM,BA,CE,DF,ES,GO,MA,MT,MS,MG,PA,PB,PR,PE,PI,RJ,RN,RS,RO,RR,SC,SP,SE,TO);
//  (12,27,16,13,29,23,53,32,52,21,51,50,31,15,25,41,26,22,33,24,43,11,14,42,35,28,17);
begin
  if FcOrgao <> 0 then
    Result := FcOrgao
  else
    Result := StrToIntDef(copy(FChave, 1, 2), 0);
end;

function TInfEvento.getDescEvento: string;
begin
  case fTpEvento of
    teCCe:               Result := 'Carta de Correcao';
    teCancelamento:      Result := 'Cancelamento';
    teNaoEmbarque:       Result := 'Nao Embarque';
    teAlteracaoPoltrona: Result := 'Alteracao Poltrona';
    teExcessoBagagem:    Result := 'Excesso Bagagem';
  else
    Result := '';
  end;
end;

function TInfEvento.getTipoEvento: string;
begin
  try
    Result := TpEventoToStr( FTpEvento );
  except
    Result := '';
  end;
end;

function TInfEvento.DescricaoTipoEvento(TipoEvento: TpcnTpEvento): string;
begin
  case TipoEvento of
    teCCe:               Result := 'CARTA DE CORRE��O ELETR�NICA';
    teCancelamento:      Result := 'CANCELAMENTO DE BP-e';
    teNaoEmbarque:       Result := 'NAO EMBARQUE';
    teAlteracaoPoltrona: Result := 'ALTERACAO DE POLTRONA';
    teExcessoBagagem:    Result := 'EXCESSO BAGAGEM';
  else
    Result := 'N�o Definido';
  end;
end;

end.
