{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
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

unit pcnCIOTW_eFrete;

interface

uses
{$IFDEF FPC}
  LResources, 
  Controls, 
{$ELSE}

{$ENDIF}
  SysUtils, 
  Classes, 
  StrUtils,
  synacode, 
  ACBrConsts,
  pcnCIOTW, 
  pcnCIOTR,
  pcnConversao,
  pcnGerador,
  pcnLeitor,
  pcnCIOT,
  ACBrCIOTConversao;

type
  { TCIOTW_eFrete }

  TCIOTW_eFrete = class(TCIOTWClass)
  private
    FVersaoDF: TVersaoCIOT;
    Fversao: Integer;
  protected
    procedure GerarIdentificacao(aVersao: Integer);

    procedure GerarGravarProprietario;
    procedure GerarGravarVeiculo;
    procedure GerarGravarMotorista;

    procedure GerarViagem;
    procedure GerarImpostos;
    procedure GerarPagamentos;
    procedure GerarContratado;
    procedure GerarMotorista;
    procedure GerarDestinatario;
    procedure GerarContratante;
    procedure GerarSubContratante;
    procedure GerarConsignatario;
    procedure GerarTomadorServico;
    procedure GerarRemetente;
    procedure GerarProprietarioCarga;
    procedure GerarVeiculos(const xPrefixo: String);

    procedure GerarViagemAdicViagem;
    procedure GerarPagamentosAdicViagem;

    procedure GerarPagamentosAdicPagamento;

    procedure GerarViagemEncerramento;
    procedure GerarPagamentosEncerramento;
    procedure GerarImpostosEncerramento;
  public
    constructor Create(ACIOTW: TCIOTW); override;

    property VersaoDF: TVersaoCIOT   read FVersaoDF write FVersaoDF;

    function ObterNomeArquivo: String; override;
    function GerarXml: Boolean; override;
  end;

const
  DSC_USUARIO = 'login: nome do usu�rio';
  DSC_SENHA = 'login: senha do usu�rio';
  DSC_CODATM = 'login: codigo AT&M';
  DSC_APLICACAO = 'Nome da Aplica��o';
  DSC_ASSUNTO = 'Assunto do e-mail';
  DSC_REMETENTES = 'Remetentes do e-mail';
  DSC_DESTINATARIOS = 'Destinat�rios do e-mail';
  DSC_CORPO = 'Corpo do e-mail';
  DSC_CHAVE = 'Chave';
  DSC_CHAVERESP = 'Chave Resposta';

implementation

constructor TCIOTW_eFrete.Create(ACIOTW: TCIOTW);
begin
  inherited Create(ACIOTW);
end;

function TCIOTW_eFrete.ObterNomeArquivo: String;
begin
  Result := '';
//  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

procedure TCIOTW_eFrete.GerarIdentificacao(aVersao: Integer);
var
  aPrefixo: string;
begin
  aPrefixo := Gerador.Prefixo;
  Gerador.Prefixo := 'obj1:';
  Fversao := aVersao;

  //ver de que forma pegar o tocken em caso de n�o usar certificado
  Gerador.wCampo(tcStr, 'AP03', 'Token', 01, 01, 0, CIOT.Integradora.Token);
  Gerador.wCampo(tcStr, 'AP04', 'Integrador', 01, 01, 0, CIOT.Integradora.Integrador);
  Gerador.wCampo(tcInt, 'AP05', 'Versao', 01, 01, 1, Fversao);

  Gerador.Prefixo := aPrefixo;
end;

procedure TCIOTW_eFrete.GerarGravarProprietario;
begin
  with CIOT.GravarProprietario do
  begin
    Gerador.wCampo(tcStr, 'AP06', 'CNPJ       ', 01, 01, 1, CNPJ);
    Gerador.wCampo(tcStr, 'AP07', 'TipoPessoa ', 01, 01, 1, TipoPessoaToStr(TipoPessoa));
    Gerador.wCampo(tcStr, 'AP08', 'RazaoSocial', 01, 01, 0, RazaoSocial);
    Gerador.wCampo(tcStr, 'AP09', 'RNTRC      ', 01, 01, 1, RNTRC);

    if Endereco.CodigoMunicipio > 0 then
    begin
      Gerador.wGrupo('Endereco', 'AP11');
      Gerador.Prefixo := 'obj1:';
      Gerador.wCampo(tcStr, 'AP12', 'Bairro         ', 01, 01, 0, Endereco.Bairro);
      Gerador.wCampo(tcStr, 'AP13', 'Rua            ', 01, 01, 0, Endereco.Rua);
      Gerador.wCampo(tcStr, 'AP14', 'Numero         ', 01, 01, 0, Endereco.Numero);
      Gerador.wCampo(tcStr, 'AP15', 'Complemento    ', 01, 01, 0, Endereco.Complemento);
      Gerador.wCampo(tcStr, 'AP16', 'CEP            ', 08, 08, 0, Endereco.CEP);
      Gerador.wCampo(tcInt, 'AP17', 'CodigoMunicipio', 07, 07, 1, Endereco.CodigoMunicipio);
      Gerador.Prefixo := 'obj:';
      Gerador.wGrupo('/Endereco');
    end;

    if (Telefones.Celular.Numero > 0) or
       (Telefones.Fixo.Numero > 0) or (Telefones.Fax.Numero > 0) then
    begin
      Gerador.wGrupo('Telefones', 'AP18');

      Gerador.Prefixo := 'obj1:';
      if Telefones.Celular.Numero > 0 then
      begin
        Gerador.wGrupo('Celular', 'AP19');
        Gerador.wCampo(tcInt, 'AP20', 'DDD   ', 01, 02, 1, Telefones.Celular.DDD, '');
        Gerador.wCampo(tcInt, 'AP21', 'Numero', 08, 09, 1, Telefones.Celular.Numero, '');
        Gerador.wGrupo('/Celular');
      end;

      if Telefones.Fixo.Numero > 0 then
      begin
        Gerador.wGrupo('Fixo', 'AP22');
        Gerador.wCampo(tcInt, 'AP23', 'DDD   ', 01, 02, 1, Telefones.Fixo.DDD, '');
        Gerador.wCampo(tcInt, 'AP24', 'Numero', 08, 09, 1, Telefones.Fixo.Numero, '');
        Gerador.wGrupo('/Fixo');
      end;

      if Telefones.Fax.Numero > 0 then
      begin
        Gerador.wGrupo('Fax', 'AP25');
        Gerador.wCampo(tcInt, 'AP26', 'DDD   ', 01, 02, 1, Telefones.Fax.DDD, '');
        Gerador.wCampo(tcInt, 'AP27', 'Numero', 08, 09, 1, Telefones.Fax.Numero, '');
        Gerador.wGrupo('/Fax');
      end;

      Gerador.Prefixo := 'obj:';
      Gerador.wGrupo('/Telefones');
    end;
  end;
end;

procedure TCIOTW_eFrete.GerarGravarVeiculo;
begin
  with CIOT.GravarVeiculo do
  begin
    if Renavam <> '' then
    begin
      Gerador.wGrupo('Veiculo', 'AP06');

      Gerador.wCampo(tcStr, 'AP07', 'Placa          ', 01, 01, 0, Placa);
      Gerador.wCampo(tcStr, 'AP08', 'Renavam        ', 01, 01, 1, Renavam);
      Gerador.wCampo(tcStr, 'AP09', 'Chassi         ', 01, 01, 0, Chassi);
      Gerador.wCampo(tcStr, 'AP10', 'RNTRC          ', 01, 01, 1, RNTRC);
      Gerador.wCampo(tcInt, 'AP11', 'NumeroDeEixos  ', 01, 01, 1, NumeroDeEixos);
      Gerador.wCampo(tcInt, 'AP12', 'CodigoMunicipio', 01, 01, 1, CodigoMunicipio);
      Gerador.wCampo(tcStr, 'AP13', 'Marca          ', 01, 01, 0, Marca);
      Gerador.wCampo(tcStr, 'AP14', 'Modelo         ', 01, 01, 0, Modelo);
      Gerador.wCampo(tcInt, 'AP15', 'AnoFabricacao  ', 01, 01, 1, AnoFabricacao);
      Gerador.wCampo(tcInt, 'AP16', 'AnoModelo      ', 01, 01, 1, AnoModelo);
      Gerador.wCampo(tcStr, 'AP17', 'Cor            ', 01, 01, 0, Cor);
      Gerador.wCampo(tcInt, 'AP18', 'Tara           ', 01, 01, 1, Tara);
      Gerador.wCampo(tcInt, 'AP19', 'CapacidadeKg   ', 01, 01, 1, CapacidadeKg);
      Gerador.wCampo(tcInt, 'AP20', 'CapacidadeM3   ', 01, 01, 1, CapacidadeM3);
      Gerador.wCampo(tcStr, 'AP21', 'TipoRodado     ', 01, 20, 1, TipoRodadoToStr(TipoRodado));
      Gerador.wCampo(tcStr, 'AP22', 'TipoCarroceria ', 01, 20, 1, TipoCarroceriaToStr(TipoCarroceria));

      Gerador.wGrupo('/Veiculo');
    end;
  end;
end;

procedure TCIOTW_eFrete.GerarGravarMotorista;
begin
  with CIOT.GravarMotorista do
  begin
    Gerador.wCampo(tcStr, 'AP06', 'CPF                ', 01, 01, 1, CPF);
    Gerador.wCampo(tcStr, 'AP07', 'Nome               ', 01, 01, 0, Nome);
    Gerador.wCampo(tcStr, 'AP08', 'CNH                ', 01, 01, 1, CNH);
    Gerador.wCampo(tcDat, 'AP09', 'DataNascimento     ', 01, 01, 1, DataNascimento);
    Gerador.wCampo(tcStr, 'AP10', 'NomeDeSolteiraDaMae', 01, 01, 0, NomeDeSolteiraDaMae);

    if Endereco.CodigoMunicipio > 0 then
    begin
      Gerador.wGrupo('Endereco', 'AP11');
      Gerador.Prefixo := 'obj1:';
      Gerador.wCampo(tcStr, 'AP12', 'Bairro         ', 01, 01, 0, Endereco.Bairro);
      Gerador.wCampo(tcStr, 'AP13', 'Rua            ', 01, 01, 0, Endereco.Rua);
      Gerador.wCampo(tcStr, 'AP14', 'Numero         ', 01, 01, 0, Endereco.Numero);
      Gerador.wCampo(tcStr, 'AP15', 'Complemento    ', 01, 01, 0, Endereco.Complemento);
      Gerador.wCampo(tcStr, 'AP16', 'CEP            ', 08, 08, 0, Endereco.CEP);
      Gerador.wCampo(tcInt, 'AP17', 'CodigoMunicipio', 07, 07, 1, Endereco.CodigoMunicipio);
      Gerador.Prefixo := 'obj:';
      Gerador.wGrupo('/Endereco');
    end;

    if (Telefones.Celular.Numero > 0) or
       (Telefones.Fixo.Numero > 0) or (Telefones.Fax.Numero > 0) then
    begin
      Gerador.wGrupo('Telefones', 'AP18');

      Gerador.Prefixo := 'obj1:';
      if Telefones.Celular.Numero > 0 then
      begin
        Gerador.wGrupo('Celular', 'AP19');
        Gerador.wCampo(tcInt, 'AP20', 'DDD   ', 01, 02, 1, Telefones.Celular.DDD, '');
        Gerador.wCampo(tcInt, 'AP21', 'Numero', 08, 09, 1, Telefones.Celular.Numero, '');
        Gerador.wGrupo('/Celular');
      end;

      if Telefones.Fixo.Numero > 0 then
      begin
        Gerador.wGrupo('Fixo', 'AP22');
        Gerador.wCampo(tcInt, 'AP23', 'DDD   ', 01, 02, 1, Telefones.Fixo.DDD, '');
        Gerador.wCampo(tcInt, 'AP24', 'Numero', 08, 09, 1, Telefones.Fixo.Numero, '');
        Gerador.wGrupo('/Fixo');
      end;

      if Telefones.Fax.Numero > 0 then
      begin
        Gerador.wGrupo('Fax', 'AP25');
        Gerador.wCampo(tcInt, 'AP26', 'DDD   ', 01, 02, 1, Telefones.Fax.DDD, '');
        Gerador.wCampo(tcInt, 'AP27', 'Numero', 08, 09, 1, Telefones.Fax.Numero, '');
        Gerador.wGrupo('/Fax');
      end;

      Gerador.Prefixo := 'obj:';
      Gerador.wGrupo('/Telefones');
    end;
  end;
end;

procedure TCIOTW_eFrete.GerarViagem;
var
  i, j: Integer;
  aPrefixo: string;
  Item: TNotaFiscalCollectionItem;
begin
  aPrefixo := Gerador.Prefixo;
  Gerador.Prefixo := 'adic:';

  for I := 0 to CIOT.AdicionarOperacao.Viagens.Count -1 do
  begin
    Gerador.wGrupo('Viagens', 'AP12');

    with CIOT.AdicionarOperacao.Viagens.Items[I] do
    begin
      Gerador.wCampo(tcStr, 'AP13', 'DocumentoViagem       ', 01, 01, 0, DocumentoViagem);
      Gerador.wCampo(tcInt, 'AP14', 'CodigoMunicipioOrigem ', 01, 07, 1, CodigoMunicipioOrigem);
      Gerador.wCampo(tcInt, 'AP15', 'CodigoMunicipioDestino', 01, 07, 1, CodigoMunicipioDestino);
      Gerador.wCampo(tcStr, 'AP16', 'CepOrigem             ', 01, 01, 0, CepOrigem);
      Gerador.wCampo(tcStr, 'AP17', 'CepDestino            ', 01, 01, 0, CepDestino);
      Gerador.wCampo(tcInt, 'AP18', 'DistanciaPercorrida   ', 01, 07, 1, DistanciaPercorrida);

      Gerador.Prefixo := 'obj:';

      if Valores.TotalOperacao > 0 then
      begin
        Gerador.wGrupo('Valores', 'AP19');

        Gerador.wCampo(tcDe2, 'AP20', 'TotalOperacao              ', 01, 01, 1, Valores.TotalOperacao);
        Gerador.wCampo(tcDe2, 'AP21', 'TotalViagem                ', 01, 01, 1, Valores.TotalViagem);
        Gerador.wCampo(tcDe2, 'AP22', 'TotalDeAdiantamento        ', 01, 01, 1, Valores.TotalDeAdiantamento);
        Gerador.wCampo(tcDe2, 'AP23', 'TotalDeQuitacao            ', 01, 01, 1, Valores.TotalDeQuitacao);
        Gerador.wCampo(tcDe2, 'AP24', 'Combustivel                ', 01, 01, 1, Valores.Combustivel);
        Gerador.wCampo(tcDe2, 'AP25', 'Pedagio                    ', 01, 01, 1, Valores.Pedagio);
        Gerador.wCampo(tcDe2, 'AP26', 'OutrosCreditos             ', 01, 01, 1, Valores.OutrosCreditos);
        Gerador.wCampo(tcStr, 'AP27', 'JustificativaOutrosCreditos', 01, 01, 0, Valores.JustificativaOutrosCreditos);
        Gerador.wCampo(tcDe2, 'AP28', 'Seguro                     ', 01, 01, 1, Valores.Seguro);
        Gerador.wCampo(tcDe2, 'AP29', 'OutrosDebitos              ', 01, 01, 1, Valores.OutrosDebitos);
        Gerador.wCampo(tcStr, 'AP30', 'JustificativaOutrosDebitos ', 01, 01, 0, Valores.JustificativaOutrosDebitos);

        Gerador.wGrupo('/Valores');
      end;

      Gerador.wCampo(tcStr, 'AP31', 'TipoPagamento', 001, 020, 1, TpPagamentoToStr(TipoPagamento));

      if TipoPagamento  = TransferenciaBancaria then
      begin
        if (InformacoesBancarias.InstituicaoBancaria <> '') or
           (InformacoesBancarias.Agencia <> '') or (InformacoesBancarias.Conta <> '') then
        begin
          Gerador.wGrupo('InformacoesBancarias', 'AP32');

          Gerador.wCampo(tcStr, 'AP33', 'InstituicaoBancaria', 01, 01, 0, InformacoesBancarias.InstituicaoBancaria);
          Gerador.wCampo(tcStr, 'AP34', 'Agencia            ', 01, 01, 0, InformacoesBancarias.Agencia);
          Gerador.wCampo(tcStr, 'AP35', 'Conta              ', 01, 01, 0, InformacoesBancarias.Conta);
          Gerador.wCampo(tcStr, 'AP36', 'TipoConta          ', 01, 15, 1, TipoContaToStr(InformacoesBancarias.TipoConta));

          Gerador.wGrupo('/InformacoesBancarias');
        end;
      end;

      if NotasFiscais.Count > 0 then
      begin
        Gerador.Prefixo := 'adic:';
        Gerador.wGrupo('NotasFiscais', 'AP37');

        for J := 0 to NotasFiscais.Count -1 do
        begin
          Item := NotasFiscais[J];

          Gerador.wGrupo('NotaFiscal', 'AP38');
          Gerador.wCampo(tcStr, 'AP39', 'Numero                            ', 01, 01, 0, Item.Numero);
          Gerador.wCampo(tcStr, 'AP40', 'Serie                             ', 01, 01, 0, Item.Serie);
          Gerador.wCampo(tcDat, 'AP41', 'Data                              ', 01, 01, 0, Item.Data);
          Gerador.wCampo(tcDe2, 'AP42', 'ValorTotal                        ', 01, 01, 1, Item.ValorTotal);
          Gerador.wCampo(tcDe4, 'AP43', 'ValorDaMercadoriaPorUnidade       ', 01, 01, 1, Item.ValorDaMercadoriaPorUnidade);
          Gerador.wCampo(tcInt, 'AP44', 'CodigoNCMNaturezaCarga            ', 01, 04, 1, Item.CodigoNCMNaturezaCarga);
          Gerador.wCampo(tcStr, 'AP45', 'DescricaoDaMercadoria             ', 01, 01, 0, Item.DescricaoDaMercadoria);
          Gerador.wCampo(tcStr, 'AP46', 'UnidadeDeMedidaDaMercadoria       ', 01, 01, 1, TpUnMedMercToStr(Item.UnidadeDeMedidaDaMercadoria));
          Gerador.wCampo(tcStr, 'AP47', 'TipoDeCalculo                     ', 01, 01, 1, TpVgTipoCalculoToStr(Item.TipoDeCalculo));
          Gerador.wCampo(tcDe4, 'AP48', 'ValorDoFretePorUnidadeDeMercadoria', 01, 01, 1, Item.ValorDoFretePorUnidadeDeMercadoria);
          Gerador.wCampo(tcDe5, 'AP49', 'QuantidadeDaMercadoriaNoEmbarque  ', 01, 01, 1, Item.QuantidadeDaMercadoriaNoEmbarque);

          if CIOT.AdicionarOperacao.TipoViagem <> TAC_Agregado then
          begin
            Gerador.wGrupo('ToleranciaDePerdaDeMercadoria', 'AP50');
            Gerador.wCampo(tcStr, 'AP51', 'Tipo ', 01, 01, 1, TpProporcaoToStr(Item.ToleranciaDePerdaDeMercadoria.Tipo));
            Gerador.wCampo(tcDe2, 'AP52', 'Valor', 01, 01, 1, Item.ToleranciaDePerdaDeMercadoria.Valor);
            Gerador.wGrupo('/ToleranciaDePerdaDeMercadoria');
          end;

          Gerador.wGrupo('DiferencaDeFrete', 'AP53');
          Gerador.Prefixo := 'obj:';

          Gerador.wCampo(tcStr, 'AP50', 'Tipo', 01, 01, 1, TpDifFreteToStr(Item.DiferencaDeFrete.Tipo));
          Gerador.wCampo(tcStr, 'AP51', 'Base', 01, 01, 1, TpDiferencaFreteBCToStr(Item.DiferencaDeFrete.Base));

          Gerador.wGrupo('Tolerancia', 'AP52');
          Gerador.wCampo(tcStr, 'AP53', 'Tipo ', 01, 01, 1, TpProporcaoToStr(Item.DiferencaDeFrete.Tolerancia.Tipo));
          Gerador.wCampo(tcDe2, 'AP54', 'Valor', 01, 01, 1, Item.DiferencaDeFrete.Tolerancia.Valor);
          Gerador.wGrupo('/Tolerancia');

          Gerador.wGrupo('MargemGanho', 'AP55');
          Gerador.wCampo(tcStr, 'AP56', 'Tipo ', 01, 01, 1, TpProporcaoToStr(Item.DiferencaDeFrete.MargemGanho.Tipo));
          Gerador.wCampo(tcDe2, 'AP57', 'Valor', 01, 01, 1, Item.DiferencaDeFrete.MargemGanho.Valor);
          Gerador.wGrupo('/MargemGanho');

          Gerador.wGrupo('MargemPerda', 'AP58');
          Gerador.wCampo(tcStr, 'AP59', 'Tipo', 01, 01, 1, TpProporcaoToStr(Item.DiferencaDeFrete.MargemPerda.Tipo));
          Gerador.wCampo(tcDe2, 'AP60', 'Valor', 01, 01, 1, Item.DiferencaDeFrete.MargemPerda.Valor);
          Gerador.wGrupo('/MargemPerda');

          Gerador.Prefixo := 'adic:';
          Gerador.wGrupo('/DiferencaDeFrete');

          Gerador.wGrupo('/NotaFiscal');
        end;

        Gerador.wGrupo('/NotasFiscais');
      end;
    end;

    Gerador.Prefixo := 'adic:';
    Gerador.wGrupo('/Viagens');
  end;

  Gerador.Prefixo := aPrefixo;
end;

procedure TCIOTW_eFrete.GerarImpostos;
begin
  with CIOT.AdicionarOperacao.Impostos do
  begin
    Gerador.wGrupo('Impostos', 'AP61');
    Gerador.wCampo(tcDe2, 'AP62', 'IRRF                   ', 01, 01, 1, IRRF, 'Valor destinado ao IRRF');
    Gerador.wCampo(tcDe2, 'AP63', 'SestSenat              ', 01, 01, 1, SestSenat, 'Valor destinado ao SEST / SENAT');
    Gerador.wCampo(tcDe2, 'AP64', 'INSS                   ', 01, 01, 1, INSS, 'Valor destinado ao INSS.');
    Gerador.wCampo(tcDe2, 'AP65', 'ISSQN                  ', 01, 01, 1, ISSQN, 'Valor destinado ao ISSQN.');
    Gerador.wCampo(tcDe2, 'AP66', 'OutrosImpostos         ', 01, 01, 1, OutrosImpostos, 'Valor destinado a outros impostos n�o previstos.');
    Gerador.wCampo(tcStr, 'AP67', 'DescricaoOutrosImpostos', 01, 01, 0, DescricaoOutrosImpostos);
    Gerador.wGrupo('/Impostos');
  end;
end;

procedure TCIOTW_eFrete.GerarPagamentos;
var
  i: Integer;
  aPrefixo: string;
begin
  aPrefixo := Gerador.Prefixo;
  Gerador.Prefixo := 'adic:';

  //Pagamentos registrados.
  //- Pode existir mais de 1 pagamento com uma mesma categoria (exceto para Quitacao).
  //- A soma dos pagamentos c/ categoria Adiantamento, dever� ter o mesmo valor apontado na
  //     tag TotalAdiantamento da tag Viagem/Valores, e neste caso, a tag Documento do pagamento
  //     dever� conter o mesmo valor da tag DocumentoViagem da tag Viagem .
  //- Se a viagem possuir a tag TotalQuitacao maior que zero, dever� ter um pagamento correspondente,
  //     com Categoria Quitacao e com o Documento o mesmo valor apontado na tag DocumentoViagem .
  for i := 0 to CIOT.AdicionarOperacao.Pagamentos.Count -1 do
  begin
    with CIOT.AdicionarOperacao.Pagamentos.Items[i] do
    begin
      Gerador.wGrupo('Pagamentos', 'AP68');
      Gerador.wCampo(tcStr, 'AP69', 'IdPagamentoCliente', 01, 01, 0, IdPagamentoCliente, 'Identificador do pagamento no sistema do Cliente.');
      Gerador.wCampo(tcDat, 'AP70', 'DataDeLiberacao   ', 01, 01, 1, DataDeLiberacao, 'Data em que o pagamento ser� liberado para saque.');
      Gerador.wCampo(tcDe2, 'AP71', 'Valor             ', 01, 01, 1, Valor, 'Valor do pagamento.');

      Gerador.Prefixo := 'obj:';
      Gerador.wCampo(tcStr, 'AP72', 'TipoPagamento', 01, 01, 1, TpPagamentoToStr(TipoPagamento), 'Tipo de pagamento que ser� usado pelo contratante. Restrito aos itens da enum: -TransferenciaBancaria -eFRETE');
      Gerador.wCampo(tcStr, 'AP73', 'Categoria    ', 01, 01, 1, TpCatPagToStr(Categoria), 'Categoria relacionada ao pagamento realizado. Restrita aos membros da ENUM: -Adiantamento, -Estadia, -Quitacao, -SemCategoria, -Frota ');

      Gerador.Prefixo := 'adic:';
      Gerador.wCampo(tcStr, 'AP74', 'Documento', 01, 01, 0, Documento, 'Documento relacionado a viagem.');

      // Preenchimento obrigat�rio para o TipoPagamento TransferenciaBancaria.
      // N�o deve ser preenchido para TipoPagamento eFRETE.
      if TipoPagamento  = TransferenciaBancaria then
      begin
        if (InformacoesBancarias.InstituicaoBancaria <> '') or
           (InformacoesBancarias.Agencia <> '') or (InformacoesBancarias.Conta <> '') then
        begin
          Gerador.Prefixo := 'obj:';
          Gerador.wGrupo('InformacoesBancarias', 'AP75');

          Gerador.wCampo(tcStr, 'AP76', 'InstituicaoBancaria', 01, 01, 0, InformacoesBancarias.InstituicaoBancaria, 'C�digo de compensa��o da institui��o banc�ria que ser� realizado o pagamento. ');
          Gerador.wCampo(tcStr, 'AP77', 'Agencia            ', 01, 01, 0, InformacoesBancarias.Agencia, 'Ag�ncia na qual o contratado possui conta com d�gito (se houver).');
          Gerador.wCampo(tcStr, 'AP78', 'Conta              ', 01, 01, 0, InformacoesBancarias.Conta, 'Conta do contratado com d�gito. ');
          Gerador.wCampo(tcStr, 'AP79', 'TipoConta          ', 01, 15, 1, TipoContaToStr(InformacoesBancarias.TipoConta));

          Gerador.wGrupo('/InformacoesBancarias');
        end;
      end;

      Gerador.Prefixo := 'adic:';
      Gerador.wCampo(tcStr, 'AP80', 'InformacaoAdicional', 01, 01, 0, InformacaoAdicional);

      if Categoria = tcpFrota then
        Gerador.wCampo(tcStr, 'AP81', 'CnpjFilialAbastecimento', 01, 01, 1, CnpjFilialAbastecimento);

      Gerador.wGrupo('/Pagamentos');
    end;
  end;

  Gerador.Prefixo := aPrefixo;
end;

procedure TCIOTW_eFrete.GerarContratado;
var
  aPrefixo: string;
begin
  aPrefixo := Gerador.Prefixo;
  Gerador.Prefixo := 'adic:';

  //TAC ou seu Equiparado, que efetuar o transporte rodovi�rio de cargas por conta de terceiros e
  //mediante remunera��o, indicado no cadastramento da Opera��o de Transporte.
  //Para o TipoViagem Frota o Contratado ser� a pr�pria empresa que est� declarando a opera��o.

  with CIOT.AdicionarOperacao.Contratado do
  begin
    if CpfOuCnpj <> '' then
    begin
      Gerador.wGrupo('Contratado', 'AP82');
      Gerador.wCampo(tcStr, 'AP83', 'CpfOuCnpj', 01, 01, 1, CpfOuCnpj);
      Gerador.wCampo(tcStr, 'AP84', 'RNTRC    ', 01, 01, 1, RNTRC);
      Gerador.wGrupo('/Contratado');
    end;
  end;

  Gerador.Prefixo := aPrefixo;
end;

procedure TCIOTW_eFrete.GerarMotorista;
var
  aPrefixo: string;
begin
  aPrefixo := Gerador.Prefixo;
  Gerador.Prefixo := 'adic:';

  //� o condutor do ve�culo que ir� realizar a opera��o de transporte,
  //pode ser o propriet�rio do ve�culo ou n�o.
  with CIOT.AdicionarOperacao.Motorista do
  begin
    if CpfOuCnpj <> '' then
    begin
      Gerador.wGrupo('Motorista', 'AP85');
      Gerador.wCampo(tcStr, 'AP86', 'CpfOuCnpj', 01, 11, 1, CpfOuCnpj, 'CPF ou CNPJ do Motorista.');
      Gerador.wCampo(tcStr, 'AP87', 'CNH      ', 01, 11, 1, CIOT.AdicionarOperacao.Motorista.CNH);

      Gerador.Prefixo := 'obj:';

      if Celular.Numero <> 0 then
      begin
        Gerador.wGrupo('Celular', 'AP88');
        Gerador.Prefixo := 'obj1:';
        Gerador.wCampo(tcInt, 'AP89', 'DDD   ', 01, 02, 1, Celular.DDD, '');
        Gerador.wCampo(tcInt, 'AP90', 'Numero', 08, 09, 1, Celular.Numero, '');
        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Celular');
      end;

      Gerador.Prefixo := 'adic:';
      Gerador.wGrupo('/Motorista');
    end;
  end;

  Gerador.Prefixo := aPrefixo;
end;

procedure TCIOTW_eFrete.GerarDestinatario;
begin
  //Destinat�rio da carga.
  //Na emiss�o com TipoViagem Padr�o seu preenchimento � obrigat�rio.
  //Na emiss�o com TipoViagem TAC_Agregado o campo n�o deve ser preenchido.
  //N�o esperado para TipoViagem Frota.
  with CIOT.AdicionarOperacao.Destinatario do
  begin
    if Length(Trim(CpfOuCnpj)) > 0 then
    begin
      Gerador.wGrupo('Destinatario', 'AP91');
      Gerador.wCampo(tcStr, 'AP92', 'NomeOuRazaoSocial', 01, 01, 0, NomeOuRazaoSocial);
      Gerador.wCampo(tcStr, 'AP93', 'CpfOuCnpj        ', 11, 14, 1, CpfOuCnpj);

      if Endereco.CodigoMunicipio > 0 then
      begin
        Gerador.wGrupo('Endereco', 'AP94');
        Gerador.Prefixo := 'obj1:';
        Gerador.wCampo(tcStr, 'AP095', 'Bairro         ', 01, 01, 0, Endereco.Bairro);
        Gerador.wCampo(tcStr, 'AP096', 'Rua            ', 01, 01, 0, Endereco.Rua);
        Gerador.wCampo(tcStr, 'AP097', 'Numero         ', 01, 01, 0, Endereco.Numero);
        Gerador.wCampo(tcStr, 'AP098', 'Complemento    ', 01, 01, 0, Endereco.Complemento);
        Gerador.wCampo(tcStr, 'AP099', 'CEP            ', 08, 08, 0, Endereco.CEP);
        Gerador.wCampo(tcInt, 'AP100', 'CodigoMunicipio', 07, 07, 1, Endereco.CodigoMunicipio);
        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Endereco');
      end;

      Gerador.wCampo(tcStr, 'AP101', 'EMail', 01, 01, 0, EMail);

      if (Telefones.Celular.Numero > 0) or
         (Telefones.Fixo.Numero > 0) or (Telefones.Fax.Numero > 0) then
      begin
        Gerador.wGrupo('Telefones', 'AP102');

        Gerador.Prefixo := 'obj1:';
        if Telefones.Celular.Numero > 0 then
        begin
          Gerador.wGrupo('Celular', 'AP103');
          Gerador.wCampo(tcInt, 'AP104', 'DDD   ', 01, 02, 1, Telefones.Celular.DDD, '');
          Gerador.wCampo(tcInt, 'AP105', 'Numero', 08, 09, 1, Telefones.Celular.Numero, '');
          Gerador.wGrupo('/Celular');
        end;

        if Telefones.Fixo.Numero > 0 then
        begin
          Gerador.wGrupo('Fixo', 'AP106');
          Gerador.wCampo(tcInt, 'AP107', 'DDD   ', 01, 02, 1, Telefones.Fixo.DDD, '');
          Gerador.wCampo(tcInt, 'AP108', 'Numero', 08, 09, 1, Telefones.Fixo.Numero, '');
          Gerador.wGrupo('/Fixo');
        end;

        if Telefones.Fax.Numero > 0 then
        begin
          Gerador.wGrupo('Fax', 'AP109');
          Gerador.wCampo(tcInt, 'AP110', 'DDD   ', 01, 02, 1, Telefones.Fax.DDD, '');
          Gerador.wCampo(tcInt, 'AP111', 'Numero', 08, 09, 1, Telefones.Fax.Numero, '');
          Gerador.wGrupo('/Fax');
        end;

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Telefones');
      end;

      Gerador.wCampo(tcStr, 'AP112', 'ResponsavelPeloPagamento', 01, 01, 1, LowerCase(BoolToStr(ResponsavelPeloPagamento, True)), 'Informar se � o respons�vel pelo pagamento da Opera��o de Transporte. True = Sim. False = N�o');

      Gerador.wGrupo('/Destinatario');
    end;
  end;
end;

procedure TCIOTW_eFrete.GerarContratante;
begin
  with CIOT.AdicionarOperacao.Contratante do
  begin
    if Length(Trim(CpfOuCnpj)) > 0 then
    begin
      Gerador.wGrupo('Contratante', 'AP113');
      Gerador.wCampo(tcStr, 'AP114', 'NomeOuRazaoSocial', 01, 01, 0, NomeOuRazaoSocial);
      Gerador.wCampo(tcStr, 'AP115', 'CpfOuCnpj        ', 11, 14, 1, CpfOuCnpj);

      if Endereco.CodigoMunicipio > 0 then
      begin
        Gerador.wGrupo('Endereco', 'AP116');
        Gerador.Prefixo := 'obj1:';
        Gerador.wCampo(tcStr, 'AP117', 'Bairro         ', 01, 01, 0, Endereco.Bairro);
        Gerador.wCampo(tcStr, 'AP118', 'Rua            ', 01, 01, 0, Endereco.Rua);
        Gerador.wCampo(tcStr, 'AP119', 'Numero         ', 01, 01, 0, Endereco.Numero);
        Gerador.wCampo(tcStr, 'AP120', 'Complemento    ', 01, 01, 0, Endereco.Complemento);
        Gerador.wCampo(tcStr, 'AP121', 'CEP            ', 01, 09, 0, Endereco.CEP);
        Gerador.wCampo(tcInt, 'AP122', 'CodigoMunicipio', 07, 07, 1, Endereco.CodigoMunicipio);
        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Endereco');
      end;

      Gerador.wCampo(tcStr, 'AP123', 'EMail', 01, 01, 0, EMail);

      if (Telefones.Celular.Numero > 0) or
         (Telefones.Fixo.Numero > 0) or (Telefones.Fax.Numero > 0) then
      begin
        Gerador.wGrupo('Telefones', 'AP124');

        Gerador.Prefixo := 'obj1:';

        if Telefones.Celular.Numero > 0 then
        begin
          Gerador.wGrupo('Celular', 'AP125');
          Gerador.wCampo(tcInt, 'AP126', 'DDD   ', 01, 02, 0, Telefones.Celular.DDD, '');
          Gerador.wCampo(tcInt, 'AP127', 'Numero', 08, 09, 0, Telefones.Celular.Numero, '');
          Gerador.wGrupo('/Celular');
        end;

        if Telefones.Fixo.Numero > 0 then
        begin
          Gerador.wGrupo('Fixo', 'AP128');
          Gerador.wCampo(tcInt, 'AP129', 'DDD   ', 01, 02, 0, Telefones.Fixo.DDD, '');
          Gerador.wCampo(tcInt, 'AP130', 'Numero', 08, 09, 0, Telefones.Fixo.Numero, '');
          Gerador.wGrupo('/Fixo');
        end;

        if Telefones.Fax.Numero > 0 then
        begin
          Gerador.wGrupo('Fax', 'AP131');
          Gerador.wCampo(tcInt, 'AP132', 'DDD   ', 01, 02, 0, Telefones.Fax.DDD, '');
          Gerador.wCampo(tcInt, 'AP133', 'Numero', 08, 09, 0, Telefones.Fax.Numero, '');
          Gerador.wGrupo('/Fax');
        end;

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Telefones');
      end;

      Gerador.wCampo(tcStr, 'AP134', 'ResponsavelPeloPagamento', 01, 01, 1, LowerCase(BoolToStr(ResponsavelPeloPagamento, True)));
      Gerador.wCampo(tcStr, 'AP135', 'RNTRC                   ', 01, 01, 0, RNTRC);

      Gerador.wGrupo('/Contratante');
    end;
  end;
end;

procedure TCIOTW_eFrete.GerarSubContratante;
begin
  //� o transportador que contratar outro transportador para realiza��o do transporte de
  //cargas para o qual fora anteriormente contratado, indicado no cadastramento da Opera��o de Transporte.
  //N�o esperado para TipoViagem Frota.

  with CIOT.AdicionarOperacao.Subcontratante do
  begin
    if Length(Trim(CpfOuCnpj)) > 0 then
    begin
      Gerador.wGrupo('Subcontratante', 'AP136');
      Gerador.wCampo(tcStr, 'AP137', 'NomeOuRazaoSocial', 01, 01, 0, NomeOuRazaoSocial);
      Gerador.wCampo(tcStr, 'AP138', 'CpfOuCnpj        ', 01, 01, 1, CpfOuCnpj);

      if Endereco.CodigoMunicipio > 0 then
      begin
        Gerador.wGrupo('Endereco', 'AP139');
        Gerador.Prefixo := 'obj1:';
        Gerador.wCampo(tcStr, 'AP140', 'Bairro         ', 01, 01, 0, Endereco.Bairro);
        Gerador.wCampo(tcStr, 'AP141', 'Rua            ', 01, 01, 0, Endereco.Rua);
        Gerador.wCampo(tcStr, 'AP142', 'Numero         ', 01, 01, 0, Endereco.Numero);
        Gerador.wCampo(tcStr, 'AP143', 'Complemento    ', 01, 01, 0, Endereco.Complemento);
        Gerador.wCampo(tcStr, 'AP144', 'CEP            ', 01, 09, 0, Endereco.CEP);
        Gerador.wCampo(tcInt, 'AP145', 'CodigoMunicipio', 01, 07, 1, Endereco.CodigoMunicipio);
        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Endereco');
      end;

      Gerador.wCampo(tcStr, 'AP146', 'EMail', 01, 01, 0, EMail);

      if (Telefones.Celular.Numero > 0) or
         (Telefones.Fixo.Numero > 0) or (Telefones.Fax.Numero > 0) then
      begin
        Gerador.wGrupo('Telefones', 'AP147');

        Gerador.Prefixo := 'obj1:';

        if Telefones.Celular.Numero > 0 then
        begin
          Gerador.wGrupo('Celular', 'AP148');
          Gerador.wCampo(tcInt, 'AP149', 'DDD   ', 01, 02, 1, Telefones.Celular.DDD, '');
          Gerador.wCampo(tcInt, 'AP150', 'Numero', 08, 09, 1, Telefones.Celular.Numero, '');
          Gerador.wGrupo('/Celular');
        end;

        if Telefones.Fixo.Numero > 0 then
        begin
          Gerador.wGrupo('Fixo', 'AP151');
          Gerador.wCampo(tcInt, 'AP152', 'DDD   ', 01, 02, 1, Telefones.Fixo.DDD, '');
          Gerador.wCampo(tcInt, 'AP153', 'Numero', 08, 09, 1, Telefones.Fixo.Numero, '');
          Gerador.wGrupo('/Fixo');
        end;

        if Telefones.Fax.Numero > 0 then
        begin
          Gerador.wGrupo('Fax', 'AP154');
          Gerador.wCampo(tcInt, 'AP155', 'DDD   ', 01, 02, 1, Telefones.Fax.DDD, '');
          Gerador.wCampo(tcInt, 'AP156', 'Numero', 08, 09, 1, Telefones.Fax.Numero, '');
          Gerador.wGrupo('/Fax');
        end;

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Telefones');
      end;

      Gerador.wCampo(tcStr, 'AP157', 'ResponsavelPeloPagamento', 01, 01, 1, LowerCase(BoolToStr(ResponsavelPeloPagamento, True)));

      Gerador.wGrupo('/Subcontratante');
    end;
  end;
end;

procedure TCIOTW_eFrete.GerarConsignatario;
begin
  //Aquele que receber� as mercadorias transportadas em consigna��o,
  //indicado no cadastramento da Opera��o de Transporte ou nos respectivos documentos fiscais.
  //N�o esperado para TipoViagem Frota.

  with CIOT.AdicionarOperacao.Consignatario do
  begin
    if Length(Trim(CpfOuCnpj)) > 0 then
    begin
      Gerador.wGrupo('Consignatario', 'AP158');
      Gerador.wCampo(tcStr, 'AP159', 'NomeOuRazaoSocial', 01, 01, 0, NomeOuRazaoSocial);
      Gerador.wCampo(tcStr, 'AP160', 'CpfOuCnpj        ', 01, 01, 1, CpfOuCnpj);

      if Endereco.CodigoMunicipio > 0 then
      begin
        Gerador.wGrupo('Endereco', 'AP161');
        Gerador.Prefixo := 'obj1:';
        Gerador.wCampo(tcStr, 'AP162', 'Bairro         ', 01, 01, 0, Endereco.Bairro);
        Gerador.wCampo(tcStr, 'AP163', 'Rua            ', 01, 01, 0, Endereco.Rua);
        Gerador.wCampo(tcStr, 'AP164', 'Numero         ', 01, 01, 0, Endereco.Numero);
        Gerador.wCampo(tcStr, 'AP165', 'Complemento    ', 01, 01, 0, Endereco.Complemento);
        Gerador.wCampo(tcStr, 'AP166', 'CEP            ', 01, 09, 0, Endereco.CEP);
        Gerador.wCampo(tcInt, 'AP167', 'CodigoMunicipio', 01, 07, 1, Endereco.CodigoMunicipio);
        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Endereco');
      end;

      Gerador.wCampo(tcStr, 'AP168', 'EMail', 01, 01, 0, EMail);

      if (Telefones.Celular.Numero > 0) or
         (Telefones.Fixo.Numero > 0) or (Telefones.Fax.Numero > 0) then
      begin
        Gerador.wGrupo('Telefones', 'AP169');

        Gerador.Prefixo := 'obj1:';

        if Telefones.Celular.Numero > 0 then
        begin
          Gerador.wGrupo('Celular', 'AP170');
          Gerador.wCampo(tcInt, 'AP171', 'DDD   ', 01, 02, 1, Telefones.Celular.DDD, '');
          Gerador.wCampo(tcInt, 'AP172', 'Numero', 08, 09, 1, Telefones.Celular.Numero, '');
          Gerador.wGrupo('/Celular');
        end;

        if Telefones.Fixo.Numero > 0 then
        begin
          Gerador.wGrupo('Fixo', 'AP173');
          Gerador.wCampo(tcInt, 'AP174', 'DDD   ', 01, 02, 1, Telefones.Fixo.DDD, '');
          Gerador.wCampo(tcInt, 'AP175', 'Numero', 08, 09, 1, Telefones.Fixo.Numero, '');
          Gerador.wGrupo('/Fixo');
        end;

        if Telefones.Fax.Numero > 0 then
        begin
          Gerador.wGrupo('Fax', 'AP176');
          Gerador.wCampo(tcInt, 'AP177', 'DDD   ', 01, 02, 1, Telefones.Fax.DDD, '');
          Gerador.wCampo(tcInt, 'AP178', 'Numero', 08, 09, 1, Telefones.Fax.Numero, '');
          Gerador.wGrupo('/Fax');
        end;

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Telefones');
      end;

      Gerador.wCampo(tcStr, 'AP179', 'ResponsavelPeloPagamento', 01, 01, 1, LowerCase(BoolToStr(ResponsavelPeloPagamento, True)));

      Gerador.wGrupo('/Consignatario');
    end;
  end;
end;

procedure TCIOTW_eFrete.GerarTomadorServico;
begin
  //Pessoa (f�sica ou jur�dica) que contratou o frete pela transportadora.
  //Na emiss�o com TipoViagem Padr�o seu preenchimento � obrigat�rio.
  //Na emiss�o com TipoViagem TAC_Agregado o campo n�o deve ser preenchido.

  with CIOT.AdicionarOperacao.TomadorServico do
  begin
    if Length(Trim(CpfOuCnpj)) > 0 then
    begin
      Gerador.wGrupo('TomadorServico', 'AP180');
      Gerador.wCampo(tcStr, 'AP181', 'NomeOuRazaoSocial', 01, 01, 0, NomeOuRazaoSocial);
      Gerador.wCampo(tcStr, 'AP182', 'CpfOuCnpj        ', 01, 01, 1, CpfOuCnpj);

      if Endereco.CodigoMunicipio > 0 then
      begin
        Gerador.wGrupo('Endereco', 'AP183');
        Gerador.Prefixo := 'obj1:';
        Gerador.wCampo(tcStr, 'AP184', 'Bairro         ', 01, 01, 0, Endereco.Bairro);
        Gerador.wCampo(tcStr, 'AP185', 'Rua            ', 01, 01, 0, Endereco.Rua);
        Gerador.wCampo(tcStr, 'AP186', 'Numero         ', 01, 01, 0, Endereco.Numero);
        Gerador.wCampo(tcStr, 'AP187', 'Complemento    ', 01, 01, 0, Endereco.Complemento);
        Gerador.wCampo(tcStr, 'AP188', 'CEP            ', 01, 09, 0, Endereco.CEP);
        Gerador.wCampo(tcInt, 'AP189', 'CodigoMunicipio', 01, 07, 1, Endereco.CodigoMunicipio);
        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Endereco');
      end;

      Gerador.wCampo(tcStr, 'AP190', 'EMail', 01, 01, 0, EMail);

      if (Telefones.Celular.Numero > 0) or
         (Telefones.Fixo.Numero > 0) or (Telefones.Fax.Numero > 0) then
      begin
        Gerador.wGrupo('Telefones', 'AP191');

        Gerador.Prefixo := 'obj1:';

        if Telefones.Celular.Numero > 0 then
        begin
          Gerador.wGrupo('Celular', 'AP192');
          Gerador.wCampo(tcInt, 'AP193', 'DDD   ', 01, 02, 1, Telefones.Celular.DDD, '');
          Gerador.wCampo(tcInt, 'AP194', 'Numero', 08, 09, 1, Telefones.Celular.Numero, '');
          Gerador.wGrupo('/Celular');
        end;

        if Telefones.Fixo.Numero > 0 then
        begin
          Gerador.wGrupo('Fixo', 'AP195');
          Gerador.wCampo(tcInt, 'AP196', 'DDD   ', 01, 02, 1, Telefones.Fixo.DDD, '');
          Gerador.wCampo(tcInt, 'AP197', 'Numero', 08, 09, 1, Telefones.Fixo.Numero, '');
          Gerador.wGrupo('/Fixo');
        end;

        if Telefones.Fax.Numero > 0 then
        begin
          Gerador.wGrupo('Fax', 'AP198');
          Gerador.wCampo(tcInt, 'AP199', 'DDD   ', 01, 02, 1, Telefones.Fax.DDD, '');
          Gerador.wCampo(tcInt, 'AP200', 'Numero', 08, 09, 1, Telefones.Fax.Numero, '');
          Gerador.wGrupo('/Fax');
        end;

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Telefones');
      end;

      Gerador.wCampo(tcStr, 'AP201', 'ResponsavelPeloPagamento', 01, 01, 1, LowerCase(BoolToStr(ResponsavelPeloPagamento, True)));

      Gerador.wGrupo('/TomadorServico');
    end;
  end;
end;

procedure TCIOTW_eFrete.GerarRemetente;
begin
  with CIOT.AdicionarOperacao.Remetente do
  begin
    if Length(Trim(CpfOuCnpj)) > 0 then
    begin
      Gerador.wGrupo('Remetente', 'AP202');
      Gerador.wCampo(tcStr, 'AP203', 'NomeOuRazaoSocial', 01, 01, 0, NomeOuRazaoSocial);
      Gerador.wCampo(tcStr, 'AP204', 'CpfOuCnpj        ', 01, 01, 1, CpfOuCnpj);

      if Endereco.CodigoMunicipio > 0 then
      begin
        Gerador.wGrupo('Endereco', 'AP205');
        Gerador.Prefixo := 'obj1:';
        Gerador.wCampo(tcStr, 'AP206', 'Bairro         ', 01, 01, 0, Endereco.Bairro);
        Gerador.wCampo(tcStr, 'AP207', 'Rua            ', 01, 01, 0, Endereco.Rua);
        Gerador.wCampo(tcStr, 'AP208', 'Numero         ', 01, 01, 0, Endereco.Numero);
        Gerador.wCampo(tcStr, 'AP209', 'Complemento    ', 01, 01, 0, Endereco.Complemento);
        Gerador.wCampo(tcStr, 'AP210', 'CEP            ', 01, 09, 0, Endereco.CEP);
        Gerador.wCampo(tcInt, 'AP211', 'CodigoMunicipio', 01, 07, 1, Endereco.CodigoMunicipio);
        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Endereco');
      end;

      Gerador.wCampo(tcStr, 'AP212', 'EMail', 01, 01, 0, EMail);

      if (Telefones.Celular.Numero > 0) or
         (Telefones.Fixo.Numero > 0) or (Telefones.Fax.Numero > 0) then
      begin
        Gerador.wGrupo('Telefones', 'AP213');

        Gerador.Prefixo := 'obj1:';

        if Telefones.Celular.Numero > 0 then
        begin
          Gerador.wGrupo('Celular', 'AP214');
          Gerador.wCampo(tcInt, 'AP215', 'DDD   ', 01, 02, 1, Telefones.Celular.DDD, '');
          Gerador.wCampo(tcInt, 'AP216', 'Numero', 08, 09, 1, Telefones.Celular.Numero, '');
          Gerador.wGrupo('/Celular');
        end;

        if Telefones.Fixo.Numero > 0 then
        begin
          Gerador.wGrupo('Fixo', 'AP217');
          Gerador.wCampo(tcInt, 'AP218', 'DDD   ', 01, 02, 1, Telefones.Fixo.DDD, '');
          Gerador.wCampo(tcInt, 'AP219', 'Numero', 08, 09, 1, Telefones.Fixo.Numero, '');
          Gerador.wGrupo('/Fixo');
        end;

        if Telefones.Fax.Numero > 0 then
        begin
          Gerador.wGrupo('Fax', 'AP220');
          Gerador.wCampo(tcInt, 'AP221', 'DDD   ', 01, 02, 1, Telefones.Fax.DDD, '');
          Gerador.wCampo(tcInt, 'AP222', 'Numero', 08, 09, 1, Telefones.Fax.Numero, '');
          Gerador.wGrupo('/Fax');
        end;

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Telefones');
      end;

      Gerador.wCampo(tcStr, 'AP223', 'ResponsavelPeloPagamento', 01, 01, 1, LowerCase(BoolToStr(ResponsavelPeloPagamento, True)));

      Gerador.wGrupo('/Remetente');
    end;
  end;
end;

procedure TCIOTW_eFrete.GerarProprietarioCarga;
begin
  with CIOT.AdicionarOperacao.ProprietarioCarga do
  begin
    if Length(Trim(CpfOuCnpj)) > 0 then
    begin
      Gerador.wGrupo('ProprietarioCarga', 'AP224');
      Gerador.wCampo(tcStr, 'AP225', 'NomeOuRazaoSocial', 01, 01, 0, NomeOuRazaoSocial);
      Gerador.wCampo(tcStr, 'AP226', 'CpfOuCnpj        ', 01, 01, 1, CpfOuCnpj);

      if Endereco.CodigoMunicipio > 0 then
      begin
        Gerador.wGrupo('Endereco', 'AP227');
        Gerador.Prefixo := 'obj1:';
        Gerador.wCampo(tcStr, 'AP228', 'Bairro         ', 01, 01, 0, Endereco.Bairro);
        Gerador.wCampo(tcStr, 'AP229', 'Rua            ', 01, 01, 0, Endereco.Rua);
        Gerador.wCampo(tcStr, 'AP230', 'Numero         ', 01, 01, 0, Endereco.Numero);
        Gerador.wCampo(tcStr, 'AP231', 'Complemento    ', 01, 01, 0, Endereco.Complemento);
        Gerador.wCampo(tcStr, 'AP232', 'CEP            ', 01, 09, 0, Endereco.CEP);
        Gerador.wCampo(tcInt, 'AP233', 'CodigoMunicipio', 01, 07, 1, Endereco.CodigoMunicipio);
        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Endereco');
      end;

      Gerador.wCampo(tcStr, 'AP234', 'EMail', 01, 01, 0, EMail);

      if (Telefones.Celular.Numero > 0) or
         (Telefones.Fixo.Numero > 0) or (Telefones.Fax.Numero > 0) then
      begin
        Gerador.wGrupo('Telefones', 'AP235');

        Gerador.Prefixo := 'obj1:';

        if Telefones.Celular.Numero > 0 then
        begin
          Gerador.wGrupo('Celular', 'AP236');
          Gerador.wCampo(tcInt, 'AP237', 'DDD   ', 01, 02, 1, Telefones.Celular.DDD, '');
          Gerador.wCampo(tcInt, 'AP238', 'Numero', 08, 09, 1, Telefones.Celular.Numero, '');
          Gerador.wGrupo('/Celular');
        end;

        if Telefones.Fixo.Numero > 0 then
        begin
          Gerador.wGrupo('Fixo', 'AP239');
          Gerador.wCampo(tcInt, 'AP240', 'DDD   ', 01, 02, 1, Telefones.Fixo.DDD, '');
          Gerador.wCampo(tcInt, 'AP241', 'Numero', 08, 09, 1, Telefones.Fixo.Numero, '');
          Gerador.wGrupo('/Fixo');
        end;

        if Telefones.Fax.Numero > 0 then
        begin
          Gerador.wGrupo('Fax', 'AP242');
          Gerador.wCampo(tcInt, 'AP243', 'DDD   ', 01, 02, 1, Telefones.Fax.DDD, '');
          Gerador.wCampo(tcInt, 'AP244', 'Numero', 08, 09, 1, Telefones.Fax.Numero, '');
          Gerador.wGrupo('/Fax');
        end;

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/Telefones');
      end;

      Gerador.wCampo(tcStr, 'AP245', 'ResponsavelPeloPagamento', 01, 01, 1, LowerCase(BoolToStr(ResponsavelPeloPagamento, True)));

      Gerador.wGrupo('/ProprietarioCarga');
    end;
  end;
end;

procedure TCIOTW_eFrete.GerarVeiculos(const xPrefixo: String);
var
  i: Integer;
  aPrefixo: string;
begin
  aPrefixo := Gerador.Prefixo;
  Gerador.Prefixo := xPrefixo;

  if xPrefixo = 'adic:' then
  begin
    for i := 0 to CIOT.AdicionarOperacao.Veiculos.Count -1 do
    begin
      Gerador.wGrupo('Veiculos', 'AP246');
      Gerador.wCampo(tcStr, 'AP247', 'Placa', 01, 07, 1, CIOT.AdicionarOperacao.Veiculos.Items[I].Placa);
      Gerador.wGrupo('/Veiculos');
    end;
  end;

  if xPrefixo = 'ret:' then
  begin
    if CIOT.RetificarOperacao.Veiculos.Count > 0 then
    begin
      Gerador.wGrupo('Veiculos', 'AP201');

      for i := 0 to CIOT.RetificarOperacao.Veiculos.Count -1 do
      begin
        Gerador.wGrupo('Veiculo', 'AP201');
        Gerador.wCampo(tcStr, 'AP202', 'Placa', 01, 07, 1, CIOT.RetificarOperacao.Veiculos.Items[I].Placa);
        Gerador.wGrupo('/Veiculo');
      end;

      Gerador.wGrupo('/Veiculos');
    end;
  end;

  Gerador.Prefixo := aPrefixo;
end;

procedure TCIOTW_eFrete.GerarViagemAdicViagem;
var
  i, j: Integer;
  aPrefixo: string;
  Item: TNotaFiscalCollectionItem;
begin
  aPrefixo := Gerador.Prefixo;
  Gerador.Prefixo := 'adic:';

  Gerador.wGrupo('Viagens', 'AP12');

  for I := 0 to CIOT.AdicionarViagem.Viagens.Count -1 do
  begin
    Gerador.wGrupo('Viagem', 'AP12');

    with CIOT.AdicionarViagem.Viagens.Items[I] do
    begin
      Gerador.wCampo(tcStr, 'AP13', 'DocumentoViagem       ', 01, 01, 0, DocumentoViagem);
      Gerador.wCampo(tcInt, 'AP14', 'CodigoMunicipioOrigem ', 01, 07, 1, CodigoMunicipioOrigem);
      Gerador.wCampo(tcInt, 'AP15', 'CodigoMunicipioDestino', 01, 07, 1, CodigoMunicipioDestino);
      Gerador.wCampo(tcStr, 'AP16', 'CepOrigem             ', 01, 01, 0, CepOrigem);
      Gerador.wCampo(tcStr, 'AP17', 'CepDestino            ', 01, 01, 0, CepDestino);

      Gerador.Prefixo := 'obj:';

      if Valores.TotalOperacao > 0 then
      begin
        Gerador.wGrupo('Valores', 'AP19');

        Gerador.wCampo(tcDe2, 'AP20', 'TotalOperacao              ', 01, 01, 1, Valores.TotalOperacao);
        Gerador.wCampo(tcDe2, 'AP21', 'TotalViagem                ', 01, 01, 1, Valores.TotalViagem);
        Gerador.wCampo(tcDe2, 'AP22', 'TotalDeAdiantamento        ', 01, 01, 1, Valores.TotalDeAdiantamento);
        Gerador.wCampo(tcDe2, 'AP23', 'TotalDeQuitacao            ', 01, 01, 1, Valores.TotalDeQuitacao);
        Gerador.wCampo(tcDe2, 'AP24', 'Combustivel                ', 01, 01, 1, Valores.Combustivel);
        Gerador.wCampo(tcDe2, 'AP25', 'Pedagio                    ', 01, 01, 1, Valores.Pedagio);
        Gerador.wCampo(tcDe2, 'AP26', 'OutrosCreditos             ', 01, 01, 1, Valores.OutrosCreditos);
        Gerador.wCampo(tcStr, 'AP27', 'JustificativaOutrosCreditos', 01, 01, 0, Valores.JustificativaOutrosCreditos);
        Gerador.wCampo(tcDe2, 'AP28', 'Seguro                     ', 01, 01, 1, Valores.Seguro);
        Gerador.wCampo(tcDe2, 'AP29', 'OutrosDebitos              ', 01, 01, 1, Valores.OutrosDebitos);
        Gerador.wCampo(tcStr, 'AP30', 'JustificativaOutrosDebitos ', 01, 01, 0, Valores.JustificativaOutrosDebitos);

        Gerador.wGrupo('/Valores');
      end;

      Gerador.wCampo(tcStr, 'AP31', 'TipoPagamento', 001, 020, 1, TpPagamentoToStr(TipoPagamento));

      if TipoPagamento  = TransferenciaBancaria then
      begin
        if (InformacoesBancarias.InstituicaoBancaria <> '') or
           (InformacoesBancarias.Agencia <> '') or (InformacoesBancarias.Conta <> '') then
        begin
          Gerador.wGrupo('InformacoesBancarias', 'AP32');

          Gerador.wCampo(tcStr, 'AP33', 'InstituicaoBancaria', 01, 01, 0, InformacoesBancarias.InstituicaoBancaria);
          Gerador.wCampo(tcStr, 'AP34', 'Agencia            ', 01, 01, 0, InformacoesBancarias.Agencia);
          Gerador.wCampo(tcStr, 'AP35', 'Conta              ', 01, 01, 0, InformacoesBancarias.Conta);
          Gerador.wCampo(tcStr, 'AP36', 'TipoConta          ', 01, 15, 1, TipoContaToStr(InformacoesBancarias.TipoConta));

          Gerador.wGrupo('/InformacoesBancarias');
        end;
      end;

      if NotasFiscais.Count > 0 then
      begin
        Gerador.Prefixo := 'adic:';

        for J := 0 to NotasFiscais.Count -1 do
        begin
          Item := NotasFiscais[J];
          Gerador.wGrupo('NotasFiscais', 'AP38');
          Gerador.wCampo(tcStr, 'AP39', 'Numero                            ', 01, 01, 0, Item.Numero);
          Gerador.wCampo(tcStr, 'AP40', 'Serie                             ', 01, 01, 0, Item.Serie);
          Gerador.wCampo(tcDat, 'AP41', 'Data                              ', 01, 01, 1, Item.Data);
          Gerador.wCampo(tcDe2, 'AP42', 'ValorTotal                        ', 01, 01, 1, Item.ValorTotal);
          Gerador.wCampo(tcDe4, 'AP43', 'ValorDaMercadoriaPorUnidade       ', 01, 01, 1, Item.ValorDaMercadoriaPorUnidade);
          Gerador.wCampo(tcInt, 'AP44', 'CodigoNCMNaturezaCarga            ', 01, 04, 1, Item.CodigoNCMNaturezaCarga);
          Gerador.wCampo(tcStr, 'AP45', 'DescricaoDaMercadoria             ', 01, 01, 0, Item.DescricaoDaMercadoria);
          Gerador.Prefixo := 'obj:';
          Gerador.wCampo(tcStr, 'AP46', 'UnidadeDeMedidaDaMercadoria       ', 01, 01, 1, TpUnMedMercToStr(Item.UnidadeDeMedidaDaMercadoria));
          Gerador.wCampo(tcStr, 'AP47', 'TipoDeCalculo                     ', 01, 01, 1, TpVgTipoCalculoToStr(Item.TipoDeCalculo));
          Gerador.Prefixo := 'adic:';
          Gerador.wCampo(tcDe4, 'AP48', 'ValorDoFretePorUnidadeDeMercadoria', 01, 01, 1, Item.ValorDoFretePorUnidadeDeMercadoria);
          Gerador.wCampo(tcDe5, 'AP49', 'QuantidadeDaMercadoriaNoEmbarque  ', 01, 01, 1, Item.QuantidadeDaMercadoriaNoEmbarque);

          if Item.ToleranciaDePerdaDeMercadoria.Valor > 0 then
          begin
            Gerador.wGrupo('ToleranciaDePerdaDeMercadoria', 'AP50');
            Gerador.wCampo(tcStr, 'AP51', 'Tipo ', 01, 01, 1, TpProporcaoToStr(Item.ToleranciaDePerdaDeMercadoria.Tipo));
            Gerador.wCampo(tcDe2, 'AP52', 'Valor', 01, 01, 1, Item.ToleranciaDePerdaDeMercadoria.Valor);
            Gerador.wGrupo('/ToleranciaDePerdaDeMercadoria');
          end;

          Gerador.wGrupo('/NotasFiscais');
        end;
      end;
    end;

    Gerador.Prefixo := 'adic:';
    Gerador.wGrupo('/Viagem');
  end;

  Gerador.wGrupo('/Viagens');

  Gerador.Prefixo := aPrefixo;
end;

procedure TCIOTW_eFrete.GerarPagamentosAdicViagem;
var
  i: Integer;
  aPrefixo: string;
begin
  aPrefixo := Gerador.Prefixo;
  Gerador.Prefixo := 'adic:';

  //Pagamentos registrados.
  //- Pode existir mais de 1 pagamento com uma mesma categoria (exceto para Quitacao).
  //- A soma dos pagamentos c/ categoria Adiantamento, dever� ter o mesmo valor apontado na
  //     tag TotalAdiantamento da tag Viagem/Valores, e neste caso, a tag Documento do pagamento
  //     dever� conter o mesmo valor da tag DocumentoViagem da tag Viagem .
  //- Se a viagem possuir a tag TotalQuitacao maior que zero, dever� ter um pagamento correspondente,
  //     com Categoria Quitacao e com o Documento o mesmo valor apontado na tag DocumentoViagem .
  Gerador.wGrupo('Pagamentos', 'AP68');

  for i := 0 to CIOT.AdicionarViagem.Pagamentos.Count -1 do
  begin
    with CIOT.AdicionarViagem.Pagamentos.Items[i] do
    begin
      Gerador.wGrupo('Pagamento', 'AP68');
      Gerador.wCampo(tcStr, 'AP69', 'IdPagamentoCliente', 01, 01, 0, IdPagamentoCliente, 'Identificador do pagamento no sistema do Cliente.');
      Gerador.wCampo(tcDat, 'AP70', 'DataDeLiberacao   ', 01, 01, 1, DataDeLiberacao, 'Data em que o pagamento ser� liberado para saque.');
      Gerador.wCampo(tcDe2, 'AP71', 'Valor             ', 01, 01, 1, Valor, 'Valor do pagamento.');

      Gerador.Prefixo := 'obj:';
      Gerador.wCampo(tcStr, 'AP72', 'TipoPagamento', 01, 01, 1, TpPagamentoToStr(TipoPagamento), 'Tipo de pagamento que ser� usado pelo contratante. Restrito aos itens da enum: -TransferenciaBancaria -eFRETE');
      Gerador.wCampo(tcStr, 'AP73', 'Categoria    ', 01, 01, 1, TpCatPagToStr(Categoria), 'Categoria relacionada ao pagamento realizado. Restrita aos membros da ENUM: -Adiantamento, -Estadia, -Quitacao, -SemCategoria, -Frota ');

      Gerador.Prefixo := 'adic:';
      Gerador.wCampo(tcStr, 'AP74', 'Documento', 01, 01, 0, Documento, 'Documento relacionado a viagem.');

      // Preenchimento obrigat�rio para o TipoPagamento TransferenciaBancaria.
      // N�o deve ser preenchido para TipoPagamento eFRETE.
      if TipoPagamento  = TransferenciaBancaria then
      begin
        if (InformacoesBancarias.InstituicaoBancaria <> '') or
           (InformacoesBancarias.Agencia <> '') or (InformacoesBancarias.Conta <> '') then
        begin
          Gerador.Prefixo := 'obj:';
          Gerador.wGrupo('InformacoesBancarias', 'AP75');

          Gerador.wCampo(tcStr, 'AP76', 'InstituicaoBancaria', 01, 01, 0, InformacoesBancarias.InstituicaoBancaria, 'C�digo de compensa��o da institui��o banc�ria que ser� realizado o pagamento. ');
          Gerador.wCampo(tcStr, 'AP77', 'Agencia            ', 01, 01, 0, InformacoesBancarias.Agencia, 'Ag�ncia na qual o contratado possui conta com d�gito (se houver).');
          Gerador.wCampo(tcStr, 'AP78', 'Conta              ', 01, 01, 0, InformacoesBancarias.Conta, 'Conta do contratado com d�gito. ');
          Gerador.wCampo(tcStr, 'AP79', 'TipoConta          ', 01, 15, 1, TipoContaToStr(InformacoesBancarias.TipoConta));

          Gerador.wGrupo('/InformacoesBancarias');
        end;
      end;

      Gerador.Prefixo := 'adic:';
      Gerador.wCampo(tcStr, 'AP80', 'InformacaoAdicional', 01, 01, 0, InformacaoAdicional);

      if Categoria = tcpFrota then
        Gerador.wCampo(tcStr, 'AP81', 'CnpjFilialAbastecimento', 01, 01, 1, CnpjFilialAbastecimento);

      Gerador.wGrupo('/Pagamento');
    end;
  end;

  Gerador.wGrupo('/Pagamentos');
  Gerador.Prefixo := aPrefixo;
end;

procedure TCIOTW_eFrete.GerarPagamentosAdicPagamento;
var
  i: Integer;
  aPrefixo: string;
begin
  aPrefixo := Gerador.Prefixo;
  Gerador.Prefixo := 'adic:';

  //Pagamentos registrados.
  //- Pode existir mais de 1 pagamento com uma mesma categoria (exceto para Quitacao).
  //- A soma dos pagamentos c/ categoria Adiantamento, dever� ter o mesmo valor apontado na
  //     tag TotalAdiantamento da tag Viagem/Valores, e neste caso, a tag Documento do pagamento
  //     dever� conter o mesmo valor da tag DocumentoViagem da tag Viagem .
  //- Se a viagem possuir a tag TotalQuitacao maior que zero, dever� ter um pagamento correspondente,
  //     com Categoria Quitacao e com o Documento o mesmo valor apontado na tag DocumentoViagem .
  Gerador.wGrupo('Pagamentos', 'AP68');

  for i := 0 to CIOT.AdicionarPagamento.Pagamentos.Count -1 do
  begin
    with CIOT.AdicionarPagamento.Pagamentos.Items[i] do
    begin
      Gerador.wGrupo('Pagamento', 'AP68');
      Gerador.wCampo(tcStr, 'AP69', 'IdPagamentoCliente', 01, 01, 0, IdPagamentoCliente, 'Identificador do pagamento no sistema do Cliente.');
      Gerador.wCampo(tcDat, 'AP70', 'DataDeLiberacao   ', 01, 01, 1, DataDeLiberacao, 'Data em que o pagamento ser� liberado para saque.');
      Gerador.wCampo(tcDe2, 'AP71', 'Valor             ', 01, 01, 1, Valor, 'Valor do pagamento.');

      Gerador.Prefixo := 'obj:';
      Gerador.wCampo(tcStr, 'AP72', 'TipoPagamento', 01, 01, 1, TpPagamentoToStr(TipoPagamento), 'Tipo de pagamento que ser� usado pelo contratante. Restrito aos itens da enum: -TransferenciaBancaria -eFRETE');
      Gerador.wCampo(tcStr, 'AP73', 'Categoria    ', 01, 01, 1, TpCatPagToStr(Categoria), 'Categoria relacionada ao pagamento realizado. Restrita aos membros da ENUM: -Adiantamento, -Estadia, -Quitacao, -SemCategoria, -Frota ');

      Gerador.Prefixo := 'adic:';
      Gerador.wCampo(tcStr, 'AP74', 'Documento', 01, 01, 0, Documento, 'Documento relacionado a viagem.');

      // Preenchimento obrigat�rio para o TipoPagamento TransferenciaBancaria.
      // N�o deve ser preenchido para TipoPagamento eFRETE.
      if (InformacoesBancarias.InstituicaoBancaria <> '') or
         (InformacoesBancarias.Agencia <> '') or (InformacoesBancarias.Conta <> '') then
      begin
        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('InformacoesBancarias', 'AP75');

        Gerador.wCampo(tcStr, 'AP76', 'InstituicaoBancaria', 01, 01, 0, InformacoesBancarias.InstituicaoBancaria, 'C�digo de compensa��o da institui��o banc�ria que ser� realizado o pagamento. ');
        Gerador.wCampo(tcStr, 'AP77', 'Agencia            ', 01, 01, 0, InformacoesBancarias.Agencia, 'Ag�ncia na qual o contratado possui conta com d�gito (se houver).');
        Gerador.wCampo(tcStr, 'AP78', 'Conta              ', 01, 01, 0, InformacoesBancarias.Conta, 'Conta do contratado com d�gito. ');
        Gerador.wCampo(tcStr, 'AP79', 'TipoConta          ', 01, 15, 1, TipoContaToStr(InformacoesBancarias.TipoConta));

        Gerador.wGrupo('/InformacoesBancarias');
      end;

      Gerador.Prefixo := 'adic:';
      Gerador.wCampo(tcStr, 'AP80', 'InformacaoAdicional', 01, 01, 0, InformacaoAdicional);

      if Categoria = tcpFrota then
        Gerador.wCampo(tcStr, 'AP81', 'CnpjFilialAbastecimento', 01, 01, 1, CnpjFilialAbastecimento);

      Gerador.wGrupo('/Pagamento');
    end;
  end;

  Gerador.wGrupo('/Pagamentos');
  Gerador.Prefixo := aPrefixo;
end;

procedure TCIOTW_eFrete.GerarViagemEncerramento;
var
  i, j: Integer;
  aPrefixo: string;
  Item : TNotaFiscalCollectionItem;
begin
  if CIOT.EncerrarOperacao.Viagens.Count > 0 then
  begin
    aPrefixo := Gerador.Prefixo;
    Gerador.Prefixo := 'enc:';

    Gerador.wGrupo('Viagens', 'AP12');

    for I := 0 to CIOT.EncerrarOperacao.Viagens.Count -1 do
    begin
      Gerador.wGrupo('Viagem', 'AP12');

      with CIOT.EncerrarOperacao.Viagens.Items[I] do
      begin
        Gerador.wCampo(tcStr, 'AP13', 'DocumentoViagem       ', 01, 01, 0, DocumentoViagem);
        Gerador.wCampo(tcInt, 'AP14', 'CodigoMunicipioOrigem ', 01, 07, 1, CodigoMunicipioOrigem);
        Gerador.wCampo(tcInt, 'AP15', 'CodigoMunicipioDestino', 01, 07, 1, CodigoMunicipioDestino);
        Gerador.wCampo(tcStr, 'AP16', 'CepOrigem             ', 01, 01, 0, CepOrigem);
        Gerador.wCampo(tcStr, 'AP17', 'CepDestino            ', 01, 01, 0, CepDestino);

        Gerador.Prefixo := 'obj:';

        if Valores.TotalOperacao > 0 then
        begin
          Gerador.wGrupo('Valores', 'AP19');

          Gerador.wCampo(tcDe2, 'AP20', 'TotalOperacao              ', 01, 01, 1, Valores.TotalOperacao);
          Gerador.wCampo(tcDe2, 'AP21', 'TotalViagem                ', 01, 01, 1, Valores.TotalViagem);
          Gerador.wCampo(tcDe2, 'AP22', 'TotalDeAdiantamento        ', 01, 01, 1, Valores.TotalDeAdiantamento);
          Gerador.wCampo(tcDe2, 'AP23', 'TotalDeQuitacao            ', 01, 01, 1, Valores.TotalDeQuitacao);
          Gerador.wCampo(tcDe2, 'AP24', 'Combustivel                ', 01, 01, 1, Valores.Combustivel);
          Gerador.wCampo(tcDe2, 'AP25', 'Pedagio                    ', 01, 01, 1, Valores.Pedagio);
          Gerador.wCampo(tcDe2, 'AP26', 'OutrosCreditos             ', 01, 01, 1, Valores.OutrosCreditos);
          Gerador.wCampo(tcStr, 'AP27', 'JustificativaOutrosCreditos', 01, 01, 0, Valores.JustificativaOutrosCreditos);
          Gerador.wCampo(tcDe2, 'AP28', 'Seguro                     ', 01, 01, 1, Valores.Seguro);
          Gerador.wCampo(tcDe2, 'AP29', 'OutrosDebitos              ', 01, 01, 1, Valores.OutrosDebitos);
          Gerador.wCampo(tcStr, 'AP30', 'JustificativaOutrosDebitos ', 01, 01, 0, Valores.JustificativaOutrosDebitos);

          Gerador.wGrupo('/Valores');
        end;

        Gerador.wCampo(tcStr, 'AP31', 'TipoPagamento', 001, 020, 1, TpPagamentoToStr(TipoPagamento));

        if (InformacoesBancarias.InstituicaoBancaria <> '') or
           (InformacoesBancarias.Agencia <> '') or (InformacoesBancarias.Conta <> '') then
        begin
          Gerador.wGrupo('InformacoesBancarias', 'AP32');

          Gerador.wCampo(tcStr, 'AP33', 'InstituicaoBancaria', 01, 01, 0, InformacoesBancarias.InstituicaoBancaria);
          Gerador.wCampo(tcStr, 'AP34', 'Agencia            ', 01, 01, 0, InformacoesBancarias.Agencia);
          Gerador.wCampo(tcStr, 'AP35', 'Conta              ', 01, 01, 0, InformacoesBancarias.Conta);
          Gerador.wCampo(tcStr, 'AP36', 'TipoConta          ', 01, 15, 1, TipoContaToStr(InformacoesBancarias.TipoConta));

          Gerador.wGrupo('/InformacoesBancarias');
        end;

        if NotasFiscais.Count > 0 then
        begin
          Gerador.Prefixo := 'enc:';
          Gerador.wGrupo('NotasFiscais', 'AP37');

          for J := 0 to NotasFiscais.Count -1 do
          begin
            Item := NotasFiscais[J];

            Gerador.wGrupo('NotaFiscal', 'AP38');
            Gerador.wCampo(tcStr, 'AP39', 'Numero                             ', 01, 01, 0, Item.Numero);
            Gerador.wCampo(tcStr, 'AP40', 'Serie                              ', 01, 01, 0, Item.Serie);
            Gerador.wCampo(tcDat, 'AP41', 'Data                               ', 01, 01, 1, Item.Data);
            Gerador.wCampo(tcDe2, 'AP42', 'ValorTotal                         ', 01, 01, 1, Item.ValorTotal);
            Gerador.wCampo(tcDe4, 'AP43', 'ValorDaMercadoriaPorUnidade        ', 01, 01, 1, Item.ValorDaMercadoriaPorUnidade);
            Gerador.wCampo(tcInt, 'AP44', 'CodigoNCMNaturezaCarga             ', 01, 04, 1, Item.CodigoNCMNaturezaCarga);
            Gerador.wCampo(tcStr, 'AP45', 'DescricaoDaMercadoria              ', 01, 01, 0, Item.DescricaoDaMercadoria);
            Gerador.wCampo(tcStr, 'AP46', 'UnidadeDeMedidaDaMercadoria        ', 01, 01, 1, TpUnMedMercToStr(Item.UnidadeDeMedidaDaMercadoria));
            Gerador.wCampo(tcStr, 'AP47', 'TipoDeCalculo                      ', 01, 01, 1, TpVgTipoCalculoToStr(Item.TipoDeCalculo));
            Gerador.wCampo(tcDe4, 'AP48', 'ValorDoFretePorUnidadeDeMercadoria ', 01, 01, 1, Item.ValorDoFretePorUnidadeDeMercadoria);
            Gerador.wCampo(tcDe5, 'AP49', 'QuantidadeDaMercadoriaNoEmbarque   ', 01, 01, 1, Item.QuantidadeDaMercadoriaNoEmbarque);
            Gerador.wCampo(tcDe5, 'AP49', 'QuantidadeDaMercadoriaNoDesembarque', 01, 01, 1, Item.QuantidadeDaMercadoriaNoDesembarque);

            if Item.ToleranciaDePerdaDeMercadoria.Valor > 0 then
            begin
              Gerador.wGrupo('ToleranciaDePerdaDeMercadoria', 'AP50');
              Gerador.wCampo(tcStr, 'AP51', 'Tipo ', 01, 01, 1, TpProporcaoToStr(Item.ToleranciaDePerdaDeMercadoria.Tipo));
              Gerador.wCampo(tcDe2, 'AP52', 'Valor', 01, 01, 1, Item.ToleranciaDePerdaDeMercadoria.Valor);
              Gerador.wGrupo('/ToleranciaDePerdaDeMercadoria');
            end;

            Gerador.wGrupo('/NotaFiscal');
          end;
          Gerador.wGrupo('/NotasFiscais');
        end;
      end;

      Gerador.Prefixo := 'enc:';
      Gerador.wGrupo('/Viagem');
    end;

    Gerador.wGrupo('/Viagens');

    Gerador.Prefixo := aPrefixo;
  end;
end;

procedure TCIOTW_eFrete.GerarPagamentosEncerramento;
var
  i: Integer;
  aPrefixo: string;
begin
  if CIOT.EncerrarOperacao.Pagamentos.Count > 0 then
  begin
    aPrefixo := Gerador.Prefixo;
    Gerador.Prefixo := 'enc:';

    //Pagamentos registrados.
    //- Pode existir mais de 1 pagamento com uma mesma categoria (exceto para Quitacao).
    //- A soma dos pagamentos c/ categoria Adiantamento, dever� ter o mesmo valor apontado na
    //     tag TotalAdiantamento da tag Viagem/Valores, e neste caso, a tag Documento do pagamento
    //     dever� conter o mesmo valor da tag DocumentoViagem da tag Viagem .
    //- Se a viagem possuir a tag TotalQuitacao maior que zero, dever� ter um pagamento correspondente,
    //     com Categoria Quitacao e com o Documento o mesmo valor apontado na tag DocumentoViagem .
    Gerador.wGrupo('Pagamentos', 'AP68');

    for i := 0 to CIOT.EncerrarOperacao.Pagamentos.Count -1 do
    begin
      with CIOT.EncerrarOperacao.Pagamentos.Items[i] do
      begin
        Gerador.wGrupo('Pagamento', 'AP68');
        Gerador.wCampo(tcStr, 'AP69', 'IdPagamentoCliente', 01, 01, 0, IdPagamentoCliente, 'Identificador do pagamento no sistema do Cliente.');
        Gerador.wCampo(tcDat, 'AP70', 'DataDeLiberacao   ', 01, 01, 1, DataDeLiberacao, 'Data em que o pagamento ser� liberado para saque.');
        Gerador.wCampo(tcDe2, 'AP71', 'Valor             ', 01, 01, 1, Valor, 'Valor do pagamento.');
        Gerador.wCampo(tcStr, 'AP72', 'TipoPagamento     ', 01, 01, 1, TpPagamentoToStr(TipoPagamento), 'Tipo de pagamento que ser� usado pelo contratante. Restrito aos itens da enum: -TransferenciaBancaria -eFRETE');

        // Preenchimento obrigat�rio para o TipoPagamento TransferenciaBancaria.
        // N�o deve ser preenchido para TipoPagamento eFRETE.
        if (InformacoesBancarias.InstituicaoBancaria <> '') or
           (InformacoesBancarias.Agencia <> '') or (InformacoesBancarias.Conta <> '') then
        begin
          Gerador.wGrupo('InformacoesBancarias', 'AP75');
          Gerador.Prefixo := 'obj:';

          Gerador.wCampo(tcStr, 'AP76', 'InstituicaoBancaria', 01, 01, 0, InformacoesBancarias.InstituicaoBancaria, 'C�digo de compensa��o da institui��o banc�ria que ser� realizado o pagamento. ');
          Gerador.wCampo(tcStr, 'AP77', 'Agencia            ', 01, 01, 0, InformacoesBancarias.Agencia, 'Ag�ncia na qual o contratado possui conta com d�gito (se houver).');
          Gerador.wCampo(tcStr, 'AP78', 'Conta              ', 01, 01, 0, InformacoesBancarias.Conta, 'Conta do contratado com d�gito. ');
          Gerador.wCampo(tcStr, 'AP79', 'TipoConta          ', 01, 15, 1, TipoContaToStr(InformacoesBancarias.TipoConta));

          Gerador.wGrupo('/InformacoesBancarias');
        end;

        Gerador.Prefixo := 'enc:';
        Gerador.wCampo(tcStr, 'AP80', 'InformacaoAdicional', 01, 01, 0, InformacaoAdicional);

        Gerador.wGrupo('/Pagamento');
      end;
    end;

    Gerador.wGrupo('/Pagamentos');

    Gerador.Prefixo := aPrefixo;
  end;
end;

procedure TCIOTW_eFrete.GerarImpostosEncerramento;
begin
  with CIOT.EncerrarOperacao.Impostos do
  begin
    if (IRRF > 0) or (SestSenat > 0) or (INSS > 0) or (ISSQN >0) or
       (OutrosImpostos > 0) then
    begin
      Gerador.wGrupo('Impostos', 'AP61');
      Gerador.wCampo(tcDe2, 'AP62', 'IRRF                   ', 01, 01, 1, IRRF, 'Valor destinado ao IRRF');
      Gerador.wCampo(tcDe2, 'AP63', 'SestSenat              ', 01, 01, 1, SestSenat, 'Valor destinado ao SEST / SENAT');
      Gerador.wCampo(tcDe2, 'AP64', 'INSS                   ', 01, 01, 1, INSS, 'Valor destinado ao INSS.');
      Gerador.wCampo(tcDe2, 'AP65', 'ISSQN                  ', 01, 01, 1, ISSQN, 'Valor destinado ao ISSQN.');
      Gerador.wCampo(tcDe2, 'AP66', 'OutrosImpostos         ', 01, 01, 1, OutrosImpostos, 'Valor destinado a outros impostos n�o previstos.');
      Gerador.wCampo(tcStr, 'AP67', 'DescricaoOutrosImpostos', 01, 01, 0, DescricaoOutrosImpostos);
      Gerador.wGrupo('/Impostos');
    end;
  end;
end;

function TCIOTW_eFrete.GerarXml: Boolean;
var
  i: Integer;
  Item : TNotaFiscalCollectionItem;
begin
  Gerador.ListaDeAlertas.Clear;
  Gerador.ArquivoFormatoXML := '';

  // Carrega Layout que sera utilizado para gera o txt
  Gerador.LayoutArquivoTXT.Clear;
  Gerador.ArquivoFormatoTXT := '';

  Gerador.Prefixo := 'pef:';

  case CIOT.Integradora.Operacao of
    opLogin:
      begin
        Gerador.Prefixo := 'log:';
        Gerador.wGrupo('Login');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('LoginRequest');

        with CIOT.Integradora do
        begin
          Gerador.wCampo(tcStr, 'AP04', 'Integrador', 01, 01, 0, Integrador);
          Gerador.wCampo(tcInt, 'AP05', 'Versao    ', 01, 01, 1, 1);
          Gerador.wCampo(tcStr, 'AP04', 'Usuario   ', 01, 01, 0, Usuario);
          Gerador.wCampo(tcStr, 'AP04', 'Senha     ', 01, 01, 0, Senha);
        end;

        Gerador.wGrupo('/LoginRequest');

        Gerador.Prefixo := 'log:';
        Gerador.wGrupo('/Login');
      end;

    opLogout:
      begin
        Gerador.Prefixo := 'log:';
        Gerador.wGrupo('Logout');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('LogoutRequest');

        with CIOT.Integradora do
        begin
          Gerador.Prefixo := 'obj1:';
          Gerador.wCampo(tcStr, 'AP04', 'Token     ', 01, 01, 0, Token);
          Gerador.wCampo(tcStr, 'AP04', 'Integrador', 01, 01, 0, Integrador);
          Gerador.wCampo(tcInt, 'AP05', 'Versao    ', 01, 01, 1, 1);
        end;

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('/LogoutRequest');

        Gerador.Prefixo := 'log:';
        Gerador.wGrupo('/Logout');
      end;

    opGravarProprietario:
      begin
        Gerador.Prefixo := 'prop:';
        Gerador.wGrupo('Gravar');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('GravarRequest');

        GerarIdentificacao(3);
        GerarGravarProprietario;

        Gerador.wGrupo('/GravarRequest');

        Gerador.Prefixo := 'prop:';
        Gerador.wGrupo('/Gravar');
      end;

    opGravarVeiculo:
      begin
        Gerador.Prefixo := 'veic:';
        Gerador.wGrupo('Gravar');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('GravarRequest');

        GerarIdentificacao(1);

        GerarGravarVeiculo;

        Gerador.wGrupo('/GravarRequest');

        Gerador.Prefixo := 'veic:';
        Gerador.wGrupo('/Gravar');
      end;

    opGravarMotorista:
      begin
        Gerador.Prefixo := 'mot:';
        Gerador.wGrupo('Gravar');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('GravarRequest');

        GerarIdentificacao(2);
        GerarGravarMotorista;

        Gerador.wGrupo('/GravarRequest');

        Gerador.Prefixo := 'mot:';
        Gerador.wGrupo('/Gravar');
      end;

    opObterCodigoIOT:
      begin
        Gerador.wGrupo('ObterCodigoIdentificacaoOperacaoTransportePorIdOperacaoCliente');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('ObterCodigoIdentificacaoOperacaoTransportePorIdOperacaoClienteRequest');

        GerarIdentificacao(1);

        with CIOT.ObterCodigoOperacaoTransporte do
        begin
          Gerador.wCampo(tcStr, '', 'MatrizCNPJ       ', 14, 14, 0, MatrizCNPJ, '');
          Gerador.wCampo(tcStr, '', 'IdOperacaoCliente', 01, 30, 0, IdOperacaoCliente, '');
        end;

        Gerador.wGrupo('/ObterCodigoIdentificacaoOperacaoTransportePorIdOperacaoClienteRequest');

        Gerador.Prefixo := 'pef:';
        Gerador.wGrupo('/ObterCodigoIdentificacaoOperacaoTransportePorIdOperacaoCliente');
      end;

    opObterPdf:
      begin
        Gerador.wGrupo('ObterOperacaoTransportePdf');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('ObterOperacaoTransportePdfRequest');

        GerarIdentificacao(1);

        with CIOT.ObterOperacaoTransportePDF do
        begin
          Gerador.wCampo(tcStr, '', 'CodigoIdentificacaoOperacao', 01, 30, 0, CodigoIdentificacaoOperacao, '');
          Gerador.wCampo(tcStr, '', 'DocumentoViagem            ', 01, 30, 0, DocumentoViagem, '');
        end;
        Gerador.wGrupo('/ObterOperacaoTransportePdfRequest');

        Gerador.Prefixo := 'pef:';
        Gerador.wGrupo('/ObterOperacaoTransportePdf');
      end;

    opAdicionar:
      begin
        Gerador.wGrupo('AdicionarOperacaoTransporte', '');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('AdicionarOperacaoTransporteRequest', 'AP01');

        GerarIdentificacao(7);

        with CIOT.AdicionarOperacao do
        begin
          Gerador.wCampo(tcStr, 'AP01', 'TipoViagem            ', 01, 01, 1, TipoViagemCIOTToStr(TipoViagem));
          Gerador.wCampo(tcStr, 'AP02', 'TipoPagamento         ', 01, 20, 1, TpPagamentoToStr(TipoPagamento));
          Gerador.wCampo(tcStr, 'AP02', 'EmissaoGratuita       ', 01, 01, 1, LowerCase(BoolToStr(EmissaoGratuita, True)));
          Gerador.wCampo(tcStr, 'AP03', 'BloquearNaoEquiparado ', 01, 01, 1, LowerCase(BoolToStr(BloquearNaoEquiparado, True)));
          Gerador.wCampo(tcStr, 'AP04', 'MatrizCNPJ            ', 14, 14, 1, MatrizCNPJ);
          Gerador.wCampo(tcStr, 'AP05', 'FilialCNPJ            ', 14, 14, 0, FilialCNPJ);
          Gerador.wCampo(tcStr, 'AP06', 'IdOperacaoCliente     ', 01, 01, 0, IdOperacaoCliente, 'Id / Chave prim�ria da opera��o de transporte no sistema do Cliente.');

          if TipoViagem <> TAC_Agregado then
            Gerador.wCampo(tcDat, 'AP07', 'DataInicioViagem      ', 10, 10, 1, DataInicioViagem);

          Gerador.wCampo(tcDat, 'AP08', 'DataFimViagem         ', 10, 10, 1, DataFimViagem, 'Data prevista para o fim de viagem.');

          if TipoViagem <> TAC_Agregado then
          begin
            Gerador.wCampo(tcInt, 'AP09', 'CodigoNCMNaturezaCarga', 01, 04, 1, CodigoNCMNaturezaCarga);
            Gerador.wCampo(tcDe5, 'AP10', 'PesoCarga             ', 01, 01, 1, PesoCarga);
            Gerador.wCampo(tcStr, 'AP11', 'TipoEmbalagem         ', 01, 01, 1, TipoEmbalagemToStr(TipoEmbalagem));
          end;

          if TipoViagem = Padrao then
            GerarViagem;

          if TipoViagem <> Frota then
            GerarImpostos;

          if TipoViagem <> TAC_Agregado then
            GerarPagamentos;

          GerarContratado;
          GerarMotorista;

          if TipoViagem <> Frota then
            GerarDestinatario;

          GerarContratante;

          if TipoViagem <> Frota then
          begin
            GerarSubContratante;
            GerarConsignatario;
            GerarTomadorServico;
          end;

          GerarRemetente;
          GerarProprietarioCarga;
          GerarVeiculos('adic:');

          //Informar um CIOT (se existente) que esteja relacionado � opera��o de transporte.
          //Por exemplo: No caso da presen�a de um Subcontratante na opera��o de transporte informar
          //o CIOT onde o Subcontratante foi o Contratado.
          Gerador.wCampo(tcStr, 'AP248', 'CodigoIdentificacaoOperacaoPrincipal', 01, 01, 0, CodigoIdentificacaoOperacaoPrincipal);

          if ObservacoesAoTransportador.Count > 0 then
          begin
            Gerador.wGrupo('ObservacoesAoTransportador', 'AP249');

            for i := 0 to ObservacoesAoTransportador.Count -1 do
            begin
              Gerador.wCampo(tcStr, 'AP250', 'string', 01, 01, 1, ObservacoesAoTransportador[i].Mensagem);
            end;

            Gerador.wGrupo('/ObservacoesAoTransportador');
          end;

          if ObservacoesAoCredenciado.Count > 0 then
          begin
            Gerador.wGrupo('ObservacoesAoCredenciado', 'AP251');

            for i := 0 to ObservacoesAoCredenciado.Count -1 do
            begin
              Gerador.wCampo(tcStr, 'AP252', 'string', 01, 01, 1, ObservacoesAoCredenciado[i].Mensagem);
            end;

            Gerador.wGrupo('/ObservacoesAoCredenciado');
          end;

          if EntregaDocumentacao <> edNenhum then
            Gerador.wCampo(tcStr, 'AP253', 'EntregaDocumentacao', 01, 01, 1, EntregaDocumentacaoToStr(EntregaDocumentacao));

          Gerador.wCampo(tcInt, 'AP254', 'QuantidadeSaques        ', 01, 01, 1, QuantidadeSaques);
          Gerador.wCampo(tcInt, 'AP255', 'QuantidadeTransferencias', 01, 01, 1, QuantidadeTransferencias);
          Gerador.wCampo(tcDe2, 'AP256', 'ValorSaques             ', 01, 01, 1, ValorSaques);
          Gerador.wCampo(tcDe2, 'AP257', 'ValorTransferencias     ', 01, 01, 1, ValorTransferencias);

          if TipoViagem <> TAC_Agregado then
          begin
            Gerador.wCampo(tcStr, 'AP258', 'CodigoTipoCarga    ', 01, 01, 1, TipoCargaToStr(CodigoTipoCarga));
            Gerador.wCampo(tcStr, 'AP259', 'AltoDesempenho     ', 01, 01, 1, LowerCase(BoolToStr(AltoDesempenho, True)));
            Gerador.wCampo(tcStr, 'AP260', 'DestinacaoComercial', 01, 01, 1, LowerCase(BoolToStr(DestinacaoComercial, True)));
            Gerador.wCampo(tcStr, 'AP261', 'FreteRetorno       ', 01, 01, 1, LowerCase(BoolToStr(FreteRetorno, True)));

            if FreteRetorno then
            begin
              Gerador.wCampo(tcStr, 'AP262', 'CepRetorno      ', 01, 01, 0, CepRetorno);
              Gerador.wCampo(tcInt, 'AP263', 'DistanciaRetorno', 01, 01, 1, DistanciaRetorno);
            end;
          end;
        end;

        Gerador.wGrupo('/AdicionarOperacaoTransporteRequest');

        Gerador.Prefixo := 'pef:';
        Gerador.wGrupo('/AdicionarOperacaoTransporte');
      end;

    opRetificar:
      begin
        Gerador.wGrupo('RetificarOperacaoTransporte');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('RetificarOperacaoTransporteRequest');

        GerarIdentificacao(3);

        with CIOT.RetificarOperacao do
        begin
          Gerador.wCampo(tcStr, 'WP02', 'CodigoIdentificacaoOperacao', 01, 01, 0, CodigoIdentificacaoOperacao, '');
          //Gerador.wCampo(tcDat, 'WP07', 'DataInicioViagem           ', 01, 01, 1, DataInicioViagem);
          //Gerador.wCampo(tcDat, 'WP06', 'DataFimViagem              ', 01, 01, 1, DataFimViagem);
          //Gerador.wCampo(tcInt, 'WP05', 'CodigoNCMNaturezaCarga     ', 01, 04, 1, CodigoNCMNaturezaCarga);
          //Gerador.wCampo(tcDe5, 'WP09', 'PesoCarga                  ', 01, 01, 1, PesoCarga);
          //Gerador.wCampo(tcInt, 'WP04', 'CodigoMunicipioOrigem      ', 01, 07, 1, CodigoMunicipioOrigem);
          //Gerador.wCampo(tcInt, 'WP03', 'CodigoMunicipioDestino     ', 01, 07, 1, CodigoMunicipioDestino);

          //Adiciona Ve�culos
          GerarVeiculos('ret:');

          Gerador.wCampo(tcInt, 'AP209', 'QuantidadeSaques        ', 01, 01, 1, QuantidadeSaques);
          Gerador.wCampo(tcInt, 'AP210', 'QuantidadeTransferencias', 01, 01, 1, QuantidadeTransferencias);
         // Gerador.wCampo(tcDe2, 'AP211', 'ValorSaques             ', 01, 01, 1, ValorSaques);
         // Gerador.wCampo(tcDe2, 'AP212', 'ValorTransferencias     ', 01, 01, 1, ValorTransferencias);
         // Gerador.wCampo(tcInt, 'AP213', 'CodigoTipoCarga         ', 01, 01, 1, CodigoTipoCarga);
          //Gerador.wCampo(tcStr, 'AP209', 'CepOrigem               ', 01, 01, 0, CepOrigem);
          //Gerador.wCampo(tcStr, 'AP209', 'CepDestino              ', 01, 01, 0, CepDestino);
          //Gerador.wCampo(tcInt, 'AP213', 'DistanciaPercorrida     ', 01, 01, 1, DistanciaPercorrida);
        end;

        Gerador.wGrupo('/RetificarOperacaoTransporteRequest');

        Gerador.Prefixo := 'pef:';
        Gerador.wGrupo('/RetificarOperacaoTransporte');
      end;

    opCancelar:
      begin
        Gerador.wGrupo('CancelarOperacaoTransporte');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('CancelarOperacaoTransporteRequest');

        GerarIdentificacao(1);

        with CIOT.CancelarOperacao do
        begin
          Gerador.wCampo(tcStr, 'KP02', 'CodigoIdentificacaoOperacao', 01, 01, 0, CodigoIdentificacaoOperacao);
          Gerador.wCampo(tcStr, 'KP02', 'Motivo                     ', 01, 01, 0, Motivo);
        end;

        Gerador.wGrupo('/CancelarOperacaoTransporteRequest');

        Gerador.Prefixo := 'pef:';
        Gerador.wGrupo('/CancelarOperacaoTransporte');
      end;

    opAdicionarViagem:
      begin
        Gerador.wGrupo('AdicionarViagem');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('AdicionarViagemRequest');

        GerarIdentificacao(3);

        with CIOT.AdicionarViagem do
        begin
          Gerador.wCampo(tcStr, 'KP02', 'CodigoIdentificacaoOperacao', 01, 01, 0, CodigoIdentificacaoOperacao);

          GerarViagemAdicViagem;
          GerarPagamentosAdicViagem;

          Gerador.wCampo(tcStr, 'AP259', 'NaoAdicionarParcialmente', 01, 01, 1, LowerCase(BoolToStr(NaoAdicionarParcialmente, True)));
        end;

        Gerador.wGrupo('/AdicionarViagemRequest');

        Gerador.Prefixo := 'pef:';
        Gerador.wGrupo('/AdicionarViagem');
      end;

    opAdicionarPagamento:
      begin
        Gerador.wGrupo('AdicionarPagamento');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('AdicionarPagamentoRequest');

        GerarIdentificacao(3);

        with CIOT.AdicionarPagamento do
        begin
          Gerador.wCampo(tcStr, 'KP02', 'CodigoIdentificacaoOperacao', 01, 01, 0, CodigoIdentificacaoOperacao);

          GerarPagamentosAdicPagamento;
        end;

        Gerador.wGrupo('/AdicionarPagamentoRequest');

        Gerador.Prefixo := 'pef:';
        Gerador.wGrupo('/AdicionarPagamento');
      end;

    opCancelarPagamento:
      begin
        Gerador.wGrupo('CancelarPagamento');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('CancelarPagamentoRequest');

        GerarIdentificacao(2);

        with CIOT.CancelarPagamento do
        begin
          Gerador.wCampo(tcStr, 'KP02', 'CodigoIdentificacaoOperacao', 01, 01, 0, CodigoIdentificacaoOperacao);
          Gerador.wCampo(tcStr, 'AP69', 'IdPagamentoCliente         ', 01, 01, 0, IdPagamentoCliente, 'Identificador do pagamento no sistema do Cliente.');
          Gerador.wCampo(tcStr, 'KP02', 'Motivo                     ', 01, 01, 0, Motivo);
        end;

        Gerador.wGrupo('/CancelarPagamentoRequest');

        Gerador.Prefixo := 'pef:';
        Gerador.wGrupo('/CancelarPagamento');
      end;

    opEncerrar:
      begin
        Gerador.wGrupo('EncerrarOperacaoTransporte');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('EncerrarOperacaoTransporteRequest');

        GerarIdentificacao(2);

        with CIOT.EncerrarOperacao do
        begin
          Gerador.wCampo(tcStr, 'QP02', 'CodigoIdentificacaoOperacao', 01, 01, 0, CodigoIdentificacaoOperacao);
          Gerador.wCampo(tcDe5, 'QP03', 'PesoCarga                  ', 01, 01, 1, PesoCarga);

          GerarViagemEncerramento;
          GerarPagamentosEncerramento;
          GerarImpostosEncerramento;

          Gerador.wCampo(tcInt, 'AP254', 'QuantidadeSaques        ', 01, 01, 1, QuantidadeSaques);
          Gerador.wCampo(tcInt, 'AP255', 'QuantidadeTransferencias', 01, 01, 1, QuantidadeTransferencias);
          Gerador.wCampo(tcDe2, 'AP256', 'ValorSaques             ', 01, 01, 1, ValorSaques);
          Gerador.wCampo(tcDe2, 'AP257', 'ValorTransferencias     ', 01, 01, 1, ValorTransferencias);
        end;

        Gerador.wGrupo('/EncerrarOperacaoTransporteRequest');

        Gerador.Prefixo := 'pef:';
        Gerador.wGrupo('/EncerrarOperacaoTransporte');
      end;

    opConsultarTipoCarga:
      begin
        Gerador.wGrupo('ConsultarTipoCarga');

        Gerador.Prefixo := 'obj:';
        Gerador.wGrupo('ConsultarTipoCargaRequest');

        GerarIdentificacao(1);

        Gerador.wGrupo('/ConsultarTipoCargaRequest');

        Gerador.Prefixo := 'pef:';
        Gerador.wGrupo('/ConsultarTipoCarga');
      end;

    opAlterarDataLiberacaoPagamento:
      begin
        Gerador.wGrupo('AlterarDataLiberacaoPagamento');
        Gerador.Prefixo := 'obj:';

        Gerador.wGrupo('EditarPagamentoRequest');

        GerarIdentificacao(1);

        with CIOT.AlterarDataLiberacaoPagamento do
        begin
          Gerador.wCampo(tcStr, 'KP02', 'CodigoIdentificacaoOperacao', 01, 01, 0, CodigoIdentificacaoOperacao);
          Gerador.wCampo(tcStr, 'AP69', 'IdPagamentoCliente         ', 01, 01, 0, IdPagamentoCliente, 'Identificador do pagamento no sistema do Cliente.');
          Gerador.wCampo(tcDat, 'KP02', 'DataLiberacao              ', 01, 01, 0, DataDeLiberacao);
          Gerador.wCampo(tcStr, 'KP02', 'Motivo                     ', 01, 01, 0, Motivo);
        end;

        Gerador.wGrupo('/EditarPagamentoRequest');

        Gerador.Prefixo := 'pef:';
        Gerador.wGrupo('/AlterarDataLiberacaoPagamento');
      end;

    opRegistrarQtdeMercadoriaDesembarque:
      begin
        Gerador.wGrupo('RegistrarQuantidadeDaMercadoriaNoDesembarque');
        Gerador.Prefixo := 'obj:';

        Gerador.wGrupo('RegistrarQuantidadeDaMercadoriaNoDesembarqueRequest');

        GerarIdentificacao(1);

        with CIOT.RegistrarQuantidadeDaMercadoriaNoDesembarque do
        begin
          Gerador.wCampo(tcStr, 'KP02', 'CodigoIdentificacaoOperacao', 01, 01, 0, CodigoIdentificacaoOperacao);

          if NotasFiscais.Count > 0 then
          begin
            Gerador.Prefixo := 'enc:';
            Gerador.wGrupo('NotasFiscais', 'AP37');

            for i := 0 to NotasFiscais.Count -1 do
            begin
              Item := NotasFiscais[i];

              Gerador.wGrupo('NotaFiscal', 'AP38');
              Gerador.wCampo(tcStr, 'AP39', 'Numero                             ', 01, 01, 0, Item.Numero);
              Gerador.wCampo(tcStr, 'AP40', 'Serie                              ', 01, 01, 0, Item.Serie);
              Gerador.wCampo(tcDe5, 'AP49', 'QuantidadeDaMercadoriaNoDesembarque', 01, 01, 1, Item.QuantidadeDaMercadoriaNoDesembarque);

              Gerador.wGrupo('/NotaFiscal');
            end;
            Gerador.wGrupo('/NotasFiscais');
          end;
        end;

        Gerador.wGrupo('/RegistrarQuantidadeDaMercadoriaNoDesembarqueRequest');

        Gerador.Prefixo := 'pef:';
        Gerador.wGrupo('/RegistrarQuantidadeDaMercadoriaNoDesembarque');
      end;

    opRegistrarPagamentoQuitacao:
      begin
        Gerador.wGrupo('RegistrarPagamentoQuitacao');
        Gerador.Prefixo := 'obj:';

        Gerador.wGrupo('RegistrarPagamentoQuitacaoRequest');

        GerarIdentificacao(1);

        with CIOT.RegistrarPagamentoQuitacao do
        begin
          Gerador.wCampo(tcStr, 'KP02', 'TokenCompra', 01, 06, 1, TokenCompra);

          if NotasFiscais.Count > 0 then
          begin
            Gerador.Prefixo := 'enc:';
            Gerador.wGrupo('NotasFiscais', 'AP37');

            for i := 0 to NotasFiscais.Count -1 do
            begin
              Item := NotasFiscais[i];

              Gerador.wGrupo('NotaFiscal', 'AP38');
              Gerador.wCampo(tcStr, 'AP39', 'Numero                             ', 01, 01, 0, Item.Numero);
              Gerador.wCampo(tcStr, 'AP40', 'Serie                              ', 01, 01, 0, Item.Serie);
              Gerador.wCampo(tcDe5, 'AP49', 'QuantidadeDaMercadoriaNoDesembarque', 01, 01, 1, Item.QuantidadeDaMercadoriaNoDesembarque);

              Gerador.wGrupo('/NotaFiscal');
            end;
            Gerador.wGrupo('/NotasFiscais');
          end;
        end;

        Gerador.wGrupo('/RegistrarPagamentoQuitacaoRequest');

        Gerador.Prefixo := 'pef:';
        Gerador.wGrupo('/RegistrarPagamentoQuitacao');
      end;

    // Implementa��o futura se houver necessidade.

    // manual vers�o 4.4
    // Incluir: Abonar Quebra - p�gina 33
    // Incluir: Obter Transa��es - p�gina 39
    // Incluir: Obter Vinculo para Transporte - p�gina 41
    // Incluir: Consultar Download Documento - p�gina 42
    // Incluir: Download Documento - p�gina 43
    // Incluir: Alterar Entrega Documentacao - p�gina 46
    // Incluir: Registrar pagamento - p�gina 47
    // Incluir: ObterFaturasPorIntervalodeDatas - p�gina 49
    // Incluir: ObterFaturasCredenciadoPorIntervalodeDatas - p�gina 51

    // manual vers�o 7.1
    // Incluir: ConsultarSituacaoTransportador - p�gina 53
  end;

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.
