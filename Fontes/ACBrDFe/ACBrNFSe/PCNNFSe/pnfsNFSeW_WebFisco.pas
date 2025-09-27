{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Fernando Castelano Banhos                       }
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

unit pnfsNFSeW_WebFisco;

interface

uses
{$IFDEF FPC}
  LResources, 
  Controls, 
{$ELSE}

{$ENDIF}
  SysUtils, 
  Classes,
  ACBrConsts,
  pnfsNFSeW, 
  pcnAuxiliar,
  ACBrDFe.Conversao,
  pcnConversao, 
  pcnGerador, 
  pnfsNFSe, 
  pnfsConversao;

type
  { TNFSeW_WebFisco }

  TNFSeW_WebFisco = class(TNFSeWClass)
  private
  protected
    procedure GerarNotas;
  public
    constructor Create(ANFSeW: TNFSeW); override;

    function ObterNomeArquivo: String; override;
    function GerarXml: Boolean; override;
  end;

implementation

uses
  ACBrUtil.Strings;

{==============================================================================}
{ Essa unit tem por finalidade exclusiva de gerar o XML do RPS segundo o       }
{ layout do provedor WebFisco.                                          }
{ Sendo assim s� ser� criado uma nova unit para um novo layout.                }
{==============================================================================}

{ TNFSeW_WebFisco }

constructor TNFSeW_WebFisco.Create(ANFSeW: TNFSeW);
begin
  inherited Create(ANFSeW);

end;

procedure TNFSeW_WebFisco.GerarNotas;
Var
  cSimples: Boolean;
  xAtrib: string;
begin
  Gerador.Opcoes.TagVaziaNoFormatoResumido := False;

  cSimples := (NFSe.OptanteSimplesNacional = snSim);
  xAtrib := 'xsi:type="xsd:string"';
  //............................................................................

  Gerador.wGrupo('EnvNfe');

  // as 2 tags abaixo s� devem ser geradas em ambinte de produ��o
  if Ambiente = taProducao then
  begin
    Gerador.wCampo(tcInt, '', 'usuario', 1,  6, 1, NFSe.Prestador.Usuario, '', True, xAtrib);
    Gerador.wCampo(tcInt, '', 'pass'   , 1,  6, 1, NFSe.Prestador.Senha, '', True, xAtrib);
    Gerador.wCampo(tcStr, '', 'prf'    , 1, 18, 1, NFSe.Prestador.CNPJ_Prefeitura, '', True, xAtrib);
    Gerador.wCampo(tcStr, '', 'usr'    , 1, 18, 1, NFSe.Prestador.Cnpj, '', True, xAtrib);
  end
  else
  begin
    {
      TESTE PARA PRESTADOR DO SIMPLES NACIONAL
      No campo usuario, usar 142826 para a fase de Homologa��o.
      No campo pass, usar 123456 para a fase de Homologa��o.
      No campo prf, usar 00.000.000/0000-00 para a fase de Homologa��o.
      No campo usr, usar 44.232.272/0001-92 para a fase de Homologa��o.

      TESTE PARA PRESTADOR N�O OPTANTE DO SIMPLES NACIONAL
      No campo usuario, usar 901567 para a fase de Homologa��o.
      No campo pass, usar 123456 para a fase de Homologa��o.
      No campo prf, usar 00.000.000/0000-00 para a fase de Homologa��o.
      No campo usr, usar 57.657.017/0001-33 para a fase de Homologa��o.
    }
    if cSimples then
    begin
      Gerador.wCampo(tcInt, '', 'usuario', 1,  6, 1, '142826', '', True, xAtrib);
      Gerador.wCampo(tcInt, '', 'pass'   , 1,  6, 1, '123456', '', True, xAtrib);
      Gerador.wCampo(tcStr, '', 'prf'    , 1, 18, 1, '00.000.000/0000-00', '', True, xAtrib);
      Gerador.wCampo(tcStr, '', 'usr'    , 1, 18, 1, '44.232.272/0001-92', '', True, xAtrib);
    end
    else
    begin
      Gerador.wCampo(tcInt, '', 'usuario', 1,  6, 1, '901567', '', True, xAtrib);
      Gerador.wCampo(tcInt, '', 'pass'   , 1,  6, 1, '123456', '', True, xAtrib);
      Gerador.wCampo(tcStr, '', 'prf'    , 1, 18, 1, '00.000.000/0000-00', '', True, xAtrib);
      Gerador.wCampo(tcStr, '', 'usr'    , 1, 18, 1, '57.657.017/0001-33', '', True, xAtrib);
    end;
  end;

  Gerador.wCampo(tcStr, '', 'ctr'    , 1,  8, 1, NFSe.IdentificacaoRps.Numero, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'cnpj'   , 1, 18, 1, NFSe.Tomador.IdentificacaoTomador.CpfCnpj, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'cnpjn'  , 1, 60, 1, NFSe.Tomador.RazaoSocial, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'ie'     , 1, 20, 1, NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'im'     , 1, 15, 1, NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'lgr'    , 1, 60, 1, NFSe.Tomador.Endereco.Endereco, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'num'    , 1,  6, 1, NFSe.Tomador.Endereco.Numero, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'cpl'    , 1, 20, 1, NFSe.Tomador.Endereco.Complemento, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'bai'    , 1, 40, 1, NFSe.Tomador.Endereco.Bairro, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'cid'    , 1, 40, 1, NFSe.Tomador.Endereco.xMunicipio, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'est'    , 1,  2, 1, NFSe.Tomador.Endereco.UF, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'cep'    , 1,  8, 1, NFSe.Tomador.Endereco.CEP, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'fon'    , 1, 12, 1, NFSe.Tomador.Contato.Telefone, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'mail'   , 1, 50, 1, NFSe.Tomador.Contato.Email, '', True, xAtrib);

  Gerador.wCampo(tcDatVcto, '', 'dat', 1, 10, 1, NFSe.DataEmissao, '', True, xAtrib);

  Gerador.wCampo(tcStr, '', 'f1n', 1 ,15, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'f1d', 1, 10, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'f1v', 1, 12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'f2n', 1, 15, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'f2d', 1, 10, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'f2v', 1, 12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'f3n', 1, 15, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'f3d', 1, 10, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'f3v', 1, 12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'f4n', 1 ,15, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'f4d', 1, 10, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'f4v', 1, 12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'f5n', 1 ,15, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'f5d', 1, 10, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'f5v', 1, 12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'f6n', 1 ,15, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'f6d', 1, 10, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'f6v', 1, 12, 1, 0.00, '', True, xAtrib);

  Gerador.wCampo(tcStr, '', 'item1', 1,  5, 1, NFSe.Servico.ItemListaServico, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'item2', 1,  5, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'item3', 1,  5, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'aliq1', 1,  5, 1, NFSe.Servico.Valores.Aliquota, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'aliq2', 1,  5, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'aliq3', 1,  5, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'val1' , 1, 12, 1, NFSe.Servico.ItemServico.Items[0].ValorUnitario, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'val2' , 1, 12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'val3' , 1, 12, 1, 0.00, '', True, xAtrib);

  //C�digo da localidade de execu��o do servi�o, se no local do estabelecimento do prestador, deixar como 0000...
  if (NFSe.PrestadorServico.Endereco.CodigoMunicipio <> IntToStr(NFSe.Servico.MunicipioIncidencia)) then
    Gerador.wCampo(tcStr, '', 'loc', 1, 4, 1, NFSe.Servico.CodigoMunicipio, '')
  else
    Gerador.wCampo(tcStr, '', 'loc', 1, 4, 1, '0000', '', True, xAtrib);

  if NFSe.Servico.Valores.IssRetido = stRetencao then
    Gerador.wCampo(tcStr, '', 'ret', 1, 3, 1, 'SIM', '')
  else
    Gerador.wCampo(tcStr, '', 'ret', 1, 3, 1, 'NAO', '', True, xAtrib);

  Gerador.wCampo(tcStr, '', 'txt'    , 1, 720, 1, NFSe.Servico.ItemServico[0].Descricao, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'val'    , 1,  12, 1, NFSe.Servico.Valores.ValorServicos, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'valtrib', 1,  12, 1, NFSe.Servico.Valores.ValorServicos, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'iss'    , 1,  12, 1, NFSe.Servico.Valores.ValorIss, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'issret' , 1,  12, 1, NFSe.Servico.Valores.ValorIssRetido, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'desci'  , 1,  12, 1, NFSe.Servico.Valores.DescontoIncondicionado, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'desco'  , 1,  12, 1, NFSe.Servico.Valores.DescontoCondicionado, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'binss'  , 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'birrf'  , 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'bcsll'  , 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'bpis'   , 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'bcofins', 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'ainss'  , 1,   6, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'airrf'  , 1,   6, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'acsll'  , 1,   6, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'apis'   , 1,   6, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'acofins', 1,   6, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'inss'   , 1,  12, 1, NFSe.Servico.Valores.ValorInss, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'irrf'   , 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'csll'   , 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'pis'    , 1,  12, 1, NFSe.Servico.Valores.ValorPis, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'cofins' , 1,  12, 1, NFSe.Servico.Valores.ValorCofins, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'item4'  , 1,   5, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'item5'  , 1,   5, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'item6'  , 1,   5, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'item7'  , 1,   5, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'item8'  , 1,   5, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'aliq4'  , 1,   5, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'aliq5'  , 1,   5, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'aliq6'  , 1,   5, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'aliq7'  , 1,   5, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'aliq8'  , 1,   5, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'val4'   , 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'val5'   , 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'val6'   , 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'val7'   , 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'val8'   , 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'iteser1', 1,   5, 1, NFSe.Servico.ItemListaServico, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'iteser2', 1,   5, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'iteser3', 1,   5, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'iteser4', 1,   5, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'iteser5', 1,   5, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'iteser6', 1,   5, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'iteser7', 1,   5, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'iteser8', 1,   5, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'alqser1', 1,   5, 1, NFSe.Servico.Valores.Aliquota, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'alqser2', 1,   5, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'alqser3', 1,   5, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'alqser4', 1,   5, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'alqser5', 1,   5, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'alqser6', 1,   5, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'alqser7', 1,   5, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'alqser8', 1,   5, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'valser1', 1,  12, 1, NFSe.Servico.Valores.ValorServicos, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'valser2', 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'valser3', 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'valser4', 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'valser5', 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'valser6', 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'valser7', 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcDe2, '', 'valser8', 1,  12, 1, 0.00, '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'paisest', 1,  60, 1, '', '', True, xAtrib);

  Gerador.wCampo(tcDe2, '', 'sssrecbr', 1, 12, 1, IIf(cSimples = True, NFSe.Prestador.ValorReceitaBruta, 0.00), '', True, xAtrib);

  Gerador.wCampo(tcStr, '', 'ssanexo', 1, 15, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'ssdtini', 1, 10, 1, IIf(cSimples = True, FormatDateTime('DD/MM/YYYY', NFSe.Prestador.DataInicioAtividade), ' '), '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'percded', 1,  6, 1, '', '', True, xAtrib);

  Gerador.wCampo(tcStr, '', 'itemsac1', 1,  60, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'itemsaq1', 1,  60, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'itemsav1', 1,  60, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'itemsac2', 1,  60, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'itemsaq2', 1,  60, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'itemsav2', 1,  60, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'itemsac3', 1,  60, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'itemsaq3', 1,  60, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'itemsav3', 1,  60, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'itemsac4', 1,  60, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'itemsaq4', 1,  60, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'itemsav4', 1,  60, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'itemsac5', 1,  60, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'itemsaq5', 1,  60, 1, '', '', True, xAtrib);
  Gerador.wCampo(tcStr, '', 'itemsav5', 1,  60, 1, '', '', True, xAtrib);

  Gerador.wGrupo('/EnvNfe');
end;

function TNFSeW_WebFisco.GerarXml: Boolean;
begin
  Gerador.ListaDeAlertas.Clear;

  Gerador.ArquivoFormatoXML := '';
  Gerador.Prefixo           := FPrefixo4;

  Gerador.Opcoes.QuebraLinha := FQuebradeLinha;

  FDefTipos := FServicoEnviar;

  GerarNotas;

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

function TNFSeW_WebFisco.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

end.
