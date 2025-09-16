{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Wemerson Souto                                  }
{                              André Ferreira de Moraes                        }
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

unit ACBrNFeNotasFiscais;

interface

uses
  Classes, SysUtils, StrUtils,
  ACBrBase,
  ACBrNFeConfiguracoes, ACBrNFe.Classes,
  {$IfDef USE_ACBr_XMLDOCUMENT}
    ACBrNFe.XmlReader, ACBrNFe.XmlWriter,
  {$Else}
    pcnNFeR, pcnNFeW,
  {$EndIf}
  ACBrNFe.IniReader, ACBrNFe.IniWriter,
  ACBrNFe.JSONReader, ACBrNFe.JSONWriter,
  pcnConversao, pcnLeitor;

type

  { NotaFiscal }

  NotaFiscal = class(TCollectionItem)
  private
    FNFe: TNFe;
    // Xml
{$IfDef USE_ACBr_XMLDOCUMENT}
    FNFeW: TNFeXmlWriter;
    FNFeR: TNFeXmlReader;
{$Else}
    FNFeW: TNFeW;
    FNFeR: TNFeR;
{$EndIf}
    // Ini
    FNFeIniR: TNFeIniReader;
    FNFeIniW: TNFeIniWriter;
    // JSON
    FNFeJSONR: TNFeJSONReader;
    FNFeJSONW: TNFeJSONWriter;

    FConfiguracoes: TConfiguracoesNFe;
    FXMLAssinado: String;
    FXMLOriginal: String;
    FAlertas: String;
    FErroValidacao: String;
    FErroValidacaoCompleto: String;
    FErroRegrasdeNegocios: String;
    FNomeArq: String;

    function GetConfirmada: Boolean;
    function GetcStat: Integer;
    function GetProcessada: Boolean;
    function GetCancelada: Boolean;

    function GetMsg: String;
    function GetNumID: String;
    function GetXMLAssinado: String;
    procedure SetXML(const AValue: String);
    procedure SetXMLOriginal(const AValue: String);
    function ValidarConcatChave: Boolean;
    function CalcularNomeArquivo: String;
    function CalcularPathArquivo: String;
  public
    constructor Create(Collection2: TCollection); override;
    destructor Destroy; override;
    procedure Imprimir;
    procedure ImprimirPDF; overload;
    function ImprimirPDF(AStream: TStream): Boolean; overload;

    procedure Assinar;
    procedure Validar;
    function VerificarAssinatura: Boolean;
    function ValidarRegrasdeNegocios: Boolean;

    function LerXML(const AXML: String): Boolean;
    function LerArqIni(const AIniString: String): Boolean;
    function GerarNFeIni: String;
    function LerJSON(const AJSONString: String): Boolean;
    function GerarJSON: String;

    function GerarXML: String;
    function GravarXML(const NomeArquivo: String = ''; const PathArquivo: String = ''): Boolean;

    function GerarTXT: String;
    function GravarTXT(const NomeArquivo: String = ''; const PathArquivo: String = ''): Boolean;

    function GravarStream(AStream: TStream): Boolean;

    procedure EnviarEmail(const sPara, sAssunto: String; sMensagem: TStrings = nil;
      EnviaPDF: Boolean = True; sCC: TStrings = nil; Anexos: TStrings = nil;
      sReplyTo: TStrings = nil; ManterPDFSalvo: Boolean = True;
      sBCC: TStrings = nil);

    property NomeArq: String read FNomeArq write FNomeArq;
    function CalcularNomeArquivoCompleto(NomeArquivo: String = '';
      PathArquivo: String = ''): String;

    property NFe: TNFe read FNFe;

    // Atribuir a "XML", faz o componente transferir os dados lido para as propriedades internas e "XMLAssinado"
    property XML: String         read FXMLOriginal   write SetXML;
    // Atribuir a "XMLOriginal", reflete em XMLAssinado, se existir a tag de assinatura
    property XMLOriginal: String read FXMLOriginal   write SetXMLOriginal;    // Sempre deve estar em UTF8
    property XMLAssinado: String read GetXMLAssinado write FXMLAssinado;      // Sempre deve estar em UTF8
    property Confirmada: Boolean read GetConfirmada;
    property Processada: Boolean read GetProcessada;
    property Cancelada: Boolean read GetCancelada;
    property cStat: Integer read GetcStat;
    property Msg: String read GetMsg;
    property NumID: String read GetNumID;

    property Alertas: String read FAlertas;
    property ErroValidacao: String read FErroValidacao;
    property ErroValidacaoCompleto: String read FErroValidacaoCompleto;
    property ErroRegrasdeNegocios: String read FErroRegrasdeNegocios;

  end;

  { TNotasFiscais }

  TNotasFiscais = class(TOwnedCollection)
  private
    FACBrNFe: TComponent;
    FConfiguracoes: TConfiguracoesNFe;

    function GetItem(Index: integer): NotaFiscal;
    procedure SetItem(Index: integer; const Value: NotaFiscal);

    procedure VerificarDANFE;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);

    procedure GerarNFe;
    procedure Assinar;
    procedure Validar;
    function VerificarAssinatura(out Erros: String): Boolean;
    function ValidarRegrasdeNegocios(out Erros: String): Boolean;
    procedure Imprimir;
    procedure ImprimirCancelado;
    procedure ImprimirResumido;
    procedure ImprimirPDF; overload;
    procedure ImprimirPDF(AStream: TStream); overload;
    procedure ImprimirResumidoPDF; overload;
    procedure ImprimirResumidoPDF(AStream: TStream); overload;
    function Add: NotaFiscal;
    function Insert(Index: integer): NotaFiscal;

    property Items[Index: integer]: NotaFiscal read GetItem write SetItem; default;

    function GetNamePath: String; override;
    // Incluido o Parametro AGerarNFe que determina se após carregar os dados da NFe
    // para o componente, será gerado ou não novamente o XML da NFe.
    function LoadFromFile(const CaminhoArquivo: String; AGerarNFe: Boolean = False): Boolean;
    function LoadFromStream(AStream: TStringStream; AGerarNFe: Boolean = False): Boolean;
    function LoadFromString(const AXMLString: String; AGerarNFe: Boolean = False): Boolean;
    function LoadFromIni(const AIniString: String): Boolean;
    function LoadFromJSON(const AJSONString: String): Boolean;

    function GerarIni: String;
    function GerarJSON: String;
    function GravarXML(const APathNomeArquivo: String = ''): Boolean;
    function GravarTXT(const APathNomeArquivo: String = ''): Boolean;

    property ACBrNFe: TComponent read FACBrNFe;
  end;

implementation

uses
  dateutils, IniFiles,
  synautil,
  ACBrNFe,
  ACBrNFe.ValidarRegrasdeNegocio,
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrUtil.XMLHTML,
  ACBrUtil.FilesIO,
  ACBrUtil.DateTime,
  ACBrUtil.Math,
  ACBrDFeUtil,
  pcnConversaoNFe;

{ NotaFiscal }

constructor NotaFiscal.Create(Collection2: TCollection);
begin
  inherited Create(Collection2);

  FNFe := TNFe.Create;
  // Xml
{$IfDef USE_ACBr_XMLDOCUMENT}
  FNFeW := TNFeXmlWriter.Create(FNFe);
  FNFeR := TNFeXmlReader.Create(FNFe);
{$Else}
  FNFeW := TNFeW.Create(FNFe);
  FNFeR := TNFeR.Create(FNFe);
{$EndIf}
  // Ini
  FNFeIniR := TNFeIniReader.Create(FNFe);
  FNFeIniW := TNFeIniWriter.Create(FNFe);
  //JSON
  FNFeJSONR := TNFeJSONReader.Create(FNFe);
  FNFeJSONW := TNFeJSONWriter.Create(FNFe);

  FConfiguracoes := TACBrNFe(TNotasFiscais(Collection).ACBrNFe).Configuracoes;

  FNFe.Ide.tpNF    := tnSaida;
  FNFe.Ide.indPag  := ipVista;
  FNFe.Ide.verProc := 'ACBrNFe';

  FNFe.Emit.EnderEmit.xPais := 'BRASIL';
  FNFe.Emit.EnderEmit.cPais := 1058;
  FNFe.Emit.EnderEmit.nro := 'SEM NUMERO';

  FNFe.Dest.EnderDest.xPais := 'BRASIL';
  FNFe.Dest.EnderDest.cPais := 1058;

  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    FNFe.Ide.modelo := StrToInt(ModeloDFToStr(Configuracoes.Geral.ModeloDF));
    FNFe.infNFe.Versao := VersaoDFToDbl(Configuracoes.Geral.VersaoDF);
    FNFe.Ide.tpAmb   := Configuracoes.WebServices.Ambiente;
    FNFe.Ide.tpEmis  := Configuracoes.Geral.FormaEmissao;

    if Assigned(DANFE) then
      FNFe.Ide.tpImp := DANFE.TipoDANFE;
  end;
end;

destructor NotaFiscal.Destroy;
begin
  // Xml
  FNFeW.Free;
  FNFeR.Free;
  // Ini
  FNFeIniR.Free;
  FNFeIniW.Free;
  //JSON
  FNFeJSONR.Free;
  FNFeJSONW.Free;

  FNFe.Free;

  inherited Destroy;
end;

procedure NotaFiscal.Imprimir;
begin
  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    if not Assigned(DANFE) then
      raise EACBrNFeException.Create('Componente DA'+ModeloDFToPrefixo(Configuracoes.Geral.ModeloDF)+' não associado.')
    else
      DANFE.ImprimirDANFE(NFe);
  end;
end;

procedure NotaFiscal.ImprimirPDF;
begin
  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    if not Assigned(DANFE) then
      raise EACBrNFeException.Create('Componente DA'+ModeloDFToPrefixo(Configuracoes.Geral.ModeloDF)+' não associado.')
    else begin
      if (DANFE.ClassName = 'TACBrNFeDANFCEFR') or
         (DANFE.ClassName = 'TACBrNFeDANFEFR') then
        DANFE.FIndexImpressaoIndividual := Index + 1
      else
        DANFE.FIndexImpressaoIndividual := Index;
      DANFE.ImprimirDANFEPDF(NFe);
    end;
  end;
end;

function NotaFiscal.ImprimirPDF(AStream: TStream): Boolean;
begin
  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    if not Assigned(DANFE) then
      raise EACBrNFeException.Create('Componente DA'+ModeloDFToPrefixo(Configuracoes.Geral.ModeloDF)+' não associado.')
    else
    begin
      AStream.Size := 0;
      DANFE.ImprimirDANFEPDF(AStream, NFe);
      Result := True;
    end;
  end;
end;

procedure NotaFiscal.Assinar;
var
  XMLStr: string;
  XMLUTF8: AnsiString;
  Leitor: TLeitor;
begin
  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    if not Assigned(SSL.AntesDeAssinar) then
      SSL.ValidarCNPJCertificado( NFe.Emit.CNPJCPF );
  end;

  // Gera novamente, para processar propriedades que podem ter sido modificadas
  XMLStr := GerarXML;

  // XML já deve estar em UTF8, para poder ser assinado //
  XMLUTF8 := ConverteXMLtoUTF8(XMLStr);

  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    FXMLAssinado := SSL.Assinar(String(XMLUTF8), 'NFe', 'infNFe');
    // SSL.Assinar() sempre responde em UTF8...
    FXMLOriginal := FXMLAssinado;

    Leitor := TLeitor.Create;
    try
      leitor.Grupo := FXMLAssinado;
      NFe.signature.URI := Leitor.rAtributo('Reference URI=');
      NFe.signature.DigestValue := Leitor.rCampo(tcStr, 'DigestValue');
      NFe.signature.SignatureValue := Leitor.rCampo(tcStr, 'SignatureValue');
      NFe.signature.X509Certificate := Leitor.rCampo(tcStr, 'X509Certificate');
    finally
      Leitor.Free;
    end;

    // Se for NFCe, deve gera o QR-Code para adicionar no XML após ter a
    // assinatura, e antes de ser salvo.
    // Homologação: 01/10/2015
    // Produção: 03/11/2015

    if (NFe.Ide.modelo = 65) then
    begin
      with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
      begin
        NFe.infNFeSupl.qrCode := GetURLQRCode(NFe);

        if NFe.infNFe.Versao >= 4 then
          NFe.infNFeSupl.urlChave := GetURLConsultaNFCe(NFe.Ide.cUF, NFe.Ide.tpAmb, NFe.infNFe.Versao);

        GerarXML;
      end;
    end;

    if Configuracoes.Arquivos.Salvar and
       (not Configuracoes.Arquivos.SalvarApenasNFeProcessadas) then
    begin
      if NaoEstaVazio(NomeArq) then
        Gravar(NomeArq, FXMLAssinado)
      else
        Gravar(CalcularNomeArquivoCompleto(), FXMLAssinado);
    end;
  end;
end;

procedure NotaFiscal.Validar;
var
  Erro, AXML: String;
  NotaEhValida, ok: Boolean;
  ALayout: TLayOut;
  VerServ: Real;
  Modelo: TpcnModeloDF;
  cUF: Integer;
begin
  AXML := FXMLAssinado;
  if AXML = '' then
    AXML := XMLOriginal;

  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    VerServ := FNFe.infNFe.Versao;
    Modelo  := StrToModeloDF(ok, IntToStr(FNFe.Ide.modelo));
    cUF     := FNFe.Ide.cUF;

    if EhAutorizacao( DblToVersaoDF(ok, VerServ), Modelo, cUF) then
      ALayout := LayNfeAutorizacao
    else
      ALayout := LayNfeRecepcao;

    // Extraindo apenas os dados da NFe (sem nfeProc)
    AXML := ObterDFeXML(AXML, 'NFe', ACBRNFE_NAMESPACE);

    if EstaVazio(AXML) then
    begin
      Erro := ACBrStr('NFe não encontrada no XML');
      NotaEhValida := False;
    end
    else
      NotaEhValida := SSL.Validar(AXML, GerarNomeArqSchema(ALayout, VerServ), Erro);

    if not NotaEhValida then
    begin
      FErroValidacao := ACBrStr('Falha na validação dos dados da nota: ') +
        IntToStr(NFe.Ide.nNF) + sLineBreak + FAlertas;
      FErroValidacaoCompleto := FErroValidacao + sLineBreak + Erro;

      raise EACBrNFeException.CreateDef(
        IfThen(Configuracoes.Geral.ExibirErroSchema, ErroValidacaoCompleto,
        ErroValidacao));
    end;
  end;
end;

function NotaFiscal.VerificarAssinatura: Boolean;
var
  Erro, AXML: String;
  AssEhValida: Boolean;
begin
  AXML := FXMLAssinado;
  if AXML = '' then
    AXML := XMLOriginal;

  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    // Extraindo apenas os dados da NFe (sem nfeProc)
    AXML := ObterDFeXML(AXML, 'NFe', ACBRNFE_NAMESPACE);

    if EstaVazio(AXML) then
    begin
      Erro := ACBrStr('NFe não encontrada no XML');
      AssEhValida := False;
    end
    else
      AssEhValida := SSL.VerificarAssinatura(AXML, Erro, 'infNFe');

    if not AssEhValida then
    begin
      FErroValidacao := ACBrStr('Falha na validação da assinatura da nota: ') +
        IntToStr(NFe.Ide.nNF) + sLineBreak + Erro;
    end;
  end;

  Result := AssEhValida;
end;

function NotaFiscal.ValidarRegrasdeNegocios: Boolean;
var
  Agora: TDateTime;
  FValidarRegras: TNFeValidarRegras;
begin
  // Converte o DateTime do Sistema para o TimeZone configurado, para evitar
  // divergência de Fuso Horário.
  Agora := DataHoraTimeZoneModoDeteccao(TACBrNFe(TNotasFiscais(Collection).ACBrNFe));

  FValidarRegras := TNFeValidarRegras.Create(FNFe);

  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    FValidarRegras.VersaoDF := Configuracoes.Geral.VersaoDF;
    FValidarRegras.Ambiente := Configuracoes.WebServices.Ambiente;
    FValidarRegras.tpEmis := Configuracoes.Geral.FormaEmissaoCodigo;
    FValidarRegras.CodigoUF := Configuracoes.WebServices.UFCodigo;
    FValidarRegras.UF := Configuracoes.WebServices.UF;
  end;

  Result := FValidarRegras.Validar(Agora);

  FErroRegrasdeNegocios := FValidarRegras.Erros;
end;

function NotaFiscal.LerXML(const AXML: String): Boolean;
{$IfNDef USE_ACBr_XMLDOCUMENT}
var
  XMLStr: String;
{$EndIf}
begin
  XMLOriginal := AXML;  // SetXMLOriginal() irá verificar se AXML está em UTF8

{$IfDef USE_ACBr_XMLDOCUMENT}
  FNFeR.Arquivo := XMLOriginal;
{$Else}
  { Verifica se precisa converter "AXML" de UTF8 para a String nativa da IDE.
    Isso é necessário, para que as propriedades fiquem com a acentuação correta }
  XMLStr := ParseText(AXML, True, XmlEhUTF8(AXML));

  {
   ****** Remoção do NameSpace do XML ******

   XML baixados dos sites de algumas SEFAZ constuma ter ocorrências do
   NameSpace em grupos diversos não previstos no MOC.
   Essas ocorrências acabam prejudicando a leitura correta do XML.
  }
  XMLStr := StringReplace(XMLStr, ' xmlns="http://www.portalfiscal.inf.br/nfe"', '', [rfReplaceAll]);

  FNFeR.Leitor.Arquivo := XMLStr;
{$EndIf}
  FNFeR.LerXml;
  Result := True;
end;

function NotaFiscal.LerArqIni(const AIniString: String): Boolean;
begin
  FNFeIniR.VersaoDF := FConfiguracoes.Geral.VersaoDF;
  FNFeIniR.Ambiente := StrToInt(TpAmbToStr(FConfiguracoes.WebServices.Ambiente));
  FNFeIniR.tpEmis := FConfiguracoes.Geral.FormaEmissaoCodigo;

  FNFeIniR.LerIni(AIniString);

  GerarXML;

  Result := True;
end;

function NotaFiscal.GerarNFeIni: String;
begin
  Result := FNFeIniW.GravarIni;
end;

function NotaFiscal.LerJSON(const AJSONString: String): Boolean;
begin
  FNFeJSONR.LerJSON(AJSONString);
  GerarXML;
  Result := True;
end;

function NotaFiscal.GerarJSON: String;
begin
  Result := FNFeJSONW.GerarJSON;
end;

function NotaFiscal.GravarXML(const NomeArquivo: String; const PathArquivo: String): Boolean;
begin
  if EstaVazio(FXMLOriginal) then
    GerarXML;

  FNomeArq := CalcularNomeArquivoCompleto(NomeArquivo, PathArquivo);

  Result := TACBrNFe(TNotasFiscais(Collection).ACBrNFe).Gravar(FNomeArq, FXMLOriginal);
end;

function NotaFiscal.GravarTXT(const NomeArquivo: String; const PathArquivo: String): Boolean;
var
  ATXT: String;
begin
  FNomeArq := CalcularNomeArquivoCompleto(NomeArquivo, PathArquivo);
  ATXT := GerarTXT;
  Result := TACBrNFe(TNotasFiscais(Collection).ACBrNFe).Gravar(
    ChangeFileExt(FNomeArq, '.txt'), ATXT);
end;

function NotaFiscal.GravarStream(AStream: TStream): Boolean;
begin
  if EstaVazio(FXMLOriginal) then
    GerarXML;

  AStream.Size := 0;
  WriteStrToStream(AStream, AnsiString(FXMLOriginal));
  Result := True;
end;

procedure NotaFiscal.EnviarEmail(const sPara, sAssunto: String; sMensagem: TStrings;
  EnviaPDF: Boolean; sCC: TStrings; Anexos: TStrings; sReplyTo: TStrings;
  ManterPDFSalvo: Boolean; sBCC: TStrings);
var
  NomeArqTemp: string;
  AnexosEmail:TStrings;
  StreamNFe: TMemoryStream;
begin
  if not Assigned(TACBrNFe(TNotasFiscais(Collection).ACBrNFe).MAIL) then
    raise EACBrNFeException.Create('Componente ACBrMail não associado');

  AnexosEmail := TStringList.Create;
  StreamNFe := TMemoryStream.Create;
  try
    AnexosEmail.Clear;
    if Assigned(Anexos) then
      AnexosEmail.Assign(Anexos);

    with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
    begin
      Self.GravarStream(StreamNFe);

      if (EnviaPDF) then
      begin
        if Assigned(DANFE) then
        begin
          DANFE.ImprimirDANFEPDF(FNFe);
//          NomeArqTemp := PathWithDelim(DANFE.PathPDF) + NumID + '-nfe.pdf';
          NomeArqTemp := DANFE.ArquivoPDF;
          AnexosEmail.Add(NomeArqTemp);
        end;
      end;

      EnviarEmail( sPara, sAssunto, sMensagem, sCC, AnexosEmail, StreamNFe,
                   NumID +'-nfe.xml', sReplyTo, sBCC);
    end;
  finally
    if not ManterPDFSalvo then
      DeleteFile(NomeArqTemp);

    AnexosEmail.Free;
    StreamNFe.Free;
  end;
end;

function NotaFiscal.GerarXML: String;
var
  IdAnterior : String;
begin
  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    IdAnterior := NFe.infNFe.ID;
{$IfDef USE_ACBr_XMLDOCUMENT}
    FNFeW.Opcoes.FormatoAlerta  := Configuracoes.Geral.FormatoAlerta;
    FNFeW.Opcoes.RetirarAcentos := Configuracoes.Geral.RetirarAcentos;
    FNFeW.Opcoes.RetirarEspacos := Configuracoes.Geral.RetirarEspacos;
    FNFeW.Opcoes.IdentarXML := Configuracoes.Geral.IdentarXML;
    FNFeW.Opcoes.NormatizarMunicipios  := Configuracoes.Arquivos.NormatizarMunicipios;
    FNFeW.Opcoes.PathArquivoMunicipios := Configuracoes.Arquivos.PathArquivoMunicipios;
    FNFeW.Opcoes.CamposFatObrigatorios := Configuracoes.Geral.CamposFatObrigatorios;
    FNFeW.Opcoes.ForcarGerarTagRejeicao938 := Configuracoes.Geral.ForcarGerarTagRejeicao938;
    FNFeW.Opcoes.ForcarGerarTagRejeicao906 := Configuracoes.Geral.ForcarGerarTagRejeicao906;
    FNFeW.Opcoes.QuebraLinha := Configuracoes.WebServices.QuebradeLinha;
{$Else}
    FNFeW.Gerador.Opcoes.FormatoAlerta  := Configuracoes.Geral.FormatoAlerta;
    FNFeW.Gerador.Opcoes.RetirarAcentos := Configuracoes.Geral.RetirarAcentos;
    FNFeW.Gerador.Opcoes.RetirarEspacos := Configuracoes.Geral.RetirarEspacos;
    FNFeW.Gerador.Opcoes.IdentarXML := Configuracoes.Geral.IdentarXML;
    FNFeW.Gerador.Opcoes.QuebraLinha := Configuracoes.WebServices.QuebradeLinha;
    FNFeW.Opcoes.NormatizarMunicipios  := Configuracoes.Arquivos.NormatizarMunicipios;
    FNFeW.Opcoes.PathArquivoMunicipios := Configuracoes.Arquivos.PathArquivoMunicipios;
    FNFeW.Opcoes.CamposFatObrigatorios := Configuracoes.Geral.CamposFatObrigatorios;
    FNFeW.Opcoes.ForcarGerarTagRejeicao938 := Configuracoes.Geral.ForcarGerarTagRejeicao938;
    FNFeW.Opcoes.ForcarGerarTagRejeicao906 := Configuracoes.Geral.ForcarGerarTagRejeicao906;
{$EndIf}

    TimeZoneConf.Assign( Configuracoes.WebServices.TimeZoneConf );

    {
      Ao gerar o XML as tags e atributos tem que ser exatamente os da configuração
    }
    {
    FNFeW.VersaoDF := Configuracoes.Geral.VersaoDF;
    FNFeW.ModeloDF := Configuracoes.Geral.ModeloDF;
    FNFeW.tpAmb := Configuracoes.WebServices.Ambiente;
    FNFeW.tpEmis := Configuracoes.Geral.FormaEmissao;
    }
    FNFeW.idCSRT := Configuracoes.RespTec.IdCSRT;
    FNFeW.CSRT   := Configuracoes.RespTec.CSRT;
  end;

{$IfNDef USE_ACBr_XMLDOCUMENT}
  FNFeW.Opcoes.GerarTXTSimultaneamente := False;
{$EndIf}

  FNFeW.GerarXml;
  //DEBUG
  //WriteToTXT('c:\temp\Notafiscal.xml', FNFeW.Document.Xml, False, False);
  //WriteToTXT('c:\temp\Notafiscal.xml', FNFeW.Gerador.ArquivoFormatoXML, False, False);

{$IfDef USE_ACBr_XMLDOCUMENT}
  XMLOriginal := FNFeW.Document.Xml;  // SetXMLOriginal() irá converter para UTF8
{$Else}
  XMLOriginal := FNFeW.Gerador.ArquivoFormatoXML;  // SetXMLOriginal() irá converter para UTF8
{$EndIf}

  { XML gerado pode ter nova Chave e ID, então devemos calcular novamente o
    nome do arquivo, mantendo o PATH do arquivo carregado }
  if (NaoEstaVazio(FNomeArq) and (IdAnterior <> FNFe.infNFe.ID)) then
    FNomeArq := CalcularNomeArquivoCompleto('', ExtractFilePath(FNomeArq));

{$IfDef USE_ACBr_XMLDOCUMENT}
  FAlertas := ACBrStr( FNFeW.ListaDeAlertas.Text );
{$Else}
  FAlertas := ACBrStr( FNFeW.Gerador.ListaDeAlertas.Text );
{$EndIf}
  Result := FXMLOriginal;
end;

function NotaFiscal.GerarTXT: String;
{$IfNDef USE_ACBr_XMLDOCUMENT}
var
  IdAnterior : String;
{$EndIf}
begin
  Result := '';
{$IfNDef USE_ACBr_XMLDOCUMENT}
  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    IdAnterior                             := NFe.infNFe.ID;
    FNFeW.Gerador.Opcoes.FormatoAlerta     := Configuracoes.Geral.FormatoAlerta;
    FNFeW.Gerador.Opcoes.RetirarAcentos    := Configuracoes.Geral.RetirarAcentos;
    FNFeW.Gerador.Opcoes.RetirarEspacos    := Configuracoes.Geral.RetirarEspacos;
    FNFeW.Gerador.Opcoes.IdentarXML        := Configuracoes.Geral.IdentarXML;
    FNFeW.Opcoes.NormatizarMunicipios      := Configuracoes.Arquivos.NormatizarMunicipios;
    FNFeW.Opcoes.PathArquivoMunicipios     := Configuracoes.Arquivos.PathArquivoMunicipios;
    FNFeW.Opcoes.CamposFatObrigatorios     := Configuracoes.Geral.CamposFatObrigatorios;
    FNFeW.Opcoes.ForcarGerarTagRejeicao938 := Configuracoes.Geral.ForcarGerarTagRejeicao938;
    FNFeW.Opcoes.ForcarGerarTagRejeicao906 := Configuracoes.Geral.ForcarGerarTagRejeicao906;
  end;

  FNFeW.Opcoes.GerarTXTSimultaneamente := True;

  FNFeW.GerarXml;
  XMLOriginal := FNFeW.Gerador.ArquivoFormatoXML;

  if (NaoEstaVazio(FNomeArq) and (IdAnterior <> FNFe.infNFe.ID)) then// XML gerado pode ter nova Chave e ID, então devemos calcular novamente o nome do arquivo, mantendo o PATH do arquivo carregado
    FNomeArq := CalcularNomeArquivoCompleto('', ExtractFilePath(FNomeArq));

  FAlertas := FNFeW.Gerador.ListaDeAlertas.Text;
  Result   := FNFeW.Gerador.ArquivoFormatoTXT;
{$EndIf}
end;

function NotaFiscal.CalcularNomeArquivo: String;
var
  xID: String;
  NomeXML: String;
begin
  xID := Self.NumID;

  if EstaVazio(xID) then
    raise EACBrNFeException.Create('ID Inválido. Impossível Salvar XML');

  NomeXML := '-nfe.xml';

  Result := xID + NomeXML;
end;

function NotaFiscal.CalcularPathArquivo: String;
var
  Data: TDateTime;
begin
  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    if Configuracoes.Arquivos.EmissaoPathNFe then
      Data := FNFe.Ide.dEmi
    else
      Data := Now;

    Result := PathWithDelim(Configuracoes.Arquivos.GetPathNFe(Data, FNFe.Emit.CNPJCPF, FNFe.Emit.IE, FNFe.Ide.modelo));
  end;
end;

function NotaFiscal.CalcularNomeArquivoCompleto(NomeArquivo: String;
  PathArquivo: String): String;
var
  PathNoArquivo: String;
begin
  if EstaVazio(NomeArquivo) then
    NomeArquivo := CalcularNomeArquivo;

  PathNoArquivo := ExtractFilePath(NomeArquivo);
  if EstaVazio(PathNoArquivo) then
  begin
    if EstaVazio(PathArquivo) then
      PathArquivo := CalcularPathArquivo
    else
      PathArquivo := PathWithDelim(PathArquivo);
  end
  else
    PathArquivo := '';

  Result := PathArquivo + NomeArquivo;
end;

function NotaFiscal.ValidarConcatChave: Boolean;
var
  wAno, wMes, wDia: word;
  chaveNFe : String;
begin
  DecodeDate(nfe.ide.dEmi, wAno, wMes, wDia);

  chaveNFe := OnlyNumber(NFe.infNFe.ID);
  {(*}
  Result := not
    ((Copy(chaveNFe, 1, 2) <> IntToStrZero(NFe.Ide.cUF, 2)) or
    (Copy(chaveNFe, 3, 2)  <> Copy(FormatFloat('0000', wAno), 3, 2)) or
    (Copy(chaveNFe, 5, 2)  <> FormatFloat('00', wMes)) or
    (Copy(chaveNFe, 7, 14) <> PadLeft(OnlyNumber(NFe.Emit.CNPJCPF), 14, '0')) or
    (Copy(chaveNFe, 21, 2) <> IntToStrZero(NFe.Ide.modelo, 2)) or
    (Copy(chaveNFe, 23, 3) <> IntToStrZero(NFe.Ide.serie, 3)) or
    (Copy(chaveNFe, 26, 9) <> IntToStrZero(NFe.Ide.nNF, 9)) or
    (Copy(chaveNFe, 35, 1) <> TpEmisToStr(NFe.Ide.tpEmis)) or
    (Copy(chaveNFe, 36, 8) <> IntToStrZero(NFe.Ide.cNF, 8)));
  {*)}
end;

function NotaFiscal.GetConfirmada: Boolean;
begin
  Result := TACBrNFe(TNotasFiscais(Collection).ACBrNFe).CstatConfirmada(
    FNFe.procNFe.cStat);
end;

function NotaFiscal.GetcStat: Integer;
begin
 Result := FNFe.procNFe.cStat;
end;

function NotaFiscal.GetProcessada: Boolean;
begin
  Result := TACBrNFe(TNotasFiscais(Collection).ACBrNFe).CstatProcessado(
    FNFe.procNFe.cStat);
end;

function NotaFiscal.GetCancelada: Boolean;
begin
  Result := TACBrNFe(TNotasFiscais(Collection).ACBrNFe).CstatCancelada(
    FNFe.procNFe.cStat);
end;

function NotaFiscal.GetMsg: String;
begin
  Result := FNFe.procNFe.xMotivo;
end;

function NotaFiscal.GetNumID: String;
begin
  Result := OnlyNumber(NFe.infNFe.ID);
end;

function NotaFiscal.GetXMLAssinado: String;
begin
  if EstaVazio(FXMLAssinado) then
    Assinar;

  Result := FXMLAssinado;
end;

procedure NotaFiscal.SetXML(const AValue: String);
begin
  LerXML(AValue);
end;

procedure NotaFiscal.SetXMLOriginal(const AValue: String);
var
  XMLUTF8: String;
begin
  { Garante que o XML informado está em UTF8, se ele realmente estiver, nada
    será modificado por "ConverteXMLtoUTF8"  (mantendo-o "original") }
  XMLUTF8 := ConverteXMLtoUTF8(AValue);

  FXMLOriginal := XMLUTF8;

  if XmlEstaAssinado(FXMLOriginal) then
    FXMLAssinado := FXMLOriginal
  else
    FXMLAssinado := '';
end;

{ TNotasFiscais }

constructor TNotasFiscais.Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
begin
  if not (AOwner is TACBrNFe) then
    raise EACBrNFeException.Create('AOwner deve ser do tipo TACBrNFe');

  inherited Create(AOwner, ItemClass);

  FACBrNFe := TACBrNFe(AOwner);
  FConfiguracoes := TACBrNFe(FACBrNFe).Configuracoes;
end;

function TNotasFiscais.Add: NotaFiscal;
begin
  Result := NotaFiscal(inherited Add);
end;

procedure TNotasFiscais.Assinar;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].Assinar;
end;

procedure TNotasFiscais.GerarNFe;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].GerarXML;
end;

function TNotasFiscais.GetItem(Index: integer): NotaFiscal;
begin
  Result := NotaFiscal(inherited Items[Index]);
end;

function TNotasFiscais.GetNamePath: String;
begin
  Result := 'NotaFiscal';
end;

procedure TNotasFiscais.VerificarDANFE;
begin
  if not Assigned(TACBrNFe(FACBrNFe).DANFE) then
    raise EACBrNFeException.Create('Componente DANFE não associado.');
end;

procedure TNotasFiscais.Imprimir;
begin
  VerificarDANFE;
  TACBrNFe(FACBrNFe).DANFE.ImprimirDANFE(nil);
end;

procedure TNotasFiscais.ImprimirCancelado;
begin
  VerificarDANFE;
  TACBrNFe(FACBrNFe).DANFE.ImprimirDANFECancelado(nil);
end;

procedure TNotasFiscais.ImprimirResumido;
begin
  VerificarDANFE;
  TACBrNFe(FACBrNFe).DANFE.ImprimirDANFEResumido(nil);
end;

procedure TNotasFiscais.ImprimirPDF;
begin
  VerificarDANFE;
  TACBrNFe(FACBrNFe).DANFE.ImprimirDANFEPDF;
end;

procedure TNotasFiscais.ImprimirPDF(AStream: TStream);
begin
  VerificarDANFE;
  TACBrNFe(FACBrNFe).DANFE.ImprimirDANFEPDF(AStream);
end;

procedure TNotasFiscais.ImprimirResumidoPDF;
begin
  VerificarDANFE;
  TACBrNFe(FACBrNFe).DANFE.ImprimirDANFEResumidoPDF;
end;

procedure TNotasFiscais.ImprimirResumidoPDF(AStream: TStream);
begin
  VerificarDANFE;
  TACBrNFe(FACBrNFe).DANFE.ImprimirDANFEResumidoPDF(AStream);
end;

function TNotasFiscais.Insert(Index: integer): NotaFiscal;
begin
  Result := NotaFiscal(inherited Insert(Index));
end;

procedure TNotasFiscais.SetItem(Index: integer; const Value: NotaFiscal);
begin
  Items[Index].Assign(Value);
end;

procedure TNotasFiscais.Validar;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].Validar;   // Dispara exception em caso de erro
end;

function TNotasFiscais.VerificarAssinatura(out Erros: String): Boolean;
var
  i: integer;
begin
  Result := True;
  Erros := '';

  if Self.Count < 1 then
  begin
    Erros := 'Nenhuma '+ModeloDFToPrefixo(Self.FConfiguracoes.Geral.ModeloDF)+' carregada';
    Result := False;
    Exit;
  end;

  for i := 0 to Self.Count - 1 do
  begin
    if not Self.Items[i].VerificarAssinatura then
    begin
      Result := False;
      Erros := Erros + Self.Items[i].ErroValidacao + sLineBreak;
    end;
  end;
end;

function TNotasFiscais.ValidarRegrasdeNegocios(out Erros: String): Boolean;
var
  i: integer;
  msg: String;
begin
  Result := True;
  Erros := '';
  msg := '';

  for i := 0 to Self.Count - 1 do
  begin
    if not Self.Items[i].ValidarRegrasdeNegocios then
    begin
      Result := False;
      msg := Self.Items[i].ErroRegrasdeNegocios;

      if Pos(msg, Erros) <= 0 then
        Erros := Erros + Self.Items[i].ErroRegrasdeNegocios + sLineBreak;
    end;
  end;
end;

function TNotasFiscais.LoadFromFile(const CaminhoArquivo: String;
  AGerarNFe: Boolean): Boolean;
var
  XMLUTF8: AnsiString;
  i, l: integer;
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    MS.LoadFromFile(CaminhoArquivo);
    XMLUTF8 := ReadStrFromStream(MS, MS.Size);
  finally
    MS.Free;
  end;

  l := Self.Count; // Indice da última nota já existente
  //Result := LoadFromString(String(XMLUTF8), AGerarNFe);
  Result := LoadFromString(String(InserirDeclaracaoXMLSeNecessario(XMLUTF8)), AGerarNFe);

  if Result then
  begin
    // Atribui Nome do arquivo a novas notas inseridas //
    for i := l to Self.Count - 1 do
      Self.Items[i].NomeArq := CaminhoArquivo;
  end;
end;

function TNotasFiscais.LoadFromStream(AStream: TStringStream;
  AGerarNFe: Boolean): Boolean;
var
  AXML: AnsiString;
begin
  AStream.Position := 0;
  AXML := ReadStrFromStream(AStream, AStream.Size);

  Result := Self.LoadFromString(String(AXML), AGerarNFe);
end;

function TNotasFiscais.LoadFromString(const AXMLString: String;
  AGerarNFe: Boolean): Boolean;
var
  ANFeXML, XMLStr: AnsiString;
  P, N: integer;

  function PosNFe: integer;
  begin
    Result := pos('</NFe>', XMLStr);
  end;

begin
  // Verifica se precisa Converter de UTF8 para a String nativa da IDE //

  if (Trim(AXMLString) <> '') and (XmlEhUTF8BOM(AXMLString)) then
  begin
    //Se tiver o BOM, eu ignoro os bytes do mesmo.
    XMLStr := Copy(AXMLString, 4, Length(AXMLString));
    XMLStr := ConverteXMLtoNativeString(XMLStr);
  end
  else
    XMLStr := ConverteXMLtoNativeString(AXMLString);

  N := PosNFe;
  while N > 0 do
  begin
    P := pos('</nfeProc>', XMLStr);

    if P <= 0 then
      P := pos('</procNFe>', XMLStr);  // NFe obtida pelo Portal da Receita

    if P > 0 then
    begin
      ANFeXML := copy(XMLStr, 1, P + 10);
      XMLStr := Trim(copy(XMLStr, P + 10, length(XMLStr)));
    end
    else
    begin
      ANFeXML := copy(XMLStr, 1, N + 6);
      XMLStr := Trim(copy(XMLStr, N + 6, length(XMLStr)));
    end;

    with Self.Add do
    begin
      LerXML(ANFeXML);

      if AGerarNFe then // Recalcula o XML
        GerarXML;
    end;

    N := PosNFe;
  end;

  Result := Self.Count > 0;
end;

function TNotasFiscais.LoadFromIni(const AIniString: String): Boolean;
begin
  with Self.Add do
    LerArqIni(AIniString);

  Result := Self.Count > 0;
end;

function TNotasFiscais.GerarIni: String;
begin
  Result := '';
  if (Self.Count > 0) then
    Result := Self.Items[0].GerarNFeIni;

end;

function TNotasFiscais.GerarJSON: String;
begin
  Result := '';
  if (Self.Count > 0) then
    Result := Self.Items[0].GerarJSON;
end;

function TNotasFiscais.LoadFromJSON(const AJSONString: String): Boolean;
begin
  Result := False;
  Self.Add.LerJSON(AJSONString);
  Result := Self.Count > 0;
end;

function TNotasFiscais.GravarXML(const APathNomeArquivo: String): Boolean;
var
  i: integer;
  NomeArq, PathArq : String;
begin
  Result := True;
  i := 0;
  while Result and (i < Self.Count) do
  begin
    PathArq := ExtractFilePath(APathNomeArquivo);
    NomeArq := ExtractFileName(APathNomeArquivo);
    Result := Self.Items[i].GravarXML(NomeArq, PathArq);
    Inc(i);
  end;
end;

function TNotasFiscais.GravarTXT(const APathNomeArquivo: String): Boolean;
var
  SL: TStringList;
  ArqTXT: String;
  PathArq : string;
  I: integer;
begin
  Result := False;
  SL := TStringList.Create;
  try
    SL.Clear;
    for I := 0 to Self.Count - 1 do
    begin
      ArqTXT := Self.Items[I].GerarTXT;
      SL.Add(ArqTXT);
    end;

    if SL.Count > 0 then
    begin
      // Inserindo cabeçalho //
      SL.Insert(0, 'NOTA FISCAL|' + IntToStr(Self.Count));

      // Apagando as linhas em branco //
      i := 0;
      while (i <= SL.Count - 1) do
      begin
        if SL[I] = '' then
          SL.Delete(I)
        else
          Inc(i);
      end;

      PathArq := APathNomeArquivo;
      if EstaVazio(PathArq) then
        PathArq := PathWithDelim(
          TACBrNFe(FACBrNFe).Configuracoes.Arquivos.PathSalvar) + 'NFe.TXT';

      SL.SaveToFile(PathArq);
      Result := True;
    end;
  finally
    SL.Free;
  end;
end;

end.
