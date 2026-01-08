{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit SilTecnologia.LerXml;

interface

uses
  SysUtils, Classes, StrUtils, IniFiles,
  ACBrNFSeXLerXml_ABRASFv1,
  ACBrNFSeXLerXml_ABRASFv2,
  PadraoNacional.LerXml;

type
  { TNFSeR_SilTecnologia }

  TNFSeR_SilTecnologia = class(TNFSeR_ABRASFv1)
  protected

  public

  end;

  { TNFSeR_SilTecnologia203 }

  TNFSeR_SilTecnologia203 = class(TNFSeR_ABRASFv2)
  protected

  public

  end;

  { TNFSeR_SilTecnologiaAPIPropria }

  TNFSeR_SilTecnologiaAPIPropria = class(TNFSeR_PadraoNacional)
  protected
    //====== Ler o Arquivo INI===========================================
    procedure LerINIDadosEmitente(AINIRec: TMemIniFile); override;
  public

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     SilTecnologia
//==============================================================================

{ TNFSeR_SilTecnologiaAPIPropria }

procedure TNFSeR_SilTecnologiaAPIPropria.LerINIDadosEmitente(AINIRec: TMemIniFile);
begin
  inherited LerINIDadosEmitente(AINIRec);
  NFSe.Emitente.IdentificacaoPrestador.CpfCnpj := NFSe.infNFSe.emit.Identificacao.CpfCnpj;
  NFSe.Emitente.IdentificacaoPrestador.InscricaoMunicipal := NFSe.infNFSe.emit.Identificacao.InscricaoMunicipal;
  NFSe.Emitente.RazaoSocial := NFSe.infNFSe.emit.RazaoSocial;
  NFSe.Emitente.NomeFantasia := NFSe.infNFSe.emit.NomeFantasia;
  NFSe.Emitente.Endereco.Endereco := NFSe.infNFSe.emit.Endereco.Endereco;
  NFSe.Emitente.Endereco.Numero := NFSe.infNFSe.emit.Endereco.Numero;
  NFSe.Emitente.Endereco.Complemento := NFSe.infNFSe.emit.Endereco.Complemento;
  NFSe.Emitente.Endereco.Bairro := NFSe.infNFSe.emit.Endereco.Bairro;
  NFSe.Emitente.Endereco.CodigoMunicipio := NFSe.infNFSe.emit.Endereco.CodigoMunicipio;
  NFSe.Emitente.Endereco.UF := NFSe.infNFSe.emit.Endereco.UF;
  NFSe.Emitente.Endereco.CEP := NFSe.infNFSe.emit.Endereco.CEP;
  NFSe.Emitente.Contato.Telefone := NFSe.infNFSe.emit.Contato.Telefone;
  NFSe.Emitente.Contato.Email := NFSe.infNFSe.emit.Contato.Email;
end;

end.
