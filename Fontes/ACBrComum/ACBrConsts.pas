{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Jo�o Carvalho - SIGData Solu��es em TI          }
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

unit ACBrConsts;

interface

Uses
  {$IFNDEF COMPILER6_UP}
    ACBrD5,
  {$ENDIF}
   SysUtils;

// delphi XE3 em diante n�o possui mais essas var, ent�o criar e preencher
{$IFDEF DELPHI15_UP}
var
  fmtst: TFormatSettings;
  CurrencyString: string;
  CurrencyFormat: Byte;
  NegCurrFormat: Byte;
  ThousandSeparator: Char;
  DecimalSeparator: Char;
  CurrencyDecimals: Byte;
  DateSeparator: Char;
  ShortDateFormat: string;
  LongDateFormat: string;
  TimeSeparator: Char;
  TimeAMString: string;
  TimePMString: string;
  ShortTimeFormat: string;
  LongTimeFormat: string;
  TwoDigitYearCenturyWindow: Word = 50;
  ListSeparator: Char;
{$ENDIF}

const
  {* Unit ACBrBase *}
  ACBR_VERSAO = '0.9.0a';
  NUL = #00 ;
  SOH = #01 ;
  STX = #02 ;
  ETX = #03 ;
  EOT = #04 ;
  ENQ = #05 ;
  ACK = #06 ;
  BELL= #07 ;
  BS  = #08 ;
  TAB = #09 ;
  LF  = #10 ;
  FF  = #12 ;
  CR  = #13 ;
  SO  = #14 ;
  SI  = #15 ;
  DLE = #16 ;
  WAK = #17 ;
  DC2 = #18 ;
  DC3 = #19 ;
  DC4 = #20 ;
  NAK = #21 ;
  SYN = #22 ;
  ESC = #27 ;
  FS  = #28 ;
  GS  = #29 ;
  CTRL_Z = #26 ;
  CRLF = CR + LF ;

  CUTF8CodPage = 65001;
  CUTF8BOM = #239+#187+#191;
  CUTF8DeclaracaoXML = '<?xml version="1.0" encoding="UTF-8"?>';

  cTimeout = 3 ;  { Tempo PADRAO para msg de falha de comunicacao }
  CDotsMM = 8;  // 203dpi


  const cMesDescricao : array[1..12] of string =
        ('Janeiro','Fevereiro','Mar�o','Abril','Maio','Junho','Julho','Agosto',
         'Setembro','Outubro','Novembro','Dezembro') ;

  cTagLigaExpandido         = '<e>';
  cTagDesligaExpandido      = '</e>';
  cTagLigaAlturaDupla       = '<a>';
  cTagDesligaAlturaDupla    = '</a>';
  cTagLigaNegrito           = '<n>';
  cTagDesligaNegrito        = '</n>';
  cTagLigaSublinhado        = '<s>';
  cTagDesligaSublinhado     = '</s>';
  cTagLigaCondensado        = '<c>';
  cTagDesligaCondensado     = '</c>';
  cTagLigaItalico           = '<i>';
  cTagDesligaItalico        = '</i>';
  cTagLigaInvertido         = '<in>';
  cTagDesligaInvertido      = '</in>';
  cTagFonteNormal           = '</fn>';
  cTagFonteA                = '</fa>';
  cTagFonteB                = '</fb>';
  cTagFonteAlinhadaDireita  = '</ad>';
  cTagFonteAlinhadaEsquerda = '</ae>';
  cTagfonteAlinhadaCentro   = '</ce>';

  cTAGS_CARACTER: array[0..12] of String = (
    cTagLigaExpandido, cTagDesligaExpandido,
    cTagLigaAlturaDupla, cTagDesligaAlturaDupla,
    cTagLigaNegrito, cTagDesligaNegrito,
    cTagLigaSublinhado, cTagDesligaSublinhado,
    cTagLigaCondensado, cTagDesligaCondensado,
    cTagLigaItalico, cTagDesligaItalico,
    cTagFonteNormal);
  cTAGS_CARACTER_HELP: array[0..12] of String = (
    'Liga Expandido', 'Desliga Expandido',
    'Liga Altura Dupla', 'Desliga Altura Dupla',
    'Liga Negrito', 'Desliga Negrito',
    'Liga Sublinhado', 'Desliga Sublinhado',
    'Liga Condensado', 'Desliga Condensado',
    'Liga Italico', 'Desliga Italico',
    'Fonte Normal');

  cTagLinhaSimples = '</linha_simples>';
  cTagLinhaDupla   = '</linha_dupla>';
  cTagPuloDeLinhas = '</pular_linhas>';

  cTAGS_LINHAS: array[0..2] of String = (
    cTagLinhaSimples, cTagLinhaDupla, cTagPuloDeLinhas);
  cTAGS_LINHAS_HELP: array[0..2] of String = (
    'Imprime Linha Simples', 'Imprime Linha Dupla',
    'Pula N Linhas de acordo com propriedade do componente');

  cTagLogotipo = '</logo>';
  cTagLogoImprimir = '<logo_imprimir>';
  cTagLogoKC1 = '<logo_kc1>';
  cTagLogoKC2 = '<logo_kc2>';
  cTagLogoFatorX = '<logo_fatorx>';
  cTagLogoFatorY = '<logo_fatory>';

  cTagCorte = '</corte>';
  cTagCorteParcial = '</corte_parcial>';
  cTagCorteTotal = '</corte_total>';
  cTagAbreGaveta = '</abre_gaveta>';
  cTagAbreGavetaEsp = '<abre_gaveta>';
  cTagBeep = '</beep>';
  cTagZera = '</zera>';
  cTagReset = '</reset>';
  cTagPulodeLinha = '</lf>';
  cTagPulodePagina = '</ff>';
  cTagRetornoDeCarro = '</cr>';

  cTAGS_FUNCOES: array[0..9] of String = (
    cTagLogotipo,
    cTagCorte, cTagCorteParcial, cTagCorteTotal,
    cTagAbreGaveta,
    cTagBeep, CTagZera, cTagPulodeLinha, cTagRetornoDeCarro, cTagReset);
  cTAGS_FUNCOES_HELP: array[0..9] of String = (
    'Imprime Logotipo j� gravado na Impressora (use utilit�rio do fabricante)',
    'Efetua Corte, conforme configura��o de "TipoCorte"',
    'Efetua Corte Parcial no Papel (n�o disponivel em alguns modelos)',
    'Efetua Corte Total no papel',
    'Aciona a abertura da Gaveta de Dinheiro',
    'Emite um Beep na Impressora (n�o disponivel em alguns modelos)',
    'Reseta as configura��es de Fonte Alinhamento.<LF>Ajusta P�gina de C�digo e Espa�o entre Linhas',
    'Pula para a pr�pxima linha',
    'Retorna para o Inicio da Linha',
    'Reseta as configura��es de Fonte Alinhamento');

  cTagAlinhadoDireita = '<ad>';
  cTagAlinhadoEsquerda = '<ae>';
  cTagAlinhadoCentro = '<ce>';

  cTAGS_ALINHAMENTO: array[0..2] of String = (
    cTagAlinhadoDireita, cTagAlinhadoEsquerda, cTagAlinhadoCentro );
  cTAGS_ALINHAMENTO_HELP: array[0..2] of String = (
    'Texto Alinhado a Direita',
    'Texto Alinhado a Esquerda',
    'Texto Centralizado' );

  cTagBarraEAN8 = '<ean8>';
  cTagBarraEAN13 = '<ean13>';
  cTagBarraStd = '<std>';
  cTagBarraInter = '<inter>';
  cTagBarraCode11 = '<code11>';
  cTagBarraCode39 = '<code39>';
  cTagBarraCode93 = '<code93>';
  cTagBarraCode128 = '<code128>';
  cTagBarraCode128a = '<code128a>';
  cTagBarraCode128b = '<code128b>';
  cTagBarraCode128c = '<code128c>';
  cTagBarraUPCA = '<upca>';
  cTagBarraUPCE = '<upce>';
  cTagBarraCodaBar = '<codabar>';
  cTagBarraMSI = '<msi>';
  cTagBarraMostrar = '<barra_mostrar>';
  cTagBarraLargura = '<barra_largura>';
  cTagBarraAltura = '<barra_altura>';

  cTagQRCode = '<qrcode>';
  cTagQRCodeTipo = '<qrcode_tipo>';
  cTagQRCodeLargura = '<qrcode_largura>';
  cTagQRCodeError = '<qrcode_error>';

  cTagBMP = '<bmp>';

  cTagModoPaginaLiga       = '<mp>';
  cTagModoPaginaDesliga    = '</mp>';
  cTagModoPaginaImprimir   = '</mp_imprimir>';
  cTagModoPaginaDirecao    = '<mp_direcao>';
  cTagModoPaginaPosEsquerda= '<mp_esquerda>';
  cTagModoPaginaPosTopo    = '<mp_topo>';
  cTagModoPaginaLargura    = '<mp_largura>';
  cTagModoPaginaAltura     = '<mp_altura>';
  cTagModoPaginaEspaco     = '<mp_espaco>';
  cTagModoPaginaConfigurar = '</mp_configurar>';
  cTagModoPaginaPosiciona  = '<mp_pos>';

  cTAGS_BARRAS: array[0..15] of String = (
    cTagBarraEAN8, cTagBarraEAN13, cTagBarraStd, cTagBarraInter, cTagBarraCode11,
    cTagBarraCode39, cTagBarraCode93, cTagBarraCode128, 
	cTagBarraUPCA, cTagBarraUPCE,
    cTagBarraCodaBar, cTagBarraMSI,
    cTagBarraCode128a, cTagBarraCode128b, cTagBarraCode128c, cTagQRCode);
  cTAGS_BARRAS_HELP: array[0..15] of String = (
    'Cod.Barras EAN8 - 7 numeros e 1 dig.verificador',
    'Cod.Barras EAN13 - 12 numeros e 1 dig.verificador',
    'Cod.Barras "Standard 2 of 5" - apenas n�meros, tamanho livre',
    'Cod.Barras "Interleaved 2 of 5" - apenas n�meros, tamanho PAR',
    'Cod.Barras Code11 - apenas n�meros, tamanho livre',
    'Cod.Barras Code39 - Aceita: 0..9,A..Z, ,$,%,*,+,-,.,/, tamanho livre',
    'Cod.Barras Code93 - Aceita: 0..9,A..Z,-,., ,$,/,+,%, tamanho livre',
    'Cod.Barras Code128 - Todos os caracteres ASCII, tamanho livre',
    'Cod.Barras UPCA - 11 numeros e 1 dig.verificador',
    'Cod.Barras UPCE - 11 numeros e 1 dig.verificador',
    'Cod.Barras CodaBar - Aceita: 0..9,A..D,a..d,$,+,-,.,/,:, tamanho livre',
    'Cod.Barra MSI - Apenas n�meros, 1 d�gito verificador',
    'Cod.Barras Code128 - Subtipo A',
    'Cod.Barras Code128 - Subtipo B (padr�o) = '+cTagBarraCode128,
    'Cod.Barras Code128 - Subtipo C (informar valores em BCD)',
    'Cod.Barras QrCode'
    );

  cTagIgnorarTags = '<ignorar_tags>';

  cACBrDeviceAtivarPortaException    = 'Porta n�o definida' ;
  cACBrDeviceAtivarException         = 'Erro abrindo: %s ' + sLineBreak +' %s ' ;
  cACBrDeviceAtivarPortaNaoEncontrada= 'Porta %s n�o encontrada' ;
  cACBrDeviceAtivarPortaNaoAcessivel = 'Porta %s n�o acess�vel' ;
  cACBrDeviceSetBaudException        = 'Valor deve estar na faixa de 50 a 4000000.'+#10+
                                       'Normalmente os equipamentos Seriais utilizam: 9600' ;
  cACBrDeviceSetDataException        = 'Valor deve estar na faixa de 5 a 8.'+#10+
                                       'Normalmente os equipamentos Seriais utilizam: 7 ou 8' ;
  cACBrDeviceSetPortaException       = 'N�o � poss�vel mudar a Porta com o Dispositivo Ativo' ;
  cACBrDeviceSetTypeException        = 'Tipo de dispositivo informado n�o condiz com o valor da Porta';
  cACBrDeviceSemImpressoraPadrao     = 'Erro Nenhuma impressora Padr�o foi detectada';
  cACBrDeviceImpressoraNaoEncontrada = 'Impressora n�o encontrada [%s]';
  cACBrDeviceEnviaStrThreadException = 'Erro gravando em: %s ' ;
  cACBrDeviceEnviaStrFailCount       = 'Erro ao enviar dados para a porta: %s';

  { constantes para exibi��o na inicializa��o e no sobre do delphi a partir da vers�o 2009 }
  cACBrSobreDialogoTitulo = 'Projeto ACBr';
  cACBrSobreTitulo = 'Projeto ACBr VCL';
  cACBrSobreDescricao = 'ACBr VCL http://www.projetoacbr.com.br/' + #13#10 +
                        'Componentes para Automa��o Comercial' + #13#10 +                        
                        'Lesser General Public License version 2.0';					
  cACBrSobreLicencaStatus = 'LGPLv2';
  
  {****                                  *}
  
  {* Unit ACBrECFClass *}
  cACBrTempoInicioMsg                  = 3 ;  { Tempo para iniciar a exibi�ao da mensagem Aguardando a Resposta da Impressora' }
  cACBrMsgAguardando                   = 'Aguardando a resposta da Impressora: %d segundos' ;
  cACBrMsgTrabalhando                  = 'Impressora est� trabalhando' ;
  cACBrMsgPoucoPapel                   = 30 ; {Exibe alerta de Pouco Papel somente a cada 30 segundos}
  cACBrMsgRelatorio                    = 'Imprimindo %s  %d� Via ' ;
  cACBrPausaRelatorio                  = 5 ;
  cACBrMsgPausaRelatorio               = 'Destaque a %d� via, <ENTER> proxima, %d seg.';
  cACBrLinhasEntreCupons               = 7 ;
  cACBrMaxLinhasBuffer                 = 0 ;
  cACBrIntervaloAposComando            = 100 ; { Tempo em milisegundos a esperar apos o termino de EnviaComando }
  cACBrECFAliquotaSetTipoException     = 'Valores v�lidos para TACBrECFAliquota.Tipo: "T" - ICMS ou "S" - ISS' ;
  cACBrECFConsumidorCPFCNPJException   = 'CPF/CNPJ N�o informado' ;
  cACBrECFConsumidorNomeException      = 'Para informar o Endere�o � necess�rio informar o Nome' ;
  cACBrECFClassCreateException         = 'Essa Classe deve ser instanciada por TACBrECF' ;
  cACBrECFNaoInicializadoException     = 'Componente ACBrECF n�o est� Ativo' ;
  cACBrECFOcupadoException             = 'Componente ACBrECF ocupado' + sLineBreak +
                                         'Aguardando resposta do comando anterior' ;
  cACBrECFSemRespostaException         = 'Impressora %s n�o est� respondendo' ;
  cACBrECFSemPapelException            = 'FIM DE PAPEL' ;
  cACBrECFCmdSemRespostaException      = 'Comandos n�o est�o sendo enviados para Impressora %s ' ;
  cACBrECFEnviaCmdSemRespostaException = 'Erro ao enviar comandos para a Impressora %s ' ;
  cACBrECFDoOnMsgSemRespostaRetentar   = 'A impressora %s n�o est� repondendo.' ;
  cACBrECFVerificaFimLeituraException  = 'Erro Function VerificaFimLeitura n�o implementada em %s ' ;
  cACBrECFVerificaEmLinhaMsgRetentar   = 'A impressora %s n�o est� pronta.' ;
  cACBrECFVerificaEmLinhaException     = 'Impressora %s n�o est� em linha' ;
  cACBrECFPodeAbrirCupomRequerX        = 'A impressora %s requer Leitura X todo inicio de dia.'+#10+
                                         ' Imprima uma Leitura X para poder vender' ;
  cACBrECFPodeAbrirCupomRequerZ        = 'Redu��o Z de dia anterior n�o emitida.'+#10+
                                         ' Imprima uma Redu��o Z para poder vender' ;
  cACBrECFPodeAbrirCupomBloqueada      = 'Redu�ao Z de hoje j� emitida, ECF bloqueado at� as 00:00' ;
  cACBrECFPodeAbrirCupomCFAberto       = 'Cupom Fiscal aberto' ;
  cACBrECFPodeAbrirCupomNaoAtivada     = 'Impressora nao foi Inicializada (Ativo = false)' ;
  cACBrECFPodeAbrirCupomEstado         = 'Estado da impressora %s  � '+sLineBreak+' %s (n�o � Livre) ' ;
  cACBrECFAbreGavetaException          = 'A Impressora %s n�o manipula Gavetas' ;
  cACBrECFImpactoAgulhasException      = 'A Impressora %s n�o permite ajustar o Impacto das Agulhas' ;
  cACBrECFImprimeChequeException       = 'Rotina de Impress�o de Cheques n�o implementada para '+
                                         'Impressora %s ';
  cACBrECFLeituraCMC7Exception         = 'Rotina de Leitura de CMC7 de Cheques n�o implementada para '+
                                         'Impressora %s ';
  cACBrECFAchaCNFException             = 'N�o existe nenhum Comprovante N�o Fiscal '+
                                         'cadastrado como: "%s" ' ;
  cACBrECFAchaFPGException             = 'N�o existe nenhuma Forma de Pagamento '+
                                         'cadastrada como: "%s" ' ;
  cACBrECFCMDInvalidoException         = 'Procedure: %s '+ sLineBreak +
                                         ' n�o implementada para a Impressora: %s'+sLineBreak + sLineBreak +
                                         'Ajude no desenvolvimento do ACBrECF. '+ sLineBreak+
                                         'Acesse nosso Forum em: http://acbr.sf.net/' ;
  cACBrECFDoOnMsgPoucoPapel            = 'Detectado pouco papel' ;
  cACBrECFDoOnMsgRetentar              = 'Deseja tentar novamente ?' ;
  cACBrECFAchaICMSAliquotaInvalida     = 'Aliquota inv�lida: ' ;
  cACBrECFAchaICMSCMDInvalido          = 'Aliquota n�o encontrada: ' ;
  cACBrECFAbrindoRelatorioGerencial    = 'Abrindo Relat�rio Gerencial, aguarde %d seg' ;
  cACBrECFFechandoRelatorioGerencial   = 'Fechando Relat�rio Gerencial' ;
  cACBrECFFormMsgDoProcedureException  = 'Erro. Chamada recurssiva de FormMsgDoProcedure' ;


  {* Unit ACBrECF *}
  cACBrECFSetModeloException             = 'N�o � poss�vel mudar o Modelo com o ECF Ativo' ;
  cACBrECFModeloNaoDefinidoException     = 'Modelo n�o definido' ;
  cACBrECFModeloBuscaPortaException      = 'Modelo: %s n�o consegue efetuar busca autom�tica de Porta'+sLineBreak+
                                           'Favor definir a Porta Ex: (COM1, LPT1, /dev/lp0, etc)' ;
  cACBrECFMsgDoAcharPorta                = 'Procurando por ECF: %s na porta: %s ' ;
  cACBrECFSetDecimaisPrecoException      = 'Valor de DecimaisPreco deve estar entre 0-3' ;
  cACBrECFSetDecimaisQtdException        = 'Valor de DecimaisQtd deve estar entre 0-4' ;
  cACBrECFVendeItemQtdeException         = 'Quantidade deve ser superior a 0.' ;
  cACBrECFVendeItemValorUnitException    = 'Valor Unitario deve ser superior a 0.' ;
  cACBrECFVendeItemValDescAcreException  = 'ValorDescontoAcrescimo deve ser positivo' ;
  cACBrECFVendeItemDescAcreException     = 'DescontoAcrescimo deve ser "A"-Acrescimo, ou "D"-Desconto' ;
  cACBrECFVendeItemTipoDescAcreException = 'TipoDescontoAcrescimo deve ser "%"-Porcentagem, ou "$"-Valor' ;
  cACBrECFVendeItemAliqICMSException     = 'Aliquota de ICMS n�o pode ser vazia.' ;
  cACBrECFAchaFPGIndiceException         = 'Forma de Pagamento: %s inv�lida' ;
  cACBrECFFPGPermiteVinculadoException   = 'Forma de Pagamento: %s '+#10+
                                           'n�o permite Cupom Vinculado' ;
  cACBrECFPAFFuncaoNaoSuportada          = 'Fun��o n�o suportada pelo modelo de ECF utilizado';
  cACBrECFRegistraItemNaoFiscalException = 'Comprovante n�o fiscal: %s inv�lido' ;
  cACBrECFSetRFDException                = 'N�o � poss�vel mudar ACBrECF.RFD com o componente ativo' ;
  cACBrECFSetAACException                = 'N�o � poss�vel mudar ACBrECF.AAC com o componente ativo' ;
  cACBrECFVirtualClassCreateException    = 'Essa Classe deve ser instanciada por TACBrECFVirtual' ;
  cACBrECFSetECFVirtualException         = 'N�o � poss�vel mudar ACBrECF.ECFVirtual com o componente ativo' ;
  cACBrECFSemECFVirtualException         = 'ACBrECF.ECFVirtual n�o foi atribuido' ;

  cACBrAACNumSerieNaoEncontardoException = 'ECF de N�mero de s�rie %s n�o encontrado no Arquivo Auxiliar Criptografado.' ;
  cACBrAACValorGTInvalidoException       = 'Diverg�ncia no Valor do Grande Total.';

  cACBrDFeSSLEnviarException = 'Erro Interno: %d'+sLineBreak+'Erro HTTP: %d'+sLineBreak+
                               'URL: %s';
  cACBrArquivoNaoEncontrado = 'Arquivo: %s n�o encontrado';

  sDisplayFormat = ',#0.%.*d';

implementation

initialization
  // delphi XE3 em diante n�o possui mais essas var, ent�o criar e preencher
  {$IFDEF DELPHI15_UP}
    fmtst := TFormatSettings.Create('');
    CurrencyString := fmtst.CurrencyString;
    CurrencyFormat := fmtst.CurrencyFormat;
    NegCurrFormat := fmtst.NegCurrFormat;
    ThousandSeparator := fmtst.ThousandSeparator;
    DecimalSeparator := fmtst.DecimalSeparator;
    CurrencyDecimals := fmtst.CurrencyDecimals;
    DateSeparator := fmtst.DateSeparator;
    ShortDateFormat := fmtst.ShortDateFormat;
    LongDateFormat := fmtst.LongDateFormat;
    TimeSeparator := fmtst.TimeSeparator;
    TimeAMString := fmtst.TimeAMString;
    TimePMString := fmtst.TimePMString;
    ShortTimeFormat := fmtst.ShortTimeFormat;
    LongTimeFormat := fmtst.LongTimeFormat;
    TwoDigitYearCenturyWindow := fmtst.TwoDigitYearCenturyWindow;
    ListSeparator := fmtst.ListSeparator;
  {$ENDIF}

end.
