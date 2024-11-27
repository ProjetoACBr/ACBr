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

unit ACBrMDFe.Consts;

interface

uses
  SysUtils;

const
  NAME_SPACE_MDFE = 'xmlns="http://www.portalfiscal.inf.br/mdfe"';

resourcestring
  DSC_NMDF        = 'N�mero do Manifesto';
  DSC_CMDF        = 'C�digo num�rico que comp�e a Chave de Acesso';
  DSC_TPEMIT      = 'Tipo do Emitente';
  DSC_TPTRANSP    = 'Tipo de Transportador';
  DSC_CMUNCARREGA = 'C�digo do Munic�pio de Carregamento';
  DSC_XMUNCARREGA = 'Nome do Munic�pio de Carregamento';
  DSC_SEGCODBARRA = 'Segundo c�digo de barras';
  DSC_NCT         = 'N�mero do CT';
  DSC_SUBSERIE    = 'Subs�rie do CT';
  DSC_PIN         = 'PIN SUFRAMA';
  DSC_QCTE        = 'Quantidade total de CTe relacionados no Manifesto';
  DSC_QCT         = 'Quantidade total de CT relacionados no Manifesto';
  DSC_QNFE        = 'Quantidade total de NFe relacionados no Manifesto';
  DSC_QNF         = 'Quantidade total de NF relacionados no Manifesto';
  DSC_QCARGA      = 'Peso Bruto Total da Carga / Mercadoria Transportada';
  DSC_DHINIVIAGEM = 'Data e Hora previstas de Inicio da Viagem';
  DSC_INDREENTREGA = 'Indicador de reentrega';
  DSC_QTDTOTAL    = 'Quantidade Total';
  DSC_QTDPARCIAL  = 'Quantidade Parcial';
  DSC_MODAL  = 'Tipo de Modal';
  DSC_UFPER    = 'Sigla da UF do percurso do ve�culo';
  DSC_RNTRC  = 'Registro Nacional de Transportadores Rodovi�rios de Carga';
  DSC_PLACA = 'Placa do Ve�culo';
  DSC_RENAVAM = 'RENAVAM';
  DSC_TPPROP = 'Tipo de Propriet�rio';
  DSC_TPROD  = 'Tipo de Rodado';
  DSC_TPCAR  = 'Tipo de Carroceria';
  DSC_VVALEPED  = 'Valor do Vale-Pedagio';
  DSC_NLACRE = 'N�mero dos Lacres';
  DSC_NSERIE = 'N�mero de s�rie';
  DSC_REFCTE = 'Chave de acesso do CT-e referenciado';
  DSC_REFNFE = 'Chave de acesso das NF-e referenciadas';

  // Rodovi�rio
  DSC_CIOT        = 'C�digo Identificador da Opera��o de Transporte';
  DSC_CINTV       = 'C�digo interno do ve�culo';
  DSC_TARA        = 'Tara em KG';
  DSC_CAPKG       = 'Capacidade em KG';
  DSC_CAPM3       = 'Capacidade em m3';
  DSC_CNPJFORN    = 'CNPJ da empresa fornecedora do Vale-Ped�gio';
  DSC_CNPJPG      = 'CNPJ do respons�vel pelo pagamento do Vale-Ped�gio';
  DSC_NCOMPRA     = 'N�mero do comprovante de compra';
  DSC_CODAGPORTO  = 'C�digo de Agendamento no Porto';

  // A�reo
  DSC_NAC         = 'Marca da Nacionalidade da Aeronave';
  DSC_MATR        = 'Marca da Matricula da Aeronave';
  DSC_NVOO        = 'N�mero do V�o';
  DSC_CAEREMB     = 'Aer�dromo de Embarque';
  DSC_CAERDES     = 'Aer�dromo de Destino';
  DSC_DVOO        = 'Data do V�o';

  // Aquavi�rio
  DSC_CNPJAGENAV  = 'CNPJ da Ag�ncia de Navega��o';
  DSC_TPEMB       = 'Tipo de Embarca��o';
  DSC_CEMBAR      = 'C�digo da Embarca��o';
  DSC_XEMBAR      = 'Nome da Embarca��o';
  DSC_NVIAG       = 'N�mero da Viagem';
  DSC_CPRTEMB     = 'C�digo do Porto de Embarque';
  DSC_CPRTDEST    = 'C�digo do Porto de Destino';
  DSC_PRTTRANS    = 'Porto de Transbordo';
  DSC_CTERMCARREG = 'C�digo do Terminal de Carregamento';
  DSC_XTERMCARREG = 'Nome do Terminal de Carregamento';
  DSC_CTERMDESCAR = 'C�digo do Terminal de Descarregamento';
  DSC_XTERMDESCAR = 'Nome do Terminal de Descarregamento';
  DSC_CEMBCOMB    = 'C�digo da Embarca��o do comboio';
  DSC_XBALSA      = 'Identificador da Balsa';
  DSC_IRIN      = 'Irin do navio sempre dever� ser informado';
  DSC_TPNAV     = 'Tipo de Navega��o';

  // Ferrovi�rio
  DSC_XPREF       = 'Prefixo do Trem';
  DSC_DHTREM      = 'Data e Hora de libera��o do Trem na origem';
  DSC_XORI        = 'Origem do Trem';
  DSC_XDEST       = 'Destino do Trem';
  DSC_QVAG        = 'Quantidade de vag�es carregados';
  DSC_NVAG        = 'N�mero de Identifica��o do vag�o';
  DSC_NSEQ        = 'Sequ�ncia do vag�o na composi��o';
  DSC_TU          = 'Tonelada �til';
  DSC_TPCARGA     = 'Tipo de Carga';
  DSC_LATITUDE    = 'Latitude';
  DSC_LONGITUDE   = 'Longitude';
  DSC_VCONTRATO   = 'Valor do Contrato';
  DSC_TPCOMP      = 'Tipo de Componente de Pagamento do Frete';
  DSC_VCOMP       = 'Valor do Componente de Pagamento do Frete';
  DSC_XCOMP       = 'Descri��o do Componente de Pagamento do Frete (Outros)';
  DSC_NPARCELA    = 'Numero da Parcela';
  DSC_VPARCELA    = 'Valor da Parcela';
  DSC_CNPJIPEF    = 'CNPJ da Institui��o de pagamento Eletr�nico do Frete';
  DSC_CODBANCO    = 'C�digo do Banco';
  DSC_CODAGENCIA  = 'C�digo da Ag�ncia';
  DSC_PIX         = 'Chave PIX';
  DSC_TPVALEPED   = 'Tipo de Vale Ped�gio';
  DSC_VADIANT     = 'Valor do Adiantamento';
  DSC_TPANTECIP   = 'Tipo de Permiss�o de Antecipa��o das parcelas';
  DSC_NROCONTRATO = 'Numero do Contrato do Transportador';

  DSC_INDCANALVERDE = 'Indicador de Canal Verde';
  DSC_INDCARREGAPOSTERIOR = 'Indicador de Carregamento Posterior';
  DSC_INFQRCODMDFE  = 'Texto com o QR-Code impresso no DAMDFE';
  DSC_IDESTRANGEIRO = 'Identifica��o do Estrangeiro';
  DSC_CATEGCOMBVEIC = 'Categoria de Combina��o Veicular';

  DSC_VCONTRATOGLOBAL = 'Valor Global do Contrato';
  DSC_INDPAG = 'Indicador da forma de pagamento';
  DSC_DVENC = 'Data de vencimento';
  DSC_QTDRAT = 'Quantidade Rateada';

  DSC_NONU      = 'N�mero ONU/UN';
  DSC_XNOMEAE   = 'Nome apropriado para embarque do produto';
  DSC_XCLARISCO = 'Classe e Risco secund�rio';
  DSC_GREMB     = 'Grupo de Embalagem';
  DSC_QTOTPROD  = 'Quantidade total por produto';
  DSC_QVOLTIPO  = 'Quantidade e tipo de volumes';

  DSC_VDOC   = 'Valor do documento';

  DSC_TPUNIDTRANSP = 'Tipo de Unidade de Transporte';
  DSC_IDUNIDTRANSP = 'Identifica��o da Unidade de Transporte';
  DSC_TPUNIDCARGA  = 'Tipo de Unidade de Carga';
  DSC_IDUNIDCARGA  = 'Identifica��o da Unidade de Carga';

  DSC_RESPSEG  = 'Respons�vel pelo Seguro';
  DSC_XSEG     = 'Nome da Seguradora';
  DSC_NAPOL    = 'N�mero da Ap�lice';
  DSC_NAVER    = 'N�mero da Averba��o';
  DSC_INFSEG   = 'Informa��es de seguro da carga';

  DSC_CUNID  = 'C�digo da unidade de medida';
  DSC_LACR   = 'Grupo de lacres';

  DSC_XPROD = 'Descri��o do Produto ou Servi�o';
  DSC_CEAN = 'C�digo de Barra do Item';
  DSC_NCM = 'C�digo NCM';

implementation

end.

