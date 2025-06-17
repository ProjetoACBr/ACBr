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

{$I ACBr.inc}

unit ACBrNFSeXDANFSeRLClass;

interface

uses
  SysUtils, Classes,
  ACBrBase,
  ACBrNFSeXClass, ACBrNFSeXDANFSeClass;

type
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrNFSeXDANFSeRL = class(TACBrNFSeXDANFSeClass)
  private
    FTamanhoLogoWidth: Integer;
    FTamanhoLogoHeight: Integer;
  protected
    FDetalharServico: Boolean;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDANFSe(NFSe: TNFSe = nil); override;
    procedure ImprimirDANFSePDF(NFSe: TNFSe = nil); overload; override;
    procedure ImprimirDANFSePDF(AStream: TStream; NFSe: TNFSe = nil); overload; override;

  published
    property DetalharServico: Boolean read FDetalharServico write FDetalharServico default False;
    property TamanhoLogoHeight: Integer read FTamanhoLogoHeight write FTamanhoLogoHeight default 0;
    property TamanhoLogoWidth: Integer read FTamanhoLogoWidth write FTamanhoLogoWidth default 0;
  end;

implementation

uses
  ACBrUtil.FilesIO,
  ACBrNFSeX, ACBrNFSeXConversao, ACBrNFSeXDANFSeRL,
  ACBrNFSeXDANFSeRLRetrato, ACBrNFSeXDANFSeRLSimplISS, ACBrNFSeXDANFSeRLISSNet;

constructor TACBrNFSeXDANFSeRL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDetalharServico := False;
  FTamanhoLogoHeight := 0;
  FTamanhoLogoWidth := 0;
end;

destructor TACBrNFSeXDANFSeRL.Destroy;
begin
  inherited Destroy;
end;

procedure TACBrNFSeXDANFSeRL.ImprimirDANFSe(NFSe: TNFSe);
var
  i: Integer;
  Notas: array of TNFSe;
  fqrXDANFSeRLRetrato: TfrlXDANFSeRL;
begin
  SetDadosPrestador;
  Provedor := TACBrNFSeX(ACBrNFSe).Configuracoes.Geral.Provedor;

  case Provedor of
    proSimplISS:
      fqrXDANFSeRLRetrato := TfrlXDANFSeRLSimplISS.Create(Self);
    proIssNet:
      fqrXDANFSeRLRetrato := TfrlXDANFSeRLISSNet.Create(Self);
  else
    fqrXDANFSeRLRetrato := TfrlXDANFSeRLRetrato.Create(Self);
  end;

  fqrXDANFSeRLRetrato.QuebradeLinha(TACBrNFSeX(ACBrNFSe).Provider.ConfigGeral.QuebradeLinha);

  if (NFSe = nil) then
  begin
    SetLength(Notas, TACBrNFSeX(ACBrNFSe).NotasFiscais.Count);

    for i := 0 to (TACBrNFSeX(ACBrNFSe).NotasFiscais.Count - 1) do
    begin
//      SetDadosTomador(i);
      Notas[i] := TACBrNFSeX(ACBrNFSe).NotasFiscais.Items[i].NFSe;
    end;
  end
  else
  begin
    SetDadosTomador(0);
    SetLength(Notas, 1);
    Notas[0] := NFSe;
  end;

  fqrXDANFSeRLRetrato.Imprimir(Self, Notas);

  fqrXDANFSeRLRetrato.Free;
end;

procedure TACBrNFSeXDANFSeRL.ImprimirDANFSePDF(NFSe: TNFSe);
var
  i: integer;
  fqrXDANFSeRLRetrato: TfrlXDANFSeRL;
begin
  SetDadosPrestador;
  Provedor := TACBrNFSeX(ACBrNFSe).Configuracoes.Geral.Provedor;

  case Provedor of
    proSimplISS:
      fqrXDANFSeRLRetrato := TfrlXDANFSeRLSimplISS.Create(Self);
    proIssNet:
      fqrXDANFSeRLRetrato := TfrlXDANFSeRLISSNet.Create(Self);
  else
    fqrXDANFSeRLRetrato := TfrlXDANFSeRLRetrato.Create(Self);
  end;

  fqrXDANFSeRLRetrato.QuebradeLinha(TACBrNFSeX(ACBrNFSe).Provider.ConfigGeral.QuebradeLinha);

  if NFSe = nil then
  begin
    for i := 0 to TACBrNFSeX(ACBrNFSe).NotasFiscais.Count - 1 do
    begin
      SetDadosTomador(i);
      FPArquivoPDF := DefinirNomeArquivo(Self.PathPDF,
       TACBrNFSeX(ACBrNFSe).NumID[TACBrNFSeX(ACBrNFSe).NotasFiscais.Items[i].NFSe] + '-nfse.pdf',
       self.NomeDocumento);

      fqrXDANFSeRLRetrato.SalvarPDF(Self, TACBrNFSeX(ACBrNFSe).NotasFiscais.Items[i].NFSe, FPArquivoPDF);
    end;
  end
  else
  begin
    SetDadosTomador(0);
    FPArquivoPDF := DefinirNomeArquivo(Self.PathPDF,
     TACBrNFSeX(ACBrNFSe).NumID[NFSe] + '-nfse.pdf', self.NomeDocumento);

    fqrXDANFSeRLRetrato.SalvarPDF(Self, NFSe, FPArquivoPDF);
  end;

  fqrXDANFSeRLRetrato.Free;
end;

procedure TACBrNFSeXDANFSeRL.ImprimirDANFSePDF(AStream: TStream; NFSe: TNFSe);
var
  i: integer;
  fqrXDANFSeRLRetrato: TfrlXDANFSeRL;
begin
  SetDadosPrestador;
  Provedor := TACBrNFSeX(ACBrNFSe).Configuracoes.Geral.Provedor;

  case Provedor of
    proSimplISS:
      fqrXDANFSeRLRetrato := TfrlXDANFSeRLSimplISS.Create(Self);
    proIssNet:
      fqrXDANFSeRLRetrato := TfrlXDANFSeRLISSNet.Create(Self);
  else
    fqrXDANFSeRLRetrato := TfrlXDANFSeRLRetrato.Create(Self);
  end;

  fqrXDANFSeRLRetrato.QuebradeLinha(TACBrNFSeX(ACBrNFSe).Provider.ConfigGeral.QuebradeLinha);

  if NFSe = nil then
  begin
    for i := 0 to TACBrNFSeX(ACBrNFSe).NotasFiscais.Count - 1 do
    begin
      SetDadosTomador(i);
      fqrXDANFSeRLRetrato.SalvarPDF(Self, TACBrNFSeX(ACBrNFSe).NotasFiscais.Items[i].NFSe, AStream);
    end;
  end
  else
  begin
    SetDadosTomador(0);
    fqrXDANFSeRLRetrato.SalvarPDF(Self, NFSe, AStream);
  end;

  fqrXDANFSeRLRetrato.Free;
end;

end.
