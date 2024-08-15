﻿{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Teno Dias                                }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrLibCTeRespostas;

interface

uses
  SysUtils, Classes, contnrs,
  pcteRetEnvEventoCTe, ACBrCTe.EventoClass,
  ACBrLibConsReciDFe, ACBrLibResposta, ACBrLibConfig, ACBrCTe;

type

  { TLibCTeResposta }
  TLibCTeResposta = class(TACBrLibResposta<TACBrCTe>)
  private
    FMsg: string;
    Fversao: string;
    FtpAmb: string;
    FverAplic: string;
    FcStat: integer;
    FxMotivo: string;
    FcUF: integer;
    FdhRecbto: TDateTime;

  published
    property Msg: string read FMsg write FMsg;
    property Versao: string read Fversao write Fversao;
    property tpAmb: string read FtpAmb write FtpAmb;
    property VerAplic: string read FverAplic write FverAplic;
    property CStat: integer read FcStat write FcStat;
    property XMotivo: string read FxMotivo write FxMotivo;
    property CUF: integer read FcUF write FcUF;
    property DhRecbto: TDateTime read FdhRecbto write FdhRecbto;

  end;

  { TStatusServicoResposta }
  TStatusServicoResposta = class(TLibCTeResposta)
  private
    FTMed: integer;
    FdhRetorno: TDateTime;
    FxObs: string;
  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;

    procedure Processar(const ACBrCTe: TACBrCTe); override;

  published
    property TMed: integer read FTMed write FTMed;
    property DhRetorno: TDateTime read FdhRetorno write FdhRetorno;
    property XObs: string read FxObs write FxObs;
  end;

  { TInutilizarCTeResposta }
  TInutilizarCTeResposta = class(TLibCTeResposta)
  private
    FNomeArquivo: String;
    FXml: String;
  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;

    procedure Processar(const ACBrCTe: TACBrCTe); override;

  published
    property NomeArquivo: String read FNomeArquivo write FNomeArquivo;
    property Xml: String read FXml write FXml;
  end;

  { TConsultaCTeResposta }
  TConsultaCTeResposta = class(TLibCTeResposta)
  private
    FChCTe: String;
    FNProt: String;
    FDigVal: String;
  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;

    procedure Processar(const ACBrCTe: TACBrCTe); override;

  published
    property ChCTe: String read FChCTe write FChCTe;
    property NProt: String read FNProt write FNProt;
    property DigVal: String read FDigVal write FDigVal;
  end;

  { TEnvioResposta }
  TEnvioResposta = class(TLibCTeResposta)
  private
    FtMed: integer;
    FnRec: string;
    FNProt: string;
    FXml: string;
    FItem: TRetornoItemResposta;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Processar(const ACBrCTe: TACBrCTe); override;

  published
   property TMed: integer read FtMed write FtMed;
   property NRec: string read FnRec write FnRec;
   property NProt: String read FNProt write FNProt;
   property Xml: string read FXml write FXml;
   property Retorno: TRetornoItemResposta read FItem;

  end;

  { TCancelamentoResposta }
  TCancelamentoResposta = class(TLibCTeResposta)
  private
    FchCTe: string;
    FnProt: string;
    FtpEvento: string;
    FxEvento: string;
    FnSeqEvento: integer;
    FCNPJDest: string;
    FemailDest: string;
    Fxml: string;
  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;

    procedure Processar(const ACBrCTe: TACBrCTe); override;

  published
    property chCTe: string read FchCTe write FchCTe;
    property nProt: string read FnProt write FnProt;
    property tpEvento: string read FtpEvento write FtpEvento;
    property xEvento: string read FxEvento write FxEvento;
    property nSeqEvento: integer read FnSeqEvento write FnSeqEvento;
    property CNPJDest: string read FCNPJDest write FCNPJDest;
    property emailDest: string read FemailDest write FemailDest;
    property XML: string read Fxml write Fxml;
  end;

  { TEventoItemResposta }
  TEventoItemResposta = class(TACBrLibRespostaBase)
  private
    FtpAmb: string;
    FverAplic: string;
    FcStat: integer;
    FxMotivo: string;
    Farquivo: String;
    FchCTe: string;
    FCNPJDest: string;
    FcOrgao: integer;
    FdhRegEvento: TDateTime;
    FdigVal: String;
    FemailDest: string;
    FId: string;
    FnProt: String;
    FnSeqEvento: Integer;
    FtpEvento: string;
    FxEvento: string;
    FXML: string;

  public
    constructor Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo;
      const AFormato: TACBrLibCodificacao);

    procedure Processar(const RetInfEvento: TRetInfEvento);

  published
    property tpAmb: string read FtpAmb write FtpAmb;
    property VerAplic: string read FverAplic write FverAplic;
    property CStat: integer read FcStat write FcStat;
    property XMotivo: string read FxMotivo write FxMotivo;
    property chCTe: string read FchCTe write FchCTe;
    property nProt: String read FnProt write FnProt;
    property arquivo: String read Farquivo write Farquivo;
    property digVal: String read FdigVal write FdigVal;
    property Id: string read FId write FId;
    property cOrgao: integer read FcOrgao write FcOrgao;
    property dhRegEvento: TDateTime read FdhRegEvento write FdhRegEvento;
    property tpEvento: string read FtpEvento write FtpEvento;
    property xEvento: string read FxEvento write FxEvento;
    property nSeqEvento: Integer read FnSeqEvento write FnSeqEvento;
    property CNPJDest: string read FCNPJDest write FCNPJDest;
    property emailDest: string read FemailDest write FemailDest;
    property XML: string read FXML write FXML;

  end;

  { TEventoResposta }
  TEventoResposta = class(TLibCTeResposta)
  private
    FidLote: Integer;
    FcOrgao: Integer;
    FItems: TObjectList;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Processar(const ACBrCTe: TACBrCTe); override;

  published
    property idLote: Integer read FidLote write FidLote;
    property cOrgao: Integer read FcOrgao write FcOrgao;
    property Items: TObjectList read FItems;

  end;

implementation

uses
  pcnConversao, pcteConversaoCTe, ACBrXMLBase,
  ACBrUtil.Base, ACBrUtil.FilesIO, ACBrUtil.Strings,
  ACBrLibCTeConsts;

{ TEventoItemResposta }
constructor TEventoItemResposta.Create(const ASessao: String;
  const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(ASessao, ATipo, AFormato);
end;

procedure TEventoItemResposta.Processar(const RetInfEvento: TRetInfEvento);
begin
  FId := RetInfEvento.Id;
  FtpAmb := TpAmbToStr(RetInfEvento.tpAmb);
  FverAplic := RetInfEvento.verAplic;
  FcOrgao := RetInfEvento.cOrgao;
  FcStat := RetInfEvento.cStat;
  FxMotivo := RetInfEvento.xMotivo;
  FchCTe := RetInfEvento.chCTe;
  FtpEvento := TpEventoToStr(RetInfEvento.tpEvento);
  FxEvento := RetInfEvento.xEvento;
  FnSeqEvento := RetInfEvento.nSeqEvento;
  FCNPJDest := RetInfEvento.CNPJDest;
  FemailDest := RetInfEvento.emailDest;
  FdhRegEvento := RetInfEvento.dhRegEvento;
  FnProt := RetInfEvento.nProt;
  FArquivo := RetInfEvento.NomeArquivo;
  FXML := RetInfEvento.XML;
end;

{ TEventoResposta }
constructor TEventoResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespEvento, ATipo, AFormato);
  FItems := TObjectList.Create(True);
end;

destructor TEventoResposta.Destroy;
begin
  FItems.Clear;
  FItems.Free;

  inherited Destroy;
end;

procedure TEventoResposta.Processar(const ACBrCTe: TACBrCTe);
var
  i: Integer;
  Item: TEventoItemResposta;
begin
  with ACBrCTe.WebServices.EnvEvento.EventoRetorno do
  begin
    Self.VerAplic := VerAplic;
    Self.tpAmb := TpAmbToStr(tpAmb);
    Self.CStat := cStat;
    Self.XMotivo := XMotivo;
    Self.idLote := IdLote;
    Self.cOrgao := cOrgao;

    with retEvento do
    begin
      for i := 0 to retEvento.Count - 1 do
      begin
        Item := TEventoItemResposta.Create('EVENTO' + Trim(IntToStrZero(i +1, 3)), Tipo, Codificacao);
        Item.Processar(retEvento.Items[i].RetInfevento);
        FItems.Add(Item);
      end;
    end;
  end;
end;

{ TCancelamentoResposta }
constructor TCancelamentoResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespCancelamento, ATipo, AFormato);
end;

procedure TCancelamentoResposta.Processar(const ACBrCTe: TACBrCTe);
begin
  with ACBrCTe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfevento do
    begin
      Self.Versao := verAplic;
      Self.TpAmb := TpAmbToStr(TpAmb);
      Self.VerAplic := VerAplic;
      Self.CStat := cStat;
      Self.XMotivo := XMotivo;
      Self.CUF := cOrgao;
      Self.ChCTe := chCTe;
      Self.DhRecbto := dhRegEvento;
      Self.NProt := nProt;
      Self.TpEvento := TpEventoToStr(tpEvento);
      Self.xEvento := xEvento;
      Self.nSeqEvento := nSeqEvento;
      Self.CNPJDest := CNPJDest;
      Self.emailDest := emailDest;
      Self.XML := XML;
    end;
end;

{ TEnvioResposta }
constructor TEnvioResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespEnvio, ATipo, AFormato);
  FItem := nil;
end;

destructor TEnvioResposta.Destroy;
begin
  if Assigned(FItem) then FreeAndNil(FItem);
end;

procedure TEnvioResposta.Processar(const ACBrCTe: TACBrCTe);
begin
  if Assigned(FItem) then FreeAndNil(FItem);

  with ACBrCTe.WebServices.Enviar do
  begin
    Self.Versao := verAplic;
    Self.TpAmb := TpAmbToStr(TpAmb);
    Self.verAplic := verAplic;
    Self.CStat := cStat;
    Self.XMotivo := xMotivo;
    Self.CUF := cUF;
    Self.nRec := Recibo;
    Self.DhRecbto := dhRecbto;
    Self.Tmed := TMed;
    Self.Msg := Msg;
    Self.NProt := Protocolo;
    Self.Xml := '';
  end;

  if (ACBrCTe.Configuracoes.Geral.ModeloDF = moCTe) and
     (ACBrCTe.WebServices.Enviar.Sincrono) and
     (ACBrCTe.Conhecimentos.Count > 0) then
  begin
    Self.Xml := ACBrCTe.Conhecimentos.Items[0].XMLOriginal;

    FItem := TRetornoItemResposta.Create('CTe' + Trim(ACBrCTe.Conhecimentos.Items[0].CTe.procCTe.chCTe), Tipo, Codificacao);
    FItem.Id := ACBrCTe.Conhecimentos.Items[0].CTe.procCTe.Id;
    FItem.tpAmb := TpAmbToStr(ACBrCTe.Conhecimentos.Items[0].CTe.procCTe.tpAmb);
    FItem.verAplic := ACBrCTe.Conhecimentos.Items[0].CTe.procCTe.verAplic;
    FItem.chDFe := ACBrCTe.Conhecimentos.Items[0].CTe.procCTe.chCTe;
    FItem.dhRecbto := ACBrCTe.Conhecimentos.Items[0].CTe.procCTe.dhRecbto;
    FItem.nProt := ACBrCTe.Conhecimentos.Items[0].CTe.procCTe.nProt;
    FItem.digVal := ACBrCTe.Conhecimentos.Items[0].CTe.procCTe.digVal;
    FItem.cStat := ACBrCTe.Conhecimentos.Items[0].CTe.procCTe.cStat;
    FItem.xMotivo := ACBrCTe.Conhecimentos.Items[0].CTe.procCTe.xMotivo;
    FItem.XML := ACBrCTe.Conhecimentos.Items[0].CTe.procCTe.XML_prot;
  end
  else if (ACBrCTe.Configuracoes.Geral.ModeloDF = moCTeOS) and (ACBrCTe.Conhecimentos.Count > 0) then
  begin
    FItem := TRetornoItemResposta.Create('CTeOS' + Trim(ACBrCTe.WebServices.Enviar.CTeRetornoSincrono.protCTe.chDFe), Tipo, Codificacao);
    FItem.Id := ACBrCTe.WebServices.Enviar.CTeRetornoSincrono.protCTe.Id;
    FItem.tpAmb := TipoAmbienteToStr(ACBrCTe.WebServices.Enviar.CTeRetornoSincrono.protCTe.tpAmb);
    FItem.verAplic := ACBrCTe.WebServices.Enviar.CTeRetornoSincrono.protCTe.verAplic;
    FItem.chDFe := ACBrCTe.WebServices.Enviar.CTeRetornoSincrono.protCTe.chDFe;
    FItem.dhRecbto := ACBrCTe.WebServices.Enviar.CTeRetornoSincrono.protCTe.dhRecbto;
    FItem.nProt := ACBrCTe.WebServices.Enviar.CTeRetornoSincrono.protCTe.nProt;
    FItem.digVal := ACBrCTe.WebServices.Enviar.CTeRetornoSincrono.protCTe.digVal;
    FItem.cStat := ACBrCTe.WebServices.Enviar.CTeRetornoSincrono.protCTe.cStat;
    FItem.xMotivo := ACBrCTe.WebServices.Enviar.CTeRetornoSincrono.protCTe.xMotivo;
    FItem.XML := ACBrCTe.WebServices.Enviar.CTeRetornoSincrono.protCTe.XML_prot;
  end;
end;

{ TStatusServicoResposta }
constructor TStatusServicoResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespStatus, ATipo, AFormato);
end;

procedure TStatusServicoResposta.Processar(const ACBrCTe: TACBrCTe);
begin
  with ACBrCTe.WebServices do
  begin
    Self.Msg := StatusServico.Msg;
    Self.Versao := StatusServico.versao;
    Self.TpAmb := TpAmbToStr(StatusServico.TpAmb);
    Self.VerAplic := StatusServico.VerAplic;
    Self.CStat := StatusServico.CStat;
    Self.XMotivo := StatusServico.XMotivo;
    Self.CUF := StatusServico.CUF;
    Self.DhRecbto := StatusServico.DhRecbto;
    Self.TMed := StatusServico.TMed;
    Self.DhRetorno := StatusServico.DhRetorno;
    Self.XObs := StatusServico.XObs;
  end;
end;

{ TInutilizarCTeResposta }
constructor TInutilizarCTeResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespInutilizacao, ATipo, AFormato);
end;

procedure TInutilizarCTeResposta.Processar(const ACBrCTe: TACBrCTe);
begin
   with ACBrCTe.WebServices do
   begin
     Self.Msg := Inutilizacao.Msg;
     Self.Versao := Inutilizacao.versao;
     Self.TpAmb := TpAmbToStr(Inutilizacao.TpAmb);
     Self.VerAplic := Inutilizacao.VerAplic;
     Self.CStat := Inutilizacao.CStat;
     Self.XMotivo := Inutilizacao.XMotivo;
     Self.CUF := Inutilizacao.cUF;
     Self.DhRecbto := Inutilizacao.DhRecbto;
     Self.NomeArquivo := Inutilizacao.NomeArquivo;
     Self.Xml := Inutilizacao.XML_ProcInutCTe;
   end;
end;

{ TConsultaCTeResposta }
constructor TConsultaCTeResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespConsulta, ATipo, AFormato);
end;

procedure TConsultaCTeResposta.Processar(const ACBrCTe: TACBrCTe);
begin
   with ACBrCTe.WebServices do
   begin
     Self.Msg := Consulta.Msg;
     Self.Versao := Consulta.versao;
     Self.TpAmb := TpAmbToStr(Consulta.TpAmb);
     Self.VerAplic := Consulta.VerAplic;
     Self.CStat := Consulta.CStat;
     Self.XMotivo := Consulta.XMotivo;
     Self.CUF := Consulta.CUF;
     Self.DhRecbto := Consulta.DhRecbto;
     Self.ChCTe := Consulta.CTeChave;
     Self.NProt := Consulta.Protocolo;
     Self.DigVal := Consulta.protCTe.digVal;
   end;
end;

end.

