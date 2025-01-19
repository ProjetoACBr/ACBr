{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{ - José Junior                                                                }
{ - Antônio Júnior                                                             }
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

//{$I ACBr.inc}

unit ACBrSchemasPagamentosAPI;

interface

uses
  Classes, SysUtils, ACBrAPIBase, ACBrJSON, ACBrUtil.Strings;

type

  TACBrPagamentoTipoLancamento = (
    ptlNenhum,
    ptlGPS,
    ptlGRU,
    ptlDARF,
    ptlPagamentos,
    ptlCodigoBarras,
    ptlTransferencias,
    ptlBoletos,
    ptlTrasnferenciaPix,
    ptlPix
  );

  TACBrPagamentoTipoPessoa = (
    ptpNenhum,
    ptpFisica,
    ptpJuridica
  ); 

  TACBrLoteEstadoRequisicao = (
    lerNenhum,
    lerDadosConsistentes,              // 1 - Requisição com todos os lançamentos com dados consistentes
    lerDadosInconsistentesParcial,     // 2 - Requisição com ao menos um dos lançamentos com dados inconsistentes
    lerDadosInconsistentesTotal,       // 3 - Requisição com todos os lançamentos com dados inconsistentes
    lerPendenteAcaoConveniado,         // 4 - Requisição pendente de ação pelo Conveniado - falta autorizar o pagamento
    lerEmProcessamentoBanco,           // 5 - Requisição em processamento pelo Banco
    lerProcessada,                     // 6 - Requisição Processada
    lerRejeitada,                      // 7 - Requisição Rejeitada
    lerPreparandoRemessaNaoLiberada,   // 8 - Preparando remessa não liberada
    lerLiberadaViaAPI,                 // 9 - Requisição liberada via API
    lerPreparandoRemessaLiberada       // 10 - Preparando remessa liberada
  );

  TACBrTipoContribuinte = (
    tctNenhum,
    tctCNPJ,          // 1 - CNPJ
    tctCPF,           // 2 - CPF
    tctNITPISPASEP,   // 3 - NIT/PIS/PASEP
    tctCEI,           // 4 - CEI
    tctNB,            // 6 - NB
    tctNumeroTitulo,  // 7 - N° Título
    tctDEBCAD,        // 8 - DEBCAD
    tctReferencia     // 9 - Referência
  );

  TACBrTransferenciaErro = (
    pteNenhum,
    pteAgenciaZerada,                    // 1 - Agência de crédito está zerada. Informe o nº da Agência de Crédito
    pteAgenciaNaoNumerica,               // 2 - Conta de crédito informada não é numérica. Informe apenas números
    pteDVContaNaoInformado,              // 3 - Dígito da conta de crédito não informado. Informe o DV da conta de crédito
    pteCPFNaoNumerico,                   // 4 - CPF informado não é numérico. Informe apenas números
    pteCNPJNaoNumerico,                  // 5 - CNPJ informado não é numérico. Informe apenas números
    pteDataNaoInformada,                 // 6 - Data do pagamento não informada. Informe a data do pagamento
    pteDataInvalida,                     // 7 - Data do pagamento inválida. Verifique o dado informado
    pteValorNaoNumerico,                 // 8 - Valor do pagamento informado não é númerico. Informe apenas números
    pteValorZerado,                      // 9 - Valor do pagamento está zerado. Informe o valor do pagamento
    pteCompensacaoISPBNaoInformados,     // 10 - Ambos os campos Número Compensação e Número ISPB não foram informados. Informe um dos campos
    pteCompensacaoISPBInformados,        // 11 - Ambos os campos Número Compensação e Número ISPB foram informados. Informe apenas um dos campos
    pteDOCTEDNaoInformados,              // 12 - Ambos os campos Finalidade DOC e Finalidade TED não foram informados. Informe um dos campos
    pteDOCTEDInformados,                 // 13 - Ambos os campos Finalidade DOC e Finalidade TED foram informados. Informe apenas um dos campos
    pteNumDepositoJudicialNaoInformado,  // 14 - Número de depósito judicial não informado. Informe o número do depósito judicial
    pteDVContaInvalido,                  // 15 - Digito da conta de crédito inválido. Verifique o dado informado
    pteCPFCNPJInformados,                // 16 - Ambos os campos CPF e CNPJ foram informados. Informe apenas um dos campos. Caso informado os 2 campos, nas consultas será exibido apenas os dados do CPF
    pteCPFCNPJNaoInformaos,              // 17 - Ambos os campos CPF e CNPJ não foram informados. Informe um dos campos
    pteCPFInvalido,                      // 18 - Dígito do CPF inválido. Verifique o dado informado
    pteCNPJInvalido,                     // 19 - Dígito do CNPJ inválido. Verifique o dado informado
    pteAgenciaContaIguais,               // 20 - Agência e conta de crédito estão iguais às de débito. Opção não permitida
    pteNumCompensacaoInvalido,           // 21 - Número Compensação inválido. Verifique o dado informado
    pteISPBDiferenteDeZeros,             // 22 - Número ISPB diferente de zeros. Não informe o nº ISPB
    pteContaCreditoNaoInformada,         // 23 - Conta de crédito não informada. Informe o número da conta de crédito
    pteCPFNaoInformado,                  // 24 - CPF não informado. Informe o nº do CPF
    pteCNPJNaoInformado,                 // 25 - CNPJ foi informado. Não informe CNPJ
    pteContaCreditoInformada,            // 26 - Conta de crédito foi informada. Não informe Conta de crédito
    pteDVCreditoInformado,               // 27 - Dígito da conta de crédito foi informado. Não informe dígito da conta de crédito
    pteFinalidadeDOCInformada,           // 28 - Finalidade do DOC foi informada. Não informe finalidade do DOC
    pteFinalidadeTEDInformada,           // 29 - Finalidade da TED foi informada. Não informe finalidade da TED
    pteNumDepositoJudicialInformado,     // 30 - Número Depósito Judicial informado. Não informe finalidade Depósito Judicial
    pteDocumentoCreditoNaoNumerico,      // 31 - Número do documento de crédito informado não é numérico. Informe apenas números
    pteDocumentoDebitoNaoNumerico,       // 32 - Número do documento de débito não é numérico. Informe apenas números
    pteCPFNaoEncontrado,                 // 33 - CPF não encontrado na base da receita federal. Verifique o dado informado
    pteCNPJNaoEncontrado,                // 34 - CNPJ não encontrado na base da receita federal. Verifique o dado informado
    pteContaPoupancaNaoPermitida,        // 35 - Conta poupança não permitido para "Pagamento ao Fornecedor". Para creditar em conta poupança utilize o recurso para efetivação de "Pagamentos Diversos"
    pteCOMPEDeveSer1,                    // 36 - Código COMPE deve ser igual a 1
    pteISPBDeveSer0,                     // 37 - Código ISPB deve ser igual a 0
    pteCodBarrasNaoNumerio,              // 38 - Código de barras não é numérico. Informe apenas números
    pteCodBarrasIgualZeros,              // 39 - Código de barras igual a zeros. Informe apenas números
    pteNumInscricaoNaoNumerico,          // 40 - Número de inscrição do pagador não é numérico. Informe apenas números
    pteInscricaoBeneficiarioNaoNumerico, // 41 - Número de inscrição do beneficiário não é numérico. Informe apenas números
    pteInscricaoAvalistaNaoNumerico,     // 42 - Número de inscrição do avalista não é numérico. Informe apenas números
    pteDVCPFPagadorInvalido,             // 43 - Digito do CPF para o pagador inválido. Verifique o dado informado
    pteDVCPFBeneficiarioInvalido,        // 44 - Digito do CPF para o beneficiário inválido. Verifique o dado informado
    pteDVCPFAvalistaInvalido,            // 45 - Digito do CPF para o avalista inválido. Verifique o dado informado
    pteDVCNPJPagadorInvalido,            // 46 - Digito do CNPJ para o pagador inválido. Verifique o dado informado
    pteDVCNPJBeneficiarioInvalido,       // 47 - Digito do CNPJ para o beneficiário inválido. Verifique o dado informado
    pteDVCNPJAvalistaInvalido,           // 48 - Digito do CNPJ para o avalista inválido.Verifique o dado informado
    pteDataVencimentoInvalida,           // 49 - Data do vencimento inválida. Verifique o dado informado
    pteValorNominalNaoNumerico,          // 50 - Valor nominal não é numérico. Informe apenas números
    pteValorDescontoNaoNumerico,         // 51 - Valor de desconto não é numérico. Informe apenas números
    pteValorMoraNaoNumerico,             // 52 - Valor de mora não é numérico. Informe apenas números
    pteDataPagamentoMenorAtual,          // 53 - Data do pagamento deve ser maior ou igual ao dia atual
    pteDocDebitoNaoInformado,            // 54 - Número do documento de débito não informado. Informe o nº do doc de débito
    pteDataVencimentoNaoInformada,       // 55 - Data do vencimento não informada. Informe a data de vencimento
    pteNomeBeneficiarioNaoInformado,     // 56 - Nome do beneficiário não informado. Informe o nome do beneficiário
    pteInscricaoBeneficiarioNaoInformada,// 57 - Número de inscrição do beneficiário não informado. Informe o CPF ou o CNPJ do beneficiário
    pteContaPagamentoInformada,          // 58 - Conta pagamento foi informada. Não informe conta pagamento
    pteContaCreditoPagamentoInformada,   // 59 - Ambos os campos conta de crédito e conta pagamento foram informados. Informe apenas um dos campos
    pteConsultarBancoErro,               // 99 - Consultar o Banco para detalhar o erro
    pteInsuficienciaFundos,              // 200 - Insuficiência de Fundos - Débito Não Efetuado
    pteCreditoDebitoCancelado,           // 201 - Crédito ou Débito Cancelado pelo Pagador
    pteDebitoAutorizado,                 // 202 - Débito Autorizado pela Agência - Efetuado
    pteControleInvalido,                 // 203 - Controle Inválido. Verificar campos 01, 02 e 03 do header ou segmento A, B, C, J, J52, N, O ou W do Arquivo CNAB240.
    pteTipoOperacaoInvalido,             // 204 - Tipo de Operação Inválido. Verificar campo 04.1 do header de lote. Valor default = "C"
    pteTipoServicoInvalido,              // 205 - Tipo de Serviço Inválido. Utilize 20 para Pagamento a Fornecedores, 30 Pagamento de Salários ou 98 Pagamentos Diversos no header de Lote, campo 05.1, do CNAB240
    pteFormaLancamentoInvalida,          // 206 - Forma de Lançamento Inválida. Para crédito em Poupança utilize Pagamentos Diversos. Para crédito em Conta Pagamento utilize Pagamentos Diversos ou Pagamento a Fornecedores. Para Pagamento de salário a conta de crédito deve ser do BB.
    pteTipoNumeroInscricaoInvalido,      // 207 - Tipo/Número de Inscrição Inválido. CPF ou CNPJ inválido. Verifique dados informados.
    pteCodigoConvenioInvalido,           // 208 - Código de Convênio Inválido. Verifique dados informados.
    pteAgenciaContaCorrenteDVInvalido,   // 209 - Agência/Conta Corrente/DV Inválido. Verifique dados informados.
    pteNumeroSequencialRegistroInvalido, // 210 - Nº Seqüencial do Registro no Lote Inválido. Verifique dado informado.
    pteCodigoSegmentoDetalheInvalido,    // 211 - Código de Segmento de Detalhe Inválido. Verifique dado informado.
    pteLancamentoInconsistente,          // 212 - Lançamento inconsistente, rejeitado na prévia. Corrigir os dados do lançamento e enviar novo pagamento.
    pteNumeroCompeBancoCreditoInvalido,  // 213 - Nº Compe do Banco para crédito Inválido. Verifique dado informado.
    pteNumeroISPBInvalido,               // 214 - Nº do ISPB Banco, Instituição de Pagamento para crédito Inválido. Verifique dado informado.
    pteAgenciaMantenedoraInvalida,       // 215 - Agência Mantenedora da Conta Corrente do Favorecido Inválida. Verifique dado informado.
    pteContaCorrenteDVInvalido,          // 216 - Conta Corrente/DV/Conta de Pagamento do Favorecido Inválido. Verifique dado informado.
    pteNomeFavorecidoNaoInformado,       // 217 - Nome do Favorecido não Informado. Informe o nome do favorecido.
    pteDataLancamentoInvalida,           // 218 - Data Lançamento Inválido. Verifique dado informado.
    pteTipoQuantidadeMoedaInvalida,      // 219 - Tipo/Quantidade da Moeda Inválido. Verifique dado informado.
    pteValorLancamentoInvalido,          // 220 - Valor do Lançamento Inválido. Verifique dado informado.
    pteAvisoFavorecidoIdentificacaoInvalida, // 221 - Aviso ao Favorecido - Identificação Inválida.
    pteTipoNumeroInscricaoFavorecidoInvalido, // 222 - Tipo/Número de Inscrição do Favorecido Inválido CPF ou CNPJ do favorecido inválido. Arquivo: Verifique o campo 07.3B - registro detalhe do segmento B.
    pteLogradouroFavorecidoNaoInformado, // 223 - Logradouro do Favorecido não Informado. Informe o logradouro do favorecido.
    pteNumeroLocalFavorecidoNaoInformado,// 224 - Nº do Local do Favorecido não Informado. Informe o nº do local do favorecido.
    pteCidadeFavorecidoNaoInformada,     // 225 - Cidade do Favorecido não Informada. Informe a cidade do favorecido.
    pteCEPFavorecidoInvalido,            // 226 - CEP/Complemento do Favorecido Inválido. Verifique dado informado.
    pteSiglaEstadoFavorecidoInvalida,    // 227 - Sigla do Estado do Favorecido Inválida. Verifique dado informado.
    pteNumeroBancoCreditoInvalido,       // 228 - Nº do Banco para crédito Inválido. Verifique dado informado.
    pteCodigoNomeAgenciaDepositariaNaoInformado, // 229 - Código/Nome da Agência Depositária não Informado. Informe o dado solicitado.
    pteSeuNumeroInvalido,                // 230 - Seu Número Inválido. Verifique dado informado.
    pteNossoNumeroInvalido,              // 231 - Nosso Número Inválido. Verifique dado informado.
    pteInclusaoEfetuadaSucesso,          // 232 - Inclusão Efetuada com Sucesso
    pteAlteracaoEfetuadaSucesso,         // 233 - Alteração Efetuada com Sucesso
    pteExclusaoEfetuadaSucesso,          // 234 - Exclusão Efetuada com Sucesso
    pteAgenciaContaImpedidaLegalmente,   // 235 - Agência/Conta Impedida Legalmente
    pteEmpresaNaoPagouSalario,           // 236 - Empresa não pagou salário Conta de crédito só aceita pagamento de salário.
    pteFalecimentoMutuario,              // 237 - Falecimento do mutuário.
    pteEmpresaNaoEnviouRemessaMutuario,  // 238 - Empresa não enviou remessa do mutuário
    pteEmpresaNaoEnviouRemessaVencimento,// 239 - Empresa não enviou remessa no vencimento
    pteValorParcelaInvalida,             // 240 - Valor da parcela inválida. Verifique dado informado.
    pteIdentificacaoContratoInvalida,    // 241 - Identificação do contrato inválida. Verifique dado informado.
    pteOperacaoConsignacaoIncluidaSucesso, // 242 - Operação de Consignação Incluída com Sucesso
    pteOperacaoConsignacaoAlteradaSucesso, // 243 - Operação de Consignação Alterada com Sucesso
    pteOperacaoConsignacaoExcluidaSucesso, // 244 - Operação de Consignação Excluída com Sucesso
    pteOperacaoConsignacaoLiquidadaSucesso, // 245 - Operação de Consignação Liquidada com Sucesso
    pteReativacaoEfetuadaSucesso,        // 246 - Reativação Efetuada com Sucesso
    pteSuspensaoEfetuadaSucesso,         // 247 - Suspensão Efetuada com Sucesso
    pteCodigoBarrasBancoInvalido,        // 248 - Código de Barras - Código do Banco Inválido.
    pteCodigoBarrasMoedaInvalido,        // 249 - Código de Barras - Código da Moeda Inválido
    pteCodigoBarrasDigitoVerificadorInvalido, // 250 - Código de Barras - Dígito Verificador Geral Inválido
    pteCodigoBarrasValorTituloInvalido,  // 251 - Código de Barras - Valor do Título Inválido
    pteCodigoBarrasCampoLivreInvalido,   // 252 - Código de Barras - Campo Livre Inválido
    pteValorDocumentoInvalido,           // 253 - Valor do Documento Inválido. Verifique dado informado.
    pteValorAbatimentoInvalido,          // 254 - Valor do Abatimento Inválido. Verifique dado informado.
    pteValorDescontoInvalido,            // 255 - Valor do Desconto Inválido. Verifique dado informado.
    pteValorMoraInvalido,                // 256 - Valor de Mora Inválido. Verifique dado informado.
    pteValorMultaInvalido,               // 257 - Valor da Multa Inválido. Verifique dado informado.
    pteValorIRInvalido,                  // 258 - Valor do IR Inválido. Verifique dado informado.
    pteValorISSInvalido,                 // 259 - Valor do ISS Inválido. Verifique dado informado.
    pteValorIOFInvalido,                 // 260 - Valor do IOF Inválido. Verifique dado informado.
    pteValorOutrasDeducoesInvalido,      // 261 - Valor de Outras Deduções Inválido. Verifique dado informado.
    pteValorOutrosAcrescimosInvalido,    // 262 - Valor de Outros Acréscimos Inválido. Verifique dado informado.
    pteValorINSSInvalido,                // 263 - Valor do INSS Inválido. Verifique dado informado.
    pteLoteNaoAceito,                    // 264 - Lote Não Aceito. Reenvie os documentos.
    pteInscricaoEmpresaInvalidaContrato, // 265 - Inscrição da Empresa Inválida para o Contrato
    pteConvenioEmpresaInexistenteContrato, // 266 - Convênio com a Empresa Inexistente/Inválido para o Contrato
    pteAgenciaContaCorrenteEmpresaInexistenteContrato, // 267 - Agência/Conta Corrente da Empresa Inexistente/Inválido para o Contrato. Verifique dado informado.
    pteTipoServicoInvalidoContrato,      // 268 - Tipo de Serviço Inválido para o Contrato. Para contrato de Pagamentos, utilize 20 para Pagamento a Fornecedores, 30 Pagamento de Salários ou 98 Pagamentos Diversos no header de Lote, campo 05.1, do CNAB240
    pteContaCorrenteSaldoInsuficiente,   // 269 - Conta Corrente da Empresa com Saldo Insuficiente.
    pteLoteServicoForaSequencia,         // 270 - Lote de Serviço Fora de Seqüência
    pteLoteServicoInvalido,              // 271 - Lote de Serviço Inválido
    pteArquivoNaoAceito,                 // 272 - Arquivo não aceito
    pteTipoRegistroInvalido,             // 273 - Tipo de Registro Inválido
    pteCodigoRemessaRetornoInvalido,     // 274 - Código Remessa / Retorno Inválido
    pteVersaoLayoutInvalida,             // 275 - Versão de layout inválida
    pteMutuarioNaoIdentificado,          // 276 - Mutuário não identificado
    pteTipoBeneficioNaoPermiteEmprestimo, // 277 - Tipo do beneficio não permite empréstimo
    pteBeneficioCessadoSuspenso,         // 278 - Beneficio cessado/suspenso
    pteBeneficioPossuiRepresentanteLegal, // 279 - Beneficio possui representante legal
    pteBeneficioTipoPA,                  // 280 - Beneficio é do tipo PA (Pensão alimentícia)
    pteQuantidadeContratosExcedida,      // 281 - Quantidade de contratos permitida excedida
    pteBeneficioNaoPertenceBanco,        // 282 - Beneficio não pertence ao Banco informado
    pteInicioDescontoUltrapassado,       // 283 - Início do desconto informado já ultrapassado
    pteNumeroParcelaInvalida,            // 284 - Número da parcela inválida. Verifique dado informado.
    pteQuantidadeParcelaInvalida,        // 285 - Quantidade de parcela inválida. Verifique dado informado.
    pteMargemConsignavelExcedidaPrazo,   // 286 - Margem consignável excedida para o mutuário dentro do prazo do contrato. Verifique suas margens disponíveis.
    pteEmprestimoJaCadastrado,           // 287 - Empréstimo já cadastrado
    pteEmprestimoInexistente,            // 288 - Empréstimo inexistente
    pteEmprestimoJaEncerrado,            // 289 - Empréstimo já encerrado
    pteArquivoSemTrailer,                // 290 - Arquivo sem trailer
    pteMutuarioSemCreditoCompetencia,    // 291 - Mutuário sem crédito na competência
    pteNaoDescontadoOutrosMotivos,       // 292 - Não descontado – outros motivos
    pteRetornoCreditoNaoPago,            // 293 - Retorno de Crédito não pago
    pteCancelamentoEmprestimoRetroativo, // 294 - Cancelamento de empréstimo retroativo
    pteOutrosMotivosGlosa,               // 295 - Outros Motivos de Glosa
    pteMargemConsignavelExcedidaAcimaPrazo, // 296 - Margem consignável excedida para o mutuário acima do prazo do contrato
    pteMutuarioDesligadoEmpregador,      // 297 - Mutuário desligado do empregador. Pagamento não permitido.
    pteMutuarioAfastadoLicenca,          // 298 - Mutuário afastado por licença. Pagamento não permitido.
    ptePrimeiroNomeMutuarioDiferente,    // 299 - Primeiro nome do mutuário diferente do primeiro nome do movimento do censo ou diferente da base de Titular do Benefício. Verificar necessidade de ajustes.
    pteBeneficioSuspensoCessadoAPS,      // 300 - Benefício suspenso/cessado pela APS ou Sisobi
    pteBeneficioSuspensoDependenciaCalculo, // 301 - Benefício suspenso por dependência de cálculo
    pteBeneficioSuspensoCessadoInspetoria, // 302 - Benefício suspenso/cessado pela inspetoria/auditoria
    pteBeneficioBloqueadoEmprestimoBeneficiario, // 303 - Benefício bloqueado para empréstimo pelo beneficiário
    pteBeneficioBloqueadoEmprestimoTBM,  // 304 - Benefício bloqueado para empréstimo por TBM
    pteBeneficioFaseConcessaoPA,         // 305 - Benefício está em fase de concessão de PA ou desdobramento.
    pteBeneficioCessadoObito,            // 306 - Benefício cessado por óbito.
    pteBeneficioCessadoFraude,           // 307 - Benefício cessado por fraude.
    pteBeneficioCessadoOutroBeneficio,   // 308 - Benefício cessado por concessão de outro benefício.
    pteBeneficioCessadoEstatutario,      // 309 - Benefício cessado: estatutário transferido para órgão de origem.
    pteEmprestimoSuspensoAPS,            // 310 - Empréstimo suspenso pela APS.
    pteEmprestimoCanceladoBanco,         // 311 - Empréstimo cancelado pelo banco.
    pteCreditoTransformadoPAB,           // 312 - Crédito transformado em PAB.
    pteTerminoConsignacaoAlterado,       // 313 - Término da consignação foi alterado.
    pteFimEmprestimoPeriodoSuspensao,    // 314 - Fim do empréstimo ocorreu durante período de suspensão ou concessão.
    pteEmprestimoSuspensoBanco,          // 315 - Empréstimo suspenso pelo banco.
    pteNaoAverbacaoContratoQuantidadeParcelas, // 316 - Não averbação de contrato – quantidade de parcelas/competências informadas ultrapassou a data limite da extinção de cota do dependente titular de benefícios
    pteLoteNaoAceitoTotaisDiferenca,     // 317 - Lote Não Aceito - Totais do Lote com Diferença
    pteTituloNaoEncontrado,              // 318 - Título Não Encontrado
    pteIdentificadorRegistroOpcionalInvalido, // 319 - Identificador Registro Opcional Inválido. Verifique dado informado.
    pteCodigoPadraoInvalido,             // 320 - Código Padrão Inválido. Verifique dado informado.
    pteCodigoOcorrenciaInvalido,         // 321 - Código de Ocorrência Inválido. Verifique dado informado.
    pteComplementoOcorrenciaInvalido,    // 322 - Complemento de Ocorrência Inválido. Verifique dado informado.
    pteAlegacaoJaInformada,              // 323 - Alegação já Informada
    pteAgenciaContaFavorecidoSubstituida, // 324 - Agência / Conta do Favorecido Substituída. Verifique dado informado.
    pteDivergenciaNomeBeneficiario,      // 325 - Divergência entre o primeiro e último nome do beneficiário versus primeiro e último nome na Receita Federal. Verificar com beneficiário necessidade de ajustes.
    pteConfirmacaoAntecipacaoValor,      // 326 - Confirmação de Antecipação de Valor
    pteAntecipacaoParcialValor,          // 327 - Antecipação parcial de valor
    pteBoletoBloqueadoBase,              // 328 - Boleto bloqueado na base. Não passível de pagamento.
    pteSistemaContingenciaBoletoValorMaior, // 329 - Sistema em contingência – Boleto valor maior que referência. Consulte o beneficiário ou tente efetuar o pagamento mais tarde.
    pteSistemaContingenciaBoletoVencido, // 330 - Sistema em contingência – Boleto vencido. Consulte o beneficiário ou tente efetuar o pagamento mais tarde.
    pteSistemaContingenciaBoletoIndexado, // 331 - Sistema em contingência – Boleto indexado. Consulte o beneficiário ou tente efetuar o pagamento mais tarde.
    pteBeneficiarioDivergente,           // 332 - Beneficiário divergente. Verifique dado informado.
    pteLimitePagamentosParciaisExcedido, // 333 - Limite de pagamentos parciais do boleto excedido. Consulte o Beneficiário do boleto.
    pteBoletoJaLiquidado,                // 334 - Boleto já liquidado. Não passível de pagamento.
    pteConsultarBancoDetalharErro        // 999 - Consultar o Banco para detalhar o erro.
  );

  { TACBrPagamentosErroOAuth }

  TACBrPagamentosErroOAuth = class(TACBrAPISchema)
  private
    ferror: String;
    fmessage: String;
    fstatusCode: Integer;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    procedure Assign(aSource: TACBrPagamentosErroOAuth);
    function IsEmpty: Boolean; override;

    property statusCode: Integer read fstatusCode write fstatusCode;
    property error: String read ferror write ferror;
    property message: String read fmessage write fmessage;
  end;

  { TACBrPagamentosAPIErro }

  TACBrPagamentosAPIErro = class(TACBrAPISchema)
  private
    fcodigo: String;
    fmensagem: String;
    focorrencia: String;
    fversao: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(aSource: TACBrPagamentosAPIErro);

    property codigo: String read fcodigo write fcodigo;
    property versao: String read fversao write fversao;
    property mensagem: String read fmensagem write fmensagem;
    property ocorrencia: String read focorrencia write focorrencia;
  end;

  { TACBrPagamentosAPIErros }

  TACBrPagamentosAPIErros = class(TACBrAPISchemaArray)
  private 
    fOAuthError: TACBrPagamentosErroOAuth;
    function GetItem(aIndex: Integer): TACBrPagamentosAPIErro;
    function GetOAuthError: TACBrPagamentosErroOAuth;
    procedure SetItem(aIndex: Integer; aValue: TACBrPagamentosAPIErro);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aItem: TACBrPagamentosAPIErro): Integer;
    procedure Insert(aIndex: Integer; aItem: TACBrPagamentosAPIErro);
    function New: TACBrPagamentosAPIErro;
    function IsOAuthError: Boolean;
              
    property OAuthError: TACBrPagamentosErroOAuth read GetOAuthError write fOAuthError;
    property Items[aIndex: Integer]: TACBrPagamentosAPIErro read GetItem write SetItem; default;
  end;

  { TACBrTransferenciaErroObject }

  TACBrTransferenciaErroObject = class(TACBrAPISchema)
  private
    fErro: TACBrTransferenciaErro;
  public
    property Erro: TACBrTransferenciaErro read fErro write fErro;
  end;

  { TACBrTransferenciaErros }

  TACBrTransferenciaErros = class(TACBrAPISchemaArray)
  private
    function GetItem(aIndex: Integer): TACBrTransferenciaErroObject;
    procedure SetItem(aIndex: Integer; aValue: TACBrTransferenciaErroObject);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aItem: TACBrTransferenciaErroObject): Integer;
    procedure Insert(aIndex: Integer; aItem: TACBrTransferenciaErroObject);
    function New: TACBrTransferenciaErroObject;
    procedure ReadFromJSon(AJSon: TACBrJSONObject); override;
    procedure WriteToJSon(AJSon: TACBrJSONObject); override;

    property Items[aIndex: Integer]: TACBrTransferenciaErroObject read GetItem write SetItem; default;
  end;

  { TACBrLancamentoClass }

  TACBrLancamentoClass = class(TACBrAPISchema)
  private
    fcodigoBarras: String;
    fcodigoIdentificadorPagamento: Int64;
    fcodigoIdentificadorTributoGuiaPrevidenciaSocial: String;
    fcodigoReceitaTributoGuiaPrevidenciaSocial: Integer;
    fcodigoTipoContribuinteGuiaPrevidenciaSocial: TACBrTipoContribuinte;
    fdataVencimento: TDateTime;
    ferrorCodes: TACBrTransferenciaErros;
    ferrors: TACBrTransferenciaErros;
    ferros: TACBrTransferenciaErros;
    fidContribuinte: Int64;
    fidPagamento: Int64;
    findicadorAceite: String;
    findicadorMovimentoAceito: String;
    fmesAnoCompetencia: Integer;
    fmesAnoCompetenciaGuiaPrevidenciaSocial: Integer;
    fnomeAvalista: String;
    fnomeBeneficiario: String;
    fnomeConvenente: String;
    fnomePagador: String;
    fnomeRecebedor: String;
    fnumeroDocumentoDebito: Integer;
    fnumeroCodigoBarras: String;
    fdataPagamento: TDateTime;
    fnumeroIdentificacaoContribuinteGuiaPrevidenciaSocial: Integer;
    fnumeroReferencia: String;
    ftextoDescricaoPagamento: String;
    ftextoPagamento: String;
    fvalorAtualizacaoMonetarioGuiaPrevidenciaSocial: Double;
    fvalorJuroEncargo: Double;
    fvalorMulta: Double;
    fvalorOutraDeducao: Double;
    fvalorOutroAcrescimo: Double;
    fvalorOutroEntradaGuiaPrevidenciaSocial: Double;
    fvalorOutrosAcrescimos: Double;
    fvalorPagamento: Double;
    fdescricaoPagamento: String;
    fcodigoSeuDocumento: String;
    fcodigoNossoDocumento: String;
    fvalorNominal: Double;
    fvalorDesconto: Double;
    fvalorMoraMulta: Double;
    fcodigoTipoPagador: TACBrPagamentoTipoPessoa;
    fdocumentoPagador: String;
    fcodigoTipoBeneficiario: TACBrPagamentoTipoPessoa;
    fdocumentoBeneficiario: String;
    fcodigoTipoAvalista: TACBrPagamentoTipoPessoa;
    fdocumentoAvalista: String;
    fvalorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial: Double;
    fvalorPrincipal: Double;
    function GeterrorCodes: TACBrTransferenciaErros;
    function Geterrors: TACBrTransferenciaErros;
    function Geterros: TACBrTransferenciaErros;
  protected
    procedure AssignSchema(ASource: TACBrAPISchema); override;
    procedure DoWriteToJSon(AJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(AJSon: TACBrJSONObject); override;

    // Boletos
    property codigoIdentificadorPagamento: Int64 read fcodigoIdentificadorPagamento write fcodigoIdentificadorPagamento;
    property codigoBarras: String read fcodigoBarras write fcodigoBarras;
    property numeroDocumentoDebito: Integer read fnumeroDocumentoDebito write fnumeroDocumentoDebito;
    property numeroCodigoBarras: String read fnumeroCodigoBarras write fnumeroCodigoBarras;
    property dataPagamento: TDateTime read fdataPagamento write fdataPagamento;
    property valorPagamento: Double read fvalorPagamento write fvalorPagamento;
    property descricaoPagamento: String read fdescricaoPagamento write fdescricaoPagamento;
    property codigoSeuDocumento: String read fcodigoSeuDocumento write fcodigoSeuDocumento;
    property codigoNossoDocumento: String read fcodigoNossoDocumento write fcodigoNossoDocumento;
    property valorNominal: Double read fvalorNominal write fvalorNominal;
    property valorDesconto: Double read fvalorDesconto write fvalorDesconto;
    property valorMoraMulta: Double read fvalorMoraMulta write fvalorMoraMulta;
    property codigoTipoPagador: TACBrPagamentoTipoPessoa read fcodigoTipoPagador write fcodigoTipoPagador;
    property documentoPagador: String read fdocumentoPagador write fdocumentoPagador;
    property nomePagador: String read fnomePagador write fnomePagador;
    property codigoTipoBeneficiario: TACBrPagamentoTipoPessoa read fcodigoTipoBeneficiario write fcodigoTipoBeneficiario;
    property documentoBeneficiario: String read fdocumentoBeneficiario write fdocumentoBeneficiario;
    property nomeBeneficiario: String read fnomeBeneficiario write fnomeBeneficiario;
    property codigoTipoAvalista: TACBrPagamentoTipoPessoa read fcodigoTipoAvalista write fcodigoTipoAvalista;
    property documentoAvalista: String read fdocumentoAvalista write fdocumentoAvalista;
    property nomeAvalista: String read fnomeAvalista write fnomeAvalista;
    property indicadorAceite: String read findicadorAceite write findicadorAceite;

    // GRU             
    property idPagamento: Int64 read fidPagamento write fidPagamento;
    property nomeRecebedor: String read fnomeRecebedor write fnomeRecebedor;
    property textoPagamento: String read ftextoPagamento write ftextoPagamento;
    property dataVencimento: TDateTime read fdataVencimento write fdataVencimento;
    property numeroReferencia: String read fnumeroReferencia write fnumeroReferencia;
    property mesAnoCompetencia: Integer read fmesAnoCompetencia write fmesAnoCompetencia;
    property idContribuinte: Int64 read fidContribuinte write fidContribuinte;
    property valorPrincipal: Double read fvalorPrincipal write fvalorPrincipal;
    property valorOutraDeducao: Double read fvalorOutraDeducao write fvalorOutraDeducao;
    property valorMulta: Double read fvalorMulta write fvalorMulta;
    property valorJuroEncargo: Double read fvalorJuroEncargo write fvalorJuroEncargo;
    property valorOutroAcrescimo: Double read fvalorOutroAcrescimo write fvalorOutroAcrescimo;
    property valorOutrosAcrescimos: Double read fvalorOutrosAcrescimos write fvalorOutrosAcrescimos;
    property indicadorMovimentoAceito: String read findicadorMovimentoAceito write findicadorMovimentoAceito;

    // GPS
    property textoDescricaoPagamento: String read ftextoDescricaoPagamento write ftextoDescricaoPagamento;
    property nomeConvenente: String read fnomeConvenente write fnomeConvenente;
    property codigoReceitaTributoGuiaPrevidenciaSocial: Integer read fcodigoReceitaTributoGuiaPrevidenciaSocial write fcodigoReceitaTributoGuiaPrevidenciaSocial;
    property codigoTipoContribuinteGuiaPrevidenciaSocial: TACBrTipoContribuinte read fcodigoTipoContribuinteGuiaPrevidenciaSocial write fcodigoTipoContribuinteGuiaPrevidenciaSocial;
    property numeroIdentificacaoContribuinteGuiaPrevidenciaSocial: Integer read fnumeroIdentificacaoContribuinteGuiaPrevidenciaSocial write fnumeroIdentificacaoContribuinteGuiaPrevidenciaSocial;
    property codigoIdentificadorTributoGuiaPrevidenciaSocial: String read fcodigoIdentificadorTributoGuiaPrevidenciaSocial write fcodigoIdentificadorTributoGuiaPrevidenciaSocial;
    property mesAnoCompetenciaGuiaPrevidenciaSocial: Integer read fmesAnoCompetenciaGuiaPrevidenciaSocial write fmesAnoCompetenciaGuiaPrevidenciaSocial;
    property valorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial: Double read fvalorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial write fvalorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial;
    property valorOutroEntradaGuiaPrevidenciaSocial: Double read fvalorOutroEntradaGuiaPrevidenciaSocial write fvalorOutroEntradaGuiaPrevidenciaSocial;
    property valorAtualizacaoMonetarioGuiaPrevidenciaSocial: Double read fvalorAtualizacaoMonetarioGuiaPrevidenciaSocial write fvalorAtualizacaoMonetarioGuiaPrevidenciaSocial;

    property errorCodes: TACBrTransferenciaErros read GeterrorCodes write ferrorCodes;
    property errors: TACBrTransferenciaErros read Geterrors write ferrors;
    property erros: TACBrTransferenciaErros read Geterros write ferros;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(ASource: TACBrLancamentoClass);
  end;

  { TACBrBoletosLancamento }

  TACBrBoletosLancamento = class(TACBrLancamentoClass)
  public
    property numeroDocumentoDebito;
    property numeroCodigoBarras;
    property dataPagamento;
    property valorPagamento;
    property descricaoPagamento;
    property codigoSeuDocumento;
    property codigoNossoDocumento;
    property valorNominal;
    property valorDesconto;
    property valorMoraMulta;
    property codigoTipoPagador;
    property documentoPagador;
    property codigoTipoBeneficiario;
    property documentoBeneficiario;
    property codigoTipoAvalista;
    property documentoAvalista;
  end;

  { TACBrBoletosLancamentos }

  TACBrBoletosLancamentos = class(TACBrAPISchemaArray)
  private
    function GetItem(aIndex: Integer): TACBrBoletosLancamento;
    procedure SetItem(aIndex: Integer; aValue: TACBrBoletosLancamento);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aLancamento: TACBrBoletosLancamento): Integer;
    procedure Insert(aIndex: Integer; aLancamento: TACBrBoletosLancamento);
    function New: TACBrBoletosLancamento;
    property Items[aIndex: Integer]: TACBrBoletosLancamento read GetItem write SetItem; default;
  end;

  { TACBrGuiasCodigoBarrasLancamento }

  TACBrGuiasCodigoBarrasLancamento = class(TACBrLancamentoClass)
  public
    property codigoBarras;
    property dataPagamento;
    property valorPagamento;
    property numeroDocumentoDebito;
    property codigoSeuDocumento;
    property descricaoPagamento;
  end; 

  { TACBrGuiasCodigoBarrasLancamentos }

  TACBrGuiasCodigoBarrasLancamentos = class(TACBrAPISchemaArray)
  private
    function GetItem(aIndex: Integer): TACBrGuiasCodigoBarrasLancamento;
    procedure SetItem(aIndex: Integer; aValue: TACBrGuiasCodigoBarrasLancamento);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aLancamento: TACBrGuiasCodigoBarrasLancamento): Integer;
    procedure Insert(aIndex: Integer; aLancamento: TACBrGuiasCodigoBarrasLancamento);
    function New: TACBrGuiasCodigoBarrasLancamento;
    property Items[aIndex: Integer]: TACBrGuiasCodigoBarrasLancamento read GetItem write SetItem; default;
  end; 

  { TACBrGRULancamento }

  TACBrGRULancamento = class(TACBrLancamentoClass)
  public
    property codigoBarras;
    property dataVencimento;
    property dataPagamento;
    property valorPagamento;
    property numeroDocumentoDebito;
    property textoPagamento;
    property numeroReferencia;
    property mesAnoCompetencia;
    property idContribuinte;
    property valorPrincipal;
    property valorDesconto;
    property valorOutraDeducao;
    property valorMulta;
    property valorJuroEncargo;
    property valorOutroAcrescimo;
  end;

  { TACBrGRULancamentos }

  TACBrGRULancamentos = class(TACBrAPISchemaArray)
  private
    function GetItem(aIndex: Integer): TACBrGRULancamento;
    procedure SetItem(aIndex: Integer; aValue: TACBrGRULancamento);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aLancamento: TACBrGRULancamento): Integer;
    procedure Insert(aIndex: Integer; aLancamento: TACBrGRULancamento);
    function New: TACBrGRULancamento;
    property Items[aIndex: Integer]: TACBrGRULancamento read GetItem write SetItem; default;
  end;

  { TACBrGPSLancamento }

  TACBrGPSLancamento = class(TACBrLancamentoClass)
  public
    property dataPagamento;
    property valorPagamento;
    property numeroDocumentoDebito;
    property codigoSeuDocumento;
    property textoDescricaoPagamento;
    property codigoReceitaTributoGuiaPrevidenciaSocial;
    property mesAnoCompetenciaGuiaPrevidenciaSocial;
    property codigoTipoContribuinteGuiaPrevidenciaSocial;
    property numeroIdentificacaoContribuinteGuiaPrevidenciaSocial;
    property codigoIdentificadorTributoGuiaPrevidenciaSocial;
    property valorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial;
    property valorOutroEntradaGuiaPrevidenciaSocial;
    property valorAtualizacaoMonetarioGuiaPrevidenciaSocial;
  end;

  { TACBrGPSLancamentos }

  TACBrGPSLancamentos = class(TACBrAPISchemaArray)
  private
    function GetItem(aIndex: Integer): TACBrGPSLancamento;
    procedure SetItem(aIndex: Integer; aValue: TACBrGPSLancamento);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aLancamento: TACBrGPSLancamento): Integer;
    procedure Insert(aIndex: Integer; aLancamento: TACBrGPSLancamento);
    function New: TACBrGPSLancamento;
    property Items[aIndex: Integer]: TACBrGPSLancamento read GetItem write SetItem; default;
  end;

  { TACBrLoteRequisicaoClass }

  TACBrLoteRequisicaoClass = class(TACBrAPISchema)
  private
    fagencia: Integer;
    fconta: Integer;
    fdigitoConta: String;
    fnumeroRequisicao: Integer;
    fcodigoContrato: Integer;
    fnumeroAgenciaDebito: Integer;
    fnumeroContaCorrenteDebito: Integer;
    fdigitoVerificadorContaCorrenteDebito: String;
    fBoletolancamentos: TACBrBoletosLancamentos;
    fGuiaCodBarraslancamentos: TACBrGuiasCodigoBarrasLancamentos;
    fGRUlistaRequisicao: TACBrGRULancamentos;
    fGPSlancamentos: TACBrGPSLancamentos;
    function GetBoletolancamentos: TACBrBoletosLancamentos;
    function GetGuiaCodBarraslancamentos: TACBrGuiasCodigoBarrasLancamentos;
    function GetGRUlistaRequisicao: TACBrGRULancamentos;
    function GetGPSlancamentos: TACBrGPSLancamentos;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(aSource: TACBrLoteRequisicaoClass); virtual;

    property numeroRequisicao: Integer read fnumeroRequisicao write fnumeroRequisicao;
    property codigoContrato: Integer read fcodigoContrato write fcodigoContrato;
    property agencia: Integer read fagencia write fagencia;
    property conta: Integer read fconta write fconta;
    property digitoConta: String read fdigitoConta write fdigitoConta;
    property numeroAgenciaDebito: Integer read fnumeroAgenciaDebito write fnumeroAgenciaDebito;
    property numeroContaCorrenteDebito: Integer read fnumeroContaCorrenteDebito write fnumeroContaCorrenteDebito;
    property digitoVerificadorContaCorrenteDebito: String read fdigitoVerificadorContaCorrenteDebito write fdigitoVerificadorContaCorrenteDebito;
  end;  

  { TACBrLoteBoletosRequisicao }

  TACBrLoteBoletosRequisicao = class(TACBrLoteRequisicaoClass)
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Assign(aSource: TACBrLoteRequisicaoClass); override;
    property lancamentos: TACBrBoletosLancamentos read GetBoletolancamentos write fBoletolancamentos;
  end; 

  { TACBrLoteGuiasCodigoBarrasRequisicao }

  TACBrLoteGuiasCodigoBarrasRequisicao = class(TACBrLoteRequisicaoClass)
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Assign(aSource: TACBrLoteRequisicaoClass); override;
    property lancamentos: TACBrGuiasCodigoBarrasLancamentos read GetGuiaCodBarraslancamentos write fGuiaCodBarraslancamentos;
  end;

  { TACBrLoteGRURequisicao }

  TACBrLoteGRURequisicao = class(TACBrLoteRequisicaoClass)
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Assign(aSource: TACBrLoteRequisicaoClass); override;
    property listaRequisicao: TACBrGRULancamentos read GetGRUlistaRequisicao write fGRUlistaRequisicao;
  end;

  { TACBrLoteGPSRequisicao }

  TACBrLoteGPSRequisicao = class(TACBrLoteRequisicaoClass)
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Assign(aSource: TACBrLoteRequisicaoClass); override;
    property lancamentos: TACBrGPSLancamentos read GetGPSlancamentos write fGPSlancamentos;
  end;

  { TACBrBoletosLancamentoResposta }

  TACBrBoletosLancamentoResposta = class(TACBrLancamentoClass)
  public
    constructor Create(const ObjectName: String = ''); override;
    property codigoIdentificadorPagamento;
    property numeroDocumentoDebito;
    property numeroCodigoBarras;
    property dataPagamento;
    property valorPagamento;
    property descricaoPagamento;
    property codigoSeuDocumento;
    property codigoNossoDocumento;
    property valorNominal;
    property valorDesconto;
    property valorMoraMulta;
    property codigoTipoPagador;
    property documentoPagador;
    property nomePagador;
    property codigoTipoBeneficiario;
    property documentoBeneficiario;
    property nomeBeneficiario;
    property codigoTipoAvalista;
    property documentoAvalista;
    property nomeAvalista;
    property indicadorAceite;
    property errorCodes;
  end;

  { TACBrBoletosLancamentosResposta }

  TACBrBoletosLancamentosResposta = class(TACBrAPISchemaArray)
  private
    function GetItem(aIndex: Integer): TACBrBoletosLancamentoResposta;
    procedure SetItem(aIndex: Integer; aValue: TACBrBoletosLancamentoResposta);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aLancamento: TACBrBoletosLancamentoResposta): Integer;
    procedure Insert(aIndex: Integer; aLancamento: TACBrBoletosLancamentoResposta);
    function New: TACBrBoletosLancamentoResposta;
    property Items[aIndex: Integer]: TACBrBoletosLancamentoResposta read GetItem write SetItem; default;
  end;

  { TACBrGuiaCodBarrasLancamentoResposta }

  TACBrGuiaCodBarrasLancamentoResposta = class(TACBrLancamentoClass)
  public
    constructor Create(const ObjectName: String = ''); override;
    property codigoIdentificadorPagamento;
    property numeroDocumentoDebito;
    property CodigoBarras;
    property dataPagamento;
    property valorPagamento;
    property descricaoPagamento;
    property codigoSeuDocumento;
    property nomeBeneficiario;
    property indicadorAceite;
    property errors;
  end;

  { TACBrGuiaCodBarrasLancamentosResposta }

  TACBrGuiaCodBarrasLancamentosResposta = class(TACBrAPISchemaArray)
  private
    function GetItem(aIndex: Integer): TACBrGuiaCodBarrasLancamentoResposta;
    procedure SetItem(aIndex: Integer; aValue: TACBrGuiaCodBarrasLancamentoResposta);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aLancamento: TACBrGuiaCodBarrasLancamentoResposta): Integer;
    procedure Insert(aIndex: Integer; aLancamento: TACBrGuiaCodBarrasLancamentoResposta);
    function New: TACBrGuiaCodBarrasLancamentoResposta;
    property Items[aIndex: Integer]: TACBrGuiaCodBarrasLancamentoResposta read GetItem write SetItem; default;
  end;

  { TACBrGRUPagamentoResposta }

  TACBrGRUPagamentoResposta = class(TACBrLancamentoClass)
  public
    constructor Create(const ObjectName: String = ''); override;
    property idPagamento;
    property nomeRecebedor;
    property codigoBarras;
    property dataVencimento;
    property dataPagamento;
    property valorPagamento;
    property numeroDocumentoDebito;
    property descricaoPagamento;
    property numeroReferencia;
    property mesAnoCompetencia;
    property idContribuinte;
    property valorPrincipal;
    property valorDesconto;
    property valorOutraDeducao;
    property valorMulta;
    property valorJuroEncargo;
    property valorOutrosAcrescimos;
    property indicadorMovimentoAceito;
    property erros;
  end;

  { TACBrGRUPagamentosResposta }

  TACBrGRUPagamentosResposta = class(TACBrAPISchemaArray)
  private
    function GetItem(aIndex: Integer): TACBrGRUPagamentoResposta;
    procedure SetItem(aIndex: Integer; aValue: TACBrGRUPagamentoResposta);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aLancamento: TACBrGRUPagamentoResposta): Integer;
    procedure Insert(aIndex: Integer; aLancamento: TACBrGRUPagamentoResposta);
    function New: TACBrGRUPagamentoResposta;
    property Items[aIndex: Integer]: TACBrGRUPagamentoResposta read GetItem write SetItem; default;
  end; 

  { TACBrGPSLancamentoResposta }

  TACBrGPSLancamentoResposta = class(TACBrLancamentoClass)
  public
    constructor Create(const ObjectName: String = ''); override;
    property codigoIdentificadorPagamento;
    property nomeConvenente;
    property dataPagamento;
    property valorPagamento;
    property numeroDocumentoDebito;
    property codigoSeuDocumento;
    property codigoReceitaTributoGuiaPrevidenciaSocial;
    property codigoTipoContribuinteGuiaPrevidenciaSocial;
    property numeroIdentificacaoContribuinteGuiaPrevidenciaSocial;
    property codigoIdentificadorTributoGuiaPrevidenciaSocial;
    property mesAnoCompetenciaGuiaPrevidenciaSocial;
    property valorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial;
    property valorOutroEntradaGuiaPrevidenciaSocial;
    property valorAtualizacaoMonetarioGuiaPrevidenciaSocial;
    property indicadorMovimentoAceito;
    property erros;
  end;

  { TACBrGPSLancamentosResposta }

  TACBrGPSLancamentosResposta = class(TACBrAPISchemaArray)
  private
    function GetItem(aIndex: Integer): TACBrGPSLancamentoResposta;
    procedure SetItem(aIndex: Integer; aValue: TACBrGPSLancamentoResposta);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aLancamento: TACBrGPSLancamentoResposta): Integer;
    procedure Insert(aIndex: Integer; aLancamento: TACBrGPSLancamentoResposta);
    function New: TACBrGPSLancamentoResposta;
    property Items[aIndex: Integer]: TACBrGPSLancamentoResposta read GetItem write SetItem; default;
  end;

  { TACBrLoteRespostaClass }

  TACBrLoteRespostaClass  = class(TACBrAPISchema)
  private
    fcodigoEstado: TACBrLoteEstadoRequisicao;
    fcodigoEstadoRequisicao: TACBrLoteEstadoRequisicao;
    fnumeroRequisicao: Integer;
    festadoRequisicao: Integer;
    fquantidadeLancamentos: Integer;
    fquantidadeTotal: Integer;
    fquantidadeTotalLancamento: Integer;
    fquantidadeTotalValido: Integer;
    fvalorLancamentos: Double;
    fquantidadeLancamentosValidos: Integer;
    fvalorLancamentosValidos: Double;
    fvalorTotal: Double;
    fvalorTotalLancamento: Double;
    fvalorTotalValido: Double;
  protected
    fBoletolancamentos: TACBrBoletosLancamentosResposta;
    fGuiaCodBarraslancamentos: TACBrGuiaCodBarrasLancamentosResposta;
    fGRUPagamentos: TACBrGRUPagamentosResposta;
    fGPSlancamentos: TACBrGPSLancamentosResposta;
    function GetBoletoLancamentos: TACBrBoletosLancamentosResposta;
    function GetGuiaCodBarrasLancamentos: TACBrGuiaCodBarrasLancamentosResposta;
    function GetGRUPagamentos: TACBrGRUPagamentosResposta;
    function GetGPSLancamentos: TACBrGPSLancamentosResposta;

    procedure AssignSchema(ASource: TACBrAPISchema); override;
    procedure DoWriteToJSon(AJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(AJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(aSource: TACBrLoteRespostaClass); virtual;
                                                                                      
    property numeroRequisicao: Integer read fnumeroRequisicao write fnumeroRequisicao;
    property estadoRequisicao: Integer read festadoRequisicao write festadoRequisicao;
    property codigoEstado: TACBrLoteEstadoRequisicao read fcodigoEstado write fcodigoEstado;

    // Boleto
    property quantidadeLancamentos: Integer read fquantidadeLancamentos write fquantidadeLancamentos;
    property valorLancamentos: Double read fvalorLancamentos write fvalorLancamentos;
    property quantidadeLancamentosValidos: Integer read fquantidadeLancamentosValidos write fquantidadeLancamentosValidos;
    property valorLancamentosValidos: Double read fvalorLancamentosValidos write fvalorLancamentosValidos;

    // GRU
    property quantidadeTotal: Integer read fquantidadeTotal write fquantidadeTotal;
    property valorTotal: Double read fvalorTotal write fvalorTotal;
    property quantidadeTotalValido: Integer read fquantidadeTotalValido write fquantidadeTotalValido;
    property valorTotalValido: Double read fvalorTotalValido write fvalorTotalValido;

    // GPS
    property codigoEstadoRequisicao: TACBrLoteEstadoRequisicao read fcodigoEstadoRequisicao write fcodigoEstadoRequisicao;
    property quantidadeTotalLancamento: Integer read fquantidadeTotalLancamento write fquantidadeTotalLancamento;
    property valorTotalLancamento: Double read fvalorTotalLancamento write fvalorTotalLancamento;
  end;

  { TACBrLoteBoletosResposta }

  TACBrLoteBoletosResposta = class(TACBrLoteRespostaClass)
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Assign(aSource: TACBrLoteRespostaClass); override;

    property numeroRequisicao;
    property estadoRequisicao;
    property quantidadeLancamentos;
    property valorLancamentos;
    property quantidadeLancamentosValidos;
    property valorLancamentosValidos;
    property lancamentos: TACBrBoletosLancamentosResposta read GetBoletoLancamentos write fBoletolancamentos;
  end; 

  { TACBrLoteGuiaCodBarrasResposta }

  TACBrLoteGuiaCodBarrasResposta = class(TACBrLoteRespostaClass)
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Assign(aSource: TACBrLoteRespostaClass); override;

    property numeroRequisicao;
    property codigoEstado;
    property quantidadeLancamentos;
    property valorLancamentos;
    property quantidadeLancamentosValidos;
    property valorLancamentosValidos;
    property lancamentos: TACBrGuiaCodBarrasLancamentosResposta read GetGuiaCodBarrasLancamentos write fGuiaCodBarraslancamentos;
  end;

  { TACBrLoteGRUResposta }

  TACBrLoteGRUResposta = class(TACBrLoteRespostaClass)
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Assign(aSource: TACBrLoteRespostaClass); override;

    property numeroRequisicao;
    property estadoRequisicao;
    property quantidadeTotal;
    property valorTotal;
    property quantidadeTotalValido;
    property valorTotalValido;
    property pagamentos: TACBrGRUPagamentosResposta read GetGRUPagamentos write fGRUPagamentos;
  end; 

  { TACBrLoteGPSResposta }

  TACBrLoteGPSResposta = class(TACBrLoteRespostaClass)
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Assign(aSource: TACBrLoteRespostaClass); override;

    property numeroRequisicao;
    property codigoEstadoRequisicao;
    property quantidadeTotalLancamento;
    property valorTotalLancamento;
    property quantidadeTotalValido;
    property valorTotalValido;
    property lancamentos: TACBrGPSLancamentosResposta read GetGPSlancamentos write fGPSlancamentos;
  end;

  function TipoPessoaToInt(const aTipo: TACBrPagamentoTipoPessoa): Integer;
  function IntToTipoPessoa(const aStr: Integer): TACBrPagamentoTipoPessoa;
  function TransferenciaErroToInteger(const aValue: TACBrTransferenciaErro): Integer;
  function IntegerToTransferenciaErro(const aValue: Integer): TACBrTransferenciaErro;
  function EstadoRequisicaoToInteger(const aValue: TACBrLoteEstadoRequisicao): Integer;
  function IntegerToEstadoRequisicao(const aValue: Integer): TACBrLoteEstadoRequisicao;
  function TipoContribuinteToInteger(const aValue: TACBrTipoContribuinte): Integer;
  function IntegerToTipoContribuinte(const aValue: Integer): TACBrTipoContribuinte;

implementation

uses
  synautil, synacode,
  ACBrSocket,
  ACBrUtil.DateTime,
  ACBrUtil.Base;

function TipoPessoaToInt(const aTipo: TACBrPagamentoTipoPessoa): Integer;
begin
  Result := 0;
    case aTipo of
      ptpNenhum: Result := 0;
      ptpFisica: Result := 1;
      ptpJuridica: Result := 2;
    end;
end;

function IntToTipoPessoa(const aStr: Integer): TACBrPagamentoTipoPessoa;
  var
  s: Integer;
begin
  Result := ptpNenhum;
  s := aStr;
  if (s = 1) then
    Result := ptpFisica
  else if (s = 2) then
    Result := ptpJuridica;
end;

function TransferenciaErroToInteger(const aValue: TACBrTransferenciaErro): Integer;
begin
  Result := 0;
  case aValue of
    pteAgenciaZerada: Result := 1;
    pteAgenciaNaoNumerica: Result := 2;
    pteDVContaNaoInformado: Result := 3;
    pteCPFNaoNumerico: Result := 4;
    pteCNPJNaoNumerico: Result := 5;
    pteDataNaoInformada: Result := 6;
    pteDataInvalida: Result := 7;
    pteValorNaoNumerico: Result := 8;
    pteValorZerado: Result := 9;
    pteCompensacaoISPBNaoInformados: Result := 10;
    pteCompensacaoISPBInformados: Result := 11;
    pteDOCTEDNaoInformados: Result := 12;
    pteDOCTEDInformados: Result := 13;
    pteNumDepositoJudicialNaoInformado: Result := 14;
    pteDVContaInvalido: Result := 15;
    pteCPFCNPJInformados: Result := 16;
    pteCPFCNPJNaoInformaos: Result := 17;
    pteCPFInvalido: Result := 18;
    pteCNPJInvalido: Result := 19;
    pteAgenciaContaIguais: Result := 20;
    pteNumCompensacaoInvalido: Result := 21;
    pteISPBDiferenteDeZeros: Result := 22;
    pteContaCreditoNaoInformada: Result := 23;
    pteCPFNaoInformado: Result := 24;
    pteCNPJNaoInformado: Result := 25;
    pteContaCreditoInformada: Result := 26;
    pteDVCreditoInformado: Result := 27;
    pteFinalidadeDOCInformada: Result := 28;
    pteFinalidadeTEDInformada: Result := 29;
    pteNumDepositoJudicialInformado: Result := 30;
    pteDocumentoCreditoNaoNumerico: Result := 31;
    pteDocumentoDebitoNaoNumerico: Result := 32;
    pteCPFNaoEncontrado: Result := 33;
    pteCNPJNaoEncontrado: Result := 34;
    pteContaPoupancaNaoPermitida: Result := 35;
    pteCOMPEDeveSer1: Result := 36;
    pteISPBDeveSer0: Result := 37;
    pteCodBarrasNaoNumerio: Result := 38;
    pteCodBarrasIgualZeros: Result := 39;
    pteNumInscricaoNaoNumerico: Result := 40;
    pteInscricaoBeneficiarioNaoNumerico: Result := 41;
    pteInscricaoAvalistaNaoNumerico: Result := 42;
    pteDVCPFPagadorInvalido: Result := 43;
    pteDVCPFBeneficiarioInvalido: Result := 44;
    pteDVCPFAvalistaInvalido: Result := 45;
    pteDVCNPJPagadorInvalido: Result := 46;
    pteDVCNPJBeneficiarioInvalido: Result := 47;
    pteDVCNPJAvalistaInvalido: Result := 48;
    pteDataVencimentoInvalida: Result := 49;
    pteValorNominalNaoNumerico: Result := 50;
    pteValorDescontoNaoNumerico: Result := 51;
    pteValorMoraNaoNumerico: Result := 52;
    pteDataPagamentoMenorAtual: Result := 53;
    pteDocDebitoNaoInformado: Result := 54;
    pteDataVencimentoNaoInformada: Result := 55;
    pteNomeBeneficiarioNaoInformado: Result := 56;
    pteInscricaoBeneficiarioNaoInformada: Result := 57;
    pteContaPagamentoInformada: Result := 58;
    pteContaCreditoPagamentoInformada: Result := 59;
    pteConsultarBancoErro: Result := 99;
    pteInsuficienciaFundos: Result := 200;
    pteCreditoDebitoCancelado: Result := 201;
    pteDebitoAutorizado: Result := 202;
    pteControleInvalido: Result := 203;
    pteTipoOperacaoInvalido: Result := 204;
    pteTipoServicoInvalido: Result := 205;
    pteFormaLancamentoInvalida: Result := 206;
    pteTipoNumeroInscricaoInvalido: Result := 207;
    pteCodigoConvenioInvalido: Result := 208;
    pteAgenciaContaCorrenteDVInvalido: Result := 209;
    pteNumeroSequencialRegistroInvalido: Result := 210;
    pteCodigoSegmentoDetalheInvalido: Result := 211;
    pteLancamentoInconsistente: Result := 212;
    pteNumeroCompeBancoCreditoInvalido: Result := 213;
    pteNumeroISPBInvalido: Result := 214;
    pteAgenciaMantenedoraInvalida: Result := 215;
    pteContaCorrenteDVInvalido: Result := 216;
    pteNomeFavorecidoNaoInformado: Result := 217;
    pteDataLancamentoInvalida: Result := 218;
    pteTipoQuantidadeMoedaInvalida: Result := 219;
    pteValorLancamentoInvalido: Result := 220;
    pteAvisoFavorecidoIdentificacaoInvalida: Result := 221;
    pteTipoNumeroInscricaoFavorecidoInvalido: Result := 222;
    pteLogradouroFavorecidoNaoInformado: Result := 223;
    pteNumeroLocalFavorecidoNaoInformado: Result := 224;
    pteCidadeFavorecidoNaoInformada: Result := 225;
    pteCEPFavorecidoInvalido: Result := 226;
    pteSiglaEstadoFavorecidoInvalida: Result := 227;
    pteNumeroBancoCreditoInvalido: Result := 228;
    pteCodigoNomeAgenciaDepositariaNaoInformado: Result := 229;
    pteSeuNumeroInvalido: Result := 230;
    pteNossoNumeroInvalido: Result := 231;
    pteInclusaoEfetuadaSucesso: Result := 232;
    pteAlteracaoEfetuadaSucesso: Result := 233;
    pteExclusaoEfetuadaSucesso: Result := 234;
    pteAgenciaContaImpedidaLegalmente: Result := 235;
    pteEmpresaNaoPagouSalario: Result := 236;
    pteFalecimentoMutuario: Result := 237;
    pteEmpresaNaoEnviouRemessaMutuario: Result := 238;
    pteEmpresaNaoEnviouRemessaVencimento: Result := 239;
    pteValorParcelaInvalida: Result := 240;
    pteIdentificacaoContratoInvalida: Result := 241;
    pteOperacaoConsignacaoIncluidaSucesso: Result := 242;
    pteOperacaoConsignacaoAlteradaSucesso: Result := 243;
    pteOperacaoConsignacaoExcluidaSucesso: Result := 244;
    pteOperacaoConsignacaoLiquidadaSucesso: Result := 245;
    pteReativacaoEfetuadaSucesso: Result := 246;
    pteSuspensaoEfetuadaSucesso: Result := 247;
    pteCodigoBarrasBancoInvalido: Result := 248;
    pteCodigoBarrasMoedaInvalido: Result := 249;
    pteCodigoBarrasDigitoVerificadorInvalido: Result := 250;
    pteCodigoBarrasValorTituloInvalido: Result := 251;
    pteCodigoBarrasCampoLivreInvalido: Result := 252;
    pteValorDocumentoInvalido: Result := 253;
    pteValorAbatimentoInvalido: Result := 254;
    pteValorDescontoInvalido: Result := 255;
    pteValorMoraInvalido: Result := 256;
    pteValorMultaInvalido: Result := 257;
    pteValorIRInvalido: Result := 258;
    pteValorISSInvalido: Result := 259;
    pteValorIOFInvalido: Result := 260;
    pteValorOutrasDeducoesInvalido: Result := 261;
    pteValorOutrosAcrescimosInvalido: Result := 262;
    pteValorINSSInvalido: Result := 263;
    pteLoteNaoAceito: Result := 264;
    pteInscricaoEmpresaInvalidaContrato: Result := 265;
    pteConvenioEmpresaInexistenteContrato: Result := 266;
    pteAgenciaContaCorrenteEmpresaInexistenteContrato: Result := 267;
    pteTipoServicoInvalidoContrato: Result := 268;
    pteContaCorrenteSaldoInsuficiente: Result := 269;
    pteLoteServicoForaSequencia: Result := 270;
    pteLoteServicoInvalido: Result := 271;
    pteArquivoNaoAceito: Result := 272;
    pteTipoRegistroInvalido: Result := 273;
    pteCodigoRemessaRetornoInvalido: Result := 274;
    pteVersaoLayoutInvalida: Result := 275;
    pteMutuarioNaoIdentificado: Result := 276;
    pteTipoBeneficioNaoPermiteEmprestimo: Result := 277;
    pteBeneficioCessadoSuspenso: Result := 278;
    pteBeneficioPossuiRepresentanteLegal: Result := 279;
    pteBeneficioTipoPA: Result := 280;
    pteQuantidadeContratosExcedida: Result := 281;
    pteBeneficioNaoPertenceBanco: Result := 282;
    pteInicioDescontoUltrapassado: Result := 283;
    pteNumeroParcelaInvalida: Result := 284;
    pteQuantidadeParcelaInvalida: Result := 285;
    pteMargemConsignavelExcedidaPrazo: Result := 286;
    pteEmprestimoJaCadastrado: Result := 287;
    pteEmprestimoInexistente: Result := 288;
    pteEmprestimoJaEncerrado: Result := 289;
    pteArquivoSemTrailer: Result := 290;
    pteMutuarioSemCreditoCompetencia: Result := 291;
    pteNaoDescontadoOutrosMotivos: Result := 292;
    pteRetornoCreditoNaoPago: Result := 293;
    pteCancelamentoEmprestimoRetroativo: Result := 294;
    pteOutrosMotivosGlosa: Result := 295;
    pteMargemConsignavelExcedidaAcimaPrazo: Result := 296;
    pteMutuarioDesligadoEmpregador: Result := 297;
    pteMutuarioAfastadoLicenca: Result := 298;
    ptePrimeiroNomeMutuarioDiferente: Result := 299;
    pteBeneficioSuspensoCessadoAPS: Result := 300;
    pteBeneficioSuspensoDependenciaCalculo: Result := 301;
    pteBeneficioSuspensoCessadoInspetoria: Result := 302;
    pteBeneficioBloqueadoEmprestimoBeneficiario: Result := 303;
    pteBeneficioBloqueadoEmprestimoTBM: Result := 304;
    pteBeneficioFaseConcessaoPA: Result := 305;
    pteBeneficioCessadoObito: Result := 306;
    pteBeneficioCessadoFraude: Result := 307;
    pteBeneficioCessadoOutroBeneficio: Result := 308;
    pteBeneficioCessadoEstatutario: Result := 309;
    pteEmprestimoSuspensoAPS: Result := 310;
    pteEmprestimoCanceladoBanco: Result := 311;
    pteCreditoTransformadoPAB: Result := 312;
    pteTerminoConsignacaoAlterado: Result := 313;
    pteFimEmprestimoPeriodoSuspensao: Result := 314;
    pteEmprestimoSuspensoBanco: Result := 315;
    pteNaoAverbacaoContratoQuantidadeParcelas: Result := 316;
    pteLoteNaoAceitoTotaisDiferenca: Result := 317;
    pteTituloNaoEncontrado: Result := 318;
    pteIdentificadorRegistroOpcionalInvalido: Result := 319;
    pteCodigoPadraoInvalido: Result := 320;
    pteCodigoOcorrenciaInvalido: Result := 321;
    pteComplementoOcorrenciaInvalido: Result := 322;
    pteAlegacaoJaInformada: Result := 323;
    pteAgenciaContaFavorecidoSubstituida: Result := 324;
    pteDivergenciaNomeBeneficiario: Result := 325;
    pteConfirmacaoAntecipacaoValor: Result := 326;
    pteAntecipacaoParcialValor: Result := 327;
    pteBoletoBloqueadoBase: Result := 328;
    pteSistemaContingenciaBoletoValorMaior: Result := 329;
    pteSistemaContingenciaBoletoVencido: Result := 330;
    pteSistemaContingenciaBoletoIndexado: Result := 331;
    pteBeneficiarioDivergente: Result := 332;
    pteLimitePagamentosParciaisExcedido: Result := 333;
    pteBoletoJaLiquidado: Result := 334;
    pteConsultarBancoDetalharErro: Result := 999;
  end;
end;

function IntegerToTransferenciaErro(const aValue: Integer): TACBrTransferenciaErro;
begin
  Result := pteNenhum;
  case aValue of
    1: Result := pteAgenciaZerada;
    2: Result := pteAgenciaNaoNumerica;
    3: Result := pteDVContaNaoInformado;
    4: Result := pteCPFNaoNumerico;
    5: Result := pteCNPJNaoNumerico;
    6: Result := pteDataNaoInformada;
    7: Result := pteDataInvalida;
    8: Result := pteValorNaoNumerico;
    9: Result := pteValorZerado;
    10: Result := pteCompensacaoISPBNaoInformados;
    11: Result := pteCompensacaoISPBInformados;
    12: Result := pteDOCTEDNaoInformados;
    13: Result := pteDOCTEDInformados;
    14: Result := pteNumDepositoJudicialNaoInformado;
    15: Result := pteDVContaInvalido;
    16: Result := pteCPFCNPJInformados;
    17: Result := pteCPFCNPJNaoInformaos;
    18: Result := pteCPFInvalido;
    19: Result := pteCNPJInvalido;
    20: Result := pteAgenciaContaIguais;
    21: Result := pteNumCompensacaoInvalido;
    22: Result := pteISPBDiferenteDeZeros;
    23: Result := pteContaCreditoNaoInformada;
    24: Result := pteCPFNaoInformado;
    25: Result := pteCNPJNaoInformado;
    26: Result := pteContaCreditoInformada;
    27: Result := pteDVCreditoInformado;
    28: Result := pteFinalidadeDOCInformada;
    29: Result := pteFinalidadeTEDInformada;
    30: Result := pteNumDepositoJudicialInformado;
    31: Result := pteDocumentoCreditoNaoNumerico;
    32: Result := pteDocumentoDebitoNaoNumerico;
    33: Result := pteCPFNaoEncontrado;
    34: Result := pteCNPJNaoEncontrado;
    35: Result := pteContaPoupancaNaoPermitida;
    36: Result := pteCOMPEDeveSer1;
    37: Result := pteISPBDeveSer0;
    38: Result := pteCodBarrasNaoNumerio;
    39: Result := pteCodBarrasIgualZeros;
    40: Result := pteNumInscricaoNaoNumerico;
    41: Result := pteInscricaoBeneficiarioNaoNumerico;
    42: Result := pteInscricaoAvalistaNaoNumerico;
    43: Result := pteDVCPFPagadorInvalido;
    44: Result := pteDVCPFBeneficiarioInvalido;
    45: Result := pteDVCPFAvalistaInvalido;
    46: Result := pteDVCNPJPagadorInvalido;
    47: Result := pteDVCNPJBeneficiarioInvalido;
    48: Result := pteDVCNPJAvalistaInvalido;
    49: Result := pteDataVencimentoInvalida;
    50: Result := pteValorNominalNaoNumerico;
    51: Result := pteValorDescontoNaoNumerico;
    52: Result := pteValorMoraNaoNumerico;
    53: Result := pteDataPagamentoMenorAtual;
    54: Result := pteDocDebitoNaoInformado;
    55: Result := pteDataVencimentoNaoInformada;
    56: Result := pteNomeBeneficiarioNaoInformado;
    57: Result := pteInscricaoBeneficiarioNaoInformada;
    58: Result := pteContaPagamentoInformada;
    59: Result := pteContaCreditoPagamentoInformada;
    99: Result := pteConsultarBancoErro;
    200: Result := pteInsuficienciaFundos;
    201: Result := pteCreditoDebitoCancelado;
    202: Result := pteDebitoAutorizado;
    203: Result := pteControleInvalido;
    204: Result := pteTipoOperacaoInvalido;
    205: Result := pteTipoServicoInvalido;
    206: Result := pteFormaLancamentoInvalida;
    207: Result := pteTipoNumeroInscricaoInvalido;
    208: Result := pteCodigoConvenioInvalido;
    209: Result := pteAgenciaContaCorrenteDVInvalido;
    210: Result := pteNumeroSequencialRegistroInvalido;
    211: Result := pteCodigoSegmentoDetalheInvalido;
    212: Result := pteLancamentoInconsistente;
    213: Result := pteNumeroCompeBancoCreditoInvalido;
    214: Result := pteNumeroISPBInvalido;
    215: Result := pteAgenciaMantenedoraInvalida;
    216: Result := pteContaCorrenteDVInvalido;
    217: Result := pteNomeFavorecidoNaoInformado;
    218: Result := pteDataLancamentoInvalida;
    219: Result := pteTipoQuantidadeMoedaInvalida;
    220: Result := pteValorLancamentoInvalido;
    221: Result := pteAvisoFavorecidoIdentificacaoInvalida;
    222: Result := pteTipoNumeroInscricaoFavorecidoInvalido;
    223: Result := pteLogradouroFavorecidoNaoInformado;
    224: Result := pteNumeroLocalFavorecidoNaoInformado;
    225: Result := pteCidadeFavorecidoNaoInformada;
    226: Result := pteCEPFavorecidoInvalido;
    227: Result := pteSiglaEstadoFavorecidoInvalida;
    228: Result := pteNumeroBancoCreditoInvalido;
    229: Result := pteCodigoNomeAgenciaDepositariaNaoInformado;
    230: Result := pteSeuNumeroInvalido;
    231: Result := pteNossoNumeroInvalido;
    232: Result := pteInclusaoEfetuadaSucesso;
    233: Result := pteAlteracaoEfetuadaSucesso;
    234: Result := pteExclusaoEfetuadaSucesso;
    235: Result := pteAgenciaContaImpedidaLegalmente;
    236: Result := pteEmpresaNaoPagouSalario;
    237: Result := pteFalecimentoMutuario;
    238: Result := pteEmpresaNaoEnviouRemessaMutuario;
    239: Result := pteEmpresaNaoEnviouRemessaVencimento;
    240: Result := pteValorParcelaInvalida;
    241: Result := pteIdentificacaoContratoInvalida;
    242: Result := pteOperacaoConsignacaoIncluidaSucesso;
    243: Result := pteOperacaoConsignacaoAlteradaSucesso;
    244: Result := pteOperacaoConsignacaoExcluidaSucesso;
    245: Result := pteOperacaoConsignacaoLiquidadaSucesso;
    246: Result := pteReativacaoEfetuadaSucesso;
    247: Result := pteSuspensaoEfetuadaSucesso;
    248: Result := pteCodigoBarrasBancoInvalido;
    249: Result := pteCodigoBarrasMoedaInvalido;
    250: Result := pteCodigoBarrasDigitoVerificadorInvalido;
    251: Result := pteCodigoBarrasValorTituloInvalido;
    252: Result := pteCodigoBarrasCampoLivreInvalido;
    253: Result := pteValorDocumentoInvalido;
    254: Result := pteValorAbatimentoInvalido;
    255: Result := pteValorDescontoInvalido;
    256: Result := pteValorMoraInvalido;
    257: Result := pteValorMultaInvalido;
    258: Result := pteValorIRInvalido;
    259: Result := pteValorISSInvalido;
    260: Result := pteValorIOFInvalido;
    261: Result := pteValorOutrasDeducoesInvalido;
    262: Result := pteValorOutrosAcrescimosInvalido;
    263: Result := pteValorINSSInvalido;
    264: Result := pteLoteNaoAceito;
    265: Result := pteInscricaoEmpresaInvalidaContrato;
    266: Result := pteConvenioEmpresaInexistenteContrato;
    267: Result := pteAgenciaContaCorrenteEmpresaInexistenteContrato;
    268: Result := pteTipoServicoInvalidoContrato;
    269: Result := pteContaCorrenteSaldoInsuficiente;
    270: Result := pteLoteServicoForaSequencia;
    271: Result := pteLoteServicoInvalido;
    272: Result := pteArquivoNaoAceito;
    273: Result := pteTipoRegistroInvalido;
    274: Result := pteCodigoRemessaRetornoInvalido;
    275: Result := pteVersaoLayoutInvalida;
    276: Result := pteMutuarioNaoIdentificado;
    277: Result := pteTipoBeneficioNaoPermiteEmprestimo;
    278: Result := pteBeneficioCessadoSuspenso;
    279: Result := pteBeneficioPossuiRepresentanteLegal;
    280: Result := pteBeneficioTipoPA;
    281: Result := pteQuantidadeContratosExcedida;
    282: Result := pteBeneficioNaoPertenceBanco;
    283: Result := pteInicioDescontoUltrapassado;
    284: Result := pteNumeroParcelaInvalida;
    285: Result := pteQuantidadeParcelaInvalida;
    286: Result := pteMargemConsignavelExcedidaPrazo;
    287: Result := pteEmprestimoJaCadastrado;
    288: Result := pteEmprestimoInexistente;
    289: Result := pteEmprestimoJaEncerrado;
    290: Result := pteArquivoSemTrailer;
    291: Result := pteMutuarioSemCreditoCompetencia;
    292: Result := pteNaoDescontadoOutrosMotivos;
    293: Result := pteRetornoCreditoNaoPago;
    294: Result := pteCancelamentoEmprestimoRetroativo;
    295: Result := pteOutrosMotivosGlosa;
    296: Result := pteMargemConsignavelExcedidaAcimaPrazo;
    297: Result := pteMutuarioDesligadoEmpregador;
    298: Result := pteMutuarioAfastadoLicenca;
    299: Result := ptePrimeiroNomeMutuarioDiferente;
    300: Result := pteBeneficioSuspensoCessadoAPS;
    301: Result := pteBeneficioSuspensoDependenciaCalculo;
    302: Result := pteBeneficioSuspensoCessadoInspetoria;
    303: Result := pteBeneficioBloqueadoEmprestimoBeneficiario;
    304: Result := pteBeneficioBloqueadoEmprestimoTBM;
    305: Result := pteBeneficioFaseConcessaoPA;
    306: Result := pteBeneficioCessadoObito;
    307: Result := pteBeneficioCessadoFraude;
    308: Result := pteBeneficioCessadoOutroBeneficio;
    309: Result := pteBeneficioCessadoEstatutario;
    310: Result := pteEmprestimoSuspensoAPS;
    311: Result := pteEmprestimoCanceladoBanco;
    312: Result := pteCreditoTransformadoPAB;
    313: Result := pteTerminoConsignacaoAlterado;
    314: Result := pteFimEmprestimoPeriodoSuspensao;
    315: Result := pteEmprestimoSuspensoBanco;
    316: Result := pteNaoAverbacaoContratoQuantidadeParcelas;
    317: Result := pteLoteNaoAceitoTotaisDiferenca;
    318: Result := pteTituloNaoEncontrado;
    319: Result := pteIdentificadorRegistroOpcionalInvalido;
    320: Result := pteCodigoPadraoInvalido;
    321: Result := pteCodigoOcorrenciaInvalido;
    322: Result := pteComplementoOcorrenciaInvalido;
    323: Result := pteAlegacaoJaInformada;
    324: Result := pteAgenciaContaFavorecidoSubstituida;
    325: Result := pteDivergenciaNomeBeneficiario;
    326: Result := pteConfirmacaoAntecipacaoValor;
    327: Result := pteAntecipacaoParcialValor;
    328: Result := pteBoletoBloqueadoBase;
    329: Result := pteSistemaContingenciaBoletoValorMaior;
    330: Result := pteSistemaContingenciaBoletoVencido;
    331: Result := pteSistemaContingenciaBoletoIndexado;
    332: Result := pteBeneficiarioDivergente;
    333: Result := pteLimitePagamentosParciaisExcedido;
    334: Result := pteBoletoJaLiquidado;
    999: Result := pteConsultarBancoDetalharErro;
  end;
end;

function EstadoRequisicaoToInteger(const aValue: TACBrLoteEstadoRequisicao): Integer;
begin
  Result := 0;
  case aValue of
    lerDadosConsistentes: Result := 1;
    lerDadosInconsistentesParcial: Result := 2;
    lerDadosInconsistentesTotal: Result := 3;
    lerPendenteAcaoConveniado: Result := 4;
    lerEmProcessamentoBanco: Result := 5;
    lerProcessada: Result := 6;
    lerRejeitada: Result := 7;
    lerPreparandoRemessaNaoLiberada: Result := 8;
    lerLiberadaViaAPI: Result := 9;
    lerPreparandoRemessaLiberada: Result := 10;
  end;
end;

function IntegerToEstadoRequisicao(const aValue: Integer): TACBrLoteEstadoRequisicao;
begin
  Result := lerNenhum;
  case aValue of
    1: Result := lerDadosConsistentes;
    2: Result := lerDadosInconsistentesParcial;
    3: Result := lerDadosInconsistentesTotal;
    4: Result := lerPendenteAcaoConveniado;
    5: Result := lerEmProcessamentoBanco;
    6: Result := lerProcessada;
    7: Result := lerRejeitada;
    8: Result := lerPreparandoRemessaNaoLiberada;
    9: Result := lerLiberadaViaAPI;
    10: Result := lerPreparandoRemessaLiberada;
  end;
end;

function TipoContribuinteToInteger(const aValue: TACBrTipoContribuinte): Integer;
begin
  Result := 0;
  case aValue of
    tctCNPJ: Result := 1;
    tctCPF: Result := 2;
    tctNITPISPASEP: Result := 3;
    tctCEI: Result := 4;
    tctNB: Result := 6;
    tctNumeroTitulo: Result := 7;
    tctDEBCAD: Result := 8;
    tctReferencia: Result := 9;
  end;
end;

function IntegerToTipoContribuinte(const aValue: Integer): TACBrTipoContribuinte;
begin
  Result := tctNenhum;
  case aValue of
    1: Result := tctCNPJ;
    2: Result := tctCPF;
    3: Result := tctNITPISPASEP;
    4: Result := tctCEI;
    6: Result := tctNB;
    7: Result := tctNumeroTitulo;
    8: Result := tctDEBCAD;
    9: Result := tctReferencia;
  end;
end;

{ TACBrGPSLancamentoResposta }

constructor TACBrGPSLancamentoResposta.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  erros.Clear;
end;

{ TACBrGRUPagamentoResposta }

constructor TACBrGRUPagamentoResposta.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  erros.Clear;
end;

{ TACBrGuiaCodBarrasLancamentoResposta }

constructor TACBrGuiaCodBarrasLancamentoResposta.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  errors.Clear;
end;

{ TACBrBoletosLancamentoResposta }

constructor TACBrBoletosLancamentoResposta.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  errorCodes.Clear;
end;

{ TACBrLoteGPSResposta }

constructor TACBrLoteGPSResposta.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  lancamentos.Clear;
end;

procedure TACBrLoteGPSResposta.Assign(aSource: TACBrLoteRespostaClass);
begin
  inherited Assign(aSource);
  if (aSource is TACBrLoteGPSResposta) then
    lancamentos.Assign(TACBrLoteGPSResposta(aSource).lancamentos);
end;

{ TACBrGPSLancamentosResposta }

function TACBrGPSLancamentosResposta.GetItem(aIndex: Integer): TACBrGPSLancamentoResposta;
begin
  Result := TACBrGPSLancamentoResposta(inherited Items[aIndex]);
end;

procedure TACBrGPSLancamentosResposta.SetItem(aIndex: Integer; aValue: TACBrGPSLancamentoResposta);
begin
  inherited Items[aIndex] := aValue;
end;

function TACBrGPSLancamentosResposta.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrGPSLancamentosResposta.Add(aLancamento: TACBrGPSLancamentoResposta): Integer;
begin
  Result := inherited Add(aLancamento);
end;

procedure TACBrGPSLancamentosResposta.Insert(aIndex: Integer; aLancamento: TACBrGPSLancamentoResposta);
begin
  inherited Insert(aIndex, aLancamento);
end;

function TACBrGPSLancamentosResposta.New: TACBrGPSLancamentoResposta;
begin
  Result := TACBrGPSLancamentoResposta.Create;
  Self.Add(Result);
end;

{ TACBrLoteGPSRequisicao }

constructor TACBrLoteGPSRequisicao.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  lancamentos.Clear;
end;

procedure TACBrLoteGPSRequisicao.Assign(aSource: TACBrLoteRequisicaoClass);
begin
  inherited Assign(aSource);
  if (aSource is TACBrLoteGPSRequisicao) then
    lancamentos.Assign(TACBrLoteGPSRequisicao(aSource).lancamentos);
end;

{ TACBrGPSLancamentos }

function TACBrGPSLancamentos.GetItem(aIndex: Integer): TACBrGPSLancamento;
begin
  Result := TACBrGPSLancamento(inherited Items[aIndex]);
end;

procedure TACBrGPSLancamentos.SetItem(aIndex: Integer; aValue: TACBrGPSLancamento);
begin
  inherited Items[aIndex] := aValue;
end;

function TACBrGPSLancamentos.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrGPSLancamentos.Add(aLancamento: TACBrGPSLancamento): Integer;
begin
  Result := inherited Add(aLancamento);
end;

procedure TACBrGPSLancamentos.Insert(aIndex: Integer; aLancamento: TACBrGPSLancamento);
begin
  inherited Insert(aIndex, aLancamento);
end;

function TACBrGPSLancamentos.New: TACBrGPSLancamento;
begin 
  Result := TACBrGPSLancamento.Create;
  Self.Add(Result);
end;

{ TACBrLoteGRUResposta }

constructor TACBrLoteGRUResposta.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  pagamentos.Clear;
end;

procedure TACBrLoteGRUResposta.Assign(aSource: TACBrLoteRespostaClass);
begin
  inherited Assign(aSource);
  if (aSource is TACBrLoteGRUResposta) then
    pagamentos.Assign(TACBrLoteGRUResposta(aSource).pagamentos);
end;

{ TACBrGRUPagamentosResposta }

function TACBrGRUPagamentosResposta.GetItem(aIndex: Integer): TACBrGRUPagamentoResposta;
begin
  Result := TACBrGRUPagamentoResposta(inherited Items[aIndex]);
end;

procedure TACBrGRUPagamentosResposta.SetItem(aIndex: Integer; aValue: TACBrGRUPagamentoResposta);
begin
  inherited Items[aIndex] := aValue;
end;

function TACBrGRUPagamentosResposta.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrGRUPagamentosResposta.Add(aLancamento: TACBrGRUPagamentoResposta): Integer;
begin
  Result := inherited Add(aLancamento);
end;

procedure TACBrGRUPagamentosResposta.Insert(aIndex: Integer; aLancamento: TACBrGRUPagamentoResposta);
begin
  inherited Insert(aIndex, aLancamento);
end;

function TACBrGRUPagamentosResposta.New: TACBrGRUPagamentoResposta;
begin
  Result := TACBrGRUPagamentoResposta.Create;
  Self.Add(Result);
end;

{ TACBrLoteGRURequisicao }

constructor TACBrLoteGRURequisicao.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  listaRequisicao.Clear;
end;

procedure TACBrLoteGRURequisicao.Assign(aSource: TACBrLoteRequisicaoClass);
begin
  inherited Assign(aSource);
  if (aSource is TACBrLoteGRURequisicao) then
    listaRequisicao.Assign(TACBrLoteGRURequisicao(aSource).listaRequisicao);
end;

{ TACBrGRULancamentos }

function TACBrGRULancamentos.GetItem(aIndex: Integer): TACBrGRULancamento;
begin
  Result := TACBrGRULancamento(inherited Items[aIndex]);
end;

procedure TACBrGRULancamentos.SetItem(aIndex: Integer; aValue: TACBrGRULancamento);
begin
  inherited Items[aIndex] := aValue;
end;

function TACBrGRULancamentos.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrGRULancamentos.Add(aLancamento: TACBrGRULancamento): Integer;
begin
  Result := inherited Add(aLancamento);
end;

procedure TACBrGRULancamentos.Insert(aIndex: Integer; aLancamento: TACBrGRULancamento);
begin
  inherited Insert(aIndex, aLancamento);
end;

function TACBrGRULancamentos.New: TACBrGRULancamento;
begin
  Result := TACBrGRULancamento.Create;
  Self.Add(Result);
end;

{ TACBrLoteGuiaCodBarrasResposta }

constructor TACBrLoteGuiaCodBarrasResposta.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  lancamentos.Clear;
end;

procedure TACBrLoteGuiaCodBarrasResposta.Assign(aSource: TACBrLoteRespostaClass);
begin
  inherited Assign(aSource);
  if (aSource is TACBrLoteGuiaCodBarrasResposta) then
    lancamentos.Assign(TACBrLoteGuiaCodBarrasResposta(aSource).lancamentos);
end;

{ TACBrGuiaCodBarrasLancamentosResposta }

function TACBrGuiaCodBarrasLancamentosResposta.GetItem(aIndex: Integer): TACBrGuiaCodBarrasLancamentoResposta;
begin
  Result := TACBrGuiaCodBarrasLancamentoResposta(inherited Items[aIndex]);
end;

procedure TACBrGuiaCodBarrasLancamentosResposta.SetItem(aIndex: Integer; aValue: TACBrGuiaCodBarrasLancamentoResposta);
begin
  inherited Items[aIndex] := aValue;
end;

function TACBrGuiaCodBarrasLancamentosResposta.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrGuiaCodBarrasLancamentosResposta.Add(aLancamento: TACBrGuiaCodBarrasLancamentoResposta): Integer;
begin
  Result := inherited Add(aLancamento);
end;

procedure TACBrGuiaCodBarrasLancamentosResposta.Insert(aIndex: Integer; aLancamento: TACBrGuiaCodBarrasLancamentoResposta);
begin
  inherited Insert(aIndex, aLancamento);
end;

function TACBrGuiaCodBarrasLancamentosResposta.New: TACBrGuiaCodBarrasLancamentoResposta;
begin
  Result := TACBrGuiaCodBarrasLancamentoResposta.Create;
  Self.Add(Result);
end;

{ TACBrLoteBoletosResposta }

constructor TACBrLoteBoletosResposta.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  lancamentos.Clear;
end;

procedure TACBrLoteBoletosResposta.Assign(aSource: TACBrLoteRespostaClass);
begin
  inherited Assign(ASource);
  if (aSource is TACBrLoteBoletosResposta) then
    lancamentos.Assign(TACBrLoteBoletosResposta(aSource).lancamentos);
end;

{ TACBrLoteGuiasCodigoBarrasRequisicao }

constructor TACBrLoteGuiasCodigoBarrasRequisicao.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  lancamentos.Clear;
end;

procedure TACBrLoteGuiasCodigoBarrasRequisicao.Assign(aSource: TACBrLoteRequisicaoClass);
begin
  inherited Assign(aSource);
  if aSource is TACBrLoteGuiasCodigoBarrasRequisicao then
    lancamentos.Assign(TACBrLoteGuiasCodigoBarrasRequisicao(aSource).lancamentos);
end;

{ TACBrLoteBoletosRequisicao }

constructor TACBrLoteBoletosRequisicao.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  lancamentos.Clear;
end;

procedure TACBrLoteBoletosRequisicao.Assign(aSource: TACBrLoteRequisicaoClass);
begin
  inherited Assign(ASource);
  if (aSource is TACBrLoteBoletosRequisicao) then
    lancamentos.Assign(TACBrLoteBoletosRequisicao(ASource).lancamentos);
end;

{ TACBrGuiasCodigoBarrasLancamentos }

function TACBrGuiasCodigoBarrasLancamentos.GetItem(aIndex: Integer): TACBrGuiasCodigoBarrasLancamento;
begin
  Result := TACBrGuiasCodigoBarrasLancamento(inherited Items[aIndex]);
end;

procedure TACBrGuiasCodigoBarrasLancamentos.SetItem(aIndex: Integer; aValue: TACBrGuiasCodigoBarrasLancamento);
begin
  inherited Items[aIndex] := aValue;
end;

function TACBrGuiasCodigoBarrasLancamentos.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrGuiasCodigoBarrasLancamentos.Add(aLancamento: TACBrGuiasCodigoBarrasLancamento): Integer;
begin
  Result := inherited Add(aLancamento);
end;

procedure TACBrGuiasCodigoBarrasLancamentos.Insert(aIndex: Integer; aLancamento: TACBrGuiasCodigoBarrasLancamento);
begin
  inherited Insert(aIndex, aLancamento);
end;

function TACBrGuiasCodigoBarrasLancamentos.New: TACBrGuiasCodigoBarrasLancamento;
begin
  Result := TACBrGuiasCodigoBarrasLancamento.Create;
  Self.Add(Result);
end;

{ TACBrTransferenciaErros }

function TACBrTransferenciaErros.GetItem(aIndex: Integer): TACBrTransferenciaErroObject;
begin
  Result := TACBrTransferenciaErroObject(inherited Items[aIndex]);
end;

procedure TACBrTransferenciaErros.SetItem(aIndex: Integer; aValue: TACBrTransferenciaErroObject);
begin
  inherited Items[aIndex] := aValue;
end;

function TACBrTransferenciaErros.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrTransferenciaErros.Add(aItem: TACBrTransferenciaErroObject): Integer;
begin
  Result := inherited Add(aItem);
end;

procedure TACBrTransferenciaErros.Insert(aIndex: Integer; aItem: TACBrTransferenciaErroObject);
begin
  inherited Insert(aIndex, aItem);
end;

function TACBrTransferenciaErros.New: TACBrTransferenciaErroObject;
begin
  Result := TACBrTransferenciaErroObject.Create;
  Self.Add(Result);
end;

procedure TACBrTransferenciaErros.ReadFromJSon(AJSon: TACBrJSONObject);
var
  i: Integer;
  ja: TACBrJsonArray;
begin
  Clear;
  ja := AJSon.AsJSONArray[fpArrayName];
  for i := 0 to ja.Count - 1 do
    New.Erro := TACBrTransferenciaErro(StrToIntDef(ja.Items[i], 0));
end;

procedure TACBrTransferenciaErros.WriteToJSon(AJSon: TACBrJSONObject);
var
  i: Integer;
  ja: TACBrJsonArray;
begin
  if IsEmpty then
    Exit;

  ja := TACBrJSONArray.Create;
  try
    for i := 0 to Count - 1 do
      ja.AddElement(TransferenciaErroToInteger(Items[i].Erro));

    AJSon.AddPair(fpArrayName, ja);
  except
    ja.Free;
    raise;
  end;
end;

{ TACBrPagamentosAPIErros }

function TACBrPagamentosAPIErros.GetItem(aIndex: Integer): TACBrPagamentosAPIErro;
begin
  Result := TACBrPagamentosAPIErro(inherited Items[aIndex]);
end;

function TACBrPagamentosAPIErros.GetOAuthError: TACBrPagamentosErroOAuth;
begin
  if (not Assigned(fOAuthError)) then
    fOAuthError := TACBrPagamentosErroOAuth.Create();
  Result := fOAuthError;
end;

procedure TACBrPagamentosAPIErros.SetItem(aIndex: Integer; aValue: TACBrPagamentosAPIErro);
begin
  inherited Items[aIndex] := aValue;
end;

function TACBrPagamentosAPIErros.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrPagamentosAPIErros.Add(aItem: TACBrPagamentosAPIErro): Integer;
begin
  Result := inherited Add(aItem);
end;

procedure TACBrPagamentosAPIErros.Insert(aIndex: Integer; aItem: TACBrPagamentosAPIErro);
begin
  inherited Insert(aIndex, aItem);
end;

function TACBrPagamentosAPIErros.New: TACBrPagamentosAPIErro;
begin
  Result := TACBrPagamentosAPIErro.Create;
  Self.Add(Result);
end;

function TACBrPagamentosAPIErros.IsOAuthError: Boolean;
begin
  Result := Assigned(fOAuthError) and NaoEstaVazio(fOAuthError.error);
end;

{ TACBrPagamentosErroOAuth }

procedure TACBrPagamentosErroOAuth.AssignSchema(aSource: TACBrAPISchema);
begin
  if (aSource is TACBrPagamentosErroOAuth) then
    Assign(TACBrPagamentosErroOAuth(ASource));
end;

procedure TACBrPagamentosErroOAuth.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('statusCode', fstatusCode)
    .AddPair('error', ferror)
    .AddPair('message', fmessage);
end;

procedure TACBrPagamentosErroOAuth.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .Value('statusCode', fstatusCode)
    .Value('error', ferror)
    .Value('message', fmessage);
end;

procedure TACBrPagamentosErroOAuth.Clear;
begin
  fstatusCode := 0;
  ferror := EmptyStr;
  fmessage := EmptyStr;
end;

function TACBrPagamentosErroOAuth.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fstatusCode) and
    EstaVazio(ferror) and
    EstaVazio(fmessage);
end;

procedure TACBrPagamentosErroOAuth.Assign(aSource: TACBrPagamentosErroOAuth);
begin
  fstatusCode := ASource.statusCode;
  ferror := ASource.error;
  fmessage := ASource.message;
end;

{ TACBrBoletosLancamentosResposta }

function TACBrBoletosLancamentosResposta.GetItem(aIndex: Integer
  ): TACBrBoletosLancamentoResposta;
begin
  Result := TACBrBoletosLancamentoResposta(inherited Items[aIndex]);
end;

procedure TACBrBoletosLancamentosResposta.SetItem(aIndex: Integer;
  aValue: TACBrBoletosLancamentoResposta);
begin
  inherited Items[aIndex] := aValue;
end;

function TACBrBoletosLancamentosResposta.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrBoletosLancamentosResposta.Add(
  aLancamento: TACBrBoletosLancamentoResposta): Integer;
begin
  Result := inherited Add(aLancamento);
end;

procedure TACBrBoletosLancamentosResposta.Insert(aIndex: Integer;
  aLancamento: TACBrBoletosLancamentoResposta);
begin
  inherited Insert(aIndex, aLancamento);
end;

function TACBrBoletosLancamentosResposta.New: TACBrBoletosLancamentoResposta;
begin
  Result := TACBrBoletosLancamentoResposta.Create;
  Self.Add(Result);
end;

{ TACBrLoteRespostaClass }

function TACBrLoteRespostaClass.GetBoletoLancamentos: TACBrBoletosLancamentosResposta;
begin
  if (not Assigned(fBoletolancamentos)) then
    fBoletolancamentos := TACBrBoletosLancamentosResposta.Create('lancamentos');
  Result := fBoletolancamentos;
end;

function TACBrLoteRespostaClass.GetGuiaCodBarrasLancamentos: TACBrGuiaCodBarrasLancamentosResposta;
begin
  if (not Assigned(fGuiaCodBarraslancamentos)) then
    fGuiaCodBarraslancamentos := TACBrGuiaCodBarrasLancamentosResposta.Create('lancamentos');
  Result := fGuiaCodBarraslancamentos;
end;

function TACBrLoteRespostaClass.GetGRUPagamentos: TACBrGRUPagamentosResposta;
begin
  if (not Assigned(fGRUPagamentos)) then
    fGRUPagamentos := TACBrGRUPagamentosResposta.Create('pagamentos');
  Result := fGRUPagamentos;
end;

function TACBrLoteRespostaClass.GetGPSLancamentos: TACBrGPSLancamentosResposta;
begin
  if (not Assigned(fGPSlancamentos)) then
    fGPSlancamentos := TACBrGPSLancamentosResposta.Create('lancamentos');
  Result := fGPSlancamentos;
end;

procedure TACBrLoteRespostaClass.AssignSchema(ASource: TACBrAPISchema);
begin
  if (aSource is TACBrLoteRespostaClass) then
    Assign(TACBrLoteRespostaClass(ASource));
end;

procedure TACBrLoteRespostaClass.DoWriteToJSon(AJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('numeroRequisicao', fnumeroRequisicao, False)
    .AddPair('estadoRequisicao', festadoRequisicao, False)
    .AddPair('codigoEstado', EstadoRequisicaoToInteger(fcodigoEstado), False)
    .AddPair('quantidadeLancamentos', fquantidadeLancamentos, False)
    .AddPair('valorLancamentos', fvalorLancamentos, False)
    .AddPair('quantidadeLancamentosValidos', fquantidadeLancamentosValidos, False)
    .AddPair('valorLancamentosValidos', fvalorLancamentosValidos, False)
    .AddPair('codigoEstadoRequisicao', EstadoRequisicaoToInteger(fcodigoEstadoRequisicao), False)
    .AddPair('quantidadeTotalLancamento', fquantidadeTotalLancamento, False)
    .AddPair('valorTotal', fvalorTotal, False)
    .AddPair('valorTotalValido', fvalorTotalValido, False)
    .AddPair('valorTotalLancamento', fvalorTotalLancamento, False)
    .AddPair('quantidadeTotalValido', fquantidadeTotalValido, False)
    .AddPair('quantidadeTotal', fquantidadeTotal, False);

  if Assigned(fBoletolancamentos) then
    fBoletolancamentos.WriteToJSon(aJSon);
  if Assigned(fGuiaCodBarraslancamentos) then
    fGuiaCodBarraslancamentos.WriteToJSon(aJSon);
  if Assigned(fGRUPagamentos) then
    fGRUPagamentos.WriteToJSon(aJSon);
  if Assigned(fGPSlancamentos) then
    fGPSlancamentos.WriteToJSon(aJSon);
end;

procedure TACBrLoteRespostaClass.DoReadFromJSon(AJSon: TACBrJSONObject);
var
  i, i2: Integer;
begin
  aJSon
    .Value('numeroRequisicao', fnumeroRequisicao)
    .Value('estadoRequisicao', festadoRequisicao)
    .Value('codigoEstado', i)
    .Value('quantidadeLancamentos', fquantidadeLancamentos)
    .Value('valorLancamentos', fvalorLancamentos)
    .Value('quantidadeLancamentosValidos', fquantidadeLancamentosValidos)
    .Value('valorLancamentosValidos', fvalorLancamentosValidos)
    .Value('codigoEstadoRequisicao', i2)
    .Value('quantidadeTotalLancamento', fquantidadeTotalLancamento)
    .Value('valorTotal', fvalorTotal)
    .Value('valorTotalValido', fvalorTotalValido)
    .Value('valorTotalLancamento', fvalorTotalLancamento)
    .Value('quantidadeTotalValido', fquantidadeTotalValido)
    .Value('quantidadeTotal', fquantidadeTotal);

  if NaoEstaZerado(i) then
    fcodigoEstado := IntegerToEstadoRequisicao(i);
  if NaoEstaZerado(i2) then
    fcodigoEstadoRequisicao := IntegerToEstadoRequisicao(i2);

  if Assigned(fBoletolancamentos) then
    fBoletolancamentos.ReadFromJSon(aJSon); 
  if Assigned(fGuiaCodBarraslancamentos) then
    fGuiaCodBarraslancamentos.ReadFromJSon(aJSon);
  if Assigned(fGRUPagamentos) then
    fGRUPagamentos.ReadFromJSon(aJSon);
  if Assigned(fGPSlancamentos) then
    fGPSlancamentos.ReadFromJSon(aJSon);
end;

destructor TACBrLoteRespostaClass.Destroy;
begin
  if Assigned(fBoletolancamentos) then
    fBoletolancamentos.Free; 
  if Assigned(fGuiaCodBarraslancamentos) then
    fGuiaCodBarraslancamentos.Free;
  if Assigned(fGRUPagamentos) then
    fGRUPagamentos.Free;
  if Assigned(fGPSlancamentos) then
    fGPSlancamentos.Free;
  inherited Destroy;
end;

procedure TACBrLoteRespostaClass.Clear;
begin
  fnumeroRequisicao:= 0;
  festadoRequisicao:= 0;
  fcodigoEstado := lerNenhum;
  fquantidadeLancamentos:= 0;
  fvalorLancamentos:= 0;
  fquantidadeLancamentosValidos:= 0;
  fvalorLancamentosValidos:= 0;
  fquantidadeTotal := 0;
  fvalorTotal := 0;
  fquantidadeTotalValido := 0;
  fvalorTotalValido := 0;
  fcodigoEstadoRequisicao := lerNenhum;
  fquantidadeTotalLancamento := 0;
  fvalorTotalLancamento := 0;
  if Assigned(fBoletolancamentos) then
    fBoletolancamentos.Clear;   
  if Assigned(fGuiaCodBarraslancamentos) then
    fGuiaCodBarraslancamentos.Clear;
  if Assigned(fGRUPagamentos) then
    fGRUPagamentos.Clear;
  if Assigned(fGPSlancamentos) then
    fGPSlancamentos.Clear;
end;

function TACBrLoteRespostaClass.IsEmpty: Boolean;
begin
  Result :=
    (fcodigoEstado = lerNenhum) and
    (fcodigoEstadoRequisicao = lerNenhum) and
    EstaZerado(fnumeroRequisicao) and
    EstaZerado(festadoRequisicao) and
    EstaZerado(fquantidadeLancamentos) and
    EstaZerado(fvalorLancamentos) and
    EstaZerado(fquantidadeLancamentosValidos) and
    EstaZerado(fvalorLancamentosValidos) and
    EstaZerado(fquantidadeTotal) and
    EstaZerado(fvalorTotal) and
    EstaZerado(fquantidadeTotalValido) and
    EstaZerado(fvalorTotalValido) and
    EstaZerado(fquantidadeTotalLancamento) and
    EstaZerado(fvalorTotalLancamento);
  if Assigned(fBoletolancamentos) then
    Result := Result and fBoletolancamentos.IsEmpty;
  if Assigned(fGuiaCodBarraslancamentos) then
    Result := Result and fGuiaCodBarraslancamentos.IsEmpty;
  if Assigned(fGRUPagamentos) then
    Result := Result and fGRUPagamentos.IsEmpty;
  if Assigned(fGPSlancamentos) then
    Result := Result and fGPSlancamentos.IsEmpty;
end;

procedure TACBrLoteRespostaClass.Assign(aSource: TACBrLoteRespostaClass);
begin
  fnumeroRequisicao := aSource.numeroRequisicao;
  festadoRequisicao := aSource.estadoRequisicao;
  fcodigoEstado := aSource.codigoEstado;
  fquantidadeLancamentos := aSource.quantidadeLancamentos;
  fvalorLancamentos := aSource.valorLancamentos;
  fquantidadeLancamentosValidos := aSource.quantidadeLancamentosValidos;
  fvalorLancamentosValidos := aSource.valorLancamentosValidos; 
  fquantidadeTotal := aSource.quantidadeTotal;
  fvalorTotal := aSource.valorTotal;
  fquantidadeTotalValido := aSource.quantidadeTotalValido;
  fvalorTotalValido := aSource.valorTotalValido;
  fcodigoEstadoRequisicao := aSource.codigoEstadoRequisicao;
  fquantidadeTotalLancamento := aSource.quantidadeTotalLancamento;
  fvalorTotalLancamento := aSource.valorTotalLancamento;
end;

{ TACBrPagamentosAPIErro }

procedure TACBrPagamentosAPIErro.AssignSchema(aSource: TACBrAPISchema);
begin
  if (aSource is TACBrPagamentosAPIErro) then
    Assign(TACBrPagamentosAPIErro(aSource));
end;

procedure TACBrPagamentosAPIErro.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('codigo', fcodigo)
    .AddPair('mensagem', fmensagem)
    .AddPair('ocorrencia', focorrencia)
    .AddPair('versao', fversao);
end;

procedure TACBrPagamentosAPIErro.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .Value('codigo', fcodigo)
    .Value('mensagem', fmensagem)
    .Value('ocorrencia', focorrencia)
    .Value('versao', fversao);
end;

destructor TACBrPagamentosAPIErro.Destroy;
begin
  inherited Destroy;
end;

procedure TACBrPagamentosAPIErro.Clear;
begin
  fcodigo := EmptyStr;
  fmensagem := EmptyStr;
  focorrencia := EmptyStr;
  fversao := EmptyStr;
end;

function TACBrPagamentosAPIErro.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fcodigo) and
    EstaVazio(fmensagem) and
    EstaVazio(focorrencia) and
    EstaVazio(fversao);
end;

procedure TACBrPagamentosAPIErro.Assign(aSource: TACBrPagamentosAPIErro);
begin
  fcodigo := aSource.codigo;
  fmensagem := aSource.mensagem;
  focorrencia := aSource.ocorrencia;
  fversao := aSource.versao;
end;

{ TACBrLoteRequisicaoClass }

function TACBrLoteRequisicaoClass.GetBoletolancamentos: TACBrBoletosLancamentos;
begin
  if (not Assigned(fBoletolancamentos)) then
    fBoletolancamentos := TACBrBoletosLancamentos.Create('lancamentos');
  Result := fBoletolancamentos;
end;

function TACBrLoteRequisicaoClass.GetGuiaCodBarraslancamentos: TACBrGuiasCodigoBarrasLancamentos;
begin
  if (not Assigned(fGuiaCodBarraslancamentos)) then
    fGuiaCodBarraslancamentos := TACBrGuiasCodigoBarrasLancamentos.Create('lancamentos');
  Result := fGuiaCodBarraslancamentos;
end;

function TACBrLoteRequisicaoClass.GetGRUlistaRequisicao: TACBrGRULancamentos;
begin
  if (not Assigned(fGRUlistaRequisicao)) then
    fGRUlistaRequisicao := TACBrGRULancamentos.Create('listaRequisicao');
  Result := fGRUlistaRequisicao;
end;

function TACBrLoteRequisicaoClass.GetGPSlancamentos: TACBrGPSLancamentos;
begin
  if (not Assigned(fGPSlancamentos)) then
    fGPSlancamentos := TACBrGPSLancamentos.Create('lancamentos');
  Result := fGPSlancamentos;
end;

procedure TACBrLoteRequisicaoClass.AssignSchema(aSource: TACBrAPISchema);
begin
  if (aSource is TACBrLoteRequisicaoClass) then
    Assign(TACBrLoteRequisicaoClass(ASource));
end;

procedure TACBrLoteRequisicaoClass.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('numeroRequisicao', fnumeroRequisicao)
    .AddPair('codigoContrato', fcodigoContrato)
    .AddPair('agencia', fagencia, False)
    .AddPair('conta', fconta, False)
    .AddPair('digitoConta', fdigitoConta, False)
    .AddPair('numeroAgenciaDebito', fnumeroAgenciaDebito, False)
    .AddPair('numeroContaCorrenteDebito', fnumeroContaCorrenteDebito, False)
    .AddPair('digitoVerificadorContaCorrenteDebito', fdigitoVerificadorContaCorrenteDebito, False);

  if Assigned(fBoletolancamentos) then
    fBoletolancamentos.WriteToJSon(AJSon);
  if Assigned(fGuiaCodBarraslancamentos) then
    fGuiaCodBarraslancamentos.WriteToJSon(AJSon);
  if Assigned(fGRUlistaRequisicao) then
    fGRUlistaRequisicao.WriteToJSon(AJSon);
  if Assigned(fGPSlancamentos) then
    fGPSlancamentos.WriteToJSon(AJSon);
end;

procedure TACBrLoteRequisicaoClass.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .Value('numeroRequisicao', fnumeroRequisicao)
    .Value('codigoContrato', fcodigoContrato)
    .Value('agencia', fagencia)
    .Value('conta', fconta)
    .Value('digitoConta', fdigitoConta)
    .Value('numeroAgenciaDebito', fnumeroAgenciaDebito)
    .Value('numeroContaCorrenteDebito', fnumeroContaCorrenteDebito)
    .Value('digitoVerificadorContaCorrenteDebito', fdigitoVerificadorContaCorrenteDebito);
  if Assigned(fBoletolancamentos) then
    fBoletolancamentos.ReadFromJSon(AJSon);
  if Assigned(fGuiaCodBarraslancamentos) then
    fGuiaCodBarraslancamentos.ReadFromJSon(AJSon); 
  if Assigned(fGRUlistaRequisicao) then
    fGRUlistaRequisicao.ReadFromJSon(AJSon);
end;

destructor TACBrLoteRequisicaoClass.Destroy;
begin
  if Assigned(fBoletolancamentos) then
    fBoletolancamentos.Free;
  if Assigned(fGuiaCodBarraslancamentos) then
    fGuiaCodBarraslancamentos.Free;  
  if Assigned(fGRUlistaRequisicao) then
    fGRUlistaRequisicao.Free;
  if Assigned(fGPSlancamentos) then
    fGPSlancamentos.Free;
  inherited Destroy;
end;

procedure TACBrLoteRequisicaoClass.Clear;
begin
  fnumeroRequisicao := 0;
  fcodigoContrato := 0;
  fagencia := 0;
  fconta := 0;
  fdigitoConta := '';
  fnumeroAgenciaDebito := 0;
  fnumeroContaCorrenteDebito := 0;
  fdigitoVerificadorContaCorrenteDebito := '';
  if Assigned(fBoletolancamentos) then
    fBoletolancamentos.Clear;  
  if Assigned(fGuiaCodBarraslancamentos) then
    fGuiaCodBarraslancamentos.Clear;
  if Assigned(fGRUlistaRequisicao) then
    fGRUlistaRequisicao.Clear;
  if Assigned(fGPSlancamentos) then
    fGPSlancamentos.Clear;
end;

function TACBrLoteRequisicaoClass.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fnumeroRequisicao) and
    EstaZerado(fcodigoContrato) and
    EstaZerado(fagencia) and
    EstaZerado(fconta) and
    EstaVazio(fdigitoConta) and
    EstaZerado(fnumeroAgenciaDebito) and
    EstaZerado(fnumeroContaCorrenteDebito) and
    EstaVazio(fdigitoVerificadorContaCorrenteDebito);
  if Assigned(fBoletolancamentos) then
    Result := Result and fBoletolancamentos.IsEmpty;
  if Assigned(fGuiaCodBarraslancamentos) then
    Result := Result and fGuiaCodBarraslancamentos.IsEmpty; 
  if Assigned(fGRUlistaRequisicao) then
    Result := Result and fGRUlistaRequisicao.IsEmpty;
  if Assigned(fGPSlancamentos) then
    Result := Result and fGPSlancamentos.IsEmpty;
end;

procedure TACBrLoteRequisicaoClass.Assign(aSource: TACBrLoteRequisicaoClass);
begin
  fnumeroRequisicao := ASource.numeroRequisicao;
  fcodigoContrato := ASource.codigoContrato;
  fagencia := ASource.agencia;
  fconta := ASource.conta;
  fdigitoConta := ASource.digitoConta;
  fnumeroAgenciaDebito := ASource.numeroAgenciaDebito;
  fnumeroContaCorrenteDebito := ASource.numeroContaCorrenteDebito;
  fdigitoVerificadorContaCorrenteDebito := ASource.digitoVerificadorContaCorrenteDebito;
end;

{ TACBrBoletosLancamentos }

function TACBrBoletosLancamentos.GetItem(aIndex: Integer): TACBrBoletosLancamento;
begin
  Result := TACBrBoletosLancamento(inherited Items[aIndex]);
end;

procedure TACBrBoletosLancamentos.SetItem(aIndex: Integer;
  aValue: TACBrBoletosLancamento);
begin
  inherited Items[aIndex] := aValue;
end;

function TACBrBoletosLancamentos.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrBoletosLancamentos.Add(
  aLancamento: TACBrBoletosLancamento): Integer;
begin
  Result := inherited Add(aLancamento);
end;

procedure TACBrBoletosLancamentos.Insert(aIndex: Integer;
  aLancamento: TACBrBoletosLancamento);
begin
  inherited Insert(aIndex, aLancamento);
end;

function TACBrBoletosLancamentos.New: TACBrBoletosLancamento;
begin
  Result := TACBrBoletosLancamento.Create;
  Self.Add(Result);
end;

{ TACBrLancamentoClass }

function TACBrLancamentoClass.GeterrorCodes: TACBrTransferenciaErros;
begin
  if (not Assigned(ferrorCodes)) then
    ferrorCodes := TACBrTransferenciaErros.Create('errorCodes');
  Result := ferrorCodes;
end;

function TACBrLancamentoClass.Geterrors: TACBrTransferenciaErros;
begin
  if (not Assigned(ferrors)) then
    ferrors := TACBrTransferenciaErros.Create('errors');
  Result := ferrors;
end;

function TACBrLancamentoClass.Geterros: TACBrTransferenciaErros;
begin
  if (not Assigned(ferros)) then
    ferros := TACBrTransferenciaErros.Create('erros');
  Result := ferros;
end;

procedure TACBrLancamentoClass.AssignSchema(ASource: TACBrAPISchema);
begin
  if (ASource is TACBrLancamentoClass) then
    Assign(TACBrLancamentoClass(ASource));
end;

procedure TACBrLancamentoClass.DoWriteToJSon(AJSon: TACBrJSONObject);
var
  dataStr: String;
begin
  // Boletos
  dataStr := EmptyStr;
  if NaoEstaZerado(fdataPagamento) then
    dataStr := FormatDateTimeBr(fdataPagamento, 'DDMMYYYY');
  AJSon
    .AddPair('codigoIdentificadorPagamento', fcodigoIdentificadorPagamento, False)
    .AddPair('numeroDocumentoDebito', fnumeroDocumentoDebito)
    .AddPair('numeroCodigoBarras', fnumeroCodigoBarras, False)
    .AddPair('codigoBarras', fcodigoBarras, False)
    .AddPair('dataPagamento', StrToIntDef(dataStr, 0))
    .AddPair('valorPagamento', fvalorPagamento)
    .AddPair('descricaoPagamento', fdescricaoPagamento, False)
    .AddPair('codigoSeuDocumento', fcodigoSeuDocumento, False)
    .AddPair('codigoNossoDocumento', fcodigoNossoDocumento, False)
    .AddPair('valorNominal', fvalorNominal)
    .AddPair('valorDesconto', fvalorDesconto, False)
    .AddPair('valorMoraMulta', fvalorMoraMulta, False)
    .AddPair('codigoTipoPagador', TipoPessoaToInt(fcodigoTipoPagador), False)
    .AddPair('documentoPagador', fdocumentoPagador, False)
    .AddPair('nomePagador', fnomePagador, False)
    .AddPair('codigoTipoBeneficiario', TipoPessoaToInt(fcodigoTipoBeneficiario))
    .AddPair('documentoBeneficiario', fdocumentoBeneficiario)
    .AddPair('nomeBeneficiario', fnomeBeneficiario, False)
    .AddPair('codigoTipoAvalista', TipoPessoaToInt(fcodigoTipoAvalista), False)
    .AddPair('documentoAvalista', fdocumentoAvalista, False)
    .AddPair('nomeAvalista', fnomeAvalista, False)
    .AddPair('indicadorAceite', findicadorAceite, False);

  // GRU  
  dataStr := EmptyStr;
  if NaoEstaZerado(fdataVencimento) then
    dataStr := FormatDateTime('DDMMYYYY', fdataVencimento);
  aJSon
    .AddPair('idPagamento', fidPagamento, False)
    .AddPair('nomeRecebedor', fnomeRecebedor, False)
    .AddPair('textoPagamento', ftextoPagamento, False)
    .AddPair('dataVencimento', StrToIntDef(dataStr, 0), False)
    .AddPair('numeroReferencia', fnumeroReferencia, False)
    .AddPair('mesAnoCompetencia', fmesAnoCompetencia, False)
    .AddPair('idContribuinte', fidContribuinte, False)
    .AddPair('valorPrincipal', fvalorPrincipal, False)
    .AddPair('valorOutraDeducao', fvalorOutraDeducao, False)
    .AddPair('valorMulta', fvalorMulta, False)
    .AddPair('valorJuroEncargo', fvalorJuroEncargo, False)
    .AddPair('valorOutroAcrescimo', fvalorOutroAcrescimo, False)
    .AddPair('valorOutrosAcrescimos', fvalorOutrosAcrescimos, False)
    .AddPair('indicadorMovimentoAceito', findicadorMovimentoAceito, False);

  // GPS
  aJSon
    .AddPair('textoDescricaoPagamento', ftextoDescricaoPagamento, False)
    .AddPair('nomeConvenente', fnomeConvenente, False)
    .AddPair('codigoReceitaTributoGuiaPrevidenciaSocial', fcodigoReceitaTributoGuiaPrevidenciaSocial, False)
    .AddPair('codigoTipoContribuinteGuiaPrevidenciaSocial', TipoContribuinteToInteger(fcodigoTipoContribuinteGuiaPrevidenciaSocial), False)
    .AddPair('numeroIdentificacaoContribuinteGuiaPrevidenciaSocial', fnumeroIdentificacaoContribuinteGuiaPrevidenciaSocial, False)
    .AddPair('codigoIdentificadorTributoGuiaPrevidenciaSocial', fcodigoIdentificadorTributoGuiaPrevidenciaSocial, False)
    .AddPair('mesAnoCompetenciaGuiaPrevidenciaSocial', fmesAnoCompetenciaGuiaPrevidenciaSocial, False)
    .AddPair('valorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial', fvalorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial, False)
    .AddPair('valorOutroEntradaGuiaPrevidenciaSocial', fvalorOutroEntradaGuiaPrevidenciaSocial, False)
    .AddPair('valorAtualizacaoMonetarioGuiaPrevidenciaSocial', fvalorAtualizacaoMonetarioGuiaPrevidenciaSocial, False);

  if Assigned(ferros) then
    ferros.WriteToJSon(AJSon);
  if Assigned(ferrors) then
    ferrors.WriteToJSon(AJSon);
  if Assigned(ferrorCodes) then
    ferrorCodes.WriteToJSon(AJSon);
end;

procedure TACBrLancamentoClass.DoReadFromJSon(AJSon: TACBrJSONObject);
var
  i, i1, i2, i3, i4, i5: Integer;
  s: String;
  d, m, a: word;
begin
  // Boletos
  AJSon
    .Value('codigoIdentificadorPagamento', fcodigoIdentificadorPagamento)
    .Value('numeroDocumentoDebito', fnumeroDocumentoDebito)
    .Value('numeroCodigoBarras', fnumeroCodigoBarras)
    .Value('codigoBarras', fcodigoBarras)
    .Value('dataPagamento', i)
    .Value('valorPagamento', fvalorPagamento)
    .Value('descricaoPagamento', fdescricaoPagamento)
    .Value('codigoSeuDocumento', fcodigoSeuDocumento)
    .Value('codigoNossoDocumento', fcodigoNossoDocumento)
    .Value('valorNominal', fvalorNominal)
    .Value('valorDesconto', fvalorDesconto)
    .Value('valorMoraMulta', fvalorMoraMulta)
    .Value('codigoTipoPagador', i1)
    .Value('documentoPagador', fdocumentoPagador)
    .Value('nomePagador', fnomePagador)
    .Value('codigoTipoBeneficiario', i2)
    .Value('documentoBeneficiario', fdocumentoBeneficiario)
    .Value('nomeBeneficiario', fnomeBeneficiario)
    .Value('codigoTipoAvalista', i3)
    .Value('documentoAvalista', fdocumentoAvalista)
    .Value('nomeAvalista', fnomeAvalista)
    .Value('indicadorAceite', findicadorAceite);
  fcodigoTipoPagador := IntToTipoPessoa(i1);
  fcodigoTipoBeneficiario := IntToTipoPessoa(i2);
  fcodigoTipoAvalista := IntToTipoPessoa(i3);
  if NaoEstaZerado(i) then
  begin
    s := IntToStrZero(i, 8);
    d := Copy(s, 1, 2).ToInteger;
    m := Copy(s, 3, 2).ToInteger;
    a := Copy(s, 5, 4).ToInteger;
    fdataPagamento := EncodeDate(a, m, d);
  end;

  // GRU 
  aJSon  
    .Value('idPagamento', fidPagamento)
    .Value('nomeRecebedor', fnomeRecebedor)
    .Value('textoPagamento', ftextoPagamento)
    .Value('dataVencimento', i5)
    .Value('numeroReferencia', fnumeroReferencia)
    .Value('mesAnoCompetencia', fmesAnoCompetencia)
    .Value('idContribuinte', fidContribuinte)
    .Value('valorPrincipal', fvalorPrincipal)
    .Value('valorOutraDeducao', fvalorOutraDeducao)
    .Value('valorMulta', fvalorMulta)
    .Value('valorJuroEncargo', fvalorJuroEncargo)
    .Value('valorOutroAcrescimo', fvalorOutroAcrescimo)
    .Value('valorOutrosAcrescimos', fvalorOutrosAcrescimos)
    .Value('indicadorMovimentoAceito', findicadorMovimentoAceito);
  if NaoEstaZerado(i5) then
  begin           
    s := IntToStrZero(i5, 8);
    d := Copy(s, 1, 2).ToInteger;
    m := Copy(s, 3, 2).ToInteger;
    a := Copy(s, 5, 4).ToInteger;
    fdataVencimento := EncodeDate(a, m, d);
  end;

  // GPS
  i4 := 0;
  aJSon
    .Value('textoDescricaoPagamento', ftextoDescricaoPagamento)
    .Value('nomeConvenente', fnomeConvenente)
    .Value('codigoReceitaTributoGuiaPrevidenciaSocial', fcodigoReceitaTributoGuiaPrevidenciaSocial)
    .Value('codigoTipoContribuinteGuiaPrevidenciaSocial', i4)
    .Value('numeroIdentificacaoContribuinteGuiaPrevidenciaSocial', fnumeroIdentificacaoContribuinteGuiaPrevidenciaSocial)
    .Value('codigoIdentificadorTributoGuiaPrevidenciaSocial', fcodigoIdentificadorTributoGuiaPrevidenciaSocial)
    .Value('mesAnoCompetenciaGuiaPrevidenciaSocial', fmesAnoCompetenciaGuiaPrevidenciaSocial)
    .Value('valorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial', fvalorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial)
    .Value('valorOutroEntradaGuiaPrevidenciaSocial', fvalorOutroEntradaGuiaPrevidenciaSocial)
    .Value('valorAtualizacaoMonetarioGuiaPrevidenciaSocial', fvalorAtualizacaoMonetarioGuiaPrevidenciaSocial);
  if NaoEstaZerado(i4) then
    fcodigoTipoContribuinteGuiaPrevidenciaSocial := IntegerToTipoContribuinte(i4);
  
  if Assigned(ferros) then
    ferros.ReadFromJSon(AJSon);
  if Assigned(ferrors) then
    ferrors.ReadFromJSon(AJSon);
  if Assigned(ferrorCodes) then
    ferrorCodes.ReadFromJSon(AJSon);
end;

destructor TACBrLancamentoClass.Destroy;
begin
  if Assigned(ferros) then
    ferros.Free;
  if Assigned(ferrors) then
    ferrors.Free;
  if Assigned(ferrorCodes) then
    ferrorCodes.Free;
  inherited Destroy;
end;

procedure TACBrLancamentoClass.Clear;
begin
  fnumeroDocumentoDebito := 0;
  fnumeroCodigoBarras := EmptyStr;
  fcodigoBarras := EmptyStr;
  fdataPagamento := 0;
  fvalorPagamento := 0;
  fdescricaoPagamento := EmptyStr;
  fcodigoSeuDocumento := EmptyStr;
  fcodigoNossoDocumento := EmptyStr;
  fvalorNominal := 0;
  fvalorDesconto := 0;
  fvalorMoraMulta := 0;
  fcodigoTipoPagador := ptpNenhum;
  fdocumentoPagador := '0';
  fcodigoTipoBeneficiario := ptpNenhum;
  fdocumentoBeneficiario := '0';
  fcodigoTipoAvalista := ptpNenhum;
  fdocumentoAvalista := '0'; 
  ftextoPagamento := EmptyStr;
  fdataVencimento := 0;
  fnumeroReferencia := EmptyStr;
  fidPagamento := 0;
  fnomeConvenente := EmptyStr;
  fnomeRecebedor := EmptyStr;
  findicadorMovimentoAceito := EmptyStr;
  fmesAnoCompetencia := 0;
  fidContribuinte := 0;
  fvalorPrincipal := 0;
  fvalorOutraDeducao := 0;
  fvalorMulta := 0;
  fvalorJuroEncargo := 0;
  fvalorOutroAcrescimo := 0;
  fvalorOutrosAcrescimos := 0;
  ftextoDescricaoPagamento := EmptyStr;
  fcodigoReceitaTributoGuiaPrevidenciaSocial := 0;
  fcodigoTipoContribuinteGuiaPrevidenciaSocial := tctNenhum;
  fnumeroIdentificacaoContribuinteGuiaPrevidenciaSocial := 0;
  fcodigoIdentificadorTributoGuiaPrevidenciaSocial := EmptyStr;
  fmesAnoCompetenciaGuiaPrevidenciaSocial := 0;
  fvalorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial := 0;
  fvalorOutroEntradaGuiaPrevidenciaSocial := 0;
  fvalorAtualizacaoMonetarioGuiaPrevidenciaSocial := 0;

  if Assigned(ferros) then
    ferros.Clear;
  if Assigned(ferrors) then
    ferrors.Clear;
  if Assigned(ferrorCodes) then
    ferrorCodes.Clear;
end;

function TACBrLancamentoClass.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fnumeroDocumentoDebito) and
    EstaVazio(fnumeroCodigoBarras) and
    EstaVazio(fcodigoBarras) and
    EstaZerado(fdataPagamento) and
    EstaZerado(fvalorPagamento) and
    EstaVazio(fdescricaoPagamento) and
    EstaVazio(fcodigoSeuDocumento) and
    EstaVazio(fcodigoNossoDocumento) and
    EstaZerado(fvalorNominal) and
    EstaZerado(fvalorDesconto) and
    EstaZerado(fvalorMoraMulta) and
    (fcodigoTipoPagador = ptpNenhum) and
    EstaVazio(fdocumentoPagador) and
    (fcodigoTipoBeneficiario = ptpNenhum) and
    EstaVazio(fdocumentoBeneficiario) and
    (fcodigoTipoAvalista = ptpNenhum) and
    EstaVazio(fdocumentoAvalista) and
    EstaVazio(ftextoPagamento) and
    EstaZerado(fdataVencimento) and
    EstaVazio(fnumeroReferencia) and
    EstaZerado(fmesAnoCompetencia) and
    EstaZerado(fidContribuinte) and
    EstaZerado(fvalorPrincipal) and
    EstaZerado(fvalorOutraDeducao) and
    EstaZerado(fvalorMulta) and
    EstaZerado(fvalorJuroEncargo) and
    EstaZerado(fvalorOutroAcrescimo) and
    EstaZerado(fvalorOutrosAcrescimos) and
    EstaVazio(ftextoDescricaoPagamento) and
    EstaZerado(fidPagamento) and
    EstaVazio(fnomeConvenente) and
    EstaVazio(fnomeRecebedor) and
    EstaVazio(findicadorMovimentoAceito) and
    EstaZerado(fcodigoReceitaTributoGuiaPrevidenciaSocial) and
    EstaZerado(Ord(fcodigoTipoContribuinteGuiaPrevidenciaSocial)) and
    EstaZerado(fnumeroIdentificacaoContribuinteGuiaPrevidenciaSocial) and
    EstaVazio(fcodigoIdentificadorTributoGuiaPrevidenciaSocial) and
    EstaZerado(fmesAnoCompetenciaGuiaPrevidenciaSocial) and
    EstaZerado(fvalorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial) and
    EstaZerado(fvalorOutroEntradaGuiaPrevidenciaSocial) and
    EstaZerado(fvalorAtualizacaoMonetarioGuiaPrevidenciaSocial);

  if Assigned(ferros) then
    Result := Result and ferros.IsEmpty;
  if Assigned(ferrors) then
    Result := Result and ferrors.IsEmpty;
  if Assigned(ferrorCodes) then
    Result := Result and ferrorCodes.IsEmpty;
end;

procedure TACBrLancamentoClass.Assign(ASource: TACBrLancamentoClass);
begin
  fnumeroDocumentoDebito := ASource.numeroDocumentoDebito;
  fnumeroCodigoBarras := ASource.numeroCodigoBarras;
  fCodigoBarras := ASource.CodigoBarras;
  fdataPagamento := ASource.dataPagamento;
  fvalorPagamento := ASource.valorPagamento;
  fdescricaoPagamento := ASource.descricaoPagamento;
  fcodigoSeuDocumento := ASource.codigoSeuDocumento;
  fcodigoNossoDocumento := ASource.codigoNossoDocumento;
  fvalorNominal := ASource.valorNominal;
  fvalorDesconto := ASource.valorDesconto;
  fvalorMoraMulta := ASource.valorMoraMulta;
  fcodigoTipoPagador := ASource.codigoTipoPagador;
  fdocumentoPagador := ASource.documentoPagador;
  fcodigoTipoBeneficiario := ASource.codigoTipoBeneficiario;
  fdocumentoBeneficiario := ASource.documentoBeneficiario;
  fcodigoTipoAvalista := ASource.codigoTipoAvalista;
  fdocumentoAvalista := ASource.documentoAvalista;
  fnomeConvenente := ASource.nomeConvenente;
  ftextoPagamento := ASource.textoPagamento;
  fdataVencimento := ASource.dataVencimento;
  fnumeroReferencia := ASource.numeroReferencia;
  fmesAnoCompetencia := ASource.mesAnoCompetencia;
  fidContribuinte := ASource.idContribuinte;
  fvalorPrincipal := ASource.valorPrincipal;
  fvalorOutraDeducao := ASource.valorOutraDeducao;
  fvalorMulta := ASource.valorMulta;
  fvalorJuroEncargo := ASource.valorJuroEncargo;
  fvalorOutroAcrescimo := ASource.valorOutroAcrescimo;
  fvalorOutrosAcrescimos := ASource.valorOutrosAcrescimos;
  fidPagamento := ASource.idPagamento;
  fnomeRecebedor := ASource.nomeRecebedor;
  findicadorMovimentoAceito := ASource.indicadorMovimentoAceito;
  ftextoDescricaoPagamento := ASource.textoDescricaoPagamento;
  fcodigoReceitaTributoGuiaPrevidenciaSocial := ASource.codigoReceitaTributoGuiaPrevidenciaSocial;
  fcodigoTipoContribuinteGuiaPrevidenciaSocial := ASource.codigoTipoContribuinteGuiaPrevidenciaSocial;
  fnumeroIdentificacaoContribuinteGuiaPrevidenciaSocial := ASource.numeroIdentificacaoContribuinteGuiaPrevidenciaSocial;
  fcodigoIdentificadorTributoGuiaPrevidenciaSocial := ASource.codigoIdentificadorTributoGuiaPrevidenciaSocial;
  fmesAnoCompetenciaGuiaPrevidenciaSocial := ASource.mesAnoCompetenciaGuiaPrevidenciaSocial;
  fvalorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial := ASource.valorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial;
  fvalorOutroEntradaGuiaPrevidenciaSocial := ASource.valorOutroEntradaGuiaPrevidenciaSocial;
  fvalorAtualizacaoMonetarioGuiaPrevidenciaSocial := ASource.valorAtualizacaoMonetarioGuiaPrevidenciaSocial;

  if (not ASource.erros.IsEmpty) then
    erros.Assign(ASource.erros);
  if (not ASource.errors.IsEmpty) then
    errors.Assign(ASource.errors);
  if (not ASource.errorCodes.IsEmpty) then
    errorCodes.Assign(ASource.errorCodes);
end;

end.
