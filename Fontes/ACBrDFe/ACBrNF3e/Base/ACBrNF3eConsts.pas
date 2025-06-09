{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit ACBrNF3eConsts;

interface

uses
  SysUtils;

const
  NAME_SPACE_NF3e = 'xmlns="http://www.portalfiscal.inf.br/nf3e"';

  DSC_INFQRCODE = 'Texto com o QR-Code impresso no DANF3e NF3-e.';
  DSC_FINNF3e = 'Finalidade de emiss�o da NF3e';
  DSC_IDESTR = 'Documento de Identifica��o do Estrangeiro';
  DSC_INDIEDEST = 'Indicador da IE do Destinat�rio';
  DSC_IDACESSO = 'C�digo de Identifica��o da Unidade Consumidora';
  DSC_IDCODCLIENTE = 'C�digo de Identifica��o do Cliente';
  DSC_TPACESSO = 'Tipo de Acessante';
  DSC_XNOMEUC = 'Nome da Unidade Consumidora';
  DSC_TPCLASSE = 'Classe de Consumo da Unidade Consumidora';
  DSC_TPSUBCLASSE = 'Subclasse de Consumo da Unidade Consumidora';
  DSC_TPFASE = 'Tipo de Liga��o';
  DSC_TPGRPTENSAO = 'Grupo e Subgrupo de Tens�o';
  DSC_TPMODTAR = 'Modalidade Tarif�ria';
  DSC_LATGPS = 'Latitude da localiza��o da captura';
  DSC_LONGGPS = 'Longitude da localiza��o da captura';
  DSC_CHNF3E = 'Chave da NF3e Referenciada';
  DSC_COMPETEMIS = 'Ano e M�s da Emiss�o da NF';
  DSC_COMPETAPUR = 'Ano e M�s da Apura��o';
  DSC_HASH115 = 'Hash do registro no arquivo do conv�nio 115';
  DSC_MOTSUB = 'Motivo da Substitui��o';
  DSC_NCONTRAT = 'Numero de Refer�ncia da quantidade contratada';
  DSC_TPGRCONTRAT = 'Tipo de Grandeza Contratada';
  DSC_TPPOSTAR = 'Tipo de Posto Tarif�rio Contratado';
  DSC_QUNIDCONTRAT = 'Quantidade Contratada em kW ou kWh';
  DSC_NMED = 'Numero de Refer�ncia da medi��o';
  DSC_IDMEDIDOR = 'Identifica��o do Medidor';
  DSC_DMEDANT = 'Data da leitura anterior';
  DSC_DMEDATU = 'Data da leitura atual';
  DSC_TPPARTCOMP = 'Tipo de Participa��o no Sistema de Compensa��o';
  DSC_VPOTINST = 'Pot�ncia Instalada em kW';
  DSC_IDACESSGER = 'C�digo �nico de identifica��o da Unidade Geradora';
  DSC_ENERALOC = 'Energia Alocada';
  DSC_VSALDANT = 'Saldo Anterior';
  DSC_VCREDEXPIRADO = 'Cr�ditos Expirados';
  DSC_VSALDATUAL = 'Saldo Atual';
  DSC_VCREDEXPIRAR = 'Cr�ditos a Expirar';
  DSC_COMPETEXPIRAR = 'AAAA/MM que ocorr� a expira��o';
  DSC_TPAJUSTE = 'Tipo de Ajuste';
  DSC_MOTAJUSTE = 'Motivo do Ajuste';
  DSC_QFATURADA = 'Quantidade Faturada';
  DSC_CCLASS = 'C�digo de Classifica��o';
  DSC_NITEMANT = 'Numero do Item Anterior';
  DSC_DINITARIF = 'Data de Inicio';
  DSC_DFIMTARIF = 'Data de Fim';
  DSC_TPATO = 'Tipo de Ato da ANEEL';
  DSC_NATO = 'Numero do Ato';
  DSC_ANOATO = 'Ano do Ato';
  DSC_TPTARIF = 'Tarifa de Aplica��o';
  DSC_CPOSTARIF = 'Tipo de Posto Tarif�rio';
  DSC_UMED = 'Unidade de Medida';
  DSC_VTARIFHOM = 'Valor da Tarifa Homologada';
  DSC_VTARIFAPLIC = 'Valor da Trarifa Aplicada';
  DSC_MOTDIFTARIF = 'Motivo da Diferen�a de Tarifa';
  DSC_TPBAND = 'Tipo de Bandeira';
  DSC_VADBAND = 'Valor do Adicional';
  DSC_VADBANDAPLIC = 'Valor Adicional Aplicado';
  DSC_MOTDIFBAND = 'Motivo da Diferen�a do Adicional';
  DSC_XGRANDFAT = 'Nome da Grandeza Faturada';
  DSC_COMPETFAT = 'Ano e M�s do Faturamento';
  DSC_VFAT = 'Valor Faturado';
  DSC_DAPRESFAT = 'Data Apresenta��o da Fatura';
  DSC_DPROXLEITURA = 'Data Prevista Pr�xima Leitura';
  DSC_CODBARRAS = 'C�digo de Barras';
  DSC_CODDEBAUTO = 'C�digo de Autoriza��o de D�bito em Conta';
  DSC_CODBANCO = 'Numero do Banco para D�bito em Conta';
  DSC_CODAGENCIA = 'Numero da Ag�ncia Banc�ria para D�bito em Conta';
  DSC_VICMSDESON = 'Valor Total do ICMS Desonerado';
  DSC_VFCP = 'Valor Total do Fundo de Combate a Pobreza';
  DSC_VFCPST = 'Valor Total do FCP retido por Substitui��o Tribut�ria';
  DSC_INDORIGEMQTD = 'Indicador da Origem da Quantidade Faturada';
  DSC_TPGRMED = 'Tipo de Grandeza Medida';
  DSC_VMEDANT = 'Valor da Medi��o Anterior';
  DSC_VMEDATU = 'Valor da Medi��o Atual';
  DSC_VCONST = 'Fator de Multiplica��o do Medidor';
  DSC_VMED = 'Valor da Medi��o';
  DSC_PPERDATRAN = 'Percentual da Perda de Transforma��o';
  DSC_VMEDPERDATRAN = 'Valor Medido ap�s perda de Transforma��o';
  DSC_VMEDPERDATEC = 'Valor Medido ap�s perda T�cnica';
  DSC_TPMOTNAOLEITURA = 'Tipo do Motivo da n�o Leitura';
  DSC_PFCP = 'Percentual do Fundo de Combate a Pobreza';
  DSC_PICMSST = 'Percentual do ICMS ST';
  DSC_VICMSST = 'Valor do ICMS ST';
  DSC_PFCPST = 'Percentual do Fundo de Combate a Pobreza ST';
  DSC_CBENEF = 'C�digo de Beneficio Fiscal';
  DSC_TPPROC = 'Tipo de Processo';
  DSC_CCONTAB = 'Numero da Conta Cont�bil';
  DSC_XCONTAB = 'Descri��o da Conta Cont�bil';
  DSC_VCONTAB = 'Valor do Lan�amento na Conta Cont�bil';
  DSC_TPLANC = 'Tipo de Lan�amento Cont�bil';
  DSC_CODROTEIROLEITURA = 'C�digo de Roteiro de Leitura';
  DSC_CNIS = 'Numero da Identifica��o Social - NIS';
  DSC_NB = 'Numero do Beneficio';
  DSC_VRETPIS = 'Valor do PIS Retido';
  DSC_VRETCOFINS = 'Valor do COFINS Retido';
  DSC_VRETCSLL = 'Valor do CSLL Retido';
  DSC_VBCIRRF = 'Base de C�lculo do IRRF';
  DSC_VIRRF = 'Valor do IRRF Retido';
  DSC_VCOFINSEfet = 'Total do Valor Efetivo do COFINS';
  DSC_VPISEfet = 'Total do Valor Efetivo do PIS';
  DSC_URLQRCODEPIX = 'URL do QRCode do PIX';
  DSC_TPFONTEENERGIA = 'Tipo da fonte de energia utilizada';
  DSC_NSITEAUTORIZ = 'Numero do Site de Autoriza��o';

  DSC_ULTNSU = '�ltimo NSU recebido pela Empresa';
  DSC_NSU = 'NSU espec�fico';

  DSC_CMUNFG = 'C�digo do Munic�pio FG';
  DSC_VITEM = 'Valor l�quido do Item';
  DSC_VPROD = 'Valor Total Bruto dos Produtos ou Servi�os';
  DSC_VBC = 'Valor da BC do ICMS';
  DSC_PICMS = 'Al�quota do imposto';
  DSC_VICMS = 'Valor do ICMS';
  DSC_VBCST = 'Valor da BC do ICMS ST';
  DSC_VPIS = 'Valor do PIS';
  DSC_VCOFINS = 'Valor do COFINS';
  DSC_INFADPROD = 'Informa��es adicionais do Produto';
  DSC_CPROD = 'C�digo do produto ou servi�o';
  DSC_XPROD = 'Descri��o do Produto ou Servi�o';
  DSC_PREDBC = 'Percentual da Redu��o de BC';
  DSC_PPIS = 'Al�quota do PIS (em percentual)';
  DSC_PCOFINS = 'Al�quota da COFINS (em percentual)';
  DSC_NPROCESSO = 'N�mero do Processo';
  DSC_VST = 'Valor TOTAL Icms substitui��o Tribut�ria';
  DSC_DVENC = 'Data de vencimento';
  DSC_NFAT = 'N�mero da fatura';
  DSC_QTDE = 'Quantidade';
  DSC_VBCSTRET = 'Valor da BC do ICMS ST Retido';
  DSC_PICMSSTRET = 'Al�quota do ICMS Substitui��o Tributaria Retido';
  DSC_VICMSSTRET = 'Valor do ICMS Substitui��o Tributaria Retido';
  DSC_VBCFCPST = 'Valor da Base de C�lculo do FCP por Substitui��o Tribut�ria';
  DSC_PFCPSTRET = 'Percentual do FCP retido anteriormente por Substitui��o Tribut�ria';
  DSC_VFCPSTRET = 'Valor do FCP retido por Substitui��o Tribut�ria';
  DSC_PREDBCEFET = 'Percentual de redu��o da base de c�lculo efetiva';
  DSC_VBCEFET = 'Valor da base de c�lculo efetiva';
  DSC_PICMSEFET = 'Al�quota do ICMS efetiva';
  DSC_VICMSEFET = 'Valor do ICMS efetivo';

implementation

end.

