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

unit ACBrDFeConsts;

interface

const
  CODIGO_BRASIL = 1058;
  CMUN_EXTERIOR = 9999999;
  XML_V01 = '?xml version="1.0"?';
  ENCODING_UTF8 = '?xml version="1.0" encoding="UTF-8"?';
  ENCODING_UTF8_STD = '?xml version="1.0" encoding="UTF-8" standalone="no"?';
  XMUN_EXTERIOR = 'EXTERIOR';
  UF_EXTERIOR = 'EX';

resourcestring
  // Descri��o de Mensagens de Erro
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

  // Descri��o de Lotes
  DSC_IDLOTE = 'Numero do Lote';

  // Descri��o de Documentos
  DSC_CNPJ = 'CNPJ(MF)';
  DSC_CPF = 'CPF';
  DSC_IDOUTROS = 'Identifica��o de Extrangeiro';
  DSC_IE = 'Inscri��o Estadual';
  DSC_IM = 'Inscri��o Municipal';

  // Descri��o de Documentos Fiscais
  DSC_MOD = 'Modelo do Documento Fiscal';
  DSC_NDF = 'Numero do Documento Fiscal';
  DSC_SERIE = 'S�rie do Documento Fiscal';
  DSC_CDF = 'C�digo do Documento Fiscal';
  DSC_CDV = 'Digito Verificador';
  DSC_VDF = 'Valor Total do DF-e';

  // Descri��o de Identifica��o do Documento Fiscal
  DSC_TPAMB = 'Identifica��o do Ambiente';
  DSC_CUF = 'C�digo IBGE da UF';
  DSC_DHEMI = 'Data e Hora de Emiss�o';
  DSC_DEMI = 'Data de emiss�o';
  DSC_HEMI = 'Hora de emiss�o';
  DSC_TPEMIS = 'Tipo de Emiss�o';
  DSC_TPIMP = 'Formato de Impress�o do Documento Auxiliar';
  DSC_PROCEMI = 'Processo de emiss�o do DF-e';
  DSC_VERPROC = 'Vers�o do processo de emiss�o';
  DSC_DHCONT = 'Data e Hora da entrada em conting�ncia';
  DSC_XJUSTCONT = 'Justificativa da entrada em conting�ncia';
  DSC_QRCODNFCOM = 'Texto com o QR-Code para consulta';
  DSC_CHAVE = 'Chave do DFe';
  DSC_CHAVESEGURANCA = 'Chave de seguran�a';
  DSC_ANO = 'Ano';
  DSC_NNFINI = 'Numero inicial';
  DSC_NNFFIN = 'Numero final';
  DSC_XJUST = 'Justificativa';
  DSC_QRCODE = 'Assinatura Digital para uso em QRCODE';
  DSC_QRCODDFe = 'Texto do QR-Code para consulta';

  // Descri��o de Dados da Pessoa F�sica ou Jur�dica
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

  // Descri��o de Informa��es do Contribuinte/Fisco
  DSC_XOBS = 'Observa��o';
  DSC_OBSCONT = 'Observa��es de interesse do Contribuite';
  DSC_INFCPL = 'Informa��es complementares de interesse do Contribuinte';
  DSC_OBSFISCO = 'Observa��es de interesse do Fisco';
  DSC_INFADFISCO = 'Informa��es adicionais de interesse do Fisco';
  DSC_XCAMPO = 'Identifica��o do Campo';
  DSC_XTEXTO = 'Conte�do do Campo';

  // Descri��o de Informa��es do Autorizado
  DSC_AUTXML = 'Autorizados para download do XML do DF-e';

  // Descri��o de Informa��es do Certificado Digital
  DSC_DigestValue = 'Digest Value';
  DSC_SignatureValue = 'Signature Value';
  DSC_X509Certificate = 'X509 Certificate';

  // Descri��o de Dados do Respons�vel T�cnico
  DSC_XCONTATO = 'Nome da pessoa a ser contatada';
  DSC_IDCSRT = 'Identificador do c�digo de seguran�a do respons�vel t�cnico';
  DSC_HASHCSRT = 'Hash do token do c�digo de seguran�a do respons�vel t�cnico';

  // Descri��o de Tributos
  DSC_CFOP = 'CFOP';
  DSC_CST = 'C�digo da situa��o tribut�ria ';

  // Descri��o de dados do DistribuicaoDFe
  DSC_ULTNSU = '�ltimo NSU recebido pela Empresa';
  DSC_NSU = 'NSU espec�fico';

  // Reforma Tribut�ria
  DSC_TPENTEGOV = 'Tipo de Ente governamental';
  DSC_PREDUTOR = 'Percentual de redu��o de aliquota em compra governamental';
  DSC_TPOPERGOV = 'Tipo de Opera��o com o ente governamental';
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
  DSC_PIBSMUN = 'Al�quota do IBS de compet�ncia do Munic�pio';
  DSC_VIBSMUN = 'Valor do IBS de compet�ncia do Munic�pio';
  DSC_VIBS = 'Valor da IBS';
  DSC_PCBS = 'Al�quota da CBS';
  DSC_VCBS = 'Valor da CBS';
  DSC_CCREDPRES = 'C�digo de Classifica��o do Cr�dito Presumido';
  DSC_PCREDPRES = 'Percentual do Cr�dito Presumido';
  DSC_VCREDPRES = 'Valor do Cr�dito Presumido';
  DSC_VCREDPRESCONDSUS = 'Valor do Cr�dito Presumido em condi��o suspensiva.';

  DSC_VTOTDFE = 'Valor total do documento fiscal';

  DSC_VBCCIBS = 'Total da Base de c�lculo do IBS/CBS';
  DSC_VIBSTOT = 'Total do IBS (IBS UF + IBS Mun)';
  DSC_PALIQIBSUF = 'Aliquota do IBS UF';
  DSC_VTRIBIBSUF = 'Valor da Tributa��o do IBS UF';
  DSC_PALIQIBSMUN = 'Aliquota do IBS Municipal';
  DSC_VTRIBIBSMUN = 'Valor da Tributa��o do IBS Municipal';
  DSC_PALIQCBS = 'Aliquota do CBS';
  DSC_VTRIBCBS = 'Valor da Tributa��o do CBS';

implementation

end.

