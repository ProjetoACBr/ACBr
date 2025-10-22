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

unit pcnRetEnvCIOT;

interface

uses
  SysUtils, Classes, pcnConversao, pcnLeitor, pcnCIOT, ACBrCIOTConversao,
  synacode, StrUtils;

type
 TRetornoEnvio = class(TPersistent)
  private
    FLeitor: TLeitor;
    FRetEnvio: TRetEnvio;
    FIntegradora: TCIOTIntegradora;
    FOperacao: TpOperacao;

    function PamcardTransformarXmlKeyValueParaTagsDiretas(const InputXML: string): string;
  public
    constructor Create;
    destructor Destroy; override;

    function LerRetorno_eFrete: Boolean;
    function LerRetorno_Repom: Boolean;
    function LerRetorno_Pamcard: Boolean;

    function LerXml: Boolean;
  published
    property Integradora: TCIOTIntegradora read FIntegradora write FIntegradora;
    property Operacao: TpOperacao read FOperacao write FOperacao;
    property Leitor: TLeitor     read FLeitor   write FLeitor;
    property RetEnvio: TRetEnvio read FRetEnvio write FRetEnvio;
  end;

implementation

{ TRetornoEnvio }

constructor TRetornoEnvio.Create;
begin
  FLeitor   := TLeitor.Create;
  FRetEnvio := TRetEnvio.Create;
end;

destructor TRetornoEnvio.Destroy;
begin
  FLeitor.Free;
  FRetEnvio.Free;

  inherited;
end;

function TRetornoEnvio.LerRetorno_eFrete: Boolean;
var
  i: Integer;
  sAux: string;
  ItemCarga: TConsultaTipoCargaCollectionItem;
begin
  Result := False;

  try
    if (leitor.rExtrai(1, 'LoginResponse') <> '') or
       (leitor.rExtrai(1, 'LogoutResponse') <> '') or

       (leitor.rExtrai(1, 'GravarResponse') <> '') or

       (leitor.rExtrai(1, 'AdicionarOperacaoTransporteResponse') <> '') or
       (leitor.rExtrai(1, 'RetificarOperacaoTransporteResponse') <> '') or
       (leitor.rExtrai(1, 'CancelarOperacaoTransporteResponse') <> '') or
       (leitor.rExtrai(1, 'ObterCodigoIdentificacaoOperacaoTransportePorIdOperacaoClienteResponse') <> '') or
       (leitor.rExtrai(1, 'ObterOperacaoTransportePdfResponse') <> '') or
       (leitor.rExtrai(1, 'AdicionarViagemResponse') <> '') or
       (leitor.rExtrai(1, 'AdicionarPagamentoResponse') <> '') or
       (leitor.rExtrai(1, 'CancelarPagamentoResponse') <> '') or
       (leitor.rExtrai(1, 'EncerrarOperacaoTransporteResponse') <> '') or
       (leitor.rExtrai(1, 'ConsultarTipoCargaResponse') <> '') or
       (leitor.rExtrai(1, 'AlterarDataLiberacaoPagamentoResponse') <> '') or
       (leitor.rExtrai(1, 'RegistrarPagamentoQuitacaoResponse') <> '') or
       (leitor.rExtrai(1, 'RegistrarQuantidadeDaMercadoriaNoDesembarqueResponse') <> '') then
    begin
      if (leitor.rExtrai(2, 'LoginResult') <> '') or
         (leitor.rExtrai(2, 'LogoutResult') <> '') or

         (leitor.rExtrai(2, 'GravarResult') <> '') or

         (leitor.rExtrai(2, 'AdicionarOperacaoTransporteResult') <> '') or
         (leitor.rExtrai(2, 'RetificarOperacaoTransporteResult') <> '') or
         (leitor.rExtrai(2, 'CancelarOperacaoTransporteResult') <> '') or
         (leitor.rExtrai(2, 'ObterCodigoIdentificacaoOperacaoTransportePorIdOperacaoClienteResult') <> '') or
         (leitor.rExtrai(2, 'ObterOperacaoTransportePdfResult') <> '') or
         (leitor.rExtrai(2, 'AdicionarViagemResult') <> '') or
         (leitor.rExtrai(2, 'AdicionarPagamentoResult') <> '') or
         (leitor.rExtrai(2, 'CancelarPagamentoResult') <> '') or
         (leitor.rExtrai(2, 'EncerrarOperacaoTransporteResult') <> '') or
         (leitor.rExtrai(2, 'ConsultarTipoCargaResult') <> '') or
         (leitor.rExtrai(2, 'AlterarDataLiberacaoPagamentoResult') <> '') or
         (leitor.rExtrai(2, 'RegistrarQuantidadeDaMercadoriaNoDesembarqueResult') <> '') or
         (leitor.rExtrai(2, 'RegistrarPagamentoQuitacaoResult') <> '') then
      begin
        with RetEnvio do
        begin
          Versao           := leitor.rCampo(tcStr, 'Versao');
          Sucesso          := leitor.rCampo(tcStr, 'Sucesso');
          ProtocoloServico := leitor.rCampo(tcStr, 'ProtocoloServico');

          Token := leitor.rCampo(tcStr, 'Token');

          PDF := leitor.rCampo(tcEsp, 'Pdf');

          if PDF <> '' then
            PDF := DecodeBase64(PDF);

          PDFNomeArquivo              := '';
          CodigoIdentificacaoOperacao := leitor.rCampo(tcStr, 'CodigoIdentificacaoOperacao');
          Data                        := leitor.rCampo(tcDatHor, 'Data');
          Protocolo                   := leitor.rCampo(tcStr, 'Protocolo');
          DataRetificacao             := leitor.rCampo(tcDatHor, 'DataRetificacao');
          QuantidadeViagens           := leitor.rCampo(tcInt, 'QuantidadeViagens');
          QuantidadePagamentos        := leitor.rCampo(tcInt, 'QuantidadePagamentos');
          IdPagamentoCliente          := leitor.rCampo(tcStr, 'IdPagamentoCliente');

          ValorLiquido                := leitor.rCampo(tcDe2, 'ValorLiquido');
          ValorQuebra                 := leitor.rCampo(tcDe2, 'ValorQuebra');
          ValorDiferencaDeFrete       := leitor.rCampo(tcDe2, 'ValorDiferencaDeFrete');

          sAux := leitor.rCampo(tcStr, 'EstadoCiot');
          EstadoCiot := ecEmViagem;
          if sAux <> '' then
            EstadoCiot := StrToEstadoCIOT(sAux);

          if (leitor.rExtrai(3, 'Proprietario') <> '') then
          begin
            Proprietario.CNPJ := leitor.rCampo(tcStr, 'CNPJ');

            sAux := leitor.rCampo(tcStr, 'TipoPessoa');
            Proprietario.TipoPessoa := tpIndefinido;
            if sAux <> '' then
              Proprietario.TipoPessoa := StrToTipoPessoa(sAux);

            Proprietario.RazaoSocial       := leitor.rCampo(tcStr, 'RazaoSocial');
            Proprietario.RNTRC             := leitor.rCampo(tcStr, 'RNTRC');

            sAux := leitor.rCampo(tcStr, 'Tipo');
            Proprietario.Tipo := tpTAC;
            if sAux <> '' then
              Proprietario.Tipo := StrToTipoProprietario(sAux);

            Proprietario.TACouEquiparado   := StrToBool(leitor.rCampo(tcStr, 'TACouEquiparado'));
            Proprietario.DataValidadeRNTRC := leitor.rCampo(tcDat, 'DataValidadeRNTRC');
            Proprietario.RNTRCAtivo        := StrToBool(leitor.rCampo(tcStr, 'RNTRCAtivo'));

            if (leitor.rExtrai(4, 'Endereco') <> '') then
            begin
              Proprietario.Endereco.Bairro          := leitor.rCampo(tcStr, 'Bairro');
              Proprietario.Endereco.Rua             := leitor.rCampo(tcStr, 'Rua');
              Proprietario.Endereco.Numero          := leitor.rCampo(tcStr, 'Numero');
              Proprietario.Endereco.Complemento     := leitor.rCampo(tcStr, 'Complemento');
              Proprietario.Endereco.CEP             := leitor.rCampo(tcStr, 'CEP');
              Proprietario.Endereco.CodigoMunicipio := leitor.rCampo(tcInt, 'CodigoMunicipio');
            end;

            if (leitor.rExtrai(4, 'Telefones') <> '') then
            begin
              if (leitor.rExtrai(5, 'Celular') <> '') then
              begin
                Proprietario.Telefones.Celular.DDD    := leitor.rCampo(tcInt, 'DDD');
                Proprietario.Telefones.Celular.Numero := leitor.rCampo(tcInt, 'Numero');
              end;

              if (leitor.rExtrai(5, 'Fixo') <> '') then
              begin
                Proprietario.Telefones.Fixo.DDD    := leitor.rCampo(tcInt, 'DDD');
                Proprietario.Telefones.Fixo.Numero := leitor.rCampo(tcInt, 'Numero');
              end;

              if (leitor.rExtrai(5, 'Fax') <> '') then
              begin
                Proprietario.Telefones.Fax.DDD    := leitor.rCampo(tcInt, 'DDD');
                Proprietario.Telefones.Fax.Numero := leitor.rCampo(tcInt, 'Numero');
              end;
            end;
          end;

          if (leitor.rExtrai(3, 'Veiculo') <> '') then
          begin
            Veiculo.Placa           := leitor.rCampo(tcStr, 'Placa');
            Veiculo.Renavam         := leitor.rCampo(tcStr, 'Renavam');
            Veiculo.Chassi          := leitor.rCampo(tcStr, 'Chassi');
            Veiculo.RNTRC           := leitor.rCampo(tcStr, 'RNTRC');
            Veiculo.NumeroDeEixos   := leitor.rCampo(tcInt, 'NumeroDeEixos');
            Veiculo.CodigoMunicipio := leitor.rCampo(tcInt, 'CodigoMunicipio');
            Veiculo.Marca           := leitor.rCampo(tcStr, 'Marca');
            Veiculo.Modelo          := leitor.rCampo(tcStr, 'Modelo');
            Veiculo.AnoFabricacao   := leitor.rCampo(tcInt, 'AnoFabricacao');
            Veiculo.AnoModelo       := leitor.rCampo(tcInt, 'AnoModelo');
            Veiculo.Cor             := leitor.rCampo(tcStr, 'Cor');
            Veiculo.Tara            := leitor.rCampo(tcInt, 'Tara');
            Veiculo.CapacidadeKg    := leitor.rCampo(tcInt, 'CapacidadeKg');
            Veiculo.CapacidadeM3    := leitor.rCampo(tcInt, 'CapacidadeM3');

            sAux := leitor.rCampo(tcStr, 'TipoRodado');
            Veiculo.TipoRodado := trNaoAplicavel;
            if sAux <> '' then
              Veiculo.TipoRodado := StrToTipoRodado(sAux);

            sAux := leitor.rCampo(tcStr, 'TipoCarroceria');
            Veiculo.TipoCarroceria := tcNaoAplicavel;
            if sAux <> '' then
              Veiculo.TipoCarroceria := StrToTipoCarroceria(sAux);
          end;

          if (leitor.rExtrai(3, 'Motorista') <> '') then
          begin
            Motorista.CPF                 := leitor.rCampo(tcStr, 'CPF');
            Motorista.Nome                := leitor.rCampo(tcStr, 'Nome');
            Motorista.CNH                 := leitor.rCampo(tcStr, 'CNH');
            Motorista.DataNascimento      := leitor.rCampo(tcDat, 'DataNascimento');
            Motorista.NomeDeSolteiraDaMae := leitor.rCampo(tcStr, 'NomeDeSolteiraDaMae');

            if (leitor.rExtrai(4, 'Endereco') <> '') then
            begin
              Motorista.Endereco.Bairro          := leitor.rCampo(tcStr, 'Bairro');
              Motorista.Endereco.Rua             := leitor.rCampo(tcStr, 'Rua');
              Motorista.Endereco.Numero          := leitor.rCampo(tcStr, 'Numero');
              Motorista.Endereco.Complemento     := leitor.rCampo(tcStr, 'Complemento');
              Motorista.Endereco.CEP             := leitor.rCampo(tcStr, 'CEP');
              Motorista.Endereco.CodigoMunicipio := leitor.rCampo(tcInt, 'CodigoMunicipio');
            end;

            if (leitor.rExtrai(4, 'Telefones') <> '') then
            begin
              if (leitor.rExtrai(5, 'Celular') <> '') then
              begin
                Motorista.Telefones.Celular.DDD    := leitor.rCampo(tcInt, 'DDD');
                Motorista.Telefones.Celular.Numero := leitor.rCampo(tcInt, 'Numero');
              end;

              if (leitor.rExtrai(5, 'Fixo') <> '') then
              begin
                Motorista.Telefones.Fixo.DDD    := leitor.rCampo(tcInt, 'DDD');
                Motorista.Telefones.Fixo.Numero := leitor.rCampo(tcInt, 'Numero');
              end;

              if (leitor.rExtrai(5, 'Fax') <> '') then
              begin
                Motorista.Telefones.Fax.DDD    := leitor.rCampo(tcInt, 'DDD');
                Motorista.Telefones.Fax.Numero := leitor.rCampo(tcInt, 'Numero');
              end;
            end;
          end;

          if leitor.rExtrai(3, 'DocumentoViagem') <> '' then
          begin
            i := 0;
            while Leitor.rExtrai(4, 'string', '', i + 1) <> '' do
            begin
              DocumentoViagem.New.Mensagem := Leitor.rCampo(tcStr, 'string');
              inc(i);
            end;
          end;

          if leitor.rExtrai(3, 'DocumentoPagamento') <> '' then
          begin
            i := 0;
            while Leitor.rExtrai(4, 'string', '', i + 1) <> '' do
            begin
              DocumentoPagamento.New.Mensagem := Leitor.rCampo(tcStr, 'string');
              inc(i);
            end;
          end;

          if leitor.rExtrai(3, 'TipoCargas') <> '' then
          begin
            i := 0;
            while Leitor.rExtrai(4, 'TipoCarga', '', i + 1) <> '' do
            begin
              ItemCarga := TipoCarga.New;

              ItemCarga.Codigo := Leitor.rCampo(tcStr, 'CodigoTipoCarga');

              sAux := leitor.rCampo(tcStr, 'DescricaoTipoCarga');
              ItemCarga.Descricao := tpNaoAplicavel;
              if sAux <> '' then
                ItemCarga.Descricao := StrToTipoCarga(sAux);

              inc(i);
            end;
          end;

          if leitor.rExtrai(3, 'AlterarDataLiberacaoPagamentoResult') <> '' then
          begin
            AlterarDataLiberacaoPagamento.CodigoIdentificacaoOperacao := leitor.rCampo(tcStr, 'CodigoIdentificacaoOperacao');
            AlterarDataLiberacaoPagamento.IdPagamentoCliente          := leitor.rCampo(tcStr, 'IdPagamentoCliente');
            AlterarDataLiberacaoPagamento.DataDeLiberacao             := leitor.rCampo(tcDat, 'DataLiberacao');
          end;

          if leitor.rExtrai(3, 'Excecao') <> '' then
          begin
            Mensagem := leitor.rCampo(tcStr, 'Mensagem');
            Codigo   := leitor.rCampo(tcStr, 'Codigo');
          end;
        end;
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TRetornoEnvio.PamcardTransformarXmlKeyValueParaTagsDiretas(const InputXML: string): string;
var
  LinhaXML, Chave, Valor, Resultado: string;
  PosKeyIni, PosKeyFim, PosValIni, PosValFim: Integer;
begin
  Resultado := '<return>';

  LinhaXML := InputXML;

  while True do
  begin
    // Encontrar chave
    PosKeyIni := Pos('<key>', LinhaXML);
    PosKeyFim := Pos('</key>', LinhaXML);
    if (PosKeyIni = 0) or (PosKeyFim = 0) then
      Break;

    Chave := Copy(LinhaXML, PosKeyIni + 5, PosKeyFim - (PosKeyIni + 5));

    // Remover até </key>
    Delete(LinhaXML, 1, PosKeyFim + 6 - 1);

    // Encontrar valor
    PosValIni := Pos('<value>', LinhaXML);
    PosValFim := Pos('</value>', LinhaXML);
    if (PosValIni = 0) or (PosValFim = 0) then
      Break;

    Valor := Copy(LinhaXML, PosValIni + 7, PosValFim - (PosValIni + 7));

    // Remover até </value>
    Delete(LinhaXML, 1, PosValFim + 8 - 1);

    // Montar nova tag
    Resultado := Resultado + Format('<%s>%s</%s>', [Chave, Valor, Chave]);
  end;

  Resultado := Resultado + '</return>';
  Result := Resultado;
end;

function TRetornoEnvio.LerRetorno_Pamcard: Boolean;
var
  i, Qtd : Integer;
begin
  Result := False;

  try
    if( leitor.rExtrai( 1, 'return' ) = '' )then
      Exit;

    leitor.Grupo := PamcardTransformarXmlKeyValueParaTagsDiretas( leitor.Grupo );

    RetEnvio.Codigo   := leitor.rCampo( tcStr, 'mensagem.codigo' );
    RetEnvio.Mensagem := leitor.rCampo( tcStr, 'mensagem.descricao' );

    if( ( RetEnvio.Codigo = '0' ) or
        ( Operacao in [ opAdicionarPagamento ] ) )then
    begin
      case Operacao of
        opIncluirCartaoPortador: begin
          RetEnvio.CartaoNumero := leitor.rCampo( tcStr, 'viagem.cartao.numero' );
        end;

        opAdicionar: begin
          RetEnvio.Digito := leitor.rCampo( tcStr, 'viagem.digito' );
          RetEnvio.Id := leitor.rCampo( tcStr, 'viagem.id' );
          RetEnvio.CodigoIdentificacaoOperacao := leitor.rCampo( tcStr, 'viagem.antt.ciot.numero' );
          RetEnvio.Protocolo := leitor.rCampo( tcStr, 'viagem.antt.ciot.protocolo' );
          RetEnvio.EstadoCiot := ecEmViagem;

          RetEnvio.Rota.Nome := leitor.rCampo( tcStr, 'viagem.rota.nome' );
          RetEnvio.Rota.DestinoCidadeNome := leitor.rCampo( tcStr, 'viagem.destino.cidade.nome' );
          RetEnvio.Rota.DestinoEstadoNome := leitor.rCampo( tcStr, 'viagem.destino.estado.nome' );
          RetEnvio.Rota.DestinoPaisNome := leitor.rCampo( tcStr, 'viagem.destino.pais.nome' );
          RetEnvio.Rota.OrigemCidadeNome := leitor.rCampo( tcStr, 'viagem.origem.cidade.nome' );
          RetEnvio.Rota.OrigemEstadoNome := leitor.rCampo( tcStr, 'viagem.origem.estado.nome' );
          RetEnvio.Rota.OrigemPaisNome := leitor.rCampo( tcStr, 'viagem.origem.pais.nome' );

          RetEnvio.Pedagio.Km := leitor.rCampo( tcDe4, 'viagem.pedagio.km' );
          RetEnvio.Pedagio.Qtde := leitor.rCampo( tcInt, 'viagem.pedagio.qtde' );
          RetEnvio.Pedagio.TempoPercurso := leitor.rCampo( tcStr, 'viagem.pedagio.tempo.percurso' );
          RetEnvio.Pedagio.Valor := leitor.rCampo( tcDe2, 'viagem.pedagio.valor' );

          Qtd := leitor.rCampo( tcInt, 'viagem.pedagio.praca.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Pedagio.Pracas.New do
              begin
                km := leitor.rCampo( tcDe4, Format( 'viagem.pedagio.praca%d.km', [i+1] ) );
                Nome := leitor.rCampo( tcStr, Format( 'viagem.pedagio.praca%d.nome', [i+1] ) );
                Seq := leitor.rCampo( tcInt, Format( 'viagem.pedagio.praca%d.seq', [i+1] ) );
                Valor := leitor.rCampo( tcDe2, Format( 'viagem.pedagio.praca%d.valor', [i+1] ) );
              end;
            end;
          end;

          Qtd := leitor.rCampo( tcInt, 'viagem.ponto.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Rota.Pontos.New do
              begin
                CidadeNome := leitor.rCampo( tcStr, Format( 'viagem.ponto%d.cidade.nome', [i+1] ) );
                EstadoNome := leitor.rCampo( tcStr, Format( 'viagem.ponto%d.estado.nome', [i+1] ) );
                PaisNome := leitor.rCampo( tcStr, Format( 'viagem.ponto%d.pais.nome', [i+1] ) );
                Km := leitor.rCampo( tcStr, Format( 'viagem.ponto%d.km', [i+1] ) );
              end;
            end;
          end;

          Qtd := leitor.rCampo( tcInt, 'viagem.uf.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Ufs.New do
              begin
                Sigla := leitor.rCampo( tcStr, Format( 'viagem.uf%d.sigla', [i+1] ) );
              end;
            end;
          end;

          Qtd := leitor.rCampo( tcInt, 'viagem.posto.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Postos.New do
              begin
                Bandeira := leitor.rCampo( tcStr, Format( 'viagem.posto%d.bandeira', [i+1] ) );
                DocumentoNumero := leitor.rCampo( tcStr, Format( 'viagem.posto%d.documento.numero', [i+1] ) );
                NomeFantasia := leitor.rCampo( tcStr, Format( 'viagem.posto%d.nomefantasia', [i+1] ) );

                Endereco.Bairro := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.bairro', [i+1] ) );
                Endereco.CEP := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.cep', [i+1] ) );
                Endereco.xMunicipio := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.cidade', [i+1] ) );
                Endereco.Complemento := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.complemento', [i+1] ) );
                Endereco.Rua := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.logradouro', [i+1] ) );
                Endereco.Numero := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.numero', [i+1] ) );
                Endereco.xPais := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.pais', [i+1] ) );
                Endereco.Uf := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.uf', [i+1] ) );
              end;
            end;
          end;
        end;

        opConsultaViagem : begin
          {RetEnvio.NumeroCartao := leitor.rCampo( tcStr, 'viagem.cartao.numero' );
          RetEnvio.CartaoPortador.NumeroDocumento := leitor.rCampo( tcStr, 'viagem.cartao.portador.documento.numero' );
          RetEnvio.CartaoPortador.TipoDocumento :=  leitor.rCampo( tcStr, 'viagem.cartao.portador.documento.tipo' );
          RetEnvio.CartaoPortador.Nome := leitor.rCampo( tcStr, 'viagem.cartao.portador.nome' );
          RetEnvio.CartaoPortador.RNTRC := leitor.rCampo( tcStr, 'viagem.cartao.portador.rntrc' );
          RetEnvio.CartaoTipo := leitor.rCampo( tcStr, 'viagem.cartao.tipo' );
          RetEnvio.ComprovacaoObs := leitor.rCampo( tcStr, 'viagem.comprovacao.observacao' );
          RetEnvio.NumeroContrato := leitor.rCampo( tcStr, 'viagem.contrato.numero' );

          RetEnvio.DataFimViagem := leitor.rCampo( tcStr, 'viagem.data.fim.viagem' );
          RetEnvio.DataInicio := leitor.rCampo( tcStr, 'viagem.data.partida' );
          RetEnvio.DataTermino := leitor.rCampo( tcStr, 'viagem.data.termino' );
          RetEnvio.Rota.DestinoCidadeNome := leitor.rCampo( tcStr, 'viagem.destino.cidade.nome' );
          RetEnvio.Rota.DestinoEstadoNome := leitor.rCampo( tcStr, 'viagem.destino.estado.nome' );
          RetEnvio.Rota.DestinoPaisNome := leitor.rCampo( tcStr, 'viagem.destino.pais.nome' );
          RetEnvio.Digito := leitor.rCampo( tcInt, 'viagem.digito' );

          Qtd := leitor.rCampo( tcInt, 'viagem.documento.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Documento.New do
              begin
                Numero := leitor.rCampo( tcDe4, Format( 'viagem.documento%d.numero', [i+1] ) );
                Tipo := leitor.rCampo( tcStr, Format( 'viagem.documento%d.tipo', [i+1] ) );
              end;
            end;
          end;

          Qtd := leitor.rCampo( tcInt, 'viagem.favorecido.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Favorecido.New do
              begin
                Cartao := leitor.rCampo( tcDe4, Format( 'viagem.favorecido%d.cartao', [i+1] ) );
                InformacoesBancarias.Agencia := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.conta.agencia', [i+1] ) );
                InformacoesBancarias.DigitoAgencia := leitor.rCampo( tcInt, Format( 'viagem.favorecido%d.conta.agencia.digito', [i+1] ) );
                InformacoesBancarias.InstituicaoBancaria := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.conta.banco', [i+1] ) );
                InformacoesBancarias.NomeInstituicaoBancaria := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.conta.banco.nome', [i+1] ) );
                InformacoesBancarias.Conta := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.conta.numero', [i+1] ) );
                InformacoesBancarias.TipoConta := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.conta.tipo', [i+1] ) );
                ResponsavelCPF := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.consumo.responsavel.cpf', [i+1] ) );
                ResponsavelNome := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.consumo.responsavel.nome', [i+1] ) );

                Qtd2 := leitor.rCampo( tcInt, 'viagem.favorecido%d.documento.qtde' );

                for J := 0 to Qtd2 - 1 do
                begin
                  with RetEnvio.Favorecido.Documentos.New do
                  begin
                    Numero := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.documento%d.numero', [i+1, j+1] ) );
                    Tipo := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.documento%d.tipo', [i+1, j+1] ) );
                  end;
                end;

                TipoPagamento := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.meio.pagamento', [i+1] ) );
                Nome := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.nome', [i+1] ) );
                Tipo := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.tipo', [i+1] ) );
              end;
            end;
          end;

          Qtd := leitor.rCampo( tcInt, 'viagem.frete.item.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Frete.Items.New do
              begin
                Tipo := leitor.rCampo( tcStr, Format( 'viagem.frete.item%d.tipo', [i+1] ) );
                Valor := leitor.rCampo( tcDe2, Format( 'viagem.frete.item%d.valor', [i+1] ) );
              end;
            end;
          end;

          RetEnvio.Frete.ValorBruto := leitor.rCampo( tcDe2, 'viagem.frete.valor.bruto' );
          RetEnvio.Frete.ValorLiquido := leitor.rCampo( tcDe2, 'viagem.frete.valor.liquido' );
          RetEnvio.Id := leitor.rCampo( tcInt, 'viagem.id' );
          RetEnvio.IdOperacaoCliente := leitor.rCampo( tcInt, 'viagem.id.cliente' );
          RetEnvio.IdProvedorCertificacao := leitor.rCampo( tcStr, 'viagem.indicador.provedor.certificacao' );
          RetEnvio.Rota.OrigemCidadeNome := leitor.rCampo( tcStr, 'viagem.origem.cidade.nome' );
          RetEnvio.Rota.OrigemEstadoNome := leitor.rCampo( tcStr, 'viagem.origem.estado.nome' );
          RetEnvio.Rota.OrigemPaisNome := leitor.rCampo( tcStr, 'viagem.origem.pais.nome' );

          Qtd := leitor.rCampo( tcInt, 'viagem.parcela.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Parcelas.Itens.New do
              begin
                Base := leitor.rCampo( tcStr, Format( 'viagem.parcela%d.base', [i+1] ) );
                Data := leitor.rCampo( tcStr, Format( 'viagem.parcela%d.data', [i+1] ) );
                EfetivacaoTipo := leitor.rCampo( tcStr, Format( 'viagem.parcela%d.efetivacao.tipo', [i+1] ) );
                FavorecidoTipoId := leitor.rCampo( tcStr, Format( 'viagem.parcela%d.favorecido.tipo.id', [i+1] ) );
                NumeroCliente := leitor.rCampo( tcStr, Format( 'viagem.parcela%d.numero.cliente', [i+1] ) );
                StatusId := leitor.rCampo( tcStr, Format( 'viagem.parcela%d.status.id', [i+1] ) );
                Tipo := leitor.rCampo( tcStr, Format( 'viagem.parcela%d.tipo', [i+1] ) );
                Valor := leitor.rCampo( tcDe2, Format( 'viagem.parcela%d.valor', [i+1] ) );
              end;
            end;
          end;

          RetEnvio.Pedagio.Caminho := leitor.rCampo( tcStr, 'viagem.pedagio.caminho' );
          RetEnvio.Pedagio.IdaVolta := leitor.rCampo( tcStr, 'viagem.pedagio.idavolta' );
          RetEnvio.Pedagio.Km := leitor.rCampo( tcDe4, 'viagem.pedagio.km' );

          Qtd := leitor.rCampo( tcInt, 'viagem.pedagio.praca.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Pedagio.Pracas.New do
              begin
                km := leitor.rCampo( tcDe4, Format( 'viagem.pedagio.praca%d.km', [i+1] ) );
                Nome := leitor.rCampo( tcStr, Format( 'viagem.pedagio.praca%d.nome', [i+1] ) );
                Seq := leitor.rCampo( tcInt, Format( 'viagem.pedagio.praca%d.seq', [i+1] ) );
                Valor := leitor.rCampo( tcDe2, Format( 'viagem.pedagio.praca%d.valor', [i+1] ) );
              end;
            end;
          end;

          RetEnvio.Pedagio.Protocolo := leitor.rCampo( tcStr, 'viagem.pedagio.protocolo' );
          RetEnvio.Pedagio.Roteirizar := leitor.rCampo( tcStr, 'viagem.pedagio.roteirizar' );
          RetEnvio.Pedagio.SolucaoId := leitor.rCampo( tcStr, 'viagem.pedagio.solucao.id' );
          RetEnvio.Pedagio.Status := leitor.rCampo( tcInt, 'viagem.pedagio.status' );
          RetEnvio.Pedagio.Tag := leitor.rCampo( tcStr, 'viagem.pedagio.tag' );
          RetEnvio.Pedagio.Valor := leitor.rCampo( tcDe2, 'viagem.pedagio.valor' );
          RetEnvio.Pedagio.ValorCarregado := leitor.rCampo( tcDe2, 'viagem.pedagio.valor.carregado' );

          Qtd := leitor.rCampo( tcInt, 'viagem.ponto.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Rota.Pontos.New do
              begin
                CidadeNome := leitor.rCampo( tcStr, Format( 'viagem.ponto%d.cidade.nome', [i+1] ) );
                EstadoNome := leitor.rCampo( tcStr, Format( 'viagem.ponto%d.estado.nome', [i+1] ) );
                PaisNome := leitor.rCampo( tcStr, Format( 'viagem.ponto%d.pais.nome', [i+1] ) );
                Km := leitor.rCampo( tcDe4, Format( 'viagem.ponto%d.km', [i+1] ) );
              end;
            end;
          end;

          Qtd := leitor.rCampo( tcInt, 'viagem.posto.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Postos.New do
              begin
                Bandeira := leitor.rCampo( tcStr, Format( 'viagem.posto%d.bandeira', [i+1] ) );
                DocumentoNumero := leitor.rCampo( tcStr, Format( 'viagem.posto%d.documento.numero', [i+1] ) );
                NomeFantasia := leitor.rCampo( tcStr, Format( 'viagem.posto%d.nomefantasia', [i+1] ) );

                Endereco.Bairro := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.bairro', [i+1] ) );
                Endereco.CEP := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.cep', [i+1] ) );
                Endereco.xMunicipio := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.cidade', [i+1] ) );
                Endereco.Complemento := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.complemento', [i+1] ) );
                Endereco.Rua := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.logradouro', [i+1] ) );
                Endereco.Numero := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.numero', [i+1] ) );
                Endereco.xPais := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.pais', [i+1] ) );
                Endereco.Uf := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.uf', [i+1] ) );
              end;
            end;
          end;

          RetEnvio.QuitacaoEntregaRessalva := leitor.rCampo( tcStr, 'viagem.quitacao.entrega.ressalva' );
          RetEnvio.QuitacaoIndicador := leitor.rCampo( tcStr, 'viagem.quitacao.indicador' );
          RetEnvio.QuitacaoPrazo := leitor.rCampo( tcInt, 'viagem.quitacao.prazo' );
          RetEnvio.Rota.Id := leitor.rCampo( tcInt, 'viagem.rota.id' );
          RetEnvio.Rota.Nome := leitor.rCampo( tcStr, 'viagem.rota.nome' );
          RetEnvio.Status := leitor.rCampo( tcInt, 'viagem.status' );

          Qtd := leitor.rCampo( tcInt, 'viagem.uf.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Ufs.New do
              begin
                Sigla := leitor.rCampo( tcStr, Format( 'viagem.uf%d.sigla', [i+1] ) );
              end;
            end;
          end;

          RetEnvio.Valor := leitor.rCampo( tcDe2, 'viagem.valor' );
          RetEnvio.Veiculo.Placa := leitor.rCampo( tcStr, 'viagem.veiculo.placa' );
          RetEnvio.Veiculo.PlacaCarreta1 := leitor.rCampo( tcStr, 'viagem.veiculo.placa.carreta1' );
          RetEnvio.Veiculo.PlacaCarreta2 := leitor.rCampo( tcStr, 'viagem.veiculo.placa.carreta2' );
          RetEnvio.Veiculo.PlacaCarreta3 := leitor.rCampo( tcStr, 'viagem.veiculo.placa.carreta3' );}
        end;

        opConsultaParcela: begin
          {RetEnvio.Parcelas.Itens[0].StatusId := leitor.rCampo( tcInt, 'viagem.parcela.status.id' );
          RetEnvio.Parcelas.Itens[0].StatusDescricao := leitor.rCampo( tcStr, 'viagem.parcela.status.descrição' );}
        end;

        opConsultarCartao: begin
          {RetEnvio.CartaoPortador.NumeroDocumento := leitor.rCampo( tcStr, 'viagem.cartao.portador.documento.numero' );
          RetEnvio.CartaoPortador.TipoDocumento :=  leitor.rCampo( tcInt, 'viagem.cartao.portador.documento.tipo' );
          RetEnvio.CartaoPortador.Nome := leitor.rCampo( tcStr, 'viagem.cartao.portador.nome' );
          RetEnvio.CartaoStatusDesc := leitor.rCampo( tcStr, 'viagem.cartao.status.descricao' );
          RetEnvio.CartaoStatusID := leitor.rCampo( tcInt, 'viagem.cartao.status.id' );
          RetEnvio.CartaoTipo := leitor.rCampo( tcStr, 'viagem.cartao.tipo' );
          RetEnvio.CartaoPortador2.NumeroDocumento := leitor.rCampo( tcStr, 'viagem.cartao.portador.documento.numero' );
          RetEnvio.CartaoPortador2.TipoDocumento :=  leitor.rCampo( tcInt, 'viagem.cartao.portador.documento.tipo' );
          RetEnvio.CartaoPortador2.Nome := leitor.rCampo( tcStr, 'viagem.cartao.portador.nome' );
          RetEnvio.CartaoDataCadastro := leitor.rCampo( tcStr, 'viagem.cartao.data.cadastro' );}
        end;

        opConsultarConta: begin
          {RetEnvio.Favorecido.Documentos.Itens[0].Tipo := leitor.rCampo( tcStr, 'viagem.favorecido.documento.tipo' );
          RetEnvio.Favorecido.Documentos.Itens[0].Numero := leitor.rCampo( tcStr, 'viagem.favorecido.documento.numero' );
          RetEnvio.Favorecido.InformacoesBancarias.Itens[0].Agencia := leitor.rCampo( tcStr, 'viagem.favorecido.conta.agencia' );
          RetEnvio.Favorecido.InformacoesBancarias.Itens[0].InstituicaoBancaria := leitor.rCampo( tcStr, 'viagem.favorecido.conta.banco' );
          RetEnvio.Favorecido.InformacoesBancarias.Itens[0].NomeInstituicaoBancaria := leitor.rCampo( tcStr, 'viagem.favorecido.conta.banco.nome' );
          RetEnvio.Favorecido.InformacoesBancarias.Itens[0].Conta := leitor.rCampo( tcStr, 'viagem.favorecido.conta.numero' );
          RetEnvio.Favorecido.InformacoesBancarias.Itens[0].Status := leitor.rCampo( tcStr, 'viagem.favorecido.conta.status' );
          RetEnvio.Favorecido.InformacoesBancarias.Itens[0].TipoConta := leitor.rCampo( tcStr, 'viagem.favorecido.conta.tipo' );
          RetEnvio.Favorecido.InformacoesBancarias.Itens[0].IndicadorPamBank := leitor.rCampo( tcStr, 'viagem.favorecido.conta.pambank.indicador' );
          RetEnvio.Favorecido.RNTRC := leitor.rCampo( tcStr, 'viagem.favorecido.rntrc.cadastro' );
          RetEnvio.Favorecido.ResponsavelFinanceiroCPF := leitor.rCampo( tcStr, 'viagem.favorecido.conta.responsavel.financeiro.cpf' );
          RetEnvio.Favorecido.ResponsavelFinanceiroNome := leitor.rCampo( tcStr, 'viagem.favorecido.conta.responsavel.financeiro.nome' );}
        end;

        opConsultarFavorecido: begin
          {Qtd := leitor.rCampo( tcInt, 'viagem.favorecido.cartao.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Favorecido.Cartao.Itens.New do
              begin
                Numero := leitor.rCampo( tcStr, Format( 'viagem.favorecido.cartao%d.numero', [i+1] ) );
                Tipo := leitor.rCampo( tcInt, Format( 'viagem.favorecido.cartao%d.tipo', [i+1] ) );
                Status := leitor.rCampo( tcStr, Format( 'viagem.favorecido.cartao%d.status', [i+1] ) );
              end;
            end;
          end;

          Qtd := leitor.rCampo( tcInt, 'viagem.favorecido.conta.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Favorecido.InformacoesBancarias.Itens.New do
              begin
                Conta := leitor.rCampo( tcStr, Format( 'viagem.favorecido.conta%d.numero', [i+1] ) );
                Agencia := leitor.rCampo( tcStr, Format( 'viagem.favorecido.conta%d.agencia', [i+1] ) );
                DigitoAgencia := leitor.rCampo( tcInt, Format( 'viagem.favorecido.conta%d.agencia.digito', [i+1] ) );
                InstituicaoBancaria := leitor.rCampo( tcStr, Format( 'viagem.favorecido.conta%d.banco', [i+1] ) );
                TipoConta := leitor.rCampo( tcStr, Format( 'viagem.favorecido.conta%d.tipo', [i+1] ) );
                Status := leitor.rCampo( tcStr, Format( 'viagem.favorecido.conta%d.status', [i+1] ) );
                IndicadorPamBank := leitor.rCampo( tcStr, Format( 'viagem.favorecido.conta%d.pambank.indicador', [i+1] ) );
              end;
            end;
          end;

          RetEnvio.Favorecido.Nome := leitor.rCampo( tcStr, 'viagem.favorecido.nome' );
          RetEnvio.Favorecido.RNTRCStatus := leitor.rCampo( tcStr, 'viagem.favorecido.status.rntrc' );
          RetEnvio.Favorecido.RNTRC := leitor.rCampo( tcStr, 'viagem.favorecido.rntrc.cadastro' );
          RetEnvio.RNTRCTipo := leitor.rCampo( tcStr, 'viagem.antt.rntrc.tipo' );
          RetEnvio.RNTRCEquiparadoTac := leitor.rCampo( tcStr, 'viagem.antt.rntrc.equiparado.tac' );
          RetEnvio.Favorecido.NumDependentes := leitor.rCampo( tcInt, 'viagem.favorecido.numDependentes' );
          RetEnvio.Favorecido.SituacaoRNTRC := leitor.rCampo( tcStr, 'viagem.favorecido.rntrc.situacao' );}
        end;

        opObterCodigoIOT: begin
          RetEnvio.Digito := leitor.rCampo( tcStr, 'viagem.digito' );
          RetEnvio.Id := leitor.rCampo( tcStr, 'viagem.id' );
          RetEnvio.CodigoIdentificacaoOperacao := leitor.rCampo( tcStr, 'viagem.antt.ciot.numero' );
          RetEnvio.Protocolo := leitor.rCampo( tcStr, 'viagem.antt.protocolo' );
          RetEnvio.Data := leitor.rCampo( tcDatVcto, 'viagem.antt.ciot.geracao.data' );
          RetEnvio.DataEncerramento := leitor.rCampo( tcDatVcto, 'viagem.antt.ciot.encerramento.data' );
          RetEnvio.ProtocoloEncerramento := leitor.rCampo( tcStr, 'viagem.antt.ciot.encerramento.protocolo' );
          RetEnvio.DataCancelamento := leitor.rCampo( tcDatVcto, 'viagem.antt.ciot.cancelamento.data' );
          RetEnvio.ProtocoloCancelamento := leitor.rCampo( tcStr, 'viagem.antt.ciot.cancelamento.protocolo' );
          RetEnvio.AvisoTransportador := leitor.rCampo( tcStr, 'viagem.antt.ciot.aviso.transportador' );

          RetEnvio.EstadoCiot := ecEmViagem;

          if( Trim( RetEnvio.ProtocoloEncerramento ) <> '' )then
            RetEnvio.EstadoCiot := ecEncerrado;

          if( Trim( RetEnvio.ProtocoloCancelamento ) <> '' )then
            RetEnvio.EstadoCiot := ecCancelado;

          (*Qtd := leitor.rCampo( tcInt, 'viagem.favorecido.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              //1-Contratado, 2-Subcontratante, 3-Motorista
              //if( leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.tipo', [i+1] ) = '1' )then


              with RetEnvio.Favorecido.New do
              begin
                Tipo := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.tipo', [i+1] ) );

                Qtd2 := leitor.rCampo( tcInt, 'viagem.favorecido%d.documento.qtde' );

                for J := 0 to Qtd2 - 1 do
                begin
                  with RetEnvio.Favorecido.Documentos.New do
                  begin
                    Numero := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.documento%d.numero', [i+1, j+1] ) );
                    Tipo := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.documento%d.tipo', [i+1, j+1] ) );
                    DataEmissao := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.documento%d.emissao.data', [i+1, j+1] ) );
                    IdEmissor := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.documento%d.emissor.id', [i+1, j+1] ) );
                    UF := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.documento%d.uf', [i+1, j+1] ) );
                  end;
                end;

                Nome := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.nome', [i+1] ) );
                DataNascimento := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.data.nascimento', [i+1] ) );
                Endereco.Logradouro := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.endereco.logradouro', [i+1] ) );
                Endereco.Numero := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.endereco.numero', [i+1] ) );
                Endereco.Bairro := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.endereco.bairro', [i+1] ) );
                Endereco.Complemento := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.endereco.complemento', [i+1] ) );
                Endereco.CEP := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.endereco.cep', [i+1] ) );
                Endereco.CidadeIBGE := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.endereco.cidade.ibge', [i+1] ) );
                Endereco.Pais := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.endereco.pais', [i+1] ) );
                Endereco.UF := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.endereco.uf', [i+1] ) );
                Endereco.Cidade := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.endereco.cidade', [i+1] ) );
                Endereco.PropriedadeTipo := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.endereco.propriedade.tipo.id', [i+1] ) );
                Endereco.ResideDesde := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.endereco.reside.desde', [i+1] ) );
                Telefones.DDD := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.telefone.ddd', [i+1] ) );
                Telefones.Numero := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.telefone.numero', [i+1] ) );
                Celular.DDD := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.celular.ddd', [i+1] ) );
                Celular.Numero := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.celular.numero', [i+1] ) );
                Celular.IdOperadora := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.celular.operadora.id', [i+1] ) );
                Email := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.email', [i+1] ) );
                Sexo := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.sexo', [i+1] ) );
                IdNacionalidade := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.nacionalidade.id', [i+1] ) );
                NaturalidadeIBGE := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.naturalidade.ibge', [i+1] ) );

                TipoPagamento := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.meio.pagamento', [i+1] ) );
                InformacoesBancarias.Agencia := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.conta.agencia', [i+1] ) );
                InformacoesBancarias.DigitoAgencia := leitor.rCampo( tcInt, Format( 'viagem.favorecido%d.conta.agencia.digito', [i+1] ) );
                InformacoesBancarias.InstituicaoBancaria := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.conta.banco', [i+1] ) );
                InformacoesBancarias.Conta := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.conta.numero', [i+1] ) );
                InformacoesBancarias.TipoConta := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.conta.tipo', [i+1] ) );
                Cartao := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.cartao', [i+1] ) );
                EmpresaNome := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.empresa.nome', [i+1] ) );
                EmpresaCNPJ := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.empresa.cnpj', [i+1] ) );
                EmpresaRNTRC := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.empresa.rntrc', [i+1] ) );

                ResponsavelCPF := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.consumo.responsavel.cpf', [i+1] ) );
                ResponsavelNome := leitor.rCampo( tcStr, Format( 'viagem.favorecido%d.consumo.responsavel.nome', [i+1] ) );
              end;
            end;
          end;*)

          RetEnvio.CodigoIdentificacaoOperacaoPrincipal := leitor.rCampo( tcStr, 'viagem.contrato.numero' );
          RetEnvio.IdOperacaoCliente := leitor.rCampo( tcStr, 'viagem.id.cliente' );
          RetEnvio.DataInicioViagem := leitor.rCampo( tcDatVcto, 'viagem.data.partida' );
          RetEnvio.DataFimViagem := leitor.rCampo( tcDatVcto, 'viagem.data.termino' );

          Qtd := leitor.rCampo( tcInt, 'viagem.veiculo.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Veiculos.New do
              begin
                Placa := leitor.rCampo( tcStr, Format( 'viagem.veiculo%d.placa', [i+1] ) );
                RNTRC := leitor.rCampo( tcStr, Format( 'viagem.veiculo%d.rntrc', [i+1] ) );
              end;
            end;
          end;

          RetEnvio.DistanciaPercorrida := leitor.rCampo( tcInt, 'viagem.distancia.km' );
          RetEnvio.CodigoTipoCarga := StrToTipoCarga( leitor.rCampo( tcInt, 'viagem.carga.tipo' ) );
          RetEnvio.CodigoNCMNaturezaCarga := leitor.rCampo( tcInt, 'viagem.carga.natureza' );
          RetEnvio.PesoCarga := leitor.rCampo( tcDe2, 'viagem.carga.peso' );
          RetEnvio.CargaPerfilId := leitor.rCampo( tcInt, 'viagem.carga.perfil.id' );
          RetEnvio.CargaValorUnitario := leitor.rCampo( tcDe2, 'viagem.carga.valorunitario' );

          (*Qtd := leitor.rCampo( tcInt, 'viagem.documento.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.DocumentoViagem.New do
              begin
                Tipo := leitor.rCampo( tcStr, Format( 'viagem.documento%d.tipo', [i+1] ) );
                Numero := leitor.rCampo( tcStr, Format( 'viagem.documento%d.numero', [i+1] ) );
                Serie := leitor.rCampo( tcStr, Format( 'viagem.documento%d.serie', [i+1] ) );
                Quantidade := leitor.rCampo( tcDe2, Format( 'viagem.documento%d.quantidade', [i+1] ) );
                Especie := leitor.rCampo( tcStr, Format( 'viagem.documento%d.especie', [i+1] ) );
                Cubagem := leitor.rCampo( tcDe3, Format( 'viagem.documento%d.cubagem', [i+1] ) );
                Natureza := leitor.rCampo( tcStr, Format( 'viagem.documento%d.natureza', [i+1] ) );
                Peso := leitor.rCampo( tcDe2, Format( 'viagem.documento%d.peso', [i+1] ) );
                ValorMercadoria := leitor.rCampo( tcDe2, Format( 'viagem.documento%d.mercadoria.valor', [i+1] ) );

                Qtd2 := leitor.rCampo( tcInt, 'viagem.documento%d.pessoafiscal.qtde' );

                for J := 0 to Qtd2 - 1 do
                begin
                  with PessoaFiscal.New do
                  begin
                    Tipo := leitor.rCampo( tcStr, Format( 'viagem.documento%d.pessoafiscal%d.tipo', [i+1, j+1] ) );
                    Codigo := leitor.rCampo( tcStr, Format( 'viagem.documento%d.pessoafiscal%d.codigo', [i+1, j+1] ) );
                    TipoDocumento := leitor.rCampo( tcStr, Format( 'viagem.documento%d.pessoafiscal%d.documento.tipo', [i+1, j+1] ) );
                    NumeroDocumento := leitor.rCampo( tcStr, Format( 'viagem.documento%d.pessoafiscal%d.documento.numero', [i+1, j+1] ) );
                    Nome := leitor.rCampo( tcStr, Format( 'viagem.documento%d.pessoafiscal%d.nome', [i+1, j+1] ) );
                    Endereco.Logradouro := leitor.rCampo( tcStr, Format( 'viagem.documento%d.pessoafiscal%d.endereco.logradouro', [i+1, j+1] ) );
                    Endereco.Numero := leitor.rCampo( tcStr, Format( 'viagem.documento%d.pessoafiscal%d.endereco.numero', [i+1, j+1] ) );
                    Endereco.Complemento := leitor.rCampo( tcStr, Format( 'viagem.documento%d.pessoafiscal%d.endereco.complemento', [i+1, j+1] ) );
                    Endereco.Bairro := leitor.rCampo( tcStr, Format( 'viagem.documento%d.pessoafiscal%d.endereco.bairro', [i+1, j+1] ) );
                    Endereco.CidadeIBGE := leitor.rCampo( tcStr, Format( 'viagem.documento%d.pessoafiscal%d.endereco.cidade.ibge', [i+1, j+1] ) );
                    Endereco.CEP := leitor.rCampo( tcStr, Format( 'viagem.documento%d.pessoafiscal%d.endereco.cep', [i+1, j+1] ) );
                  end;
                end;
              end;
            end;
          end;

          Qtd := leitor.rCampo( tcInt, 'viagem.documento.complementar.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.DocumentoComplementar.New do
              begin
                Tipo := leitor.rCampo( tcStr, Format( 'viagem.documento.complementar%d.tipo', [i+1] ) );
              end;
            end;
          end;*)

          RetEnvio.Rota.Id := leitor.rCampo( tcInt, 'viagem.rota.id' );
          RetEnvio.Rota.Nome := leitor.rCampo( tcStr, 'viagem.rota.nome' );
          RetEnvio.Rota.OrigemCidadeNome := leitor.rCampo( tcStr, 'viagem.origem.cidade.nome' );
          RetEnvio.Rota.OrigemEstadoNome := leitor.rCampo( tcStr, 'viagem.origem.estado.nome' );
          RetEnvio.Rota.OrigemPaisNome := leitor.rCampo( tcStr, 'viagem.origem.pais.nome' );
          RetEnvio.Rota.OrigemCidadeIbge := leitor.rCampo( tcInt, 'viagem.origem.cidade.ibge' );
          RetEnvio.Rota.OrigemCidadeLatitude := leitor.rCampo( tcStr, 'viagem.origem.cidade.latitude' );
          RetEnvio.Rota.OrigemCidadeLongitude := leitor.rCampo( tcStr, 'viagem.origem.cidade.longitude' );
          RetEnvio.Rota.OrigemCidadeCep := leitor.rCampo( tcStr, 'viagem.origem.cidade.cep' );

          RetEnvio.Rota.DestinoCidadeNome := leitor.rCampo( tcStr, 'viagem.destino.cidade.nome' );
          RetEnvio.Rota.DestinoEstadoNome := leitor.rCampo( tcStr, 'viagem.destino.estado.nome' );
          RetEnvio.Rota.DestinoPaisNome := leitor.rCampo( tcStr, 'viagem.destino.pais.nome' );
          RetEnvio.Rota.DestinoCidadeIbge := leitor.rCampo( tcInt, 'viagem.destino.cidade.ibge' );
          RetEnvio.Rota.DestinoCidadeLatitude := leitor.rCampo( tcStr, 'viagem.destino.cidade.latitude' );
          RetEnvio.Rota.DestinoCidadeLongitude := leitor.rCampo( tcStr, 'viagem.destino.cidade.longitude' );
          RetEnvio.Rota.DestinoCidadeCep := leitor.rCampo( tcStr, 'viagem.destino.cidade.cep' );

          Qtd := leitor.rCampo( tcInt, 'viagem.ponto.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Rota.Pontos.New do
              begin
                CidadeNome := leitor.rCampo( tcStr, Format( 'viagem.ponto%d.cidade.nome', [i+1] ) );
                EstadoNome := leitor.rCampo( tcStr, Format( 'viagem.ponto%d.estado.nome', [i+1] ) );
                PaisNome := leitor.rCampo( tcStr, Format( 'viagem.ponto%d.pais.nome', [i+1] ) );
                CidadeIBGE := leitor.rCampo( tcInt, Format( 'viagem.ponto%d.cidade.ibge', [i+1] ) );
              end;
            end;
          end;

          RetEnvio.Rota.ObterPostos := leitor.rCampo( tcStr, 'viagem.obter.postos' ) = 'S';
          RetEnvio.Rota.ObterUf := leitor.rCampo( tcStr, 'viagem.obter.uf' ) = 'S';
          RetEnvio.VeiculoCategoria := leitor.rCampo( tcStr, 'viagem.veiculo.categoria' );

          RetEnvio.Pedagio.CartaoNumero := leitor.rCampo( tcStr, 'viagem.pedagio.cartao.numero' );
          RetEnvio.Pedagio.Tag := leitor.rCampo( tcStr, 'viagem.pedagio.tag' );
          RetEnvio.Pedagio.IdaVolta := leitor.rCampo( tcStr, 'viagem.pedagio.idavolta' ) = 'S';
          RetEnvio.Pedagio.ObterPraca := leitor.rCampo( tcStr, 'viagem.pedagio.obter.praca' ) = 'S';
          RetEnvio.Pedagio.Roteirizar := leitor.rCampo( tcStr, 'viagem.pedagio.roteirizar' ) = 'S';
          RetEnvio.Pedagio.SolucaoId := leitor.rCampo( tcInt, 'viagem.pedagio.solucao.id' );
          RetEnvio.Pedagio.StatusId := leitor.rCampo( tcInt, 'viagem.pedagio.status.id' );
          RetEnvio.Pedagio.Valor := leitor.rCampo( tcDe2, 'viagem.pedagio.valor' );
          RetEnvio.Pedagio.ValorCarregado := leitor.rCampo( tcDe2, 'viagem.pedagio.valor.carregado' );
          RetEnvio.Pedagio.Protocolo := leitor.rCampo( tcStr, 'viagem.pedagio.protocolo' );

          Qtd := leitor.rCampo( tcInt, 'viagem.pedagio.praca.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Pedagio.Pracas.New do
              begin
                Id := leitor.rCampo( tcInt, Format( 'viagem.pedagio.praca%d.id', [i+1] ) );
                Valor := leitor.rCampo( tcDe2, Format( 'viagem.pedagio.praca%d.valor', [i+1] ) );
              end;
            end;
          end;

          Qtd := leitor.rCampo( tcInt, 'viagem.posto.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Postos.New do
              begin
                DocumentoNumero := leitor.rCampo( tcStr, Format( 'viagem.posto%d.documento.numero', [i+1] ) );
              end;
            end;
          end;

          RetEnvio.Frete.ValorBruto := leitor.rCampo( tcDe2, 'viagem.frete.valor.bruto' );
          RetEnvio.Frete.ValorBaseApuracao := leitor.rCampo( tcDe2, 'viagem.frete.valor.base.apuracao' );

          Qtd := leitor.rCampo( tcInt, 'viagem.frete.item.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Frete.Itens.New do
              begin
                Tipo := leitor.rCampo( tcInt, Format( 'viagem.frete.item%d.tipo', [i+1] ) );
                Valor := leitor.rCampo( tcDe2, Format( 'viagem.frete.item%d.valor', [i+1] ) );
                TarifaQuantidade := leitor.rCampo( tcInt, Format( 'viagem.frete.item%d.tarifa.quantidade', [i+1] ) );
              end;
            end;
          end;

          Qtd := leitor.rCampo( tcInt, 'viagem.parcela.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Parcelas.New do
              begin
                Data := leitor.rCampo( tcDatVcto, Format( 'viagem.parcela%d.data', [i+1] ) );
                EfetivacaoTipo := leitor.rCampo( tcInt, Format( 'viagem.parcela%d.efetivacao.tipo', [i+1] ) );
                FavorecidoTipoId := leitor.rCampo( tcInt, Format( 'viagem.parcela%d.favorecido.tipo.id', [i+1] ) );
                NumeroCliente := leitor.rCampo( tcStr, Format( 'viagem.parcela%d.numero.cliente', [i+1] ) );
                StatusId := leitor.rCampo( tcInt, Format( 'viagem.parcela%d.status.id', [i+1] ) );
                Subtipo := leitor.rCampo( tcInt, Format( 'viagem.parcela%d.tipo', [i+1] ) );
                Valor := leitor.rCampo( tcDe2, Format( 'viagem.parcela%d.valor', [i+1] ) );
              end;
            end;
          end;

          RetEnvio.Quitacao.EntregaRessalva := leitor.rCampo( tcStr, 'viagem.quitacao.entrega.ressalva' ) = 'S';
          RetEnvio.Quitacao.Indicador := leitor.rCampo( tcStr, 'viagem.quitacao.indicador' ) = 'S';
          RetEnvio.Quitacao.Prazo := leitor.rCampo( tcInt, 'viagem.quitacao.prazo' );
          RetEnvio.Quitacao.OrigemPagamento := leitor.rCampo( tcInt, 'viagem.quitacao.origem.pagamento' );
          RetEnvio.Quitacao.DescontoTipo := leitor.rCampo( tcInt, 'viagem.quitacao.desconto.tipo' );
          RetEnvio.Quitacao.DescontoTolerancia := leitor.rCampo( tcDe3, 'viagem.quitacao.desconto.tolerancia' );

          Qtd := leitor.rCampo( tcInt, 'viagem.quitacao.desconto.faixa.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Quitacao.DescontoFaixas.New do
              begin
                Ate := leitor.rCampo( tcDe3, Format( 'viagem.quitacao.desconto.faixa%d.ate', [i+1] ) );
                Percentual := leitor.rCampo( tcDe2, Format( 'viagem.quitacao.desconto.faixa%d.percentual', [i+1] ) );
              end;
            end;
          end;

          RetEnvio.DiferencaFreteCredito := leitor.rCampo( tcStr, 'viagem.diferencafrete.credito' ) = 'S';
          RetEnvio.DiferencaFreteDebito := leitor.rCampo( tcStr, 'viagem.diferencafrete.debito' ) = 'S';
          RetEnvio.DiferencaFreteTarifaMotorista := leitor.rCampo( tcDe2, 'viagem.diferencafrete.tarifamotorista' );
        end;

        opConsultarFrota: begin
          {RetEnvio.Favorecido.Nome := leitor.rCampo( tcStr, 'viagem.antt.nome' );
          RetEnvio.Favorecido.RNTRC := leitor.rCampo( tcStr, 'viagem.antt.rntrc.numero' );
          RetEnvio.RNTRCSituacao := leitor.rCampo( tcStr, 'viagem.antt.rntrc.situacao' );

          Qtd := leitor.rCampo( tcInt, 'viagem.veiculo.placa.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Veiculo.New do
              begin
                Placa := leitor.rCampo( tcStr, Format( 'viagem.veiculo%d.placa', [i+1] ) );
                Situacao := leitor.rCampo( tcStr, Format( 'viagem.veiculo%d.situacao', [i+1] ) );
              end;
            end;
          end;}
        end;

        opConsultarRNTRC: begin
          {RetEnvio.Favorecido.Nome := leitor.rCampo( tcStr, 'viagem.antt.nome' );
          RetEnvio.RNTRCSituacao := leitor.rCampo( tcStr, 'viagem.antt.rntrc.situacao' );
          RetEnvio.RNTRCValidade := leitor.rCampo( tcStr, 'viagem.antt.rntrc.validade' );
          RetEnvio.RNTRCTipo := leitor.rCampo( tcStr, 'viagem.antt.rntrc.tipo' );
          RetEnvio.RNTRCEquiparadoTac := leitor.rCampo( tcStr, 'viagem.antt.rntrc.equiparado.tac' );
          RetEnvio.Favorecido.RNTRC := leitor.rCampo( tcStr, 'viagem.antt.rntrc.numero' );}
        end;

        opConsultarTAG: begin
          {RetEnvio.Favorecido.Documentos.Itens[0].Numero := leitor.rCampo( tcStr, 'tag.favorecido.documento.numero' );
          RetEnvio.Favorecido.Documentos.Itens[0].Tipo := leitor.rCampo( tcStr, 'tag.favorecido.documento.tipo' );
          RetEnvio.Favorecido.Nome := leitor.rCampo( tcStr, 'tag. favorecido.nome' );

          Qtd := leitor.rCampo( tcInt, 'tag.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Tag.New do
              begin
                DataAdesao := leitor.rCampo( tcStr, Format( 'tag%d.adesao.data', [i+1] ) );
                StatusAdesao := leitor.rCampo( tcInt, Format( 'tag%d.adesao.status', [i+1] ) ); //1: Pendente - 2:Liberada - 3:Cancelada
                Numero := leitor.rCampo( tcStr, Format( 'tag%d.numero', [i+1] ) );
                Placa := leitor.rCampo( tcStr, Format( 'tag%d.placa', [i+1] ) );
                Status := leitor.rCampo( tcInt, Format( 'tag%d.status', [i+1] ) ); //1: Aguardando Ativação - 2:Ativa
                IndicadorValePedagio := leitor.rCampo( tcStr, Format( 'tag%d.valepedagio.indicador', [i+1] ) );
              end;
            end;
          end;}
        end;

        opEncerrar: begin
          RetEnvio.ProtocoloEncerramento := leitor.rCampo( tcStr, 'viagem.antt.ciot.encerramento.numero' );
          RetEnvio.CodigoIdentificacaoOperacao := leitor.rCampo( tcStr, 'viagem.antt.ciot.numero' );
          RetEnvio.Protocolo := leitor.rCampo( tcStr, 'viagem.antt.ciot.protocolo' );
        end;

        opAdicionarPagamento: begin
          Qtd := leitor.rCampo( tcInt, 'mensagem.parcela.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              RetEnvio.DocumentoPagamento.New.Mensagem := leitor.rCampo( tcStr, Format( 'mensagem.parcela%d.codigo', [i+1] ) ) + ' - ' +
                                                          leitor.rCampo( tcStr, Format( 'mensagem.parcela%d.descricao', [i+1] ) );
            end;
          end;
        end;

        opPagamentoPedagio: begin
          RetEnvio.Pedagio.Valor := leitor.rCampo( tcDe2, 'viagem.pedagio.valor' );
          RetEnvio.Pedagio.ValorCarregado := leitor.rCampo( tcDe2, 'viagem.pedagio.valor.carregado' );
          RetEnvio.Pedagio.Protocolo := leitor.rCampo( tcStr, 'viagem.pedagio.protocolo' );
        end;

        opIncluirRota: begin
          RetEnvio.Rota.Id := leitor.rCampo( tcStr, 'viagem.rota.id' );
        end;

        opRoteirizar: begin
          RetEnvio.Rota.OrigemCidadeNome := leitor.rCampo( tcStr, 'viagem.origem.cidade.nome' );
          RetEnvio.Rota.OrigemEstadoNome := leitor.rCampo( tcStr, 'viagem.origem.estado.nome' );
          RetEnvio.Rota.OrigemPaisNome := leitor.rCampo( tcStr, 'viagem.origem.pais.nome' );

          RetEnvio.Rota.DestinoCidadeNome := leitor.rCampo( tcStr, 'viagem.destino.cidade.nome' );
          RetEnvio.Rota.DestinoEstadoNome := leitor.rCampo( tcStr, 'viagem.destino.estado.nome' );
          RetEnvio.Rota.DestinoPaisNome := leitor.rCampo( tcStr, 'viagem.destino.pais.nome' );

          RetEnvio.Pedagio.Km := leitor.rCampo( tcDe4, 'viagem.pedagio.km' );
          RetEnvio.Pedagio.TempoPercurso := leitor.rCampo( tcStr, 'viagem.pedagio.tempo.percurso' );
          RetEnvio.Pedagio.Valor := leitor.rCampo( tcDe2, 'viagem.pedagio.valor' );

          Qtd := leitor.rCampo( tcInt, 'viagem.pedagio.pracas.quantidade' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Pedagio.Pracas.New do
              begin
                km := leitor.rCampo( tcDe4, Format( 'viagem.pedagio.praca%d.km', [i+1] ) );
                Nome := leitor.rCampo( tcStr, Format( 'viagem.pedagio.praca%d.nome', [i+1] ) );
                Seq := leitor.rCampo( tcInt, Format( 'viagem.pedagio.praca%d.seq', [i+1] ) );
                Valor := leitor.rCampo( tcDe2, Format( 'viagem.pedagio.praca%d.valor', [i+1] ) );
              end;
            end;
          end;

          Qtd := leitor.rCampo( tcInt, 'viagem.ponto.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Rota.Pontos.New do
              begin
                CidadeNome := leitor.rCampo( tcStr, Format( 'viagem.ponto%d.cidade.nome', [i+1] ) );
                EstadoNome := leitor.rCampo( tcStr, Format( 'viagem.ponto%d.estado.nome', [i+1] ) );
                PaisNome := leitor.rCampo( tcStr, Format( 'viagem.ponto%d.pais.nome', [i+1] ) );
                Km := leitor.rCampo( tcDe4, Format( 'viagem.ponto%d.km', [i+1] ) );
              end;
            end;
          end;

          Qtd := leitor.rCampo( tcInt, 'viagem.uf.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Ufs.New do
              begin
                Sigla := leitor.rCampo( tcStr, Format( 'viagem.uf%d.sigla', [i+1] ) );
              end;
            end;
          end;

          Qtd := leitor.rCampo( tcInt, 'viagem.posto.qtde' );

          if( Qtd > 0 )then
          begin
            for I := 0 to Qtd - 1 do
            begin
              with RetEnvio.Postos.New do
              begin
                Bandeira := leitor.rCampo( tcStr, Format( 'viagem.posto%d.bandeira', [i+1] ) );
                DocumentoNumero := leitor.rCampo( tcStr, Format( 'viagem.posto%d.documento.numero', [i+1] ) );
                NomeFantasia := leitor.rCampo( tcStr, Format( 'viagem.posto%d.nomefantasia', [i+1] ) );

                Endereco.Bairro := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.bairro', [i+1] ) );
                Endereco.CEP := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.cep', [i+1] ) );
                Endereco.xMunicipio := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.cidade', [i+1] ) );
                Endereco.Complemento := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.complemento', [i+1] ) );
                Endereco.Rua := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.logradouro', [i+1] ) );
                Endereco.Numero := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.numero', [i+1] ) );
                Endereco.xPais := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.pais', [i+1] ) );
                Endereco.Uf := leitor.rCampo( tcStr, Format( 'viagem.posto%d.endereco.uf', [i+1] ) );
              end;
            end;
          end;
        end;
      end;
    end;

    RetEnvio.Sucesso := IfThen( RetEnvio.Codigo = '0', 'true', 'false' );
  except
    Result := False;
  end;
end;

function TRetornoEnvio.LerRetorno_Repom: Boolean;
begin
  Result := False;

  try

    //.................. Implementar

  except
    Result := False;
  end;
end;

function TRetornoEnvio.LerXml: Boolean;
begin
  Leitor.Grupo := Leitor.Arquivo;

  case Integradora of
    ieFrete:  Result := LerRetorno_eFrete;
    iRepom:   Result := LerRetorno_Repom;
    iPamcard: Result := LerRetorno_Pamcard;
  else
    Result := False;
  end;
end;

end.

