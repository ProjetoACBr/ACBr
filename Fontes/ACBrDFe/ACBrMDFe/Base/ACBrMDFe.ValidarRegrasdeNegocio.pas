{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
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

unit ACBrMDFe.ValidarRegrasdeNegocio;

interface

uses
  Classes, SysUtils,
  ACBrMDFe.Classes,
  ACBrXmlBase,
  ACBrDFe.Conversao,
  pcnConversao,
  pmdfeConversaoMDFe;

type
  { TMDFeValidarRegras }

  TMDFeValidarRegras = class
  private
    FpLog: string;

    FMDFe: TMDFe;
    FVersaoDF: TVersaoMDFe;
    FAmbiente: TpcnTipoAmbiente;
    FtpEmis: Integer;
    FCodigoUF: Integer;
    FUF: string;
    FErros: string;

    procedure ValidarRegra226;
    procedure ValidarRegra227;
    procedure ValidarRegra247;
    procedure ValidarRegra252;
    procedure ValidarRegra458;
    procedure ValidarRegra540;
    procedure ValidarRegra541;

    procedure ValidarRegra638;
    procedure ValidarRegra639;
    procedure ValidarRegra666;
    procedure ValidarRegra897;

    procedure ValidacoesGerais;
    procedure ValidacoesTipoEmitente;
    procedure ValidacoesTipoTransportador;
    procedure ValidacoesCarregamentoPosterior;
    procedure ValidacoesDocumentosOriginarios;
    procedure ValidacoesEmitente;
    procedure ValidacoesDataHoraEmissao;
    procedure ValidacoesModalRodoviario;
    procedure ValidacoesAutorizadosXML;
    procedure ValidacoesANTT;
    procedure ValidacoesQRCode;
    procedure ValidacoesResponsavelTecnico;
    procedure ValidacoesOutras;

    procedure GravaLog(const AString: string);
    procedure AdicionaErro(const Erro: string);

  public
    constructor Create(AOwner: TMDFe); reintroduce;

    function Validar(Agora: TDateTime): Boolean;

    property MDFe: TMDFe read FMDFe write FMDFe;
    property VersaoDF: TVersaoMDFe read FVersaoDF write FVersaoDF;
    property Ambiente: TpcnTipoAmbiente read FAmbiente write FAmbiente;
    property tpEmis: Integer read FtpEmis write FtpEmis;
    property CodigoUF: Integer read FCodigoUF write FCodigoUF;
    property UF: string read FUF write FUF;
    property Erros: string read FErros write FErros;
  end;

implementation

uses
  ACBrDFeUtil,
  ACBrUtil.Base,
  ACBrUtil.Strings;

{ TMDFeValidarRegras }

constructor TMDFeValidarRegras.Create(AOwner: TMDFe);
begin
  inherited Create;

  FMDFe := AOwner;
end;

procedure TMDFeValidarRegras.GravaLog(const AString: string);
begin
  FpLog := FpLog + FormatDateTime('hh:nn:ss:zzz', Now) + ' - ' + AString + sLineBreak;
end;

procedure TMDFeValidarRegras.AdicionaErro(const Erro: string);
begin
  FErros := FErros + Erro + sLineBreak;
end;

procedure TMDFeValidarRegras.ValidacoesGerais;
begin
  ValidarRegra227;
  ValidarRegra247;
  ValidarRegra252;
//  ValidarRegra253;
//  ValidarRegra405;
//  ValidarRegra406;
//  ValidarRegra456;
//  ValidarRegra579;
//  ValidarRegra580;
//  ValidarRegra612;
  ValidarRegra666;
//  ValidarRegra680;
//  ValidarRegra685;
end;

procedure TMDFeValidarRegras.ValidacoesTipoEmitente;
begin
  // Todas Valida��es Implementadas
  ValidarRegra540;
  ValidarRegra541;
  ValidarRegra638;
  ValidarRegra639;
end;

procedure TMDFeValidarRegras.ValidacoesTipoTransportador;
begin

end;

procedure TMDFeValidarRegras.ValidacoesCarregamentoPosterior;
begin

end;

procedure TMDFeValidarRegras.ValidacoesDocumentosOriginarios;
begin

end;

procedure TMDFeValidarRegras.ValidacoesEmitente;
begin

end;

procedure TMDFeValidarRegras.ValidacoesDataHoraEmissao;
begin

end;

procedure TMDFeValidarRegras.ValidacoesModalRodoviario;
begin

end;

procedure TMDFeValidarRegras.ValidacoesAutorizadosXML;
begin

end;

procedure TMDFeValidarRegras.ValidacoesANTT;
begin

end;

procedure TMDFeValidarRegras.ValidacoesQRCode;
begin

end;

procedure TMDFeValidarRegras.ValidacoesResponsavelTecnico;
begin

end;

procedure TMDFeValidarRegras.ValidacoesOutras;
begin
  ValidarRegra226;
  ValidarRegra458;
  ValidarRegra897;
end;

function TMDFeValidarRegras.Validar(Agora: TDateTime): Boolean;
begin
  GravaLog('Inicio da Valida��o');

  FErros := '';

  ValidacoesGerais;
  ValidacoesTipoEmitente;
  ValidacoesTipoTransportador;
  ValidacoesCarregamentoPosterior;
  ValidacoesDocumentosOriginarios;
  ValidacoesEmitente;
  ValidacoesDataHoraEmissao;
  ValidacoesModalRodoviario;
  ValidacoesAutorizadosXML;
  ValidacoesANTT;
  ValidacoesQRCode;
  ValidacoesResponsavelTecnico;
  ValidacoesOutras;

  Result := EstaVazio(FErros);

  if not Result then
  begin
    FErros := ACBrStr('Erro(s) nas Regras de neg�cios do Manifesto: ' +
                     IntToStr(MDFe.Ide.nMDF) + sLineBreak + FErros);
  end;

  GravaLog('Fim da Valida��o. Tempo: ' +
           FormatDateTime('hh:nn:ss:zzz', Now - Agora) + sLineBreak +
           'Erros:' + FErros);
end;

procedure TMDFeValidarRegras.ValidarRegra226;
begin
  GravaLog('Validar 226-UF');
  if copy(IntToStr(MDFe.Emit.EnderEmit.cMun), 1, 2) <> IntToStr(CodigoUF) then
    AdicionaErro('226-Rejei��o: C�digo da UF do Emitente diverge da UF autorizadora');
end;

procedure TMDFeValidarRegras.ValidarRegra227;
begin
  GravaLog('Validar: 227-Chave de acesso');
{
  if not ValidarConcatChave then
    AdicionaErro('227-Rejei��o: Chave de Acesso do Campo Id difere da concatena��o dos campos correspondentes');
}
end;

procedure TMDFeValidarRegras.ValidarRegra247;
begin
  GravaLog('Validar 247-UF');
  if MDFe.Emit.EnderEmit.UF <> UF then
    AdicionaErro('247-Rejei��o: Sigla da UF do Emitente difere da UF do Web Service');
end;

procedure TMDFeValidarRegras.ValidarRegra252;
begin
  GravaLog('Validar: 252-Ambiente');
  if (MDFe.Ide.tpAmb <> Ambiente) then
    AdicionaErro('252-Rejei��o: Tipo do ambiente do MDF-e difere do ambiente do Web Service');
end;

procedure TMDFeValidarRegras.ValidarRegra458;
begin
  GravaLog('Validar: 458-Tipo de Transportador');
  if (VersaoDF >= ve300) and (MDFe.Ide.tpTransp <> ttNenhum) and
     (MDFe.Ide.tpEmit = teTranspCargaPropria) and
     (MDFe.Ide.modal = moRodoviario) and ((MDFe.Rodo.veicTracao.Prop.CNPJCPF = '') or
     (MDFe.Rodo.veicTracao.Prop.CNPJCPF = MDFe.emit.CNPJCPF))  then
    AdicionaErro('458-Rejei��o: Tipo de transportador (tpTransp) n�o deve ser preenchido');
end;

procedure TMDFeValidarRegras.ValidarRegra540;
begin
  GravaLog('Validar: 540-Tipo de Emitente');
  if (MDFe.Ide.tpEmit = teTranspCTeGlobalizado) and (MDFe.infDoc.infMunDescarga[0].infCTe.Count > 0) then
    AdicionaErro('540-Rejei��o: N�o deve ser informado Conhecimento de Transporte para tipo de emitente Prestador Servi�o de Transporte que emitir� CTe Globalizado');
end;

procedure TMDFeValidarRegras.ValidarRegra541;
begin
  GravaLog('Validar: 541-Tipo de Emitente');
  if (MDFe.Ide.tpEmit = teTranspCTeGlobalizado) and ((MDFe.Ide.UFIni <> MDFe.Ide.UFFim) or
     (MDFe.Ide.UFIni = 'EX') or (MDFe.Ide.UFFim = 'EX')) then
    AdicionaErro('541-Rejei��o: Tipo de emitente inv�lido para opera��es interestaduais ou com exterior');
end;

procedure TMDFeValidarRegras.ValidarRegra638;
begin
  GravaLog('Validar: 638-Tipo de Emitente');
  if (MDFe.Ide.tpEmit = teTransportadora) and (MDFe.infDoc.infMunDescarga[0].infNFe.Count > 0) then
    AdicionaErro('638-Rejei��o: N�o deve ser informada Nota Fiscal para tipo de emitente Prestador Servi�o de Transporte');
end;

procedure TMDFeValidarRegras.ValidarRegra639;
begin
  GravaLog('Validar: 639-Tipo de Emitente');
  if (MDFe.Ide.tpEmit = teTranspCargaPropria) and (MDFe.infDoc.infMunDescarga[0].infCTe.Count > 0) then
    AdicionaErro('639-Rejei��o: N�o deve ser informado Conhecimento de Transporte Eletr�nico para tipo de emitente Transporte de Carga Pr�pria');
end;

procedure TMDFeValidarRegras.ValidarRegra666;
begin
  GravaLog('Validar: 666-Ano da Chave');
  if Copy(MDFe.infMDFe.ID, 7, 2) < '12' then
    AdicionaErro('666-Rejei��o: Ano da chave de acesso � inferior a 2012');
end;

procedure TMDFeValidarRegras.ValidarRegra897;
begin
  GravaLog('Validar: 897-C�digo do documento: ' + IntToStr(MDFe.Ide.nMDF));
  if not ValidarCodigoDFe(MDFe.Ide.cMDF, MDFe.Ide.nMDF) then
    AdicionaErro('897-Rejei��o: C�digo num�rico em formato inv�lido ');
end;

end.
