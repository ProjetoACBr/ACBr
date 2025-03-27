{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Elton Barbosa                                   }
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

unit ACBrNFSeXDANFSeFPDFClass;

{$I ACBr.inc}

interface

uses
  SysUtils, 
  Classes, 
  ACBrBase, 
  ACBrNFSeXClass,
  ACBrNFSeXDANFSeClass;

type
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrNFSeXDANFSeFPDF = class(TACBrNFSeXDANFSeClass)
  private
    procedure ExecutaImpressaoPDFUmaNFSe(var UmaNFSe: TNFSe);
  protected
//    FPrintDialog: boolean;
//	  FDetalharServico : Boolean;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImprimirDANFSe(NFSe: TNFSe = nil); override;
    procedure ImprimirDANFSePDF(NFSe: TNFSe = nil); override;
  published
//    property PrintDialog: boolean read FPrintDialog write FPrintDialog;
//    property DetalharServico: Boolean read FDetalharServico write FDetalharServico default False;

  end;

implementation

uses
  ACBrUtil.Compatibilidade,
  ACBrUtil.FilesIO,
  ACBrNFSeX, ACBrNFSeXConversao, ACBr.DANFSeX.Classes, ACBrNFSeXInterface,
  ACBr.DANFSeX.FPDFA4Retrato;

constructor TACBrNFSeXDANFSeFPDF.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

//  FPrintDialog := True;
//  FDetalharServico := False;
  MargemInferior := 0;
  MargemSuperior := 0;
  MargemEsquerda := 0;
  MargemDireita  := 0;
end;

destructor TACBrNFSeXDANFSeFPDF.Destroy;
begin
  inherited Destroy;
end;

procedure TACBrNFSeXDANFSeFPDF.ImprimirDANFSe(NFSe: TNFSe = nil);
//var
//  i: Integer;
//  Notas: array of TNFSe;
begin
  ImprimirDANFSePDF(NFSe);

//  TfrlDANFSeRLRetrato.QuebradeLinha(TACBrNFSe(ACBrNFSe).Configuracoes.Geral.ConfigGeral.QuebradeLinha);
//
//  if (NFSe = nil) then
//  begin
//    SetLength(Notas, TACBrNFSe(ACBrNFSe).NotasFiscais.Count);
//
//    for i := 0 to (TACBrNFSe(ACBrNFSe).NotasFiscais.Count - 1) do
//      Notas[i] := TACBrNFSe(ACBrNFSe).NotasFiscais.Items[i].NFSe;
//  end
//  else
//  begin
//    SetLength(Notas, 1);
//    Notas[0] := NFSe;
//  end;
//
//  TfrlDANFSeRLRetrato.Imprimir(Self, Notas);
end;

procedure TACBrNFSeXDANFSeFPDF.ExecutaImpressaoPDFUmaNFSe(var UmaNFSe: TNFSe);
var
  FProvider: IACBrNFSeXProvider;
  DadosAux: TDadosNecessariosParaDANFSeX;
  Report: TACBrDANFSeFPDFA4Retrato;
  BLogoPref: TBytes;
  BLogoPres: TBytes;
begin
  FProvider := TACBrNFSeX(ACBrNFSe).Provider;

  FPArquivoPDF := DefinirNomeArquivo(Self.PathPDF, TACBrNFSeX(ACBrNFSe).NumID[UmaNFSe] + '-nfse.pdf',
    self.NomeDocumento);

  DadosAux := TDadosNecessariosParaDANFSeX.Create;
  try
    DadosAux.NaturezaOperacaoDescricao     := FProvider.NaturezaOperacaoDescricao(UmaNFSe.NaturezaOperacao);
    DadosAux.RegimeEspecialDescricao       := FProvider.RegimeEspecialTributacaoDescricao(UmaNFSe.RegimeEspecialTributacao);
    DadosAux.IssAReterDescricao            := FProvider.SituacaoTributariaDescricao(UmaNFSe.Servico.Valores.IssRetido);
    DadosAux.OptanteSimplesDescricao       := FProvider.SimNaoDescricao(UmaNFSe.OptanteSimplesNacional);
    DadosAux.IncentivadorCulturalDescricao := FProvider.SimNaoDescricao(UmaNFSe.IncentivadorCultural);
    DadosAux.QuebradeLinha                 := FProvider.ConfigGeral.QuebradeLinha;
    DadosAux.Detalhar                      := FProvider.ConfigGeral.DetalharServico;

    Report := TACBrDANFSeFPDFA4Retrato.Create(UmaNFSe);
    try
      Report.Cancelada := Cancelada;
      Report.Homologacao := TACBrNFSeX(ACBrNFSe).Configuracoes.WebServices.AmbienteCodigo <> 1;
      Report.LogoPrefeitura := Trim(Self.Logo) <> '';
      Report.LogoPrestador  := Trim(Self.Prestador.Logo) <> '';
      Report.QRCode := (Trim(UmaNFSe.Link) <> '');

      if Report.LogoPrefeitura then
      begin
        ACBrUtil.FilesIO.FileToBytes(Self.Logo, BLogoPref);
        Report.LogoPrefeituraBytes := BLogoPref;
      end;

      if Report.LogoPrestador then
      begin
        ACBrUtil.FilesIO.FileToBytes(Self.Prestador.Logo, BLogoPres);
        Report.LogoPrestadorBytes := BLogoPres;
      end;

      Report.CabecalhoLinha1 := Self.Prefeitura;
      Report.QuebraDeLinha   := DadosAux.QuebradeLinha;
      Report.MensagemRodape := Format('Impresso em %s||%s', [FormatDateTime('dd/mm/yyy HH:nn:ss', Now), Self.Sistema]);

      report.SalvarPDF(DadosAux, FPArquivoPDF);
    finally
      Report.Free;
    end;
  finally
    DadosAux.Free;
  end;
end;


procedure TACBrNFSeXDANFSeFPDF.ImprimirDANFSePDF(NFSe: TNFSe = nil);
var
  i: integer;
  UmaNFSe: TNFSe;
begin
  if NFSe = nil then
  begin
    for i := 0 to TACBrNFSeX(ACBrNFSe).NotasFiscais.Count - 1 do
    begin
      UmaNFSe := TACBrNFSeX(ACBrNFSe).NotasFiscais.Items[i].NFSe;
      ExecutaImpressaoPDFUmaNFSe(UmaNFSe);
    end;
  end
  else
  begin
    UmaNFSe := NFSe;
    ExecutaImpressaoPDFUmaNFSe(UmaNFSe);
  end;


end;

end.
