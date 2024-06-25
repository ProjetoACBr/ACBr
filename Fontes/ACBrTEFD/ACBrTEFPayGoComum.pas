{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrTEFPayGoComum;

interface

uses
  Classes, SysUtils,
  ACBrTEFComum;

const
  PWRET_OK = 0;      // Opera��o bem sucedida

  //==========================================================================================
  //  Tabela de C�digos de retorno das transa��es
  //==========================================================================================
  PWOPER_NULL        = 0;   // Testa comunica��o com a infraestrutura do Pay&Go Web
  PWOPER_INSTALL     = 1;   // Registra o Ponto de Captura perante a infraestrutura do Pay&Go Web, para que seja autorizado a realizar transa��es
  PWOPER_PARAMUPD    = 2;   // Obt�m da infraestrutura do Pay&Go Web os par�metros de opera��o atualizados do Ponto de Captura.
  PWOPER_REPRINT     = 16;  // Obt�m o �ltimo comprovante gerado por uma transa��o
  PWOPER_RPTTRUNC    = 17;  // Obt�m um relat�rio sint�tico das transa��es realizadas desde a �ltima obten��o deste relat�rio
  PWOPER_RPTDETAIL   = 18;  // Relat�rio detalhado das transa��es realizadas na data informada, ou data atual.
  PWOPER_REPRNTNTRANSACTION = 19; // Realiza uma reimpress�o de qualquer transa��o
  PWOPER_COMMTEST    = 20;  // Realiza um teste de comunica��o com a adquirente.
  PWOPER_RPTSUMMARY  = 21;  // Realiza um Relat�rio resumido das transa��es realizadas na data informada, ou data atual
  PWOPER_TRANSACINQ  = 22;  // Realiza uma consulta de uma transa��o.
  PWOPER_ROUTINGINQ  = 23;  // Realiza uma consulta de roteamento.
  PWOPER_ADMIN       = 32;  // Acessa qualquer transa��o que n�o seja disponibilizada pelo comando PWOPER_SALE. Um menu � apresentado para o operador selecionar a transa��o desejada.
  PWOPER_SALE        = 33;  // (Venda) Realiza o pagamento de mercadorias e/ou servi�os vendidos pelo Estabelecimento ao Cliente (tipicamente, com cart�o de cr�dito/d�bito), transferindo fundos entre as respectivas contas.
  PWOPER_SALEVOID    = 34;  // (Cancelamento de venda) Cancela uma transa��o PWOPER_SALE, realizando a transfer�ncia de fundos inversa
  PWOPER_PREPAID     = 35;  // Realiza a aquisi��o de cr�ditos pr�-pagos (por exemplo, recarga de celular).
  PWOPER_CHECKINQ    = 36;  // Consulta a validade de um cheque papel
  PWOPER_RETBALINQ   = 37;  // Consulta o saldo/limite do Estabelecimento (tipicamente, limite de cr�dito para venda de cr�ditos pr�-pagos).
  PWOPER_CRDBALINQ   = 38;  // Consulta o saldo do cart�o do Cliente
  PWOPER_INITIALIZ   = 39;  // (Inicializa��o/abertura) Inicializa a opera��o junto ao Provedor e/ou obt�m/atualiza os par�metros de opera��o mantidos por este
  PWOPER_SETTLEMNT   = 40;  // (Fechamento/finaliza��o) Finaliza a opera��o junto ao Provedor
  PWOPER_PREAUTH     = 41;  // (Pr�-autoriza��o) Reserva o valor correspondente a uma venda no limite do cart�o de cr�dito de um Cliente, por�m sem efetivar a transfer�ncia de fundos.
  PWOPER_PREAUTVOID  = 42;  // (Cancelamento de pr�-autoriza��o) Cancela uma transa��o PWOPER_PREAUTH, liberando o valor reservado no limite do cart�o de cr�dito
  PWOPER_CASHWDRWL   = 43;  // (Saque) Registra a retirada de um valor em esp�cie pelo Cliente no Estabelecimento, para transfer�ncia de fundos nas respectivas contas
  PWOPER_LOCALMAINT  = 44;  // (Baixa t�cnica) Registra uma interven��o t�cnica no estabelecimento perante o Provedor.
  PWOPER_FINANCINQ   = 45;  // Consulta as taxas de financiamento referentes a uma poss�vel venda parcelada, sem efetivar a transfer�ncia de fundos ou impactar o limite de cr�dito do Cliente
  PWOPER_ADDRVERIF   = 46;  // Verifica junto ao Provedor o endere�o do Cliente
  PWOPER_SALEPRE     = 47;  // Efetiva uma pr�-autoriza��o (PWOPER_PREAUTH), previamente realizada, realizando a transfer�ncia de fundos entre as contas do Estabelecimento e do Cliente
  PWOPER_LOYCREDIT   = 48;  // Registra o ac�mulo de pontos pelo Cliente, a partir de um programa de fidelidade.
  PWOPER_LOYCREDVOID = 49;  // Cancela uma transa��o PWOPER_LOYCREDIT
  PWOPER_LOYDEBIT    = 50;  // Registra o resgate de pontos/pr�mio pelo Cliente, a partir de um programa de fidelidade.
  PWOPER_LOYDEBVOID  = 51;  // Cancela uma transa��o PWOPER_LOYDEBIT
  PWOPER_BILLPAYMENT = 52;  // Realiza um pagamento de conta/boleto/fatura.
  PWOPER_DOCPAYMENTQ = 53;  // Realiza uma consulta de documento de cobran�a.
  PWOPER_LOGON       = 54;  // Realiza uma opera��o de logon no servidor.
  PWOPER_SRCHPREAUTH = 55;  // Realiza uma busca de pr�-autoriza��o.
  PWOPER_ADDPREAUTH  = 56;  // Realiza uma altera��o no valor de uma pr�-autoriza��o.
  PWOPER_VOID        = 57;  // Exibe um menu com os cancelamentos dispon�veis, caso s� exista um tipo, este � selecionado automaticamente
  PWOPER_STATISTICS  = 64;  // Realiza uma transa��o de estat�sticas.
  PWOPER_CARDPAYMENT = 65;  // Realiza um pagamento de cart�o de cr�dito.
  PWOPER_CARDPAYMENTVOID = 68;  // Cancela uma transa��o PWOPER_CARDPAYMENT.
  PWOPER_CASHWDRWLVOID = 69;  // Cancela uma transa��o PWOPER_CASHWDRWL.
  PWOPER_CARDUNLOCK  = 70;  // Realiza um desbloqueio de cart�o.
  PWOPER_UPDATEDCHIP = 72;  // Realiza uma atualiza��o no chip do cart�o.
  PWOPER_RPTPROMOTIONAL = 73;  // Realiza uma transa��o de relat�rio promocional.
  PWOPER_SALESUMMARY = 74;  // Imprime um resumo das transa��es de vendas.
  PWOPER_STATISTICSAUTHORIZER = 75;  // Realiza uma estat�stica espec�fica do autorizador.
  PWOPER_OTHERADMIN  = 76;   // Realiza uma transa��o administrativa especificada pelo autorizador.
  PWOPER_BILLPAYMENTVOID = 78;  // Cancela uma transa��o PWOPER_BILLPAYMENT.
  PWOPER_TSTKEY      = 240; // Teste de chaves de criptografia do PIN-pad
  PWOPER_EXPORTLOGS  = 241; // Envio de logs para o servidor.
  PWOPER_COMMONDATA  = 250; // Realiza uma opera��o para obter os dados b�sicos do PdC. O resultado dessa opera��o deve ser consultado por meio da chamada de PW_iGetResult para as informa��es: PWINFO_AUTADDRESS, PWINFO_APN, PWINFO_LIBVERSION, PWINFO_POSID, PWINFO_DESTTCPIP, PWINFO_LOCALIP, PWINFO_GATEWAY, PWINFO_SUBNETMASK, PWINFO_PPPPWD , PWINFO_SSID.
  PWOPER_SHOWPDC     = 251; // Exibe o ponto de captura configurado.
  PWOPER_VERSION     = 252; // (Vers�o) Permite consultar a vers�o da biblioteca atualmente em uso.
  PWOPER_CONFIG      = 253; // (Configura��o) Visualiza e altera os par�metros de opera��o locais da biblioteca
  PWOPER_MAINTENANCE = 254; // (Manuten��o) Apaga todas as configura��es do Ponto de Captura, devendo ser novamente realizada uma transa��o de Instala��o.


//==========================================================================================
//    C�digos de Confirma��o de Transa��o
//==========================================================================================
  PWCNF_CNF_AUTO     = 289;     // A transa��o foi confirmada pelo Ponto de Captura, sem interven��o do usu�rio.
  PWCNF_CNF_MANU_AUT = 12833;   // A transa��o foi confirmada manualmente na Automa��o.*/
  PWCNF_REV_MANU_AUT = 12849;   // A transa��o foi desfeita manualmente na Automa��o.*/
  PWCNF_REV_PRN_AUT  = 78129;   // A transa��o foi desfeita pela Automa��o, devido a uma falha na impress�o do comprovante (n�o fiscal). A priori, n�o usar. Falhas na impress�o n�o devem gerar desfazimento, deve ser solicitada a reimpress�o da transa��o.*/
  PWCNF_REV_DISP_AUT = 143665;  // A transa��o foi desfeita pela Automa��o, devido a uma falha no mecanismo de libera��o da mercadoria.*/
  PWCNF_REV_COMM_AUT = 209201;  // A transa��o foi desfeita pela Automa��o, devido a uma falha de comunica��o/integra��o com o ponto de captura (Cliente Muxx).*/
  PWCNF_REV_ABORT    = 274737;  // A transa��o n�o foi finalizada, foi interrompida durante a captura de dados.*/
  PWCNF_REV_OTHER_AUT= 471345;  // A transa��o foi desfeita a pedido da Automa��o, por um outro motivo n�o previsto.*/
  PWCNF_REV_PWR_AUT  = 536881;  // A transa��o foi desfeita automaticamente pela Automa��o, devido a uma queda de energia (rein�cio abrupto do sistema).*/
  PWCNF_REV_FISC_AUT = 602417;  // A transa��o foi desfeita automaticamente pela Automa��o, devido a uma falha de registro no sistema fiscal (impressora S@T, on-line, etc.).*/

  //==========================================================================================
  //   Tipos de dados que podem ser informados pela Automa��o
  //==========================================================================================
  PWINFO_RET            = 0;      // C�digo do �ltimo Retorno (PWRET)  (uso interno do ACBr)
  PWINFO_OPERATION      = 2;      // Tipo de transa��o (PWOPER_xxx). Consultar os valores poss�veis na descri��o da fun��o PW_iNewTransac
  PWINFO_PPPPWD         = 3;      // Usu�rio para autentica��o PPP.
  PWINFO_LOCALIP        = 9;      // Endere�o local no formato �VVV:VVV:VVV:VVV�, para conex�o com IP fixo.
  PWINFO_GATEWAY        = 10;     // Endere�o de gateway, no formato �VVV.VVV.VVV.VVV�.
  PWINFO_SUBNETMASK     = 11;     // M�scara de subrede, no formato �VVV.VVV.VVV.VVV�.
  PWINFO_SSID           = 12;     // SSID da rede Wi-Fi cadastrada
  PWINFO_POSID          = 17;     // Identificador do Ponto de Captura.
  PWINFO_AUTNAME        = 21;     // Nome do aplicativo de Automa��o
  PWINFO_AUTVER         = 22;     // Vers�o do aplicativo de Automa��o
  PWINFO_AUTDEV         = 23;     // Empresa desenvolvedora do aplicativo de Automa��o.
  PWINFO_DESTTCPIP      = 27;     // Endere�o TCP/IP para comunica��o com a infraestrutura Pay&Go Web, no formato <endere�o IP>:<porta TCP> ou <nome do servidor>:<porta TCP>
  PWINFO_MERCHCNPJCPF   = 28;     // CNPJ (ou CPF) do Estabelecimento, sem formata��o. No caso de estarem sendo utilizadas afilia��es de mais de um estabelecimento, este dado pode ser adicionado pela automa��o para selecionar previamente o estabelecimento a ser utilizado para determinada transa��o. Caso este dado n�o seja informado, ser� solicitada a exibi��o de um menu para a escolha dentre os v�rios estabelecimentos dispon�veis.
  PWINFO_AUTCAP         = 36;     // Capacidades da Automa��o (soma dos valores abaixo): 1: funcionalidade de troco/saque; 2: funcionalidade de desconto; 4: valor fixo, sempre incluir; 8: impress�o das vias diferenciadas do comprovante para Cliente/Estabelecimento; 16: impress�o do cupom reduzido. 32: utiliza��o de saldo total do voucher para abatimento do valor da compra.
  PWINFO_TOTAMNT        = 37;     // Valor total da opera��o, considerando PWINFO_CURREXP (em centavos se igual a 2), incluindo desconto, saque, gorjeta, taxa de embarque, etc.
  PWINFO_CURRENCY       = 38;     // Moeda (padr�o ISO4217, 986 para o Real)
  PWINFO_CURREXP        = 39;     // Expoente da moeda (2 para centavos)
  PWINFO_FISCALREF      = 40;     // Identificador do documento fiscal
  PWINFO_CARDTYPE       = 41;     // Tipo de cart�o utilizado (PW_iGetResult), ou tipos de cart�o aceitos (soma dos valores abaixo, PW_iAddParam): 1: cr�dito 2: d�bito 4: voucher/PAT 8: private label 16: frota 128: outros
  PWINFO_PRODUCTNAME    = 42;     // Nome/tipo do produto utilizado, na nomenclatura do Provedor.
  PWINFO_DATETIME       = 49;     // Data e hora local da transa��o, no formato �AAAAMMDDhhmmss�
  PWINFO_REQNUM         = 50;     // Refer�ncia local da transa��o
  PWINFO_AUTHSYST       = 53;     // Nome do Provedor: �ELAVON�; �FILLIP�; �LIBERCARD�; �RV�; etc
  PWINFO_VIRTMERCH      = 54;     // Identificador do Estabelecimento
  PWINFO_AUTMERCHID     = 56;     // Identificador do estabelecimento para o Provedor (c�digo de afilia��o).
  PWINFO_PHONEFULLNO    = 58;     // N�mero do telefone, com o DDD (10 ou 11 d�gitos).
  PWINFO_FINTYPE        = 59;     // Modalidade de financiamento da transa��o: 1: � vista 2: parcelado pelo emissor 4: parcelado pelo estabelecimento 8: pr�-datado 16: cr�dito emissor
  PWINFO_INSTALLMENTS   = 60;     // Quantidade de parcelas
  PWINFO_INSTALLMDATE   = 61;     // Data de vencimento do pr�-datado, ou da primeira parcela. Formato �DDMMAA
  PWINFO_PRODUCTID      = 62;     // Identifica��o do produto utilizado, de acordo com a nomenclatura do Provedor.
  PWINFO_RESULTMSG      = 66;     // Mensagem descrevendo o resultado final da transa��o, seja esta bem ou mal sucedida (conforme �4.3.Interface com o usu�rio�, p�gina 8
  PWINFO_CNFREQ         = 67;     // Necessidade de confirma��o: 0: n�o requer confirma��o; 1: requer confirma��o.
  PWINFO_AUTLOCREF      = 68;     // Refer�ncia da transa��o para a infraestrutura Pay&Go Web
  PWINFO_AUTEXTREF      = 69;     // Refer�ncia da transa��o para o Provedor (NSU host).
  PWINFO_AUTHCODE       = 70;     // C�digo de autoriza��o
  PWINFO_AUTRESPCODE    = 71;     // C�digo de resposta da transa��o (campo ISO8583:39)
  PWINFO_AUTDATETIME    = 72;     // Data/hora da transa��o para o Provedor, formato �AAAAMMDDhhmmss�.
  PWINFO_DISCOUNTAMT    = 73;     // Valor do desconto concedido pelo Provedor, considerando PWINFO_CURREXP, j� deduzido em PWINFO_TOTAMNT
  PWINFO_CASHBACKAMT    = 74;     // Valor do saque/troco, considerando PWINFO_CURREXP, j� inclu�do em PWINFO_TOTAMNT
  PWINFO_CARDNAME       = 75;     // Nome do cart�o ou do emissor do cart�o
  PWINFO_ONOFF          = 76;     // Modalidade da transa��o: 1: online 2: off-line
  PWINFO_BOARDINGTAX    = 77;     // Valor da taxa de embarque, considerando PWINFO_CURREXP, j� inclu�do em PWINFO_TOTAMNT
  PWINFO_TIPAMOUNT      = 78;     // Valor da taxa de servi�o (gorjeta), considerando PWINFO_CURREXP, j� inclu�do em PWINFO_TOTAMNT
  PWINFO_INSTALLM1AMT   = 79;     // Valor da entrada para um pagamento parcelado, considerando PWINFO_CURREXP, j� inclu�do em PWINFO_TOTAMNT
  PWINFO_INSTALLMAMNT   = 80;     // Valor da parcela, considerando PWINFO_CURREXP, j� inclu�do em PWINFO_TOTAMNT
  PWINFO_RCPTFULL       = 82;     // Comprovante para impress�o � Via completa. At� 40 colunas, quebras de linha identificadas pelo caractere 0Dh
  PWINFO_RCPTMERCH      = 83;     // Comprovante para impress�o � Via diferenciada para o Estabelecimento. At� 40 colunas, quebras de linha identificadas pelo caractere 0Dh.
  PWINFO_RCPTCHOLDER    = 84;     // Comprovante para impress�o � Via diferenciada para o Cliente. At� 40 colunas, quebras de linha identificadas pelo caractere 0Dh.
  PWINFO_RCPTCHSHORT    = 85;     // Comprovante para impress�o � Cupom reduzido (para o Cliente). At� 40 colunas, quebras de linha identificadas pelo caractere 0Dh
  PWINFO_TRNORIGDATE    = 87;     // Data da transa��o original, no caso de um cancelamento ou uma confirma��o de pr�-autoriza��o (formato �DDMMAA�).
  PWINFO_TRNORIGNSU     = 88;     // NSU da transa��o original, no caso de um cancelamento ou uma confirma��o de pr�-autoriza��
  PWINFO_SALDOVOUCHER   = 89;     // Saldo do cart�o voucher recebido do autorizador
  PWINFO_TRNORIGAMNT    = 96;     // Valor da transa��o original, no caso de um cancelamento ou uma confirma��o de pr�-autoriza��o.
  PWINFO_TRNORIGAUTH    = 98;     // C�digo de autoriza��o da transa��o original, no caso de um cancelamento ou uma confirma��o de pr�-autoriza��o
  PWINFO_LANGUAGE       = 108;    // Idioma a ser utilizado para a interface com o cliente: 0: Portugu�s 1: Ingl�s 2: Espanhol
  PWINFO_PROCESSMSG     = 111;    // Mensagem a ser exibida para o cliente durante o processamento da transa��o
  PWINFO_TRNORIGREQNUM  = 114;    // N�mero da solicita��o da transa��o original, no caso de um cancelamento ou uma confirma��o de pr�-autoriza��o
  PWINFO_TRNORIGTIME    = 115;    // Hora da transa��o original, no caso de um cancelamento ou uma confirma��o de pr�-autoriza��o (formato �HHMMSS�).
  PWINFO_CNCDSPMSG      = 116;    // Mensagem a ser exibida para o operador no terminal no caso da transa��o ser abortada (cancelamento ou timeout).
  PWINFO_CNCPPMSG       = 117;    // Mensagem a ser exibida para o portador no PIN-pad no caso da transa��o ser abortada (cancelamento ou timeout).
  PWINFO_TRNORIGLOCREF  = 120;    // Refer�ncia local da transa��o original, no caso de um cancelamento.
  PWINFO_AUTHSYSTEXTENDED=135;    // Nome do provedor, independente do emissor e/ou subadquirencia
  PWINFO_CARDENTMODE    = 192;    // Modo(s) de entrada do cart�o: 1: digitado 2: tarja magn�tica 4: chip com contato 16: fallback de chip para tarja 32: chip sem contato simulando tarja (cliente informa tipo efetivamente utilizado) 64: chip sem contato EMV (cliente informa tipo efetivamente utilizado) 256: fallback de tarja para digitado
  PWINFO_CARDFULLPAN    = 193;    // N�mero do cart�o completo, para transa��o digitada. Este dado n�o pode ser recuperado pela fun��o PW_iGetResult
  PWINFO_CARDEXPDATE    = 194;    // Data de vencimento do cart�o (formato �MMAA�).
  PWINFO_CARDNAMESTD    = 196;    // Descri��o do produto bandeira padr�o relacionado ao BIN.
  PWINFO_PRODNAMEDESC   = 197;    // Descri��o do nome do produto ou bandeira.
  PWINFO_CARDPARCPAN    = 200;    // N�mero do cart�o, truncado ou mascarado
  PWINFO_CHOLDVERIF     = 207;    // Verifica��o do portador, soma dos seguintes valores: �1�: Assinatura do portador em papel. �2�: Senha verificada off-line. �4�: Senha off-line bloqueada no decorrer desta transa��o. �8�: Senha verificada online
  PWINFO_EMVRESPCODE    = 214;    // Identificador do resultado final do processamento de cart�o com chip: 1: Transa��o aprovada. 2: Transa��o negada pelo cart�o. 3.Transa��o negada pelo Host. Caso n�o seja uma transa��o com chip, o valor n�o ir� existir.
  PWINFO_AID            = 216;    // Aplica��o do cart�o utilizada durante a transa��o
  PWINFO_BARCODENTMODE  = 233;    // Modo(s) de entrada do c�digo de barras: 1:  digitado; 2:  lido atrav�s de dispositivo eletr�nico.
  PWINFO_BARCODE        = 234;    // C�digo de barras completo, lido ou digitado
  PWINFO_MERCHADDDATA1  = 240;    // Dados adicionais relevantes para a Automa��o (#1)
  PWINFO_MERCHADDDATA2  = 241;    // Dados adicionais relevantes para a Automa��o (#2)
  PWINFO_MERCHADDDATA3  = 242;    // Dados adicionais relevantes para a Automa��o (#3)
  PWINFO_MERCHADDDATA4  = 243;    // Dados adicionais relevantes para a Automa��o (#4)
  PWINFO_RCPTPRN        = 244;    // Indica quais vias de comprovante devem ser impressas: 0: n�o h� comprovante 1: imprimir somente a via do Cliente 2: imprimir somente a via do Estabelecimento 3: imprimir ambas as vias do Cliente e do Estabelecimento
  PWINFO_AUTHMNGTUSER   = 245;    // Identificador do usu�rio autenticado com a senha do lojista
  PWINFO_AUTHTECHUSER   = 246;    // Identificador do usu�rio autenticado com a senha t�cnica.
  PWINFO_MERCHNAMERCPT  = 250;    // Nome que identifica o estabelecimento nos comprovantes.
  PWINFO_PRODESTABRCPT  = 251;    // Descri��o do produto/cart�o utilizado na transa��o, para o estabelecimento.
  PWINFO_PRODCLIRCPT    = 252;    // Descri��o do produto/cart�o utilizado na transa��o, para o cliente.
  PWINFO_EMVCRYPTTYPE   = 253;    // Tipo de criptograma gerado no 1� Generate AC do processo   EMV:   �ARQC� para transa��es submetidas � autoriza��o do   emissor.   �TC� para transa��es efetuadas sem autoriza��o do emissor.
  PWINFO_TRNORIGAUTHCODE= 254;    // C�digo de autoriza��o da transa��o original, no caso de um cancelamento.
  PWINFO_PAYMNTTYPE     = 7969;   // Modalidade de pagamento:   1: cart�o   2: dinheiro   4: cheque   8: carteira virtual
  PWINFO_GRAPHICRCPHEADER= 7990;  // At� 100 Cabe�alho do comprovante gr�fico recebido do servidor.
  PWINFO_GRAPHICRCPFOOTER= 7991;  // Rodap� do comprovante gr�fico recebido do servidor.
  PWINFO_CHOLDERNAME    = 7992;   // Nome do portador do cart�o utilizado, o tamanho segue o mesmo padr�o da tag 5F20 EMV.
  PWINFO_MERCHNAMEPDC   = 7993;   // Nome do estabelecimento em que o ponto de captura est� cadastrado. (at� 100)
  PWINFO_TRANSACDESCRIPT= 8000;   // Descritivo da transa��o realizada, por exemplo, CREDITO A VISTA ou VENDA PARCELADA EM DUAS VEZES.
  PWINFO_ARQC           = 8001;   // ARQC
  PWINFO_DEFAULTCARDPARCPAN  = 8002; // N�mero do cart�o mascarado no formato BIN + *** + 4 �ltimos d�gitos. Ex: 543211******987
  PWINFO_SOFTDESCRIPTOR      = 8003; // Texto que ser� de identifica��o na fatura do portador do cart�o
  PWINFO_RCPTADDINFOESTABCLI = 8004; // At� 500 - Mensagem texto destinada a ambos: ao cliente e ao estabelecimento.
  PWINFO_RCPTADDINFOCLI      = 8005; // At� 500 - Mensagem texto destinada ao cliente.
  PWINFO_RCPTADDINFOESTAB    = 8006; // At� 500 - Mensagem texto destinada ao estabelecimento.
  PWINFO_SPLITPAYMENT   = 8025;   // O campo PWINFO_SPLITPAYMENT dever� possuir as seguintes informa��es separadas por v�rgula �,�: Afilia��o: Identificador do lojista do ponto de vista do adquirente. Valor: Valor parcial a ser enviado para a afilia��o do split. OBS: A soma de todos os valores referente ao split de pagamento dever� ser igual a PWINFO_TOTAMNT Exemplo: 8DA10E01A6A6213, 1200 Para cada conjunto de informa��es de split de pagamento, conforme o exemplo acima, dever� ser feito o PW_iAddParam informando a tag PWINFO_SPLITPAYMENT e as informa��es atualizadas.
  PWINFO_AUTHPOSQRCODE  = 8055;   // Conte�do do QR Code identificando o checkout para o autorizador.
  PWINFO_WALLETUSERIDTYPE=8065;   // Forma de identifica��o do portador da carteira virtual: 1: QRCode do checkout (lido pelo celular do portador) 2: CPF 128: outros
  PWINFO_RCPTECVID      = 8081;   // At� 10 - Identificador do estabelecimento virtual que est� processando a transa��o. O campo � utilizado na montagem do comprovante pr�prio.
  PWINFO_USINGPINPAD    = 32513;  // Indica se o ponto de captura faz ou n�o o uso de PIN-pad: 0: N�o utiliza PIN-pad; 1: Utiliza PIN-pad.
  PWINFO_PPCOMMPORT     = 32514;  // N�mero da porta serial � qual o PIN-pad est� conectado. O valor 0 (zero) indica uma busca autom�tica desta porta
  PWINFO_IDLEPROCTIME   = 32516;  // Pr�xima data e hor�rio em que a fun��o PW_iIdleProc deve ser chamada pela Automa��o. Formato �AAMMDDHHMMSS�
  PWINFO_PNDAUTHSYST    = 32517;  // Nome do provedor para o qual existe uma transa��o pendente.
  PWINFO_PNDVIRTMERCH   = 32518;  // Identificador do Estabelecimento para o qual existe uma transa��o pendente
  PWINFO_PNDREQNUM      = 32519;  // Refer�ncia local da transa��o que est� pendente.
  PWINFO_PNDAUTLOCREF   = 32520;  // Refer�ncia para a infraestrutura Pay&Go Web da transa��o que est� pendente.
  PWINFO_PNDAUTEXTREF   = 32521;  // Refer�ncia para o Provedor da transa��o que est� pendente
  PWINFO_LOCALINFO1     = 32522;  // Texto exibido para um item de menu selecionado pelo usu�rio
  PWINFO_SERVERPND      = 32523;  // Indica se o ponto de captura possui alguma pend�ncia a ser resolvida com o Pay&Go Web: 0: n�o possui pend�ncia; 1: possui pend�ncia
  PWINFO_PPINFO         = 32533;  // Informa��es do PIN-pad conectado, seguindo o padr�o posi��o/informa��o abaixo: 001-020 / Nome do fabricante do PIN-pad. 021-039 / Modelo/vers�o do hardware. 040 / Se o PIN-pad suporta cart�o com chip sem contato, este campo deve conter a letra �C�, caso contr�rio um espa�o em branco. 041-060 / Vers�o do software b�sico/firmware. 061-064 / Vers�o da especifica��o, no formato �V.VV�. 065-080 / Vers�o da aplica��o b�sica, no formato �VVV.VV AAMMDD� (com 3 espa�os � direita). 081-100 / N�mero de s�rie do PIN-pad (com espa�os � direita)
  PWINFO_RESULTID       = 32534;  // Identificador do resultado da opera��o do ponto de vista do Servidor.
  PWINFO_DSPCHECKOUT1   = 32535;  // Mensagem a ser exibida no cliente durante as transi��es de determinadas capturas. A automa��o dever� informar a capacidade desse tratamento no PWINFO_AUTCAP
  PWINFO_DSPCHECKOUT2   = 32536;  // Mensagem a ser exibida no cliente durante as transi��es de determinadas capturas. A automa��o dever� informar a capacidade desse tratamento no PWINFO_AUTCAP
  PWINFO_DSPCHECKOUT3   = 32537;  // Mensagem a ser exibida no cliente durante as transi��es de determinadas capturas. A automa��o dever� informar a capacidade desse tratamento no PWINFO_AUTCAP
  PWINFO_DSPCHECKOUT4   = 32538;  // Mensagem a ser exibida no cliente durante as transi��es de determinadas capturas. A automa��o dever� informar a capacidade desse tratamento no PWINFO_AUTCAP
  PWINFO_DSPCHECKOUT5   = 32539;  // Mensagem a ser exibida no cliente durante as transi��es de determinadas capturas. A automa��o dever� informar a capacidade desse tratamento no PWINFO_AUTCAP
  PWINFO_CTLSCAPTURE    = 32540;  // Deve ser adicionado para sinalizar que a automa��o deseja fazer uma captura de cart�o sem contato. Se o autorizador permitir, a captura ser� executada. N�o dever� ser adicionada caso j� tenha sido capturado cart�o digitado, trilha magn�tica ou chip.
  PWINFO_CHOLDERGRARCP  = 32541;  // Deve ser adicionado para sinalizar que a vila do cliente foi impressa utilizando o comprovante gr�fico.
  PWINFO_MERCHGRARCP    = 32542;  // Deve ser adicionado para sinalizar que a via do estabelecimento foi impressa utilizando o comprovante gr�fico.
  PWINFO_AUTADDRESS     = 32543;  // Endere�o TCP/IP para comunica��o com automa��o comercial quando terminal POS operando integrado � automa��o no formato <endere�o IP >:<porta TCP> ou <nome do servidor>:<porta TCP>
  PWINFO_APN            = 32544;  // APN caso terminal esteja configurado para operar utilizando GPRS.
  PWINFO_LIBVERSION     = 32545;  // Vers�o da biblioteca no formato �VVV.VVV.VVV.VVV�.
  PWINFO_TSTKEYTYPE     = 32560;  // Tipo de teste de chaves que ser� executado pela biblioteca, essa informa��o s� ser� considerada caso a op��o for PWOPER_TSTKEY: 1: PIN � DUKPT 3DES; 2: PIN � MK 3DES; 4: PIN � MK DES; 8: DADOS � DUKPT 3DES; 16: DADOS � MK 3DES; 32: DADOS � MK DES; Aten��o: Caso a criptografia n�o seja suportada pelo PIN-pad, a mesma n�o ser� executada. Para a realiza��o do teste completo, os valores devem ser enviados somados.
  PWINFO_TKPINDUKPT3DES   = 32562;  // Sequ�ncia de valores que indicam a situa��o das chaves de PIN DUKPT 3DES. O significado dos valores s�o: 1 � Chave ausente.; 2 � Chave presente.; 3 � Chave v�lida.; 4 � Chave inv�lida.; 5 � Chave n�o validada (Durante o teste o usu�rio pressionou �anula� no equipamento). Exemplo de dado retornado: �12221212111111122211111111111111111�, ou seja, a chave da posi��o 1 est� ausente, a chave da posi��o 2 est� presente, assim sucessivamente.
  PWINFO_TKPINMK3DES      = 32563;  // Sequ�ncia de valores que indicam a situa��o das chaves de PIN MK 3DES. O significado dos valores s�o: 1 � Chave ausente.; 2 � Chave presente.; 3 � Chave v�lida.; 4 � Chave inv�lida.; 5 � Chave n�o validada (Durante o teste o usu�rio pressionou �anula� no equipamento). Exemplo de dado retornado: �13331413111111133311111111111111111�, ou seja, a chave da posi��o 1 est� ausente, a chave da posi��o 2 est� v�lida, assim sucessivamente.
  PWINFO_TKPINMKDES       = 32564;  // Sequ�ncia de valores que indicam a situa��o das chaves de PIN MK DES. O significado dos valores s�o: 1 � Chave ausente.; 2 � Chave presente.; 3 � Chave v�lida.; 4 � Chave inv�lida.; 5 � Chave n�o validada (Durante o teste o usu�rio pressionou �anula� no equipamento). Exemplo de dado retornado: �13331413111111133311111111111111111�, ou seja, a chave da posi��o 1 est� ausente, a chave da posi��o 2 est� v�lida, assim sucessivamente.
  PWINFO_TKDADOSDUKPT3DES = 32565;  // Sequ�ncia de valores que indicam a situa��o das chaves de DADOS DUKPT 3DES. O significado dos valores s�o: 1 � Chave ausente.; 2 � Chave presente.; 3 � Chave v�lida.; 4 � Chave inv�lida.; 5 � Chave n�o validada (Durante o teste o usu�rio pressionou �anula� no equipamento). Exemplo de dado retornado: �12221212111111122211111111111111111�, ou seja, a chave da posi��o 1 est� ausente, a chave da posi��o 2 est� presente, assim sucessivamente.
  PWINFO_TKDADOSMK3DES    = 32566;  // Sequ�ncia de valores que indicam a situa��o das chaves de DADOS MK 3DES. O significado dos valores s�o: 1 � Chave ausente.; 2 � Chave presente.; 3 � Chave v�lida.; 4 � Chave inv�lida. 5 � Chave n�o validada (Durante o teste o usu�rio pressionou �anula� no equipamento). Exemplo de dado retornado: �13331413111111133311111111111111111�, ou seja, a chave da posi��o 1 est� ausente, a chave da posi��o 2 est� v�lida, assim sucessivamente.
  PWINFO_TKDADOSMKDES     = 32567;  // Sequ�ncia de valores que indicam a situa��o das chaves de DADOS MK DES. O significado dos valores s�o: 1 � Chave ausente.; 2 � Chave presente.; 3 � Chave v�lida.; 4 � Chave inv�lida.; 5 � Chave n�o validada (Durante o teste o usu�rio pressionou �anula� no equipamento). Exemplo de dado retornado: �13331413111111133311111111111111111�, ou seja, a chave da posi��o 1 est� ausente, a chave da posi��o 2 est� v�lida, assim sucessivamente.
  PWINFO_DSPTESTKEY       = 32568;  // Mensagem a ser exibida no cliente durante as transi��es de determinadas capturas. A automa��o dever� informar a capacidade desse tratamento no PWINFO_AUTCAP.
  PWINFO_GETKSNPIN        = 32569;  // Retorna o KSN de uma dada chave DUKPT3DES de PIN cujo resultado do teste tenha sido 1 (chave presente). Para indicar qual item deve ser consultado, primeiro deve-se adicionar o �ndice, por exemplo, �01�, chamando a fun��o PW_iAddParam. Em seguida, consultar o resultado por meio de PW_iGetResult. Nesse resultado, � retornado o KSN j� em caracteres imprim�veis.
  PWINFO_GETKSNDATA       = 32576;  // Retorna o KSN de uma dada chave DUKPT3DES de PIN cujo resultado do teste tenha sido 1 (chave presente). Para indicar qual item deve ser consultado, primeiro deve-se adicionar o �ndice, por exemplo, �01�, chamando a fun��o PW_iAddParam. Em seguida, consultar o resultado por meio de PW_iGetResult. Nesse resultado, � retornado o KSN j� em caracteres imprim�veis.
  PWINFO_PINDUKPT3DESNAME = 32577;  // Retorna o nome relacionado a um item do teste de chaves para uma chave DUKPT3DES de PIN. Para Para indicar qual item deve ser consultado, primeiro deve-se adicionar o �ndice, por exemplo, �01�, chamando a fun��o PW_iAddParam. Em seguida, consultar o resultado por meio de PW_iGetResult. Nesse resultado, � retornado o nome .
  PWINFO_PINMK3DESNAME    = 32578;  // Retorna o nome relacionado a um item do teste de chaves para uma chave MK3DES de PIN. Para Para indicar qual item deve ser consultado, primeiro deve-se adicionar o �ndice, por exemplo, �01�, chamando a fun��o PW_iAddParam. Em seguida, consultar o resultado por meio de PW_iGetResult. Nesse resultado, � retornado o nome.
  PWINFO_PINMKDESNAME     = 32579;  // Retorna o nome relacionado a um item do teste de chaves para uma chave MKDES de PIN. Para Para indicar qual item deve ser consultado, primeiro deve-se adicionar o �ndice, por exemplo, �01�, chamando a fun��o PW_iAddParam. Em seguida, consultar o resultado por meio de PW_iGetResult. Nesse resultado, � retornado o nome.
  PWINFO_DATADUKPT3DESNAME= 32580;  // Retorna o nome relacionado a um item do teste de chaves para uma chave DUKPT3DES de dados. Para Para indicar qual item deve ser consultado, primeiro deve-se adicionar o �ndice, por exemplo, �01�, chamando a fun��o PW_iAddParam. Em seguida, consultar o resultado por meio de PW_iGetResult. Nesse resultado, � retornado o nome.
  PWINFO_DATAMK3DESNAME   = 32581;  // Retorna o nome relacionado a um item do teste de chaves para uma chave MK3DES de dados. Para Para indicar qual item deve ser consultado, primeiro deve-se adicionar o �ndice, por exemplo, �01�, chamando a fun��o PW_iAddParam. Em seguida, consultar o resultado por meio de PW_iGetResult. Nesse resultado, � retornado o nome.
  PWINFO_DATAMKDESNAME    = 32582;  // Retorna o nome relacionado a um item do teste de chaves para uma chave MKDES. Para indicar qual item deve ser consultado, primeiro deve-se adicionar o �ndice, por exemplo, �01�, chamando a fun��o PW_iAddParam. Em seguida, consultar o resultado por meio de PW_iGetResult. Nesse resultado, � retornado o nome.
  PWINFO_SERNUM           = 32583;  // Retorna o n�mero serial do terminal, para plataformas em que isso fa�a sentido.
  PWINFO_MACADDR          = 32584;  // Endere�o MAC do terminal, no formato �XX:XX:XX:XX�
  PWINFO_IMEI             = 32585;  // IMEI do SIMCARD caso dispon�vel.
  PWINFO_IPADDRESS        = 32586;  // Endere�o IP do terminal.
  PWINFO_SSID_IDX         = 32587;  // Retorna o SSID relacionado a um �ndice caso plataforma seja compilada com a funcionalidade de m�ltiplos SSID�s. Para consulta primeiro deve-se adicionar o �ndice, por exemplo, �01�, chamando a fun��o PW_iAddParam. Em seguida, consultar o resultado por meio de PW_iGetResult. Nesse resultado, � retornado o nome.
  PWINFO_DNSSERVER_P      = 32588;  // Servidor de DNS prim�rio configurado.
  PWINFO_DNSSERVER_S      = 32589;  // Servidor de DNS secund�rio configurado.
  PWINFO_OSVERSION        = 32590;  // Vers�o do sistema operacional.
  PWINFO_APPDOWNLOADVER   = 32591;  // Vers�o da biblioteca de telecarga.
  PWINFO_DSPQRPREF        = 32592;  // Caso a exibi��o de QR Code seja suportada pela Automa��o Comercial e pelo PIN-Pad, indica a prefer�ncia do local de exibi��o: 1: exibe no PIN-Pad; 2: exibe no checkout; OBS: Caso esse dado n�o seja informado e o ponto de captura esteja configurado no Muxx como autoatendimento, exibe no checkout, caso contr�rio, exibe no PIN-pad.
  PWINFO_SELFATT          = 32593;  // Indica se o ponto de captura est� configurado para operar na modalidade de autoatendimento: 0: opera��o assistida; 1: autoatendimento.
  PWINFO_DUEAMNT          = 48902;  // Valor devido pelo usu�rio, considerando PWINFO_CURREXP, j� deduzido em PWINFO_TOTAMNT
  PWINFO_READJUSTEDAMNT   = 48905;  // Valor total da transa��o reajustado, este campo ser� utilizado caso o autorizador, por alguma regra de neg�cio espec�fica dele, resolva alterar o valor total que foi solicitado para a transa��o
  PWINFO_TRNORIGDATETIME  = 48909;  // Data e hora da transa��o original, no formato �AAAAMMDDhhmmss�, no caso de um cancelamento.
  PWINFO_DATETIMERCPT     = 48910;  // Data/hora da transa��o para exibi��o no comprovante, no formato �AAAAMMDDhhmmss�.
  PWINFO_UNIQUEID         = 49040;  // ID �nico da transa��o armazenada no banco de dados
  PWINFO_GRAPHICRCP       = 40722;  // Indica, se poss�vel, a necessidade de impress�o de um comprovante gr�fico: 0: N�o necess�rio. 1: Necess�rio.
  PWINFO_OPERATIONORIG    = 40727;  // Tipo de transa��o (PWOPER_xxx) da transa��o original, no caso de reimpress�es. Consultar os valores poss�veis na descri��o da fun��o PW_iNewTransac (p�gina 14)

  // Indices de uso interno do ACBr (n�o mapeados pela PayGoWeb)
  PWINFO_CONFTRANSIDENT   = 65500; // confirmTransactionIdentifier (Android)

  MIN_PWINFO = PWINFO_OPERATION;
  MAX_PWINFO = PWINFO_UNIQUEID;

type
  EACBrTEFPayGoWeb = class(EACBrTEFErro);

  { TACBrTEFRespPayGoWeb }

  TACBrTEFRespPayGoWeb = class( TACBrTEFResp )
  public
    procedure ConteudoToProperty; override;
  end;

procedure ConteudoToPropertyPayGoWeb(AACBrTEFResp: TACBrTEFResp);
procedure DadosDaTransacaoToTEFResp(ADadosDaTransacao: TACBrTEFParametros; ATefResp: TACBrTEFResp);
function DadoStrToCurrency(ADadosDaTransacao: TACBrTEFParametros; iINFO: Word): Currency;
function DadoStrToDateTime(ADado: String): TDateTime;

function ParseKeyValue(const AKeyValueStr: String; out TheKey: String; out TheValue: String): Boolean;
function PWINFOToString(iINFO: Word): String;
function PWOPERToString(iOPER: Byte): String;
function PWCNFToString(iCNF: LongWord): String;

function MoedaToISO4217(AMoeda: Byte): Word;
function ISO4217ToMoeda(AIso4217: Word): Byte;

function StatusTransacaoToPWCNF_( AStatus: TACBrTEFStatusTransacao): LongWord;
function OperacaoAdminToPWOPER_( AOperacao: TACBrTEFOperacao): Byte;

implementation

uses
  Math, DateUtils, StrUtils,
  ACBrTEFPayGoRedes, ACBrConsts,
  ACBrUtil.Math,
  ACBrUtil.Strings,
  ACBrUtil.Base;

procedure ConteudoToPropertyPayGoWeb(AACBrTEFResp: TACBrTEFResp);

  procedure ConteudoToComprovantes;
  var
    ImprimirViaCliente, ImprimirViaEstabelecimento: Boolean;
    ViaCompleta, ViaDiferenciada, ViasDeComprovante: String;

    function ViaDoCliente( ViaReduzida: Boolean ): String;
    begin
      if ViaReduzida then
        Result := AACBrTEFResp.LeInformacao(PWINFO_RCPTCHSHORT, 0).AsBinary
      else
        Result := AACBrTEFResp.LeInformacao(PWINFO_RCPTCHOLDER, 0).AsBinary;
    end;

  begin
    with AACBrTEFResp do
    begin
      {
      PWINFO_RCPTPRN      F4h 1 Indica quais vias de comprovante devem ser impressas:
                              0: n�o h� comprovante, 1: imprimir somente a via do Cliente,
                              2: imprimir somente a via do Estabelecimento, 3: imprimir ambas as vias do Cliente e do Estabelecimento
      PWINFO_RCPTFULL     52h Comprovante para impress�o � Via completa.
                              At� 40 colunas, quebras de linha identificadas pelo caractere 0Dh.
      PWINFO_RCPTMERCH    53h Comprovante para impress�o � Via diferenciada para o Estabelecimento.
                              At� 40 colunas, quebras de linha identificadas pelo caractere 0Dh.
      PWINFO_RCPTCHOLDER  54h Comprovante para impress�o � Via diferenciada para o Cliente.
                              At� 40 colunas, quebras de linha identificadas pelo caractere 0Dh.
      PWINFO_RCPTCHSHORT  55h Comprovante para impress�o � Cupom reduzido (para o Cliente).
                              At� 40 colunas, quebras de linha identificadas pelo caractere 0Dh.
      }

      ViasDeComprovante := Trim(LeInformacao(PWINFO_RCPTPRN, 0).AsString);
      if (ViasDeComprovante = '') then
        ViasDeComprovante := '3';

      ImprimirViaCliente := (ViasDeComprovante = '1') or (ViasDeComprovante = '3');
      ImprimirViaEstabelecimento := (ViasDeComprovante = '2') or (ViasDeComprovante = '3');
      if (not ImprimirViaEstabelecimento) then
        ImprimirViaEstabelecimento := (Trim(LeInformacao(PWINFO_RCPTMERCH, 0).AsBinary) <> '') ;

      ViaCompleta := LeInformacao(PWINFO_RCPTFULL, 0).AsBinary;

      // Verificando Via do Estabelecimento
      if ImprimirViaEstabelecimento then
      begin
        ViaDiferenciada := LeInformacao(PWINFO_RCPTMERCH, 0).AsBinary;
        if (Trim(ViaDiferenciada) <> '') then
          ImagemComprovante2aVia.Text := ViaDiferenciada
        else
          ImagemComprovante2aVia.Text := ViaCompleta;
      end
      else
        ImagemComprovante2aVia.Clear;

      // Verificando Via do Cliente
      if ImprimirViaCliente then
      begin
        ViaDiferenciada := ViaDoCliente( ViaClienteReduzida );
        if (Trim(ViaDiferenciada) = '') then
          ViaDiferenciada := ViaDoCliente( not ViaClienteReduzida );

        if (Trim(ViaDiferenciada) <> '') then
          ImagemComprovante1aVia.Text := ViaDiferenciada
        else
          ImagemComprovante1aVia.Text := ViaCompleta;
      end
      else
        ImagemComprovante1aVia.Clear;

      QtdLinhasComprovante := max(ImagemComprovante1aVia.Count, ImagemComprovante2aVia.Count);
    end;
  end;

  procedure ConteudoToParcelas;
  var
    DataParcela: TDateTime;
    ValorPrimeiraParcela, ValorParcelas, SaldoParcelas: Currency;
    I: Integer;
    Parc: TACBrTEFRespParcela;
  begin
    with AACBrTEFResp do
    begin
      Parcelas.Clear;

      QtdParcelas := LeInformacao(PWINFO_INSTALLMENTS, 0).AsInteger;
      if (QtdParcelas > 0) then
      begin
        DataParcela := LeInformacao(PWINFO_INSTALLMDATE, 0).AsDate;
        if (DataParcela = 0) then
          DataParcela := IncDay(DateOf(DataHoraTransacaoLocal), 30);

        ValorParcelas := LeInformacao(PWINFO_INSTALLMAMNT, 0).AsFloat;
        if (ValorParcelas = 0) then
          ValorParcelas := RoundABNT((ValorTotal / QtdParcelas), -2);

        ValorPrimeiraParcela := LeInformacao(PWINFO_INSTALLM1AMT, 0).AsFloat;
        if (ValorPrimeiraParcela = 0) then
          ValorPrimeiraParcela := ValorParcelas;

        SaldoParcelas := ValorTotal;

        for I := 1 to QtdParcelas do
        begin
          Parc := TACBrTEFRespParcela.create;
          Parc.Vencimento := DataParcela;
          if (I = QtdParcelas) then
            Parc.Valor := SaldoParcelas
          else if (I = 1) then
            Parc.Valor := ValorPrimeiraParcela
          else
            Parc.Valor := ValorParcelas;

          Parc.NSUParcela := NSU;
          Parcelas.Add(Parc);

          DataParcela := IncDay(DataParcela,30);
          SaldoParcelas := SaldoParcelas - Parc.Valor;
        end;
      end;
    end;
  end;

var
  I, AInt: Integer;
  LinStr: String;
  Linha: TACBrTEFLinha;
  ARede: TACBrTEFPayGoRede;
begin
  with AACBrTEFResp do
  begin
    ImagemComprovante1aVia.Clear;
    ImagemComprovante2aVia.Clear;
    Debito := False;
    Credito := False;
    Digitado := False;
    TaxaServico := 0;
    DataHoraTransacaoCancelada := 0;

    for I := 0 to Conteudo.Count - 1 do
    begin
      Linha := Conteudo.Linha[I];
      LinStr := Linha.Informacao.AsBinary;

      case Linha.Identificacao of
        PWINFO_TOTAMNT:
          ValorTotal := Linha.Informacao.AsFloat;

        PWINFO_DISCOUNTAMT:
          Desconto := Linha.Informacao.AsFloat;

        PWINFO_CASHBACKAMT:
          Saque := Linha.Informacao.AsFloat;

        PWINFO_CURRENCY:
        begin
          AInt := Linha.Informacao.AsInteger;
          Moeda := ISO4217ToMoeda(AInt);
        end;

        PWINFO_CNFREQ:
          Confirmar := (Trim(Linstr)='1');

        PWINFO_FISCALREF:
          DocumentoVinculado := LinStr;

        PWINFO_CARDTYPE:
        begin
          // 1: cr�dito, 2: d�bito, 4: voucher/PAT, 8: private label, 16: frota, 128: outros
          AInt := Linha.Informacao.AsInteger;
          Credito := (AInt = 1);
          Debito := (AInt = 2);
          Voucher := (Aint = 4);
        end;

        PWINFO_CARDENTMODE:
        begin
          // 1: digitado, 2: tarja magn�tica, 4: chip com contato, 16: fallback de chip para tarja,
          // 32: chip sem contato simulando tarja (cliente informa tipo efetivamente utilizado),
          // 64: chip sem contato EMV (cliente informa tipo efetivamente, utilizado),
          // 256: fallback de tarja para digitado
          AInt := Linha.Informacao.AsInteger;
          Digitado := (AInt = 1) or (AInt = 256);
        end;

        PWINFO_CARDFULLPAN:
        begin
          BIN := LinStr;
          NFCeSAT.UltimosQuatroDigitos := RightStr(LinStr,4);
        end;

        PWINFO_CARDPARCPAN:
        begin
          if (NFCeSAT.UltimosQuatroDigitos = '') then
            NFCeSAT.UltimosQuatroDigitos := RightStr(LinStr,4);
        end;

        PWINFO_DEFAULTCARDPARCPAN:
        begin
          BIN := LinStr;
          NFCeSAT.UltimosQuatroDigitos := RightStr(LinStr,4);
        end;

        PWINFO_CARDEXPDATE:
          NFCeSAT.DataExpiracao := LinStr;

        PWINFO_DATETIME:
          DataHoraTransacaoLocal := Linha.Informacao.AsTimeStampSQL;

        PWINFO_AUTDATETIME:
          DataHoraTransacaoHost :=  Linha.Informacao.AsTimeStampSQL;

        PWINFO_DATETIMERCPT:
          DataHoraTransacaoComprovante := Linha.Informacao.AsTimeStampSQL;

        PWINFO_AUTHSYST:
        begin
          Rede := LinStr;
          if (Trim(Rede) <> '') then
          begin
            ARede := TabelaRedes.FindPGWeb(Rede);
            if Assigned(ARede) then
            begin
              if (NFCeSAT.Bandeira = '') then
                NFCeSAT.Bandeira := ARede.NomePGWeb;

              NFCeSAT.CNPJCredenciadora := ARede.CNPJ;
              NFCeSAT.CodCredenciadora := IntToStrZero(ARede.CodSATCFe, 3);
            end;
          end;
        end;

        PWINFO_CARDNAME:
        begin
          CodigoBandeiraPadrao := LinStr;
          if (NFCeSAT.Bandeira = '') then
            NFCeSAT.Bandeira := LinStr;
        end;

        PWINFO_CARDNAMESTD:
        begin
          NomeAdministradora := LinStr;
          NFCeSAT.Bandeira := LinStr;
        end;

        PWINFO_CHOLDERNAME:
          NFCeSAT.DonoCartao := LinStr;

        PWINFO_AUTLOCREF:
          Finalizacao := LinStr;

        PWINFO_AUTEXTREF:
        begin
          NSU := LinStr;
          CodigoPSP := LinStr;
          NFCeSAT.Autorizacao := NSU;
        end;

        PWINFO_REQNUM:
        begin
          NumeroLoteTransacao := Linha.Informacao.AsInt64;
          NSU_TEF := LinStr;
        end;

        PWINFO_VIRTMERCH:
          Estabelecimento := LinStr;

        PWINFO_AUTHCODE:
          CodigoAutorizacaoTransacao := LinStr;

        //PWINFO_AUTRESPCODE:
        //  Autenticacao := LinStr;

        PWINFO_FINTYPE:
        begin
          // 1: � vista, 2: parcelado pelo emissor, 4: parcelado pelo estabelecimento, 8: pr�-datado, 16: cr�dito emissor
          AInt := Linha.Informacao.AsInteger;
          if (AInt = 2) then
          begin
            ParceladoPor := parcADM;
            TipoOperacao := opParcelado;
          end
          else if (AInt = 4) then
          begin
            ParceladoPor := parcLoja;
            TipoOperacao := opParcelado;
          end
          else if (AInt = 8) then
          begin
            ParceladoPor := parcNenhum;
            TipoOperacao := opPreDatado;
          end
          else if (AInt = 16) then
          begin
            ParceladoPor := parcNenhum;
            TipoOperacao := opOutras;
          end
          else
          begin
            ParceladoPor := parcNenhum;
            TipoOperacao := opAvista;
          end
        end;

        PWINFO_INSTALLMDATE:
          DataPreDatado := Linha.Informacao.AsDate;

        PWINFO_BOARDINGTAX, PWINFO_TIPAMOUNT:
          TaxaServico := TaxaServico + Linha.Informacao.AsFloat;

        PWINFO_TRNORIGDATE:
          DataHoraTransacaoCancelada := DataHoraTransacaoCancelada + Linha.Informacao.AsDate;

        PWINFO_TRNORIGTIME:
          DataHoraTransacaoCancelada := DataHoraTransacaoCancelada + Linha.Informacao.AsTime;

        PWINFO_TRNORIGNSU:
          NSUTransacaoCancelada := LinStr;

        PWINFO_TRNORIGAMNT:
          ValorOriginal := Linha.Informacao.AsFloat;

        PWINFO_AUTHPOSQRCODE:
          QRCode := LinStr;

        PWINFO_POSID:
          SerialPOS := LinStr;

        PWINFO_PRODUCTNAME:  // 2Ah at� 20 Nome/tipo do produto utilizado, na nomenclatura do Provedor
          Instituicao := LinStr;

        //PWINFO_PRODUCTID   3Eh at� 8 Identifica��o do produto utilizado, de acordo com a nomenclatura do Provedor.
        //PWINFO_AUTMERCHID  38h at� 50 Identificador do estabelecimento para o Provedor (c�digo de afilia��o)
        //PWINFO_TRANSACDESCRIPT 1F40h At� 80 Descritivo da transa��o realizada, por exemplo, CREDITO A VISTA ou VENDA PARCELADA EM DUAS VEZES.
      else
        ProcessarTipoInterno(Linha);
      end;
    end;

    ConteudoToComprovantes;
    ConteudoToParcelas;

    if (TipoOperacao <> opPreDatado) then
      DataPreDatado := 0;

    Confirmar := Confirmar or (QRCode <> '');
    Sucesso := (LeInformacao(PWINFO_RET, 0).AsInteger = PWRET_OK);

    if Sucesso then
      TextoEspecialOperador := LeInformacao(PWINFO_RESULTMSG, 0).AsBinary
    else
      TextoEspecialOperador := IfEmptyThen( LeInformacao(PWINFO_CNCDSPMSG, 0).AsBinary,
                                            LeInformacao(PWINFO_RESULTMSG, 0).AsBinary );

    // Workaround, para situa��es onde a VERO / BANRICOMPRAS n�o retorna o CodigoAutorizacaoTransacao ou PWINFO_AUTHCODE (0x46)
    if (CodigoAutorizacaoTransacao = '') then
    begin
      if (UpperCase(Instituicao) = 'BANRICOMPRAS') and (UpperCase(Rede) = 'VERO') then
        CodigoAutorizacaoTransacao := NSU;
    end;

    if (Trim(TextoEspecialOperador) = '') then
      TextoEspecialOperador := 'TRANSACAO FINALIZADA'
    else if (copy(TextoEspecialOperador,1,1) = CR) then
      TextoEspecialOperador := copy(TextoEspecialOperador, 2, Length(TextoEspecialOperador));
  end;
end;

procedure DadosDaTransacaoToTEFResp(ADadosDaTransacao: TACBrTEFParametros;
  ATefResp: TACBrTEFResp);
var
  i, p, AInfo: Integer;
  Lin, AValue: String;
begin
  for i := 0 to ADadosDaTransacao.Count-1 do
  begin
    Lin := ADadosDaTransacao[i];
    p := pos('=', Lin);
    if (p > 0) then
    begin
      AInfo := StrToIntDef(copy(Lin, 1, p-1), -1);
      if (AInfo >= 0) then
      begin
        AValue := copy(Lin, P+1, Length(Lin));
        ATefResp.Conteudo.GravaInformacao(Ainfo, 0, AValue);
      end;
    end;
  end;

  ConteudoToPropertyPayGoWeb( ATefResp );
end;

function DadoStrToCurrency(ADadosDaTransacao: TACBrTEFParametros; iINFO: Word): Currency;
var
  ADado: String;
  Centavos: Integer;
  Pow: Extended;
begin
  Result := 0;
  ADado := Trim(ADadosDaTransacao.ValueInfo[iINFO]);
  if (ADado = '') then
    Exit;

  Centavos := StrToIntDef( Trim(ADadosDaTransacao.ValueInfo[PWINFO_CURREXP]), 2);
  Pow := IntPower(10, Centavos);

  Result := StrToFloatDef(ADado, 0);
  Result := Result / Pow;
end;

function DadoStrToDateTime(ADado: String): TDateTime;
var
  DateTimeStr : String;
begin
  Result := 0;
  if (ADado = '') then
    Exit;

  DateTimeStr := OnlyNumber(Trim(ADado));
  try
    Result := EncodeDateTime( StrToInt(copy(DateTimeStr,1,4)),
                              StrToInt(copy(DateTimeStr,5,2)),
                              StrToInt(copy(DateTimeStr,7,2)),
                              StrToIntDef(copy(DateTimeStr,9,2),0),
                              StrToIntDef(copy(DateTimeStr,11,2),0),
                              StrToIntDef(copy(DateTimeStr,13,2),0), 0) ;
  except
    Result := 0 ;
  end;
end;

function ParseKeyValue(const AKeyValueStr: String; out TheKey: String; out
  TheValue: String): Boolean;
var
  p: Integer;
begin
  Result := False;
  p := pos('=', AKeyValueStr);
  if (p > 0) then
  begin
    TheKey := copy(AKeyValueStr, 1, p-1);
    if (TheKey <> '') then
    begin
      TheValue := copy(AKeyValueStr, P+1, Length(AKeyValueStr));
      Result := True;
    end;
  end;
end;

function PWINFOToString(iINFO: Word): String;
begin
  case iINFO of
    PWINFO_RET:             Result := 'PWINFO_RET';
    PWINFO_OPERATION:       Result := 'PWINFO_OPERATION';
    PWINFO_PPPPWD:          Result := 'PWINFO_PPPPWD';
    PWINFO_LOCALIP:         Result := 'PWINFO_LOCALIP';
    PWINFO_GATEWAY:         Result := 'PWINFO_GATEWAY';
    PWINFO_SUBNETMASK:      Result := 'PWINFO_SUBNETMASK';
    PWINFO_SSID:            Result := 'PWINFO_SSID';
    PWINFO_POSID:           Result := 'PWINFO_POSID';
    PWINFO_AUTNAME:         Result := 'PWINFO_AUTNAME';
    PWINFO_AUTVER:          Result := 'PWINFO_AUTVER';
    PWINFO_AUTDEV:          Result := 'PWINFO_AUTDEV';
    PWINFO_DESTTCPIP:       Result := 'PWINFO_DESTTCPIP';
    PWINFO_MERCHCNPJCPF:    Result := 'PWINFO_MERCHCNPJCPF';
    PWINFO_AUTCAP:          Result := 'PWINFO_AUTCAP';
    PWINFO_TOTAMNT:         Result := 'PWINFO_TOTAMNT';
    PWINFO_CURRENCY:        Result := 'PWINFO_CURRENCY';
    PWINFO_CURREXP:         Result := 'PWINFO_CURREXP';
    PWINFO_FISCALREF:       Result := 'PWINFO_FISCALREF';
    PWINFO_CARDTYPE:        Result := 'PWINFO_CARDTYPE';
    PWINFO_PRODUCTNAME:     Result := 'PWINFO_PRODUCTNAME';
    PWINFO_DATETIME:        Result := 'PWINFO_DATETIME';
    PWINFO_REQNUM:          Result := 'PWINFO_REQNUM';
    PWINFO_AUTHSYST:        Result := 'PWINFO_AUTHSYST';
    PWINFO_VIRTMERCH:       Result := 'PWINFO_VIRTMERCH';
    PWINFO_AUTMERCHID:      Result := 'PWINFO_AUTMERCHID';
    PWINFO_PHONEFULLNO:     Result := 'PWINFO_PHONEFULLNO';
    PWINFO_FINTYPE:         Result := 'PWINFO_FINTYPE';
    PWINFO_INSTALLMENTS:    Result := 'PWINFO_INSTALLMENTS';
    PWINFO_INSTALLMDATE:    Result := 'PWINFO_INSTALLMDATE';
    PWINFO_PRODUCTID:       Result := 'PWINFO_PRODUCTID';
    PWINFO_RESULTMSG:       Result := 'PWINFO_RESULTMSG';
    PWINFO_CNFREQ:          Result := 'PWINFO_CNFREQ';
    PWINFO_AUTLOCREF:       Result := 'PWINFO_AUTLOCREF';
    PWINFO_AUTEXTREF:       Result := 'PWINFO_AUTEXTREF';
    PWINFO_AUTHCODE:        Result := 'PWINFO_AUTHCODE';
    PWINFO_AUTRESPCODE:     Result := 'PWINFO_AUTRESPCODE';
    PWINFO_AUTDATETIME:     Result := 'PWINFO_AUTDATETIME';
    PWINFO_DISCOUNTAMT:     Result := 'PWINFO_DISCOUNTAMT';
    PWINFO_CASHBACKAMT:     Result := 'PWINFO_CASHBACKAMT';
    PWINFO_CARDNAME:        Result := 'PWINFO_CARDNAME';
    PWINFO_ONOFF:           Result := 'PWINFO_ONOFF';
    PWINFO_BOARDINGTAX:     Result := 'PWINFO_BOARDINGTAX';
    PWINFO_TIPAMOUNT:       Result := 'PWINFO_TIPAMOUNT';
    PWINFO_INSTALLM1AMT:    Result := 'PWINFO_INSTALLM1AMT';
    PWINFO_INSTALLMAMNT:    Result := 'PWINFO_INSTALLMAMNT';
    PWINFO_RCPTFULL:        Result := 'PWINFO_RCPTFULL';
    PWINFO_RCPTMERCH:       Result := 'PWINFO_RCPTMERCH';
    PWINFO_RCPTCHOLDER:     Result := 'PWINFO_RCPTCHOLDER';
    PWINFO_RCPTCHSHORT:     Result := 'PWINFO_RCPTCHSHORT';
    PWINFO_TRNORIGDATE:     Result := 'PWINFO_TRNORIGDATE';
    PWINFO_TRNORIGNSU:      Result := 'PWINFO_TRNORIGNSU';
    PWINFO_SALDOVOUCHER:    Result := 'PWINFO_SALDOVOUCHER';
    PWINFO_TRNORIGAMNT:     Result := 'PWINFO_TRNORIGAMNT';
    PWINFO_TRNORIGAUTH:     Result := 'PWINFO_TRNORIGAUTH';
    PWINFO_LANGUAGE:        Result := 'PWINFO_LANGUAGE';
    PWINFO_PROCESSMSG:      Result := 'PWINFO_PROCESSMSG';
    PWINFO_TRNORIGREQNUM:   Result := 'PWINFO_TRNORIGREQNUM';
    PWINFO_TRNORIGTIME:     Result := 'PWINFO_TRNORIGTIME';
    PWINFO_CNCDSPMSG:       Result := 'PWINFO_CNCDSPMSG';
    PWINFO_CNCPPMSG:        Result := 'PWINFO_CNCPPMSG';
    PWINFO_TRNORIGLOCREF:   Result := 'PWINFO_TRNORIGLOCREF';
    PWINFO_AUTHSYSTEXTENDED:Result := 'PWINFO_AUTHSYSTEXTENDED';
    PWINFO_CARDENTMODE:     Result := 'PWINFO_CARDENTMODE';
    PWINFO_CARDFULLPAN:     Result := 'PWINFO_CARDFULLPAN';
    PWINFO_CARDEXPDATE:     Result := 'PWINFO_CARDEXPDATE';
    PWINFO_CARDNAMESTD:     Result := 'PWINFO_CARDNAMESTD';
    PWINFO_PRODNAMEDESC:    Result := 'PWINFO_PRODNAMEDESC';
    PWINFO_CARDPARCPAN:     Result := 'PWINFO_CARDPARCPAN';
    PWINFO_CHOLDVERIF:      Result := 'PWINFO_CHOLDVERIF';
    PWINFO_EMVRESPCODE:     Result := 'PWINFO_EMVRESPCODE';
    PWINFO_AID:             Result := 'PWINFO_AID';
    PWINFO_BARCODENTMODE:   Result := 'PWINFO_BARCODENTMODE';
    PWINFO_BARCODE:         Result := 'PWINFO_BARCODE';
    PWINFO_MERCHADDDATA1:   Result := 'PWINFO_MERCHADDDATA1';
    PWINFO_MERCHADDDATA2:   Result := 'PWINFO_MERCHADDDATA2';
    PWINFO_MERCHADDDATA3:   Result := 'PWINFO_MERCHADDDATA3';
    PWINFO_MERCHADDDATA4:   Result := 'PWINFO_MERCHADDDATA4';
    PWINFO_RCPTPRN:         Result := 'PWINFO_RCPTPRN';
    PWINFO_AUTHMNGTUSER:    Result := 'PWINFO_AUTHMNGTUSER';
    PWINFO_AUTHTECHUSER:    Result := 'PWINFO_AUTHTECHUSER';
    PWINFO_MERCHNAMERCPT:   Result := 'PWINFO_MERCHNAMERCPT';
    PWINFO_PRODESTABRCPT:   Result := 'PWINFO_PRODESTABRCPT';
    PWINFO_PRODCLIRCPT:     Result := 'PWINFO_PRODCLIRCPT';
    PWINFO_EMVCRYPTTYPE:    Result := 'PWINFO_EMVCRYPTTYPE';
    PWINFO_TRNORIGAUTHCODE: Result := 'PWINFO_TRNORIGAUTHCODE';
    PWINFO_PAYMNTTYPE:      Result := 'PWINFO_PAYMNTTYPE';
    PWINFO_GRAPHICRCPHEADER: Result := 'PWINFO_GRAPHICRCPHEADER';
    PWINFO_GRAPHICRCPFOOTER: Result := 'PWINFO_GRAPHICRCPFOOTER';
    PWINFO_CHOLDERNAME:     Result := 'PWINFO_CHOLDERNAME';
    PWINFO_MERCHNAMEPDC:    Result := 'PWINFO_MERCHNAMEPDC';
    PWINFO_TRANSACDESCRIPT: Result := 'PWINFO_TRANSACDESCRIPT';
    PWINFO_ARQC:            Result := 'PWINFO_ARQC';
    PWINFO_DEFAULTCARDPARCPAN: Result := 'PWINFO_DEFAULTCARDPARCPAN';
    PWINFO_SOFTDESCRIPTOR:  Result := 'PWINFO_SOFTDESCRIPTOR';
    PWINFO_RCPTADDINFOESTABCLI: Result := 'PWINFO_RCPTADDINFOESTABCLI';
    PWINFO_RCPTADDINFOCLI:  Result := 'PWINFO_RCPTADDINFOCLI';
    PWINFO_RCPTADDINFOESTAB:Result := 'PWINFO_RCPTADDINFOESTAB';
    PWINFO_SPLITPAYMENT:    Result := 'PWINFO_SPLITPAYMENT';
    PWINFO_AUTHPOSQRCODE:   Result := 'PWINFO_AUTHPOSQRCODE';
    PWINFO_WALLETUSERIDTYPE:Result := 'PWINFO_WALLETUSERIDTYPE';
    PWINFO_RCPTECVID:       Result := 'PWINFO_RCPTECVID';
    PWINFO_USINGPINPAD:     Result := 'PWINFO_USINGPINPAD';
    PWINFO_PPCOMMPORT:      Result := 'PWINFO_PPCOMMPORT';
    PWINFO_IDLEPROCTIME:    Result := 'PWINFO_IDLEPROCTIME';
    PWINFO_PNDAUTHSYST:     Result := 'PWINFO_PNDAUTHSYST';
    PWINFO_PNDVIRTMERCH:    Result := 'PWINFO_PNDVIRTMERCH';
    PWINFO_PNDREQNUM:       Result := 'PWINFO_PNDREQNUM';
    PWINFO_PNDAUTLOCREF:    Result := 'PWINFO_PNDAUTLOCREF';
    PWINFO_PNDAUTEXTREF:    Result := 'PWINFO_PNDAUTEXTREF';
    PWINFO_LOCALINFO1:      Result := 'PWINFO_LOCALINFO1';
    PWINFO_SERVERPND:       Result := 'PWINFO_SERVERPND';
    PWINFO_PPINFO:          Result := 'PWINFO_PPINFO';
    PWINFO_RESULTID:        Result := 'PWINFO_RESULTID';
    PWINFO_DSPCHECKOUT1:    Result := 'PWINFO_DSPCHECKOUT1';
    PWINFO_DSPCHECKOUT2:    Result := 'PWINFO_DSPCHECKOUT2';
    PWINFO_DSPCHECKOUT3:    Result := 'PWINFO_DSPCHECKOUT3';
    PWINFO_DSPCHECKOUT4:    Result := 'PWINFO_DSPCHECKOUT4';
    PWINFO_DSPCHECKOUT5:    Result := 'PWINFO_DSPCHECKOUT5';
    PWINFO_CTLSCAPTURE:     Result := 'PWINFO_CTLSCAPTURE';
    PWINFO_CHOLDERGRARCP:   Result := 'PWINFO_CHOLDERGRARCP';
    PWINFO_MERCHGRARCP:     Result := 'PWINFO_MERCHGRARCP';
    PWINFO_AUTADDRESS:      Result := 'PWINFO_AUTADDRESS';
    PWINFO_APN:             Result := 'PWINFO_APN';
    PWINFO_LIBVERSION:      Result := 'PWINFO_LIBVERSION';
    PWINFO_TSTKEYTYPE:      Result := 'PWINFO_TSTKEYTYPE';
    PWINFO_TKPINDUKPT3DES:  Result := 'PWINFO_TKPINDUKPT3DES';
    PWINFO_TKPINMK3DES:     Result := 'PWINFO_TKPINMK3DES';
    PWINFO_TKPINMKDES:      Result := 'PWINFO_TKPINMKDES';
    PWINFO_TKDADOSDUKPT3DES:Result := 'PWINFO_TKDADOSDUKPT3DES';
    PWINFO_TKDADOSMK3DES:   Result := 'PWINFO_TKDADOSMK3DES';
    PWINFO_TKDADOSMKDES:    Result := 'PWINFO_TKDADOSMKDES';
    PWINFO_DSPTESTKEY:      Result := 'PWINFO_DSPTESTKEY';
    PWINFO_GETKSNPIN:       Result := 'PWINFO_GETKSNPIN';
    PWINFO_GETKSNDATA:      Result := 'PWINFO_GETKSNDATA';
    PWINFO_PINDUKPT3DESNAME:Result := 'PWINFO_PINDUKPT3DESNAME';
    PWINFO_PINMK3DESNAME:   Result := 'PWINFO_PINMK3DESNAME';
    PWINFO_PINMKDESNAME:    Result := 'PWINFO_PINMKDESNAME';
    PWINFO_DATADUKPT3DESNAME:Result := 'PWINFO_DATADUKPT3DESNAME';
    PWINFO_DATAMK3DESNAME:  Result := 'PWINFO_DATAMK3DESNAME';
    PWINFO_DATAMKDESNAME:   Result := 'PWINFO_DATAMKDESNAME';
    PWINFO_SERNUM:          Result := 'PWINFO_SERNUM';
    PWINFO_MACADDR:         Result := 'PWINFO_MACADDR';
    PWINFO_IMEI:            Result := 'PWINFO_IMEI';
    PWINFO_IPADDRESS:       Result := 'PWINFO_IPADDRESS';
    PWINFO_SSID_IDX:        Result := 'PWINFO_SSID_IDX';
    PWINFO_DNSSERVER_P:     Result := 'PWINFO_DNSSERVER_P';
    PWINFO_DNSSERVER_S:     Result := 'PWINFO_DNSSERVER_S';
    PWINFO_OSVERSION:       Result := 'PWINFO_OSVERSION';
    PWINFO_APPDOWNLOADVER:  Result := 'PWINFO_APPDOWNLOADVER';
    PWINFO_DSPQRPREF:       Result := 'PWINFO_DSPQRPREF';
    PWINFO_SELFATT:         Result := 'PWINFO_SELFATT';
    PWINFO_GRAPHICRCP:      Result := 'PWINFO_GRAPHICRCP';
    PWINFO_OPERATIONORIG:   Result := 'PWINFO_OPERATIONORIG';
    PWINFO_DUEAMNT:         Result := 'PWINFO_DUEAMNT';
    PWINFO_READJUSTEDAMNT:  Result := 'PWINFO_READJUSTEDAMNT';
    PWINFO_TRNORIGDATETIME: Result := 'PWINFO_TRNORIGDATETIME';
    PWINFO_DATETIMERCPT:    Result := 'PWINFO_DATETIMERCPT';
    PWINFO_UNIQUEID:        Result := 'PWINFO_UNIQUEID';
    PWINFO_CONFTRANSIDENT:  Result := 'PWINFO_CONFTRANSIDENT';
  else
    Result := 'PWINFO_'+IntToStr(iINFO);
  end;
end;

function PWOPERToString(iOPER: Byte): String;
begin
  case iOPER of
    PWOPER_NULL:         Result := 'PWOPER_NULL';
    PWOPER_INSTALL:      Result := 'PWOPER_INSTALL';
    PWOPER_PARAMUPD:     Result := 'PWOPER_PARAMUPD';
    PWOPER_REPRINT:      Result := 'PWOPER_REPRINT';
    PWOPER_RPTTRUNC:     Result := 'PWOPER_RPTTRUNC';
    PWOPER_RPTDETAIL:    Result := 'PWOPER_RPTDETAIL';
    PWOPER_REPRNTNTRANSACTION: Result := 'PWOPER_REPRNTNTRANSACTION';
    PWOPER_COMMTEST:     Result := 'PWOPER_COMMTEST';
    PWOPER_RPTSUMMARY:   Result := 'PWOPER_RPTSUMMARY';
    PWOPER_TRANSACINQ:   Result := 'PWOPER_TRANSACINQ';
    PWOPER_ROUTINGINQ:   Result := 'PWOPER_ROUTINGINQ';
    PWOPER_ADMIN:        Result := 'PWOPER_ADMIN';
    PWOPER_SALE:         Result := 'PWOPER_SALE';
    PWOPER_SALEVOID:     Result := 'PWOPER_SALEVOID';
    PWOPER_PREPAID:      Result := 'PWOPER_PREPAID';
    PWOPER_CHECKINQ:     Result := 'PWOPER_CHECKINQ';
    PWOPER_RETBALINQ:    Result := 'PWOPER_RETBALINQ';
    PWOPER_CRDBALINQ:    Result := 'PWOPER_CRDBALINQ';
    PWOPER_INITIALIZ:    Result := 'PWOPER_INITIALIZ';
    PWOPER_SETTLEMNT:    Result := 'PWOPER_SETTLEMNT';
    PWOPER_PREAUTH:      Result := 'PWOPER_PREAUTH';
    PWOPER_PREAUTVOID:   Result := 'PWOPER_PREAUTVOID';
    PWOPER_CASHWDRWL:    Result := 'PWOPER_CASHWDRWL';
    PWOPER_LOCALMAINT:   Result := 'PWOPER_LOCALMAINT';
    PWOPER_FINANCINQ:    Result := 'PWOPER_FINANCINQ';
    PWOPER_ADDRVERIF:    Result := 'PWOPER_ADDRVERIF';
    PWOPER_SALEPRE:      Result := 'PWOPER_SALEPRE';
    PWOPER_LOYCREDIT:    Result := 'PWOPER_LOYCREDIT';
    PWOPER_LOYCREDVOID:  Result := 'PWOPER_LOYCREDVOID';
    PWOPER_LOYDEBIT:     Result := 'PWOPER_LOYDEBIT';
    PWOPER_LOYDEBVOID:   Result := 'PWOPER_LOYDEBVOID';
    PWOPER_BILLPAYMENT:  Result := 'PWOPER_BILLPAYMENT';
    PWOPER_DOCPAYMENTQ:  Result := 'PWOPER_DOCPAYMENTQ';
    PWOPER_LOGON:        Result := 'PWOPER_LOGON';
    PWOPER_SRCHPREAUTH:  Result := 'PWOPER_SRCHPREAUTH';
    PWOPER_ADDPREAUTH:   Result := 'PWOPER_ADDPREAUTH';
    PWOPER_VOID:         Result := 'PWOPER_VOID';
    PWOPER_STATISTICS:   Result := 'PWOPER_STATISTICS';
    PWOPER_CARDPAYMENT:  Result := 'PWOPER_CARDPAYMENT';
    PWOPER_CARDPAYMENTVOID: Result := 'PWOPER_CARDPAYMENTVOID';
    PWOPER_CASHWDRWLVOID:   Result := 'PWOPER_CASHWDRWLVOID';
    PWOPER_CARDUNLOCK:   Result := 'PWOPER_CARDUNLOCK';
    PWOPER_UPDATEDCHIP:  Result := 'PWOPER_UPDATEDCHIP';
    PWOPER_RPTPROMOTIONAL:  Result := 'PWOPER_RPTPROMOTIONAL';
    PWOPER_SALESUMMARY:  Result := 'PWOPER_SALESUMMARY';
    PWOPER_STATISTICSAUTHORIZER: Result := 'PWOPER_STATISTICSAUTHORIZER';
    PWOPER_OTHERADMIN:   Result := 'PWOPER_OTHERADMIN';
    PWOPER_BILLPAYMENTVOID:  Result := 'PWOPER_BILLPAYMENTVOID';
    PWOPER_TSTKEY:       Result := 'PWOPER_TSTKEY';
    PWOPER_EXPORTLOGS:   Result := 'PWOPER_EXPORTLOGS';
    PWOPER_COMMONDATA:   Result := 'PWOPER_COMMONDATA';
    PWOPER_SHOWPDC:      Result := 'PWOPER_SHOWPDC';
    PWOPER_VERSION:      Result := 'PWOPER_VERSION';
    PWOPER_CONFIG:       Result := 'PWOPER_CONFIG';
    PWOPER_MAINTENANCE:  Result := 'PWOPER_MAINTENANCE';
  else
    Result := 'PWOPER_'+IntToStr(iOPER);
  end;
end;

function PWCNFToString(iCNF: LongWord): String;
begin
  case iCNF of
    PWCNF_CNF_AUTO:      Result := 'PWCNF_CNF_AUTO';
    PWCNF_CNF_MANU_AUT:  Result := 'PWCNF_CNF_MANU_AUT';
    PWCNF_REV_MANU_AUT:  Result := 'PWCNF_REV_MANU_AUT';
    PWCNF_REV_PRN_AUT:   Result := 'PWCNF_REV_PRN_AUT';
    PWCNF_REV_DISP_AUT:  Result := 'PWCNF_REV_DISP_AUT';
    PWCNF_REV_COMM_AUT:  Result := 'PWCNF_REV_COMM_AUT';
    PWCNF_REV_ABORT:     Result := 'PWCNF_REV_ABORT';
    PWCNF_REV_OTHER_AUT: Result := 'PWCNF_REV_OTHER_AUT';
    PWCNF_REV_PWR_AUT:   Result := 'PWCNF_REV_PWR_AUT';
    PWCNF_REV_FISC_AUT:  Result := 'PWCNF_REV_FISC_AUT';
  else
    Result := 'PWCNF_'+IntToStr(iCNF);
  end;
end;

function MoedaToISO4217(AMoeda: Byte): Word;
begin
  case AMoeda of
    0: Result := 986;    // BRL
    1: Result := 840;    // USD
    2: Result := 978;    // EUR
  else
    Result := AMoeda;
  end;
end;

function ISO4217ToMoeda(AIso4217: Word): Byte;
begin
  case AIso4217 of
    986: Result := 0;    // BRL
    840: Result := 1;    // USD
    978: Result := 2;    // EUR
  else
    Result := AIso4217;
  end;
end;

function StatusTransacaoToPWCNF_( AStatus: TACBrTEFStatusTransacao): LongWord;
begin
  case AStatus of
    tefstsSucessoAutomatico: Result := PWCNF_CNF_AUTO;
    tefstsSucessoManual: Result := PWCNF_CNF_MANU_AUT;
    tefstsErroImpressao: Result := PWCNF_REV_PRN_AUT;
    tefstsErroDispesador: Result := PWCNF_REV_DISP_AUT;
    tefstsErroEnergia: Result := PWCNF_REV_PWR_AUT;
    tefstsErroDiverso: Result := PWCNF_REV_MANU_AUT;
  else
    Result := PWCNF_REV_MANU_AUT;
  end;
end;

function OperacaoAdminToPWOPER_(AOperacao: TACBrTEFOperacao): Byte;
begin
  case AOperacao of
    tefopPagamento: Result := PWOPER_SALE;
    tefopAdministrativo: Result := PWOPER_ADMIN;
    tefopTesteComunicacao: Result := PWOPER_NULL;
    tefopVersao: Result := PWOPER_VERSION;
    tefopFechamento: Result := PWOPER_SETTLEMNT;
    tefopCancelamento: Result := PWOPER_SALEVOID;
    tefopReimpressao:  Result := PWOPER_REPRINT;
    tefopPrePago: Result := PWOPER_PREPAID;
    tefopPreAutorizacao: Result := PWOPER_PREAUTH;
    tefopConsultaSaldo: Result := PWOPER_CRDBALINQ;
    tefopConsultaCheque: Result := PWOPER_CHECKINQ;
    tefopPagamentoConta: Result := PWOPER_BILLPAYMENT;
    tefopRelatResumido: Result := PWOPER_RPTSUMMARY;
    tefopRelatSintetico: Result := PWOPER_RPTTRUNC;
    tefopRelatDetalhado: Result := PWOPER_RPTDETAIL;
  else
    Result := PWOPER_ADMIN;
  end;
end;

{ TACBrTEFRespPayGoWeb }

procedure TACBrTEFRespPayGoWeb.ConteudoToProperty;
begin
  ConteudoToPropertyPayGoWeb( Self );
end;

end.

