{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrANe.Consts;

interface

uses
  SysUtils;

resourcestring
  // Códigos e Descrições das mensagens
  Cod001 = 'X001';
  Desc001 = 'Serviço não implementado pela Seguradora.';
  Cod002 = 'X002';
  Desc002 = 'Nenhum DF-e adicionado ao componente.';
  Cod003 = 'X003';
  Desc003 = 'Conjunto de DF-e transmitidos (máximo de xxx RPS) excedido. Quantidade atual: yyy';

  Cod126 = 'X126';
  Desc126	= 'Chave do DFe não informada.';

  Cod201 = 'X201';
  Desc201 = 'WebService retornou um XML vazio.';

  Cod800 = 'X800';
  Desc800 = 'Erro de Validação: ';
  Cod801 = 'X801';
  Desc801 = 'Erro ao Assinar: ';

  Cod999 = 'X999';
  Desc999 = 'Erro de Conexão: ';

implementation

end.

