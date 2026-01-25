{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit WebFisco.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXGravarXml,
  ACBrNFSeXConversao;

type
  { TNFSeW_WebFisco }

  TNFSeW_WebFisco = class(TNFSeWClass)
  protected

  public
    function GerarXml: Boolean; override;

  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrValidador;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     WebFisco
//==============================================================================

{ TNFSeW_WebFisco }

function TNFSeW_WebFisco.GerarXml: Boolean;
var
  NFSeNode: TACBrXmlNode;
  cSimples: Boolean;
  xAtrib, strAux, locEstab, nifInf, paisTomador: string;
  i: Integer;
  valAux: Double;
  LAuxVencimento: TDateTime;

  function TemParcela(const AIndice: Integer): Boolean;
  begin
    Result := AIndice < NFSe.CondicaoPagamento.Parcelas.Count;
  end;
begin
  Configuracao;

  ListaDeAlertas.Clear;

  cSimples := (NFSe.OptanteSimplesNacional = snSim);
  xAtrib   := 'xsi:type="xsd:string"';

  // Pre-calculo localestab/nifinf (Manual WebFisco 2026 - Paginas 5 a 7)
  paisTomador := UpperCase(Trim(NFSe.Tomador.Endereco.xPais));
  if paisTomador = '' then
    locEstab := 'NAOINFORMADO'
  else if (paisTomador = 'BR') or (paisTomador = 'BRASIL') or (paisTomador = 'BRAZIL') then
    locEstab := 'BR'
  else
    locEstab := 'EXTERIOR';

  nifInf := '';
  if locEstab = 'EXTERIOR' then
  begin
    if Trim(NFSe.Tomador.IdentificacaoTomador.Nif) <> '' then
      nifInf := '1'
    else
      nifInf := '0';
  end;

  FDocument.Clear();

  NFSeNode := CreateElement('EnvNfe');

  FDocument.Root := NFSeNode;

  // Manual WebFisco 2026 - Pagina 5: Regras de Homologacao e Producao
  if Ambiente = taProducao then
  begin
    // Producao: enviar usuario e pass (obrigatorio)
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'usuario', 1, 6, 1,
                                                    Usuario, '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'pass', 1, 6, 1,
                                                      Senha, '', True, xAtrib));

    // Producao: usar CNPJ real da prefeitura e do prestador
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'prf', 1, 18, 1,
                               FormatarCNPJ(CNPJPrefeitura), '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'usr', 1, 18, 1,
      FormatarCNPJouCPF(NFSe.Prestador.IdentificacaoPrestador.CpfCnpj), '', True, xAtrib));
  end
  else
  begin
    // Homologacao: NAO enviar tags usuario e pass (Manual pagina 5)
    // Homologacao: usar prf = 00.000.000/0000-00 (Manual pagina 5)
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'prf', 1, 18, 1,
                                       '00.000.000/0000-00', '', True, xAtrib));

    // Homologacao: usar CNPJ informado em cada modelo de xml (Manual pagina 5)
    // O manual nao especifica valores fixos, entao usamos o CNPJ do prestador configurado
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'usr', 1, 18, 1,
      FormatarCNPJouCPF(NFSe.Prestador.IdentificacaoPrestador.CpfCnpj), '', True, xAtrib));
  end;

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'ctr', 1, 8, 1,
                               NFSe.IdentificacaoRps.Numero, '', True, xAtrib));

  if locEstab = 'BR' then
    strAux := FormatarCNPJouCPF(NFSe.Tomador.IdentificacaoTomador.CpfCnpj)
  else if (locEstab = 'EXTERIOR') and (nifInf = '1') then
    strAux := Trim(NFSe.Tomador.IdentificacaoTomador.Nif)
  else
    strAux := '';

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'cnpjcpfnif', 9, 18, 1,
                                                     strAux, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'cnpjcpfnifnome', 1, 60, 1,
                                   NFSe.Tomador.RazaoSocial, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'ie', 1, 20, 1,
        NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'im', 1, 15, 1,
       NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'lgr', 1, 60, 1,
                             NFSe.Tomador.Endereco.Endereco, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'num', 1, 6, 1,
                               NFSe.Tomador.Endereco.Numero, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'cpl', 1, 20, 1,
                          NFSe.Tomador.Endereco.Complemento, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'bai', 1, 40, 1,
                               NFSe.Tomador.Endereco.Bairro, '', True, xAtrib));

  if locEstab = 'BR' then
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'cid', 1, 4, 1,
                           NFSe.Tomador.Endereco.xMunicipio, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'cid', 1, 4, 1,
                                                         '', '', True, xAtrib));
  if locEstab = 'BR' then
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'est', 1, 2, 1,
                                   NFSe.Tomador.Endereco.UF, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'est', 1, 2, 1,
                                                         '', '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'cep', 1, 8, 1,
                                  NFSe.Tomador.Endereco.CEP, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'fon', 1, 12, 1,
                              NFSe.Tomador.Contato.Telefone, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'mail', 1, 50, 1,
                                 NFSe.Tomador.Contato.Email, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcDatVcto, '#', 'dataemissao', 1, 10, 1,
                                           NFSe.DataEmissao, '', True, xAtrib));


  // Manual WebFisco 2026 - Paginas 5 a 7: localestab / nifinf / nifmotivo / pais / epr
  NFSeNode.AppendChild(AddNode(tcStr, '#', 'localestab', 2, 12, 1,
                                                   locEstab, '', True, xAtrib));

  // nifinf: somente se localestab = EXTERIOR (0/1)
  if locEstab = 'EXTERIOR' then
  begin
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'nifinf', 1, 1, 1,
                                                     nifInf, '', True, xAtrib));

    // nifmotivo: somente se nifinf = 0 (0/1/2)
    if nifInf = '0' then
      NFSeNode.AppendChild(AddNode(tcStr, '#', 'nifmotivo', 1, 1, 1,
        NaoNIFToStr(NFSe.Tomador.IdentificacaoTomador.cNaoNIF), '', True, xAtrib))
    else
      NFSeNode.AppendChild(AddNode(tcStr, '#', 'nifmotivo', 1, 1, 1,
                                                         '', '', True, xAtrib));
  end
  else
  begin
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'nifinf', 1, 1, 1,
                                                         '', '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'nifmotivo', 1, 1, 1,
                                                         '', '', True, xAtrib));
  end;

  // pais: ISO2 - somente se localestab = EXTERIOR (pag. 6)
  if (locEstab = 'EXTERIOR') then
  begin
    if Length(paisTomador) = 2 then
      strAux := paisTomador
    else
      strAux := '';

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'pais', 1, 2, 1,
                                                     strAux, '', True, xAtrib));
  end
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'pais', 1, 2, 1,
                                                         '', '', True, xAtrib));

  // epr: Estado/Provincia/Regiao - somente se localestab = EXTERIOR (pag. 7)
  if (locEstab = 'EXTERIOR') then
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'epr', 1, 60, 1,
                                    NFSe.Tomador.Endereco.UF, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'epr', 1, 60, 1,
                                                         '', '', True, xAtrib));

  for i := 1 to 6 do
  begin
    strAux := '';
    if TemParcela(i-1) then
      strAux := NFSe.CondicaoPagamento.Parcelas[i-1].Parcela;

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'f' + IntToStr(i) + 'n', 1, 15, 1,
                                                     strAux, '', True, xAtrib));

    LAuxVencimento := 0;
    if TemParcela(i-1) then
      LAuxVencimento := NFSe.CondicaoPagamento.Parcelas[i-1].DataVencimento;

    if LAuxVencimento > 0 then
      NFSeNode.AppendChild(AddNode(tcDatVcto, '#', 'f' + IntToStr(i) + 'd', 1, 10, 1,
                                              LAuxVencimento, '', True, xAtrib))
    else
      NFSeNode.AppendChild(AddNode(tcStr, '#', 'f' + IntToStr(i) + 'd', 1, 10, 1,
                                                         '', '', True, xAtrib));

    valAux := 0;
    if TemParcela(i-1) then
      valAux := NFSe.CondicaoPagamento.Parcelas[i-1].Valor;

    if valAux > 0 then
      NFSeNode.AppendChild(AddNode(tcDe2, '#', 'f' + IntToStr(i) + 'v', 1, 12, 1,
                  NFSe.CondicaoPagamento.Parcelas[i-1].Valor, '', True, xAtrib))
    else
      NFSeNode.AppendChild(AddNode(tcStr, '#', 'f' + IntToStr(i) + 'v', 1, 12, 1,
                                                         '', '', True, xAtrib));
  end;

  for i := 0 to 2 do
  begin
    if i <= NFSe.Servico.ItemServico.Count -1 then
      NFSeNode.AppendChild(AddNode(tcStr, '#', 'item' + IntToStr(i+1), 1, 5, 1,
          NFSe.Servico.ItemServico.Items[i].ItemListaServico, '', True, xAtrib))
    else
      NFSeNode.AppendChild(AddNode(tcStr, '#', 'item' + IntToStr(i+1), 1, 5, 1,
                                                         '', '', True, xAtrib));
  end;

  for i := 0 to 2 do
  begin
    if i <= NFSe.Servico.ItemServico.Count -1 then
      NFSeNode.AppendChild(AddNode(tcDe2, '#', 'aliq' + IntToStr(i+1), 1, 5, 1,
                  NFSe.Servico.ItemServico.Items[i].Aliquota, '', True, xAtrib))
    else
      NFSeNode.AppendChild(AddNode(tcDe2, '#', 'aliq' + IntToStr(i+1), 1, 5, 1,
                                                          0, '', True, xAtrib));
  end;

  for i := 0 to 2 do
  begin
    if i <= NFSe.Servico.ItemServico.Count -1 then
      NFSeNode.AppendChild(AddNode(tcDe2, '#', 'val' + IntToStr(i+1), 1, 12, 1,
             NFSe.Servico.ItemServico.Items[i].ValorUnitario, '', True, xAtrib))
    else
      NFSeNode.AppendChild(AddNode(tcDe2, '#', 'val' + IntToStr(i+1), 1, 12, 1,
                                                          0, '', True, xAtrib));
  end;

  // Codigo da localidade de execucao do servico, se no local do estabelecimento
  // do prestador, deixar como 0000...
  NFSeNode.AppendChild(AddNode(tcStr, '#', 'codnbs', 1, 9, 1,
                                     NFSe.Servico.CodigoNBS, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'clatribscbs', 1, 6, 1,
                                    NFSe.Servico.cClassTrib, '', True, xAtrib));

  // CST PIS/COFINS e Tipo de retencao (manual)
  strAux := Trim(ACBrNFSeXConversao.CSTPisToStr(NFSe.Servico.Valores.CSTPis));
  if strAux = '' then
    strAux := '00';

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'sittribpiscofins', 2, 2, 1,
                                                     strAux, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'tipretpiscofins', 1, 1, 1,
    ACBrNFSeXConversao.tpRetPisCofinsToStr(NFSe.Servico.Valores.tpRetPisCofins), '', True, xAtrib));

  if (NFSe.Prestador.Endereco.CodigoMunicipio <> IntToStr(NFSe.Servico.MunicipioIncidencia)) then
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'loc', 1, 4, 1,
                                NFSe.Servico.CodigoMunicipio, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'loc', 1, 4, 1,
                                                     '0000', '', True, xAtrib));

  if NFSe.Servico.Valores.IssRetido = stRetencao then
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'impret', 1, 3, 1,
                                                       'SIM', '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'impret', 1, 3, 1,
                                                      'NAO', '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'txt', 1, 720, 1,
                      NFSe.Servico.ItemServico[0].Descricao, '', True, xAtrib));

  // Percentuais aproximados de tributos (manual: obrigatorio apenas para NAO optantes do Simples)
  if not cSimples then
  begin
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'impfederal', 1, 4, 1,
                                                          0, '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'impestadual', 1, 4, 1,
                                                          0, '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'impmunicipal', 1, 4, 1,
                                                          0, '', True, xAtrib));
  end
  else
  begin
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'impfederal', 1, 4, 1,
                                                         '', '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'impestadual', 1, 4, 1,
                                                         '', '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'impmunicipal', 1, 4, 1,
                                                         '', '', True, xAtrib));
  end;


  NFSeNode.AppendChild(AddNode(tcDe2, '#', 'val', 1, 12, 1,
                         NFSe.Servico.Valores.ValorServicos, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcDe2, '#', 'valtrib', 1, 12, 1,
                         NFSe.Servico.Valores.ValorServicos, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcDe2, '#', 'iss', 1, 12, 1,
                              NFSe.Servico.Valores.ValorIss, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcDe2, '#', 'issret', 1, 12, 1,
                        NFSe.Servico.Valores.ValorIssRetido, '', True, xAtrib));

  // Manual WebFisco 2026 - Pagina 9: Valor do ISSQN NAO Retido (obrigatorio)
  NFSeNode.AppendChild(AddNode(tcDe2, '#', 'issrec', 1, 12, 1,
    NFSe.Servico.Valores.ValorIss - NFSe.Servico.Valores.ValorIssRetido, '', True, xAtrib));

  // Manual WebFisco 2026 - Pagina 9: Valor Liquido da Nota a Pagar (obrigatorio)
  valAux := NFSe.Servico.Valores.ValorServicos -
            NFSe.Servico.Valores.DescontoIncondicionado -
            NFSe.Servico.Valores.DescontoCondicionado -
            NFSe.Servico.Valores.OutrosDescontos -
            NFSe.Servico.Valores.ValorIssRetido;

  NFSeNode.AppendChild(AddNode(tcDe2, '#', 'liqpag', 1, 12, 1,
                                                     valAux, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcDe2, '#', 'desci', 1, 12, 1,
                NFSe.Servico.Valores.DescontoIncondicionado, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcDe2, '#', 'desco', 1, 12, 1,
                  NFSe.Servico.Valores.DescontoCondicionado, '', True, xAtrib));

  // IRRF / CSLL / INSS (Manual WebFisco 2026 - Pagina 8)
  // Bases (se nao informado, enviar vazio)
  valAux := NFSe.Servico.Valores.tribFed.vBCPCP;

  if valAux > 0 then
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'binss', 1, 12, 1,
                                                      valAux, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'binss', 1, 12, 1,
                                                         '', '', True, xAtrib));

  valAux := NFSe.Servico.Valores.tribFed.vBCPIRRF;
  if valAux > 0 then
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'birrf', 1, 12, 1,
                                                      valAux, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'birrf', 1, 12, 1,
                                                         '', '', True, xAtrib));

  valAux := NFSe.Servico.Valores.tribFed.vBCCSLL;
  if valAux > 0 then
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'bcsll', 1, 12, 1,
                                                      valAux, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'bcsll', 1, 12, 1,
                                                         '', '', True, xAtrib));

  // Aliquotas e valores
  if NFSe.Servico.Valores.AliquotaIr > 0 then
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'airrf', 1, 6, 1,
                             NFSe.Servico.Valores.AliquotaIr, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'airrf', 1, 6, 1,
                                                         '', '', True, xAtrib));

  if NFSe.Servico.Valores.ValorIr > 0 then
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'irrf', 1, 12, 1,
                                NFSe.Servico.Valores.ValorIr, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'irrf', 1, 12, 1,
                                                         '', '', True, xAtrib));

  if NFSe.Servico.Valores.AliquotaCsll > 0 then
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'acsll', 1, 6, 1,
                           NFSe.Servico.Valores.AliquotaCsll, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'acsll', 1, 6, 1,
                                                         '', '', True, xAtrib));

  if NFSe.Servico.Valores.ValorCsll > 0 then
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'csll', 1, 12, 1,
                              NFSe.Servico.Valores.ValorCsll, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'csll', 1, 12, 1,
                                                         '', '', True, xAtrib));

  if NFSe.Servico.Valores.AliquotaInss > 0 then
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'ainss', 1, 6, 1,
                           NFSe.Servico.Valores.AliquotaInss, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'ainss', 1, 6, 1,
                                                         '', '', True, xAtrib));

  if NFSe.Servico.Valores.ValorInss > 0 then
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'inss', 1, 12, 1,
                              NFSe.Servico.Valores.ValorInss, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'inss', 1, 12, 1,
                                                         '', '', True, xAtrib));
  // Bases/aliquotas/valores PIS/COFINS (manual: nao enviar quando sittribpiscofins = 00)
  if strAux <> '00' then
  begin
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'bpis', 1, 12, 1,
                                                          0, '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'apis', 1, 6, 1,
                           NFSe.Servico.Valores.AliquotaPis, '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'pis', 1, 12, 1,
                              NFSe.Servico.Valores.ValorPis, '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'bcofins', 1, 12, 1,
                                                          0, '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'acofins', 1, 6, 1,
                        NFSe.Servico.Valores.AliquotaCofins, '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'cofins', 1, 12, 1,
                           NFSe.Servico.Valores.ValorCofins, '', True, xAtrib));
  end
  else
  begin
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'bpis', 1, 12, 1,
                                                         '', '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'apis', 1, 6, 1,
                                                         '', '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'pis', 1, 12, 1,
                                                         '', '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'bcofins', 1, 12, 1,
                                                         '', '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'acofins', 1, 6, 1,
                                                         '', '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'cofins', 1, 12, 1,
                                                         '', '', True, xAtrib));
  end;

  for i := 4 to 8 do
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'item' + IntToStr(i), 1, 5, 1,
                                                         '', '', True, xAtrib));

  for i := 4 to 8 do
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'aliq' + IntToStr(i), 1, 5, 1,
                                                          0, '', True, xAtrib));

  for i := 4 to 8 do
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'val' + IntToStr(i), 1, 5, 1,
                                                          0, '', True, xAtrib));

  for i := 1 to 8 do
  begin
    if (i = 1) and cSimples then
      NFSeNode.AppendChild(AddNode(tcStr, '#', 'iteser' + IntToStr(i), 1, 5, 1,
                               NFSe.Servico.ItemListaServico, '', True, xAtrib))
    else
      NFSeNode.AppendChild(AddNode(tcStr, '#', 'iteser' + IntToStr(i), 1, 5, 1,
                                                         '', '', True, xAtrib));
  end;

  for i := 1 to 8 do
  begin
    if (i = 1) and cSimples then
      NFSeNode.AppendChild(AddNode(tcDe2, '#', 'alqser' + IntToStr(i), 1, 5, 1,
                               NFSe.Servico.Valores.Aliquota, '', True, xAtrib))
    else
      NFSeNode.AppendChild(AddNode(tcDe2, '#', 'alqser' + IntToStr(i), 1, 5, 1,
                                                          0, '', True, xAtrib));
  end;

  for i := 1 to 8 do
  begin
    if (i = 1) and cSimples then
      NFSeNode.AppendChild(AddNode(tcDe2, '#', 'valser' + IntToStr(i), 1, 12, 1,
                          NFSe.Servico.Valores.ValorServicos, '', True, xAtrib))
    else
      NFSeNode.AppendChild(AddNode(tcDe2, '#', 'valser' + IntToStr(i), 1, 12, 1,
                                                          0, '', True, xAtrib));
  end;

  strAux := UpperCase(Trim(NFSe.Servico.xPais));
  if Length(strAux) <> 2 then
    strAux := 'BR';

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'paisloc', 1, 2, 1,
                                                     strAux, '', True, xAtrib));

  if cSimples then
    valAux := NFSe.Prestador.ValorReceitaBruta
  else
    valAux := 0.00;

  NFSeNode.AppendChild(AddNode(tcDe2, '#', 'ssrecbr', 1, 12, 1,
                                                     valAux, '', True, xAtrib));

  // Manual WebFisco 2026 - Pagina 9: Optante Simples Nacional (obrigatorio)
  if cSimples then
    strAux := 'SIM'
  else
    strAux := 'NAO';
  NFSeNode.AppendChild(AddNode(tcStr, '#', 'ssusr', 1, 3, 1,
                                                   strAux, '', True, xAtrib));

  if cSimples then
    strAux := NFSe.Prestador.Anexo
  else
    strAux :='';

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'ssanexo', 1, 15, 1,
                                                     strAux, '', True, xAtrib));

  if cSimples then
    strAux := FormatDateTime('DD/MM/YYYY', NFSe.Prestador.DataInicioAtividade)
  else
    strAux :=' ';

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'ssdtini', 1, 10, 1,
                                                     strAux, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'percded', 1, 6, 1,
                                                         '', '', True, xAtrib));

  // Manual WebFisco 2026 - Pagina 9: Percentual de Incentivo fiscal (opcional)
  if NFSe.Servico.Valores.AliquotaDeducoes > 0 then
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'per2', 1, 5, 1,
                       NFSe.Servico.Valores.AliquotaDeducoes, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'per2', 1, 5, 1,
                                                         '', '', True, xAtrib));

  // Manual WebFisco 2026 - Paginas 9 a 15: Campos opcionais/condicionais
  // Para evitar rejeicao por falta de dados, enviamos os campos com opcao = 0 e demais vazios.
  // --- Obras (infobras*) - pag. 9-10
  NFSeNode.AppendChild(AddNode(tcInt, '#', 'infobrasopcao', 1, 1, 1,
               IntToStr(NFSe.ConstrucaoCivil.infobrasopcao), '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infobrascodobra', 1, 30, 1,
                            NFSe.ConstrucaoCivil.CodigoObra, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infobrasim', 1, 30, 1,
                          NFSe.ConstrucaoCivil.inscImobFisc, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'ccib', 1, 8, 1,
          FormatFloat('00000000', NFSe.ConstrucaoCivil.Cib), '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infobrascep', 1, 8, 1,
                          NFSe.ConstrucaoCivil.Endereco.CEP, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infobrasmunicipio', 1, 4, 1,
              NFSe.ConstrucaoCivil.Endereco.CodigoMunicipio, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infobrasufproviciaregiao', 1, 60, 1,
                           NFSe.ConstrucaoCivil.Endereco.UF, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infobraslogradouro', 1, 60, 1,
                     NFSe.ConstrucaoCivil.Endereco.Endereco, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infobrasnumero', 1, 6, 1,
                       NFSe.ConstrucaoCivil.Endereco.Numero, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infobrascomplemento', 1, 20, 1,
                  NFSe.ConstrucaoCivil.Endereco.Complemento, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infobrasbairro', 1, 40, 1,
                       NFSe.ConstrucaoCivil.Endereco.Bairro, '', True, xAtrib));

  // --- Evento (infoatividadeevento*) - pag. 11-12
  NFSeNode.AppendChild(AddNode(tcInt, '#', 'infoatividadeeventoopcao', 1, 1, 1,
     IntToStr(NFSe.Servico.Evento.infoatividadeeventoopcao), '', True, xAtrib));

  if NFSe.Servico.Evento.dtIni > 0 then
    strAux := FormatDateTime('DD/MM/YYYY', NFSe.Servico.Evento.dtIni)
  else
    strAux := '';

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infoatividadeeventodatainicial', 1, 10, 1,
                                                     strAux, '', True, xAtrib));

  if NFSe.Servico.Evento.dtFim > 0 then
    strAux := FormatDateTime('DD/MM/YYYY', NFSe.Servico.Evento.dtFim)
  else
    strAux := '';

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infoatividadeeventodatafinal', 1, 10, 1,
                                                     strAux, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infoatividadeeventodescricao', 1, 255, 1,
                                  NFSe.Servico.Evento.xNome, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infoatividadeeventoidentificacao', 1, 30, 1,
                               NFSe.Servico.Evento.idAtvEvt, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infoatividadeeventocep', 1, 8, 1,
                           NFSe.Servico.Evento.Endereco.CEP, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infoatividadeeventomunicipio', 1, 4, 1,
               NFSe.Servico.Evento.Endereco.CodigoMunicipio, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infoatividadeeventoufregiaoestado', 1, 60, 1,
                            NFSe.Servico.Evento.Endereco.UF, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infoatividadeeventologradouro', 1, 60, 1,
                      NFSe.Servico.Evento.Endereco.Endereco, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infoatividadeeventonumero', 1, 6, 1,
                        NFSe.Servico.Evento.Endereco.Numero, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infoatividadeeventocomplemento', 1, 20, 1,
                   NFSe.Servico.Evento.Endereco.Complemento, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infoatividadeeventobairro', 1, 40, 1,
                        NFSe.Servico.Evento.Endereco.Bairro, '', True, xAtrib));

  // --- Exportacao (infocomext*) - pag. 13
  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infocomextmodoprest', 1, 1, 1,
         IntToStr(Integer(NFSe.Servico.comExt.mdPrestacao)), '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infocomextvinculo', 1, 1, 1,
           IntToStr(Integer(NFSe.Servico.comExt.vincPrest)), '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infocomextmoeda_codigo', 1, 3, 1,
            FormatFloat('000', NFSe.Servico.comExt.tpMoeda), '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcDe2, '#', 'infocomextvlrmoeda', 1, 12, 1,
                             NFSe.Servico.comExt.vServMoeda, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infocomextmecprest', 1, 2, 1,
    FormatFloat('00', Integer(NFSe.Servico.comExt.mecAFComexP)), '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'infocomextmectomador', 1, 2, 1,
    FormatFloat('00', Integer(NFSe.Servico.comExt.mecAFComexT)), '', True, xAtrib));

  // --- Exportacao (vincopemovtempbens/didsidadri/reaverb/compartdpsmdic) - pag. 14-15
  NFSeNode.AppendChild(AddNode(tcStr, '#', 'vincopemovtempbens', 1, 1, 1,
         IntToStr(Integer(NFSe.Servico.comExt.movTempBens)), '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'didsidadri', 1, 12, 1,
                                    NFSe.Servico.comExt.nDI, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'reaverb', 1, 12, 1,
                                    NFSe.Servico.comExt.nRE, '', True, xAtrib));

  NFSeNode.AppendChild(AddNode(tcStr, '#', 'compartdpsmdic', 1, 1, 1,
                         IntToStr(NFSe.Servico.comExt.mdic), '', True, xAtrib));

for i := 1 to 5 do
  begin
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'itemsac' + IntToStr(i), 1, 60, 1,
                                                         '', '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'itemsaq' + IntToStr(i), 1, 60, 1,
                                                         '', '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'itemsav' + IntToStr(i), 1, 60, 1,
                                                         '', '', True, xAtrib));

    // A tag abaixo foi incluida para atender o provedor FGMaiss
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'itemsat' + IntToStr(i), 1, 60, 1,
                                                         '', '', True, xAtrib));
  end;

  // A tag abaixo foi incluida para atender o provedor FGMaiss
  NFSeNode.AppendChild(AddNode(tcStr, '#', 'sslimite', 1, 6, 1,
                                                      'NAO', '', True, xAtrib));

  // A tag abaixo foi incluida para atender o provedor FGMaiss
  if NFSe.Servico.Valores.OutrosDescontos > 0 then
    NFSeNode.AppendChild(AddNode(tcDe2, '#', 'descoutros', 1, 12, 1,
                        NFSe.Servico.Valores.OutrosDescontos, '', True, xAtrib))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'descoutros', 1, 12, 1,
                                                         '', '', True, xAtrib));

  // As tag abaixo foram incluidas para atender o provedor FGMaiss
  for i := 7 to 12 do
  begin
    NFSeNode.AppendChild(AddNode(tcStr, '#', 'f' + IntToStr(i) + 'n', 1, 15, 1,
                                                         '', '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'f' + IntToStr(i) + 'd', 1, 10, 1,
                                                         '', '', True, xAtrib));

    NFSeNode.AppendChild(AddNode(tcStr, '#', 'f' + IntToStr(i) + 'v', 1, 12, 1,
                                                         '', '', True, xAtrib));
  end;

  Result := True;
end;

end.
