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

unit ACBrDCeDeclaracoes;

interface

uses
  Classes,
	SysUtils, 
	StrUtils,
  ACBrDCeConfiguracoes,
  ACBrDCe.Classes,
	ACBrDCe.XmlReader,
	ACBrDCe.XmlWriter,
	pcnConversao;

type

  { TDeclaracao }

  TDeclaracao = class(TCollectionItem)
  private
    FDCe: TDCe;
    FDCeW: TDCeXmlWriter;
    FDCeR: TDCeXmlReader;

    FConfiguracoes: TConfiguracoesDCe;
    FXMLAssinado: String;
    FXMLOriginal: String;
    FAlertas: String;
    FErroValidacao: String;
    FErroValidacaoCompleto: String;
    FErroRegrasdeNegocios: String;
    FNomeArq: String;
    FNomeArqPDF: String;

    function GetConfirmado: Boolean;
    function GetProcessado: Boolean;
    function GetCancelado: Boolean;

    function GetMsg: String;
    function GetNumID: String;
    function GetXMLAssinado: String;
    procedure SetXML(const AValue: String);
    procedure SetXMLOriginal(const AValue: String);
    function ValidarConcatChave: Boolean;
    function CalcularNomeArquivo: String;
    function CalcularPathArquivo: String;
    function GetcStat: Integer;
  public
    constructor Create(Collection2: TCollection); override;
    destructor Destroy; override;
    procedure Imprimir;
    procedure ImprimirPDF;

    procedure Assinar;
    procedure Validar;
    function VerificarAssinatura: Boolean;
    function ValidarRegrasdeNegocios: Boolean;

    function LerXML(const AXML: String): Boolean;
    function LerArqIni(const AIniString: String): Boolean;
    function GerarDCeIni: String;

    function GerarXML: String;
    function GravarXML(const NomeArquivo: String = ''; const PathArquivo: String = ''): Boolean;

    function GravarStream(AStream: TStream): Boolean;

    procedure EnviarEmail(const sPara, sAssunto: String; sMensagem: TStrings = nil;
      EnviaPDF: Boolean = True; sCC: TStrings = nil; Anexos: TStrings = nil;
      sReplyTo: TStrings = nil);

    function CalcularNomeArquivoCompleto(NomeArquivo: String = '';
      PathArquivo: String = ''): String;

    property NomeArq: String read FNomeArq write FNomeArq;
    property NomeArqPDF: String read FNomeArqPDF write FNomeArqPDF;

    property DCe: TDCe read FDCe;

    // Atribuir a "XML", faz o componente transferir os dados lido para as propriedades internas e "XMLAssinado"
    property XML: String         read FXMLOriginal   write SetXML;
    // Atribuir a "XMLOriginal", reflete em XMLAssinado, se existir a tag de assinatura
    property XMLOriginal: String read FXMLOriginal   write SetXMLOriginal;
    property XMLAssinado: String read GetXMLAssinado write FXMLAssinado;

    property Confirmado: Boolean read GetConfirmado;
    property Processado: Boolean read GetProcessado;
    property Cancelado: Boolean  read GetCancelado;
    property cStat: Integer read GetcStat;
    property Msg: String read GetMsg;
    property NumID: String read GetNumID;

    property Alertas: String read FAlertas;
    property ErroValidacao: String read FErroValidacao;
    property ErroValidacaoCompleto: String read FErroValidacaoCompleto;
    property ErroRegrasdeNegocios: String read FErroRegrasdeNegocios;
  end;

  { TDeclaracoes }

  TDeclaracoes = class(TOwnedCollection)
  private
    FACBrDCe: TComponent;
    FConfiguracoes: TConfiguracoesDCe;

    function GetItem(Index: integer): TDeclaracao;
    procedure SetItem(Index: integer; const Value: TDeclaracao);

    procedure VerificarDADCe;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);

    procedure GerarDCe;
    procedure Assinar;
    procedure Validar;
    function VerificarAssinatura(out Erros: String): Boolean;
    function ValidarRegrasdeNegocios(out Erros: String): Boolean;
    procedure Imprimir;
    procedure ImprimirPDF;

    function Add: TDeclaracao;
    function Insert(Index: integer): TDeclaracao;

    property Items[Index: integer]: TDeclaracao read GetItem write SetItem; default;

    function GetNamePath: String; override;
    // Incluido o Parametro AGerarDCe que determina se ap�s carregar os dados do DCe
    // para o componente, ser� gerado ou n�o novamente o XML do DCe.
    function LoadFromFile(const CaminhoArquivo: String; AGerarDCe: Boolean = False): Boolean;
    function LoadFromStream(AStream: TStringStream; AGerarDCe: Boolean = False): Boolean;
    function LoadFromString(const AXMLString: String; AGerarDCe: Boolean = False): Boolean;
    function LoadFromIni(const AIniString: String): Boolean;

    function GerarIni: String;
    function GravarXML(const PathNomeArquivo: String = ''): Boolean;

    property ACBrDCe: TComponent read FACBrDCe;
  end;

implementation

uses
  Dateutils, 
	IniFiles,
  synautil, 
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrUtil.XMLHTML,
  ACBrUtil.FilesIO,
  ACBrUtil.DateTime,
	ACBrXmlBase,
  ACBrXmlDocument,
  ACBrDCe,
	ACBrDFeUtil,
	ACBrDCe.Conversao;

{ Declaracao }

constructor TDeclaracao.Create(Collection2: TCollection);
begin
  inherited Create(Collection2);

  FDCe := TDCe.Create;
  FDCeW := TDCeXmlWriter.Create(FDCe);
  FDCeR := TDCeXmlReader.Create(FDCe);
  FConfiguracoes := TACBrDCe(TDeclaracoes(Collection).ACBrDCe).Configuracoes;

  FDCe.Ide.verProc := 'ACBrDCe';
  FDCe.Ide.modelo := 99;

  with TACBrDCe(TDeclaracoes(Collection).ACBrDCe) do
  begin
    FDCe.infDCe.Versao := VersaoDCeToDbl(Configuracoes.Geral.VersaoDF);
    FDCe.Ide.tpAmb := TACBrTipoAmbiente(Configuracoes.WebServices.Ambiente);
    FDCe.Ide.tpEmis := TACBrTipoEmissao(Configuracoes.Geral.FormaEmissao);
  end;
end;

destructor TDeclaracao.Destroy;
begin
  FDCeW.Free;
  FDCeR.Free;
  FDCe.Free;

  inherited Destroy;
end;

procedure TDeclaracao.Imprimir;
begin
  with TACBrDCe(TDeclaracoes(Collection).ACBrDCe) do
  begin
    if not Assigned(DACE) then
      raise EACBrDCeException.Create('Componente DACE n�o associado.')
    else
      DACE.ImprimirDACE(DCe);
  end;
end;

procedure TDeclaracao.ImprimirPDF;
begin
  with TACBrDCe(TDeclaracoes(Collection).ACBrDCe) do
  begin
    if not Assigned(DACE) then
      raise EACBrDCeException.Create('Componente DACE n�o associado.')
    else
      DACE.ImprimirDACEPDF(DCe);
  end;
end;

procedure TDeclaracao.Assinar;
var
  XMLStr: String;
  XMLUTF8: AnsiString;
  Document: TACBrXmlDocument;
  ANode: TACBrXmlNode;
begin
  with TACBrDCe(TDeclaracoes(Collection).ACBrDCe) do
  begin
    if not Assigned(SSL.AntesDeAssinar) then
      SSL.ValidarCNPJCertificado(DCe.Emit.CNPJCPF);
  end;

  // Gera novamente, para processar propriedades que podem ter sido modificadas
  XMLStr := GerarXML;

  // XML j� deve estar em UTF8, para poder ser assinado //
  XMLUTF8 := ConverteXMLtoUTF8(XMLStr);

  with TACBrDCe(TDeclaracoes(Collection).ACBrDCe) do
  begin
    FXMLAssinado := SSL.Assinar(String(XMLUTF8), 'DCe', 'infDCe');
    // SSL.Assinar() sempre responde em UTF8...
    FXMLOriginal := FXMLAssinado;

    Document := TACBrXmlDocument.Create;
    try
      Document.LoadFromXml(FXMLOriginal);
      ANode := Document.Root;

      LerSignature(ANode.Childrens.FindAnyNs('Signature'), DCe.signature);
    finally
      FreeAndNil(Document);
    end;

    // Gera o QR-Code para adicionar no XML ap�s ter a
    // assinatura, e antes de ser salvo.

    with TACBrDCe(TDeclaracoes(Collection).ACBrDCe) do
    begin
      if DCe.emit.idOutros <> '' then
        DCe.infDCeSupl.qrCode := GetURLQRCode(DCe.Ide.cUF,
          DCe.Ide.tpAmb,
          DCe.ide.tpEmis, DCe.infDCe.ID, DCe.emit.idOutros,
          'O', DCe.infDCe.Versao)
      else
      begin
        if Length(DCe.emit.CNPJCPF) = 14 then
          DCe.infDCeSupl.qrCode := GetURLQRCode(DCe.Ide.cUF,
            DCe.Ide.tpAmb,
            DCe.ide.tpEmis, DCe.infDCe.ID, DCe.emit.CNPJCPF,
            'J', DCe.infDCe.Versao)
        else
          DCe.infDCeSupl.qrCode := GetURLQRCode(DCe.Ide.cUF,
            DCe.Ide.tpAmb,
            DCe.ide.tpEmis, DCe.infDCe.ID, DCe.emit.CNPJCPF,
            'F', DCe.infDCe.Versao);
      end;

      DCe.infDCeSupl.urlChave := GetURLConsulta(DCe.Ide.cUF,
                   DCe.Ide.tpAmb, DCe.infDCe.Versao);

      GerarXML;
    end;

    if Configuracoes.Arquivos.Salvar and
      (not Configuracoes.Arquivos.SalvarApenasDCeProcessados) then
    begin
      if NaoEstaVazio(NomeArq) then
        Gravar(NomeArq, FXMLAssinado)
      else
        Gravar(CalcularNomeArquivoCompleto(), FXMLAssinado);
    end;
  end;
end;

procedure TDeclaracao.Validar;
var
  Erro, AXML: String;
  DCeEhValida: Boolean;
  ALayout: TLayOutDCe;
begin
  AXML := FXMLAssinado;

  if AXML = '' then
    AXML := XMLOriginal;

  with TACBrDCe(TDeclaracoes(Collection).ACBrDCe) do
  begin
    ALayout := LayDCeAutorizacao;

    // Extraindo apenas os dados da DCe (sem DCeProc)
    AXML := ObterDFeXML(AXML, 'DCe', ACBRDCe_NAMESPACE);

    if EstaVazio(AXML) then
    begin
      Erro := ACBrStr('DCe n�o encontrada no XML');
      DCeEhValida := False;
    end
    else
    begin
      DCeEhValida := SSL.Validar(AXML, GerarNomeArqSchema(ALayout, FDCe.infDCe.Versao), Erro);
    end;

    if not DCeEhValida then
    begin
      FErroValidacao := ACBrStr('Falha na valida��o dos dados do Declaracao: ') +
        IntToStr(DCe.Ide.nDC) + sLineBreak + FAlertas ;
      FErroValidacaoCompleto := FErroValidacao + sLineBreak + Erro;

      raise EACBrDCeException.CreateDef(
        IfThen(Configuracoes.Geral.ExibirErroSchema, ErroValidacaoCompleto,
        ErroValidacao));
    end;
  end;
end;

function TDeclaracao.VerificarAssinatura: Boolean;
var
  Erro, AXML: String;
  AssEhValida: Boolean;
begin
  AXML := XMLAssinado;

  with TACBrDCe(TDeclaracoes(Collection).ACBrDCe) do
  begin
    // Extraindo apenas os dados da DCe (sem DCeProc)
    AXML := ObterDFeXML(AXML, 'DCe', ACBRDCe_NAMESPACE);

    if EstaVazio(AXML) then
    begin
      Erro := ACBrStr('DCe n�o encontrada no XML');
      AssEhValida := False;
    end
    else
      AssEhValida := SSL.VerificarAssinatura(AXML, Erro, 'infDCe');

    if not AssEhValida then
    begin
      FErroValidacao := ACBrStr('Falha na valida��o da assinatura do Declaracao: ') +
        IntToStr(DCe.Ide.nDC) + sLineBreak + Erro;
    end;
  end;

  Result := AssEhValida;
end;

function TDeclaracao.ValidarRegrasdeNegocios: Boolean;
var
  Erros{, Log}: String;
  Agora: TDateTime;

  procedure GravaLog(AString: String);
  begin
    //DEBUG
    //Log := Log + FormatDateTime('hh:nn:ss:zzz',Now) + ' - ' + AString + sLineBreak;
  end;


  procedure AdicionaErro(const Erro: String);
  begin
    Erros := Erros + Erro + sLineBreak;
  end;

begin
  Agora := Now;
  GravaLog('Inicio da Valida��o');

  with TACBrDCe(TDeclaracoes(Collection).ACBrDCe) do
  begin
    Erros := '';

    GravaLog('Validar: 897-C�digo do documento: ' + IntToStr(DCe.Ide.nDC));
    if not ValidarCodigoDFe(DCe.Ide.cDC, DCe.Ide.nDC) then
      AdicionaErro('897-Rejei��o: C�digo num�rico em formato inv�lido ');

    GravaLog('Regra: G001 - Validar: 252-Ambiente');
    if (Integer(DCe.Ide.tpAmb) <> Integer(Configuracoes.WebServices.Ambiente)) then
      AdicionaErro('252-Rejei��o: Tipo do ambiente do MDF-e difere do ambiente do Web Service');

    GravaLog('Regra: G002 - Validar 226-UF');
    if copy(IntToStr(DCe.Emit.EnderEmit.cMun), 1, 2) <> IntToStr(Configuracoes.WebServices.UFCodigo) then
      AdicionaErro('226-Rejei��o: C�digo da UF do Emitente diverge da UF autorizadora');

    GravaLog('Regra: G003 - Validar 247-UF');
    if DCe.Emit.EnderEmit.UF <> Configuracoes.WebServices.UF then
      AdicionaErro('247-Rejei��o: Sigla da UF do Emitente difere da UF do Web Service');

    GravaLog('Regra: G004 - Validar: 227-Chave de acesso');
    if not ValidarConcatChave then
      AdicionaErro('227-Rejei��o: Chave de Acesso do Campo Id difere da concatena��o dos campos correspondentes');

    GravaLog('Regra: G005 - Validar: 666-Ano da Chave');
    if Copy(DCe.infDCe.ID, 7, 2) < '12' then
      AdicionaErro('666-Rejei��o: Ano da chave de acesso � inferior a 2012');

    // *************************************************************************
    // No total s�o 93 regras de valida��o, portanto faltam muitas para serem
    // acrescentadas nessa rotina.
  end;

  Result := EstaVazio(Erros);

  if not Result then
  begin
    Erros := ACBrStr('Erro(s) nas Regras de neg�cios do Declaracao: '+
                     IntToStr(DCe.Ide.nDC) + sLineBreak + Erros);
  end;

  GravaLog('Fim da Valida��o. Tempo: ' +
           FormatDateTime('hh:nn:ss:zzz', Now - Agora) + sLineBreak +
           'Erros:' + Erros);

  FErroRegrasdeNegocios := Erros;
end;

function TDeclaracao.LerXML(const AXML: String): Boolean;
begin
  XMLOriginal := AXML;  // SetXMLOriginal() ir� verificar se AXML est� em UTF8

  FDCeR.Arquivo := XMLOriginal;
  FDCeR.LerXml;

  Result := True;
end;

function TDeclaracao.GravarXML(const NomeArquivo: String; const PathArquivo: String): Boolean;
begin
  if EstaVazio(FXMLOriginal) then
    GerarXML;

  FNomeArq := CalcularNomeArquivoCompleto(NomeArquivo, PathArquivo);

  Result := TACBrDCe(TDeclaracoes(Collection).ACBrDCe).Gravar(FNomeArq, FXMLOriginal);
end;

function TDeclaracao.GravarStream(AStream: TStream): Boolean;
begin
  if EstaVazio(FXMLOriginal) then
    GerarXML;

  AStream.Size := 0;
  WriteStrToStream(AStream, AnsiString(FXMLOriginal));
  Result := True;
end;

procedure TDeclaracao.EnviarEmail(const sPara, sAssunto: String; sMensagem: TStrings;
  EnviaPDF: Boolean; sCC: TStrings; Anexos: TStrings; sReplyTo: TStrings);
var
  NomeArqTemp : String;
  AnexosEmail:TStrings;
  StreamDCe : TMemoryStream;
begin
  if not Assigned(TACBrDCe(TDeclaracoes(Collection).ACBrDCe).MAIL) then
    raise EACBrDCeException.Create('Componente ACBrMail n�o associado');

  AnexosEmail := TStringList.Create;
  StreamDCe := TMemoryStream.Create;
  try
    AnexosEmail.Clear;
    if Assigned(Anexos) then
      AnexosEmail.Assign(Anexos);

    with TACBrDCe(TDeclaracoes(Collection).ACBrDCe) do
    begin
      Self.GravarStream(StreamDCe);

      if (EnviaPDF) then
      begin
        if Assigned(DACE) then
        begin
          DACE.ImprimirDACEPDF(FDCe);
          NomeArqTemp := PathWithDelim(DACE.PathPDF) + NumID + '-DCe.pdf';
          AnexosEmail.Add(NomeArqTemp);
        end;
      end;

      EnviarEmail( sPara, sAssunto, sMensagem, sCC, AnexosEmail, StreamDCe,
                   NumID + '-DCe.xml', sReplyTo);
    end;
  finally
    AnexosEmail.Free;
    StreamDCe.Free;
  end;
end;

function TDeclaracao.GerarDCeIni: String;
var
  INIRec: TMemIniFile;
  sSecao: string;
  i: Integer;
  IniDFe: TStringList;
begin
  Result := '';

  if not ValidarChave(DCe.infDCe.ID) then
    raise EACBrDCeException.Create('DCe Inconsistente para gerar INI. Chave Inv�lida.');

  INIRec := TMemIniFile.Create('');
  try
    with FDCe do
    begin
      INIRec.WriteString('infDCe', 'ID', infDCe.ID);
      INIRec.WriteString('infDCe', 'Versao', FloatToStr(infDCe.Versao));

      sSecao := 'ide';
      INIRec.WriteInteger(sSecao, 'cUF', Ide.cUF);
      INIRec.WriteInteger(sSecao, 'cDC', Ide.cDC);
      INIRec.WriteInteger(sSecao, 'Modelo', Ide.modelo);
      INIRec.WriteInteger(sSecao, 'Serie', Ide.serie);
      INIRec.WriteInteger(sSecao, 'nDC', Ide.nDC);
      INIRec.WriteString(sSecao, 'dhEmi', DateTimeToStr(Ide.dhEmi));
      INIRec.WriteString(sSecao, 'tpEmis', TipoEmissaoToStr(Ide.tpEmis));
      INIRec.WriteString(sSecao, 'tpEmit', EmitenteDCeToStr(Ide.tpEmit));
      INIRec.WriteString(sSecao, 'nSiteAutoriz', SiteAutorizadorToStr(Ide.nSiteAutoriz));
      INIRec.WriteString(sSecao, 'tpAmb', TipoAmbienteToStr(Ide.tpAmb));
      INIRec.WriteString(sSecao, 'verProc', Ide.verProc);

      sSecao := 'emit';
      INIRec.WriteString(sSecao, 'CNPJCPF', Emit.CNPJCPF);
      INIRec.WriteString(sSecao, 'idOutros', Emit.idOutros);
      INIRec.WriteString(sSecao, 'xNome', Emit.xNome);
      // Endere�o do Emitente
      INIRec.WriteString(sSecao, 'xLgr', Emit.EnderEmit.xLgr);
      INIRec.WriteString(sSecao, 'nro', Emit.EnderEmit.nro);
      INIRec.WriteString(sSecao, 'xCpl', Emit.EnderEmit.xCpl);
      INIRec.WriteString(sSecao, 'xBairro', Emit.EnderEmit.xBairro);
      INIRec.WriteInteger(sSecao, 'cMun', Emit.EnderEmit.cMun);
      INIRec.WriteString(sSecao, 'xMun', Emit.EnderEmit.xMun);
      INIRec.WriteInteger(sSecao, 'CEP', Emit.EnderEmit.CEP);
      INIRec.WriteString(sSecao, 'UF', Emit.EnderEmit.UF);
      INIRec.WriteString(sSecao, 'fone', Emit.EnderEmit.fone);
      INIRec.WriteString(sSecao, 'email', Emit.EnderEmit.email);

      if Fisco.CNPJ <> '' then
      begin
        sSecao := 'Fisco';
        INIRec.WriteString(sSecao, 'CNPJ', Fisco.CNPJ);
        INIRec.WriteString(sSecao, 'xOrgao', Fisco.xOrgao);
        INIRec.WriteString(sSecao, 'UF', Fisco.UF);
      end;

      if Marketplace.CNPJ <> '' then
      begin
        sSecao := 'Marketplace';
        INIRec.WriteString(sSecao, 'CNPJ', Marketplace.CNPJ);
        INIRec.WriteString(sSecao, 'xNome', Marketplace.xNome);
        INIRec.WriteString(sSecao, 'Site', Marketplace.Site);
      end;

      if Transportadora.CNPJ <> '' then
      begin
        sSecao := 'Transportadora';
        INIRec.WriteString(sSecao, 'CNPJ', Transportadora.CNPJ);
        INIRec.WriteString(sSecao, 'xNome', Transportadora.xNome);
      end;

      if ECT.CNPJ <> '' then
      begin
        sSecao := 'ECT';
        INIRec.WriteString(sSecao, 'CNPJ', ECT.CNPJ);
        INIRec.WriteString(sSecao, 'xNome', ECT.xNome);
      end;

      sSecao := 'dest';
      INIRec.WriteString(sSecao, 'CNPJCPF', Dest.CNPJCPF);
      INIRec.WriteString(sSecao, 'idOutros', Dest.idOutros);
      INIRec.WriteString(sSecao, 'xNome', Dest.xNome);
      // Endere�o do Destinatario
      INIRec.WriteString(sSecao, 'xLgr', Dest.EnderDest.xLgr);
      INIRec.WriteString(sSecao, 'nro', Dest.EnderDest.nro);
      INIRec.WriteString(sSecao, 'xCpl', Dest.EnderDest.xCpl);
      INIRec.WriteString(sSecao, 'xBairro', Dest.EnderDest.xBairro);
      INIRec.WriteInteger(sSecao, 'cMun', Dest.EnderDest.cMun);
      INIRec.WriteString(sSecao, 'xMun', Dest.EnderDest.xMun);
      INIRec.WriteInteger(sSecao, 'CEP', Dest.EnderDest.CEP);
      INIRec.WriteString(sSecao, 'UF', Dest.EnderDest.UF);
      INIRec.WriteString(sSecao, 'fone', Dest.EnderDest.fone);
      INIRec.WriteString(sSecao, 'email', Dest.EnderDest.email);

      for i := 0 to autXML.Count - 1 do
      begin
        sSecao := 'autXML' + IntToStrZero(I + 1, 2);
        with autXML[i] do
        begin
          INIRec.WriteString(sSecao, 'CNPJCPF', CNPJCPF);
        end;
      end;

      for i := 0 to det.Count - 1 do
      begin
        sSecao := 'Prod' + IntToStrZero(I + 1, 3);
        with det[i] do
        begin
          INIRec.WriteString(sSecao, 'xProd', Prod.xProd);
          INIRec.WriteString(sSecao, 'NCM', Prod.NCM);
          INIRec.WriteFloat(sSecao, 'qCom', Prod.qCom);
          INIRec.WriteFloat(sSecao, 'vUnCom', Prod.vUnCom);
          INIRec.WriteFloat(sSecao, 'vProd', Prod.vProd);
          INIRec.WriteString(sSecao, 'infAdProd', infAdProd);
        end;
      end;

      sSecao := 'total';
      INIRec.WriteFloat(sSecao, 'vDC', total.vDC);

      sSecao := 'transp';
      INIRec.WriteString(sSecao, 'modTrans', ModTransToStr(transp.modTrans));
      INIRec.WriteString(sSecao, 'CNPJTransp', transp.CNPJTransp);

      sSecao := 'infAdic';
      INIRec.WriteString(sSecao, 'infAdFisco', infAdic.infAdFisco);
      INIRec.WriteString(sSecao, 'infCpl', infAdic.infCpl);
      INIRec.WriteString(sSecao, 'infAdMarketplace', infAdic.infAdMarketplace);
      INIRec.WriteString(sSecao, 'infAdTransp', infAdic.infAdTransp);
      INIRec.WriteString(sSecao, 'infAdECT', infAdic.infAdECT);

      for i := 0 to obsFisco.Count - 1 do
      begin
        sSecao := 'obsFisco' + IntToStrZero(I + 1, 2);
        with obsFisco[i] do
        begin
          INIRec.WriteString(sSecao, 'xCampo', xCampo);
          INIRec.WriteString(sSecao, 'xTexto', xTexto);
        end;
      end;

      for i := 0 to obsMarketplace.Count - 1 do
      begin
        sSecao := 'obsMarketplace' + IntToStrZero(I + 1, 2);
        with obsMarketplace[i] do
        begin
          INIRec.WriteString(sSecao, 'xCampo', xCampo);
          INIRec.WriteString(sSecao, 'xTexto', xTexto);
        end;
      end;

      for i := 0 to obsEmit.Count - 1 do
      begin
        sSecao := 'obsEmit' + IntToStrZero(I + 1, 2);
        with obsEmit[i] do
        begin
          INIRec.WriteString(sSecao, 'xCampo', xCampo);
          INIRec.WriteString(sSecao, 'xTexto', xTexto);
        end;
      end;

      for i := 0 to obsECT.Count - 1 do
      begin
        sSecao := 'obsECT' + IntToStrZero(I + 1, 2);
        with obsECT[i] do
        begin
          INIRec.WriteString(sSecao, 'xCampo', xCampo);
          INIRec.WriteString(sSecao, 'xTexto', xTexto);
        end;
      end;
    end;

    IniDFe := TStringList.Create;
    try
      INIRec.GetStrings(IniDFe);
      Result := StringReplace(IniDFe.Text, sLineBreak + sLineBreak, sLineBreak, [rfReplaceAll]);
    finally
      IniDFe.Free;
    end;
  finally
    INIRec.Free;
  end;
end;

function TDeclaracao.GerarXML: String;
var
  IdAnterior : String;
begin
  with TACBrDCe(TDeclaracoes(Collection).ACBrDCe) do
  begin
    IdAnterior := DCe.infDCe.ID;

    FDCeW.Opcoes.FormatoAlerta  := Configuracoes.Geral.FormatoAlerta;
    FDCeW.Opcoes.RetirarAcentos := Configuracoes.Geral.RetirarAcentos;
    FDCeW.Opcoes.RetirarEspacos := Configuracoes.Geral.RetirarEspacos;
    FDCeW.Opcoes.IdentarXML := Configuracoes.Geral.IdentarXML;
    FDCeW.Opcoes.NormatizarMunicipios  := Configuracoes.Arquivos.NormatizarMunicipios;
    FDCeW.Opcoes.PathArquivoMunicipios := Configuracoes.Arquivos.PathArquivoMunicipios;

    TimeZoneConf.Assign( Configuracoes.WebServices.TimeZoneConf );

    FDCeW.ModeloDF := 99;
    FDCeW.VersaoDF := Configuracoes.Geral.VersaoDF;
    FDCeW.tpAmb := TACBrTipoAmbiente(Configuracoes.WebServices.Ambiente);
//    FDCeW.tpEmis := TACBrTipoEmissao(Integer(Configuracoes.Geral.FormaEmissao));
  end;

  FDCeW.GerarXml;

  XMLOriginal := FDCeW.Document.Xml;  // SetXMLOriginal() ir� converter para UTF8

  { XML gerado pode ter nova Chave e ID, ent�o devemos calcular novamente o
    nome do arquivo, mantendo o PATH do arquivo carregado }
  if (NaoEstaVazio(FNomeArq) and (IdAnterior <> FDCe.infDCe.ID)) then
    FNomeArq := CalcularNomeArquivoCompleto('', ExtractFilePath(FNomeArq));

  FAlertas := ACBrStr( FDCeW.ListaDeAlertas.Text );
  Result := FXMLOriginal;
end;

function TDeclaracao.CalcularNomeArquivo: String;
var
  xID: String;
begin
  xID := Self.NumID;

  if EstaVazio(xID) then
    raise EACBrDCeException.Create('ID Inv�lido. Imposs�vel Salvar XML');

  Result := xID + '-DCe.xml';
end;

function TDeclaracao.CalcularPathArquivo: String;
var
  Data: TDateTime;
begin
  with TACBrDCe(TDeclaracoes(Collection).ACBrDCe) do
  begin
    if Configuracoes.Arquivos.EmissaoPathDCe then
      Data := FDCe.Ide.dhEmi
    else
      Data := Now;

    Result := PathWithDelim(Configuracoes.Arquivos.GetPathDCe(Data, FDCe.Emit.CNPJCPF, ''));
  end;
end;

function TDeclaracao.CalcularNomeArquivoCompleto(NomeArquivo: String;
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

function TDeclaracao.ValidarConcatChave: Boolean;
var
  wAno, wMes, wDia: word;
begin
  DecodeDate(DCe.ide.dhEmi, wAno, wMes, wDia);

  Result := not
    ((Copy(DCe.infDCe.ID, 5, 2) <> IntToStrZero(DCe.Ide.cUF, 2)) or
    (Copy(DCe.infDCe.ID, 7, 2)  <> Copy(FormatFloat('0000', wAno), 3, 2)) or
    (Copy(DCe.infDCe.ID, 9, 2)  <> FormatFloat('00', wMes)) or
    (Copy(DCe.infDCe.ID, 11, 14)<> PadLeft(OnlyNumber(DCe.Emit.CNPJCPF), 14, '0')) or
    (Copy(DCe.infDCe.ID, 25, 2) <> IntToStr(DCe.Ide.modelo)) or
    (Copy(DCe.infDCe.ID, 27, 3) <> IntToStrZero(DCe.Ide.serie, 3)) or
    (Copy(DCe.infDCe.ID, 30, 9) <> IntToStrZero(DCe.Ide.nDC, 9)) or
    (Copy(DCe.infDCe.ID, 39, 1) <> IntToStr(Integer(DCe.Ide.tpEmis))) or
    (Copy(DCe.infDCe.ID, 40, 8) <> IntToStrZero(DCe.Ide.cDC, 8)));
end;

function TDeclaracao.GetConfirmado: Boolean;
begin
  Result := TACBrDCe(TDeclaracoes(Collection).ACBrDCe).cStatConfirmado(
    FDCe.procDCe.cStat);
end;

function TDeclaracao.GetcStat: Integer;
begin
  Result := FDCe.procDCe.cStat;
end;

function TDeclaracao.GetProcessado: Boolean;
begin
  Result := TACBrDCe(TDeclaracoes(Collection).ACBrDCe).cStatProcessado(
    FDCe.procDCe.cStat);
end;

function TDeclaracao.GetCancelado: Boolean;
begin
  Result := TACBrDCe(TDeclaracoes(Collection).ACBrDCe).cStatCancelado(
    FDCe.procDCe.cStat);
end;

function TDeclaracao.GetMsg: String;
begin
  Result := FDCe.procDCe.xMotivo;
end;

function TDeclaracao.GetNumID: String;
begin
  Result := Trim(OnlyNumber(DCe.infDCe.ID));
end;

function TDeclaracao.GetXMLAssinado: String;
begin
  if EstaVazio(FXMLAssinado) then
    Assinar;

  Result := FXMLAssinado;
end;

procedure TDeclaracao.SetXML(const AValue: String);
begin
  LerXML(AValue);
end;

procedure TDeclaracao.SetXMLOriginal(const AValue: String);
var
  XMLUTF8: String;
begin
  { Garante que o XML informado est� em UTF8, se ele realmente estiver, nada
    ser� modificado por "ConverteXMLtoUTF8"  (mantendo-o "original") }
  XMLUTF8 := ConverteXMLtoUTF8(AValue);

  FXMLOriginal := XMLUTF8;

  if XmlEstaAssinado(FXMLOriginal) then
    FXMLAssinado := FXMLOriginal
  else
    FXMLAssinado := '';
end;

function TDeclaracao.LerArqIni(const AIniString: String): Boolean;
var
  INIRec : TMemIniFile;
  OK: boolean;
  sSecao, sFim: string;
  I: Integer;
begin
  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    with FDCe do
    begin
      OK := True;

      infDCe.versao := StringToFloatDef(INIRec.ReadString('infDCe', 'versao', VersaoDCeToStr(FConfiguracoes.Geral.VersaoDF)), 0);

      sSecao := 'ide';
      Ide.tpAmb := StrToTipoAmbiente(OK, INIRec.ReadString(sSecao, 'tpAmb', IntToStr(Integer(FConfiguracoes.WebServices.Ambiente))));
      Ide.modelo := INIRec.ReadInteger(sSecao, 'Modelo', 99);
      Ide.serie := INIRec.ReadInteger(sSecao, 'Serie', 1);
      Ide.nDC := INIRec.ReadInteger(sSecao, 'nDC', 0);
      Ide.cDC := INIRec.ReadInteger(sSecao, 'cDC', 0);
      Ide.dhEmi := StringToDateTime(INIRec.ReadString(sSecao, 'dhEmi', '0'));
      Ide.tpEmis := StrToTipoEmissao(OK, INIRec.ReadString(sSecao, 'tpEmis', IntToStr(FConfiguracoes.Geral.FormaEmissaoCodigo)));
      Ide.tpEmit  := StrToEmitenteDCe(INIRec.ReadString(sSecao, 'tpEmit', '1'));
      Ide.nSiteAutoriz := StrToSiteAutorizator(INIRec.ReadString(sSecao, 'nSiteAutoriz', '0'));
      Ide.verProc := INIRec.ReadString(sSecao, 'verProc', 'ACBrNFCom');

      sSecao := 'emit';
      Emit.CNPJCPF := INIRec.ReadString(sSecao, 'CNPJCPF', '');
      Emit.idOutros := INIRec.ReadString(sSecao, 'idOutros', '');
      Emit.xNome := INIRec.ReadString(sSecao, 'xNome', '');
      // Endere�o do Emitente
      Emit.EnderEmit.xLgr := INIRec.ReadString(sSecao, 'xLgr', '');
      Emit.EnderEmit.nro := INIRec.ReadString(sSecao, 'nro', '');
      Emit.EnderEmit.xCpl := INIRec.ReadString(sSecao, 'xCpl', '');
      Emit.EnderEmit.xBairro := INIRec.ReadString(sSecao, 'xBairro', '');
      Emit.EnderEmit.cMun := INIRec.ReadInteger(sSecao, 'cMun', 0);
      Emit.EnderEmit.xMun := INIRec.ReadString(sSecao, 'xMun', '');
      Emit.EnderEmit.CEP := INIRec.ReadInteger(sSecao, 'CEP', 0);
      Emit.EnderEmit.UF := INIRec.ReadString(sSecao, 'UF', '');
      Emit.EnderEmit.fone := INIRec.ReadString(sSecao, 'fone', '');
      Emit.EnderEmit.email := INIRec.ReadString(sSecao, 'email', '');

      Ide.cUF := INIRec.ReadInteger(sSecao, 'cUF', UFparaCodigoUF(Emit.EnderEmit.UF));

      sSecao := 'Fisco';
      Fisco.CNPJ := INIRec.ReadString(sSecao, 'CNPJ', '');
      Fisco.xOrgao := INIRec.ReadString(sSecao, 'xOrgao', '');
      Fisco.UF := INIRec.ReadString(sSecao, 'UF', '');

      sSecao := 'Marketplace';
      Marketplace.CNPJ := INIRec.ReadString(sSecao, 'CNPJ', '');
      Marketplace.xNome := INIRec.ReadString(sSecao, 'xNome', '');
      Marketplace.Site := INIRec.ReadString(sSecao, 'Site', '');

      sSecao := 'Transportadora';
      Transportadora.CNPJ := INIRec.ReadString(sSecao, 'CNPJ', '');
      Transportadora.xNome := INIRec.ReadString(sSecao, 'xNome', '');

      sSecao := 'ECT';
      ECT.CNPJ := INIRec.ReadString(sSecao, 'CNPJ', '');
      ECT.xNome := INIRec.ReadString(sSecao, 'xNome', '');

      sSecao := 'dest';
      Dest.xNome := INIRec.ReadString(sSecao, 'xNome', '');
      Dest.CNPJCPF := INIRec.ReadString(sSecao, 'CNPJCPF', '');
      Dest.idOutros := INIRec.ReadString(sSecao, 'idOutros','');
      // Endere�o do Destinatario
      Dest.EnderDest.xLgr := INIRec.ReadString(sSecao, 'xLgr', '');
      Dest.EnderDest.nro := INIRec.ReadString(sSecao, 'nro', '');
      Dest.EnderDest.xCpl := INIRec.ReadString(sSecao, 'xCpl', '');
      Dest.EnderDest.xBairro := INIRec.ReadString(sSecao, 'xBairro', '');
      Dest.EnderDest.cMun := INIRec.ReadInteger(sSecao, 'cMun', 0);
      Dest.EnderDest.xMun := INIRec.ReadString(sSecao, 'xMun', '');
      Dest.EnderDest.CEP := INIRec.ReadInteger(sSecao, 'CEP', 0);
      Dest.EnderDest.UF := INIRec.ReadString(sSecao, 'UF', '');
      Dest.EnderDest.fone := INIRec.ReadString(sSecao, 'fone', '');
      Dest.EnderDest.email := INIRec.ReadString(sSecao, 'email', '');

      I := 1;
      while true do
      begin
        sSecao := 'autXML' + IntToStrZero(I, 2);
        sFim   := INIRec.ReadString(sSecao, 'CNPJCPF', 'FIM');
        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        with autXML.New do
        begin
          CNPJCPF := sFim;
        end;

        Inc(I);
      end;

      I := 1;
      while true do
      begin
        sSecao := 'prod' + IntToStrZero(I, 3);
        sFim   := INIRec.ReadString(sSecao, 'xProd', 'FIM');
        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        with det.New do
        begin
          Prod.nItem :=  I;
          Prod.xProd := sFim;

          Prod.NCM := INIRec.ReadString(sSecao, 'NCM', '');
          Prod.qCom := StringToFloatDef(INIRec.ReadString(sSecao, 'qCom', ''), 0);
          Prod.vUnCom := StringToFloatDef(INIRec.ReadString(sSecao, 'vUnCom', ''), 0);
          Prod.vProd := StringToFloatDef(INIRec.ReadString(sSecao, 'vProd', ''), 0);

          infAdProd := INIRec.ReadString(sSecao, 'infAdProd', '');
        end;

        Inc(I);
      end;

      sSecao := 'total';
      total.vDC := StringToFloatDef(INIRec.ReadString(sSecao, 'vDC', ''), 0);

      sSecao := 'transp';
      transp.modTrans := StrToModTrans(INIRec.ReadString(sSecao, 'modTrans', '0'));
      transp.CNPJTransp := INIRec.ReadString(sSecao, 'CNPJTransp', '');

      sSecao := 'infAdic';
      infAdic.infAdFisco := INIRec.ReadString(sSecao, 'infAdFisco', '');
      infAdic.infCpl := INIRec.ReadString(sSecao, 'infCpl', '');
      infAdic.infAdMarketplace := INIRec.ReadString(sSecao, 'infAdMarketplace', '');
      infAdic.infAdTransp := INIRec.ReadString(sSecao, 'infAdTransp', '');
      infAdic.infAdECT := INIRec.ReadString(sSecao, 'infAdECT', '');

      I := 1;
      while true do
      begin
        sSecao := 'obsFisco' + IntToStrZero(I, 2);
        sFim   := INIRec.ReadString(sSecao, 'xCampo', 'FIM');
        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        with obsFisco.New do
        begin
          xCampo := sFim;
          xTexto := INIRec.ReadString(sSecao, 'xTexto', '');
        end;

        Inc(I);
      end;

      I := 1;
      while true do
      begin
        sSecao := 'obsMarketplace' + IntToStrZero(I, 2);
        sFim   := INIRec.ReadString(sSecao, 'xCampo', 'FIM');
        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        with obsMarketplace.New do
        begin
          xCampo := sFim;
          xTexto := INIRec.ReadString(sSecao, 'xTexto', '');
        end;

        Inc(I);
      end;

      I := 1;
      while true do
      begin
        sSecao := 'obsEmit' + IntToStrZero(I, 2);
        sFim   := INIRec.ReadString(sSecao, 'xCampo', 'FIM');
        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        with obsEmit.New do
        begin
          xCampo := sFim;
          xTexto := INIRec.ReadString(sSecao, 'xTexto', '');
        end;

        Inc(I);
      end;

      I := 1;
      while true do
      begin
        sSecao := 'obsECT' + IntToStrZero(I, 2);
        sFim   := INIRec.ReadString(sSecao, 'xCampo', 'FIM');
        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        with obsECT.New do
        begin
          xCampo := sFim;
          xTexto := INIRec.ReadString(sSecao, 'xTexto', '');
        end;

        Inc(I);
      end;
    end;

    GerarXML;

    Result := True;
  finally
    INIRec.Free;
  end;
end;

{ TDeclaracoes }

constructor TDeclaracoes.Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
begin
  if not (AOwner is TACBrDCe) then
    raise EACBrDCeException.Create('AOwner deve ser do tipo TACBrDCe');

  inherited Create(AOwner, ItemClass);

  FACBrDCe := TACBrDCe(AOwner);
  FConfiguracoes := TACBrDCe(FACBrDCe).Configuracoes;
end;

function TDeclaracoes.Add: TDeclaracao;
begin
  Result := TDeclaracao(inherited Add);
end;

procedure TDeclaracoes.Assinar;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].Assinar;
end;

function TDeclaracoes.GerarIni: String;
begin
  Result := '';
  if (Self.Count > 0) then
    Result := Self.Items[0].GerarDCeIni;
end;

procedure TDeclaracoes.GerarDCe;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].GerarXML;
end;

function TDeclaracoes.GetItem(Index: integer): TDeclaracao;
begin
  Result := TDeclaracao(inherited Items[Index]);
end;

function TDeclaracoes.GetNamePath: String;
begin
  Result := 'Declaracao';
end;

procedure TDeclaracoes.VerificarDADCe;
begin
  if not Assigned(TACBrDCe(FACBrDCe).DACE) then
    raise EACBrDCeException.Create('Componente DACE n�o associado.');
end;

procedure TDeclaracoes.Imprimir;
begin
  VerificarDADCe;
  TACBrDCe(FACBrDCe).DACE.ImprimirDACE(nil);
end;

procedure TDeclaracoes.ImprimirPDF;
begin
  VerificarDADCe;
  TACBrDCe(FACBrDCe).DACE.ImprimirDACEPDF;
end;

function TDeclaracoes.Insert(Index: integer): TDeclaracao;
begin
  Result := TDeclaracao(inherited Insert(Index));
end;

procedure TDeclaracoes.SetItem(Index: integer; const Value: TDeclaracao);
begin
  Items[Index].Assign(Value);
end;

procedure TDeclaracoes.Validar;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].Validar;   // Dispara exception em caso de erro
end;

function TDeclaracoes.VerificarAssinatura(out Erros: String): Boolean;
var
  i: integer;
begin
  Result := True;
  Erros := '';

  if Self.Count < 1 then
  begin
    Erros := 'Nenhum DCe carregado';
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

function TDeclaracoes.ValidarRegrasdeNegocios(out Erros: String): Boolean;
var
  i: integer;
begin
  Result := True;
  Erros := '';

  for i := 0 to Self.Count - 1 do
  begin
    if not Self.Items[i].ValidarRegrasdeNegocios then
    begin
      Result := False;
      Erros := Erros + Self.Items[i].ErroRegrasdeNegocios + sLineBreak;
    end;
  end;
end;

function TDeclaracoes.LoadFromFile(const CaminhoArquivo: String;
  AGerarDCe: Boolean): Boolean;
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

  l := Self.Count; // Indice do �ltimo Declaracao j� existente
  Result := LoadFromString(String(XMLUTF8), AGerarDCe);

  if Result then
  begin
    // Atribui Nome do arquivo a novos Declaracoes inseridos //
    for i := l to Self.Count - 1 do
      Self.Items[i].NomeArq := CaminhoArquivo;
  end;
end;

function TDeclaracoes.LoadFromStream(AStream: TStringStream;
  AGerarDCe: Boolean): Boolean;
var
  AXML: AnsiString;
begin
  AStream.Position := 0;
  AXML := ReadStrFromStream(AStream, AStream.Size);

  Result := Self.LoadFromString(String(AXML), AGerarDCe);
end;

function TDeclaracoes.LoadFromString(const AXMLString: String;
  AGerarDCe: Boolean): Boolean;
var
  ADCeXML, XMLStr: AnsiString;
  P, N: integer;

  function PosDCe: integer;
  begin
    Result := pos('</DCe>', XMLStr);
  end;

begin
  // Verifica se precisa Converter de UTF8 para a String nativa da IDE //
  XMLStr := ConverteXMLtoNativeString(AXMLString);

  N := PosDCe;
  while N > 0 do
  begin
    P := pos('</dceProc>', XMLStr);

    if P <= 0 then
      P := pos('</procDCe>', XMLStr);  // DCe obtido pelo Portal da Receita

    if P > 0 then
    begin
      ADCeXML := copy(XMLStr, 1, P + 11);
      XMLStr := Trim(copy(XMLStr, P + 11, length(XMLStr)));
    end
    else
    begin
      ADCeXML := copy(XMLStr, 1, N + 7);
      XMLStr := Trim(copy(XMLStr, N + 7, length(XMLStr)));
    end;

    with Self.Add do
    begin
      LerXML(ADCeXML);

      if AGerarDCe then // Recalcula o XML
        GerarXML;
    end;

    N := PosDCe;
  end;

  Result := Self.Count > 0;
end;

function TDeclaracoes.LoadFromIni(const AIniString: String): Boolean;
begin
  with Self.Add do
    LerArqIni(AIniString);

  Result := Self.Count > 0;
end;

function TDeclaracoes.GravarXML(const PathNomeArquivo: String): Boolean;
var
  i: integer;
  NomeArq, PathArq : String;
begin
  Result := True;
  i := 0;
  while Result and (i < Self.Count) do
  begin
    PathArq := ExtractFilePath(PathNomeArquivo);
    NomeArq := ExtractFileName(PathNomeArquivo);
    Result := Self.Items[i].GravarXML(NomeArq, PathArq);
    Inc(i);
  end;
end;

end.
