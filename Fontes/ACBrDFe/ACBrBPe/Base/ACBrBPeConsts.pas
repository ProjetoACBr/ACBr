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

unit ACBrBPeConsts;

interface

uses
  SysUtils;

const
  NAME_SPACE_BPE = 'xmlns="http://www.portalfiscal.inf.br/bpe"';

  DSC_CHBPE = 'Chave do Bilhete de Passagem Eletr�nico';
  DSC_INFQRCODEBPE = 'QR-Code do BP-e';
  DSC_BOARDPASSBPE = 'Boarding Pass do BP-e';
  DSC_MODALBPE = 'Modal do BP-e';
  DSC_TPBPE = 'Tipo de BP-e';
  DSC_INDPRESBPE = 'Indicador de Presen�a';
  DSC_UFINIBPE = 'UF de Inicio';
  DSC_CMUNINIBPE = 'C�digo do Municipio de Inicio';
  DSC_UFFIMBPE = 'UF de Fim';
  DSC_CMUNFIMBPE = 'C�digo do Municipio de Fim';
  DSC_CRTBPE = 'C�digo do Regime Tribut�rio';
  DSC_TAR = 'Termo de Autoriza��o de Servi�o Regular';
  DSC_IDESTRBPE = 'Indicador de Comprador Estrangeiro';
  DSC_TPSUB = 'Tipo de Substitui��o';
  DSC_CLOCORIG = 'C�digo do Local de Origem';
  DSC_XLOCORIG = 'Descri��o do Local de Origem';
  DSC_CLOCDEST = 'C�digo do Local de Destino';
  DSC_XLOCDEST = 'Descri��o do Local de Destino';
  DSC_DHEMB = 'Data e Hora de Embarque';
  DSC_DHVALIDADE = 'Data e Hora de Validade';
  DSC_XNOMEPASS = 'Nome do Passageiro';
  DSC_TPDOC = 'Tipo de Documento';
  DSC_NDOC = 'Numero do Documento';
  DSC_DNASC = 'Data de Nascimento';
  DSC_CPERCURSO = 'C�digo do Percurso';
  DSC_XPERCURSO = 'Descri��o do Percurso';
  DSC_TPVIAGEM = 'Tipo de Viagem';
  DSC_TPSERVICO = 'Tipo de Servi�o';
  DSC_TPACOMODACAO = 'Tipo de Acomoda��o';
  DSC_TPTRECHO = 'Tipo de Trecho';
  DSC_DHVIAGEM = 'Data e Hora da Viagem';
  DSC_DHCONEXAO = 'Data e Hora da Conex�o';
  DSC_INFVIAGEM = 'Informa��es da Viagem';
  DSC_PREFIXO = 'Prefixo da Linha';
  DSC_POLTRONA = 'Numero da Poltrona / Assento / Cabine';
  DSC_PLATAFORMA = 'Plataforma / Carro / Barco de Embarque';
  DSC_TPVEICULO = 'Tipo de Ve�culo Transportado';
  DSC_SITVEICULO = 'Situa��o do Ve�culo Transportado';
  DSC_VBP = 'Valor do Bilhete de Passagem';
  DSC_VDESCONTO = 'Valor do Desconto';
  DSC_VPGTO = 'Valor Pago';
  DSC_VTROCO = 'Valor do Troco';
  DSC_TPDESCONTO = 'Tipo de Desconto / Beneficio';
  DSC_XDESCONTO = 'Descri��o do Tipo de Desconto / Beneficio Concedido';
  DSC_TPCOMP = 'Tipo de Componente';
  DSC_VCOMP = 'Valor do Componente';
  DSC_COMP = 'Componente do Valor do Bilhete';
  DSC_VCRED = 'Valor do Cr�dito Outorgado / Presumido';
  DSC_VTOTTRIB = 'Valor Aproximado dos Tributos';
  DSC_VBCUFFIM = 'Valor da BC';
  DSC_PFCPUFFIM = 'Percentual para Fundo ao Combate a Pobreza';
  DSC_PICMSUFFIM = 'Percentual do ICMS';
  DSC_PICMSINTER = 'Percentual do ICMS Interno';
  DSC_PICMSINTERPART = 'Percentual do ICMS Interno Parte';
  DSC_VFCPUFFIM = 'Valor do Fundo ao Combate a Pobreza';
  DSC_VICMSUFFIM = 'Valor do ICMS da UF de Fim';
  DSC_VICMSUFINI = 'Valor do ICMS da UF de Inicio';
  DSC_XPAG = 'Desci��o da forma de pagamento';
  DSC_XBAND = 'Descri��o do tipo de bandeira';
  DSC_NSUTRANS = 'Numero Sequencial Unico da Transa��o';
  DSC_NSUHOST = 'Numero Sequencial Unico da Host';
  DSC_NPARCELAS = 'Numero de Parcelas';
  DSC_CDESCONTO = 'C�digo do Desconto / Beneficio Concedido';
  DSC_INFADCARD = 'Informa��es Adicionais do Cart�o de Cr�dito';
  DSC_XDOC = 'Descri��o do Documento';
  DSC_NDOCPAG = 'Numero do Documento para Pagamento';
  DSC_UFINIVIAGEM ='UF de inicio de Viagem';
  DSC_UFFIMVIAGEM = 'UF de fim de Viagem';
  DSC_NCONTINICIO = 'Contador in�cio da viagem';
  DSC_NCONTFIM = 'Contador fim da viagem';
  DSC_QPASS = 'Quantidade de Passagens da viagem';
  DSC_QCOMP = 'Quantidade do componente';
  DSC_DCOMPET = 'Data de Competencia';

  DSC_IEST = 'Inscri��o Estadual do Substituto tribut�rio';
  DSC_CNAE = 'Classifica��o Nacional de Atividades Econ�micas';
  DSC_VBC = 'Valor da BC do ICMS';
  DSC_PICMS = 'Al�quota do imposto';
  DSC_VICMS = 'Valor do ICMS';
  DSC_PREDBC = 'Percentual da Redu��o de BC';
  DSC_VICMSDESON = 'Valor do ICMS Desonera��o';
  DSC_CBENEF = 'C�digo de Benef�cio Fiscal na UF aplicado';

  DSC_TPAG = 'Forma de Pagamento';
  DSC_VPAG = 'Valor do Pagamento';
  DSC_TPINTEGRA = 'Tipo de Integra��o para pagamento';
  DSC_TBAND = 'Bandeira da Operadora de Cart�o';
  DSC_CAUT = 'N�mero da Autoriza��o';

  DSC_PLACA = 'Placa do Ve�culo';

  // Reforma Tribut�ria
  DSC_TPCOMPRAGOV = 'Tipo de compra governamental';
  DSC_PREDUTOR = 'Percentual de redu��o de aliquota em compra governamental';
  DSC_CCLASSTRIB = 'C�digo de Classifica��o Tribut�ria do IBS e CBS';
  DSC_PIBSUF = 'Al�quota do IBS de compet�ncia das UF';
  DSC_VTRIBOP = 'Valor bruto do tributo na opera��o';
  DSC_PDIF = 'Percentual de diferimento';
  DSC_VDIF = 'Valor do Diferimento';
  DSC_VCBSOP = 'Valor da CBS Bruto na opera��o';
  DSC_VDEVTRIB = 'Valor do tributo devolvido';
  DSC_PREDALIQ = 'Percentual da redu��o de al�quota';
  DSC_PALIQEFET = 'Aliquota Efetiva do IBS de compet�ncia das UF que ser� aplicada a Base de C�lculo';
  DSC_PALIQ = 'Valor da al�quota';
  DSC_VTRIBREG = 'Valor do Tributo';
  DSC_VIBSUF = 'Valor do IBS de compet�ncia da UF';
  DSC_VIBS = 'Valor da IBS';
  DSC_PCBS = 'Al�quota da CBS';
  DSC_VCBS = 'Valor da CBS';
  DSC_CCREDPRES = 'C�digo de Classifica��o do Cr�dito Presumido';
  DSC_PCREDPRES = 'Percentual do Cr�dito Presumido';
  DSC_VCREDPRES = 'Valor do Cr�dito Presumido';
  DSC_VCREDPRESCONDSUS = 'Valor do Cr�dito Presumido em condi��o suspensiva.';

  DSC_VTOTDEF = 'Valor total do documento fiscal';

  DSC_VBCCIBS = 'Total da Base de c�lculo do IBS/CBS';
  DSC_VIBSMUN = 'Total do IBS Municipal';
  DSC_VIBSTOT = 'Total do IBS (IBS UF + IBS Mun)';

implementation

end.

