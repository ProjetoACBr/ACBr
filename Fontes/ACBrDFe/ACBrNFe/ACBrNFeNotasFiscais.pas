{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Wemerson Souto                                  }
{                              Andr� Ferreira de Moraes                        }
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

unit ACBrNFeNotasFiscais;

interface

uses
  Classes, SysUtils, StrUtils,
  ACBrNFeConfiguracoes, ACBrNFe.Classes,
  {$IfDef USE_ACBr_XMLDOCUMENT}
    ACBrNFe.XmlReader, ACBrNFe.XmlWriter,
  {$Else}
    pcnNFeR, pcnNFeW,
  {$EndIf}
  ACBrNFe.IniReader, ACBrNFe.IniWriter,
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

    function GerarXML: String;
    function GravarXML(const NomeArquivo: String = ''; const PathArquivo: String = ''): Boolean;

    function GerarTXT: String;
    function GravarTXT(const NomeArquivo: String = ''; const PathArquivo: String = ''): Boolean;

    function GravarStream(AStream: TStream): Boolean;

    procedure EnviarEmail(const sPara, sAssunto: String; sMensagem: TStrings = nil;
      EnviaPDF: Boolean = True; sCC: TStrings = nil; Anexos: TStrings = nil;
      sReplyTo: TStrings = nil);

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
    // Incluido o Parametro AGerarNFe que determina se ap�s carregar os dados da NFe
    // para o componente, ser� gerado ou n�o novamente o XML da NFe.
    function LoadFromFile(const CaminhoArquivo: String; AGerarNFe: Boolean = False): Boolean;
    function LoadFromStream(AStream: TStringStream; AGerarNFe: Boolean = False): Boolean;
    function LoadFromString(const AXMLString: String; AGerarNFe: Boolean = False): Boolean;
    function LoadFromIni(const AIniString: String): Boolean;

    function GerarIni: String;
    function GravarXML(const APathNomeArquivo: String = ''): Boolean;
    function GravarTXT(const APathNomeArquivo: String = ''): Boolean;

    property ACBrNFe: TComponent read FACBrNFe;
  end;

implementation

uses
  dateutils, IniFiles,
  synautil,
  ACBrNFe,
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.XMLHTML, ACBrUtil.FilesIO,
  ACBrUtil.DateTime, ACBrUtil.Math,
  ACBrDFeUtil, pcnConversaoNFe;

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

  FNFe.Free;

  inherited Destroy;
end;

procedure NotaFiscal.Imprimir;
begin
  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    if not Assigned(DANFE) then
      raise EACBrNFeException.Create('Componente DA'+ModeloDFToPrefixo(Configuracoes.Geral.ModeloDF)+' n�o associado.')
    else
      DANFE.ImprimirDANFE(NFe);
  end;
end;

procedure NotaFiscal.ImprimirPDF;
begin
  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    if not Assigned(DANFE) then
      raise EACBrNFeException.Create('Componente DA'+ModeloDFToPrefixo(Configuracoes.Geral.ModeloDF)+' n�o associado.')
    else
      DANFE.ImprimirDANFEPDF(NFe);
  end;
end;

function NotaFiscal.ImprimirPDF(AStream: TStream): Boolean;
begin
  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    if not Assigned(DANFE) then
      raise EACBrNFeException.Create('Componente DA'+ModeloDFToPrefixo(Configuracoes.Geral.ModeloDF)+' n�o associado.')
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
  XMLStr: String;
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

  // XML j� deve estar em UTF8, para poder ser assinado //
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

    // Se for NFCe, deve gera o QR-Code para adicionar no XML ap�s ter a
    // assinatura, e antes de ser salvo.
    // Homologa��o: 01/10/2015
    // Produ��o: 03/11/2015

    if (NFe.Ide.modelo = 65) then
    begin
      with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
      begin
        NFe.infNFeSupl.qrCode := GetURLQRCode(NFe.Ide.cUF, NFe.Ide.tpAmb,
                                  onlyNumber(NFe.infNFe.ID),
                                  trim(IfThen(NFe.Dest.idEstrangeiro <> '', NFe.Dest.idEstrangeiro, OnlyNumber(NFe.Dest.CNPJCPF))),
                                  NFe.Ide.dEmi, NFe.Total.ICMSTot.vNF,
                                  NFe.Total.ICMSTot.vICMS, NFe.signature.DigestValue,
                                  NFe.infNFe.Versao);

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
      Erro := ACBrStr('NFe n�o encontrada no XML');
      NotaEhValida := False;
    end
    else
      NotaEhValida := SSL.Validar(AXML, GerarNomeArqSchema(ALayout, VerServ), Erro);

    if not NotaEhValida then
    begin
      FErroValidacao := ACBrStr('Falha na valida��o dos dados da nota: ') +
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
      Erro := ACBrStr('NFe n�o encontrada no XML');
      AssEhValida := False;
    end
    else
      AssEhValida := SSL.VerificarAssinatura(AXML, Erro, 'infNFe');

    if not AssEhValida then
    begin
      FErroValidacao := ACBrStr('Falha na valida��o da assinatura da nota: ') +
        IntToStr(NFe.Ide.nNF) + sLineBreak + Erro;
    end;
  end;

  Result := AssEhValida;
end;

function NotaFiscal.ValidarRegrasdeNegocios: Boolean;
const
  SEM_GTIN = 'SEM GTIN';
var
  Erros: String;
  I, J, CodigoUF: Integer;
  Inicio, Agora, UltVencto: TDateTime;
  fsvTotTrib, fsvBC, fsvICMS, fsvICMSDeson, fsvBCST, fsvST, fsvProd, fsvFrete,
  fsvSeg, fsvDesc, fsvII, fsvIPI, fsvPIS, fsvCOFINS, fsvOutro, fsvServ, fsvNF,
  fsvTotPag, fsvPISST, fsvCOFINSST, fsvFCP, fsvFCPST, fsvFCPSTRet, fsvIPIDevol,
  fsvDup, fsvPISServico, fsvCOFINSServico, fsvICMSMonoReten: Currency;
  FaturamentoDireto, NFImportacao, UFCons, bServico : Boolean;

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
  Inicio := DataHoraTimeZoneModoDeteccao( TACBrNFe(TNotasFiscais(Collection).ACBrNFe ));   //Converte o DateTime do Sistema para o TimeZone configurado, para evitar diverg�ncia de Fuso Hor�rio.
  Agora := IncMinute(Inicio, 5);  //Aceita uma toler�ncia de at� 5 minutos, devido ao sincronismo de hor�rio do servidor da Empresa e o servidor da SEFAZ.
  GravaLog('Inicio da Valida��o');

  with TACBrNFe(TNotasFiscais(Collection).ACBrNFe) do
  begin
    Erros := '';

    GravaLog('Validar: 701-vers�o');
    if NFe.infNFe.Versao < 3.10 then
      AdicionaErro('701-Rejei��o: Vers�o inv�lida');

    GravaLog('Validar 512-Chave de acesso');
    if not ValidarConcatChave then  //A03-10
      AdicionaErro(
        '502-Rejei��o: Erro na Chave de Acesso - Campo Id n�o corresponde � concatena��o dos campos correspondentes');

    GravaLog('Validar: 897-C�digo do documento: ' + IntToStr(NFe.Ide.nNF));
    if not ValidarCodigoDFe(NFe.Ide.cNF, NFe.Ide.nNF) then
      AdicionaErro('897-Rejei��o: C�digo num�rico em formato inv�lido ');

    GravaLog('Validar 226-IF');
    if copy(IntToStr(NFe.Emit.EnderEmit.cMun), 1, 2) <>
      IntToStr(Configuracoes.WebServices.UFCodigo) then //B02-10
      AdicionaErro('226-Rejei��o: C�digo da UF do Emitente diverge da UF autorizadora');

    GravaLog('Validar: 703-Data hora');
    if (NFe.Ide.dEmi > Agora) then  //B09-10
      AdicionaErro('703-Rejei��o: Data-Hora de Emiss�o posterior ao hor�rio de recebimento');

    GravaLog('Validar: 228-Data Emiss�o');
    if ((Agora - NFe.Ide.dEmi) > 30) then  //B09-20
      AdicionaErro('228-Rejei��o: Data de Emiss�o muito atrasada');

    //GB09.02 - Data de Emiss�o posterior � 31/03/2011
    //GB09.03 - Data de Recep��o posterior � 31/03/2011 e tpAmb (B24) = 2

    GravaLog('Validar: 253-Digito Chave');
    if not ValidarChave(NFe.infNFe.ID) then
      AdicionaErro('253-Rejei��o: Digito Verificador da chave de acesso composta inv�lida');

    GravaLog('Validar: 270-Digito Municipio Fato Gerador');
    if not ValidarMunicipio(NFe.Ide.cMunFG) then //B12-10
      AdicionaErro('270-Rejei��o: C�digo Munic�pio do Fato Gerador: d�gito inv�lido');

    GravaLog('Validar: 271-Municipio Fato Gerador diferente');
    if (UFparaCodigoUF(NFe.Emit.EnderEmit.UF) <> StrToIntDef(
      copy(IntToStr(NFe.Ide.cMunFG), 1, 2), 0)) then//GB12.1
      AdicionaErro('271-Rejei��o: C�digo Munic�pio do Fato Gerador: difere da UF do emitente');

    GravaLog('Validar: 570-Tipo de Emiss�o SCAN/SVC');
    if ((NFe.Ide.tpEmis in [teSCAN, teSVCAN, teSVCRS]) and
      (Configuracoes.Geral.FormaEmissao = teNormal)) then  //B22-30
      AdicionaErro(
        '570-Rejei��o: Tipo de Emiss�o 3, 6 ou 7 s� � v�lido nas conting�ncias SCAN/SVC');

    GravaLog('Validar: 571-Tipo de Emiss�o SCAN');
    if ((NFe.Ide.tpEmis <> teSCAN) and (Configuracoes.Geral.FormaEmissao = teSCAN))
    then  //B22-40
      AdicionaErro('571-Rejei��o: Tipo de Emiss�o informado diferente de 3 para conting�ncia SCAN');

    GravaLog('Validar: 713-Tipo de Emiss�o SCAN/SVCRS');
    if ((Configuracoes.Geral.FormaEmissao in [teSVCAN, teSVCRS]) and
      (not (NFe.Ide.tpEmis in [teSVCAN, teSVCRS]))) then  //B22-60
      AdicionaErro('713-Rejei��o: Tipo de Emiss�o diferente de 6 ou 7 para conting�ncia da SVC acessada');

    //B23-10
    GravaLog('Validar: 252-Ambiente');
    if (NFe.Ide.tpAmb <> Configuracoes.WebServices.Ambiente) then
      //B24-10
      AdicionaErro('252-Rejei��o: Ambiente informado diverge do Ambiente de recebimento '
        + '(Tipo do ambiente da NF-e difere do ambiente do Web Service)');

    GravaLog('Validar: 370-Tipo de Emiss�o');
    if (NFe.Ide.procEmi in [peAvulsaFisco, peAvulsaContribuinte]) and
      (NFe.Ide.tpEmis <> teNormal) then //B26-30
      AdicionaErro('370-Rejei��o: Nota Fiscal Avulsa com tipo de emiss�o inv�lido');

    GravaLog('Validar: 556-Justificativa Entrada');
    if (NFe.Ide.tpEmis = teNormal) and ((NFe.Ide.xJust > '') or
      (NFe.Ide.dhCont <> 0)) then
      //B28-10
      AdicionaErro(
        '556-Justificativa de entrada em conting�ncia n�o deve ser informada para tipo de emiss�o normal');

    GravaLog('Validar: 557-Justificativa Entrada');
    if (NFe.Ide.tpEmis in [teContingencia, teFSDA, teOffLine]) and
      (NFe.Ide.xJust = '') then //B28-20
      AdicionaErro('557-A Justificativa de entrada em conting�ncia deve ser informada');

    GravaLog('Validar: 558-Data de Entrada');
    if (NFe.Ide.dhCont > Agora) then //B28-30
      AdicionaErro('558-Rejei��o: Data de entrada em conting�ncia posterior a data de recebimento');

    GravaLog('Validar: 569-Data Entrada conting�ncia');
    if (NFe.Ide.dhCont > 0) and ((Agora - NFe.Ide.dhCont) > 30) then //B28-40
      AdicionaErro('569-Rejei��o: Data de entrada em conting�ncia muito atrasada');

    GravaLog('Validar: 207-CNPJ emitente');
    // adicionado CNPJ por conta do produtor rural
    if not ValidarCNPJouCPF(NFe.Emit.CNPJCPF) then
      AdicionaErro('207-Rejei��o: CNPJ do emitente inv�lido');

    GravaLog('Validar: 272-C�digo Munic�pio');
    if not ValidarMunicipio(NFe.Emit.EnderEmit.cMun) then
      AdicionaErro('272-Rejei��o: C�digo Munic�pio do Emitente: d�gito inv�lido');

    GravaLog('Validar: 273-C�digo Munic�pio difere da UF');
    if (UFparaCodigoUF(NFe.Emit.EnderEmit.UF) <> StrToIntDef(
      copy(IntToStr(NFe.Emit.EnderEmit.cMun), 1, 2), 0)) then
      AdicionaErro('273-Rejei��o: C�digo Munic�pio do Emitente: difere da UF do emitente');

    GravaLog('Validar: 229-IE n�o informada');
    if EstaVazio(NFe.Emit.IE) then
      AdicionaErro('229-Rejei��o: IE do emitente n�o informada');

    GravaLog('Validar: 209-IE inv�lida');
    if not ValidarIE(NFe.Emit.IE,NFe.Emit.EnderEmit.UF) then
      AdicionaErro('209-Rejei��o: IE do emitente inv�lida ');

    GravaLog('Validar: 208-CNPJ destinat�rio');
    if (Length(Trim(OnlyNumber(NFe.Dest.CNPJCPF))) >= 14) and
      not ValidarCNPJ(NFe.Dest.CNPJCPF) then
      AdicionaErro('208-Rejei��o: CNPJ do destinat�rio inv�lido');

    GravaLog('Validar: 513-EX');
    if (NFe.Retirada.UF = 'EX') and
       (NFe.Retirada.cMun <> 9999999) then
      AdicionaErro('513-Rejei��o: C�digo Munic�pio do Local de Retirada deve ser 9999999 para UF retirada = "EX"');

    GravaLog('Validar: 276-Cod Munic�pio Retirada inv�lido');
    if (NFe.Retirada.UF <> 'EX') and
       NaoEstaVazio(NFe.Retirada.xMun) and
       not ValidarMunicipio(NFe.Retirada.cMun) then
      AdicionaErro('276-Rejei��o: C�digo Munic�pio do Local de Retirada: d�gito inv�lido');

    GravaLog('Validar: 277-Cod Munic�pio Retirada diferente UF');
    if NaoEstaVazio(NFe.Retirada.UF) and (NFe.Retirada.cMun > 0) then
    begin
      if NFe.Retirada.UF = 'EX' then
        CodigoUF := 99
      else
        CodigoUF := UFparaCodigoUF(NFe.Retirada.UF);

      if (CodigoUF <> StrToIntDef(Copy(IntToStr(NFe.Retirada.cMun), 1, 2), 0)) then
        AdicionaErro('277-Rejei��o: C�digo Munic�pio do Local de Retirada: difere da UF do Local de Retirada');
    end;

    GravaLog('Validar: 515-Cod Munic�pio Entrega EX');
    if (NFe.Entrega.UF = 'EX') and
       (NFe.Entrega.cMun <> 9999999) then
      AdicionaErro('515-Rejei��o: C�digo Munic�pio do Local de Entrega deve ser 9999999 para UF entrega = "EX"');

    GravaLog('Validar: 278-Cod Munic�pio Entrega inv�lido');
    if (NFe.Entrega.UF <> 'EX') and
       NaoEstaVazio(NFe.Entrega.xMun) and
       not ValidarMunicipio(NFe.Entrega.cMun) then
      AdicionaErro('278-Rejei��o: C�digo Munic�pio do Local de Entrega: d�gito inv�lido');

    GravaLog('Validar: 279-Cod Munic�pio Entrega diferente UF');
    if NaoEstaVazio(NFe.Entrega.UF) and (NFe.Entrega.cMun > 0) then
    begin
      if NFe.Entrega.UF = 'EX' then
        CodigoUF := 99
      else
        CodigoUF := UFparaCodigoUF(NFe.Entrega.UF);

      if (CodigoUF <> StrToIntDef(Copy(IntToStr(NFe.Entrega.cMun), 1, 2), 0)) then
        AdicionaErro('279-Rejei��o: C�digo Munic�pio do Local de Entrega: difere da UF do Local de Entrega');
    end;

    GravaLog('Validar: 542-CNPJ Transportador');
    if NaoEstaVazio(Trim(NFe.Transp.Transporta.CNPJCPF)) and
       (Length(Trim(OnlyNumber(NFe.Transp.Transporta.CNPJCPF))) >= 14) and
       not ValidarCNPJ(NFe.Transp.Transporta.CNPJCPF) then
      AdicionaErro('542-Rejei��o: CNPJ do Transportador inv�lido');

    GravaLog('Validar: 543-CPF Transportador');
    if NaoEstaVazio(Trim(NFe.Transp.Transporta.CNPJCPF)) and
       (Length(Trim(OnlyNumber(NFe.Transp.Transporta.CNPJCPF))) <= 11) and
       not ValidarCPF(NFe.Transp.Transporta.CNPJCPF) then
      AdicionaErro('543-Rejei��o: CPF do Transportador inv�lido');

    GravaLog('Validar: 559-UF do Transportador');
    if NaoEstaVazio(Trim(NFe.Transp.Transporta.IE)) and
       EstaVazio(Trim(NFe.Transp.Transporta.UF)) then
      AdicionaErro('559-Rejei��o: UF do Transportador n�o informada');

    GravaLog('Validar: 544-IE do Transportador');
    if NaoEstaVazio(Trim(NFe.Transp.Transporta.IE)) and
       not ValidarIE(NFe.Transp.Transporta.IE,NFe.Transp.Transporta.UF) then
      AdicionaErro('544-Rejei��o: IE do Transportador inv�lida');

    if (NFe.Ide.modelo = 65) then  //Regras v�lidas apenas para NFC-e - 65
    begin
      GravaLog('Validar: 704-NFCe Data atrasada');
      if (NFe.Ide.dEmi < IncMinute(Agora,-10)) and
        (NFe.Ide.tpEmis in [teNormal, teSCAN, teSVCAN, teSVCRS]) then
        //B09-40
        AdicionaErro('704-Rejei��o: NFC-e com Data-Hora de emiss�o atrasada');

      GravaLog('Validar: 705-NFCe Data de entrada/saida');
      if (NFe.Ide.dSaiEnt <> 0) then  //B10-10
        AdicionaErro('705-Rejei��o: NFC-e com data de entrada/sa�da');

      GravaLog('Validar: 706-NFCe opera��o entrada');
      if (NFe.Ide.tpNF = tnEntrada) then  //B11-10
        AdicionaErro('706-Rejei��o: NFC-e para opera��o de entrada');

      GravaLog('Validar: 707-NFCe opera��o interestadual');
      if (NFe.Ide.idDest <> doInterna) then  //B11-10
        AdicionaErro('707-NFC-e para opera��o interestadual ou com o exterior');

      GravaLog('Validar: 709-NFCe formato DANFE');
      if (not (NFe.Ide.tpImp in [tiNFCe, tiMsgEletronica])) then
        //B21-10
        AdicionaErro('709-Rejei��o: NFC-e com formato de DANFE inv�lido');

      GravaLog('Validar: 782-NFCe e SCAN');
      if (NFe.Ide.tpEmis = teSCAN) then //B22-50
        AdicionaErro('782-Rejei��o: NFC-e n�o � autorizada pelo SCAN');

      GravaLog('Validar: 783-NFCe e SVC');
      if (NFe.Ide.tpEmis in [teSVCAN, teSVCRS]) then  //B22-70
        AdicionaErro('783-Rejei��o: NFC-e n�o � autorizada pela SVC');

      GravaLog('Validar: 715-NFCe finalidade');
      if (NFe.Ide.finNFe <> fnNormal) then  //B25-20
        AdicionaErro('715-Rejei��o: Rejei��o: NFC-e com finalidade inv�lida');

      GravaLog('Validar: 716-NFCe opera��o');
      if (NFe.Ide.indFinal = cfNao) then //B25a-10
        AdicionaErro('716-Rejei��o: NFC-e em opera��o n�o destinada a consumidor final');

      GravaLog('Validar: 717-NFCe entrega');
      if (not (NFe.Ide.indPres in [pcPresencial, pcEntregaDomicilio])) then
        //B25b-20
        AdicionaErro('717-Rejei��o: NFC-e em opera��o n�o presencial');

      GravaLog('Validar: 785-NFCe entrega e UF');
      if (NFe.Ide.indPres = pcEntregaDomicilio) and
        (AnsiIndexStr(NFe.Emit.EnderEmit.UF, ['XX']) <> -1) then
        //B25b-30  Qual estado n�o permite entrega a domic�lio?
        AdicionaErro('785-Rejei��o: NFC-e com entrega a domic�lio n�o permitida pela UF');

      GravaLog('Validar: 708-NFCe referenciada');
      if (NFe.Ide.NFref.Count > 0) then
        AdicionaErro('708-Rejei��o: NFC-e n�o pode referenciar documento fiscal');

      GravaLog('Validar: 718-NFCe e IE de ST');
      if NaoEstaVazio(Trim(NFe.Emit.IEST)) then
        AdicionaErro('718-Rejei��o: NFC-e n�o deve informar IE de Substituto Tribut�rio');

      GravaLog('Validar: 787-NFCe entrega e Identifica��o');
      if (NFe.Ide.indPres = pcEntregaDomicilio) and
        EstaVazio(Trim(nfe.Entrega.xLgr)) and 
        EstaVazio(Trim(nfe.Dest.EnderDest.xLgr)) then
        AdicionaErro('787-Rejei��o: NFC-e de entrega a domic�lio sem a identifica��o do destinat�rio');

      GravaLog('Validar: 789-NFCe e destinat�rio');
      if (NFe.Dest.indIEDest <> inNaoContribuinte) then
        AdicionaErro('789-Rejei��o: NFC-e para destinat�rio contribuinte de ICMS');

      GravaLog('Validar: 729-NFCe IE destinat�rio');
      if NaoEstaVazio(Trim(NFe.Dest.IE)) then
        AdicionaErro('729-Rejei��o: NFC-e com informa��o da IE do destinat�rio');

      GravaLog('Validar: 730-NFCe e SUFRAMA');
      if NaoEstaVazio(Trim(NFe.Dest.ISUF)) then
        AdicionaErro('730-Rejei��o: NFC-e com Inscri��o Suframa');

      GravaLog('Validar: 753-NFCe e Frete');
      if (NFe.Transp.modFrete <> mfSemFrete) and
         (NFe.Ide.indPres <> pcEntregaDomicilio)then
        AdicionaErro('753-Rejei��o: NFC-e com Frete');

      GravaLog('Validar: 754-NFCe e dados Transporte');
      if (NFe.Ide.indPres <> pcEntregaDomicilio) and
         ((trim(NFe.Transp.Transporta.CNPJCPF) <> '') or
         (trim(NFe.Transp.Transporta.xNome) <> '') or
         (trim(NFe.Transp.Transporta.IE) <> '') or
         (trim(NFe.Transp.Transporta.xEnder) <> '') or
         (trim(NFe.Transp.Transporta.xMun) <> '') or
         (trim(NFe.Transp.Transporta.UF) <> '')) then
        AdicionaErro('754-Rejei��o: NFC-e com dados do Transportador');

      GravaLog('Validar: 786-NFCe entrega domicilio e dados Transporte');
      if (NFe.Ide.indPres = pcEntregaDomicilio) and
         ((trim(NFe.Transp.Transporta.CNPJCPF) = '') or
         (trim(NFe.Transp.Transporta.xNome) = '')) then
        AdicionaErro('786-Rejei��o: NFC-e de entrega a domic�lio sem dados do Transportador');

      GravaLog('Validar: 755-NFCe reten��o ICMS Transporte');
      if (NFe.Transp.retTransp.vServ > 0) or
         (NFe.Transp.retTransp.vBCRet > 0) or
         (NFe.Transp.retTransp.pICMSRet > 0) or
         (NFe.Transp.retTransp.vICMSRet > 0) or
         (Trim(NFe.Transp.retTransp.CFOP) <> '') or
         (NFe.Transp.retTransp.cMunFG > 0) then
        AdicionaErro('755-Rejei��o: NFC-e com dados de Reten��o do ICMS no Transporte');

      GravaLog('Validar: 756-NFCe dados veiculo Transporte');
      if (Trim(NFe.Transp.veicTransp.placa) <> '') or
         (Trim(NFe.Transp.veicTransp.UF) <> '') or
         (Trim(NFe.Transp.veicTransp.RNTC) <> '') then
        AdicionaErro('756-Rejei��o: NFC-e com dados do ve�culo de Transporte');

      GravaLog('Validar: 757-NFCe dados reboque Transporte');
      if NFe.Transp.Reboque.Count > 0 then
        AdicionaErro('757-Rejei��o: NFC-e com dados de Reboque do ve�culo de Transporte');

      GravaLog('Validar: 758-NFCe dados vag�o Transporte');
      if NaoEstaVazio(Trim(NFe.Transp.vagao)) then
        AdicionaErro('758-Rejei��o: NFC-e com dados do Vag�o de Transporte');

      GravaLog('Validar: 759-NFCe dados Balsa Transporte');
      if NaoEstaVazio(Trim(NFe.Transp.balsa)) then
        AdicionaErro('759-Rejei��o: NFC-e com dados da Balsa de Transporte');

      GravaLog('Validar: 760-NFCe entrega dados cobran�a');
      if (Trim(nfe.Cobr.Fat.nFat) <> '') or
         (NFe.Cobr.Fat.vOrig > 0) or
         (NFe.Cobr.Fat.vDesc > 0) or
         (NFe.Cobr.Fat.vLiq > 0) or
         (NFe.Cobr.Dup.Count > 0) then
        AdicionaErro('760-Rejei��o: NFC-e com dados de cobran�a (Fatura, Duplicata)');

      GravaLog('Validar: 769-NFCe formas pagamento');
      if NFe.pag.Count <= 0 then
        AdicionaErro('769-Rejei��o: NFC-e deve possuir o grupo de Formas de Pagamento');

      GravaLog('Validar: 762-NFCe dados de compra');
      if Trim(NFe.compra.xNEmp) + Trim(NFe.compra.xPed) + Trim(NFe.compra.xCont) <> '' then
        AdicionaErro('762-Rejei��o: NFC-e com dados de compras (Empenho, Pedido, Contrato)');

      GravaLog('Validar: 763-NFCe dados cana');
      if not(Trim(NFe.cana.safra) = '') or not(Trim(NFe.cana.ref) = '') or
         (NFe.cana.fordia.Count > 0) or (NFe.cana.deduc.Count > 0) then
        AdicionaErro('763-Rejei��o: NFC-e com dados de aquisi��o de Cana');

    end
    else if (NFe.Ide.modelo = 55) then  //Regras v�lidas apenas para NF-e - 55
    begin
      GravaLog('Validar: 504-Saida > 30');
      if ((NFe.Ide.dSaiEnt - Agora) > 30) then  //B10-20  - Facultativo
        AdicionaErro('504-Rejei��o: Data de Entrada/Sa�da posterior ao permitido');

      GravaLog('Validar: 505-Saida < 30');
      if (NFe.Ide.dSaiEnt <> 0) and ((Agora - NFe.Ide.dSaiEnt) > 30) then  //B10-30  - Facultativo
        AdicionaErro('505-Rejei��o: Data de Entrada/Sa�da anterior ao permitido');

      GravaLog('Validar: 506-Saida < Emissao');
      if (NFe.Ide.dSaiEnt <> 0) and (NFe.Ide.dSaiEnt < NFe.Ide.dEmi) then
        //B10-40  - Facultativo
        AdicionaErro('506-Rejei��o: Data de Sa�da menor que a Data de Emiss�o');

      GravaLog('Validar: 710-Formato DANFE');
      if (NFe.Ide.tpImp in [tiNFCe, tiMsgEletronica]) then  //B21-20
        AdicionaErro('710-Rejei��o: NF-e com formato de DANFE inv�lido');

      GravaLog('Validar: 711-NFe off-line');
      if (NFe.Ide.tpEmis = teOffLine) then  //B22-10
        AdicionaErro('711-Rejei��o: NF-e com conting�ncia off-line');

      GravaLog('Validar: 254-NFe complementar sem referenciada');
      if (NFe.Ide.finNFe = fnComplementar) and (NFe.Ide.NFref.Count = 0) then  //B25-30
        AdicionaErro('254-Rejei��o: NF-e complementar n�o possui NF referenciada');

      GravaLog('Validar: 255-NFe complementar e muitas referenciada');
      if (NFe.Ide.finNFe = fnComplementar) and (NFe.Ide.NFref.Count > 1) then  //B25-40
        AdicionaErro('255-Rejei��o: NF-e complementar possui mais de uma NF referenciada');

      GravaLog('Validar: 269-CNPJ Emitente NFe complementar');
      if (NFe.Ide.finNFe = fnComplementar) and (NFe.Ide.NFref.Count = 1) and
        (((NFe.Ide.NFref.Items[0].RefNF.CNPJ > '') and
        (NFe.Ide.NFref.Items[0].RefNF.CNPJ <> NFe.Emit.CNPJCPF)) or
        ((NFe.Ide.NFref.Items[0].RefNFP.CNPJCPF > '') and
        (NFe.Ide.NFref.Items[0].RefNFP.CNPJCPF <> NFe.Emit.CNPJCPF))) then
        //B25-50
        AdicionaErro(
          '269-Rejei��o: CNPJ Emitente da NF Complementar difere do CNPJ da NF Referenciada');

      GravaLog('Validar: 678-UF NFe referenciada e complementar');
      if (NFe.Ide.finNFe = fnComplementar) and (NFe.Ide.NFref.Count = 1) and
        //Testa pelo n�mero para saber se TAG foi preenchida
        (((NFe.Ide.NFref.Items[0].RefNF.nNF > 0) and
        (NFe.Ide.NFref.Items[0].RefNF.cUF <> UFparaCodigoUF(
        NFe.Emit.EnderEmit.UF))) or ((NFe.Ide.NFref.Items[0].RefNFP.nNF > 0) and
        (NFe.Ide.NFref.Items[0].RefNFP.cUF <> UFparaCodigoUF(
        NFe.Emit.EnderEmit.UF))))
      then  //B25-60 - Facultativo
        AdicionaErro('678-Rejei��o: NF referenciada com UF diferente da NF-e complementar');

      GravaLog('Validar: 321-NFe devolu��o sem referenciada');
      if (NFe.Ide.finNFe = fnDevolucao) and (NFe.Ide.NFref.Count = 0) then
        //B25-70
        AdicionaErro('321-Rejei��o: NF-e devolu��o n�o possui NF referenciada');

      GravaLog('Validar: 794-NFe e domic�cio NFCe');
      if (NFe.Ide.indPres = pcEntregaDomicilio) then //B25b-10
        AdicionaErro('794-Rejei��o: NF-e com indicativo de NFC-e com entrega a domic�lio');

//      GravaLog('Validar: 719-NFe sem ident. destinat�rio');
//      if (NFe.Dest.CNPJCPF = '') and
//         (NFe.Dest.idEstrangeiro = '') then
//        AdicionaErro('719-Rejei��o: NF-e sem a identifica��o do destinat�rio');

      GravaLog('Validar: 237-CPF destinat�rio ');
      if (Trim(OnlyNumber(NFe.Dest.CNPJCPF)) <> EmptyStr) and
        (Length(Trim(OnlyNumber(NFe.Dest.CNPJCPF))) <= 11) and
        not ValidarCPF(NFe.Dest.CNPJCPF) then
        AdicionaErro('237-Rejei��o: CPF do destinat�rio inv�lido');

//      GravaLog('Validar: 720-idEstrangeiro');
//      if (nfe.Ide.idDest = doExterior) and
//         (EstaVazio(Trim(NFe.Dest.idEstrangeiro))) then
//        AdicionaErro('720-Rejei��o: Na opera��o com Exterior deve ser informada tag idEstrangeiro');

      GravaLog('Validar: 721-Op.Interstadual sem CPF/CNPJ');
      if (nfe.Ide.idDest = doInterestadual) and
         (EstaVazio(Trim(NFe.Dest.CNPJCPF))) then
        AdicionaErro('721-Rejei��o: Opera��o interestadual deve informar CNPJ ou CPF');

      GravaLog('Validar: 723-Op.interna com idEstrangeiro');
      if (nfe.Ide.idDest = doInterna) and
         (NaoEstaVazio(Trim(NFe.Dest.idEstrangeiro))) and
         (NFe.Ide.indFinal <> cfConsumidorFinal)then
        AdicionaErro('723-Rejei��o: Opera��o interna com idEstrangeiro informado deve ser para consumidor final');

      GravaLog('Validar: 724-Nome destinat�rio');
      if EstaVazio(Trim(NFe.Dest.xNome)) then
        AdicionaErro('724-Rejei��o: NF-e sem o nome do destinat�rio');

      GravaLog('Validar: 726-Sem Endere�o destinat�rio');
      if EstaVazio(Trim(NFe.Dest.EnderDest.xLgr)) then
        AdicionaErro('726-Rejei��o: NF-e sem a informa��o de endere�o do destinat�rio');

      GravaLog('Validar: 509-EX e munic�pio');
      if (NFe.Dest.EnderDest.UF <> 'EX') and
         not ValidarMunicipio(NFe.Dest.EnderDest.cMun) then
        AdicionaErro('509-Rejei��o: Informado c�digo de munic�pio diferente de "9999999" para opera��o com o exterior');

      GravaLog('Validar: 727-Op exterior e UF');
      if (nfe.Ide.idDest = doExterior) and
         (NFe.Dest.EnderDest.UF <> 'EX') then
        AdicionaErro('727-Rejei��o: Opera��o com Exterior e UF diferente de EX');

      GravaLog('Validar: 771-Op.Interstadual e UF EX');
      if (nfe.Ide.idDest = doInterestadual) and
         (NFe.Dest.EnderDest.UF = 'EX') then
        AdicionaErro('771-Rejei��o: Opera��o Interestadual e UF de destino com EX');

      GravaLog('Validar: 773-Op.Interna e UF diferente');
      if (nfe.Ide.idDest = doInterna) and
         (NFe.Dest.EnderDest.UF <> NFe.Emit.EnderEmit.UF) and
         (NFe.Ide.indPres <> pcPresencial) then
        AdicionaErro('773-Rejei��o: Opera��o Interna e UF de destino difere da UF do emitente - n�o presencial');

      GravaLog('Validar: 790-Op.Exterior e Destinat�rio ICMS');
      if (NFe.Ide.idDest = doExterior) and
         (NFe.Dest.indIEDest <> inNaoContribuinte) then
        AdicionaErro('790-Rejei��o: Opera��o com Exterior para destinat�rio Contribuinte de ICMS');

      if NFe.infNFe.Versao < 4 then
      begin
        GravaLog('Validar: 768-NFe < 4.0 com formas de pagamento');
        if (NFe.pag.Count > 0) then
          AdicionaErro('768-Rejei��o: NF-e n�o deve possuir o grupo de Formas de Pagamento');
      end
      else
      begin
        GravaLog('Validar: 769-NFe >= 4.0 sem formas pagamento');
        if (NFe.pag.Count <= 0) then
          AdicionaErro('769-Rejei��o: NF-e deve possuir o grupo de Formas de Pagamento');
      end;

      if NFe.infNFe.Versao >= 4 then
      begin
        GravaLog('Validar: 864-Opera��o presencial, fora do estabelecimento e n�o informada campos refNFe');
        if (NFe.Ide.indPres = pcPresencialForaEstabelecimento) and
           (NFe.Ide.NFref.Count <= 0) then
          AdicionaErro('864-Rejei��o: NF-e com indicativo de Opera��o presencial, fora do estabelecimento e n�o informada NF referenciada');

        GravaLog('Validar: 868-Se opera��o interestadual(idDest=2), n�o informar os Grupos Veiculo Transporte (id:X18; veicTransp) e Grupo Reboque (id: X22)');
        if (NFe.Ide.idDest = doInterestadual) and
           (((trim(NFe.Transp.veicTransp.placa) <> '') or
            (trim(NFe.Transp.veicTransp.UF) <> '') or
            (trim(NFe.Transp.veicTransp.RNTC) <> '')) or
            (nfe.Transp.Reboque.Count > 0)) then
          AdicionaErro('868-Rejei��o: Grupos Veiculo Transporte e Reboque n�o devem ser informados');

        if NFe.Ide.finNFe in [fnNormal, fnComplementar] then
        begin
          GravaLog('Validar: 895-Valor do Desconto (vDesc, id:Y05) maior que o Valor Original da Fatura (vOrig, id:Y04)');
          if (nfe.Cobr.Fat.vDesc > nfe.Cobr.Fat.vOrig) then
            AdicionaErro('895-Rejei��o: Valor do Desconto da Fatura maior que Valor Original da Fatura');

          GravaLog('Validar: 902-Valor L�quido da Fatura (vLiq, id:Y06) difere do Valor Original da Fatura (vOrig; id:Y04) � Valor do Desconto (vDesc, id:Y05)');
          if (nfe.Cobr.Fat.vLiq <> (nfe.Cobr.Fat.vOrig - nfe.Cobr.Fat.vDesc)) then
            AdicionaErro('902-Rejei��o: Valor Liquido da Fatura difere do Valor Original menos o Valor do Desconto');

//          GravaLog('Validar: 897-Valor L�quido da Fatura/Valor Original da Fatura maior que o Valor Total da Nota Fiscal');
//          if (((nfe.Cobr.Fat.vLiq > 0) and (nfe.Cobr.Fat.vLiq > nfe.Total.ICMSTot.vNF)) or
//              ((nfe.Cobr.Fat.vOrig > nfe.Total.ICMSTot.vNF)))then
//            AdicionaErro('897-Rejei��o: Valor da Fatura maior que Valor Total da NF-e');

          fsvDup := 0;
          UltVencto := DateOf(NFe.Ide.dEmi);
          for I:=0 to nfe.Cobr.Dup.Count-1 do
          begin
            fsvDup := fsvDup + nfe.Cobr.Dup.Items[I].vDup;

            GravaLog('Validar: 857-Se informado o Grupo Parcelas de cobran�a (tag:dup, Id:Y07), N�mero da parcela (nDup, id:Y08) n�o informado ou inv�lido.');
            if EstaVazio(nfe.Cobr.Dup.Items[I].nDup) then
              AdicionaErro('857-Rejei��o: N�mero da parcela inv�lido ou n�o informado');

            //898 - Verificar DATA de autoriza��o

            GravaLog('Validar: 894-Se informado o grupo de Parcelas de cobran�a (tag:dup, Id:Y07) e Data de vencimento (dVenc, id:Y09) n�o informada ou menor que a Data de Emiss�o (id:B09)');
            if (nfe.Cobr.Dup.Items[I].dVenc < DateOf(NFe.Ide.dEmi)) then
              AdicionaErro('894-Rejei��o: Data de vencimento da parcela n�o informada ou menor que Data de Emiss�o');

            GravaLog('Validar: 867-Se informado o grupo de Parcelas de cobran�a (tag:dup, Id:Y07) e Data de vencimento (dVenc, id:Y09) n�o informada ou menor que a Data de vencimento da parcela anterior (dVenc, id:Y09)');
            if (nfe.Cobr.Dup.Items[I].dVenc < UltVencto) then
              AdicionaErro('867-Rejei��o: Data de vencimento da parcela n�o informada ou menor que a Data de vencimento da parcela anterior');

            UltVencto := nfe.Cobr.Dup.Items[I].dVenc;
          end;

          GravaLog('Validar: 851-Se informado o grupo de Parcelas de cobran�a (tag:dup, Id:Y07) e a soma do valor das parcelas (vDup, id: Y10) difere do Valor L�quido da Fatura (vLiq, id:Y06).');
          //porque se n�o tiver parcela n�o tem valor para ser verificado
          if (nfe.Cobr.Dup.Count > 0) and (((nfe.Cobr.Fat.vLiq > 0) and (fsvDup < nfe.Cobr.Fat.vLiq)) or
             (fsvDup < (nfe.Cobr.Fat.vOrig-nfe.Cobr.Fat.vDesc))) then
            AdicionaErro('851-Rejei��o: Soma do valor das parcelas difere do Valor L�quido da Fatura');
        end;
      end;
    end;

    for I:=0 to NFe.autXML.Count-1 do
    begin
      GravaLog('Validar: 325-'+IntToStr(I)+'-CPF download');
      if (Length(Trim(OnlyNumber(NFe.autXML[I].CNPJCPF))) <= 11) and
        not ValidarCPF(NFe.autXML[I].CNPJCPF) then
        AdicionaErro('325-Rejei��o: CPF autorizado para download inv�lido');

      GravaLog('Validar: 323-'+IntToStr(I)+'-CNPJ download');
      if (Length(Trim(OnlyNumber(NFe.autXML[I].CNPJCPF))) > 11) and
        not ValidarCNPJ(NFe.autXML[I].CNPJCPF) then
        AdicionaErro('323-Rejei��o: CNPJ autorizado para download inv�lido');
    end;

    fsvTotTrib := 0;
    fsvBC      := 0;
    fsvICMS    := 0;
    fsvICMSDeson    := 0;
    fsvBCST    := 0;
    fsvST      := 0;
    fsvProd    := 0;
    fsvFrete   := 0;
    fsvSeg     := 0;
    fsvDesc    := 0;
    fsvII      := 0;
    fsvIPI     := 0;
    fsvPIS     := 0;
    fsvCOFINS  := 0;
    fsvOutro   := 0;
    fsvServ    := 0;
    fsvFCP     := 0;
    fsvFCPST   := 0;
    fsvFCPSTRet:= 0;
    fsvIPIDevol:= 0;
    fsvPISServico := 0;
    fsvCOFINSServico := 0;
    fsvPISST     := 0;
    fsvCOFINSST  := 0;
    fsvICMSMonoReten := 0;

    FaturamentoDireto := False;
    NFImportacao := False;
    UFCons := False;

    for I:=0 to NFe.Det.Count-1 do
    begin
      with NFe.Det[I] do
      begin
        bServico := (Trim(Prod.NCM) = '00') or (Trim(Imposto.ISSQN.cListServ) <> '');
        if (not bServico) then
        begin
          // validar NCM completo somente quando n�o for servi�o
          GravaLog('Validar: 777-NCM info [nItem: '+IntToStr(Prod.nItem)+']');
          if Length(Trim(Prod.NCM)) < 8 then
            AdicionaErro('777-Rejei��o: Obrigat�ria a informa��o do NCM completo [nItem: '+IntToStr(Prod.nItem)+']');
        end;

        if (NFe.Ide.modelo = 65) then
        begin
          GravaLog('Validar: 383-NFCe Item com CSOSN indevido [nItem: '+IntToStr(Prod.nItem)+']');
          if Imposto.ICMS.CSOSN in [csosn101, csosn201, csosn202, csosn203]  then
            AdicionaErro('383-Rejei��o: NFC-e Item com CSOSN indevido [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 766-NFCe Item com CST indevido [nItem: '+IntToStr(Prod.nItem)+']');
          if Imposto.ICMS.CST in [cst10, cst30, cst50, cst51, cst70]  then
            AdicionaErro('766-Rejei��o: NFC-e Item com CST indevido [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 725-NFCe CFOP invalido [nItem: '+IntToStr(Prod.nItem)+']');
          if (pos(OnlyNumber(Prod.CFOP), 'XXXX,5101,5102,5103,5104,5115,5405,5656,5667,5933,5949') <= 0)  then
            AdicionaErro('725-Rejei��o: NFC-e com CFOP inv�lido [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 774-NFCe indicador Total [nItem: '+IntToStr(Prod.nItem)+']');
          if (Prod.IndTot = itNaoSomaTotalNFe) then
            AdicionaErro('774-Rejei��o: NFC-e com indicador de item n�o participante do total [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 736-NFCe Grupo veiculos novos [nItem: '+IntToStr(Prod.nItem)+']');
          if (NaoEstaVazio(Prod.veicProd.chassi)) then
            AdicionaErro('736-Rejei��o: NFC-e com grupo de Ve�culos novos [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 738-NFCe grupo Armamentos [nItem: '+IntToStr(Prod.nItem)+']');
          if (Prod.arma.Count > 0) then
            AdicionaErro('738-Rejei��o: NFC-e com grupo de Armamentos [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 348-NFCe grupo RECOPI [nItem: '+IntToStr(Prod.nItem)+']');
          if (NaoEstaVazio(Prod.nRECOPI)) then
            AdicionaErro('348-Rejei��o: NFC-e com grupo RECOPI [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 740-NFCe CST 51 [nItem: '+IntToStr(Prod.nItem)+']');
          if (Imposto.ICMS.CST = cst51) then
            AdicionaErro('740-Rejei��o: NFC-e com CST 51-Diferimento [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 741-NFCe partilha ICMS [nItem: '+IntToStr(Prod.nItem)+']');
          if (Imposto.ICMS.CST in [cstPart10,cstPart90]) then
            AdicionaErro('741-Rejei��o: NFC-e com Partilha de ICMS entre UF [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 742-NFCe grupo IPI [nItem: '+IntToStr(Prod.nItem)+']');
          if ((Imposto.IPI.cEnq  <> '') or
              (Imposto.IPI.vBC   <> 0) or
              (Imposto.IPI.qUnid <> 0) or
              (Imposto.IPI.vUnid <> 0) or
              (Imposto.IPI.pIPI  <> 0) or
              (Imposto.IPI.vIPI  <> 0)) then
            AdicionaErro('742-Rejei��o: NFC-e com grupo do IPI [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 743-NFCe grupo II [nItem: '+IntToStr(Prod.nItem)+']');
          if (Imposto.II.vBc > 0) or
             (Imposto.II.vDespAdu > 0) or
             (Imposto.II.vII > 0) or
             (Imposto.II.vIOF > 0) or
             (Copy(Prod.CFOP,1,1) = '3') then
            AdicionaErro('743-Rejei��o: NFC-e com grupo do II [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 746-NFCe grupo PIS-ST [nItem: '+IntToStr(Prod.nItem)+']');
          if (Imposto.PISST.vBc > 0) or
             (Imposto.PISST.pPis > 0) or
             (Imposto.PISST.qBCProd > 0) or
             (Imposto.PISST.vAliqProd > 0) or
             (Imposto.PISST.vPIS > 0) then
           AdicionaErro('746-Rejei��o: NFC-e com grupo do PIS-ST [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 749-NFCe grupo COFINS-ST [nItem: '+IntToStr(Prod.nItem)+']');
          if (Imposto.COFINSST.vBC > 0) or
             (Imposto.COFINSST.pCOFINS > 0) or
             (Imposto.COFINSST.qBCProd > 0) or
             (Imposto.COFINSST.vAliqProd > 0) or
             (Imposto.COFINSST.vCOFINS > 0) then
            AdicionaErro('749-Rejei��o: NFC-e com grupo da COFINS-ST [nItem: '+IntToStr(Prod.nItem)+']');
        end
        else if(NFe.Ide.modelo = 55) then
        begin
          if (NFe.infNFe.Versao >= 4) then
          begin
 {           GravaLog('Validar: 508-CST incompat�vel na opera��o com N�o Contribuinte [nItem: '+IntToStr(Prod.nItem)+']');
            if (NFe.Emit.CRT <> crtSimplesNacional) and
               (NFe.Dest.indIEDest = inNaoContribuinte) and
               (NFe.Ide.tpNF <> tnEntrada) and
               (pos(OnlyNumber(Prod.CFOP), 'XXXX,5915,5916,6915,6916,5912,5913') <= 0) and
               (EstaVazio(Prod.veicProd.chassi) or (NaoEstaVazio(Prod.veicProd.chassi) and not (Prod.veicProd.tpOP in [toFaturamentoDireto, toVendaDireta]))) and
               (not (Imposto.ICMS.CST in [cst00, cst20, cst40, cst41, cst60])) then
              AdicionaErro('508-Rejei��o: CST incompat�vel na opera��o com N�o Contribuinte [nItem: '+IntToStr(Prod.nItem)+']');

            GravaLog('Validar: 529-CST incompat�vel na opera��o com Contribuinte Isento de Inscri��o Estadual [nItem: '+IntToStr(Prod.nItem)+']');
            if (NFe.Dest.indIEDest = inIsento) and
               ((Imposto.ICMS.CST = cst51) or
               ((Imposto.ICMS.CST = cst50) and (pos(OnlyNumber(Prod.CFOP), 'XXXX,5915,5916,6915,6916,5912,5913') <= 0))) then
             AdicionaErro('529-Rejei��o: CST incompat�vel na opera��o com Contribuinte Isento de Inscri��o Estadual [nItem: '+IntToStr(Prod.nItem)+']');

            GravaLog('Validar: 600-CSOSN incompat�vel na opera��o com N�o Contribuinte [nItem: '+IntToStr(Prod.nItem)+']');
            if (NFe.Emit.CRT = crtSimplesNacional) and
               (NFe.Dest.indIEDest = inNaoContribuinte) and
               (NFe.Ide.tpNF <> tnEntrada) and
               (pos(OnlyNumber(Prod.CFOP), 'XXXX,5915,5916,6915,6916,5912,5913') <= 0) and
               (EstaVazio(Prod.veicProd.chassi) or (NaoEstaVazio(Prod.veicProd.chassi) and not (Prod.veicProd.tpOP in [toFaturamentoDireto, toVendaDireta]))) and
               (not (Imposto.ICMS.CSOSN in [csosn102, csosn103, csosn300, csosn400, csosn500])) then
              AdicionaErro('600-Rejei��o: CSOSN incompat�vel na opera��o com N�o Contribuinte [nItem: '+IntToStr(Prod.nItem)+']');

            GravaLog('Validar: 806-Opera��o com ICMS-ST sem informa��o do CEST [nItem: '+IntToStr(Prod.nItem)+']');
            if (not Imposto.ICMS.CST in [cstPart10,cstPart90]) and
               EstaVazio(Prod.CEST) and
               (((NFe.Emit.CRT = crtSimplesNacional) and (Imposto.ICMS.CSOSN in [csosn201, csosn202, csosn203, csosn500, csosn900])) or
                ((NFe.Emit.CRT <> crtSimplesNacional) and (Imposto.ICMS.CST in [cst10, cst30, cst60, cst70, cst90]))) then
              AdicionaErro('806-Rejei��o: Opera��o com ICMS-ST sem informa��o do CEST [nItem: '+IntToStr(Prod.nItem)+']');           }

{            GravaLog('Validar: 856-Obrigat�ria a informa��o do campo vPart (id: LA03d) para produto "210203001 � GLP" (tag:cProdANP) [nItem: '+IntToStr(Prod.nItem)+']');
            if (Prod.comb.cProdANP = 210203001) and (Prod.comb.vPart <= 0) then
              AdicionaErro('856-Rejei��o: Campo valor de partida n�o preenchido para produto GLP [nItem: '+IntToStr(Prod.nItem)+']'); }

{            GravaLog('Validar: 858-Grupo ICMS60 (id:N08) informado indevidamente nas opera��es com os produtos combust�veis sujeitos a repasse interestadual [nItem: '+IntToStr(Prod.nItem)+']');
            if (Prod.comb.cProdANP = '210203001') and (Imposto.ICMS.CST = cst60 and Imposto.ICMS.vICMSSTDest <= 0) then
              AdicionaErro('858-Rejei��o: Grupo de Tributa��o informado indevidamente [nItem: '+IntToStr(Prod.nItem)+']');    }//VERIFICAR


          end;
        end;

        GravaLog('Validar: 629-Produto do valor unit�rio e quantidade comercializada [nItem: ' + IntToStr(Prod.nItem) + ']');
        if (NFe.ide.finNFe = fnNormal) and (ComparaValor(Prod.vProd, Prod.vUnCom * Prod.qCom, 0.01) <> 0) then
          AdicionaErro('629-Rejei��o: Valor do Produto difere do produto Valor Unit�rio de Comercializa��o e Quantidade Comercial [nItem: ' + IntToStr(Prod.nItem) + ']');

        GravaLog('Validar: 630-Produto do valor unit�rio e quantidade tribut�vel [nItem: ' + IntToStr(Prod.nItem) + ']');
        if (NFe.ide.finNFe = fnNormal) and (ComparaValor(Prod.vProd, Prod.vUnTrib * Prod.qTrib, 0.01) <> 0) then
          AdicionaErro('630-Rejei��o: Valor do Produto difere do produto Valor Unit�rio de Tributa��o e Quantidade Tribut�vel [nItem: ' + IntToStr(Prod.nItem) + ']');

        GravaLog('Validar: 528-ICMS BC e Aliq [nItem: '+IntToStr(Prod.nItem)+']');
        if (Imposto.ICMS.CST in [cst00,cst10,cst20,cst70]) and
           (NFe.Ide.finNFe = fnNormal) and
	       (ComparaValor(Imposto.ICMS.vICMS, Imposto.ICMS.vBC * (Imposto.ICMS.pICMS/100), 0.01) <> 0) then
          AdicionaErro('528-Rejei��o: Valor do ICMS difere do produto BC e Al�quota [nItem: '+IntToStr(Prod.nItem)+']');

        GravaLog('Validar: 625-Insc.SUFRAMA [nItem: '+IntToStr(Prod.nItem)+']');
        if (Imposto.ICMS.motDesICMS = mdiSuframa) and
           (EstaVazio(NFe.Dest.ISUF))then
          AdicionaErro('625-Rejei��o: Inscri��o SUFRAMA deve ser informada na venda com isen��o para ZFM [nItem: '+IntToStr(Prod.nItem)+']');

        GravaLog('Validar: 530-ISSQN e IM [nItem: '+IntToStr(Prod.nItem)+']');
        if EstaVazio(NFe.Emit.IM) and
          ((Imposto.ISSQN.vBC > 0) or
           (Imposto.ISSQN.vAliq > 0) or
           (Imposto.ISSQN.vISSQN > 0) or
           (Imposto.ISSQN.cMunFG > 0) or
           (Imposto.ISSQN.cListServ <> '')) then
          AdicionaErro('530-Rejei��o: Opera��o com tributa��o de ISSQN sem informar a Inscri��o Municipal [nItem: '+IntToStr(Prod.nItem)+']');

        GravaLog('Validar: 287-Cod.Munic�pio FG [nItem: '+IntToStr(Prod.nItem)+']');
        if (Imposto.ISSQN.cMunFG > 0) and
           not ValidarMunicipio(Imposto.ISSQN.cMunFG) then
          AdicionaErro('287-Rejei��o: C�digo Munic�pio do FG - ISSQN: d�gito inv�lido [nItem: '+IntToStr(Prod.nItem)+']');

        if (NFe.infNFe.Versao >= 4) then
        begin
          if (Trim(Prod.cEAN) = '') then
          begin
            //somente aplicavel em produ��o a partir de 01/12/2018
            //GravaLog('Validar: 883-GTIN (cEAN) sem informa��o [nItem:' + IntToStr(I) + ']');
            //AdicionaErro('883-Rejei��o: GTIN (cEAN) sem informa��o [nItem:' + IntToStr(I) + ']');
          end
          else
          begin
            if (Prod.cEAN <> SEM_GTIN) then
            begin
              GravaLog('Validar: 611-GTIN (cEAN) inv�lido [nItem: '+IntToStr(Prod.nItem)+']');
              if not ValidarGTIN(Prod.cEAN) then
                AdicionaErro('611-Rejei��o: GTIN (cEAN) inv�lido [nItem: '+IntToStr(Prod.nItem)+']');

              GravaLog('Validar: 882-GTIN (cEAN) com prefixo inv�lido [nItem: '+IntToStr(Prod.nItem)+']');
              if not ValidarPrefixoGTIN(Prod.cEAN) then
                AdicionaErro('882-Rejei��o: GTIN (cEAN) com prefixo inv�lido [nItem: '+IntToStr(Prod.nItem)+']');

              GravaLog('Validar: 885-GTIN informado, mas n�o informado o GTIN da unidade tribut�vel [nItem: '+IntToStr(Prod.nItem)+']');
              if (Trim(Prod.cEANTrib) = '') or ((Trim(Prod.cEANTrib) = SEM_GTIN)) then
                AdicionaErro('885-Rejei��o: GTIN informado, mas n�o informado o GTIN da unidade tribut�vel [nItem: '+IntToStr(Prod.nItem)+']');
            end;
          end;

          if (Trim(Prod.cEANTrib) = '') then
          begin
            //somente aplicavel em produ��o a partir de 01/12/2018
            //GravaLog('Validar: 888-GTIN da unidade tribut�vel (cEANTrib) sem informa��o [nItem:' + IntToStr(I) + ']');
            //AdicionaErro('888-Rejei��o: GTIN da unidade tribut�vel (cEANTrib) sem informa��o [nItem: '+IntToStr(Prod.nItem)+']');
          end
          else
          begin
            if (Prod.cEANTrib <> SEM_GTIN) then
            begin
              GravaLog('Validar: 612-GTIN da unidade tribut�vel (cEANTrib) inv�lido [nItem: '+IntToStr(Prod.nItem)+']');
              if not ValidarGTIN(Prod.cEANTrib) then
                AdicionaErro('612-Rejei��o: GTIN da unidade tribut�vel (cEANTrib) inv�lido [nItem: '+IntToStr(Prod.nItem)+']');

              GravaLog('Validar: 884-GTIN da unidade tribut�vel (cEANTrib) com prefixo inv�lido [nItem: '+IntToStr(Prod.nItem)+']');
              if not ValidarPrefixoGTIN(Prod.cEANTrib) then
                AdicionaErro('884-Rejei��o: GTIN da unidade tribut�vel (cEANTrib) com prefixo inv�lido [nItem: '+IntToStr(Prod.nItem)+']');

              GravaLog('Validar: 886-GTIN da unidade tribut�vel informado, mas n�o informado o GTIN [nItem: '+IntToStr(Prod.nItem)+']');
              if (Trim(Prod.cEAN) = '') or ((Trim(Prod.cEAN) = SEM_GTIN)) then
                AdicionaErro('886-Rejei��o: GTIN da unidade tribut�vel informado, mas n�o informado o GTIN [nItem: '+IntToStr(Prod.nItem)+']');
            end;
          end;

          GravaLog('Valida��o: 889-Obrigat�ria a informa��o do GTIN para o produto [nItem: '+IntToStr(Prod.nItem)+']');
          if (Trim(Prod.cEAN) = '') then
            AdicionaErro('889-Rejei��o: Obrigat�ria a informa��o do GTIN para o produto [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 879-Se informado indEscala=N- n�o relevante (id: I05d), deve ser informado CNPJ do Fabricante da Mercadoria (id: I05e) [nItem: '+IntToStr(Prod.nItem)+']');
          if (Prod.indEscala = ieNaoRelevante) and
             EstaVazio(Prod.CNPJFab) then
            AdicionaErro('879-Rejei��o: Informado item Produzido em Escala N�O Relevante e n�o informado CNPJ do Fabricante [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 489-Se informado CNPJFab (id: I05e) - CNPJ inv�lido (DV, zeros) [nItem: '+IntToStr(Prod.nItem)+']');
          if NaoEstaVazio(Prod.CNPJFab) and (not ValidarCNPJ(Prod.CNPJFab)) then
            AdicionaErro('489-Rejei��o: CNPJFab informado inv�lido (DV ou zeros) [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 854-Informado campo cProdANP (id: LA02) = 210203001 (GLP) e campo uTrib (id: I13) <> �kg� (ignorar a diferencia��o entre mai�sculas e min�sculas) [nItem: '+IntToStr(Prod.nItem)+']');
          if (Prod.comb.cProdANP = 210203001) and (UpperCase(Prod.uTrib) <> 'KG') then
            AdicionaErro('854-Rejei��o: Unidade Tribut�vel (tag:uTrib) incompat�vel com produto informado [nItem: '+IntToStr(Prod.nItem)+']');

          if not UFCons then
            UFCons := (Prod.comb.UFcons <> '') and (Prod.comb.UFcons <> NFe.emit.EnderEmit.UF);

          for J:=0 to Prod.rastro.Count-1 do
          begin
            GravaLog('Validar: 877-Data de Fabrica��o dFab (id:I83) maior que a data de processamento [nItem: '+IntToStr(Prod.nItem)+']');
            if (Prod.rastro.Items[J].dFab > NFe.Ide.dEmi) then
              AdicionaErro('877-Rejei��o: Data de fabrica��o maior que a data de processamento [nItem: '+IntToStr(Prod.nItem)+']');

            GravaLog('Validar: 870-Informada data de validade dVal(id: I84) menor que Data de Fabrica��o dFab (id: I83) [nItem: '+IntToStr(Prod.nItem)+']');
            if (Prod.rastro.Items[J].dVal < Prod.rastro.Items[J].dFab) then
              AdicionaErro('870-Rejei��o: Data de validade incompat�vel com data de fabrica��o [nItem: '+IntToStr(Prod.nItem)+']');
          end;

          for J:=0 to Prod.med.Count-1 do
          begin
            GravaLog('Validar: 873-Se informado Grupo de Medicamentos (tag:med) obrigat�rio preenchimento do grupo rastro (id: I80) [nItem: '+IntToStr(Prod.nItem)+']');
            if NaoEstaVazio(Prod.med[J].cProdANVISA)
               and (Prod.rastro.Count<=0)
               and (not (NFe.Ide.finNFe in [fnDevolucao,fnAjuste,fnComplementar])) // exce��o 1
               and (not (NFe.Ide.indPres in [pcInternet, pcTeleatendimento]))      // exce��o 2
               and (AnsiIndexStr(Prod.CFOP,['5922','6922','5118','6118',               // exce��o 3 CFOP's excluidos da valida��o
                                        '5119','6119','5120','6120'  ]) = -1)
               and (NFe.Ide.tpNF = tnSaida)                                        // exce��o 4
            then
              AdicionaErro('873-Rejei��o: Opera��o com medicamentos e n�o informado os campos de rastreabilidade [nItem: '+IntToStr(Prod.nItem)+']');
          end;

          GravaLog('Validar: 461-Informado percentual do GLP (id: LA03a) ou percentual de G�s Natural Nacional (id: LA03b) ou percentual de G�s Natural Importado (id: LA03c) para produto diferente de "210203001 � GLP" (tag:cProdANP) [nItem: '+IntToStr(Prod.nItem)+']');
          if (Prod.comb.cProdANP <> 210203001) and ((Prod.comb.pGLP > 0) or (Prod.comb.pGNn > 0) or (Prod.comb.pGNi > 0)) then
            AdicionaErro('461-Rejei��o: Informado campos de percentual de GLP e/ou GLGNn e/ou GLGNi para produto diferente de GLP [nItem: '+IntToStr(Prod.nItem)+']');

          GravaLog('Validar: 855-Informado percentual do GLP (id: LA03a) ou percentual de G�s Natural Nacional (id: LA03b) ou percentual de G�s Natural Importado (id: LA03c) para produto diferente de "210203001 � GLP" (tag:cProdANP) [nItem: '+IntToStr(Prod.nItem)+']');
          if (Prod.comb.cProdANP = 210203001) and ((Prod.comb.pGLP + Prod.comb.pGNn + Prod.comb.pGNi) <> 100) then
            AdicionaErro('855-Rejei��o: Somat�rio percentuais de GLP derivado do petr�leo, GLGNn e GLGNi diferente de 100 [nItem: '+IntToStr(Prod.nItem)+']');
        end;

        // Valores somados independentemente de IndTot
        fsvTotTrib  := fsvTotTrib + Imposto.vTotTrib;
        fsvFrete    := fsvFrete + Prod.vFrete;
        fsvSeg      := fsvSeg + Prod.vSeg;
        fsvOutro    := fsvOutro + Prod.vOutro;
        fsvDesc     := fsvDesc + Prod.vDesc;
        fsvII       := fsvII + Imposto.II.vII;
        fsvIPI      := fsvIPI + Imposto.IPI.vIPI;
        fsvIPIDevol := fsvIPIDevol + vIPIDevol;
        fsvICMSDeson := fsvICMSDeson + Imposto.ICMS.vICMSDeson;

        if bServico then
        begin
          fsvPISServico    := fsvPISServico + Imposto.PIS.vPIS;
          fsvCOFINSServico := fsvCOFINSServico + Imposto.COFINS.vCOFINS;
        end
        else
        begin
          fsvPIS     := fsvPIS + Imposto.PIS.vPIS;
          fsvCOFINS  := fsvCOFINS + Imposto.COFINS.vCOFINS;
        end;

        // Valores somados se IndTot = itSomaTotalNFe
        if Prod.IndTot = itSomaTotalNFe then
        begin
          fsvBC        := fsvBC + Imposto.ICMS.vBC;
          fsvICMS      := fsvICMS + Imposto.ICMS.vICMS;
          fsvBCST      := fsvBCST + Imposto.ICMS.vBCST;
          fsvST        := fsvST + Imposto.ICMS.vICMSST;
          fsvFCP       := fsvFCP + Imposto.ICMS.vFCP;
          fsvFCPST     := fsvFCPST + Imposto.ICMS.vFCPST;
          fsvFCPSTRet  := fsvFCPSTRet + Imposto.ICMS.vFCPSTRet;
          fsvICMSMonoReten := fsvICMSMonoReten + Imposto.ICMS.vICMSMonoReten;

          // Verificar se comp�e PIS ST e COFINS ST
          if (Imposto.PISST.indSomaPISST = ispPISSTCompoe) then
            fsvPISST := fsvPISST + Imposto.PISST.vPIS;
          if (Imposto.COFINSST.indSomaCOFINSST = iscCOFINSSTCompoe) then
            fsvCOFINSST := fsvCOFINSST + Imposto.COFINSST.vCOFINS;

          // Quando for servi�o o produto n�o soma no total de produtos, quando for nota de ajuste tamb�m ir� somar
          if (not bServico) or (NFe.Ide.finNFe = fnAjuste) then
            fsvProd := fsvProd + Prod.vProd;
        end;

        if Prod.veicProd.tpOP = toFaturamentoDireto then
          FaturamentoDireto := True;

        if Copy(Prod.CFOP, 1, 1) = '3' then
          NFImportacao := True;
      end;
    end;

    // O campo abaixo � pego diretamento do total. N�o foi implementada valida��o 605 para os itens.
    fsvServ := NFe.Total.ISSQNtot.vServ;

    if not UFCons then
    begin
      GravaLog('Validar: 772-Op.Interestadual e UF igual');
      if (nfe.Ide.idDest = doInterestadual) and
         (NFe.Dest.EnderDest.UF = NFe.Emit.EnderEmit.UF) and
         (NFe.Dest.CNPJCPF <> NFe.Emit.CNPJCPF) and
         (NFe.Entrega.UF = NFe.Emit.EnderEmit.UF) then
        AdicionaErro('772-Rejei��o: Opera��o Interestadual e UF de destino igual � UF do emitente');
    end;

    if FaturamentoDireto then
      fsvNF := (fsvProd + fsvFrete + fsvSeg + fsvOutro + fsvII + fsvIPI +
                fsvServ + fsvPISST + fsvCOFINSST) - (fsvDesc + fsvICMSDeson)
    else
      fsvNF := (fsvProd + fsvST + fsvFrete + fsvSeg + fsvOutro + fsvII + fsvIPI +
                fsvServ + fsvFCPST + fsvICMSMonoReten + fsvIPIDevol + fsvPISST +
                fsvCOFINSST) - (fsvDesc + fsvICMSDeson);

    GravaLog('Validar: 531-Total BC ICMS');
    if (NFe.Total.ICMSTot.vBC <> fsvBC) then
      AdicionaErro('531-Rejei��o: Total da BC ICMS difere do somat�rio dos itens');

    GravaLog('Validar: 532-Total ICMS');
    if (NFe.Total.ICMSTot.vICMS <> fsvICMS) then
      AdicionaErro('532-Rejei��o: Total do ICMS difere do somat�rio dos itens');

    GravaLog('Validar: 795-Total ICMS desonerado');
    if (NFe.Total.ICMSTot.vICMSDeson <> fsvICMSDeson) then
      AdicionaErro('795-Rejei��o: Total do ICMS desonerado difere do somat�rio dos itens');

    GravaLog('Validar: 533-Total BC ICMS-ST');
    if (NFe.Total.ICMSTot.vBCST <> fsvBCST) then
      AdicionaErro('533-Rejei��o: Total da BC ICMS-ST difere do somat�rio dos itens');

    GravaLog('Validar: 534-Total ICMS-ST');
    if (NFe.Total.ICMSTot.vST <> fsvST) then
      AdicionaErro('534-Rejei��o: Total do ICMS-ST difere do somat�rio dos itens');

    GravaLog('Validar: 564-Total Produto/Servi�o');
    if (ComparaValor(NFe.Total.ICMSTot.vProd, fsvProd, 0.009) <> 0) then
      AdicionaErro('564-Rejei��o: Total do Produto / Servi�o difere do somat�rio dos itens');

    GravaLog('Validar: 535-Total Frete');
    if (NFe.Total.ICMSTot.vFrete <> fsvFrete) then
      AdicionaErro('535-Rejei��o: Total do Frete difere do somat�rio dos itens');

    GravaLog('Validar: 536-Total Seguro');
    if (NFe.Total.ICMSTot.vSeg <> fsvSeg) then
      AdicionaErro('536-Rejei��o: Total do Seguro difere do somat�rio dos itens');

    GravaLog('Validar: 537-Total Desconto');
    if (NFe.Total.ICMSTot.vDesc <> fsvDesc) then
      AdicionaErro('537-Rejei��o: Total do Desconto difere do somat�rio dos itens');

    GravaLog('Validar: 601-Total II');
    if (NFe.Total.ICMSTot.vII <> fsvII) then
      AdicionaErro('601-Rejei��o: Total do II difere do somat�rio dos itens');

    GravaLog('Validar: 538-Total IPI');
    if (NFe.Total.ICMSTot.vIPI <> fsvIPI) then
      AdicionaErro('538-Rejei��o: Total do IPI difere do somat�rio dos itens');

    GravaLog('Validar: 602-Total PIS');
    if (NFe.Total.ICMSTot.vPIS <> fsvPIS) then
      AdicionaErro('602-Rejei��o: Total do PIS difere do somat�rio dos itens sujeitos ao ICMS');

    GravaLog('Validar: 603-Total COFINS');
    if (NFe.Total.ICMSTot.vCOFINS <> fsvCOFINS) then
      AdicionaErro('603-Rejei��o: Total da COFINS difere do somat�rio dos itens sujeitos ao ICMS');

    GravaLog('Validar: 604-Total vOutro');
    if (NFe.Total.ICMSTot.vOutro <> fsvOutro) then
      AdicionaErro('604-Rejei��o: Total do vOutro difere do somat�rio dos itens');

    GravaLog('Validar: 608-Total PIS ISSQN');
    if (NFe.Total.ISSQNtot.vPIS <> fsvPISServico) then
      AdicionaErro('608-Rejei��o: Total do PIS difere do somat�rio dos itens sujeitos ao ISSQN');

    GravaLog('Validar: 609-Total COFINS ISSQN');
    if (NFe.Total.ISSQNtot.vCOFINS <> fsvCOFINSServico) then
      AdicionaErro('609-Rejei��o: Total da COFINS difere do somat�rio dos itens sujeitos ao ISSQN');

    GravaLog('Validar: 861-Total do FCP');
    if (NFe.Total.ICMSTot.vFCP <> fsvFCP) then
      AdicionaErro('861-Rejei��o: Total do FCP difere do somat�rio dos itens');

    if (NFe.Ide.modelo = 55) then  //Regras v�lidas apenas para NF-e - 55
    begin
      GravaLog('Validar: 862-Total do FCP ST');
      if (NFe.Total.ICMSTot.vFCPST <> fsvFCPST) then
        AdicionaErro('862-Rejei��o: Total do FCP ST difere do somat�rio dos itens');

      GravaLog('Validar: 859-Total do FCP ST retido anteriormente');
      if (NFe.Total.ICMSTot.vFCPSTRet <> fsvFCPSTRet) then
        AdicionaErro('859-Rejei��o: Total do FCP retido anteriormente por Substitui��o Tribut�ria difere do somat�rio dos itens');

      GravaLog('Validar: 863-Total do IPI devolvido');
      if (NFe.Total.ICMSTot.vIPIDevol <> fsvIPIDevol) then
        AdicionaErro('863-Rejei��o: Total do IPI devolvido difere do somat�rio dos itens');
    end;

    GravaLog('Validar: 610-Total NF');
    if not NFImportacao and
       (NFe.Total.ICMSTot.vNF <> fsvNF) then
    begin
      if (ComparaValor(NFe.Total.ICMSTot.vNF, fsvNF, 0.009) <> 0) and (ComparaValor(NFe.Total.ICMSTot.vNF, fsvNF + fsvICMSDeson, 0.009) <> 0) then
        AdicionaErro('610-Rejei��o: Total da NF difere do somat�rio dos Valores comp�e o valor Total da NF.');
    end;

    GravaLog('Validar: 685-Total Tributos');
    if (NFe.Total.ICMSTot.vTotTrib <> fsvTotTrib) then
      AdicionaErro('685-Rejei��o: Total do Valor Aproximado dos Tributos difere do somat�rio dos itens');

    if (NFe.Ide.modelo = 65) and (NFe.infNFe.Versao < 4) then
    begin
      GravaLog('Validar: 767-NFCe soma pagamentos');
      fsvTotPag := 0;
      for I := 0 to NFe.pag.Count-1 do
      begin
        fsvTotPag :=  fsvTotPag + NFe.pag[I].vPag;
      end;

      if (NFe.Total.ICMSTot.vNF <> fsvTotPag) then
        AdicionaErro('767-Rejei��o: NFC-e com somat�rio dos pagamentos diferente do total da Nota Fiscal');
    end
    else if (NFe.infNFe.Versao >= 4) then
    begin
      case NFe.Ide.finNFe of
        fnNormal, fnComplementar:
        begin
          fsvTotPag := 0;
          for I := 0 to NFe.pag.Count-1 do
          begin
            fsvTotPag :=  fsvTotPag + NFe.pag[I].vPag;
          end;

          {
            ** Valida��o removida na NT 2016.002 v1.10
          GravaLog('Validar: 767-Soma dos pagamentos');
          if (fsvTotPag < NFe.Total.ICMSTot.vNF) then
            AdicionaErro('767-Rejei��o: Somat�rio dos pagamentos diferente do total da Nota Fiscal');
          }

          if (NFe.Ide.modelo = 65) then
          begin
            GravaLog('Validar: 899-NFCe sem pagamento');
            for I := 0 to NFe.pag.Count - 1 do
            begin
              if (NFe.pag[I].tPag = fpSemPagamento) then
              begin
                AdicionaErro('899-Rejei��o: Informado incorretamente o campo meio de pagamento');
                Break;
              end;
            end;

            GravaLog('Validar: 865-Total dos pagamentos NFCe');
            if (fsvTotPag < NFe.Total.ICMSTot.vNF) then
              AdicionaErro('865-Rejei��o: Total dos pagamentos menor que o total da nota');
          end;

          GravaLog('Validar: 866-Aus�ncia de troco');
          if (NFe.pag.vTroco = 0) and (fsvTotPag > NFe.Total.ICMSTot.vNF) then
            AdicionaErro('866-Rejei��o: Aus�ncia de troco quando o valor dos pagamentos informados for maior que o total da nota');

          GravaLog('Validar: 869-Valor do troco');
          if (NFe.pag.vTroco > 0) and (NFe.Total.ICMSTot.vNF <> (fsvTotPag - NFe.pag.vTroco)) then
            AdicionaErro('869-Rejei��o: Valor do troco incorreto');

        end;

        fnDevolucao:
        begin
          GravaLog('Validar: 871-Informa��es de Pagamento');
          for I := 0 to NFe.pag.Count-1 do
          begin
            if (NFe.pag[I].tPag <> fpSemPagamento) then
              AdicionaErro('871-Rejei��o: O campo Meio de Pagamento deve ser preenchido com a op��o Sem Pagamento');
          end;
        end;
      end;
    end;

    //TODO: Regrar W01. Total da NF-e / ISSQN

  end;

  Result := EstaVazio(Erros);

  if not Result then
  begin
    Erros := ACBrStr('Erro(s) nas Regras de neg�cios da nota: '+
                     IntToStr(NFe.Ide.nNF) + sLineBreak +
                     Erros);
  end;

  GravaLog('Fim da Valida��o. Tempo: '+FormatDateTime('hh:nn:ss:zzz', Now - Inicio)+sLineBreak+
           'Erros:' + Erros);

  //DEBUG
  //WriteToTXT('c:\temp\Notafiscal.txt', Log);

  FErroRegrasdeNegocios := Erros;
end;

function NotaFiscal.LerXML(const AXML: String): Boolean;
{$IfNDef USE_ACBr_XMLDOCUMENT}
var
  XMLStr: String;
{$EndIf}
begin
  XMLOriginal := AXML;  // SetXMLOriginal() ir� verificar se AXML est� em UTF8

{$IfDef USE_ACBr_XMLDOCUMENT}
  FNFeR.Arquivo := XMLOriginal;
{$Else}
  { Verifica se precisa converter "AXML" de UTF8 para a String nativa da IDE.
    Isso � necess�rio, para que as propriedades fiquem com a acentua��o correta }
  XMLStr := ParseText(AXML, True, XmlEhUTF8(AXML));

  {
   ****** Remo��o do NameSpace do XML ******

   XML baixados dos sites de algumas SEFAZ constuma ter ocorr�ncias do
   NameSpace em grupos diversos n�o previstos no MOC.
   Essas ocorr�ncias acabam prejudicando a leitura correta do XML.
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
  FNFeIniR.Ambiente := Integer(FConfiguracoes.WebServices.Ambiente);
  FNFeIniR.tpEmis := FConfiguracoes.Geral.FormaEmissaoCodigo;

  FNFeIniR.LerIni(AIniString);

  GerarXML;

  Result := True;
end;

function NotaFiscal.GerarNFeIni: String;
begin
  Result := FNFeIniW.GravarIni;
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
  EnviaPDF: Boolean; sCC: TStrings; Anexos: TStrings; sReplyTo: TStrings);
var
  AnexosEmail:TStrings;
  StreamNFe : TMemoryStream;
begin
  if not Assigned(TACBrNFe(TNotasFiscais(Collection).ACBrNFe).MAIL) then
    raise EACBrNFeException.Create('Componente ACBrMail n�o associado');

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
          AnexosEmail.Add(DANFE.ArquivoPDF);
        end;
      end;

      EnviarEmail( sPara, sAssunto, sMensagem, sCC, AnexosEmail, StreamNFe,
                   NumID +'-nfe.xml', sReplyTo);
    end;
  finally
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
      Ao gerar o XML as tags e atributos tem que ser exatamente os da configura��o
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
  XMLOriginal := FNFeW.Document.Xml;  // SetXMLOriginal() ir� converter para UTF8
{$Else}
  XMLOriginal := FNFeW.Gerador.ArquivoFormatoXML;  // SetXMLOriginal() ir� converter para UTF8
{$EndIf}

  { XML gerado pode ter nova Chave e ID, ent�o devemos calcular novamente o
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

  if (NaoEstaVazio(FNomeArq) and (IdAnterior <> FNFe.infNFe.ID)) then// XML gerado pode ter nova Chave e ID, ent�o devemos calcular novamente o nome do arquivo, mantendo o PATH do arquivo carregado
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
    raise EACBrNFeException.Create('ID Inv�lido. Imposs�vel Salvar XML');

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
  { Garante que o XML informado est� em UTF8, se ele realmente estiver, nada
    ser� modificado por "ConverteXMLtoUTF8"  (mantendo-o "original") }
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
    raise EACBrNFeException.Create('Componente DANFE n�o associado.');
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

  l := Self.Count; // Indice da �ltima nota j� existente
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

  XMLStr := RemoverDeclaracaoXML(XMLStr);

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
      // Inserindo cabe�alho //
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
