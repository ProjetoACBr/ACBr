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

unit ACBrANe.Consts;

interface

uses
  SysUtils;

resourcestring
  // C�digos e Descri��es das mensagens
  Cod001 = 'X001';
  Desc001 = 'Servi�o n�o implementado pela Seguradora.';
  Cod002 = 'X002';
  Desc002 = 'Nenhum DF-e adicionado ao componente.';
  Cod003 = 'X003';
  Desc003 = 'Conjunto de DF-e transmitidos (m�ximo de xxx RPS) excedido. Quantidade atual: yyy';
  {
  Cod004 = 'X004';
  Desc004 = 'Nenhum Evento adicionado ao componente';
  Cod005 = 'X005';
  Desc005 = 'Conjunto de RPS transmitidos (m�nimo de xxx RPS). Quantidade atual: yyy';

  Cod101 = 'X101';
  Desc101 = 'N�mero do Protocolo n�o informado.';
  Cod102 = 'X102';
  Desc102 = 'N�mero do RPS n�o informado.';
  Cod103 = 'X103';
  Desc103 = 'S�rie do Rps n�o informada.';
  Cod104 = 'X104';
  Desc104 = 'Tipo do Rps n�o informado.';
  Cod105 = 'X105';
  Desc105 = 'N�mero Inicial da NFSe n�o informado.';
  Cod106 = 'X106';
  Desc106 = 'N�mero Final da NFSe n�o informado.';
  Cod107 = 'X107';
  Desc107 = 'Pedido de Cancelamento n�o informado.';
  Cod108 = 'X108';
  Desc108 = 'N�mero da NFSe n�o informado.';
  Cod109 = 'X109';
  Desc109 = 'C�digo de Cancelamento n�o informado.';
  Cod110 = 'X110';
  Desc110 = 'Motivo do Cancelamento n�o informado.';
  Cod111 = 'X111';
  Desc111 =	'N�mero do Lote n�o informado.';
  Cod112 = 'X112';
  Desc112 = 'S�rie da NFSe n�o informada.';
  Cod113 = 'X113';
  Desc113 = 'Valor da NFSe n�o informado.';
  Cod114 = 'X114';
  Desc114	= 'Tipo da NFSe n�o informado.';
  Cod115 = 'X115';
  Desc115	= 'Data Inicial n�o informada.';
  Cod116 = 'X116';
  Desc116 =	'Data Final n�o informada.';
  Cod117 = 'X117';
  Desc117 = 'C�digo de Verifica��o/Valida��o n�o informado.';
  Cod118 = 'X118';
  Desc118	= 'Chave da NFSe n�o informada.';
  Cod119 = 'X119';
  Desc119	= 'Emitente.WSUser n�o informado.';
  Cod120 = 'X120';
  Desc120	= 'Emitente.WSSenha n�o informada.';
  Cod121 = 'X121';
  Desc121	= 'Cadastro Econ�mico n�o informado.';
  Cod122 = 'X122';
  Desc122 = 'Data Emiss�o da NFSe n�o informada.';
  Cod123 = 'X123';
  Desc123 = 'C�digo do Servi�o n�o informado.';
  Cod124 = 'X124';
  Desc124	= 'Emitente.WSChaveAcesso n�o informada.';
  Cod125 = 'X125';
  Desc125	= 'Emitente.WSChaveAutoriz n�o informada.';
  Cod127 = 'X127';
  Desc127	= 'CNPJ do Tomador n�o informado.';
  Cod128 = 'X128';
  Desc128	= 'NSU n�o informado.';
  Cod129 = 'X129';
  Desc129	= 'Emitente.InscMun n�o informada.';
  Cod130 = 'X130';
  Desc130	= 'Emitente.CNPJ n�o informado.';
  Cod131 = 'X131';
  Desc131 =	'Data de Competencia n�o informada.';
  Cod132 = 'X132';
  Desc132 =	'P�gina de retorno da consulta n�o informada.';
  Cod133 = 'X133';
  Desc133	= 'Geral.CNPJPrefeitura n�o informado.';

  Cod202 = 'X202';
  Desc202 = 'Lista de NFSe n�o encontrada! (ListaNfse)';
  Cod203 = 'X203';
  Desc203 = 'N�o foi retornado nenhuma NFSe.';
  Cod204 = 'X204';
  Desc204 = 'Confirma��o do Cancelamento n�o encontrada.';
  Cod205 = 'X205';
  Desc205 = 'Retorno da Substitui��o n�o encontrado.';
  Cod206 = 'X206';
  Desc206 = 'Nfse Substituida n�o encontrada.';
  Cod207 = 'X207';
  Desc207 = 'Nfse Substituidora n�o encontrada.';
  Cod208 = 'X208';
  Desc208	= 'N�o foi retornado nenhum Rps.';
  Cod209 = 'X209';
  Desc209 = 'Retorno do Cancelamento n�o encontrado.';
  Cod210 = 'X210';
  Desc210 = 'Nfse do Cancelamento n�o encontrada.';
  Cod211 = 'X211';
  Desc211 = 'N�o foi retornado nenhum Evento.';
  Cod212 = 'X212';
  Desc212 = 'N�o foi retornado nenhum JSON.';
  Cod213 = 'X213';
  Desc213 = 'N�o foi retornado nenhum Token.';
  }
  Cod126 = 'X126';
  Desc126	= 'Chave do DFe n�o informada.';

  Cod201 = 'X201';
  Desc201 = 'WebService retornou um XML vazio.';

  Cod800 = 'X800';
  Desc800 = 'Erro de Valida��o: ';
  Cod801 = 'X801';
  Desc801 = 'Erro ao Assinar: ';

  Cod999 = 'X999';
  Desc999 = 'Erro de Conex�o: ';

implementation

end.

