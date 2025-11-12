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

unit pcnCIOTW_Pamcard;

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
  Variants,
  Math,
  synacode,
  ACBrConsts,
  pcnCIOTW, 
  pcnCIOTR,
  pcnConversao,
  pcnGerador, 
  pcnLeitor,
  pcnCIOT, 
  ACBrCIOTConversao,
  ACBrUtil.Base,
  ACBrUtil.Strings;

type
  { TCIOTW_Pamcard }

  TCIOTW_Pamcard = class(TCIOTWClass)
  private
    FIndiceFavorecido: Integer;
    FIndicePessoaFiscal: Integer;
    FVersaoDF: TVersaoCIOT;
  protected
    procedure AddFieldNoXml( const Tipo: TpcnTipoCampo; ID, TAG: string; const min, max, ocorrencias: smallint; const valor: variant; const Descricao: string = ''; ParseTextoXML: Boolean = True; Atributo: String = '' );

    procedure GerarAlterarContratoFrete;
    procedure GerarAlterarStatusParcela;
    procedure GerarAlterarStatusPedagio;
    procedure GerarAlterarValoresViagem;
    procedure GerarAlterarValoresContratoFrete;
    procedure GerarCancelaViagem;//ok
    procedure GerarConsultarTAG(Favorecido : TPessoa);
    procedure GerarConsultarRNTRC(Favorecido : TPessoa);
    procedure GerarConsultarFrota(Favorecido : TPessoa);
    procedure GerarConsultarConta(Favorecido : TPessoa);
    procedure GerarConsultarCartao;
    procedure GerarConsultarContratoFrete;//ok
    procedure GerarConsultarFavorecido(Favorecido : TPessoa);
    procedure GerarConsultarViagem;
    procedure GerarConsultaStatusParcela;
    procedure GerarEncerrarContratoFrete;//ok
    procedure GerarFavorecido;
    procedure GerarIncluirCartaoPortadorFrete;//ok
    procedure GerarConta(Favorecido : TPessoa);
    procedure GerarPagamentoParcela;//ok
    procedure GerarPagamentoPedagio;//ok
    procedure GerarIncluirRota; //ok
    procedure GerarRoteirizar; //ok

    procedure FavorecidoContratoFrete( TipoFavorecido: Integer; Pessoa: TPessoa );//ok
    procedure VeiculosContratoFrete;//ok
    procedure DocumentosContratoFrete;//ok
    procedure RotaOrigemDestinoPontosContratoFrete;//ok
    procedure PedagioContratoFrete;//ok
    procedure PostosContratoFrete;//ok
    procedure FreteContratoFrete;//ok
    procedure ParcelasContratoFrete;//ok
    procedure QuitacaoContratoFrete;//ok
    procedure GerarInserirContratoFrete;//ok
  public
    constructor Create(ACIOTW: TCIOTW); override;

    property VersaoDF: TVersaoCIOT   read FVersaoDF write FVersaoDF;

    function GerarXml: Boolean; override;
  end;

implementation

procedure TCIOTW_Pamcard.AddFieldNoXml(const Tipo: TpcnTipoCampo; ID, TAG: string; const min, max, ocorrencias: smallint; const valor: variant; const Descricao: string; ParseTextoXML: Boolean; Atributo: String);

  function IsEmptyDate(wAno, wMes, wDia: Word): Boolean;
  begin
    Result := ((wAno = 1899) and (wMes = 12) and (wDia = 30));
  end;

var
  valorDbl : Double;
  wAno, wMes, wDia : Word;
  ConteudoProcessado : String;
  EstaVazio : Boolean;
begin
  case Tipo of
    tcInt, tcInt64 : begin
      // Tipo Inteiro
      try
        if tipo = tcInt then
          ConteudoProcessado := IntToStr( StrToInt( VarToStr( valor ) ) )
        else
          ConteudoProcessado := IntToStr( StrToInt64( VarToStr( valor ) ) );
      except
        ConteudoProcessado := '0';
      end;

      EstaVazio := ( ConteudoProcessado = '0' ) and ( ocorrencias = 0 );
    end;

    tcDe2, tcDe3, tcDe4, tcDe5, tcDe6, tcDe7, tcDe8, tcDe10 : begin
      try
        valorDbl := valor; // Converte Variant para Double
      except
        valorDbl := 0;
      end;

      EstaVazio := ( valorDbl = 0 ) and ( ocorrencias = 0 );
    end;

    tcDat, tcDatCFe, tcDatVcto: begin
      DecodeDate(VarToDateTime(valor), wAno, wMes, wDia);
      EstaVazio := IsEmptyDate(wAno, wMes, wDia);
    end;
  else
    EstaVazio := VarToStrDef( valor, '' ) = '';
  end;

  if( ( ocorrencias > 0 ) or
      ( not EstaVazio ) )then
  begin
    Gerador.wGrupo( 'fields' );
    Gerador.wCampo( tcStr, ID, 'key', 01, 99, ocorrencias, TAG, Descricao, ParseTextoXML, Atributo );
    Gerador.wCampo( Tipo, ID, 'value', min, max, ocorrencias, valor, Trim( TAG + ' ' + Descricao ), ParseTextoXML, Atributo );
    Gerador.wGrupo( '/fields' );
  end;
end;

constructor TCIOTW_Pamcard.Create(ACIOTW: TCIOTW);
begin
  inherited Create(ACIOTW);
end;

function TCIOTW_Pamcard.GerarXml: Boolean;
//var
//  Prefixo, NameSpaceServico, NameSpaceBase: string;
//  Ok: Boolean;
//  versao: Integer;
begin
  Gerador.ListaDeAlertas.Clear;
  Gerador.ArquivoFormatoXML := '';
  // Carrega Layout que sera utilizado para gera o txt
  Gerador.LayoutArquivoTXT.Clear;
  Gerador.ArquivoFormatoTXT := '';
  //versao := 1;
//  VersaoDF := DblToVersaoCIOT(Ok, CIOT.OperacaoTransporte.Versao);
//  versao := VersaoCIOTToInt(VersaoDF);

  Gerador.wGrupo( 'arg0' );

  case CIOT.Integradora.Operacao of
    opIncluirRota: GerarIncluirRota;
    opRoteirizar: GerarRoteirizar;
    opIncluirCartaoPortador : GerarIncluirCartaoPortadorFrete;
    opAdicionar: GerarInserirContratoFrete;
    opObterCodigoIOT: GerarConsultarContratoFrete;
    opRetificar:;
    opCancelar: GerarCancelaViagem;
    opAdicionarViagem:;
    opAdicionarPagamento: GerarPagamentoParcela;
    opPagamentoPedagio: GerarPagamentoPedagio;
    opCancelarPagamento:;
    opEncerrar: GerarEncerrarContratoFrete;
  end;

  Gerador.wGrupo( '/arg0' );

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

procedure TCIOTW_Pamcard.FavorecidoContratoFrete( TipoFavorecido: Integer; Pessoa: TPessoa );
var
  f: string;
begin
  if( OnlyNumber( Pessoa.CpfOuCnpj ) = '' )then
    Exit;

  Inc( FIndiceFavorecido );

  f := IntToStr( FIndiceFavorecido );

  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.tipo', 01, 01, 1, TipoFavorecido ); //1-Contratado, 2-Subcontratante, 3-Motorista

  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.documento.qtde', 01, 01, 1, IfThen( Length( OnlyNumber( Pessoa.CpfOuCnpj ) ) = 11, 4, 2 ) );

  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.documento1.tipo', 01, 01, 1, IfThen( Length( OnlyNumber( Pessoa.CpfOuCnpj ) ) = 11, 2, 1 ) ); //1-CNPJ, 2-CPF
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.documento1.numero', 01, 30, 1, OnlyNumber( Pessoa.CpfOuCnpj ) );
  AddFieldNoXml( tcDatVcto, '', 'viagem.favorecido'+f+'.documento1.emissao.data', 01, 10, 0, 0 );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.documento1.emissor.id', 01, 02, 0, 0 );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.documento1.uf', 01, 02, 0, '' );

  //RNTRC
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.documento2.tipo', 01, 01, 0, IfThen( Length( OnlyNumber( Pessoa.CpfOuCnpj ) ) = 11, 5, 6 ) ); //6-RNTRC-CNPJ, 5-RNTRC-CPF
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.documento2.numero', 01, 30, 0, OnlyNumber( Pessoa.RNTRC ) );
  AddFieldNoXml( tcDatVcto, '', 'viagem.favorecido'+f+'.documento2.emissao.data', 01, 10, 0, 0 );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.documento2.emissor.id', 01, 02, 0, 0 );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.documento2.uf', 01, 02, 0, '' );

  if( Length( OnlyNumber( Pessoa.CpfOuCnpj ) ) = 11 )then
  begin
    //RG
    AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.documento3.tipo', 01, 01, 0, 3 );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.documento3.numero', 01, 30, 0, OnlyNumber( Pessoa.Rg ) );
    AddFieldNoXml( tcDatVcto, '', 'viagem.favorecido'+f+'.documento3.emissao.data', 01, 10, 0, 0 );
    AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.documento3.emissor.id', 01, 02, 0, 0 );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.documento3.uf', 01, 02, 0, Pessoa.RgUf );

    //PIS
    AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.documento4.tipo', 01, 01, 0, 7 );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.documento4.numero', 01, 30, 0, OnlyNumber( Pessoa.PISPASEP ) );
    AddFieldNoXml( tcDatVcto, '', 'viagem.favorecido'+f+'.documento4.emissao.data', 01, 10, 0, 0 );
    AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.documento4.emissor.id', 01, 02, 0, 0 );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.documento4.uf', 01, 02, 0, '' );
  end;

  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.nome', 01, 40, 1, Pessoa.NomeOuRazaoSocial );
  AddFieldNoXml( tcDatVcto, '', 'viagem.favorecido'+f+'.data.nascimento', 01, 10, 0, Pessoa.DataNascimento );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.endereco.logradouro', 01, 40, 1, Pessoa.Endereco.Rua );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.endereco.numero', 01, 05, 1, Pessoa.Endereco.Numero );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.endereco.bairro', 01, 30, 1, Pessoa.Endereco.Bairro );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.endereco.complemento', 01, 15, 1, Pessoa.Endereco.Complemento );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.endereco.cep', 01, 08, 1, OnlyNumber( Pessoa.Endereco.CEP ) );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.endereco.cidade.ibge', 01, 07, 0, Pessoa.Endereco.CodigoMunicipio );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.endereco.pais', 01, 30, 0, Pessoa.Endereco.xPais );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.endereco.uf', 01, 02, 0, Pessoa.Endereco.Uf );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.endereco.cidade', 01, 30, 0, Pessoa.Endereco.xMunicipio );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.endereco.propriedade.tipo.id', 01, 02, 0, Pessoa.Endereco.PropriedadeTipoId );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.endereco.reside.desde', 01, 07, 0, Pessoa.Endereco.ResideDesde ); // MM/YYYY
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.telefone.ddd', 03, 03, 1, Pessoa.Telefones.Fixo.DDD );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.telefone.numero', 08, 08, 1, Pessoa.Telefones.Fixo.Numero );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.celular.operadora.id', 01, 02, 0, Pessoa.Telefones.Celular.OperadoraId );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.celular.ddd', 03, 03, 0, Pessoa.Telefones.Celular.DDD );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.celular.numero', 09, 09, 0, Pessoa.Telefones.Celular.Numero );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.email', 01, 40, 0, Pessoa.EMail );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.sexo', 01, 01, 0, Pessoa.Sexo );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.nacionalidade.id', 01, 01, 0, Pessoa.NacionalidadeId );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.naturalidade.ibge', 01, 09, 0, Pessoa.NaturalidadeIbge );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.meio.pagamento', 01, 01, 0, Pessoa.MeioPagamentoId );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.consumo.responsavel.cpf', 01, 11, 0, OnlyNumber( Pessoa.ConsumoResponsavelCpf ) );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.consumo.responsavel.nome', 01, 50, 0, Pessoa.ConsumoResponsavelNome );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.conta.banco', 01, 04, 0, Pessoa.InformacoesBancarias.InstituicaoBancaria );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.conta.agencia', 01, 10, 0, Pessoa.InformacoesBancarias.Agencia );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.conta.agencia.digito', 01, 01, 0, Pessoa.InformacoesBancarias.DigitoAgencia );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.conta.numero', 01, 20, 0, Pessoa.InformacoesBancarias.Conta );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.conta.tipo', 01, 02, 0, TipoContaToIndex( Pessoa.InformacoesBancarias.TipoConta ) );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.cartao.numero', 01, 16, 0, Pessoa.InformacoesBancarias.Cartao.Numero );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.empresa.nome', 01, 50, 0, Pessoa.InformacoesBancarias.Cartao.EmpresaNome );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.empresa.cnpj', 01, 14, 0, Pessoa.InformacoesBancarias.Cartao.EmpresaCNPJ );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.empresa.rntrc', 01, 08, 0, OnlyNumber( Pessoa.InformacoesBancarias.Cartao.EmpresaRNTRC ) );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.escolaridade', 01, 02, 0, Pessoa.Escolaridade );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.qualificacao', 01, 02, 0, Pessoa.Qualificacao );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.estado.civil', 01, 02, 0, Pessoa.EstadoCivil );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido'+f+'.nome.mae', 01, 60, 0, Pessoa.NomeMae );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido'+f+'.numDependentes', 01, 02, 0, Pessoa.NumDependentes );
end;

procedure TCIOTW_Pamcard.VeiculosContratoFrete;
var
  i : Integer;
begin
  with CIOT.AdicionarOperacao do
  begin
    AddFieldNoXml( tcStr, '', 'viagem.veiculo.categoria', 01, 03, 1, VeiculoCategoria );
    AddFieldNoXml( tcStr, '', 'viagem.veiculo.categoria.eixo.suspenso', 01, 02, 0, VeiculoCategoriaEixoSuspenso );
    AddFieldNoXml( tcStr, '', 'viagem.veiculo.altodesempenho.indicador', 01, 01, 1, IfThen( AltoDesempenho, 'S','N' ) );
    AddFieldNoXml( tcInt, '', 'viagem.veiculo.qtde', 01, 01, 1, Veiculos.Count );

    for i := 0 to Veiculos.Count - 1 do
    begin
      AddFieldNoXml( tcStr, '', Format( 'viagem.veiculo%d.placa', [i + 1] ), 01, 07, 1, OnlyAlphaNum( Veiculos.Items[i].Placa ) );
      AddFieldNoXml( tcStr, '', Format( 'viagem.veiculo%d.rntrc', [i + 1] ), 01, 08, 0, OnlyNumber( Veiculos.Items[i].RNTRC ) );
    end;
  end;
end;

procedure TCIOTW_Pamcard.DocumentosContratoFrete;

  procedure PessoaFiscal( id, Tipo: Integer; Pessoa: TPessoa );
  var
    p : Integer;
  begin
    if( OnlyNumber( Pessoa.CpfOuCnpj ) = '' )then
      Exit;

    Inc( FIndicePessoaFiscal );
    p := FIndicePessoaFiscal;

    AddFieldNoXml( tcInt, '', Format('viagem.documento%d.pessoafiscal%d.tipo', [id+1, p] ), 01, 01, 1, Tipo ); //1-Remetente, 2-Destinatario, 3-Consignatario
    AddFieldNoXml( tcInt, '', Format('viagem.documento%d.pessoafiscal%d.codigo', [id+1, p] ), 01, 10, 0, Pessoa.CodigoNaIntegradora );

    if( Pessoa.CodigoNaIntegradora = 0 )then
    begin
      AddFieldNoXml( tcInt, '', Format('viagem.documento%d.pessoafiscal%d.documento.tipo', [id+1, p] ), 01, 01, 1, IfThen( Length( OnlyNumber( Pessoa.CpfOuCnpj ) ) = 11, 2, 1 ) ); //1-CNPJ 2-CPF
      AddFieldNoXml( tcStr, '', Format('viagem.documento%d.pessoafiscal%d.documento.numero', [id+1, p] ), 01, 20, 1, OnlyNumber( Pessoa.CpfOuCnpj ) );
      AddFieldNoXml( tcStr, '', Format('viagem.documento%d.pessoafiscal%d.nome', [id+1, p] ), 01, 40, 1, Pessoa.NomeOuRazaoSocial );
      AddFieldNoXml( tcStr, '', Format('viagem.documento%d.pessoafiscal%d.endereco.logradouro', [id+1, p]), 01, 40, 1, Pessoa.Endereco.Rua );
      AddFieldNoXml( tcStr, '', Format('viagem.documento%d.pessoafiscal%d.endereco.numero', [id+1, p] ), 01, 05, 1, Pessoa.Endereco.Numero );
      AddFieldNoXml( tcStr, '', Format('viagem.documento%d.pessoafiscal%d.endereco.complemento', [id+1, p] ), 01, 15, 0, Pessoa.Endereco.Complemento );
      AddFieldNoXml( tcStr, '', Format('viagem.documento%d.pessoafiscal%d.endereco.bairro', [id+1, p] ), 01, 30, 1, Pessoa.Endereco.Bairro );
      AddFieldNoXml( tcInt, '', Format('viagem.documento%d.pessoafiscal%d.endereco.cidade.ibge', [id+1, p] ), 01, 07, 0, Pessoa.Endereco.CodigoMunicipio );
      AddFieldNoXml( tcStr, '', Format('viagem.documento%d.pessoafiscal%d.endereco.cep', [id+1, p] ), 01, 08, 0, OnlyNumber( Pessoa.Endereco.CEP ) );
    end;
  end;

var
  i : Integer;
  Item: TNotaFiscalCollectionItem;
  PessoaFiscalQtd : Integer;
begin
  with CIOT.AdicionarOperacao do
  begin
    if( Viagens.Count = 0 )then
      Exit;

    AddFieldNoXml( tcInt, '', 'viagem.documento.qtde', 01, 10, 1, Viagens[0].NotasFiscais.Count );

    for i := 0 to Viagens[0].NotasFiscais.Count -1 do
    begin
      Item := Viagens[0].NotasFiscais[i];

      FIndicePessoaFiscal := 0;
      PessoaFiscalQtd := 0;

      if( OnlyNumber( Item.Remetente.CpfOuCnpj ) <> '' )then
        Inc( PessoaFiscalQtd );

      if( OnlyNumber( Item.Destinatario.CpfOuCnpj ) <> '' )then
        Inc( PessoaFiscalQtd );

      if( OnlyNumber( Item.Consignatario.CpfOuCnpj ) <> '' )then
        Inc( PessoaFiscalQtd );

      AddFieldNoXml( tcInt, '', Format( 'viagem.documento%d.tipo', [i+1] ), 01, 02, 1, TipoDocumentoPamcardToStr( Item.TipoDocumentoPamcard ) );
      AddFieldNoXml( tcStr, '', Format( 'viagem.documento%d.numero', [i+1] ), 01, 30, 01, Item.Numero );
      AddFieldNoXml( tcStr, '', Format( 'viagem.documento%d.serie', [i+1] ), 01, 05, 0, Item.Serie );
      AddFieldNoXml( tcDe2, '', Format( 'viagem.documento%d.quantidade', [i+1] ), 01, 09, 0, Item.QuantidadeDaMercadoriaNoEmbarque );
      AddFieldNoXml( tcStr, '', Format( 'viagem.documento%d.especie', [i+1] ), 01, 15, 0, Item.Especie );
      AddFieldNoXml( tcDe3, '', Format( 'viagem.documento%d.cubagem', [i+1] ), 01, 07, 0, Item.Cubagem );
      AddFieldNoXml( tcInt, '', Format( 'viagem.documento%d.natureza', [i+1] ), 04, 04, 0, Item.CodigoNCMNaturezaCarga );
      AddFieldNoXml( tcDe2, '', Format( 'viagem.documento%d.peso', [i+1] ), 01, 07, 0, Item.Peso );
      AddFieldNoXml( tcDe2, '', Format( 'viagem.documento%d.mercadoria.valor', [i+1] ), 01, 19, 0, Item.ValorTotal );
      AddFieldNoXml( tcStr, '', Format( 'viagem.documento%d.chaveacesso', [i+1] ), 01, 46, 0, Item.ChaveAcesso );
      AddFieldNoXml( tcInt, '', Format( 'viagem.documento%d.pessoafiscal.qtde', [i+1] ), 01, 02, 1, PessoaFiscalQtd );

      PessoaFiscal( i, 1, Item.Remetente );
      PessoaFiscal( i, 2, Item.Destinatario );
      PessoaFiscal( i, 3, Item.Consignatario );
    end;

    //Implementar lista futuramente se necessario
    {AddFieldNoXml( tcStr, '', 'viagem.documento.complementar.qtde', 01, 02, 0, 0 );

    for i := 0 to Qtd do
    begin
      AddFieldNoXml( tcStr, '', Format('viagem.documento.complementar%d.tipo', [i+1] ), 01, 02, 0, 0 );
    end;}
  end;
end;

procedure TCIOTW_Pamcard.RotaOrigemDestinoPontosContratoFrete;
var
  i: Integer;
begin
  with CIOT.AdicionarOperacao do
  begin
    AddFieldNoXml( tcInt, '', 'viagem.rota.id', 01, 10, 0, Rota.Id );
    AddFieldNoXml( tcStr, '', 'viagem.rota.nome', 01, 50, 0, Rota.Nome );

    AddFieldNoXml( tcInt, '', 'viagem.origem.cidade.ibge', 01, 07, 0, Rota.OrigemCidadeIbge );
    AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.latitude', 01, 10, 0, Rota.OrigemCidadeLatitude );
    AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.longitude', 01, 10, 0, Rota.OrigemCidadeLongitude );
    AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.cep', 01, 08, 0, OnlyNumber( Rota.OrigemCidadeCep ) );
    AddFieldNoXml( tcStr, '', 'viagem.origem.eixo.indicador', 01, 01, 1, IfThen( Rota.OrigemEixoSuspenso, 'S', 'N' ) );

    AddFieldNoXml( tcInt, '', 'viagem.destino.cidade.ibge', 01, 07, 0, Rota.DestinoCidadeIbge );
    AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.latitude', 01, 10, 0, Rota.DestinoCidadeLatitude );
    AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.longitude', 01, 10, 0, Rota.DestinoCidadeLongitude );
    AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.cep', 01, 08, 0, OnlyNumber( Rota.DestinoCidadeCep ) );
    AddFieldNoXml( tcStr, '', 'viagem.destino.eixo.indicador', 01, 01, 1, IfThen( Rota.DestinoEixoSuspenso, 'S', 'N' ) );

    AddFieldNoXml( tcInt, '', 'viagem.ponto.qtde', 01, 10, 0, Rota.Pontos.Count );

    for i := 0 to Rota.Pontos.Count - 1 do
    begin
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.pais.nome', [i+1] ), 01, 50, 0, Rota.Pontos.Items[i].PaisNome );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.estado.nome', [i+1] ), 01, 50, 0, Rota.Pontos.Items[i].EstadoNome );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.cidade.nome', [i+1] ), 01, 50, 0, Rota.Pontos.Items[i].CidadeNome );
      AddFieldNoXml( tcInt, '', Format( 'viagem.ponto%d.cidade.ibge', [i+1] ), 01, 07, 0, Rota.Pontos.Items[i].CidadeIbge );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.cidade.cep', [i+1] ), 01, 08, 0, OnlyNumber( Rota.Pontos.Items[i].CidadeCep ) );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.cidade.latitude', [i+1] ), 01, 10, 0, Rota.Pontos.Items[i].CidadeLatitude );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.cidade.longitude', [i+1] ), 01, 10, 0, Rota.Pontos.Items[i].CidadeLongitude );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.eixo.indicador', [i+1] ), 01, 01, 1, IfThen( Rota.Pontos.Items[i].EixoSuspenso, 'S', 'N' ) );
    end;

    AddFieldNoXml( tcStr, '', 'viagem.obter.postos', 01, 01, 0, IfThen( Rota.ObterPostos, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.obter.uf', 01, 01, 0, IfThen( Rota.ObterUf, 'S', 'N' ) );
  end;
end;


procedure TCIOTW_Pamcard.PedagioContratoFrete;
var
  i: Integer;
begin
  with CIOT.AdicionarOperacao do
  begin
    AddFieldNoXml( tcStr, '', 'viagem.pedagio.cartao.numero', 01, 16, 0, Pedagio.CartaoNumero );
    AddFieldNoXml( tcStr, '', 'viagem.pedagio.idavolta', 01, 01, 0, IfThen( Pedagio.IdaVolta, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.pedagio.obter.praca', 01, 01, 0, IfThen( Pedagio.ObterPraca, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.pedagio.roteirizar', 01, 01, 0, IfThen( Pedagio.Roteirizar, 'S', 'N' ) );
    AddFieldNoXml( tcInt, '', 'viagem.pedagio.solucao.id', 01, 01, 0, Pedagio.SolucaoId );
    AddFieldNoXml( tcInt, '', 'viagem.pedagio.status.id', 01, 02, 0, Pedagio.StatusId );
    AddFieldNoXml( tcDe2, '', 'viagem.pedagio.valor', 01, 10, 0, Pedagio.Valor );
    AddFieldNoXml( tcInt, '', 'viagem.pedagio.tag.emissor.id', 01, 04, 0, Pedagio.TagEmissorId );
    AddFieldNoXml( tcInt, '', 'viagem.pedagio.roteirizar.tipo', 01, 01, 0, 1 );
    AddFieldNoXml( tcInt, '', 'viagem.pedagio.caminho', 01, 01, 0, Pedagio.Caminho );

    AddFieldNoXml( tcInt, '', 'viagem.pedagio.praca.qtde', 01, 02, 0, Pedagio.Pracas.Count );

    for i := 0 to Pedagio.Pracas.Count - 1 do
    begin
      AddFieldNoXml( tcInt, '', Format( 'viagem.pedagio.praca%d.id', [i+1] ), 01, 05, 0, Pedagio.Pracas.Items[i].Id );
      AddFieldNoXml( tcDe2, '', Format( 'viagem.pedagio.praca%d.valor', [i+1] ), 01, 10, 0, Pedagio.Pracas.Items[i].Valor );
    end;
  end;
end;

procedure TCIOTW_Pamcard.PostosContratoFrete;
var
  i: Integer;
begin
  with CIOT.AdicionarOperacao do
  begin
    AddFieldNoXml( tcInt, '', 'viagem.posto.qtde', 01, 02, 0, Postos.Count );

    for i := 0 to Postos.Count - 1 do
      AddFieldNoXml( tcStr, '', Format('viagem.posto%d.documento.numero', [i+1] ), 01, 20, 0, OnlyNumber( Postos.Items[i].DocumentoNumero ) );
  end;
end;

procedure TCIOTW_Pamcard.FreteContratoFrete;
var
  i: Integer;
begin
  with CIOT.AdicionarOperacao do
  begin
    AddFieldNoXml( tcDe2, '', 'viagem.frete.valor.bruto', 01, 10, 1, Frete.ValorBruto );
    AddFieldNoXml( tcInt, '', 'viagem.frete.item.qtde', 01, 02, 1, Frete.Itens.Count );

    for i := 0 to Frete.Itens.Count - 1 do
    begin
      AddFieldNoXml( tcInt, '', Format( 'viagem.frete.item%d.tipo', [i+1] ), 01, 03, 1, Frete.Itens.Items[i].Tipo );
      AddFieldNoXml( tcInt, '', Format( 'viagem.frete.item%d.tarifa.quantidade', [i+1] ), 01, 02, 1, Frete.Itens.Items[i].TarifaQuantidade );
      AddFieldNoXml( tcDe2, '', Format( 'viagem.frete.item%d.valor', [i+1] ), 01, 19, 1, Frete.Itens.Items[i].Valor );
    end;
  end;
end;

procedure TCIOTW_Pamcard.ParcelasContratoFrete;
var
  i: Integer;
begin
  with CIOT.AdicionarOperacao do
  begin
    AddFieldNoXml( tcInt, '', 'viagem.parcela.qtde', 01, 10, 0, Parcelas.Count );

    for i := 0 to Parcelas.Count - 1 do
    begin
      AddFieldNoXml( tcDatVcto, '', Format( 'viagem.parcela%d.data', [i+1] ), 01, 10, 1, Parcelas.Items[i].Data );
      AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.efetivacao.tipo', [i+1] ), 01, 02, 1, Parcelas.Items[i].EfetivacaoTipo );
      AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.favorecido.tipo.id', [i+1] ), 01, 02, 1, Parcelas.Items[i].FavorecidoTipoId );
      AddFieldNoXml( tcStr, '', Format( 'viagem.parcela%d.numero.cliente', [i+1] ), 01, 18, 1, Parcelas.Items[i].NumeroCliente );
      AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.status.id', [i+1] ), 01, 02, 1, Parcelas.Items[i].StatusId );
      AddFieldNoXml( tcStr, '', Format( 'viagem.parcela%d.subtipo', [i+1] ), 01, 02, 1, Parcelas.Items[i].Subtipo );
      AddFieldNoXml( tcDe2, '', Format( 'viagem.parcela%d.valor', [i+1] ), 01, 11, 1, Parcelas.Items[i].Valor );
    end;
  end;
end;

procedure TCIOTW_Pamcard.QuitacaoContratoFrete;
var
  i: Integer;
begin
  with CIOT.AdicionarOperacao do
  begin
    AddFieldNoXml( tcStr, '', 'viagem.quitacao.indicador', 01, 01, 0, IfThen( Quitacao.Indicador, 'S', '' ) );
    AddFieldNoXml( tcInt, '', 'viagem.quitacao.origem.pagamento', 01, 02, 0,  Quitacao.OrigemPagamento );
    AddFieldNoXml( tcInt, '', 'viagem.quitacao.prazo', 01, 02, 0, Quitacao.Prazo );
    AddFieldNoXml( tcStr, '', 'viagem.quitacao.entrega.ressalva', 01, 01, 0, IfThen( Quitacao.EntregaRessalva, 'S', '' ) );
    AddFieldNoXml( tcInt, '', 'viagem.quitacao.desconto.tipo', 01, 01, 0, Quitacao.DescontoTipo );
    AddFieldNoXml( tcDe2, '', 'viagem.quitacao.desconto.tolerancia', 01, 03, 0,  Quitacao.DescontoTolerancia );
    AddFieldNoXml( tcInt, '', 'viagem.quitacao.desconto.faixa.qtde', 01, 09, 0, Quitacao.DescontoFaixas.Count );

    for i := 0 to Quitacao.DescontoFaixas.Count - 1 do
    begin
      AddFieldNoXml( tcDe3, '', Format( 'viagem.quitacao.desconto.faixa%d.ate', [i+1] ), 01, 09, 1, Quitacao.DescontoFaixas.Items[i].Ate );
      AddFieldNoXml( tcDe2, '', Format( 'viagem.quitacao.desconto.faixa%d.percentual', [i+1] ), 01, 03, 1, Quitacao.DescontoFaixas.Items[i].Percentual );
    end;
  end;
end;

procedure TCIOTW_Pamcard.GerarInserirContratoFrete;
var
  FavorecidoQtd : Integer;
begin
  Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'InsertFreightContract' );

  FIndiceFavorecido := 0;
  FavorecidoQtd := 0;

  with CIOT.AdicionarOperacao do
  begin
    if( OnlyNumber( Contratado.CpfOuCnpj ) <> '' )then
      Inc( FavorecidoQtd );

    if( OnlyNumber( Subcontratante.CpfOuCnpj ) <> '' )then
      Inc( FavorecidoQtd );

    if( OnlyNumber( Motorista.CpfOuCnpj ) <> '' )then
      Inc( FavorecidoQtd );

    AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( MatrizCNPJ ) );

    if( OnlyNumber( FilialCNPJ ) <> '' )then
    begin
      AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 01, 2, 1 ); //CNPJ
      AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( FilialCNPJ ) );
    end;

    AddFieldNoXml( tcInt, '', 'viagem.favorecido.qtde', 01, 02, 1, FavorecidoQtd );

    FavorecidoContratoFrete( 1, Contratado );
    FavorecidoContratoFrete( 2, Subcontratante );
    FavorecidoContratoFrete( 3, Motorista );

    AddFieldNoXml( tcStr, '', 'viagem.contrato.numero', 01, 30, 0, CodigoIdentificacaoOperacaoPrincipal );
    AddFieldNoXml( tcInt, '', 'viagem.id.cliente', 01, 18, 1, IdOperacaoCliente );
    AddFieldNoXml( tcDatVcto, '', 'viagem.data.partida', 01, 10, 1, DataInicioViagem );
    AddFieldNoXml( tcDatVcto, '', 'viagem.data.termino', 01, 10, 1, DataFimViagem );

    VeiculosContratoFrete;

    if( Viagens.Count > 0 )then
      AddFieldNoXml( tcInt, '', 'viagem.distancia.km', 01, 10, 1, Viagens[0].DistanciaPercorrida );

    AddFieldNoXml( tcInt, '', 'viagem.carga.tipo', 01, 02, 1, TipoCargaToStr( CodigoTipoCarga ) );
    AddFieldNoXml( tcInt, '', 'viagem.carga.natureza', 04, 04, 1, CodigoNCMNaturezaCarga );
    AddFieldNoXml( tcDe2, '', 'viagem.carga.peso', 01, 07, 1, PesoCarga );
    AddFieldNoXml( tcInt, '', 'viagem.carga.perfil.id', 01, 01, 0, CargaPerfilId );
    AddFieldNoXml( tcDe2, '', 'viagem.carga.valorunitario', 01, 11, 0, CargaValorUnitario );
    AddFieldNoXml( tcStr, '', 'viagem.carga.destinacaocomercial.indicador ', 01, 01, 0, IfThen( DestinacaoComercial, 'S', 'N' ) );

    DocumentosContratoFrete;

    RotaOrigemDestinoPontosContratoFrete;

    PedagioContratoFrete;

    FreteContratoFrete;

    ParcelasContratoFrete;

    QuitacaoContratoFrete;

    AddFieldNoXml( tcInt, '', 'viagem.diferencafrete.credito', 01, 01, 0, IfThen( DiferencaFreteCredito, 1, 0 ) );
    AddFieldNoXml( tcInt, '', 'viagem.diferencafrete.debito', 01, 01, 0, IfThen( DiferencaFreteDebito, 1, 0 ) );
    AddFieldNoXml( tcDe2, '', 'viagem.diferencafrete.tarifamotorista', 01, 11, 0, DiferencaFreteTarifaMotorista );
    AddFieldNoXml( tcStr, '', 'viagem.comprovacao.observacao', 01, 4000, 0, ComprovacaoObservacao );

    AddFieldNoXml( tcStr, '', 'viagem.retorno.frete.indicador', 01, 01, 0, IfThen( FreteRetorno, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.retorno.cep', 01, 08, 0, OnlyNumber( CepRetorno ) );
    AddFieldNoXml( tcInt, '', 'viagem.retorno.distancia.km', 01, 10, 0, DistanciaRetorno );

    if( OnlyNumber( CiotEmissor.CpfOuCnpj ) <> '' )then
    begin
      AddFieldNoXml( tcStr, '', 'viagem.ciot.emissor.cliente.documento.tipo', 01, 01, 0, IfThen( Length( OnlyNumber( CiotEmissor.CpfOuCnpj ) ) = 11, 2, 1 ) );
      AddFieldNoXml( tcStr, '', 'viagem.ciot.emissor.cliente.documento.numero', 01, 14, 0, CiotEmissor.CpfOuCnpj );
      AddFieldNoXml( tcStr, '', 'viagem.ciot.emissor.cliente.nome', 01, 60, 0, CiotEmissor.NomeOuRazaoSocial );
    end;

    AddFieldNoXml( tcInt, '', 'viagem.contratacao.tipo', 01, 01, 0, ContratacaoTipo );
  end;
end;

procedure TCIOTW_Pamcard.GerarAlterarContratoFrete;

  {procedure PessoaFiscal( id, Tipo: Integer; Pessoa: TPessoa );
  var
    p : Integer;
  begin
    if( Trim( Pessoa.CpfOuCnpj ) = '' )then
      Exit;

    Inc( FIndicePessoaFiscal );
    p := FIndicePessoaFiscal;

    AddFieldNoXml( tcInt, '', Format('viagem.documento%d.pessoafiscal%d.tipo', [id+1, p] ), 01, 1, 1, Tipo ); //1-Remetente, 2-Destinatario, 3-Consignatario
    AddFieldNoXml( tcInt, '', Format('viagem.documento%d.pessoafiscal%d.codigo', [id+1, p] ), 01, 10, 0, Pessoa.CodigoNaIntegradora );

    if( Pessoa.CodigoNaIntegradora = 0 )then
    begin
      AddFieldNoXml( tcInt, '', Format('viagem.documento%d.pessoafiscal%d.documento.tipo', [id+1, p] ), 01, 2, 1, IfThen( Length( OnlyNumber( Pessoa.CpfOuCnpj ) ) = 11, 2, 1 ) ); //1-CNPJ 2-CPF
      AddFieldNoXml( tcStr, '', Format('viagem.documento%d.pessoafiscal%d.documento.numero', [id+1, p] ), 01, 20, 1, OnlyNumber( Pessoa.CpfOuCnpj ) );
      AddFieldNoXml( tcStr, '', Format('viagem.documento%d.pessoafiscal%d.nome', [id+1, p] ), 01, 40, 1, Pessoa.NomeOuRazaoSocial );
      AddFieldNoXml( tcStr, '', Format('viagem.documento%d.pessoafiscal%d.endereco.logradouro', [id+1, p]), 01, 40, 1, Pessoa.Endereco.Rua );
      AddFieldNoXml( tcStr, '', Format('viagem.documento%d.pessoafiscal%d.endereco.numero', [id+1, p] ), 01, 5, 1, Pessoa.Endereco.Numero );
      AddFieldNoXml( tcStr, '', Format('viagem.documento%d.pessoafiscal%d.endereco.complemento', [id+1, p] ), 01, 15, 1, Pessoa.Endereco.Complemento );
      AddFieldNoXml( tcStr, '', Format('viagem.documento%d.pessoafiscal%d.endereco.bairro', [id+1, p] ), 01, 30, 1, Pessoa.Endereco.Bairro );
      AddFieldNoXml( tcInt, '', Format('viagem.documento%d.pessoafiscal%d.endereco.cidade.ibge', [id+1, p] ), 01, 7, 1, Pessoa.Endereco.CodigoMunicipio );
      AddFieldNoXml( tcStr, '', Format('viagem.documento%d.pessoafiscal%d.endereco.cep', [id+1, p] ), 01, 8, 1, OnlyNumber( Pessoa.Endereco.CEP ) );
    end;
  end;}

{var
  I : Integer;
  Favorecidos : array of TFavorecidoInfo;
  PessoaFiscalQtd : Integer;}
begin
  {Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'UpdateFreightContract' );

  if Trim( CIOT.AdicionarOperacao.Contratado.CpfOuCnpj ) <> '' then
  begin
    SetLength( Favorecidos, Length( Favorecidos ) + 1);
    Favorecidos[High( Favorecidos )].Tipo := 1;
    Favorecidos[High( Favorecidos )].Pessoa := CIOT.AdicionarOperacao.Contratado;
  end;

  if Trim( CIOT.AdicionarOperacao.Subcontratante.CpfOuCnpj ) <> '' then
  begin
    SetLength( Favorecidos, Length( Favorecidos ) + 1);
    Favorecidos[High( Favorecidos )].Tipo := 2;
    Favorecidos[High( Favorecidos )].Pessoa := CIOT.AdicionarOperacao.Subcontratante;
  end;

  if Trim( CIOT.AdicionarOperacao.Motorista.CpfOuCnpj ) <> '' then
  begin
    SetLength( Favorecidos, Length( Favorecidos ) + 1 );
    Favorecidos[High( Favorecidos )].Tipo := 3;
    Favorecidos[High( Favorecidos )].Pessoa := CIOT.AdicionarOperacao.Motorista;
  end;

  AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.MatrizCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
  AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.FilialCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido.qtde', 01, 1, 1, Length( Favorecidos ) );

  for i := 0 to High(Favorecidos) do
  begin
    AddFieldNoXml( tcInt, '', Format( 'viagem.favorecido%d.tipo', [i+1] ), 01, 1, 0, Favorecidos[I].Tipo );
    AddFieldNoXml( tcStr, '', Format( 'viagem.favorecido%d.cartao.numero', [i+1] ), 01, 16, 0, OnlyNumber( Favorecidos[I].Pessoa.InformacoesBancarias.CartaoNumero ) );
  end;

  AddFieldNoXml( tcInt, '', 'viagem.id', 01, 10, 1, CIOT.AdicionarOperacao.Id );
  AddFieldNoXml( tcInt, '', 'viagem.id.cliente', 01, 18, 1, CIOT.AdicionarOperacao.IdOperacaoCliente );
  AddFieldNoXml( tcInt, '', 'viagem.antt.ciot.numero', 01, 12, 1, CIOT.AdicionarOperacao.CIOTNumero );
  AddFieldNoXml( tcDatVcto, '', 'viagem.data.termino', 01, 10, 1, CIOT.AdicionarOperacao.DataFimViagem );
  AddFieldNoXml( tcInt, '', 'viagem.carga.natureza', 01, 4, 1, CIOT.AdicionarOperacao.CodigoNCMNaturezaCarga );
  AddFieldNoXml( tcInt, '', 'viagem.carga.tipo', 01, 2, 1, TipoCargaToStr( CIOT.AdicionarOperacao.CodigoTipoCarga ) );
  AddFieldNoXml( tcDe2, '', 'viagem.carga.peso', 01, 5, 1, CIOT.AdicionarOperacao.PesoCarga );
  AddFieldNoXml( tcStr, '', 'viagem.veiculo.categoria', 01, 3, 0, CIOT.AdicionarOperacao.VeiculoCategoria );
  AddFieldNoXml( tcInt, '', 'viagem.veiculo.qtde', 01, 1, 1, CIOT.AdicionarOperacao.Veiculos.Count );

  for i := 0 to CIOT.AdicionarOperacao.Veiculos.Count - 1 do
  begin
    AddFieldNoXml( tcStr, '', Format( 'viagem.veiculo%d.placa', [i+1] ), 01, 7, 1, CIOT.AdicionarOperacao.Veiculos.Items[i].Placa );
    AddFieldNoXml( tcStr, '', Format( 'viagem.veiculo%d.rntrc', [i+1] ), 01, 8, 0, CIOT.AdicionarOperacao.Veiculos.Items[i].RNTRC );
  end;

  AddFieldNoXml( tcStr, '', 'viagem.pedagio.roteirizar', 01, 1, 0, IfThen( CIOT.AdicionarOperacao.Pedagio.Roteirizar, 'S', 'N' ) );
  AddFieldNoXml( tcInt, '', 'viagem.documento.qtde', 01, 10, 1, CIOT.AdicionarOperacao.Viagens[0].NotasFiscais.Count );

  for i := 0 to CIOT.AdicionarOperacao.Viagens[0].NotasFiscais.Count -1 do
  begin
    FIndicePessoaFiscal := 0;
    PessoaFiscalQtd := 0;

    if( Trim( CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].Remetente.CpfOuCnpj ) <> '' )then
      Inc( PessoaFiscalQtd );

    if( Trim( CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].Destinatario.CpfOuCnpj ) <> '' )then
      Inc( PessoaFiscalQtd );

    if( Trim( CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].Consignatario.CpfOuCnpj ) <> '' )then
      Inc( PessoaFiscalQtd );

    AddFieldNoXml( tcInt, '', Format( 'viagem.documento%d.tipo', [i+1] ), 01, 2, 1, TipoDocumentoPamcardToStr( CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].TipoDocumentoPamcard ) );
    AddFieldNoXml( tcStr, '', Format( 'viagem.documento%d.numero', [i+1] ), 01, 30, 01, CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].Numero );
    AddFieldNoXml( tcStr, '', Format( 'viagem.documento%d.serie', [i+1] ), 01, 5, 0, CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].Serie );
    AddFieldNoXml( tcDe2, '', Format( 'viagem.documento%d.quantidade', [i+1] ), 01, 7, 0, CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].QuantidadeDaMercadoriaNoEmbarque );
    AddFieldNoXml( tcStr, '', Format( 'viagem.documento%d.especie', [i+1] ), 01, 15, 0, CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].Especie );
    AddFieldNoXml( tcDe3, '', Format( 'viagem.documento%d.cubagem', [i+1] ), 01, 8, 0, CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].Cubagem );
    AddFieldNoXml( tcInt, '', Format( 'viagem.documento%d.natureza', [i+1] ), 01, 4, 0, CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].CodigoNCMNaturezaCarga );
    AddFieldNoXml( tcDe2, '', Format( 'viagem.documento%d.peso', [i+1] ), 01, 5, 0, CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].Peso );
    AddFieldNoXml( tcDe2, '', Format( 'viagem.documento%d.mercadoria.valor', [i+1] ), 01, 17, 0, CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].ValorTotal );
    AddFieldNoXml( tcInt, '', Format( 'viagem.documento%d.pessoafiscal.qtde', [i+1] ), 01, 02, 1, PessoaFiscalQtd );

    PessoaFiscal( i, 1, CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].Remetente );
    PessoaFiscal( i, 2, CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].Destinatario );
    PessoaFiscal( i, 3, CIOT.AdicionarOperacao.Viagens[0].NotasFiscais[i].Consignatario );
  end;

  AddFieldNoXml( tcStr, '', 'viagem.documento.complementar.qtde', 01, 2, 0, 0 );
  AddFieldNoXml( tcStr, '', Format('viagem.documento.complementar%d.tipo', [1] ), 01, 2, 0, 0 );//Implementar lista futuramente se necessario

  AddFieldNoXml( tcStr, '', 'viagem.pedagio.cartao.numero', 01, 16, 0, CIOT.AdicionarOperacao.Pedagio.CartaoNumero );
  AddFieldNoXml( tcStr, '', 'viagem.pedagio.idavolta', 01, 1, 0, IfThen( CIOT.AdicionarOperacao.Pedagio.IdaVolta, 'S', 'N' ) );
  AddFieldNoXml( tcStr, '', 'viagem.pedagio.obter.praca', 01, 1, 0, IfThen( CIOT.AdicionarOperacao.Pedagio.ObterPraca, 'S', 'N' ) );
  AddFieldNoXml( tcStr, '', 'viagem.pedagio.roteirizar', 01, 1, 0, IfThen( CIOT.AdicionarOperacao.Pedagio.Roteirizar, 'S', 'N' ) );
  AddFieldNoXml( tcInt, '', 'viagem.pedagio.solucao.id', 01, 1, 0, CIOT.AdicionarOperacao.Pedagio.SolucaoId );
  AddFieldNoXml( tcInt, '', 'viagem.pedagio.status.id', 01, 2, 0, CIOT.AdicionarOperacao.Pedagio.StatusId );
  AddFieldNoXml( tcDe2, '', 'viagem.pedagio.valor', 01, 9, 0, CIOT.AdicionarOperacao.Pedagio.Valor );
  AddFieldNoXml( tcInt, '', 'viagem.pedagio.praca.qtde', 01, 3, 0, CIOT.AdicionarOperacao.Pedagio.Pracas.Count );

  for i := 0 to CIOT.AdicionarOperacao.Pedagio.Pracas.Count - 1 do
  begin
    AddFieldNoXml( tcInt, '', Format( 'viagem.pedagio.praca%d.id', [i+1] ), 01, 5, 0, CIOT.AdicionarOperacao.Pedagio.Pracas.Items[i].Id );
    AddFieldNoXml( tcDe2, '', Format( 'viagem.pedagio.praca%d.valor', [i+1] ), 01, 9, 0, CIOT.AdicionarOperacao.Pedagio.Pracas.Items[i].Valor );
  end;

  AddFieldNoXml( tcInt, '', 'viagem.rota.id', 01, 10, 0, CIOT.AdicionarOperacao.Rota.Id );
  AddFieldNoXml( tcStr, '', 'viagem.rota.nome', 01, 50, 0, CIOT.AdicionarOperacao.Rota.Nome );
  AddFieldNoXml( tcStr, '', 'viagem.origem.pais.nome', 01, 50, 0, CIOT.AdicionarOperacao.Rota.OrigemPaisNome );
  AddFieldNoXml( tcStr, '', 'viagem.origem.estado.nome', 01, 50, 0, CIOT.AdicionarOperacao.Rota.OrigemEstadoNome );
  AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.nome', 01, 50, 0, CIOT.AdicionarOperacao.Rota.OrigemCidadeNome );
  AddFieldNoXml( tcInt, '', 'viagem.origem.cidade.ibge', 01, 7, 0, CIOT.AdicionarOperacao.Rota.OrigemCidadeIbge );
  AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.latitude', 01, 10, 0, CIOT.AdicionarOperacao.Rota.OrigemCidadeLatitude );
  AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.longitude', 01, 10, 0, CIOT.AdicionarOperacao.Rota.OrigemCidadeLongitude );
  AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.cep', 01, 8, 0, OnlyNumber( CIOT.AdicionarOperacao.Rota.OrigemCidadeCep ) );
  AddFieldNoXml( tcInt, '', 'viagem.destino.cidade.ibge', 01, 7, 0, CIOT.AdicionarOperacao.Rota.DestinoCidadeIbge );
  AddFieldNoXml( tcStr, '', 'viagem.destino.pais.nome', 01, 50, 0, CIOT.AdicionarOperacao.Rota.DestinoPaisNome );
  AddFieldNoXml( tcStr, '', 'viagem.destino.estado.nome', 01, 50, 0, CIOT.AdicionarOperacao.Rota.DestinoEstadoNome );
  AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.nome', 01, 50, 0, CIOT.AdicionarOperacao.Rota.DestinoCidadeNome );
  AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.latitude', 01, 10, 0, CIOT.AdicionarOperacao.Rota.DestinoCidadeLatitude );
  AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.longitude', 01, 10, 0, CIOT.AdicionarOperacao.Rota.DestinoCidadeLongitude );
  AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.cep', 01, 8, 0, CIOT.AdicionarOperacao.Rota.DestinoCidadeCep );
  AddFieldNoXml( tcInt, '', 'viagem.ponto.qtde', 01, 10, 0, CIOT.AdicionarOperacao.Rota.Pontos.Count );

  for i := 0 to CIOT.AdicionarOperacao.Rota.Pontos.Count - 1 do
  begin
    AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.pais.nome', [i+1] ), 01, 50, 0, CIOT.AdicionarOperacao.Rota.Pontos.Items[I].PaisNome );
    AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.estado.nome', [i+1] ), 01, 50, 0, CIOT.AdicionarOperacao.Rota.Pontos.Items[I].EstadoNome );
    AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.cidade.nome', [i+1] ), 01, 50, 0, CIOT.AdicionarOperacao.Rota.Pontos.Items[I].CidadeNome );
    AddFieldNoXml( tcInt, '', Format( 'viagem.ponto%d.cidade.ibge', [i+1] ), 01, 50, 0, CIOT.AdicionarOperacao.Rota.Pontos.Items[I].CidadeIbge );
  end;

  AddFieldNoXml( tcInt, '', 'viagem.posto.qtde', 01, 02, 0, CIOT.AdicionarOperacao.Postos.Count );

  for i := 0 to CIOT.AdicionarOperacao.Postos.Count - 1 do
    AddFieldNoXml( tcStr, '', Format('viagem.posto%d.documento.numero', [i+1] ), 01, 20, 0, OnlyNumber( CIOT.AdicionarOperacao.Postos.Items[i].CNPJ ) );

  AddFieldNoXml( tcStr, '', 'viagem.quitacao.indicador', 01, 1, 0, IfThen( CIOT.AdicionarOperacao.Quitacao.Indicador, 'S', 'N' ) );
  AddFieldNoXml( tcInt, '', 'viagem.carga.perfil.id', 01, 1, 0, CIOT.AdicionarOperacao.CargaPerfilId );
  AddFieldNoXml( tcInt, '', 'viagem.quitacao.origem.pagamento', 01, 2, 0,  CIOT.AdicionarOperacao.Quitacao.OrigemPagamento );
  AddFieldNoXml( tcInt, '', 'viagem.quitacao.prazo', 01, 2, 0, CIOT.AdicionarOperacao.Quitacao.Prazo );
  AddFieldNoXml( tcStr, '', 'viagem.quitacao.entrega.ressalva', 01, 1, 0, IfThen( CIOT.AdicionarOperacao.Quitacao.EntregaRessalva, 'S', 'N' ) );
  AddFieldNoXml( tcInt, '', 'viagem.quitacao.desconto.tipo', 01, 1, 0, CIOT.AdicionarOperacao.Quitacao.DescontoTipo );
  AddFieldNoXml( tcDe2, '', 'viagem.carga.valorunitario', 01, 9, 0, CIOT.AdicionarOperacao.CargaValorUnitario );
  AddFieldNoXml( tcDe2, '', 'viagem.quitacao.desconto.tolerancia', 01, 3, 0,  CIOT.AdicionarOperacao.Quitacao.DescontoTolerancia );
  AddFieldNoXml( tcInt, '', 'viagem.quitacao.desconto.faixa.qtde', 01, 9, 0, CIOT.AdicionarOperacao.Quitacao.DescontoFaixas.Count );

  for i := 0 to CIOT.AdicionarOperacao.Quitacao.DescontoFaixas.Count - 1 do
  begin
    AddFieldNoXml( tcDe3, '', Format( 'viagem.quitacao.desconto.faixa%d.ate', [i+1] ), 01, 9, 1, CIOT.AdicionarOperacao.Quitacao.DescontoFaixas.Items[i].Ate );
    AddFieldNoXml( tcDe2, '', Format( 'viagem.quitacao.desconto.faixa%d.percentual', [i+1] ), 01, 3, 1, CIOT.AdicionarOperacao.Quitacao.DescontoFaixas.Items[i].Percentual );
  end;

  AddFieldNoXml( tcInt, '', 'viagem.diferencafrete.credito', 01, 1, 0, IfThen( CIOT.AdicionarOperacao.DiferencaFreteCredito, 1, 0 ) );
  AddFieldNoXml( tcInt, '', 'viagem.diferencafrete.debito', 01, 1, 0, IfThen( CIOT.AdicionarOperacao.DiferencaFreteDebito, 1, 0 ) );
  AddFieldNoXml( tcDe2, '', 'viagem.diferencafrete.tarifamotorista', 01, 9, 0, CIOT.AdicionarOperacao.DiferencaFreteTarifaMotorista );
  AddFieldNoXml( tcStr, '', 'viagem.comprovacao.observacao', 01, 4000, 0, CIOT.AdicionarOperacao.ComprovacaoObservacao );}
end;

procedure TCIOTW_Pamcard.GerarAlterarStatusParcela;
{var
  I : Integer;}
begin
  {Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'UpdateParcelStatus' );

  AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.MatrizCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
  AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.FilialCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.id', 01, 10, 1, CIOT.AdicionarOperacao.Id );
  AddFieldNoXml( tcInt, '', 'viagem.id.cliente', 01, 18, 1, CIOT.AdicionarOperacao.IdOperacaoCliente );
  AddFieldNoXml( tcInt, '', 'viagem.antt.ciot.numero', 01, 12, 1, CIOT.AdicionarOperacao.CIOTNumero );
  AddFieldNoXml( tcInt, '', 'viagem.parcela.qtde', 01, 10, 0, CIOT.AdicionarOperacao.Parcelas.Count );

  for i := 0 to CIOT.AdicionarOperacao.Parcelas.Count - 1 do
  begin
    AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.numero', [i+1] ), 01, 2, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].Numero );
    AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.status.id', [i+1] ), 01, 2, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].StatusId );
    AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.numero.cliente', [i+1] ), 01, 18, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].NumeroCliente );
  end;}
end;

procedure TCIOTW_Pamcard.GerarAlterarStatusPedagio;
begin
  {Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'UpdateTollStatus' );

  AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.MatrizCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
  AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.FilialCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.id', 01, 10, 1, CIOT.AdicionarOperacao.Id );
  AddFieldNoXml( tcInt, '', 'viagem.id.cliente', 01, 18, 1, CIOT.AdicionarOperacao.IdOperacaoCliente );
  AddFieldNoXml( tcInt, '', 'viagem.antt.ciot.numero', 01, 12, 1, CIOT.AdicionarOperacao.CIOTNumero );
  AddFieldNoXml( tcInt, '', 'viagem.pedagio.status.id', 01, 10, 1, CIOT.AdicionarOperacao.Pedagio.StatusId );}
end;

procedure TCIOTW_Pamcard.GerarAlterarValoresContratoFrete;
{var
  I : Integer;}
begin
  {Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'UpdateValuesFreightContract' );

  AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.MatrizCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
  AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.FilialCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.id', 01, 10, 1, CIOT.AdicionarOperacao.Id );
  AddFieldNoXml( tcInt, '', 'viagem.id.cliente', 01, 10, 1, CIOT.AdicionarOperacao.IdOperacaoCliente );
  AddFieldNoXml( tcInt, '', 'viagem.antt.ciot.numero', 01, 12, 1, CIOT.AdicionarOperacao.CIOTNumero );
  AddFieldNoXml( tcDe2, '', 'viagem.frete.valor.bruto', 01, 9, 1, CIOT.AdicionarOperacao.Frete.ValorBruto );
  AddFieldNoXml( tcInt, '', 'viagem.frete.item.qtde', 01, 2, 1, CIOT.AdicionarOperacao.Frete.Itens.Count );

  for i := 0 to CIOT.AdicionarOperacao.Frete.Itens.Count - 1 do
  begin
    AddFieldNoXml( tcInt, '', Format( 'viagem.frete.item%d.tipo', [i+1] ), 01, 3, 1, CIOT.AdicionarOperacao.Frete.Itens[I].Tipo );
    AddFieldNoXml( tcInt, '', Format( 'viagem.frete.item%d.tarifa.quantidade', [i+1] ), 01, 2, 1, CIOT.AdicionarOperacao.Frete.Itens[I].TarifaQuantidade );
    AddFieldNoXml( tcDe2, '', Format( 'viagem.frete.item%d.valor', [i+1] ), 01, 17, 1, CIOT.AdicionarOperacao.Frete.Itens[I].Valor );
  end;

  AddFieldNoXml( tcInt, '', 'viagem.parcela.qtde', 01, 10, 0, CIOT.AdicionarOperacao.Parcelas.Count );

  for i := 0 to CIOT.AdicionarOperacao.Parcelas.Count - 1 do
  begin
    AddFieldNoXml( tcDatVcto, '', Format( 'viagem.parcela%d.data', [i+1] ), 01, 10, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].Data );
    AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.efetivacao.tipo', [i+1] ), 01, 02, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].EfetivacaoTipo );
    AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.favorecido.tipo.id', [i+1] ), 01, 02, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].FavorecidoTipoId );
    AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.numero.cliente', [i+1] ), 01, 18, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].NumeroCliente );
    AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.status.id', [i+1] ), 01, 2, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].StatusId );
    AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.tipo', [i+1] ), 01, 2, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].Tipo );
    AddFieldNoXml( tcDe2, '', Format( 'viagem.parcela%d.valor', [i+1] ), 01, 9, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].Valor );
  end;}
end;

procedure TCIOTW_Pamcard.GerarAlterarValoresViagem;
{var
  I : Integer;}
begin
  {Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'UpdateValuesTrip' );

  AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.MatrizCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
  AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.FilialCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.id', 01, 10, 1, CIOT.AdicionarOperacao.Id );
  AddFieldNoXml( tcInt, '', 'viagem.id.cliente', 01, 10, 1, CIOT.AdicionarOperacao.IdOperacaoCliente );
  AddFieldNoXml( tcInt, '', 'viagem.parcela.qtde', 01, 10, 0, CIOT.AdicionarOperacao.Parcelas.Count );

  for i := 0 to CIOT.AdicionarOperacao.Parcelas.Count - 1 do
  begin
    AddFieldNoXml( tcDatVcto, '', Format( 'viagem.parcela%d.data', [i+1] ), 01, 10, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].Data );
    AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.efetivacao.tipo', [i+1] ), 01, 02, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].EfetivacaoTipo );
    AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.favorecido.tipo.id', [i+1] ), 01, 02, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].FavorecidoTipoId );
    AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.numero.cliente', [i+1] ), 01, 18, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].NumeroCliente );
    AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.status.id', [i+1] ), 01, 2, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].StatusId );
    AddFieldNoXml( tcInt, '', Format( 'viagem.parcela%d.tipo', [i+1] ), 01, 2, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].Tipo );
    AddFieldNoXml( tcDe2, '', Format( 'viagem.parcela%d.valor', [i+1] ), 01, 9, 1, CIOT.AdicionarOperacao.Parcelas.Items[i].Valor );
  end;}
end;

procedure TCIOTW_Pamcard.GerarCancelaViagem;
begin
  with CIOT.CancelarOperacao do
  begin
    Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'CancelTrip' );

    AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.CancelarOperacao.MatrizCNPJ ) );

    if( OnlyNumber( FilialCNPJ ) <> '' )then
    begin
      AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 01, 2, 1 ); //CNPJ
      AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( FilialCNPJ ) );
    end;

    AddFieldNoXml( tcStr, '', 'viagem.id', 01, 10, 0, CIOT.CancelarOperacao.IdOperacaoIntegradora );
    AddFieldNoXml( tcStr, '', 'viagem.id.cliente', 01, 18, 0, CIOT.CancelarOperacao.IdOperacaoCliente );
    AddFieldNoXml( tcStr, '', 'viagem.antt.ciot.numero', 01, 12, 0, CIOT.CancelarOperacao.CodigoIdentificacaoOperacao );
    AddFieldNoXml( tcStr, '', 'viagem.antt.cancelamento.motivo', 01, 500, 1, CIOT.CancelarOperacao.Motivo );
  end;
end;

procedure TCIOTW_Pamcard.GerarConsultarContratoFrete;
begin
  with CIOT.ObterCodigoOperacaoTransporte do
  begin
    Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'FindFreightContract' );

    AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.ObterCodigoOperacaoTransporte.MatrizCNPJ ) );

    if( OnlyNumber( FilialCNPJ ) <> '' )then
    begin
      AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 01, 2, 1 ); //CNPJ
      AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( FilialCNPJ ) );
    end;

    AddFieldNoXml( tcStr, '', 'viagem.id', 01, 10, 0, CIOT.ObterCodigoOperacaoTransporte.IdOperacaoIntegradora );
    AddFieldNoXml( tcStr, '', 'viagem.id.cliente', 01, 18, 0, CIOT.ObterCodigoOperacaoTransporte.IdOperacaoCliente );
    AddFieldNoXml( tcStr, '', 'viagem.antt.ciot.numero', 01, 12, 0, CIOT.ObterCodigoOperacaoTransporte.CodigoIdentificacaoOperacao );
    AddFieldNoXml( tcStr, '', 'viagem.pedagio.obter.praca', 01, 01, 1, IfThen( CIOT.ObterCodigoOperacaoTransporte.PedagioObterPraca, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.pedagio.obter.rota', 01, 01, 1, IfThen( CIOT.ObterCodigoOperacaoTransporte.PedagioObterRota, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.obter.favorecido', 01, 01, 1, IfThen( CIOT.ObterCodigoOperacaoTransporte.ObterFavorecido, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.obter.documento', 01, 01, 1, IfThen( CIOT.ObterCodigoOperacaoTransporte.ObterDocumento, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.obter.valores', 01, 01, 1, IfThen( CIOT.ObterCodigoOperacaoTransporte.ObterValores, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.obter.veiculo', 01, 01, 1, IfThen( CIOT.ObterCodigoOperacaoTransporte.ObterVeiculo, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.obter.quitacao', 01, 01, 1, IfThen( CIOT.ObterCodigoOperacaoTransporte.ObterQuitacao, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.obter.uf', 01, 01, 1, IfThen( CIOT.ObterCodigoOperacaoTransporte.ObterUf, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.obter.postos', 01, 01, 1, IfThen( CIOT.ObterCodigoOperacaoTransporte.ObterPostos, 'S', 'N' ) );
  end;
end;

procedure TCIOTW_Pamcard.GerarConsultarCartao;
begin
  {Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'FindCard' );

  AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.MatrizCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
  AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.FilialCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.cartao.numero', 01, 16, 1, CIOT.AdicionarOperacao.Cartao.Numero );}
end;

procedure TCIOTW_Pamcard.GerarConsultarConta(Favorecido: TPessoa);
{var
  i : Integer;}
begin
  {Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'FindFavoredAccount' );

  AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.MatrizCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
  AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.FilialCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido.documento.tipo', 01, 1, 1, IfThen( Length( OnlyNumber( Favorecido.CpfOuCnpj ) ) = 11, 2, 1) );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido.documento.numero', 01, 20, 1, OnlyNumber( Favorecido.CpfOuCnpj ) );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido.conta.banco', 01, 4, 1, Favorecido.InformacoesBancarias.InstituicaoBancaria );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido.conta.agencia', 01, 10, 1, Favorecido.InformacoesBancarias.Agencia );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido.conta.agencia.digito', 01, 1, 1, Favorecido.InformacoesBancarias.DigitoAgencia );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido.conta.numero', 01, 20, 1, Favorecido.InformacoesBancarias.Conta );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido.conta.tipo', 01, 2, 1, TipoContaToIndex( Favorecido.InformacoesBancarias.TipoConta ) );}
end;

procedure TCIOTW_Pamcard.GerarConsultarFavorecido(Favorecido: TPessoa);
begin
  {Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'FindFavored' );

  AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.MatrizCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
  AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.FilialCNPJ ) );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido.documento.numero', 01, 20, 1, OnlyNumber( Favorecido.CpfOuCnpj ) );

  if( Length( OnlyNumber( Favorecido.CpfOuCnpj ) ) = 11 )then
    AddFieldNoXml( tcInt, '', 'viagem.favorecido.documento.tipo', 01, 1, 1, 2 )
  else
  begin
    AddFieldNoXml( tcInt, '', 'viagem.favorecido.documento.tipo', 01, 1, 1, 1 );

    if( CIOT.AdicionarOperacao.ObterCartao )then
    begin
      AddFieldNoXml( tcStr, '', 'viagem.favorecido2.documento.numero', 01, 20, 1, OnlyNumber( Favorecido.CPF ) );
      AddFieldNoXml( tcInt, '', 'viagem.favorecido2.documento.tipo', 01, 2, 1, 2 );
    end;
  end;

  AddFieldNoXml( tcStr, '', 'viagem.obter.cartao', 01, 1, 1, IfThen( CIOT.AdicionarOperacao.ObterCartao, 'S', 'N' ) );
  AddFieldNoXml( tcStr, '', 'viagem.obter.conta', 01, 1, 1, IfThen( CIOT.AdicionarOperacao.ObterConta, 'S', 'N' ) );
  AddFieldNoXml( tcStr, '', 'viagem.obter.rntrc.complemento', 01, 1, 1, IfThen( CIOT.AdicionarOperacao.ObterRNTRCComplemento, 'S', 'N' ) );}
end;

procedure TCIOTW_Pamcard.GerarConsultarFrota(Favorecido: TPessoa);
{var
  i : Integer;}
begin
  {Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'FindFleet' );

  AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.MatrizCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
  AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.FilialCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido.documento.qtde', 01, 1, 1, 2 );

  for i := 0 to 1 do
  begin
    AddFieldNoXml( tcInt, '', Format( 'viagem.favorecido.documento%d.tipo', [i+1] ), 01, 2, 0, IfThen( Length( OnlyNumber( Favorecido.CpfOuCnpj ) ) = 11, IfThen( i = 0, 2, 5 ), IfThen( i = 0, 1, 6 ) ) );
    AddFieldNoXml( tcStr, '', Format( 'viagem.favorecido.documento%d.numero', [i+1] ), 01, 20, 0, IfThen( i = 0, OnlyNumber( Favorecido.CpfOuCnpj ), OnlyNumber( Favorecido.RNTRC ) ) );
  end;

  AddFieldNoXml( tcInt, '', 'viagem.veiculo.qtde', 01, 1, 1, CIOT.AdicionarOperacao.Veiculos.Count );

  for i := 0 to CIOT.AdicionarOperacao.Veiculos.Count - 1 do
  begin
    AddFieldNoXml( tcStr, '', Format( 'viagem.veiculo%d.placa', [i + 1] ), 01, 07, 1, CIOT.AdicionarOperacao.Veiculos.Items[i].Placa );
  end;

  AddFieldNoXml( tcStr, '', 'viagem.favorecido.obter.rntrc', 01, 1, 1, IfThen( Favorecido.ObterRNTRC, 'S', 'N' ) );}
end;

procedure TCIOTW_Pamcard.GerarConsultarRNTRC(Favorecido: TPessoa);
{var
  i : Integer;}
begin
  {Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'FindRNTRC' );

  AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.MatrizCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
  AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.FilialCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido.documento.qtde', 01, 1, 1, 2 );

  for i := 0 to 1 do
  begin
    AddFieldNoXml( tcInt, '', Format( 'viagem.favorecido.documento%d.tipo', [i+1] ), 01, 2, 0, IfThen( Length( OnlyNumber( Favorecido.CpfOuCnpj ) ) = 11, IfThen( i = 0, 2, 5 ), IfThen( i = 0, 1, 6 ) ) );
    AddFieldNoXml( tcInt, '', Format( 'viagem.favorecido.documento%d.numero', [i+1] ), 01, 20, 0, IfThen( i = 0, OnlyNumber( Favorecido.CpfOuCnpj ), OnlyNumber( Favorecido.RNTRC ) ) );
  end;

  AddFieldNoXml( tcStr, '', 'viagem.favorecido.obter.rntrc', 01, 1, 1, IfThen( Favorecido.ObterRNTRC, 'S', 'N' ) );}
end;

procedure TCIOTW_Pamcard.GerarConsultarTAG(Favorecido : TPessoa);
begin
  {Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'FindTag' );

  AddFieldNoXml( tcStr, '', 'tag.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.MatrizCNPJ ) );
  //AddFieldNoXml( tcStr, '', 'tag.placa', 01, 7, 1, OnlyNumber( CIOT.AdicionarOperacao. ) );   Campos so precisa ser preenchido em caso de nao haver favorecido ou numero
  //AddFieldNoXml( tcStr, '', 'tag.numero', 01, 13, 1, OnlyNumber( CIOT.AdicionarOperacao. ) );  Campos so precisa ser preenchido em caso de nao haver favorecido ou placa
  AddFieldNoXml( tcInt, '', 'favorecido.documento.tipo', 01, 2, 1, IfThen( Length( OnlyNumber( Favorecido.CpfOuCnpj ) ) = 11, 2, 1) );
  AddFieldNoXml( tcStr, '', 'favorecido.documento.numero', 01, 20, 1, OnlyNumber( Favorecido.CpfOuCnpj ));
  AddFieldNoXml( tcStr, '', 'tag.emissor.id', 01, 4, 1, OnlyNumber( CIOT.AdicionarOperacao.Pedagio.TagEmissorId ) );}
end;

procedure TCIOTW_Pamcard.GerarConsultarViagem;
begin
  {Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'FindTrip' );

  AddFieldNoXml( tcInt, '', 'viagem.id', 01, 10, 1, CIOT.AdicionarOperacao.Id );
  AddFieldNoXml( tcInt, '', 'viagem.id.cliente', 01, 18, 1, CIOT.AdicionarOperacao.IdOperacaoCliente );
  AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.MatrizCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
  AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.FilialCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.documento.qtde', 01, 2, 1, 1 );
  AddFieldNoXml( tcInt, '', 'viagem.documento.tipo', 01, 2, 1, TipoDocumentoPamcardToStr( CIOT.AdicionarOperacao.TipoDocumentoPamCard ) );
  AddFieldNoXml( tcStr, '', 'viagem.documento.numero', 01, 30, 1, CIOT.AdicionarOperacao.NumeroDocumentoPamCard );
  AddFieldNoXml( tcInt, '', 'viagem.cartao.numero', 01, 16, 1, CIOT.AdicionarOperacao.Cartao.Numero );
  AddFieldNoXml( tcStr, '', 'viagem.pedagio.obter.praca', 01, 1, 1, IfThen( CIOT.AdicionarOperacao.Pedagio.ObterPraca, 'S', 'N' ) );
  AddFieldNoXml( tcStr, '', 'viagem.pedagio.obter.rota', 01, 1, 1, IfThen( CIOT.AdicionarOperacao.Pedagio.ObterRota, 'S', 'N' ) );
  AddFieldNoXml( tcStr, '', 'viagem.obter.uf', 01, 1, 1, IfThen( CIOT.AdicionarOperacao.ObterUf, 'S', 'N' ) );
  AddFieldNoXml( tcStr, '', 'viagem.obter.posto', 01, 1, 1, IfThen( CIOT.AdicionarOperacao.ObterPostos, 'S', 'N' ) );}
end;

procedure TCIOTW_Pamcard.GerarConsultaStatusParcela;
begin
  {Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'FindParcelStatus' );

  AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.MatrizCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
  AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.FilialCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.id', 01, 10, 1, CIOT.AdicionarOperacao.Id );
  AddFieldNoXml( tcInt, '', 'viagem.id.cliente', 01, 18, 1, CIOT.AdicionarOperacao.IdOperacaoCliente );
  AddFieldNoXml( tcInt, '', 'viagem.antt.ciot.numero', 01, 12, 1, CIOT.AdicionarOperacao.CIOTNumero );
  AddFieldNoXml( tcInt, '', 'viagem.parcela.numero', 01, 2, 1, CIOT.AdicionarOperacao.Parcelas.Items[0].Numero );
  AddFieldNoXml( tcInt, '', 'viagem.parcela.numero.cliente', 01, 18, 1, CIOT.AdicionarOperacao.Parcelas.Items[0].NumeroCliente );}
end;

procedure TCIOTW_Pamcard.GerarEncerrarContratoFrete;
var
  I : Integer;
begin
  with CIOT.EncerrarOperacao do
  begin
    Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'CloseFreightContract' );

    AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( MatrizCNPJ ) );

    if( OnlyNumber( FilialCNPJ ) <> '' )then
    begin
      AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 02, 1, 1 );
      AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( FilialCNPJ ) );
    end;

    AddFieldNoXml( tcStr, '', 'viagem.id.cliente', 01, 18, 0, IdOperacaoCliente );
    AddFieldNoXml( tcStr, '', 'viagem.id', 01, 10, 0, IdOperacaoIntegradora );
    AddFieldNoXml( tcStr, '', 'viagem.antt.ciot.numero', 01, 12, 0, CodigoIdentificacaoOperacao );
    AddFieldNoXml( tcDe2, '', 'viagem.frete.valor.bruto', 01, 11, 1, Frete.ValorBruto );
    AddFieldNoXml( tcInt, '', 'viagem.frete.item.qtde', 01, 02, 1, Frete.Itens.Count );

    for i := 0 to Frete.Itens.Count - 1 do
    begin
      AddFieldNoXml( tcInt, '', Format( 'viagem.frete.item%d.tipo', [i+1] ), 01, 03, 1, Frete.Itens[I].Tipo );
      AddFieldNoXml( tcDe2, '', Format( 'viagem.frete.item%d.valor', [i+1] ), 01, 17, 1, Frete.Itens[I].Valor );
    end;

    AddFieldNoXml( tcDe2, '', 'viagem.carga.peso', 01, 05, 1, PesoCarga );
  end;
end;

procedure TCIOTW_Pamcard.GerarConta(Favorecido : TPessoa);
begin
  {Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'InsertFavoredAccount' );

  AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.MatrizCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
  AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( CIOT.AdicionarOperacao.FilialCNPJ ) );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido.documento.tipo', 01, 2, 1, IfThen( Length( OnlyNumber( Favorecido.CpfOuCnpj ) ) = 11, 2, 1 ) );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido.documento.numero', 01, 20, 1, Favorecido.CpfOuCnpj );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido.conta.banco', 01, 4, 1, Favorecido.InformacoesBancarias.InstituicaoBancaria );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido.conta.agencia', 01, 10, 1, Favorecido.InformacoesBancarias.Agencia );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido.conta.agencia.digito', 01, 1, 1, Favorecido.InformacoesBancarias.DigitoAgencia );
  AddFieldNoXml( tcStr, '', 'viagem.favorecido.conta.numero', 01, 20, 1, Favorecido.InformacoesBancarias.Conta );
  AddFieldNoXml( tcInt, '', 'viagem.favorecido.conta.tipo', 01, 2, 1, Favorecido.InformacoesBancarias.TipoConta );}
end;

procedure TCIOTW_Pamcard.GerarPagamentoParcela;
var
  I : Integer;
begin
  with CIOT.AdicionarPagamento do
  begin
    Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'PayParcel' );

    AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( MatrizCNPJ ) );

    if( OnlyNumber( FilialCNPJ ) <> '' )then
    begin
      AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 02, 1, 1 );
      AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( FilialCNPJ ) );
    end;

    AddFieldNoXml( tcStr, '', 'viagem.id', 01, 10, 0, IdOperacaoIntegradora );
    AddFieldNoXml( tcStr, '', 'viagem.id.cliente', 01, 18, 0, IdOperacaoCliente );
    AddFieldNoXml( tcStr, '', 'viagem.antt.ciot.numero', 01, 12, 0, CodigoIdentificacaoOperacao );
    AddFieldNoXml( tcInt, '', 'viagem.parcela.qtde', 01, 10, 0, Pagamentos.Count );

    for i := 0 to Pagamentos.Count - 1 do
    begin
      AddFieldNoXml( tcStr, '', Format( 'viagem.parcela%d.numero', [i+1] ), 01, 02, 0, Pagamentos.Items[i].IdIntegradora );
      AddFieldNoXml( tcStr, '', Format( 'viagem.parcela%d.numero.cliente', [i+1] ), 01, 18, 0, Pagamentos.Items[i].IdPagamentoCliente );
    end;
  end;
end;

procedure TCIOTW_Pamcard.GerarPagamentoPedagio;
begin
  with CIOT.PagamentoPedagio do
  begin
    Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'PayToll' );

    AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( MatrizCNPJ ) );

    if( OnlyNumber( FilialCNPJ ) <> '' )then
    begin
      AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
      AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( FilialCNPJ ) );
    end;

    AddFieldNoXml( tcInt, '', 'viagem.id', 01, 10, 0, IdOperacaoIntegradora );
    AddFieldNoXml( tcInt, '', 'viagem.id.cliente', 01, 18, 0, IdOperacaoCliente );
    AddFieldNoXml( tcInt, '', 'viagem.antt.ciot.numero', 01, 12, 0, CodigoIdentificacaoOperacao );
  end;
end;

procedure TCIOTW_Pamcard.GerarIncluirRota;
var
  I : Integer;
begin
  with CIOT.IncluirRota do
  begin
    Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'InsertRoute' );

    AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( MatrizCNPJ ) );

    if( OnlyNumber( FilialCNPJ ) <> '' )then
    begin
      AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
      AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( FilialCNPJ ) );
    end;

    AddFieldNoXml( tcInt, '', 'viagem.rota.id.cliente', 01, 10, 0, Rota.IdCliente );
    AddFieldNoXml( tcStr, '', 'viagem.rota.nome', 01, 50, 0, Rota.Nome );

    AddFieldNoXml( tcStr, '', 'viagem.origem.pais.nome', 01, 50, 0, Rota.OrigemPaisNome );
    AddFieldNoXml( tcStr, '', 'viagem.origem.estado.nome', 01, 50, 0, Rota.OrigemEstadoNome );
    AddFieldNoXml( tcInt, '', 'viagem.origem.cidade.ibge', 01, 07, 0, Rota.OrigemCidadeIbge );
    AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.nome', 01, 50, 0, Rota.OrigemCidadeNome );
    AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.latitude', 01, 10, 0, Rota.OrigemCidadeLatitude );
    AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.longitude', 01, 10, 0, Rota.OrigemCidadeLongitude );
    AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.cep', 01, 08, 0, OnlyNumber( Rota.OrigemCidadeCep ) );
    AddFieldNoXml( tcStr, '', 'viagem.origem.eixo.indicador', 01, 01, 1, IfThen( Rota.OrigemEixoSuspenso, 'S', 'N' ) );

    AddFieldNoXml( tcStr, '', 'viagem.destino.pais.nome', 01, 50, 0, Rota.DestinoPaisNome );
    AddFieldNoXml( tcStr, '', 'viagem.destino.estado.nome', 01, 50, 0, Rota.DestinoEstadoNome );
    AddFieldNoXml( tcInt, '', 'viagem.destino.cidade.ibge', 01, 07, 0, Rota.DestinoCidadeIbge );
    AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.nome', 01, 50, 0, Rota.DestinoCidadeNome );
    AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.latitude', 01, 10, 0, Rota.DestinoCidadeLatitude );
    AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.longitude', 01, 10, 0, Rota.DestinoCidadeLongitude );
    AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.cep', 01, 08, 0, OnlyNumber( Rota.DestinoCidadeCep ) );
    AddFieldNoXml( tcStr, '', 'viagem.destino.eixo.indicador', 01, 01, 1, IfThen( Rota.DestinoEixoSuspenso, 'S', 'N' ) );

    AddFieldNoXml( tcInt, '', 'viagem.ponto.qtde', 01, 10, 0, Rota.Pontos.Count );

    for i := 0 to Rota.Pontos.Count - 1 do
    begin
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.pais.nome', [i+1] ), 01, 50, 0, Rota.Pontos.Items[I].PaisNome );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.estado.nome', [i+1] ), 01, 50, 0, Rota.Pontos.Items[I].EstadoNome );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.cidade.nome', [i+1] ), 01, 50, 0, Rota.Pontos.Items[I].CidadeNome );
      AddFieldNoXml( tcInt, '', Format( 'viagem.ponto%d.cidade.ibge', [i+1] ), 01, 50, 0, Rota.Pontos.Items[I].CidadeIbge );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.cidade.cep', [i+1] ), 01, 08, 0, OnlyNumber( Rota.Pontos.Items[I].CidadeCep ) );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.cidade.latitude', [i+1] ), 01, 10, 0, Rota.Pontos.Items[I].CidadeLatitude );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.cidade.longitude', [i+1] ), 01, 10, 0, Rota.Pontos.Items[I].CidadeLongitude );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.eixo.indicador', [i+1] ), 01, 01, 1, IfThen( Rota.Pontos.Items[I].EixoSuspenso, 'S', 'N' ) );
    end;

    AddFieldNoXml( tcStr, '', 'viagem.rota.idavolta', 01, 01, 0, IfThen( Pedagio.IdaVolta, 'S', 'N' ) );
    AddFieldNoXml( tcInt, '', 'viagem.pedagio.caminho', 01, 1, 01, Pedagio.Caminho );
  end;
end;

procedure TCIOTW_Pamcard.GerarRoteirizar;
var
  I : Integer;
begin
  with CIOT.Roterizar do
  begin
    Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'Router' );

    AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( MatrizCNPJ ) );

    if( OnlyNumber( FilialCNPJ ) <> '' )then
    begin
      AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
      AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( FilialCNPJ ) );
    end;

    AddFieldNoXml( tcStr, '', 'viagem.veiculo.categoria', 01, 3, 0, VeiculoCategoria );
    AddFieldNoXml( tcStr, '', 'viagem.veiculo.categoria.eixo.suspenso', 01, 3, 1, VeiculoCategoriaEixoSuspenso );

    AddFieldNoXml( tcInt, '', 'viagem.rota.id', 01, 10, 0, Rota.Id );
    AddFieldNoXml( tcStr, '', 'viagem.rota.nome', 01, 50, 0, Rota.Nome );

    AddFieldNoXml( tcStr, '', 'viagem.origem.pais.nome', 01, 50, 0, Rota.OrigemPaisNome );
    AddFieldNoXml( tcStr, '', 'viagem.origem.estado.nome', 01, 50, 0, Rota.OrigemEstadoNome );
    AddFieldNoXml( tcInt, '', 'viagem.origem.cidade.ibge', 01, 07, 0, Rota.OrigemCidadeIbge );
    AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.nome', 01, 50, 0, Rota.OrigemCidadeNome );
    AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.latitude', 01, 10, 0, Rota.OrigemCidadeLatitude );
    AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.longitude', 01, 10, 0, Rota.OrigemCidadeLongitude );
    AddFieldNoXml( tcStr, '', 'viagem.origem.cidade.cep', 01, 08, 0, OnlyNumber( Rota.OrigemCidadeCep ) );
    AddFieldNoXml( tcStr, '', 'viagem.origem.eixo.indicador', 01, 01, 1, IfThen( Rota.OrigemEixoSuspenso, 'S', 'N' ) );

    AddFieldNoXml( tcStr, '', 'viagem.destino.pais.nome', 01, 50, 0, Rota.DestinoPaisNome );
    AddFieldNoXml( tcStr, '', 'viagem.destino.estado.nome', 01, 50, 0, Rota.DestinoEstadoNome );
    AddFieldNoXml( tcInt, '', 'viagem.destino.cidade.ibge', 01, 07, 0, Rota.DestinoCidadeIbge );
    AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.nome', 01, 50, 0, Rota.DestinoCidadeNome );
    AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.latitude', 01, 10, 0, Rota.DestinoCidadeLatitude );
    AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.longitude', 01, 10, 0, Rota.DestinoCidadeLongitude );
    AddFieldNoXml( tcStr, '', 'viagem.destino.cidade.cep', 01, 08, 0, OnlyNumber( Rota.DestinoCidadeCep ) );
    AddFieldNoXml( tcStr, '', 'viagem.destino.eixo.indicador', 01, 01, 1, IfThen( Rota.DestinoEixoSuspenso, 'S', 'N' ) );

    AddFieldNoXml( tcInt, '', 'viagem.ponto.qtde', 01, 10, 0, Rota.Pontos.Count );

    for i := 0 to Rota.Pontos.Count - 1 do
    begin
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.pais.nome', [i+1] ), 01, 50, 0, Rota.Pontos.Items[I].PaisNome );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.estado.nome', [i+1] ), 01, 50, 0, Rota.Pontos.Items[I].EstadoNome );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.cidade.nome', [i+1] ), 01, 50, 0, Rota.Pontos.Items[I].CidadeNome );
      AddFieldNoXml( tcInt, '', Format( 'viagem.ponto%d.cidade.ibge', [i+1] ), 01, 50, 0, Rota.Pontos.Items[I].CidadeIbge );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.cidade.cep', [i+1] ), 01, 08, 0, OnlyNumber( Rota.Pontos.Items[I].CidadeCep ) );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.cidade.latitude', [i+1] ), 01, 10, 0, Rota.Pontos.Items[I].CidadeLatitude );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.cidade.longitude', [i+1] ), 01, 10, 0, Rota.Pontos.Items[I].CidadeLongitude );
      AddFieldNoXml( tcStr, '', Format( 'viagem.ponto%d.eixo.indicador', [i+1] ), 01, 01, 1, IfThen( Rota.Pontos.Items[I].EixoSuspenso, 'S', 'N' ) );
    end;

    AddFieldNoXml( tcStr, '', 'viagem.pedagio.obter.praca', 01, 01, 0, IfThen( Pedagio.ObterPraca, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.pedagio.obter.rota', 01, 01, 0, IfThen( Pedagio.ObterRota, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.pedagio.idavolta', 01, 01, 0, IfThen( Pedagio.IdaVolta, 'S', 'N' ) );
    AddFieldNoXml( tcInt, '', 'viagem.pedagio.roteirizar.tipo', 01, 01, 0, 1 );
    AddFieldNoXml( tcInt, '', 'viagem.pedagio.solucao.id', 01, 01, 0, Pedagio.SolucaoId );
    AddFieldNoXml( tcInt, '', 'viagem.pedagio.caminho', 01, 1, 01, Pedagio.Caminho );

    AddFieldNoXml( tcStr, '', 'viagem.obter.uf', 01, 01, 1, IfThen( Rota.ObterUf, 'S', 'N' ) );
    AddFieldNoXml( tcStr, '', 'viagem.obter.posto', 01, 01, 1, IfThen( Rota.ObterPostos, 'S', 'N' ) );
  end;
end;

procedure TCIOTW_Pamcard.GerarIncluirCartaoPortadorFrete;
begin
  Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'InsertCardFreight' );

  with CIOT.IncluirCartaoPortador do
  begin
    AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( MatrizCNPJ ) );

    if( OnlyNumber( FilialCNPJ ) <> '' )then
    begin
      AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 ); // 1-CNPJ
      AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( FilialCNPJ ) );
    end;

    AddFieldNoXml( tcStr, '', 'viagem.cartao.numero', 01, 16, 1, Portador.InformacoesBancarias.Cartao.Numero );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.numero.controle', 01, 10, 0, Portador.InformacoesBancarias.Cartao.NumeroControle );
    AddFieldNoXml( tcInt, '', 'viagem.cartao.portador.documento.tipo', 01, 02, 1, IfThen( Length( OnlyNumber( Portador.CpfOuCnpj ) ) = 11, 2, 1 ) ); //1-CNPJ, 2-CPF
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.documento.numero', 01, 20, 1, OnlyNumber( Portador.CpfOuCnpj ) );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.rg', 01, 17, 1, OnlyNumber( Portador.Rg ) );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.uf.rg', 01, 02, 1, Portador.RgUf );
    AddFieldNoXml( tcInt, '', 'viagem.cartao.portador.rg.emissor.id', 01, 02, 0, Portador.RgEmissorId );
    AddFieldNoXml( tcDatVcto, '', 'viagem.cartao.portador.rg.emissao.data', 01, 10, 0, Portador.RgDataEmissao );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.rntrc', 01, 14, 0, OnlyNumber( Portador.RNTRC ) );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.nome', 01, 40, 1, Portador.NomeOuRazaoSocial );
    AddFieldNoXml( tcDatVcto, '', 'viagem.cartao.portador.data.nascimento', 01, 10, 0, Portador.DataNascimento );
    AddFieldNoXml( tcInt, '', 'viagem.cartao.portador.nacionalidade.id', 01, 01, 0, Portador.NacionalidadeId );
    AddFieldNoXml( tcInt, '', 'viagem.cartao.portador.naturalidade.ibge', 01, 09, 0, Portador.NaturalidadeIbge );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.sexo', 01, 01, 0, Portador.Sexo );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.endereco.logradouro', 01, 40, 1, Portador.Endereco.Rua );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.endereco.numero', 01, 05, 1, Portador.Endereco.Numero );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.endereco.complemento', 01, 15, 0, Portador.Endereco.Complemento );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.endereco.bairro', 01, 30, 1, Portador.Endereco.Bairro );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.endereco.cidade', 01, 30, 1, Portador.Endereco.xMunicipio );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.endereco.uf', 01, 02, 1, Portador.Endereco.UF );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.endereco.pais', 01, 30, 1, Portador.Endereco.xPais );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.endereco.cep', 01, 08, 1, OnlyNumber( Portador.Endereco.CEP ) );
    AddFieldNoXml( tcInt, '', 'viagem.cartao.portador.endereco.propriedade.tipo.id', 01, 2, 0, Portador.Endereco.PropriedadeTipoId );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.endereco.reside.desde', 01, 07, 0, Portador.Endereco.ResideDesde );
    AddFieldNoXml( tcInt, '', 'viagem.cartao.portador.telefone.ddd', 03, 03, 1, Portador.Telefones.Fixo.DDD );
    AddFieldNoXml( tcInt, '', 'viagem.cartao.portador.telefone.numero', 08, 08, 1, Portador.Telefones.Fixo.Numero );
    AddFieldNoXml( tcInt, '', 'viagem.cartao.portador.celular.operadora.id', 01, 02, 0, Portador.Telefones.Celular.OperadoraID );
    AddFieldNoXml( tcInt, '', 'viagem.cartao.portador.celular.ddd', 03, 03, 0, Portador.Telefones.Celular.DDD );
    AddFieldNoXml( tcInt, '', 'viagem.cartao.portador.celular.numero', 09, 09, 0, Portador.Telefones.Celular.Numero );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.portador.email', 01, 40, 0, Portador.Email );
    AddFieldNoXml( tcStr, '', 'viagem.cartao.empresa.nome', 01, 50, 0, Portador.InformacoesBancarias.Cartao.EmpresaNome );
    AddFieldNoXml( tcInt, '', 'viagem.cartao.empresa.cnpj', 01, 14, 0, OnlyNumber( Portador.InformacoesBancarias.Cartao.EmpresaCNPJ ) );
    AddFieldNoXml( tcInt, '', 'viagem.cartao.empresa.rntrc', 01, 08, 0, OnlyNumber( Portador.InformacoesBancarias.Cartao.EmpresaRNTRC ) );
  end;
end;

procedure TCIOTW_Pamcard.GerarFavorecido;
{var
  PessoaFisica : Boolean;}
begin
  {PessoaFisica := Length( OnlyNumber( CIOT.AdicionarOperacao.Favorecido.CpfOuCnpj ) ) = 11;

  Gerador.wCampo( tcStr, '', 'context', 01, 99, 1, 'InsertFavored' );

  with CIOT do
  begin
    AddFieldNoXml( tcStr, '', 'viagem.contratante.documento.numero', 01, 20, 1, OnlyNumber( AdicionarOperacao.MatrizCNPJ ) );
    AddFieldNoXml( tcInt, '', 'viagem.unidade.documento.tipo', 01, 2, 1, 1 );
    AddFieldNoXml( tcStr, '', 'viagem.unidade.documento.numero', 01, 20, 1, OnlyNumber( AdicionarOperacao.FilialCNPJ ) );
    AddFieldNoXml( tcInt, '', 'viagem.favorecido.documento.qtde', 01, 1, 1, 1 );
    AddFieldNoXml( tcInt, '', 'viagem.favorecido.documento1.tipo', 01, 01, 2, IfThen( PessoaFisica, 2, 1) );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido.documento1.numero', 01, 20, 1, OnlyNumber( AdicionarOperacao.Favorecido.CpfOuCnpj ) );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido.documento1.uf', 01, 2, 1, AdicionarOperacao.Favorecido.UF );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido.documento1.emissor.id', 01, 2, 1, 'Não informado' );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido.documento1.emissao.data', 01, 10, 1, 'Não informado' );

    AddFieldNoXml( tcStr, '', 'viagem.favorecido.nome', 01, 60, 1, AdicionarOperacao.Favorecido.NomeOuRazaoSocial );

    if( PessoaFisica )then
      AddFieldNoXml( tcDatVcto, '', 'viagem.favorecido.data.nascimento', 01, 10, 1, AdicionarOperacao.Favorecido.DataNascimento )
    else
      AddFieldNoXml( tcStr, '', 'viagem.favorecido.data.nascimento', 01, 10, 1, 'Não informado' );

    AddFieldNoXml( tcInt, '', 'viagem.favorecido.nacionalidade.id', 01, 1, 1, 0 ); //N Obrigatorio
    AddFieldNoXml( tcInt, '', 'viagem.favorecido.naturalidade.ibge', 01, 9, 1, 0 ); //N Obrigatorio
    AddFieldNoXml( tcStr, '', 'viagem.favorecido.sexo', 01, 1, 1, AdicionarOperacao.Favorecido.Sexo );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido.endereco.logradouro', 01, 40, 1, AdicionarOperacao.Favorecido.Endereco.Rua );
    AddFieldNoXml( tcInt, '', 'viagem.favorecido.endereco.numero', 01, 5, 1, AdicionarOperacao.Favorecido.Endereco.Numero );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido.endereco.complemento', 01, 15, 1, AdicionarOperacao.Favorecido.Endereco.Complemento ); //N Obrigatorio
    AddFieldNoXml( tcStr, '', 'viagem.favorecido.endereco.bairro', 01, 30, 1, AdicionarOperacao.Favorecido.Endereco.Bairro );
    AddFieldNoXml( tcInt, '', 'viagem.favorecido.endereco.cidade.ibge', 01, 8, 1, AdicionarOperacao.Favorecido.Endereco.CodigoMunicipio );

    if( AdicionarOperacao.Favorecido.Endereco.CodigoMunicipio > 0 )then
    begin
      AddFieldNoXml( tcStr, '', 'viagem.favorecido.endereco.cidade', 01, 30, 1, 'Não informado' );
      AddFieldNoXml( tcStr, '', 'viagem.favorecido.endereco.uf', 01, 2, 1, 'Não informado' );
      AddFieldNoXml( tcStr, '', 'viagem.favorecido.endereco.pais', 01, 30, 1, 'Não informado' );
    end
    else
    begin
      AddFieldNoXml( tcStr, '', 'viagem.favorecido.endereco.cidade', 01, 30, 1, AdicionarOperacao.Favorecido.Endereco.Cidade );
      AddFieldNoXml( tcStr, '', 'viagem.favorecido.endereco.uf', 01, 2, 1, AdicionarOperacao.Favorecido.Endereco.CodigoMunicipio );
      AddFieldNoXml( tcStr, '', 'viagem.favorecido.endereco.pais', 01, 30, 1, AdicionarOperacao.Favorecido.Endereco.CodigoMunicipio );
    end;

    AddFieldNoXml( tcInt, '', 'viagem.favorecido.endereco.cep', 01, 8, 1, AdicionarOperacao.Favorecido.Endereco.CEP );
    AddFieldNoXml( tcInt, '', 'viagem.favorecido.endereco.propriedade.tipo.id', 01, 2, 1, 1 ); //N Obrigatorio
    AddFieldNoXml( tcStr, '', 'viagem.favorecido.endereco.reside.desde', 01, 7, 1, 'Não informado' );  //mm/yyyy
    AddFieldNoXml( tcStr, '', 'viagem.favorecido.telefone.ddd', 01, 3, 1, AdicionarOperacao.Favorecido.Telefones.Fixo.DDD );
    AddFieldNoXml( tcInt, '', 'viagem.favorecido.telefone.numero', 01, 8, 1, AdicionarOperacao.Favorecido.Telefones.Fixo.Numero );
    AddFieldNoXml( tcInt, '', 'viagem.favorecido.celular.operadora.id', 01, 2, 1, AdicionarOperacao.Favorecido.Telefones.Celular.OperadoraId );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido.celular.ddd', 01, 3, 1, AdicionarOperacao.Favorecido.Telefones.Celular.DDD );
    AddFieldNoXml( tcInt, '', 'viagem.favorecido.celular.numero', 01, 8, 1, AdicionarOperacao.Favorecido.Telefones.Celular.Numero );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido.email', 01, 40, 1, AdicionarOperacao.Favorecido.Email );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido1.escolaridade', 01, 2, 1, 'Não informado' );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido1.qualificacao', 01, 2, 1, 'Não informado' );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido1.estado.civil', 01, 2, 1, 'Não informado' );
    AddFieldNoXml( tcStr, '', 'viagem.favorecido1.nome.mae', 01, 60, 1, 'Não informado' );
    AddFieldNoXml( tcInt, '', 'viagem.favorecido.numDependentes', 01, 2, 1, 0 );
  end;}
end;

end.
