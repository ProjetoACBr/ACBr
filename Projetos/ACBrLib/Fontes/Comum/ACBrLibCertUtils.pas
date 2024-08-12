{******************************************************************************}
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

unit ACBrLibCertUtils;
  
interface
 
uses
  Classes, SysUtils,
  ACBrDFeSSL, ACBrUtil.Strings, ACBrUtil.DateTime;

const
  CCertFormat = '%s|%s|%s|%s|%s|%s|%s';
 
function ObterCerticados(const SSL: TDFeSSL): ansistring;

implementation

function ObterCerticados(const SSL: TDFeSSL): ansistring;
var
  I: Integer;
begin
  Result := '';
  If SSL.SSLCryptLib in [cryCapicom, cryWinCrypt] then
    SSL.LerCertificadosStore
  else
  begin
    with SSL do
    begin
      CarregarCertificado;
      Result := Format(CCertFormat, [CertNumeroSerie, CertRazaoSocial, CertCNPJ, FormatDateBr(CertDataVenc),
                                     CertCertificadora, CertSubjectName, CertIssuerName]) + sLineBreak;
    end;
  end;

  for I := 0 to SSL.ListaCertificados.Count-1 do
  begin
    with SSL.ListaCertificados[I] do
    begin
      if (CNPJ <> '') then
      begin
        Result := Result + Format(CCertFormat, [NumeroSerie, RazaoSocial, CNPJ, FormatDateBr(DataVenc),
                                                Certificadora, SubjectName, IssuerName]) + sLineBreak;
      end;
    end;
  end;
end;

end.
