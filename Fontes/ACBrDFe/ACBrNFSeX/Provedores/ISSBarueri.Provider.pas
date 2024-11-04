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
unit ISSBarueri.Provider;

interface

uses
  SysUtils, Classes, Variants,
  ACBrDFeSSL,
  ACBrXmlBase, ACBrXmlDocument,
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
                 ce260, ce261, ce300, ce301, ce302, ce303, ce304, ce305, ce400,
                 ce401, ce402, ce403, ce000, ce500, ce600, ce700, ce900, ce901,
                 ce999);

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

    function AplicarXMLtoUTF8(const AXMLRps: String): String; override;
    function AplicarLineBreak(const AXMLRps: String; const ABreak: String): String; override;

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
                 '260', '261', '300', '301', '302', '303', '304', '305', '400',
                 '401', '402', '403', '000', '500', '600', '700', '900', '901'],
                [ce999,
                 ce100, ce101, ce102, ce200, ce201, ce202, ce203, ce204, ce205,
                 ce206, ce207, ce208, ce209, ce210, ce211, ce212, ce213, ce214,
                 ce215, ce216, ce217, ce218, ce219, ce220, ce221, ce222, ce223,
                 ce224, ce225, ce226, ce227, ce228, ce229, ce230, ce231, ce232,
                 ce233, ce234, ce235, ce236, ce237, ce238, ce239, ce240, ce241,
                 ce242, ce243, ce244, ce245, ce246, ce247, ce248, ce249, ce250,
                 ce251, ce252, ce253, ce254, ce255, ce256, ce257, ce258, ce259,
                 ce260, ce261, ce300, ce301, ce302, ce303, ce304, ce305, ce400,
                 ce401, ce402, ce403, ce000, ce500, ce600, ce700, ce900, ce901]);
end;

function TACBrNFSeProviderISSBarueri.GetCausa(
  const ACodigo: TCodigoErro): String;
begin
  case ACodigo of
    ce100: Result := 'Tipo de Registro Inv�lido';
    ce101: Result := 'Inscri��o do Prestador de Servi�os n�o encontrada na base de dados da PMB';
    ce102: Result := 'Identifica��o da Remessa do Contribuinte inv�lida ou j� informada em outro arquivo de remessa';
    ce200: Result := 'Tipo de Registro Inv�lido';
    ce201: Result := 'Tipo de RPS Inv�lido';
    ce202: Result := 'N�mero de S�rie do RPS Inv�lida';
    ce203: Result := 'N�mero de S�rie da Nf-e Inv�lida';
    ce204: Result := 'N�mero de RPS n�o Informado ou inv�lido. Numera��o m�xima permitida 0009999999';
    ce205: Result := 'N�mero de RPS j� enviado';
    ce206: Result := 'Numero do RPS enviado em Duplicidade no Arquivo';
    ce207: Result := 'NF-e n�o consta na base de dados da PMB, n�o pode ser cancelada/substituida';
    ce208: Result := 'Data Inv�lida';
    ce209: Result := 'Data de Emiss�o n�o poder� ser inferior a 09/09/2008';
    ce210: Result := 'Data de Emiss�o do RPS n�o pode ser superior a Data de Hoje';
    ce211: Result := 'Hora de Emiss�o do RPS Inv�lida';
    ce212: Result := 'Situa��o do RPS Inv�lida';
    ce213: Result := 'C�digo do Motivo de Cancelamento Inv�lido';
    ce214: Result := 'Campo Descri��o do Cancelamento n�o informado';
    ce215: Result := 'NFe n�o pode ser cancelada, guia em aberto para nota fiscal correspondente';
    ce216: Result := 'C�digo de Atividade n�o encontrada na base da PMB';
    ce217: Result := 'Local da Presta��o do Servi�o Inv�lido';
    ce218: Result := 'Servi�o Prestado em Vias P�blicas Inv�lido';
    ce219: Result := 'Campo Endereco do Servi�o Prestado � obrigat�rio';
    ce220: Result := 'Campo N�mero do Logradouro do Servi�o Prestado � obrigat�rio';
    ce221: Result := 'Campo Bairro do Servi�o Prestado � obrigat�rio';
    ce222: Result := 'Campo Cidade do Servi�o Prestado � obrigat�rio';
    ce223: Result := 'Campo UF do Servi�o Prestado � obrigat�rio';
    ce224: Result := 'Campo UF do Servi�o Prestado invalido';
    ce225: Result := 'Campo CEP do Servi�o Prestado invalido';
    ce226: Result := 'Quantidade de Servi�o n�o dever� ser inferior a zero e/ou Quantidade de Servi�o dever� ser num�rico';
    ce227: Result := 'Valor do Servi�o n�o pode ser menor que zero e/ou Valor do Servi�o dever� ser num�rico';
    ce228: Result := 'Reservado';
    ce229: Result := 'Reservado';
    ce230: Result := 'Valor Total das Reten��es n�o dever� ser inferior a zero e/ou Valor Total das Reten��es dever� ser num�rico';
    ce231: Result := 'Valor Total das Reten��es n�o poder� ser superior ao Valor Total do servi�o prestado';
    ce232: Result := 'Valor Total dos Reten��es n�o confere com os valores dedu�oes informadas para este RPS';
    ce233: Result := 'Identificador de tomodor estrangeiro inv�lido';
    ce234: Result := 'C�digo do Pais de Nacionalidade do Tomador Estrangeiro inv�lido';
    ce235: Result := 'Identificador se Servi�o Prestado � exporta��o inv�lido';
    ce236: Result := 'Indicador CPF/CNPJ Inv�lido';
    ce237: Result := 'CPNJ do Tomador Inv�lido';
    ce238: Result := 'Campo Nome ou Raz�o Social do Tomador de Servi�os � Obrigat�rio';
    ce239: Result := 'Campo Endere�o do Tomador de Servi�os � Obrigat�rio';
    ce240: Result := 'Campo N�mero do Logradouro do Tomador de Servi�os';
    ce241: Result := 'Campo Bairro do Tomador de Servi�os � Obrigat�rio';
    ce242: Result := 'Campo Cidade do Tomador de Servi�os � Obrigat�rio';
    ce243: Result := 'Campo UF do Tomador de Servi�os � Obrigat�rio';
    ce244: Result := 'Campo UF do Tomador de Servi�os Inv�lido';
    ce245: Result := 'Campo CEP do Tomador de Servi�os Inv�lido';
    ce246: Result := 'Email do Tomador de Servi�os Inv�lido';
    ce247: Result := 'Campo Fatura dever� ser num�rico';
    ce248: Result := 'Valor da Fatura n�o dever� ser inferior a zero e/ou Valor da Fatura dever� ser num�rico';
    ce249: Result := 'Campo Forma de Pagamento n�o informado';
    ce250: Result := 'Campo Discrimina��o de Servi�o n�o informado e/ou fora dos padr�es estabelecidos no layout';
    ce251: Result := 'Valor Total do Servi�o superior ao permitido (campo valor do servi�o multiplicado pelo campo quantidade)';
    ce252: Result := 'Data Inv�lida';
    ce253: Result := 'NFe n�o pode ser cancelada, data de emiss�o superior a 90 dias';
    ce254: Result := 'Nota Fiscal J� Cancelada';
    ce255: Result := 'Nota Fiscal com valores zerados';
    ce256: Result := 'Contribuinte com condi��o diferente de ativo';
    ce257: Result := 'Nota Fiscal enviada em Duplicidade no Arquivo';
    ce258: Result := 'NFe n�o pode ser cancelada ou substituida compet�ncia j� encerrada';
    ce259: Result := 'Data de Emiss�o do RPS refere-se a compet�ncia j� encerrada';
    ce260: Result := 'C�digo de Atividade n�o permitido';
    ce261: Result := 'C�digo de Atividade Bloqueado';
    ce300: Result := 'Tipo de Registro Inv�lido';
    ce301: Result := 'C�digo de Outros Valores Inv�lido';
    ce302: Result := 'Caso seja reten��o: Valor da Reten��o n�o poder� ser menor/igual a zero Caso seja "VN" Valor deve ser diferente de zero';
    ce303: Result := 'Soma do servi�o prestado e valor "VN" n�o poder� ser inferior a zero.';
    ce304: Result := 'C�digo de Outros Valores envia';
    ce305: Result := 'Conforme Lei Complementar 419 / 2017, ficam revogados, a partir de 30 de dezembro de 2017, todos os regimes especiais e solu��es ' +
                     'de consulta cujo resultado ermitiu redu��o do pre�o do servi�o ou da base de c�lculo do Imposto Sobre Servi�o de Qualquer Natureza.';
    ce400: Result := 'Tipo de Registro Inv�lido';
    ce401: Result := 'N�mero de Linhas n�o confere com n�mero de linhas do tipo 1,2,3 e 9 enviadas no arquivo';
    ce402: Result := 'Valor Total dos Servi�os n�o confere os valores de servi�os enviados no arquivo';
    ce403: Result := 'Valor Total das Reten��es e Total de outros valores informados no registro 3 n�o confere com total informado';
    ce000: Result := 'Lay-Out do arquivo fora dos padr�es';
    ce500: Result := 'Lay-Out do arquivo fora dos padr�es';
    ce600: Result := 'Lay-Out do arquivo fora dos padr�es';
    ce700: Result := 'Quantidade de RPS superior ao padr�o';
    ce900: Result := 'Tamanho do Registro diferente da especifica��o do layout';
    ce901: Result := 'Arquivo com aus�ncia de um dos Registros: 1, 2 ou 9';
  else
    Result := 'Desconhecido';
  end;
end;

function TACBrNFSeProviderISSBarueri.GetSolucao(
  const ACodigo: TCodigoErro): String;
begin
  case ACodigo of
    ce100: Result := 'Informar Tipo Especificado: 1';
    ce101: Result := 'Informar N�mero Correto do Prestador de Servi�os';
    ce102: Result := 'Informar N�mero v�lido e �nico/exclusivo. Um n�mero outra enviado jamais poder� ser enviado novamente';
    ce200: Result := 'Informar Tipo Especificado: 2';
    ce201: Result := 'Informar Tipo Especificado: RPS / RPS-C';
    ce202: Result := 'Informar o N�mero de S�rie do RPS V�lida';
    ce203: Result := 'Informar o N�mero de S�rie da NF-e V�lida';
    ce204: Result := 'Informar o N�mero do RPS';
    ce205: Result := 'Informar um N�mero de RPS V�lido';
    ce206: Result := 'Informar o RPS apenas uma vez no arquivo, caso envie v�rios arquivos simult�neos enviar o RPS uma vez em apenas 1 dos arquivos.';
    ce207: Result := 'Informar NF-e V�lida.';
    ce208: Result := 'A data informada dever� estar no formato AAAAMMDD, ou seja, 4 d�gitos para ano seguido de 2 d�gitos para o m�s seguido de 2 d�gitos para o dia.';
    ce209: Result := 'Informar uma Data V�lida';
    ce210: Result := 'Informar uma Data V�lida';
    ce211: Result := 'A hora informada dever� estar no formato HHMMSS, ou seja, 2 d�gitos para hora em seguida 2 d�gitos para os minutos e e 2 d�gitos para os segundos.';
    ce212: Result := 'Informar a Situa��o Especificada: E para RPS Enviado / C para RPS Cancelado';
    ce213: Result := 'Informar o C�digo Especificado: 01 para Extravio / 02 para Dados Incorretos / 03 para Substitui��o';
    ce214: Result := 'Informar a Descri��o do Cancelamento';
    ce215: Result := 'Cancelar a guia correspondente a nota fiscal';
    ce216: Result := 'Informar C�digo de Atividade V�lido';
    ce217: Result := 'Informar o Local Especificado:1 para servi�o prestado no Munic�pio / 2 para servi�o prestado fora do Munic�pio / 3 para servi�o prestado fora do Pa�s';
    ce218: Result := 'Informe 1 para servi�o prestado em vias p�blicas / 2 para servi�o n�o prestado em vias p�blicas.';
    ce219: Result := 'Informar Endere�o';
    ce220: Result := 'Informar N�mero';
    ce221: Result := 'Informar Bairro';
    ce222: Result := 'Informar Cidade';
    ce223: Result := 'Informar UF Tomador';
    ce224: Result := 'Informar UF Tomador V�lida';
    ce225: Result := 'Informar CEP';
    ce226: Result := 'Informar um Valor V�lido.';
    ce227: Result := 'Informar um Valor V�lido';
    ce228: Result := 'Reservado';
    ce229: Result := 'Reservado';
    ce230: Result := 'Informar um Valor V�lido.';
    ce231: Result := 'Informar um Valor V�lido.';
    ce232: Result := 'Informar Somat�ria dos Valores de Reten��es informadas no registro 3 referente a este RPS';
    ce233: Result := 'Informe 1 Para Tomador Estrangeiro 2 para Tomador Brasileiro';
    ce234: Result := 'Informe um c�digo de pais v�lido';
    ce235: Result := 'Informe 1 Para Servi�o exportado 2 para Servi�o n�o exportado.';
    ce236: Result := 'Informar Indicador do CPF/CNPJ Especificado:1 para CPF / 2 para CNPJ';
    ce237: Result := 'Informar o CPNJ do Tomador V�lido';
    ce238: Result := 'Informar Raz�o Social';
    ce239: Result := 'Informar Endere�o';
    ce240: Result := 'Informar N�mero';
    ce241: Result := 'Informar Bairro';
    ce242: Result := 'Informar Cidade';
    ce243: Result := 'Informar UF Tomador';
    ce244: Result := 'Informar UF Tomador V�lida';
    ce245: Result := 'Informar CEP';
    ce246: Result := 'Informar e-mail V�lido';
    ce247: Result := 'Informar um conteudo v�lido.';
    ce248: Result := 'Informar um Valor V�lido';
    ce249: Result := 'Informar Forma de Pagamento';
    ce250: Result := 'Informar a Discrimina��o do Servi�o';
    ce251: Result := 'Informar valores validos';
    ce252: Result := 'A data informada dever� estar no formato AAAAMMDD, ou seja, 4 d�gitos para ano seguido de 2 d�gitos para o m�s seguido de 2 d�gitos para o dia.';
    ce253: Result := 'Informar NF-e valida para cancelamento/substitui��o';
    ce254: Result := 'Informar NF-e valida para cancelamento/substitui��o';
    ce255: Result := 'O valor da nota fiscal � calculado: (quantidade do servi�o x pre�o unit�rio) + valor "VN" informado no registro 3. Esse resultado pode ser zero desde que o valor do servi�o ou VN seja diferente de zero.';
    ce256: Result := 'Artigo 3�. Os contribuintes com restri��es cadastrais est�o impedidos de utilizar os sistemas ora institu�dos. ' +
                     '-Contribuinte com situa��o diferente de ativo n�o poder� converter RPS emitidos ap�s a data da altera��o da situa��o. D�vidas entrar em contato com o Depto. T�cnico de Tributos Mobili�rios no Tel. 4199-8050.';
    ce257: Result := 'Informar a Nota Fiscal apenas uma vez no arquivo, caso envie v�rios arquivos simult�neos enviar a Nota uma vez em apenas 1 dos arquivos.';
    ce258: Result := 'Para prosseguir � necess�rio retificar o movimento atrav�s do menu "Retificar Servi�os Prestados"';
    ce259: Result := 'Para prosseguir � necess�rio retificar o movimento atrav�s do menu "Retificar Servi�os Prestados"';
    ce260: Result := 'Informar um C�digo de Atividade vinculado ao Perfil do Contribuinte ou um C�digo de Atividade tributada.';
    ce261: Result := 'Informar um C�digo de Atividade vinculado ao Perfil do Contribuinte (Atingido o limite permitido de notas para atividade n�o vinculadas ao cadastro do contribuinte).';
    ce300: Result := 'Informar Tipo Especificado: 3';
    ce301: Result := 'Informar o C�digo Especificado: 01 - para IRRF 02 - para PIS/PASEP 03 - para COFINS 04 - ' +
                     'para CSLL VN - para Valor n�o Incluso na Base de C�lculo (exceto tributos federais). Esse campo somado ao valor total dos servi�os resulta no Valor total da nota.';
    ce302: Result := 'Caso n�o tenha reten��o n�o informar o registro ou informe um valor maior que zero. Se for "VN" informar um valor diferente de zero ou simplesmente n�o informe esse registro';
    ce303: Result := 'Informar um Valor V�lido.';
    ce304: Result := 'Informar C�digo de Reten��o V�lido';
    ce305: Result := 'N�o informar este tipo de dedu��o para RPS cuja a data base de c�lculo seja superior � 29/12/2017.';
    ce400: Result := 'Informar Tipo Especificado: 9';
    ce401: Result := 'Informe o n�mero de linhas (tipo 1,2,3 e 9)';
    ce402: Result := 'Informar Somat�ria dos Valores Totais de Servi�os Prestados (Soma dos valores dos servi�os multiplicados pelas quantidades de cada servi�o)';
    ce403: Result := 'Informar Somat�ria dos Valores Totais lan�ados no Registro tipo 3.';
    ce000: Result := 'O arquivo enviado n�o � um arquivo de Remessa da NFe de Barueri. Enviar um arquivo com os Registros: 1, 2, 9 e opcionalmente o registro tipo 3';
    ce500: Result := 'Os registros v�lidos esperados no arquivo s�o tipo: 1,2,3 e 9';
    ce600: Result := 'Deve haver apenas 1 registro tipo 9 e esse deve ser o �ltimo registro do arquivo';
    ce700: Result := 'Enviar um arquivo com no m�ximo 1000 RPS';
    ce900: Result := 'Reveja as posi��es/tamanho para cada registro, certifique-se que o tamanho dos registros conferem com o layout e cont�m o caracter de fim de linha conforme especificado no layout';
    ce901: Result := 'Reveja os registros do arquivo, certifique-se que todos registros mencionados est�o presentes em seu arquivo. ' +
                     'Tamb�m certifique-se que todos os registros do arquivo cont�m o caracter de fim de linha conforme especificado no layout';
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
    (ALinha[1] = '9'));
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
  XML, NumeroRps: String;
  Emitente: TEmitenteConfNFSe;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  NumeroRps := TACBrNFSeX(FAOwner).NotasFiscais.Items[0].NFSe.IdentificacaoRps.Numero;

  if (EstaVazio(NumeroRps)) then
    NumeroRps := FormatDateTime('yyyymmddzzz', Now);

  XML := '<NFeLoteEnviarArquivo xmlns="http://www.barueri.sp.gov.br/nfe">';
  XML := XML + '<InscricaoMunicipal>' + Emitente.InscMun + '</InscricaoMunicipal>';
  XML := XML + '<CPFCNPJContrib>' + Emitente.CNPJ + '</CPFCNPJContrib>';
  XML := XML + '<NomeArquivoRPS>' + Format('Rps-0%s.txt', [NumeroRps]) + '</NomeArquivoRPS>';
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

  Nota.XmlRps := AplicarXMLtoUTF8(Nota.XmlRps);
  Nota.XmlRps := AplicarLineBreak(Nota.XmlRps, '');

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
  XML: string;
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
          // A partir do caractere 1971, � a listagem de codigo de erros
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

      NumRps := Trim(Copy(Dados[0], Pos('PMB002', Dados[0]), Length(Dados[0])));
      NumRps := StringReplace(NumRps, 'PMB002', '', [rfReplaceAll]);
      Response.NumeroRps := NumRps;

      //Retorno do Txt de um RPS Processado com sucesso...
      if ((Response.Sucesso) and (Length(Dados[0]) > 26)) then
      begin
        //1XXXXXXX0000000000000000PMB00200000000004
        //2     00000120220318211525723K.1473.0553.5240699-I...
        //Onde 723K.1473.0553.5240699-I � o Codigo de verificacao para fazer download do XML
        Response.Situacao := '1';
        Response.DescSituacao := 'Arquivo Importado';
        Response.Protocolo := Trim(Copy(Dados[1], 27, 24));
        Response.NumeroNota := Trim(Copy(Dados[1], 7, 6));
        Response.SerieRps := Trim(Copy(Dados[1], 51, 4));
        Response.SerieNota := Trim(Copy(Dados[1], 2, 5));

        if NaoEstaVazio(Trim(Copy(Dados[1], 22, 6))) then
        begin
          Response.Data := StringToDateTime(Trim(Copy(Dados[1], 13, 8)), 'YYYYMMDD');
          Response.Data := Response.Data + StrToTime(Format('%S:%S:%S', [Trim(Copy(Dados[1], 21, 2)), Trim(Copy(Dados[1], 23, 2)), Trim(Copy(Dados[1], 25, 2))]));
        end
        else
          Response.Data := StringToDateTime(Trim(Copy(Dados[1], 13, 8)), 'YYYYMMDD');

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
    As tag que contem o c�digo, mensagem e corre��o do erro s�o diferentes do padr�o
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
        <Mensagem>Certificado digital inv�lido ou n�o informado</Mensagem>
        <Correcao>Informe um certificado v�lido padr�o ICP-Brasil</Correcao>
    </ListaMensagemRetorno>
  }
end;

function TACBrNFSeProviderISSBarueri.AplicarXMLtoUTF8(const AXMLRps: String): String;
begin
  Result := string(NativeStringToUTF8(AXMLRps));
end;

function TACBrNFSeProviderISSBarueri.AplicarLineBreak(const AXMLRps: String;
  const ABreak: String): String;
begin
  Result := AXMLRps;
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

