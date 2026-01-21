{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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
unit ISSBarueri.Provider;

interface

uses
  SysUtils, Classes, Variants,
  ACBrBase, ACBrDFeSSL,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderProprio,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type

  TCodigoErro = (ce100, ce101, ce102, ce200, ce201, ce202, ce203, ce204, ce205,
                 ce206, ce207, ce208, ce209, ce210, ce211, ce212, ce213, ce214,
                 ce215, ce216, ce217, ce218, ce219, ce220, ce221, ce222, ce223,
                 ce224, ce225, ce226, ce227, ce228, ce229, ce230, ce231, ce232,
                 ce233, ce234, ce235, ce236, ce237, ce238, ce239, ce240, ce241,
                 ce242, ce243, ce244, ce245, ce246, ce247, ce248, ce249, ce250,
                 ce251, ce252, ce253, ce254, ce255, ce256, ce257, ce258, ce259,
                 ce260, ce261, ce262, ce263, ce264, ce265, ce266, ce300, ce301,
                 ce302, ce303, ce304, ce305, ce400, ce401, ce402, ce403, ce000,
                 ce500, ce600, ce700, ce800, ce801, ce802, ce803, ce804, ce805,
                 ce806, ce807, ce808, ce809, ce810, ce811, ce812, ce813, ce814,
                 ce815, ce816, ce817, ce818, ce819, ce820, ce821, ce822, ce823,
                 ce824, ce825, ce826, ce827, ce828, ce829, ce830, ce831, ce832,
                 ce833, ce834, ce835, ce836, ce837, ce838, ce839, ce840, ce841,
                 ce842, ce843, ce844, ce845, ce846, ce900, ce901, ce999);

  { TACBrNFSeXWebserviceISSBarueri }

  TACBrNFSeXWebserviceISSBarueri = class(TACBrNFSeXWebserviceSoap12)
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoTomado(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;
  end;

  { TACBrNFSeProviderISSBarueri }

  TACBrNFSeProviderISSBarueri = class(TACBrNFSeProviderProprio)
  private
    function ExisteErroRegistro(const ALinha: String): Boolean;

    function StrToCodigoErro(var ok:boolean; const s: string): TCodigoErro;
    function GetCausa(const ACodigo: TCodigoErro): String;
    function GetSolucao(const ACodigo: TCodigoErro): String;
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;
    procedure GerarMsgDadosEmitir(Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse); override;
    function PrepararRpsParaLote(const aXml: string): string; override;

    procedure PrepararConsultaSituacao(Response: TNFSeConsultaSituacaoResponse); override;
    procedure TratarRetornoConsultaSituacao(Response: TNFSeConsultaSituacaoResponse); override;

    procedure PrepararConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;
    procedure TratarRetornoConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;

    procedure PrepararConsultaNFSeServicoTomado(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSeServicoTomado(Response: TNFSeConsultaNFSeResponse); override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    function AplicarLineBreak(const AXMLRps: string; const ABreak: string): string; override;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = 'ListaMensagemRetorno';
                                     const AMessageTag: string = 'MensagemRetorno'); override;
  public
    function SituacaoLoteRpsToStr(const t: TSituacaoLoteRps): string; override;
    function StrToSituacaoLoteRps(out ok: boolean; const s: string): TSituacaoLoteRps; override;
    function SituacaoLoteRpsToDescr(const t: TSituacaoLoteRps): string; override;

    function TipoTributacaoRPSToStr(const t: TTipoTributacaoRPS): string; override;
    function StrToTipoTributacaoRPS(out ok: boolean; const s: string): TTipoTributacaoRPS; override;
  end;

implementation

uses
  synacode, synautil,
  ACBrDFe.Conversao,
  ACBrConsts,
  ACBrUtil.Base, ACBrUtil.DateTime, ACBrUtil.Strings, ACBrUtil.XMLHTML,
  ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  ISSBarueri.GravarXml, ISSBarueri.LerXml;

{ TACBrNFSeProviderISSBarueri }

function TACBrNFSeProviderISSBarueri.StrToCodigoErro(var ok: boolean;
  const s: string): TCodigoErro;
begin
  result := StrToEnumerado(ok, s,
                ['999',
                 '100', '101', '102', '200', '201', '202', '203', '204', '205',
                 '206', '207', '208', '209', '210', '211', '212', '213', '214',
                 '215', '216', '217', '218', '219', '220', '221', '222', '223',
                 '224', '225', '226', '227', '228', '229', '230', '231', '232',
                 '233', '234', '235', '236', '237', '238', '239', '240', '241',
                 '242', '243', '244', '245', '246', '247', '248', '249', '250',
                 '251', '252', '253', '254', '255', '256', '257', '258', '259',
                 '260', '261', '262', '263', '264', '265', '266', '300', '301',
                 '302', '303', '304', '305', '400', '401', '402', '403', '000',
                 '500', '600', '700', '800', '801', '802', '803', '804', '805',
                 '806', '807', '808', '809', '810', '811', '812', '813', '814',
                 '815', '816', '817', '818', '819', '820', '821', '822', '823',
                 '824', '825', '826', '827', '828', '829', '830', '831', '832',
                 '833', '834', '835', '836', '837', '838', '839', '840', '841',
                 '842', '843', '844', '845', '846', '900', '901'],
                [ce999,
                 ce100, ce101, ce102, ce200, ce201, ce202, ce203, ce204, ce205,
                 ce206, ce207, ce208, ce209, ce210, ce211, ce212, ce213, ce214,
                 ce215, ce216, ce217, ce218, ce219, ce220, ce221, ce222, ce223,
                 ce224, ce225, ce226, ce227, ce228, ce229, ce230, ce231, ce232,
                 ce233, ce234, ce235, ce236, ce237, ce238, ce239, ce240, ce241,
                 ce242, ce243, ce244, ce245, ce246, ce247, ce248, ce249, ce250,
                 ce251, ce252, ce253, ce254, ce255, ce256, ce257, ce258, ce259,
                 ce260, ce261, ce262, ce263, ce264, ce265, ce266, ce300, ce301,
                 ce302, ce303, ce304, ce305, ce400, ce401, ce402, ce403, ce000,
                 ce500, ce600, ce700, ce800, ce801, ce802, ce803, ce804, ce805,
                 ce806, ce807, ce808, ce809, ce810, ce811, ce812, ce813, ce814,
                 ce815, ce816, ce817, ce818, ce819, ce820, ce821, ce822, ce823,
                 ce824, ce825, ce826, ce827, ce828, ce829, ce830, ce831, ce832,
                 ce833, ce834, ce835, ce836, ce837, ce838, ce839, ce840, ce841,
                 ce842, ce843, ce844, ce845, ce846, ce900, ce901]);
end;

function TACBrNFSeProviderISSBarueri.GetCausa(
  const ACodigo: TCodigoErro): String;
begin
  case ACodigo of
    ce100: Result := 'Tipo de Registro Inválido';
    ce101: Result := 'Inscrição do Prestador de Serviços não encontrada na base de dados da PMB';
    ce102: Result := 'Identificação da Remessa do Contribuinte inválida ou já informada em outro arquivo de remessa';
    ce200: Result := 'Tipo de Registro Inválido';
    ce201: Result := 'Tipo de RPS Inválido';
    ce202: Result := 'Número de Série do RPS Inválida';
    ce203: Result := 'Número de Série da Nf-e Inválida';
    ce204: Result := 'Número de RPS não Informado ou inválido. Numeração máxima permitida 0009999999';
    ce205: Result := 'Número de RPS já enviado';
    ce206: Result := 'Numero do RPS enviado em Duplicidade no Arquivo';
    ce207: Result := 'NF-e não consta na base de dados da PMB, não pode ser cancelada/substituida';
    ce208: Result := 'Data Inválida';
    ce209: Result := 'Data de Emissão não poderá ser inferior a 09/09/2008';
    ce210: Result := 'Data de Emissão do RPS não pode ser superior a Data de Hoje';
    ce211: Result := 'Hora de Emissão do RPS Inválida';
    ce212: Result := 'Situação do RPS Inválida';
    ce213: Result := 'Código do Motivo de Cancelamento Inválido';
    ce214: Result := 'Campo Descrição do Cancelamento não informado';
    ce215: Result := 'NFe não pode ser cancelada, guia em aberto para nota fiscal correspondente';
    ce216: Result := 'Código de Atividade não encontrada na base da PMB';
    ce217: Result := 'Local da Prestação do Serviço Inválido';
    ce218: Result := 'Serviço Prestado em Vias Públicas Inválido';
    ce219: Result := 'Campo Endereco do Serviço Prestado é obrigatório';
    ce220: Result := 'Campo Número do Logradouro do Serviço Prestado é obrigatório';
    ce221: Result := 'Campo Bairro do Serviço Prestado é obrigatório';
    ce222: Result := 'Campo Cidade do Serviço Prestado é obrigatório';
    ce223: Result := 'Campo UF do Serviço Prestado é obrigatório';
    ce224: Result := 'Campo UF do Serviço Prestado invalido';
    ce225: Result := 'Campo CEP do Serviço Prestado invalido';
    ce226: Result := 'Quantidade de Serviço não deverá ser inferior a zero e/ou Quantidade de Serviço deverá ser numérico';
    ce227: Result := 'Valor do Serviço não pode ser menor que zero e/ou Valor do Serviço deverá ser numérico';
    ce228: Result := 'Reservado';
    ce229: Result := 'Reservado';
    ce230: Result := 'Valor Total das Retenções não deverá ser inferior a zero e/ou Valor Total das Retenções deverá ser numérico';
    ce231: Result := 'Valor Total das Retenções não poderá ser superior ao Valor Total do serviço prestado';
    ce232: Result := 'Valor Total dos Retenções não confere com os valores deduçoes informadas para este RPS';
    ce233: Result := 'Identificador de tomodor estrangeiro inválido';
    ce234: Result := 'Código do Pais de Nacionalidade do Tomador Estrangeiro inválido';
    ce235: Result := 'Identificador se Serviço Prestado é exportação inválido';
    ce236: Result := 'Indicador CPF/CNPJ Inválido';
    ce237: Result := 'CPNJ do Tomador Inválido';
    ce238: Result := 'Campo Nome ou Razão Social do Tomador de Serviços é Obrigatório';
    ce239: Result := 'Campo Endereço do Tomador de Serviços é Obrigatório';
    ce240: Result := 'Campo Número do Logradouro do Tomador de Serviços';
    ce241: Result := 'Campo Bairro do Tomador de Serviços é Obrigatório';
    ce242: Result := 'Campo Cidade do Tomador de Serviços é Obrigatório';
    ce243: Result := 'Campo UF do Tomador de Serviços é Obrigatório';
    ce244: Result := 'Campo UF do Tomador de Serviços Inválido';
    ce245: Result := 'Campo CEP do Tomador de Serviços Inválido';
    ce246: Result := 'Email do Tomador de Serviços Inválido';
    ce247: Result := 'Campo Fatura deverá ser numérico';
    ce248: Result := 'Valor da Fatura não deverá ser inferior a zero e/ou Valor da Fatura deverá ser numérico';
    ce249: Result := 'Campo Forma de Pagamento não informado';
    ce250: Result := 'Campo Discriminação de Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce251: Result := 'Valor Total do Serviço superior ao permitido (campo valor do serviço multiplicado pelo campo quantidade)';
    ce252: Result := 'Data Inválida';
    ce253: Result := 'NFe não pode ser cancelada, data de emissão superior a 90 dias';
    ce254: Result := 'Nota Fiscal Já Cancelada';
    ce255: Result := 'Nota Fiscal com valores zerados';
    ce256: Result := 'Contribuinte com condição diferente de ativo';
    ce257: Result := 'Nota Fiscal enviada em Duplicidade no Arquivo';
    ce258: Result := 'NFe não pode ser cancelada ou substituida competência já encerrada';
    ce259: Result := 'Data de Emissão do RPS refere-se a competência já encerrada';
    ce260: Result := 'Código de Atividade não permitido';
    ce261: Result := 'Código de Atividade Bloqueado';
    ce262: Result := 'Situação do RPS "R" para correção de informação junto ao ADN, não permitida';
    ce263: Result := 'Campo Endereco do Tomador é obrigatório';
    ce264: Result := 'Campo Número do Logradouro do Tomador é obrigatório';
    ce265: Result := 'Campo Bairro do Tomador é obrigatório';
    ce266: Result := 'Campo Cidade do Tomador é obrigatório';
    ce300: Result := 'Tipo de Registro Inválido';
    ce301: Result := 'Código de Outros Valores Inválido';
    ce302: Result := 'Caso seja retenção: Valor da Retenção não poderá ser menor/igual a zero Caso seja "VN" Valor deve ser diferente de zero';
    ce303: Result := 'Soma do serviço prestado e valor "VN" não poderá ser inferior a zero.';
    ce304: Result := 'Código de Outros Valores envia';
    ce305: Result := 'Conforme Lei Complementar 419 / 2017, ficam revogados, a partir de 30 de dezembro de 2017, todos os regimes especiais e soluções ' +
                     'de consulta cujo resultado ermitiu redução do preço do serviço ou da base de cálculo do Imposto Sobre Serviço de Qualquer Natureza.';
    ce400: Result := 'Tipo de Registro Inválido';
    ce401: Result := 'Número de Linhas não confere com número de linhas do tipo 1,2,3 e 9 enviadas no arquivo';
    ce402: Result := 'Valor Total dos Serviços não confere os valores de serviços enviados no arquivo';
    ce403: Result := 'Valor Total das Retenções e Total de outros valores informados no registro 3 não confere com total informado';
    ce000: Result := 'Lay-Out do arquivo fora dos padrões';
    ce500: Result := 'Lay-Out do arquivo fora dos padrões';
    ce600: Result := 'Lay-Out do arquivo fora dos padrões';
    ce700: Result := 'Quantidade de RPS superior ao padrão';
    ce800: Result := 'Tipo de Registro Inválido';
    ce801: Result := 'Campo Optante Simples Nacional não informado e/ou fora dos padrões estabelecidos no layout';
    ce802: Result := 'Campo Regime de Apuração Tributária pelo Simples Nacional do Prestador de Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce803: Result := 'Campo Código do País do local do Serviço Prestado não informado e/ou fora dos padrões estabelecidos no layout';
    ce804: Result := 'Campo Código da Cidade do Local da Prestação do Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce805: Result := 'Campo Código Cidade do Tomador não informado e/ou fora dos padrões estabelecidos no layout';
    ce806: Result := 'Campo NIF não informado e/ou fora dos padrões estabelecidos no layout';
    ce807: Result := 'Campo Código NBS não informado e/ou fora dos padrões estabelecidos no layout';
    ce808: Result := 'Campo Código de Endereço Postal - Tomador Estrangeiro não informado e/ou fora dos padrões estabelecidos no layout';
    ce809: Result := 'Campo Estado/Província/Região - Tomador Estrangeiro não informado e/ou fora dos padrões estabelecidos no layout';
    ce810: Result := 'Campo Vinculo entre as partes do negócio não informado e/ou fora dos padrões estabelecidos no layout';
    ce811: Result := 'Campo Código de Endereço Postal - Serviço prestado no Exterior não informado e/ou fora dos padrões estabelecidos no layout';
    ce812: Result := 'Campo Estado/Província/Região - Serviço prestado no Exterior não informado e/ou fora dos padrões estabelecidos no layout';
    ce813: Result := 'Campo Nome do Evento não informado e/ou fora dos padrões estabelecidos no layout';
    ce814: Result := 'Campo Data de início da atividade de evento não informado e/ou fora dos padrões estabelecidos no layout';
    ce815: Result := 'Campo Data de fim da atividade de evento não informado e/ou fora dos padrões estabelecidos no layout';
    ce816: Result := 'Campo Código de justificativa de cancelamento substituição: não informado e/ou fora dos padrões estabelecidos no layout';
    ce817: Result := 'Campo Código Indicador da operação de fornecimento não informado e/ou fora dos padrões estabelecidos no layout';
    ce818: Result := 'Campo Código de Classificação Tributária do IBS e da CBS não informado e/ou fora dos padrões estabelecidos no layout';
    ce819: Result := 'Campo Código de Situação Tributária IBS CBS não informado e/ou fora dos padrões estabelecidos no layout';
    ce820: Result := 'Campo Operação de uso ou consumo pessoal não informado e/ou fora dos padrões estabelecidos no layout';
    ce821: Result := 'Campo Indicador do Destinatário do Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce822: Result := 'Tipo de Registro Inválido';
    ce823: Result := 'Campo Código e classificação do crédito presumido IBS e CBS não informado e/ou fora dos padrões estabelecidos no layout';
    ce824: Result := 'Campo Tipo de Ente Governamental para o caso de aquisição de serviços pela administração pública não informado e/ou fora dos padrões estabelecidos no layout';
    ce825: Result := 'Campo Tipo de Operação com entes Governamentais ou sobre bens imóveis não informado e/ou fora dos padrões estabelecidos no layout';
    ce826: Result := 'Campo Chave da NFS-e referenciada não informado e/ou fora dos padrões estabelecidos no layout';
    ce827: Result := 'Campo Código da Nomenclatura Comum do Mercosul - NCM do bem móvel objeto de locação não informado e/ou fora dos padrões estabelecidos no layout';
    ce828: Result := 'Campo Descrição do bem móvel objeto de locação não informado e/ou fora dos padrões estabelecidos no layout';
    ce829: Result := 'Campo Quantidade para bem móvel objeto de locação não informado e/ou fora dos padrões estabelecidos no layout';
    ce830: Result := 'Campo Indicador de operação de doação não informado e/ou fora dos padrões estabelecidos no layout';
    ce831: Result := 'Campo Destinatário do serviço é estrangeiro? não informado e/ou fora dos padrões estabelecidos no layout';
    ce832: Result := 'Campo CPF/ CNPJ do Destinatário do Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce833: Result := 'Campo Razão Social / Nome do Destinatário do Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce834: Result := 'Campo Endereço Logradouro do Destinatário do Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce835: Result := 'Campo Numero Logradouro do Destinatário do Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce836: Result := 'Campo Complemento Logradouro do Destinatário do Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce837: Result := 'Campo Bairro Logradouro do Destinatário do Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce838: Result := 'Campo Cidade Logradouro do Destinatário do Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce839: Result := 'Campo Código da Cidade do Destinatário do Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce840: Result := 'Campo UF Logradouro do Destinatário do Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce841: Result := 'Campo Código do País do Destinatário do Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce842: Result := 'Campo CEP Logradouro do Destinatário do Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce843: Result := 'Campo e-mail do Destinatário do Serviço não informado e/ou fora dos padrões estabelecidos no layout';
    ce844: Result := 'Campo NIF do Destinatário não informado e/ou fora dos padrões estabelecidos no layout';
    ce845: Result := 'Campo Código de Endereço Postal - Destinatário Estrangeiro não informado e/ou fora dos padrões estabelecidos no layout';
    ce846: Result := 'Campo Estado/Província/Região - Destinatário Estrangeiro não informado e/ou fora dos padrões estabelecidos no layout';
    ce900: Result := 'Tamanho do Registro diferente da especificação do layout';
    ce901: Result := 'Arquivo com ausência de um dos Registros: 1, 2 ou 9';
  else
    Result := 'Desconhecido';
  end;
end;

function TACBrNFSeProviderISSBarueri.GetSolucao(
  const ACodigo: TCodigoErro): String;
begin
  case ACodigo of
    ce100: Result := 'Informar Tipo Especificado: 1';
    ce101: Result := 'Informar Número Correto do Prestador de Serviços';
    ce102: Result := 'Informar Número válido e único/exclusivo. Um número outra enviado jamais poderá ser enviado novamente';
    ce200: Result := 'Informar Tipo Especificado: 2';
    ce201: Result := 'Informar Tipo Especificado: RPS / RPS-C';
    ce202: Result := 'Informar o Número de Série do RPS Válida';
    ce203: Result := 'Informar o Número de Série da NF-e Válida';
    ce204: Result := 'Informar o Número do RPS';
    ce205: Result := 'Informar um Número de RPS Válido';
    ce206: Result := 'Informar o RPS apenas uma vez no arquivo, caso envie vários arquivos simultâneos enviar o RPS uma vez em apenas 1 dos arquivos.';
    ce207: Result := 'Informar NF-e Válida.';
    ce208: Result := 'A data informada deverá estar no formato AAAAMMDD, ou seja, 4 dígitos para ano seguido de 2 dígitos para o mês seguido de 2 dígitos para o dia.';
    ce209: Result := 'Informar uma Data Válida';
    ce210: Result := 'Informar uma Data Válida';
    ce211: Result := 'A hora informada deverá estar no formato HHMMSS, ou seja, 2 dígitos para hora em seguida 2 dígitos para os minutos e e 2 dígitos para os segundos.';
    ce212: Result := 'Informar a Situação Especificada: E para RPS Enviado / C para RPS Cancelado';
    ce213: Result := 'Informar o Código Especificado: 01 para Extravio / 02 para Dados Incorretos / 03 para Substituição';
    ce214: Result := 'Informar a Descrição do Cancelamento';
    ce215: Result := 'Cancelar a guia correspondente a nota fiscal';
    ce216: Result := 'Informar Código de Atividade Válido';
    ce217: Result := 'Informar o Local Especificado:1 para serviço prestado no Município / 2 para serviço prestado fora do Município / 3 para serviço prestado fora do País';
    ce218: Result := 'Informe 1 para serviço prestado em vias públicas / 2 para serviço não prestado em vias públicas.';
    ce219: Result := 'Informar Endereço';
    ce220: Result := 'Informar Número';
    ce221: Result := 'Informar Bairro';
    ce222: Result := 'Informar Cidade';
    ce223: Result := 'Informar UF Tomador';
    ce224: Result := 'Informar UF Tomador Válida';
    ce225: Result := 'Informar CEP';
    ce226: Result := 'Informar um Valor Válido';
    ce227: Result := 'Informar um Valor Válido';
    ce228: Result := 'Reservado';
    ce229: Result := 'Reservado';
    ce230: Result := 'Informar um Valor Válido.';
    ce231: Result := 'Informar um Valor Válido.';
    ce232: Result := 'Informar Somatória dos Valores de Retenções informadas no registro 3 referente a este RPS';
    ce233: Result := 'Informe 1 Para Tomador Estrangeiro 2 para Tomador Brasileiro';
    ce234: Result := 'Informe um código de pais válido';
    ce235: Result := 'Informe 1 Para Serviço exportado 2 para Serviço não exportado.';
    ce236: Result := 'Informar Indicador do CPF/CNPJ Especificado:1 para CPF / 2 para CNPJ';
    ce237: Result := 'Informar o CPNJ do Tomador Válido';
    ce238: Result := 'Informar Razão Social';
    ce239: Result := 'Informar Endereço';
    ce240: Result := 'Informar Número';
    ce241: Result := 'Informar Bairro';
    ce242: Result := 'Informar Cidade';
    ce243: Result := 'Informar UF Tomador';
    ce244: Result := 'Informar UF Tomador Válida';
    ce245: Result := 'Informar CEP';
    ce246: Result := 'Informar e-mail Válido';
    ce247: Result := 'Informar um conteudo válido.';
    ce248: Result := 'Informar um Valor Válido';
    ce249: Result := 'Informar Forma de Pagamento';
    ce250: Result := 'Informar a Discriminação do Serviço';
    ce251: Result := 'Informar valores validos';
    ce252: Result := 'A data informada deverá estar no formato AAAAMMDD, ou seja, 4 dígitos para ano seguido de 2 dígitos para o mês seguido de 2 dígitos para o dia.';
    ce253: Result := 'Informar NF-e valida para cancelamento/substituição';
    ce254: Result := 'Informar NF-e valida para cancelamento/substituição';
    ce255: Result := 'O valor da nota fiscal é calculado: (quantidade do serviço x preço unitário) + valor "VN" informado no registro 3. Esse resultado pode ser zero desde que o valor do serviço ou VN seja diferente de zero.';
    ce256: Result := 'Artigo 3º. Os contribuintes com restrições cadastrais estão impedidos de utilizar os sistemas ora instituídos. ' +
                     '-Contribuinte com situação diferente de ativo não poderá converter RPS emitidos após a data da alteração da situação. Dúvidas entrar em contato com o Depto. Técnico de Tributos Mobiliários no Tel. 4199-8050.';
    ce257: Result := 'Informar a Nota Fiscal apenas uma vez no arquivo, caso envie vários arquivos simultâneos enviar a Nota uma vez em apenas 1 dos arquivos.';
    ce258: Result := 'Para prosseguir é necessário retificar o movimento através do menu "Retificar Serviços Prestados"';
    ce259: Result := 'Para prosseguir é necessário retificar o movimento através do menu "Retificar Serviços Prestados"';
    ce260: Result := 'Informar um Código de Atividade vinculado ao Perfil do Contribuinte ou um Código de Atividade tributada.';
    ce261: Result := 'Informar um Código de Atividade vinculado ao Perfil do Contribuinte (Atingido o limite permitido de notas para atividade não vinculadas ao cadastro do contribuinte).';
    ce262: Result := 'Não há apontamento de rejeito pelo ADN para o RPS informado, logo não é possível reenvio de informação';
    ce263: Result := 'Informar Endereço';
    ce264: Result := 'Informar Número';
    ce265: Result := 'Informar Bairro';
    ce266: Result := 'Informar Cidade';
    ce300: Result := 'Informar Tipo Especificado: 3';
    ce301: Result := 'Informar o Código Especificado: 01 - para IRRF 02 - para PIS/PASEP 03 - para COFINS 04 - ' +
                     'para CSLL VN - para Valor não Incluso na Base de Cálculo (exceto tributos federais). Esse campo somado ao valor total dos serviços resulta no Valor total da nota.';
    ce302: Result := 'Caso não tenha retenção não informar o registro ou informe um valor maior que zero. Se for "VN" informar um valor diferente de zero ou simplesmente não informe esse registro';
    ce303: Result := 'Informar um Valor Válido.';
    ce304: Result := 'Informar Código de Retenção Válido';
    ce305: Result := 'Não informar este tipo de dedução para RPS cuja a data base de cálculo seja superior à 29/12/2017.';
    ce400: Result := 'Informar Tipo Especificado: 9';
    ce401: Result := 'Informe o número de linhas (tipo 1,2,3 e 9)';
    ce402: Result := 'Informar Somatória dos Valores Totais de Serviços Prestados (Soma dos valores dos serviços multiplicados pelas quantidades de cada serviço)';
    ce403: Result := 'Informar Somatória dos Valores Totais lançados no Registro tipo 3.';
    ce000: Result := 'O arquivo enviado não é um arquivo de Remessa da NFe de Barueri. Enviar um arquivo com os Registros: 1, 2, 9 e opcionalmente o registro tipo 3';
    ce500: Result := 'Os registros válidos esperados no arquivo são tipo: 1,2,3 e 9';
    ce600: Result := 'Deve haver apenas 1 registro tipo 9 e esse deve ser o último registro do arquivo';
    ce700: Result := 'Enviar um arquivo com no máximo 1000 RPS';
	ce800: Result := 'Informar Tipo Especificado: 4';
    ce801: Result := 'Informar Situação do Prestador de Serviço / contribuinte perante o Simples Nacional: 1 - Não Optante; 2 - Optante - Microempreendedor Individual (MEI); 3 - Optante - Microempresa ou Empresa de Pequeno Porte (ME/EPP);';
    ce802: Result := '*Informar somente quando o campo "Enquadramento do Prestador do Serviço no Simples Nacional" estiver preenchido com a opção "3": 1 – Regime de apuração dos tributos federais e municipal pelo Simples Nacional; 2 – Regime de apura'+'ção dos tributos federais pelo Simples Nacional e o ISSQN pela NFS-e conforme respectiva legislação municipal do tributo; 3 – Regime de apuração dos tributos federais e '+'municipal pela NFS-e conforme respectivas legislação federal e municipal de cada tributo;';
    ce803: Result := 'Informar código do país do local do Serviço Prestado, conforme tabela de países, informado somente quando o campo "Serviço prestado é exportação" no registro tipo "2". *Exceto para serviços prestados no Brasil.';
    ce804: Result := 'Informar o código do município do endereço do prestador do serviço conforme tabela do IBGE, somente para serviços prestados no Brasil. Tabela disponível em: https://www.ibge.gov.br/explica/codigos-dos-municipios.php';
    ce805: Result := 'Informar o código do município do Tomador conforme tabela do IBGE, somente para Tomador nacional. Tabela disponível em: https://www.ibge.gov.br/explica/codigos-dos-municipios.php';
    ce806: Result := 'Obrigatório somente quando tomador de serviço estrangeiro, identificado no Registro tipo "2". Número de identificação fiscal fornecido por órgão de administração tributária no exterior.';
    ce807: Result := 'Informar o Código NBS correspondente ao respectivo código de serviço prestado. Essa correspondência deve considerar os quatro primeiros dígitos do código de serviço (Item da LC 116/03 x NBS), conforme a Tabela do Anexo VIII - Co'+'rrelaçãoItemNBSIndOp. Tabela disponível em: https://www.gov.br/nfse/pt-br/biblioteca/documentacao-tecnica';
    ce808: Result := 'Obrigatório somente quando tomador de serviço estrangeiro, identificado no Registro tipo "2". Informar o código alfanumérico do Endereçamento Postal no exterior do tomador do serviço.';
    ce809: Result := 'Obrigatório somente quando tomador de serviço estrangeiro, identificado no Registro tipo "2". Informar o Estado/província/região no exterior do tomador do serviço.';
    ce810: Result := 'Obrigatório somente quando tomador de serviço estrangeiro, identificado no Registro tipo "2" ou quando o local de prestação do serviço é no exterior (campo "serviço prestado é exportação" no registro tipo "2"). 0 - Sem vínculo co'+'m o Tomador / Prestador; 1 - Controlada; 2 - Controladora; 3 - Coligada; 4 - Matriz; 5 - Filial ou sucursal; 6 - Outro vínculo;';
    ce811: Result := 'Obrigatório somente quando o local de prestação do serviço é no exterior (campo "serviço prestado é exportação" no registro tipo "2"). Informar o Código de Endereçamento Postal alfanumérico do endereço quando o serviço é prestado no exterior.';
    ce812: Result := 'Obrigatório somente quando o local de prestação do serviço é no exterior (campo "serviço prestado é exportação" no registro tipo "2"). Informar Estado/província/região no exterior do local de prestação do serviço.';
    ce813: Result := 'Obrigatório somente para atividades com código de serviço iniciados em 12 (Serviços relativos à atividades de eventos, diversões, lazer, entretenimento e congêneres). Informar Nome do evento Artístico, Cultural, Esportivo, entre outros.';
    ce814: Result := 'Obrigatório somente para atividades com código de serviço iniciados em 12 (Serviços relativos à atividades de eventos, diversões, lazer, entretenimento e congeneres). Informar Data válida de início da atividade de evento. Ano, Mês e Dia (AAAAMMDD).';
    ce815: Result := 'Obrigatório somente para atividades com código de serviço iniciados em 12 (Serviços relativos à atividades de eventos, diversões, lazer, entretenimento e congeneres). Informar Data válida de fim da atividade de evento. Ano, Mês e Dia (AAAAMMDD).';
    ce816: Result := 'Obrigatório somente para os casos de RPS com Código de Motivo de Cancelamento "03 - Substituição" no registro Tipo "2". Informar Código de justificativa de cancelamento substituição: 1 - Desenquadramento de NFS-e do Simples Nacion'+'al; 2 - Enquadramento de NFS-e no Simples Nacional; 3 - Inclusão Retroativa de Imunidade/Isenção para NFS-e; 4 - Exclusão Retroativa de Imunidade/Isenção para NFS-e; 5'+' - Rejeição de NFS-e pelo tomador ou pelo intermediário se responsável pelo recolhimento do tributo; 9 - Outros;';
    ce817: Result := '*Informar o código Indicador de Operação, que deve corresponder: • Aos 4 primeiros dígitos do código do serviço prestado, conforme relação do Anexo VIII (Item LC116 x indOp); • Ao código NBS informado, de acordo com o Anexo VIII -'+' (NBS x indOp); Tabela disponível em: https://www.gov.br/nfse/pt-br/biblioteca/documentacao-tecnica/rtc';
    ce818: Result := '*Informar o código de classificação tributária informado, que deve corresponder: • Aos 4 primeiros dígitos do código do serviço prestado, conforme relação do Anexo VIII (Item LC116 x cClassTrib); • Ao código NBS informado, de acord'+'o com o Anexo VIII - (NBS x cClassTrib); • Ao Código Indicador de Operação conforme relação do Anexo VIII (indOp x cClassTrib); O Anexo VIII - correlação LC116 X cClas'+'sTrib está disponível em: https://www.gov.br/nfse/pt-br/biblioteca/documentacao-tecnica A relação de códigos de classificação tributária está disponível em: https://dfe-portal.svrs.rs.gov.br/Nfse/Documentos';
    ce819: Result := 'Informar Código de Situação Tributária do IBS e da CBS. Tabela disponível em: https://dfe-portal.svrs.rs.gov.br/DFE/TabelaClassificacaoTributaria *O preenchimento do Código de Situação Tributária deve corresponder exatamente aos 3 p'+'rimeiros dígitos do código informado no campo "Código de Classificação Tributária do IBS e da CBS".';
    ce820: Result := 'Indicar se a operação da nota fiscal de serviços é de uso ou consumo pessoal. (O Art. 57 LC 214/2025 estabelece situação onde um bem ou serviço adquirido é de caráter pessoal.) Opções: 0=Não | 1=Sim';
    ce821: Result := 'Informar uma das opções abaixo: 0 – Destinatário é o próprio tomador/adquirente identificado na NFS-e (tomador=adquirente=destinatário); 1 – Destinatário não é o próprio adquirente, podendo ser outra pessoa, física ou jurídica (ou eq'+'uiparada), ou um estabelecimento diferente do indicado como tomador (tomador=adquirente diferente destinatário);';
    ce822: Result := 'Informar Tipo Especificado: 5';
    ce823: Result := '*Obrigatório somente quando: Código da classificação tributária informado no Registro 4 exigir a informação do código do crédito presumido. O código de crédito presumido deve corresponder à classificação tributária, conforme tabela di'+'sponível abaixo, é necessário aplicar o filtro de visão aberta por cClassTrib, tabela com correlação disponível em: https://dfe-portal.svrs.rs.gov.br/DFE/Classificac'+'aoTributaria. Tabela com Códigos Crédito Presumido IBS/CBS, disponível em: https://dfe-portal.svrs.rs.gov.br/DFE/TabelaCreditoPresumido';
    ce824: Result := 'Obrigatório somente para compras governamentais. Este campo deve ser preenchido quando o adquirente/tomador do serviço for um dos órgãos públicos listados abaixo. Tipo de Ente Governamental: 1 = União, 2 = Estado, 3 = Distrito Federal, 4 = Município';
    ce825: Result := 'Obrigatório somente quando: Atividade com código de serviço iniciado em "25.05" OU Atividade com código de serviço iniciado em "15.09" OU Atividade com código de serviço iniciado em "17.12" OU Atividade com código de serviço iniciado e'+'m "10.05" OU Campo "tipo de ente governamental é preenchido". Opções: 1 – Fornecimento com pagamento posterior; 2 – Recebimento do pagamento com fornecimento já real'+'izado; 3 – Fornecimento com pagamento já realizado; 4 – Recebimento do pagamento com fornecimento posterior; 5 – Fornecimento e recebimento do pagamento concomitantes.';
    ce826: Result := 'Obrigatório somente quando: Campo "Tipo de Operação com entes Governamentais ou sobre bens imóveis" é preenchido com 2; OU Campo "Tipo de Operação com entes Governamentais ou sobre bens imóveis" é preenchido com 3.';
    ce827: Result := '*Obrigatório somente quando: O código de serviço prestado é iniciado em "990401". Preencher com código NCM da tabela disponível em: https://www.gov.br/receitafederal/pt-br/assuntos/aduana-e-comercio-exterior/classificacao-fiscal-de-mer'+'cadorias/download-ncm-nomenclatura-comum-do-mercosul';
    ce828: Result := '*Obrigatório somente quando: O código de serviço prestado é iniciado em "990401"';
    ce829: Result := '*Obrigatório somente quando: O código de serviço prestado é iniciado em "990401"';
    ce830: Result := '*Obrigatório somente quando: O campo "Código de Classificação Tributária do IBS e da CBS" do registro 4 é preenchido com "410003"; OU o campo "Código de Classificação Tributária do IBS e da CBS" do registro 4 é preenchido com "410026". Op'+'ções: 1 - Doação com contraprestação; 2 - Doação sem contraprestação';
    ce831: Result := '*Obrigatório somente quando: O campo "Indicador do Destinatário do Serviço" do Registro 4 é preenchido com "1". Opções: 1 - Sim; 2 - Não';
    ce832: Result := '*Obrigatório somente quando: O campo "Indicador do Destinatário do Serviço" do Registro 4 é preenchido com "1" E o campo "Destinatário do serviço é estrangeiro?" é preenchido com "2"- Não.';
    ce833: Result := '*Obrigatório para as seguintes situações: Se o campo "Indicador do Destinatário do Serviço" do Registro 4 é preenchido com "1".';
    ce834: Result := '*Obrigatório somente quando: O campo "Indicador do Destinatário do Serviço" do Registro 4 é preenchido com "1".';
    ce835: Result := '*Obrigatório somente quando: O campo "Indicador do Destinatário do Serviço" do Registro 4 é preenchido com "1".';
    ce836: Result := '*Quando existir a informação, obrigatório quando: O campo "Indicador do Destinatário do Serviço" do Registro 4 é preenchido com "1".';
    ce837: Result := '*Obrigatório somente quando: O campo "Indicador do Destinatário do Serviço" do Registro 4 é preenchido com "1".';
    ce838: Result := '*Obrigatório para as seguintes situações: Se o campo "Indicador do Destinatário do Serviço" do Registro 4 é preenchido com "1".';
    ce839: Result := '*Obrigatório somente quando: O campo "Indicador do Destinatário do Serviço" do Registro 4 é preenchido com "1" E o campo "Destinatário do serviço é estrangeiro?" do Registro 5 é preenchido com "2" (Não). Preencher com o'+' código do município conforme tabela do IBGE, disponível em: https://www.ibge.gov.br/explica/codigos-dos-municipios.php';
    ce840: Result := 'Obrigatório somente quando: O campo "Indicador do Destinatário do Serviço" é preenchido com "1"; E O campo "Destinatário do Serviço é estrangeiro?" é preenchido com "2 - Não";';
    ce841: Result := '*Informar somente quando: O campo "Indicador do Destinatário do Serviço" é preenchido com "1"; E O campo "Destinatário do Serviço é estrangeiro?" é preenchido com "1 - Sim".';
    ce842: Result := '*Informar somente quando: O campo "Indicador do Destinatário do Serviço" é preenchido com "1"; E O campo "Destinatário do Serviço é estrangeiro?" é preenchido com "2 - Não"; Para CEP que não possui os 8 dígitos, completa'+'r com zeros a esquerda. Exemplos: 06401220, 00206540';
    ce843: Result := 'Permitido no máximo 3 e-mails, usando o caracter "|" (pipe ou barra vertical) como delimitador de e-mail, sendo o primeiro considerado principal. * Poderá ser preenchido quando o campo Destinatário do Serviço do Registro 4 é preenchido com "1";';
    ce844: Result := '*Informar somente quando: Se o campo "Indicador do Destinatário do Serviço" é preenchido com "1"; E Se o campo "Destinatário do Serviço é estrangeiro?" é preenchido com "1 - Sim";';
    ce845: Result := '*Informar somente quando: O campo "Indicador do Destinatário do Serviço" é preenchido com "1"; E O campo "Destinatário do Serviço é estrangeiro?" é preenchido com "1 - Sim";';
    ce846: Result := '*Informar somente quando: O campo "Indicador do Destinatário do Serviço" é preenchido com "1"; E O campo "Destinatário do Serviço é estrangeiro?" é preenchido com "1 - Sim";';
    ce900: Result := 'Reveja as posições/tamanho para cada registro, certifique-se que o tamanho dos registros conferem com o layout e contém o caracter de fim de linha conforme especificado no layout';
    ce901: Result := 'Reveja os registros do arquivo, certifique-se que todos registros mencionados estão presentes em seu arquivo. ' +
                     'Também certifique-se que todos os registros do arquivo contém o caracter de fim de linha conforme especificado no layout';
  else
    Result := 'Desconhecido';
  end;
end;

function TACBrNFSeProviderISSBarueri.ExisteErroRegistro(
  const ALinha: String): Boolean;
begin
  Result := (Length(ALinha) > 1971) and (
    (ALinha[1] = '1') or
    (ALinha[1] = '2') or
    (ALinha[1] = '3') or
    (ALinha[1] = '4') or
    (ALinha[1] = '5') or
    (ALinha[1] = '9'));
end;

function TACBrNFSeProviderISSBarueri.AplicarLineBreak(const AXMLRps,
  ABreak: string): string;
begin
  Result := AXMLRps;
end;

procedure TACBrNFSeProviderISSBarueri.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    QuebradeLinha := '|';
    Identificador := '';
    UseCertificateHTTP := True;
    ModoEnvio := meLoteAssincrono;
    ConsultaNFSe := False;
    FormatoArqRecibo := tfaTxt;
    NumMaxRpsEnviar := 1000;

    ServicosDisponibilizados.EnviarLoteAssincrono := True;
    ServicosDisponibilizados.ConsultarSituacao := True;
    ServicosDisponibilizados.ConsultarLote := True;
    ServicosDisponibilizados.ConsultarServicoTomado := True;
    ServicosDisponibilizados.CancelarNfse := True;

    Particularidades.PermiteMaisDeUmServico := True;
  end;

  with ConfigMsgDados do
  begin
    Prefixo := 'nfe';

    LoteRps.DocElemento := 'NFeLoteEnviarArquivo';
    LoteRps.xmlns := 'http://www.barueri.sp.gov.br/nfe';

    ConsultarSituacao.DocElemento := 'NFeLoteStatusArquivo';
    ConsultarSituacao.xmlns := 'http://www.barueri.sp.gov.br/nfe';

    ConsultarLote.DocElemento := 'NFeLoteBaixarArquivo';
    ConsultarLote.xmlns := 'http://www.barueri.sp.gov.br/nfe';

    ConsultarNFSe.DocElemento := 'ConsultaNFeRecebidaPeriodo';
    ConsultarNFSe.xmlns := 'http://www.barueri.sp.gov.br/nfe';

    GerarNSLoteRps := False;
    GerarPrestadorLoteRps := False;
    UsarNumLoteConsLote := False;
  end;

  SetXmlNameSpace('http://www.barueri.sp.gov.br/nfe');
  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderISSBarueri.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ISSBarueri.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSBarueri.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ISSBarueri.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSBarueri.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceISSBarueri.Create(FAOwner, AMetodo, URL)
  else
    raise EACBrDFeException.Create('ERR_SEM_URL');
end;

procedure TACBrNFSeProviderISSBarueri.TratarRetornoEmitir(
  Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;
  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit;
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);
      ProcessarMensagemErros(Document.Root, Response, 'ListaMensagemRetorno');
      Response.Sucesso := (Response.Erros.Count = 0);
      ANode := Document.Root;
      Response.Data := Now;
      Response.Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('ProtocoloRemessa'), tcStr);
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderISSBarueri.GerarMsgDadosEmitir(
  Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
var
  XML: String;
  Emitente: TEmitenteConfNFSe;
  Registro1, Registro9, AIdentificacaoRemessa: string;
  Nota: TNotaFiscal;
  ValorServicos, ValorTotalRetencoes: Double;
  I, TotalLinhas: Integer;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  ValorServicos := 0;
  ValorTotalRetencoes := 0;
  TotalLinhas := 0;

  for I := 0 to TACBrNFSeX(FAOwner).NotasFiscais.Count - 1 do
  begin
    Nota := TACBrNFSeX(FAOwner).NotasFiscais.Items[I];

    if I = 0 then
    begin
      AIdentificacaoRemessa := Nota.NFSe.IdentificacaoRemessa;

      if AIdentificacaoRemessa = '' then
        AIdentificacaoRemessa := Nota.NFSe.IdentificacaoRps.Numero;

      if Nota.NFSe.StatusRps = srCancelado then
        AIdentificacaoRemessa := FormatDateTime('yyyymmddzzz', Now);

      Registro1 := '1' +
                   PadRight(Emitente.InscMun, 7, ' ');

      if ConfigGeral.Params.TemParametro('PMB004') then
        Registro1 := Registro1 + 'PMB004'
      else
        Registro1 := Registro1 + 'PMB002';

      Registro1 := Registro1 + PadLeft(AIdentificacaoRemessa, 11, '0') + CRLF;

      // Inclui no total de linhas o Registro 1
      TotalLinhas := 1;
    end;

    // Informação contida no Registro 2
    ValorServicos := ValorServicos +
                     Nota.NFSe.Servico.Valores.ValorServicos;
    Inc(TotalLinhas);

    // Informações contidas no Registro 3
    ValorTotalRetencoes := ValorTotalRetencoes +
                           Nota.NFSe.Servico.Valores.ValorIr +
                           Nota.NFSe.Servico.Valores.ValorPis +
                           Nota.NFSe.Servico.Valores.ValorCofins +
                           Nota.NFSe.Servico.Valores.ValorCsll;

    if Nota.NFSe.Servico.Valores.ValorIr > 0 then
      Inc(TotalLinhas);

    if Nota.NFSe.Servico.Valores.ValorPis > 0 then
      Inc(TotalLinhas);

    if Nota.NFSe.Servico.Valores.ValorCofins > 0 then
      Inc(TotalLinhas);

    if Nota.NFSe.Servico.Valores.ValorCsll > 0 then
      Inc(TotalLinhas);
  end;

  if ConfigGeral.Params.TemParametro('PMB004') then
  begin
    // Inclui no total de linhas o Registro 4
    Inc(TotalLinhas);

    // Inclui no total de linhas o Registro 5
    Inc(TotalLinhas);
  end;

  // Inclui no total de linhas o Registro 9
  Inc(TotalLinhas);

  Registro9 := '9' +
        PadLeft(IntToStr(TotalLinhas), 7, '0') +
        PadLeft(FloatToStr(ValorServicos * 100), 15, '0') +
        PadLeft(FloatToStr(ValorTotalRetencoes * 100), 15, '0') + CRLF;

  Params.Xml := Registro1 + Params.Xml + Registro9;

  XML := '<NFeLoteEnviarArquivo xmlns="http://www.barueri.sp.gov.br/nfe">';
  XML := XML + '<InscricaoMunicipal>' + Emitente.InscMun + '</InscricaoMunicipal>';
  XML := XML + '<CPFCNPJContrib>' + Emitente.CNPJ + '</CPFCNPJContrib>';
  XML := XML + '<NomeArquivoRPS>' + Format('Rps-0%s.txt', [AIdentificacaoRemessa]) + '</NomeArquivoRPS>';
  XML := XML + '<ApenasValidaArq>false</ApenasValidaArq>';
  XML := XML + '<ArquivoRPSBase64>' + string(EncodeBase64(AnsiString(Params.Xml))) + '</ArquivoRPSBase64>';
  XML := XML + '</NFeLoteEnviarArquivo>';

  Response.ArquivoEnvio := XML;
end;

function TACBrNFSeProviderISSBarueri.PrepararRpsParaLote(
  const aXml: string): string;
begin
  Result := aXml;
end;

procedure TACBrNFSeProviderISSBarueri.PrepararConsultaSituacao(
  Response: TNFSeConsultaSituacaoResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  XML: String;
begin
  if EstaVazio(Response.Protocolo) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod101;
    AErro.Descricao := ACBrStr(Desc101);
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  XML := '<NFeLoteStatusArquivo xmlns="http://www.barueri.sp.gov.br/nfe">';
  XML := XML + '<InscricaoMunicipal>' + Emitente.InscMun + '</InscricaoMunicipal>';
  XML := XML + '<CPFCNPJContrib>' + Emitente.CNPJ + '</CPFCNPJContrib>';
  XML := XML + '<ProtocoloRemessa>' + Response.Protocolo + '</ProtocoloRemessa>';
  XML := XML + '</NFeLoteStatusArquivo>';

  Response.ArquivoEnvio := XML;
end;

procedure TACBrNFSeProviderISSBarueri.TratarRetornoConsultaSituacao(
  Response: TNFSeConsultaSituacaoResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode, AuxNode: TACBrXmlNode;
  Ok: Boolean;
  Situacao: TSituacaoLoteRps;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit;
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, 'ListaMensagemRetorno');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;
      AuxNode := ANode.Childrens.FindAnyNs('ListaNfeArquivosRPS');

      if (AuxNode = Nil) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit;
      end;

      Response.Data := Iso8601ToDateTime(ObterConteudoTag(AuxNode.Childrens.FindAnyNs('DataEnvioArq'), tcStr));
      Response.NumeroRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('CodigoRemessa'), tcStr);
      Response.Protocolo := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('NomeArqRetorno'), tcStr);
      Response.Situacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('SituacaoArq'), tcStr);

      Situacao := TACBrNFSeX(FAOwner).Provider.StrToSituacaoLoteRps(Ok, Response.Situacao);
      Response.DescSituacao := TACBrNFSeX(FAOwner).Provider.SituacaoLoteRpsToDescr(Situacao);
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderISSBarueri.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  XML, NumeroRps, xRps: String;
  Nota: TNotaFiscal;
begin
  if EstaVazio(Response.InfCancelamento.NumeroNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := ACBrStr(Desc108);
  end;

  if EstaVazio(Response.InfCancelamento.CodCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod109;
    AErro.Descricao := ACBrStr(Desc109);
  end;

  if EstaVazio(Response.InfCancelamento.MotCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod110;
    AErro.Descricao := ACBrStr(Desc110);
  end;

  if (TACBrNFSeX(FAOwner).NotasFiscais.Count <= 0) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod002;
    AErro.Descricao := ACBrStr(Desc002);
  end;

  if (Response.Erros.Count > 0) then
  begin
    Response.Sucesso := False;
    Exit;
  end;

  Nota := Nil;
  NumeroRps := '';

  if (Response.InfCancelamento.NumeroRps > 0) then
  begin
    NumeroRps := IntToStr(Response.InfCancelamento.NumeroRps);
    Nota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumeroRps);
  end;

  if (EstaVazio(NumeroRps)) then
  begin
    NumeroRps := Response.InfCancelamento.NumeroNFSe;
    Nota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(NumeroRps);
  end;

  if (Nota = Nil) then
    Nota := TACBrNFSeX(FAOwner).NotasFiscais.Items[0];

  Nota.NFSe.StatusRps := srCancelado;
  Nota.NFSe.MotivoCancelamento := Response.InfCancelamento.MotCancelamento;
  Nota.NFSe.CodigoCancelamento := Response.InfCancelamento.CodCancelamento;
  Nota.GerarXML;

  Nota.XmlRps := string(NativeStringToUTF8(Nota.XmlRps));

  SalvarXmlRps(Nota);

  xRps := RemoverDeclaracaoXML(Nota.XmlRps);
  xRps := PrepararRpsParaLote(xRps);

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  XML := '<NFeLoteEnviarArquivo xmlns="http://www.barueri.sp.gov.br/nfe">';
  XML := XML + '<InscricaoMunicipal>' + Emitente.InscMun + '</InscricaoMunicipal>';
  XML := XML + '<CPFCNPJContrib>' + Emitente.CNPJ + '</CPFCNPJContrib>';
  XML := XML + '<NomeArquivoRPS>' +
                  Format('Rps-Canc-%s.txt', [NumeroRps]) +
               '</NomeArquivoRPS>';
  XML := XML + '<ApenasValidaArq>false</ApenasValidaArq>';
  XML := XML + '<ArquivoRPSBase64>' +
                  string(EncodeBase64(AnsiString(xRps))) +
               '</ArquivoRPSBase64>';
  XML := XML + '</NFeLoteEnviarArquivo>';

  Response.ArquivoEnvio := XML;
end;

procedure TACBrNFSeProviderISSBarueri.TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit;
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, 'ListaMensagemRetorno');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;
      Response.Data := Now;
      Response.Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('ProtocoloRemessa'), tcStr);
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderISSBarueri.PrepararConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  XML: String;
begin
  if EstaVazio(Response.Protocolo) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod101;
    AErro.Descricao := ACBrStr(Desc101);
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  XML := '<NFeLoteBaixarArquivo xmlns="http://www.barueri.sp.gov.br/nfe">';
  XML := XML + '<InscricaoMunicipal>' + Emitente.InscMun + '</InscricaoMunicipal>';
  XML := XML + '<CPFCNPJContrib>' + Emitente.CNPJ + '</CPFCNPJContrib>';
  XML := XML + '<NomeArqRetorno>' + Response.Protocolo + '</NomeArqRetorno>';
  XML := XML + '</NFeLoteBaixarArquivo>';

  Response.ArquivoEnvio := XML;
end;

procedure TACBrNFSeProviderISSBarueri.TratarRetornoConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  ArquivoBase64: String;
  Dados: TStringList;
  NumRps: String;
  Erros: TStringList;
  ANota: TNotaFiscal;
  I, X: Integer;
  XML, wDataString: string;
  Ok: Boolean;
begin
  Document := TACBrXmlDocument.Create;
  Dados := TStringList.Create;
  Erros := TStringList.Create;
  Erros.Delimiter := ';';

  try
    try
      if EstaVazio(Response.ArquivoRetorno) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit;
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, 'ListaMensagemRetorno');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;
      ArquivoBase64 := ObterConteudoTag(ANode.Childrens.FindAnyNs('ArquivoRPSBase64'), tcStr);

      if (EstaVazio(ArquivoBase64) and (not StrIsBase64(ArquivoBase64))) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit;
      end;

      {$IFDEF FPC}
      Dados.LineBreak := CRLF;
      {$ELSE}
        {$IFDEF DELPHI2006_UP}
        Dados.LineBreak := CRLF;
        {$ENDIF}
      {$ENDIF}

      Dados.Text := string(DecodeBase64(AnsiString(ArquivoBase64)));

      for I := 0 to Pred(Dados.Count) do
      begin
        if (ExisteErroRegistro(Dados[I])) then
        begin
          // A partir do caractere 1971, é a listagem de codigo de erros
          Erros.DelimitedText := Trim(Copy(Dados[I], 1971, Length(Dados[I])));

          for X := 0 to Pred(Erros.Count) do
          begin
            if NaoEstaVazio(Erros[X]) then
            begin
              AErro := Response.Erros.New;
              AErro.Codigo := Erros[X];
              AErro.Descricao := GetCausa(StrToCodigoErro(Ok, Erros[X]));
              AErro.Correcao := GetSolucao(StrToCodigoErro(Ok, Erros[X]));
            end;
          end;
        end;
      end;

      Response.Sucesso := (Response.Erros.Count = 0);

      if ConfigGeral.Params.TemParametro('PMB004') then
      begin
        if Response.Sucesso then
          NumRps := Trim(Copy(Dados[1], 55, 10))
        else
          NumRps := Trim(Copy(Dados[1], 16, 10));
      end
      else
      begin
        NumRps := Trim(Copy(Dados[0], Pos('PMB002', Dados[0]), Length(Dados[0])));
        NumRps := StringReplace(NumRps, 'PMB002', '', [rfReplaceAll]);
      end;
      Response.NumeroRps := NumRps;

      //Retorno do Txt de um RPS Processado com sucesso...
      if ((Response.Sucesso) and (Length(Dados[0]) > 26)) then
      begin
        //1XXXXXXX0000000000000000PMB00200000000004
        //2     00000120220318211525723K.1473.0553.5240699-I...
        //Onde 723K.1473.0553.5240699-I é o Codigo de verificacao para fazer download do XML
        Response.Situacao := '1';
        Response.DescSituacao := 'Arquivo Importado';
        Response.Protocolo := Trim(Copy(Dados[1], 27, 24));
        Response.NumeroNota := Trim(Copy(Dados[1], 7, 6));
        Response.SerieRps := Trim(Copy(Dados[1], 51, 4));
        Response.SerieNota := Trim(Copy(Dados[1], 2, 5));
        Response.idNota := Trim(Copy(Dados[1], 1629, 50));

        TACBrNFSeX(FAOwner).WebService.ConsultaLoteRps.idNota:=Response.idNota;

        wDataString := Trim(Copy(Dados[1], 19, 2) + '/' + Copy(Dados[1], 17, 2) +
                       '/' + Copy(Dados[1], 13, 4));

        if NaoEstaVazio(Trim(Copy(Dados[1], 22, 6))) then
        begin
          Response.Data := StrToDateTime(wDataString);
          Response.Data := Response.Data +
                      StrToTime(Format('%S:%S:%S', [Trim(Copy(Dados[1], 21, 2)),
                      Trim(Copy(Dados[1], 23, 2)), Trim(Copy(Dados[1], 25, 2))]));
        end
        else
          Response.Data := StrToDateTime(wDataString);

        if (FAOwner.Configuracoes.WebServices.AmbienteCodigo = 1) then
          Response.Link := 'https://www.barueri.sp.gov.br/nfe/xmlNFe.ashx'
        else
          Response.Link := 'https://testeeiss.barueri.sp.gov.br/nfe/xmlNFe.ashx';

        Response.Link := Response.Link + '?codigoautenticidade=' +
                 Response.Protocolo + '&numdoc=' + Trim(Copy(Dados[1], 94, 14));

        if NaoEstaVazio(Response.Link) then
        begin
          XML := string(FAOwner.SSL.HTTPGet(Response.Link));

          if (NaoEstaVazio(XML) and
             (Pos('<ConsultarNfeServPrestadoResposta', XML) > 0) ) then
          begin
            XML := RemoverDeclaracaoXML(XML);
            XML := ConverteXMLtoUTF8(XML);
            Document.Clear();
            Document.LoadFromXml(XML);
            Dados.Clear;
            Dados.Text := XML;
          end;

          TACBrNFSeX(FAOwner).WebService.ConsultaLoteRps.XmlRetorno:=XML;
        end;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

        ANota := CarregarXmlNfse(ANota, Dados.Text);
        SalvarXmlNfse(ANota);
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
    FreeAndNil(Dados);
    FreeAndNil(Erros);
  end;
end;

procedure TACBrNFSeProviderISSBarueri.PrepararConsultaNFSeServicoTomado(
  Response: TNFSeConsultaNFSeResponse);
var
  XmlConsulta: String;
begin
  XmlConsulta := '<NFeRecebidaPeriodo xmlns="http://www.barueri.sp.gov.br/nfe">';

  if NaoEstaVAzio(Response.InfConsultaNFSe.CNPJTomador) then
  begin
    XmlConsulta := XmlConsulta +
                   '<CPFCNPJTomador>' +
                      Response.InfConsultaNFSe.CNPJTomador +
                   '</CPFCNPJTomador>';
  end;

  if (Response.InfConsultaNFSe.DataInicial > 0) and
     (Response.InfConsultaNFSe.DataFinal > 0) then
    XmlConsulta := XmlConsulta +
                     '<DataInicial>' +
                        FormatDateTime('yyyy-mm-dd', Response.InfConsultaNFSe.DataInicial) +
                     '</DataInicial>' +
                     '<DataFinal>' +
                        FormatDateTime('yyyy-mm-dd', Response.InfConsultaNFSe.DataFinal) +
                     '</DataFinal>';

  if NaoEstaVAzio(Response.InfConsultaNFSe.CNPJPrestador) then
  begin
    XmlConsulta := XmlConsulta +
                     '<' + 'CPFCNPJPrestador>' +
                          Response.InfConsultaNFSe.CNPJPrestador+
                       '</CPFCNPJPrestador>';
  end;

  XmlConsulta := XmlConsulta + '<Pagina>' +
                                  IntToStr( Response.InfConsultaNFSe.Pagina ) +
                               '</Pagina>' ;
  XmlConsulta := XmlConsulta + '</NFeRecebidaPeriodo>';

  Response.Metodo := tmConsultarNFSeServicoTomado;

  Response.ArquivoEnvio := XmlConsulta;
end;

procedure TACBrNFSeProviderISSBarueri.TratarRetornoConsultaNFSeServicoTomado(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  ANota: TNotaFiscal;
  NumNFSe: String;
  I: Integer;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      TACBrNFSeX(FAOwner).NotasFiscais.Clear;

      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response);

      ANode := ANode.Childrens.FindAnyNs('ListaNfe');

      if ANode = nil then
        ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANodeArray := ANode.Childrens.FindAllAnyNs('CompNfe');
      if not Assigned(ANodeArray) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := ACBrStr(Desc203);
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];
        AuxNode := ANode.Childrens.FindAnyNs('Nfe');
        AuxNode := AuxNode.Childrens.FindAnyNs('InfNFe');
        AuxNode := AuxNode.Childrens.FindAnyNs('NumeroNfe');
        NumNFSe := AuxNode.AsString;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(NumNFSe);

        CarregarXmlNfse(ANota, ANode.OuterXml);

        SalvarXmlNfse(ANota);
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderISSBarueri.ProcessarMensagemErros(
  RootNode: TACBrXmlNode; Response: TNFSeWebserviceResponse;
  const AListTag: string; const AMessageTag: string);
var
  Codigo: String;
  ANode: TACBrXmlNode;
  AErro: TNFSeEventoCollectionItem;
begin
  ANode := RootNode.Childrens.FindAnyNs(AListTag);

  if (ANode = Nil) then Exit;
    Codigo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Codigo'), tcStr);

  if (Codigo <> 'OK200') then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Codigo'), tcStr);
    AErro.Descricao := ObterConteudoTag(ANode.Childrens.FindAnyNs('Mensagem'), tcStr);
    AErro.Correcao := ObterConteudoTag(ANode.Childrens.FindAnyNs('Correcao'), tcStr);
  end;
  {
    As tag que contem o código, mensagem e correção do erro são diferentes do padrão
    <NFeLoteEnviarArquivoResult>
        <ListaMensagemRetorno>
            <Codigo>OK200</Codigo>
            <Mensagem>Procedimento executado com sucesso - Arquivo agendado para processamento: RPS-1.txt</Mensagem>
            <Correcao/>
        </ListaMensagemRetorno>
        <ProtocoloRemessa>ENV555318486B20220316155838</ProtocoloRemessa>
    </NFeLoteEnviarArquivoResult>
    <ListaMensagemRetorno>
        <Codigo>E0001</Codigo>
        <Mensagem>Certificado digital inválido ou não informado</Mensagem>
        <Correcao>Informe um certificado válido padrão ICP-Brasil</Correcao>
    </ListaMensagemRetorno>
  }
end;

function TACBrNFSeProviderISSBarueri.SituacaoLoteRpsToStr(const t: TSituacaoLoteRps): string;
begin
  Result := EnumeradoToStr(t,
                           ['-2', '-1', '0', '1', '2'],
                           [sLoteNaoProcessado, sLoteEmProcessamento,
                            sLoteValidado, sLoteImportado, sLoteProcessadoErro]);
end;

function TACBrNFSeProviderISSBarueri.StrToSituacaoLoteRps(out ok: boolean; const s: string): TSituacaoLoteRps;
begin
  Result := StrToEnumerado(ok, s,
                           ['-2', '-1', '0', '1', '2'],
                           [sLoteNaoProcessado, sLoteEmProcessamento,
                            sLoteValidado, sLoteImportado, sLoteProcessadoErro]);
end;

function TACBrNFSeProviderISSBarueri.SituacaoLoteRpsToDescr(const t: TSituacaoLoteRps): string;
begin
  Result := EnumeradoToStr(t,
                           ['Aguardando Processamento', 'Em Processamento',
                            'Arquivo Validado', 'Arquivo Importado',
                            'Arquivo com Erros'],
                           [sLoteNaoProcessado, sLoteEmProcessamento,
                            sLoteValidado, sLoteImportado, sLoteProcessadoErro]);
end;

function TACBrNFSeProviderISSBarueri.TipoTributacaoRPSToStr(
  const t: TTipoTributacaoRPS): string;
begin
  Result := EnumeradoToStr(t,
                           ['1', '2', '3', '4'],
                           [ttTribnoMun, ttTribforaMun, ttTribnoMunIsento,
                            ttTribnoMunSuspensa]);
end;

function TACBrNFSeProviderISSBarueri.StrToTipoTributacaoRPS(out ok: boolean;
  const s: string): TTipoTributacaoRPS;
begin
  Result := StrToEnumerado(OK, s,
                           ['1', '2', '3', '4'],
                           [ttTribnoMun, ttTribforaMun, ttTribnoMunIsento,
                            ttTribnoMunSuspensa]);
end;

{ TACBrNFSeXWebserviceISSBarueri }

function TACBrNFSeXWebserviceISSBarueri.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfe:NFeLoteEnviarArquivo>';
  Request := Request + '<nfe:VersaoSchema>1</nfe:VersaoSchema>';
  Request := Request + '<nfe:MensagemXML>';
  Request := Request + IncluirCDATA(AMSG);
  Request := Request + '</nfe:MensagemXML>';
  Request := Request + '</nfe:NFeLoteEnviarArquivo>';

  Result := Executar('http://www.barueri.sp.gov.br/nfe/NFeLoteEnviarArquivo',
                     Request,
                     ['NFeLoteEnviarArquivoResult'],
                     ['xmlns:nfe="http://www.barueri.sp.gov.br/nfe"']);
end;

function TACBrNFSeXWebserviceISSBarueri.ConsultarSituacao(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfe:NFeLoteStatusArquivo>';
  Request := Request + '<nfe:VersaoSchema>1</nfe:VersaoSchema>';
  Request := Request + '<nfe:MensagemXML>';
  Request := Request + IncluirCDATA(AMSG);
  Request := Request + '</nfe:MensagemXML>';
  Request := Request + '</nfe:NFeLoteStatusArquivo>';

  Result := Executar('http://www.barueri.sp.gov.br/nfe/NFeLoteStatusArquivo',
                     Request,
                     ['NFeLoteStatusArquivoResult'],
                     ['xmlns:nfe="http://www.barueri.sp.gov.br/nfe"']);
end;

function TACBrNFSeXWebserviceISSBarueri.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfe:NFeLoteBaixarArquivo>';
  Request := Request + '<nfe:VersaoSchema>1</nfe:VersaoSchema>';
  Request := Request + '<nfe:MensagemXML>';
  Request := Request + IncluirCDATA(AMSG);
  Request := Request + '</nfe:MensagemXML>';
  Request := Request + '</nfe:NFeLoteBaixarArquivo>';

  Result := Executar('http://www.barueri.sp.gov.br/nfe/NFeLoteBaixarArquivo',
                     Request,
                     ['NFeLoteBaixarArquivoResult'],
                     ['xmlns:nfe="http://www.barueri.sp.gov.br/nfe"']);
end;

function TACBrNFSeXWebserviceISSBarueri.ConsultarNFSeServicoTomado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfe:ConsultaNFeRecebidaPeriodo>';
  Request := Request + '<nfe:VersaoSchema>1</nfe:VersaoSchema>';
  Request := Request + '<nfe:MensagemXML>';
  Request := Request + IncluirCDATA(AMSG);
  Request := Request + '</nfe:MensagemXML>';
  Request := Request + '</nfe:ConsultaNFeRecebidaPeriodo>';


  Result := Executar('http://www.barueri.sp.gov.br/nfe/ConsultaNFeRecebidaPeriodo',
                     Request,
                     ['ConsultaNFeRecebidaPeriodoResult'],
                     ['xmlns:nfe="http://www.barueri.sp.gov.br/nfe"']);
end;

function TACBrNFSeXWebserviceISSBarueri.Cancelar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfe:NFeLoteEnviarArquivo>';
  Request := Request + '<nfe:VersaoSchema>1</nfe:VersaoSchema>';
  Request := Request + '<nfe:MensagemXML>';
  Request := Request + IncluirCDATA(AMSG);
  Request := Request + '</nfe:MensagemXML>';
  Request := Request + '</nfe:NFeLoteEnviarArquivo>';

  Result := Executar('http://www.barueri.sp.gov.br/nfe/NFeLoteEnviarArquivo',
                     Request,
                     ['NFeLoteEnviarArquivoResult'],
                     ['xmlns:nfe="http://www.barueri.sp.gov.br/nfe"']);
end;

end.

