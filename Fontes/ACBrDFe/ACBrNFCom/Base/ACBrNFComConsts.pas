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

unit ACBrNFComConsts;

interface

uses
  SysUtils;

const
  CODIGO_BRASIL = 1058;
  CMUN_EXTERIOR = 9999999;
  ENCODING_UTF8 = '?xml version="1.0" encoding="UTF-8"?';
  XMUN_EXTERIOR = 'EXTERIOR';
  UF_EXTERIOR = 'EX';

resourcestring
  NAME_SPACE_NFCom = 'xmlns="http://www.portalfiscal.inf.br/nfcom"';

  // Descri��o de Mensagens de Erro - Futuramente vai para a unit ACBrDFeConsts
  ERR_MSG_MAIOR = 'Tamanho maior que o m�ximo permitido';
  ERR_MSG_MENOR = 'Tamanho menor que o m�nimo permitido';
  ERR_MSG_VAZIO = 'Nenhum valor informado';
  ERR_MSG_INVALIDO = 'Conte�do inv�lido';
  ERR_MSG_MAXIMO_DECIMAIS = 'Numero m�ximo de casas decimais permitidas';
  ERR_MSG_GERAR_CHAVE = 'Erro ao gerar a chave da DFe!';
  ERR_MSG_FINAL_MENOR_INICIAL = 'O numero final n�o pode ser menor que o inicial';
  ERR_MSG_ARQUIVO_NAO_ENCONTRADO = 'Arquivo n�o encontrado';
  ERR_MSG_SOMENTE_UM = 'Somente um campo deve ser preenchido';
  ERR_MSG_MAIOR_MAXIMO = 'N�mero de ocorr�ncias maior que o m�ximo permitido - M�ximo ';
  ERR_MSG_MENOR_MINIMO = 'N�mero de ocorr�ncias menor que o m�nimo permitido - M�nimo ';

  // Descri��o de Identifica��o do Documento Fiscal - Futuramente vai para a unit ACBrDFeConsts
  DSC_TPAMB = 'Identifica��o do Ambiente';
  DSC_CUF = 'C�digo IBGE da UF';
  DSC_DHEMI = 'Data e Hora de Emiss�o';
  DSC_DEMI = 'Data de emiss�o';
  DSC_HEMI = 'Hora de emiss�o';
  DSC_TPEMIS = 'Tipo de Emiss�o';
  DSC_VERPROC = 'Vers�o do processo de emiss�o';
  DSC_DHCONT = 'Data e Hora da entrada em conting�ncia';
  DSC_XJUSTCONT = 'Justificativa da entrada em conting�ncia';
  DSC_QRCODNFCOM = 'Texto com o QR-Code para consulta';
  DSC_CHAVESEGURANCA = 'Chave de seguran�a';

  // Descri��o de Documentos Fiscais - Futuramente vai para a unit ACBrDFeConsts
  DSC_MOD = 'Modelo do Documento Fiscal';
  DSC_NDF = 'Numero do Documento Fiscal';
  DSC_SERIE = 'S�rie do Documento Fiscal';
  DSC_CDF = 'C�digo do Documento Fiscal';
  DSC_CDV = 'Digito Verificador';

  // Descri��o de Dados da Pessoa F�sica ou Jur�dica - Futuramente vai para a unit ACBrDFeConsts
  DSC_CRT = 'C�digo de Regime Tribut�rio';
  DSC_XNOME = 'Raz�o social ou Nome';
  DSC_XFANT = 'Nome fantasia';
  DSC_XLGR = 'Logradouro';
  DSC_NRO = 'N�mero do Logradouro';
  DSC_XCPL = 'Complemento';
  DSC_XBAIRRO = 'Bairro';
  DSC_CMUN = 'C�digo IBGE do munic�pio';
  DSC_XMUN = 'Nome do munic�pio';
  DSC_CEP = 'CEP';
  DSC_UF = 'Sigla da UF';
  DSC_CPAIS = 'C�digo do Pa�s';
  DSC_XPAIS = 'Nome do Pa�s';
  DSC_FONE = 'Telefone';
  DSC_EMAIL = 'Endere�o de E-mail';

  // Descri��o de Documentos - Futuramente vai para a unit ACBrDFeConsts
  DSC_CNPJ = 'CNPJ(MF)';
  DSC_CPF = 'CPF';
  DSC_IE = 'Inscri��o Estadual';
  DSC_IM = 'Inscri��o Municipal';

  // Descri��o de Informa��es do Contribuinte/Fisco - Futuramente vai para a unit ACBrDFeConsts
  DSC_XOBS = 'Observa��o';
  DSC_INFADFISCO = 'Informa��es adicionais de interesse do Fisco';
  DSC_INFCPL = 'Informa��es complementares de interesse do Contribuinte';

  // Descri��o de Dados do Respons�vel T�cnico - Futuramente vai para a unit ACBrDFeConsts
  DSC_XCONTATO = 'Nome da pessoa a ser contatada';
  DSC_IDCSRT = 'Identificador do c�digo de seguran�a do respons�vel t�cnico';
  DSC_HASHCSRT = 'Hash do token do c�digo de seguran�a do respons�vel t�cnico';
  DSC_CFOP = 'CFOP';
  DSC_VITEM = 'Valor unit�rio do item ';
  DSC_VDESC = 'Valor do Desconto';
  DSC_VOUTRO = 'Outras despesas acess�rias ';
  DSC_VPROD = 'Valor total do item';
  DSC_CST = 'Classifica��o Tribut�ria';
  DSC_VBC = 'Valor da Base de Calculo';
  DSC_PICMS = 'Al�quota do ICMS';
  DSC_VICMS = 'Valor do ICMS';
  DSC_PFCP = 'Percentual de ICMS relativo ao Fundo de Combate � Pobreza (FCP)';
  DSC_VFCP = 'Valor do ICMS relativo ao Fundo de Combate � Pobreza (FCP)';
  DSC_PREDBC = 'Percentual de redu��o da Base de Calculo';
  DSC_VICMSDESON = 'Valor do ICMS de desonera��o';
  DSC_CBENEF = 'C�digo de Benef�cio Fiscal na UF aplicado ao item';
  DSC_VBCUFDEST = 'Valor da BC do ICMS na UF de destino';
  DSC_PFCPUFDEST = 'Percentual do ICMS relativo ao Fundo de Combate � pobreza (FCP) na UF de destino';
  DSC_PICMSUFDEST = 'Al�quota interna da UF de destino';
  DSC_VFCPUFDEST = 'Valor do ICMS relativo ao Fundo de Combate � Pobreza (FCP) da UF de destino';
  DSC_VICMSUFDEST = 'Valor do ICMS de partilha para a UF de destino';
  DSC_VICMSUFEMI = 'Valor do ICMS de partilha para a UF de emiss�o';
  DSC_PPIS = 'Al�quota do PIS';
  DSC_VPIS = 'Valor do PIS';
  DSC_PCOFINS = 'Al�quota do COFINS';
  DSC_VCOFINS = 'Valor do COFINS';
  DSC_VNF = 'Valor Total do Documento';
  DSC_DVENC = 'Data de vencimento';

  DSC_NSITEAUTORIZ = 'Numero do Site de Autoriza��o';
  DSC_FINNFCom = 'Finalidade de emiss�o da NFCom';
  DSC_TPFAT = 'Tipo de Faturamento da NFCom';
  DSC_IEUFDEST = 'Inscri��o Estadual Virtual do emitente na UF de Destino da partilha (IE Virtual)';
  DSC_IDESTR = 'Idenditica��o do destinat�rio outros';
  DSC_INDIEDEST = 'Indicador da IE do Destinat�rio';
  DSC_ICODASSINANTE = 'C�digo �nico de Identifica��o do assinante';
  DSC_TPASSINANTE = 'Tipo de assinante';
  DSC_TPSERVUTIL = 'Tipo de servi�o utilizado';
  DSC_NCONTRATO = 'N�mero do Contrato do assinante';
  DSC_DCONTRATOINI = 'Data de in�cio do contrato';
  DSC_DCONTRATOFIM = 'Data de t�rmino do contrato';
  DSC_NROTERMPRINC = 'N�mero do Terminal Principal do servi�o contratado';
  DSC_CHNFCOM = 'Chave de acesso da NFCom emitida pela Operadora Local';
  DSC_CMUNFG = 'C�digo do munic�pio de ocorr�ncia do fato gerador';
  DSC_NROTERMADIC = 'N�mero dos Terminais adicionais do servi�o contratado';
  DSC_MOTSUB = 'Motivo da substitui��o';
  DSC_COMPETEMIS = 'Ano e m�s da emiss�o da NF (AAAAMM)';
  DSC_HASH115 = 'Hash do registro no arquivo do conv�nio 115';
  DSC_CPROD = 'C�digo do produto ou servi�o.';
  DSC_XPROD = 'Descri��o do produto ou servi�o';
  DSC_CCLASS = 'C�digo de classifica��o';
  DSC_UMED = 'Unidade B�sica de Medida';
  DSC_QFATURADA = 'Quantidade Faturada';
  DSC_DEXPIRACAO = 'Data de expira��o de cr�dito';
  DSC_INFADPROD = 'Informa��es Adicionais do produto';
  DSC_VRETPIS = 'Valor do PIS retido';
  DSC_VRETCOFINS = 'Valor do COFNS retido';
  DSC_VRETCSLL = 'Valor da CSLL retida';
  DSC_VBCIRRF = 'Base de c�lculo do IRRF';
  DSC_VIRRF = 'Valor do IRRF retido';
  DSC_TPPROC = 'Tipo de Processo';
  DSC_NPROCESSO = 'N�mero do Processo';
  DSC_VFUNTTEL = 'Valor do FUNTTEL';
  DSC_VFUST = 'Valor do FUST';
  DSC_COMPETFAT = 'Ano e m�s refer�ncia do faturamento (AAAAMM)';
  DSC_DPERUSOINI = 'Per�odo de uso inicial';
  DSC_DPERUSOFIM = 'Per�odo de uso final';
  DSC_CODBARRAS = 'Linha digit�vel do c�digo de barras';
  DSC_CODDEBAUTO = 'C�digo de autoriza��o d�bito em conta';
  DSC_CODBANCO = 'N�mero do banco para d�bito em conta';
  DSC_CODAGENCIA = 'N�mero da ag�ncia banc�ria para d�bito em conta';
  DSC_URLQRCODEPIX = 'URL do QRCode do PIX que ser� apresentado na fatura';
  DSC_PFUST = 'Al�quota do FUST (em percentual)';
  DSC_PFUNTTEL = 'Al�quota do FUNTTEL (em percentual)';
  DSC_TPRESSARC = 'Tipo de Ressarcimento';
  DSC_DREF = 'Data de refer�ncia';
  DSC_NPROTRECLAMA = 'N�mero do protocolo de reclama��o';
  DSC_QTDSALDOPTS = 'Saldo de pontos do cliente na data de refer�ncia';
  DSC_DREFSALDOPTS= 'Data de aferi��o do saldo de pontos';
  DSC_QTDPTSRESG = 'Qtd de pontos resgatados na data de refer�ncia';
  DSC_DREFRESGPTS = 'Data de resgate dos pontos';

implementation

end.

