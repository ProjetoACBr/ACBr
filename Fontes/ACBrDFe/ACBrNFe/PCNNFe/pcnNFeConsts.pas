{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{																			   }
{ Colaboradores neste arquivo: Italo Jurisato Junior                           }
{																			   }
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

{*******************************************************************************
|* Historico
|*
|* 17/08/2016: Italo Jurisato Junior
|*  - Criado uma Unit especifica para as constantes usadas pelo componente
|*    ACBrNFe
*******************************************************************************}

{$I ACBr.inc}

unit pcnNFeConsts;

interface

uses
  SysUtils;

const
  NAME_SPACE = 'xmlns="http://www.portalfiscal.inf.br/nfe"';

  DSC_AAMM = 'Ano e M�s';
  DSC_ANOFAB = 'Ano de Fabrica��o';
  DSC_ANOMOD = 'Ano do Modelo de Fabrica��o';
  DSC_CEANTRIB = 'C�digo de Barra do Item Tributa��o';
  DSC_CENQ = 'C�digo de Enquadramento Legal do IPI';
  DSC_CEXPORTADOR = 'C�digo do exportador';
  DSC_CFABRICANTE = 'Fabricante';
  DSC_CLENQ = 'Classe de enquadramento do IPI para Cigarros e Bebidas';
  DSC_CSITTRIB = 'C�digo de Tributa��o do ISSQN';
  DSC_CILIN = 'Cilindradas';
  DSC_CMT = 'Capacidade M�xima de Tra��o';
  DSC_CCORDEN = 'C�digo da Cor DENATRAN';
  DSC_TPREST = 'Restri��o';
  DSC_CRT = 'C�digo de Regime Tribut�rio';
  DSC_CODIF = 'C�digo de autoriza��o / registro do CODIF';
  DSC_CONDVEIC = 'Condi��es do Ve�culo';
  DSC_CNPJPROD = 'CNPJ do produtor da mercadoria, quando diferente do emitente';
  DSC_CPRODANP = 'C�digo do produto ANP';
  DSC_CSELO = 'C�digo do selo';
  DSC_DDESEMB = 'Data do Desembara�o Aduaneiro';
  DSC_DDI = 'Data de registro da DI/DSI/DA';
  DSC_DESCR = 'Descri��o completa';
  DSC_DFAB = 'Data de fabrica��o';
  DSC_DIST = 'Dist�ncia entre os eixos';
  DSC_DPAG = 'Data de pagamento do Documento de Arrecada��o';
  DSC_DSAIENT = 'Data de sa�da ou entrada da mercadoria/produto';
  DSC_HSAIENT = 'Hora de sa�da ou entrada da mercadoria/produto';
  DSC_DVAL = 'Data de validade';
  DSC_ESP = 'Esp�cie dos volumes transportados';
  DSC_ESPVEIC = 'Esp�cie de ve�culo';
  DSC_EXTIPI = 'EX_TIPI';
  DSC_FINNFE = 'Finalidade de emiss�o da NFe';
  DSC_GENERO = 'G�nero do produto ou servi�o';
  DSC_INDPROC = 'Indicador da origem do processo';
  DSC_IPITrib = 'IPI Tribut�vel';
  DSC_MARCA = 'Marca dos volumes transportados';
  DSC_MATR = 'Matr�cula do agente';
  DSC_NECF = 'N�mero de ordem seq�encial do ECF';
  DSC_NCOO = 'N�mero do Contador de Ordem de Opera��o - COO';
  DSC_MODBC = 'Modalidade de determina��o da BC do ICMS';
  DSC_MODBCST = 'Modalidade de determina��o da BC do ICMS ST';
  DSC_MOTDESICMS = 'Motivo da desonera��o do ICMS';
  DSC_MODFRETE = 'Modalidade do Frete';
  DSC_NADICAO = 'Numero da Adi��o';
  DSC_NCANO = 'Numero de s�rie do cano';
  DSC_NDI = 'Numero do Documento de Importa��o DI/DSI/DA';
  DSC_nDAR = 'N�mero do Documento Arrecada��o de Receita';
  DSC_NLOTE = 'N�mero do Lote do medicamento';
  DSC_CPRODANVISA = 'C�digo de Produto da ANVISA';
  DSC_XMOTIVOISENCAO = 'Motivo da Isen��o de registro da ANVISA';
  DSC_NMOTOR = 'N�mero de Motor';
  DSC_NPROC = 'Identificador do processo ou ato concess�rio';
  DSC_NSEQADIC = 'Numero seq�encial do item dentro da adi��o';
  DSC_NVOL = 'Numera��o dos volumes transportados';
  DSC_PESOB = 'Peso Bruto (em kg)';
  DSC_PESOL = 'Peso L�quido (em kg)';
  DSC_PICMSRET = 'Al�quota da Reten��o';
  DSC_PICMSST = 'Al�quota do imposto do ICMS ST';
  DSC_PIPI = 'Al�quota do IPI';
  DSC_PMVAST = 'Percentual da margem de valor Adicionado do ICMS ST';
  DSC_POT = 'Pot�ncia Motor';
  DSC_PCREDSN = 'Al�quota aplic�vel de c�lculo do cr�dito (Simples Nacional).';
  DSC_VCREDICMSSN = 'Valor cr�dito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)';
  DSC_PREDBCST = 'Percentual da Redu��o de BC do ICMS ST';
  DSC_UFST = 'UF para qual � devido o ICMS ST';
  DSC_PBCOP = 'Percentual da BC opera��o pr�pria';
  DSC_QLOTE = 'Quantidade de produto no Lote do medicamento';
  DSC_QSELO = 'Quantidade de selo de controle';
  DSC_QTEMP = 'Quantidade de combust�vel faturada � temperatura ambiente.';
  DSC_QTRIB = 'Quantidade Tribut�vel';
  DSC_QUNID = 'Quantidade total na unidade padr�o para tributa��o (somente para os produtos tributados por unidade)';
  DSC_QVOL = 'Quantidade de volumes transportados';
  DSC_REBOQUE = 'Reboque';
  DSC_REPEMI = 'Reparti��o Fiscal emitente';
  DSC_RNTC = 'Registro Nacional de Transportador de Carga (ANTT)';
  DSC_BALSA = 'Identifica��o da balsa';
  DSC_TPARMA = 'Indicador do tipo de arma de fogo';
  DSC_TPCOMB = 'Tipo de combust�vel';
  DSC_TPOP = 'Tipo da opera��o';
  DSC_TPPINT = 'Tipo de Pintura';
  DSC_UFCONS = 'Sigla da UF de consumo';
  DSC_UFDESEMB = 'Sigla da UF onde ocorreu o Desembara�o Aduaneiro';
  DSC_UFEMBARQ = 'Sigla da UF onde ocorrer� o embarque dos produtos';
  DSC_UTRIB = 'Unidade Tribut�vel';
  DSC_VBCICMSST = 'BC do ICMS ST retido';
  DSC_VBCICMSSTCONS = 'Valor do ICMS ST da UF de consumo';
  DSC_VBCICMSSTDEST = 'BC do ICMS ST da UF de destino';
  DSC_VBCIRRF = 'Base de C�lculo do IRRF';
  DSC_VBCRET = 'BC da Reten��o do ICMS';
  DSC_VBCRETPREV = 'Base de C�lculo da Reten��o da Previd�ncia Social';
  DSC_VBCSTRET = 'Valor da BC do ICMS ST Retido';
  DSC_VCIDE = 'Valor da CIDE';
  DSC_VDAR = 'Valor total constante no Documento de arrecada��o de Receita';
  DSC_INDTOT = 'Indicador de soma no total da NFe';
  DSC_VDESCDI = 'Valor do desconto do item da DI � adi��o';
  DSC_VDESPADU = 'Valor das despesas aduaneiras';
  DSC_VICMSRET = 'Valor do ICMS Retido';
  DSC_VICMSST = 'Valor do ICMS Substitui��o Tributaria';
  DSC_VICMSSTRET = 'Valor do ICMS Substitui��o Tributaria Retido';
  DSC_VICMSSTCONS = 'Valor do ICMS Substitui��o Tributaria da UF de Consumo';
  DSC_VICMSSTDEST = 'Valor do ICMS Substitui��o Tributaria da UF de Destino';
  DSC_VII = 'Valor do Imposto de Importa��o';
  DSC_VIN = 'Condi��o do VIN';
  DSC_VIOF = 'Valor do Imposto sobre opera��es Financeiras';
  DSC_vIPI = 'Valor do Imposto sobre Produtos Industrializados';
  DSC_VIRRF = 'Valor do Imposto de Renda Retido na Fonte';
  DSC_VPMC = 'Pre�o M�ximo ao Consumidor';
  DSC_VRETCOFINS = 'Valor Retido do COFINS';
  DSC_VRETCSLL = 'Valor Retido da CONTRIBUI��O SOCIAL SOBRE O LUCRO L�QUIDO';
  DSC_VRETPIS = 'Valor Retido do PIS';
  DSC_VRETPREV = 'Valor da Reten��o da Previd�ncia Social';
  DSC_VSEG = 'Valor Total do Seguro';
  DSC_VSERV = 'Valor total dos Servi�os sob n�o incid�ncia ou n�o Tributados pelo ICMS  / Valor do Servi�o';
  DSC_VUNID = 'Valor por Unidade Tribut�vel';
  DSC_VUNTRIB = 'Valor unit�rio de Tributa��o';
  DSC_XAGENTE = 'Nome do agente';
  DSC_XCONT = 'Contrato';
  DSC_XENDER = 'Endere�o Completo';
  DSC_XLOCDESEMB = 'Local de Desembara�o';
  DSC_XLOCEMBARQ = 'Local onde ocorrer� o embarque dos produtos';
  DSC_XNEMP = 'Nota de Empenho';
  DSC_XPED = 'Pedido';
  DSC_XORGAO = 'Org�o emitente';
  DSC_CHNFE = 'Chave da NFe';
  DSC_IDLOTE = 'Numero do Lote';
  DSC_VERAPLIC = 'Vers�o do aplicativo';
  DSC_NREGDPEC = 'N�mero de registro do DPEC';
  DSC_DPEC_ID = 'Grupo de Identifica��o da TAG a ser assinada. DPEC + CNPJ do emissor.';
  DSC_SAFRA = 'Identifica��o da safra';
  DSC_REF = 'M�s e ano de refer�ncia';
  DSC_FORDIA = 'Grupo de Fornecimento di�rio de cana';
  DSC_DIA = 'Dia';
  DSC_QTOTMES = 'Quantidade Total do M�s';
  DSC_QTOTANT = 'Quantidade Total Anterior';
  DSC_TOTGER = 'Quantidade Total Geral';
  DSC_DEDUC = 'Grupo de Dedu��es � Taxas e Contribui��es';
  DSC_XDED = 'Descri��o da Dedu��o';
  DSC_VDED = 'Valor da Dedu��o';
  DSC_VFOR = 'Valor dos Fornecimentos';
  DSC_VTOTDED = 'Valor Total da Dedu��o';
  DSC_VLIQFOR = 'Valor L�quido dos Fornecimentos';
  DSC_INDNFE = 'Indicador de NF-e consultada';
  DSC_INDEMI = 'Indicador do Emissor da NF-e';
  DSC_QNF = 'Quantidade de Documento Fiscal';
  DSC_VTOTTRIB = 'Valor Aproximado Total de Tributos';
  DSC_IDDEST = 'Destino da Opera��o';
  DSC_INDFINAL = 'Indicador de Opera��o com Consumidor Final';
  DSC_INDPRES = 'Indicador de Presen�a do Consumidor Final';
  DSC_INDINTERMED = 'Indicador de Intermediador/marketplace';
  DSC_IDESTR = 'Documento de Identifica��o do Estrangeiro';
  DSC_INDIEDEST = 'Indicador da IE do Destinat�rio';
  DSC_NVE = 'Nomenclatura de Valor Aduaneiro e Estat�stica';
  DSC_NFCI = 'N�mero de Controle da FCI';
  DSC_NRECOPI = 'N�mero do RECOPI';
  DSC_TPVIATRANSP = 'Via de Transporte Internacional';
  DSC_TPINTERMEDIO = 'Forma de Importa��o';
  DSC_NDRAW = 'N�mero do Drawback';
  DSC_NRE = 'N�mero do Registro de Exporta��o';
  DSC_QEXPORT = 'Qtde Exportada';
  DSC_PMIXGN = 'Percentual de G�s Natural';
  DSC_VICMSDESON = 'Valor do ICMS Desonera��o';
  DSC_PDEVOL = 'Percentual da Mercadoria Devolvida';
  DSC_VIPIDEVOL = 'Valor do IPI Devolvido';
  DSC_DCOMPET = 'Data da Presta��o do Servi�o';
  DSC_VDEDUCAO = 'Valor da Dedu��o';
  DSC_VOUTRODED = 'Valor Outras Dedu��es';
  DSC_CSERVICO = 'C�digo do Servi�o';
  DSC_CREGTRIB = 'C�digo do Regime Especial de Tributa��o';
  DSC_XLOCDESP = 'Local de Despacho';
  DSC_INFQRCODE = 'Texto com o QR-Code impresso no DANFE NFC-e.';
  DSC_NBICO = 'N�mero de identifica��o do bico';
  DSC_NBOMBA = 'N�mero de identifica��o da bomba';
  DSC_NTANQUE = 'N�mero de identifica��o do tanque';
  DSC_VENCINI = 'Valor do Encerrante no in�cio do abastecimento';
  DSC_VENCFIN = 'Valor do Encerrante no final do abastecimento';
  DSC_VBCUFDEST = 'Valor da BC do ICMS na UF do destinat�rio';
  DSC_PFCPUFDEST = 'Al�quota do ICMS realtivo ao Fundo de Combate � Pobreza';
  DSC_PICMSUFDEST = 'Al�quota interna da UF do destinat�rio';
  DSC_PICMSINTER = 'Al�quota interestadual das UF envolvidas';
  DSC_PICMSINTERPART = 'Percentual provis�rio de partilha entre os Estados';
  DSC_VFCPUFDEST = 'Valor do ICMS realtivo ao Fundo de Combate � Pobreza';
  DSC_VICMSUFDEST = 'Valor do ICMS de partilha para a UF do destinat�rio';
  DSC_VICMSUFREMET = 'Valor do ICMS de partilha para a UF do remetente';
  DSC_DESCANP = 'Descri��o do produto conforme ANP';
  DSC_PGLP = 'Percentual do GLP derivado do petr�leo no produto GLP';
  DSC_PGNN = 'Percentual de G�s Natural Nacional � GLGNn para o produto GLP';
  DSC_PGNI = 'Percentual de G�s Natural Importado � GLGNi para o produto GLP';
  DSC_VPART = 'Valor de partida';
  DSC_VBCFCP = 'Valor da Base de C�lculo do FCP';
  DSC_PFCP = 'Percentual do ICMS relativo ao Fundo de Combate � Pobreza (FCP)';
  DSC_VFCP = 'Valor do ICMS relativo ao Fundo de Combate � Pobreza (FCP)';
  DSC_VBCFCPST = 'Valor da Base de C�lculo do FCP por Substitui��o Tribut�ria';
  DSC_PFCPST = 'Percentual do FCP retido por Substitui��o Tribut�ria';
  DSC_VFCPST = 'Valor do FCP retido por Substitui��o Tribut�ria';
  DSC_PFCPSTRET = 'Percentual do FCP retido anteriormente por Substitui��o Tribut�ria';
  DSC_VFCPSTRET = 'Valor do FCP retido por Substitui��o Tribut�ria';
  DSC_PST = 'Al�quota suportada pelo Consumidor Final';
  DSC_VBCFCPUFDEST = 'Valor da BC FCP na UF de destino';
  DSC_PREDBCEFET = 'Percentual de redu��o da base de c�lculo efetiva';
  DSC_VBCEFET = 'Valor da base de c�lculo efetiva';
  DSC_PICMSEFET = 'Al�quota do ICMS efetiva';
  DSC_VICMSEFET = 'Valor do ICMS efetivo';
  DSC_VICMSSUBSTITUTO = 'Valor do ICMS Substituto';
  //DSC_VPART = 'Valor';
  DSC_INDESCALA = 'Indicador de Escala de Produ��o';
  DSC_CNPJFAB = 'CNPJ do Fabricante da Mercadoria';
  DSC_CBENEF = 'C�digo de Benef�cio Fiscal na UF aplicado ao item';
  DSC_CAGREG = 'C�digo de Agrega��o';
  DSC_URLCHAVE = 'URL de consulta por chave de acesso a ser impressa no DANFE NFC-e';
  DSC_CNPJINTERM = 'CNPJ do Intermediador da Transa��o';
  DSC_IDCADINTERM = 'Nome do usu�rio ou identifica��o do perfil do vendedor no site do intermediador';
  DSC_CBARRA = 'C�digo de Barras pr�prio ou de terceiros';
  DSC_CBARRATRIB = 'C�digo de Barras pr�prio ou de terceiros (Tributa��o)';
  DSC_VICMSSTDESON = 'Valor do ICMS- ST desonerado';
  DSC_MOTDESICMSST = 'Motivo da desonera��o do ICMS- ST';
  DSC_PFCPDIF = 'Percentual do diferimento do ICMS relativo ao Fundo de Combate � Pobreza (FCP)';
  DSC_VFCPDIF = 'Valor do ICMS relativo ao Fundo de Combate � Pobreza (FCP) diferido';
  DSC_VFCPEFET = 'Valor efetivo do ICMS relativo ao Fundo de Combate � Pobreza (FCP)';
  DSC_INDSOMAPISST = 'Indica se o valor do PIS ST comp�e o valor total da NF-e';
  DSC_INDSOMACOFINSST = 'Indica se o valor da COFINS ST comp�e o valor total da NF-e';
  DSC_TPATO = 'Tipo do Ato Concess�rio';
  DSC_PBIO = 'Percentual do �ndice de mistura do Biodiesel';
  DSC_INDIMPORT = 'indicador de importa��o';
  DSC_PORIG = 'Percentual origin�rio para a UF';
  DSC_ADREMICMS = 'Al�quota ad rem do imposto';
  DSC_VICMSMONO = 'Valor do ICMS pr�prio';
  DSC_ADREMICMSRETEN = 'Al�quota ad rem do imposto com reten��o ';
  DSC_VICMSMONORETEN = 'Valor do ICMS com reten��o';
  DSC_ADREMICMSDIF = 'Al�quota ad rem do imposto diferido';
  DSC_VICMSMONODIF = 'Valor do ICMS diferido';
  DSC_ADREMICMSRET = 'Al�quota ad rem do imposto retido anteriormente';
  DSC_VICMSMONORET = 'Valor do ICMS retido anteriormente';
  DSC_QBCMONO = 'Quantidade tributada';
  DSC_QBCMONORETEN = 'Quantidade tributada sujeita a reten��o';
  DSC_PREDADREM = 'Percentual de redu��o do valor da al�quota adrem do ICMS';
  DSC_MOTREDADREM = 'Motivo da redu��o do adrem';
  DSC_VICMSMONOOP = 'Valor do ICMS da opera��o';
  DSC_QBCMONORET = 'Quantidade tributada retida anteriormente';
  DSC_PDIF = 'Percentual do diferimento';

  DSC_VICMS = 'Valor do ICMS';
  DSC_VST = 'Valor TOTAL Icms substitui��o Tribut�ria';
  DSC_NATOP = 'Descri��o da Natureza da Opera��o';
  DSC_INDPAG = 'Indicador da forma de pagamento';
  DSC_TPNF = 'Tipo do Documento Fiscal';
  DSC_CMUNFG = 'C�digo do Munic�pio FG';
  DSC_REFNFE = 'Chave de acesso das NF-e referenciadas';
  DSC_REFCTE = 'Chave de acesso do CT-e referenciado';
  DSC_IEST = 'Inscri��o Estadual do Substituto tribut�rio';
  DSC_CNAE = 'Classifica��o Nacional de Atividades Econ�micas';
  DSC_ISUF = 'Inscri��o na SUFRAMA';
  DSC_INFADPROD = 'Informa��es adicionais do Produto';
  DSC_NITEM = 'Numero do item';
  DSC_CPROD = 'C�digo do produto ou servi�o';
  DSC_CEAN = 'C�digo de Barra do Item';
  DSC_XPROD = 'Descri��o do Produto ou Servi�o';
  DSC_NCM = 'C�digo NCM';
  DSC_CEST = 'C�digo Identificador da Substitu��o Tribut�ria';
  DSC_UCOM = 'Unidade Comercial';
  DSC_QCOM = 'Quantidade Comercial';
  DSC_VUNCOM = 'Valor Unit�rio de Comercializa��o';
  DSC_VPROD = 'Valor Total Bruto dos Produtos ou Servi�os';
  DSC_VFRETE = 'Valor Total do Frete';
  DSC_VDESC = 'Valor do desconto';
  DSC_VOUTRO = 'Outras Despesas Acess�rias';
  DSC_NITEMPED = 'Item do Pedido de Compra da DI � adi��o';
  DSC_VAFRMM = 'Valor da AFRMM';
  DSC_CHASSI = 'N�mero do chassi';
  DSC_CCOR = 'Cor do Ve�culo';
  DSC_XCOR = 'Descri��o da Cor';
  DSC_NSERIE = 'N�mero de s�rie';
  DSC_TPVEIC = 'Tipo de Ve�culo';
  DSC_CMOD = 'Modelo do Ve�culo';
  DSC_LOTA   = 'Indicador de lota��o';
  DSC_QBCPROD = 'BC da CIDE';
  DSC_VALIQPROD = 'Valor da al�quota (em reais)';
  DSC_VBCICMS = 'BC do ICMS';
  DSC_ORIG = 'Origem da mercadoria';
  DSC_VBC = 'Valor da BC do ICMS';
  DSC_PICMS = 'Al�quota do imposto';
  DSC_PREDBC = 'Percentual da Redu��o de BC';
  DSC_VBCST = 'Valor da BC do ICMS ST';
  DSC_CSOSN = 'C�digo de Situa��o da Opera��o � Simples Nacional';
  DSC_PPIS = 'Al�quota do PIS (em percentual)';
  DSC_VPIS = 'Valor do PIS';
  DSC_PISOUTR = 'Grupo PIS outras opera��es';
  DSC_PCOFINS = 'Al�quota da COFINS (em percentual)';
  DSC_VCOFINS = 'Valor do COFINS';
  DSC_COFINSST = 'Grupo de COFINS Substitui��o Tribut�ria';
  DSC_VBCISS = 'Valor da Base de C�lculo do ISSQN';
  DSC_VALIQ = 'Al�quota';
  DSC_VISSQN = 'Valor do Imposto sobre Servi�o de Qualquer Natureza';
  DSC_CLISTSERV = 'Lista Presta��o de Servi�os';
  DSC_VDESCINCOND = 'Valor Desconto Incondicionado';
  DSC_VDESCCOND = 'Valor Desconto Condicionado';
  DSC_VISSRET = 'Valor Reten��o ISS';
  DSC_INDISS = 'Indicador da Exigibilidade do ISS';
  DSC_NPROCESSO = 'N�mero do Processo';
  DSC_INDINCENTIVO = 'Indicador de Incentivo Fiscal';
  DSC_VISS = 'Valor do Imposto sobre Servi�o';
  DSC_NFAT = 'N�mero da fatura';
  DSC_VORIG = 'Valor Original da Fatura';
  DSC_VLIQ = 'Valor L�quido da Fatura';
  DSC_NDUP = 'N�mero da duplicata';
  DSC_DVENC = 'Data de vencimento';
  DSC_VDUP = 'Valor da duplicata';
  DSC_VAGAO = 'Identifica��o do vag�o';
  DSC_PLACA = 'Placa do Ve�culo';
  DSC_NLACRE = 'N�mero dos Lacres';
  DSC_QTDE = 'Quantidade';
  DSC_TPAG = 'Forma de Pagamento';
  DSC_XPAG = 'Descri��o da forma de Pagamento';
  DSC_VPAG = 'Valor do Pagamento';
  DSC_TPINTEGRA = 'Tipo de Integra��o para pagamento';
  DSC_TBAND = 'Bandeira da Operadora de Cart�o';
  DSC_CAUT = 'N�mero da Autoriza��o';
  DSC_CNPJPAG = 'CNPJ Transacional do Pagamento';
  DSC_UFPAG = 'UF do CNPJ do estabelecimento onde o pagamento foi processado/transacionado/recebido';
  DSC_CNPJRECEB = 'CNPJ do benefici�rio do pagamento';
  DSC_IDTERMPAG = 'Identificador do terminal de pagamento';
  DSC_CCREDPRESUMIDO = 'C�digo de Benef�cio Fiscal de Cr�dito Presumido na UF aplicado ao item';
  DSC_PCREDPRESUMIDO = 'Percentual do Cr�dito Presumido';
  DSC_VCREDPRESUMIDO = 'Valor do Cr�dito Presumido';
  DSC_CBENEFRBC = 'C�digo de Benef�cio Fiscal na UF aplicado ao item quando houver RBC.';
  DSC_CNPJIF = 'CNPJ da institui��o financeira, de pagamento, adquirente ou subadquirente.';
  DSC_UFRECEB = 'UF do CNPJ do estabelecimento benefici�rio do pagamento.';

  // Descri��o do grupo Agropecuario
  DSC_NRECEITUARIO = 'N�mero da Receita ou Receitu�rio de Aplica��o do defensivo';
  DSC_CPFRESPTEC = 'CPF do Respons�vel T�cnico, emitente do receitu�rio';
  DSC_UFGUIA = ' UF de emiss�o da guia';
  DSC_TPGUIA = 'Tipo da Guia';
  DSC_SERIEGUIA = 'S�rie da Guia';
  DSC_NGUIA = 'N�mero da Guia';

implementation

end.

