{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
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
//incluido em 23/04/2023
{$I ACBr.inc}

unit ACBrBancoSofisaItau;

interface

uses
  Classes,
  SysUtils,
  StrUtils,
  ACBrBoleto,
  ACBrUtil.Strings, 
  ACBrUtil.DateTime, 
  ACBrValidador,
  ACBrBoletoConversao,
  {$ifdef COMPILER6_UP} DateUtils {$else} ACBrD5 {$endif},  
  ACBrUtil.Base,
  ACBrBancoItau;

type

  { TACBrBancoSofisaItau }

  TACBrBancoSofisaItau = class(TACBrBancoItau)
  private

  protected
  public
    Constructor create(AOwner: TACBrBanco);
    Procedure LerRetorno400 ( ARetorno: TStringList ); override;
    function CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia;override;
    function TipoOcorrenciaToDescricao( const TipoOcorrencia: TACBrTipoOcorrencia): String;override;
    function GerarRegistroHeader240(NumeroRemessa: Integer): String; override;
    procedure GerarRegistroHeader400( NumeroRemessa: Integer; aRemessa: TStringList); override;
    function CodMotivoRejeicaoToDescricaoSofisa(const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: String): String;
    procedure GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList);override;
  end;

implementation

{ TACBrBancoSofisaItau }

constructor TACBrBancoSofisaItau.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpNome                   := 'BANCO SOFISA SA';
   fpNumeroCorrespondente   := 637;
end;

function TACBrBancoSofisaItau.GerarRegistroHeader240(NumeroRemessa: Integer): String;
begin
  raise Exception.Create( ACBrStr('N�o permitido para o layout deste banco.') );
end;


procedure TACBrBancoSofisaItau.GerarRegistroHeader400( NumeroRemessa: Integer; aRemessa: TStringList);
var
  wLinha: String;
begin
   with ACBrBanco.ACBrBoleto.Cedente do
   begin
      wLinha:= '0'                                        + // 001-001 ID do Registro
               '1'                                        + // 002-002 ID do Arquivo( 1 - Remessa)
               'REMESSA'                                  + // 003-009 Literal de Remessa
               '01'                                       + // 010-011 C�digo do Tipo de Servi�o
               PadRight( 'COBRANCA', 15 )                 + // 012-026 Descri��o do tipo de servi�o
               PadRight( CodigoTransmissao, 20)           + // 027-046 Codigo da Empresa no Banco
               PadRight( Nome, 30)                        + // 047-076 Nome da Empresa
               '637'                                      + // 077-079 C�digo
               PadRight('BANCO SOFISA SA', 15)            + // 080-094 Nome do Banco
               FormatDateTime('ddmmyy',Now)               + // 095-100 Data de gera��o do arquivo
               Space(294)                                 + // 101-394 Brancos
               IntToStrZero(1,6);                           // 395-400 Nr. Sequencial de Remessa

      aRemessa.Text:= aRemessa.Text + UpperCase(wLinha);
   end;
end;

procedure TACBrBancoSofisaItau.LerRetorno400(ARetorno: TStringList);
var LCodBanco : Integer;
begin
  try
    LCodBanco := fpNumero;
    fpNumero  := fpNumeroCorrespondente;
    LCodBanco := StrToIntDef(copy(ARetorno.Strings[0],77,3),-1);
    if (LCodBanco <> Numero) and (LCodBanco <> fpNumeroCorrespondente) then
      raise Exception.Create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
                                     'n�o � um arquivo de retorno do '+ Nome));

    ACBrBanco.ACBrBoleto.Cedente.CodigoCedente := Trim(Copy(ARetorno[1],18,20));
    inherited;
  finally
    fpNumero := LCodBanco;
  end;

end;
function TACBrBancoSofisaItau.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
 CodOcorrencia: Integer;
begin
  Result := '';
  CodOcorrencia := StrToIntDef(TipoOcorrenciaToCod(TipoOcorrencia),0);

  case CodOcorrencia of
    01: Result := '01-Confirma Entrada T�tulo na CIP';
    02: Result := '02-Entrada Confirmada';
    03: Result := '03-Entrada Rejeitada';
    05: Result := '05-Campo Livre Alterado';
    06: Result := '06-Liquida��o Normal';
    08: Result := '08-Liquida��o em Cart�rio';
    09: Result := '09-Baixa Autom�tica';
    10: Result := '10-Baixa por ter sido liquidado';
    12: Result := '12-Confirma Abatimento';
    13: Result := '13-Abatimento Cancelado';
    14: Result := '14-Vencimento Alterado';
    15: Result := '15-Baixa Rejeitada';
    16: Result := '16-Instru��o Rejeitada';
    19: Result := '19-Confirma Recebimento de Ordem de Protesto';
    20: Result := '20-Confirma Recebimento de Ordem de Susta��o';
    22: Result := '22-Seu n�mero alterado';
    23: Result := '23-T�tulo enviado para cart�rio';
    24: Result := '24-Confirma recebimento de ordem de n�o protestar';
    28: Result := '28-D�bito de Tarifas/Custas � Correspondentes';
    40: Result := '40-Tarifa de Entrada (debitada na Liquida��o)';
    43: Result := '43-Baixado por ter sido protestado';
    96: Result := '96-Tarifa Sobre Instru��es � M�s anterior';
    97: Result := '97-Tarifa Sobre Baixas � M�s Anterior';
    98: Result := '98-Tarifa Sobre Entradas � M�s Anterior';
    99: Result := '99-Tarifa Sobre Instru��es de Protesto/Susta��o � M�s Anterior';
  end;
  Result := ACBrSTr(Result);
end;

function TACBrBancoSofisaItau.CodOcorrenciaToTipo(const CodOcorrencia:Integer ) : TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    01: Result := toRetornoEntradaConfirmadaNaCip;
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    05: Result := toRetornoDadosAlterados;
    06: Result := toRetornoLiquidado;
    08: Result := toRetornoLiquidadoEmCartorio;
    09: Result := toRetornoBaixaAutomatica;
    10: Result := toRetornoBaixaPorTerSidoLiquidado;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    15: Result := toRetornoBaixaRejeitada;
    16: Result := toRetornoInstrucaoRejeitada;
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    22: Result := toRetornoDadosAlterados;
    23: Result := toRetornoEncaminhadoACartorio;
    24: Result := toRetornoRecebimentoInstrucaoNaoProtestar;
    28: Result := toRetornoDebitoTarifas;
    40: Result := toRetornoTarifaDeRelacaoDasLiquidacoes;
    43: Result := toRetornoBaixaPorProtesto;
    96: Result := toRetornoDebitoMensalTarifasOutrasInstrucoes;
    97: Result := toRetornoTarifaMensalBaixasCarteira;
    98: Result := toRetornoTarifaMensalRefEntradasBancosCorrespCarteira;
    99: Result := toRetornoDebitoMensalTarifasSustacaoProtestos;
  else
    Result := toRetornoOutrasOcorrencias;
  end;
end;

function TACBrBancoSofisaItau.CodMotivoRejeicaoToDescricaoSofisa( const TipoOcorrencia:TACBrTipoOcorrencia; CodMotivo: String) : String;
begin
   case TipoOcorrencia of
    toRetornoComandoRecusado, toRetornoRegistroRecusado: //03 (Entrada rejeitada)
      begin
         if CodMotivo = '03' then
            Result:='CEP inv�lido � N�o temos cobrador � Cobrador n�o Localizado'
         else if CodMotivo = '04' then
            Result:='Sigla do Estado inv�lida'
         else if CodMotivo = '05' then
            Result:='Data de Vencimento inv�lida ou fora do prazo m�nimo'
         else if CodMotivo = '06' then
            Result:='C�digo do Banco inv�lido'
         else if CodMotivo = '08' then
            Result:='Nome do sacado n�o informado'
         else if CodMotivo = '10' then
            Result:='Logradouro n�o informado'
         else if CodMotivo = '14' then
            Result:='Registro em duplicidade'
         else if CodMotivo = '19' then
            Result:='Data de desconto inv�lida ou maior que a data de vencimento'
         else if CodMotivo = '20' then
            Result:='Valor de IOF n�o num�rico'
         else if CodMotivo = '21' then
            Result:='Movimento para t�tulo n�o cadastrado no sistema'
         else if CodMotivo = '22' then
            Result:='Valor de desconto + abatimento maior que o valor do t�tulo'
         else if CodMotivo = '25' then
            Result:='CNPJ ou CPF do sacado inv�lido (aceito com restri��es)'
         else if CodMotivo = '26' then
            Result:='Esp�cie de documento inv�lida'
         else if CodMotivo = '27' then
            Result:='Data de emiss�o do t�tulo inv�lida'
         else if CodMotivo = '28' then
            Result:='Seu n�mero n�o informado'
         else if CodMotivo = '29' then
            Result:='CEP � igual a espa�o ou zeros ou n�o num�rico'
         else if CodMotivo = '30' then
            Result:='Valor do t�tulo n�o num�rico ou inv�lido'
         else if CodMotivo = '36' then
            Result:='Valor de perman�ncia (mora) n�o num�rico'
         else if CodMotivo = '37' then
            Result:='Valor de perman�ncia inconsistente, pois, dentro de um m�s, ser� maior que o valor do t�tulo'
         else if CodMotivo = '38' then
            Result:='Valor de desconto/abatimento n�o num�rico ou inv�lido'
         else if CodMotivo = '39' then
            Result:='Valor de abatimento n�o num�rico'
         else if CodMotivo = '42' then
            Result:='T�tulo j� existente em nossos registros. Nosso n�mero n�o aceito'
         else if CodMotivo = '43' then
            Result:='T�tulo enviado em duplicidade nesse movimento'
         else if CodMotivo = '44' then
            Result:='T�tulo zerado ou em branco ou n�o num�rico na remessa'
         else if CodMotivo = '46' then
            Result:='T�tulo enviado fora da faixa de Nosso N�mero, estipulada para o cliente.'
         else if CodMotivo = '51' then
            Result:='Tipo/N�mero de Inscri��o Sacador/Avalista Inv�lido'
         else if CodMotivo = '52' then
            Result:='Sacador/Avalista n�o informado'
         else if CodMotivo = '53' then
            Result:='Prazo de vencimento do t�tulo excede ao da contrata��o'
         else if CodMotivo = '54' then
            Result:='Banco informado n�o � nosso correspondente 140-142'
         else if CodMotivo = '55' then
            Result:='Banco correspondente informado n�o cobra este CEP ou n�o possui faixas de CEP cadastradas'
         else if CodMotivo = '56' then
            Result:='Nosso n�mero no correspondente n�o foi informado'
         else if CodMotivo = '57' then
            Result:='Remessa contendo duas instru��es incompat�veis � n�o protestar e dias de protesto ou prazo para protesto inv�lido.'
         else if CodMotivo = '58' then
            Result:='Entradas Rejeitadas � Reprovado no Represamento para An�lise'
         else if CodMotivo = '60' then
            Result:='CNPJ/CPF do sacado inv�lido � t�tulo recusado'
         else if CodMotivo = '87' then
            Result:='Excede Prazo m�ximo entre emiss�o e vencimento'
         else if CodMotivo = 'AA' then
            Result:='Servi�o de cobran�a inv�lido'
         else if CodMotivo = 'AB' then
            Result:='Servi�o de "0" ou "5" e banco cobrador <> zeros'
         else if CodMotivo = 'AE' then
            Result:='T�tulo n�o possui abatimento'
         else if CodMotivo = 'AG' then
            Result:='Movto n�o permitido para t�tulo � Vista/Contra Apresenta��o'
         else if CodMotivo = 'AH' then
            Result:='Cancelamento de Valores Inv�lidos'
         else if CodMotivo = 'AI' then
            Result:='Nossa carteira inv�lida'
         else if CodMotivo = 'AJ' then
            Result:='Modalidade com bancos correspondentes inv�lida'
         else if CodMotivo = 'AK' then
            Result:='T�tulo pertence a outro cliente'
         else if CodMotivo = 'AL' then
            Result:='Sacado impedido de entrar nesta cobran�a'
         else if CodMotivo = 'AT' then
            Result:='Valor Pago Inv�lido'
         else if CodMotivo = 'AU' then
            Result:='Data da ocorr�ncia inv�lida'
         else if CodMotivo = 'AV' then
            Result:='Valor da tarifa de cobran�a inv�lida'
         else if CodMotivo = 'AX' then
            Result:='T�tulo em pagamento parcial'
         else if CodMotivo = 'AY' then
            Result:='T�tulo em Aberto e Vencido para acatar protestol'
         else if CodMotivo = 'BA' then
            Result:='Banco Correspondente Recebedor n�o � o Cobrador Atual'
         else if CodMotivo = 'BB' then
            Result:='T�tulo deve estar em cart�rio para baixar'
         else if CodMotivo = 'BC' then
            Result:='An�lise gerencial-sacado inv�lido p/opera��o cr�dito'
         else if CodMotivo = 'BD' then
            Result:='An�lise gerencial-sacado inadimplente'
         else if CodMotivo = 'BE' then
            Result:='An�lise gerencial-sacado difere do exigido'
         else if CodMotivo = 'BF' then
            Result:='An�lise gerencial-vencto excede vencto da opera��o de cr�dito'
         else if CodMotivo = 'BG' then
            Result:='An�lise gerencial-sacado com baixa liquidez'
         else if CodMotivo = 'BH' then
            Result:='An�lise gerencial-sacado excede concentra��o'
         else if CodMotivo = 'CC' then
            Result:='Valor de iof incompat�vel com a esp�cie documento'
         else if CodMotivo = 'CD' then
            Result:='Efetiva��o de protesto sem agenda v�lida'
         else if CodMotivo = 'CE' then
            Result:='T�tulo n�o aceito - pessoa f�sica'
         else if CodMotivo = 'CF' then
            Result:='Excede prazo m�ximo da entrada ao vencimento'
         else if CodMotivo = 'CG' then
            Result:='T�tulo n�o aceito � por an�lise gerencial'
         else if CodMotivo = 'CH' then
            Result:='T�tulo em espera � em an�lise pelo banco'
         else if CodMotivo = 'CJ' then
            Result:='An�lise gerencial-vencto do titulo abaixo przcurto'
         else if CodMotivo = 'CK' then
            Result:='An�lise gerencial-vencto do titulo abaixo przlongo CS T�tulo rejeitado pela checagem de duplicatas'
         else if CodMotivo = 'DA' then
            Result:='An�lise gerencial � Entrada de T�tulo Descontado com limite cancelado'
         else if CodMotivo = 'DB' then
            Result:='An�lise gerencial � Entrada de T�tulo Descontado com limite vencido'
         else if CodMotivo = 'DC' then
            Result:='An�lise gerencial - cedente com limite cancelado'
         else if CodMotivo = 'DD' then
            Result:='An�lise gerencial � cedente � sacado e teve seu limite cancelado'
         else if CodMotivo = 'DE' then
            Result:='An�lise gerencial - apontamento no Serasa'
         else if CodMotivo = 'DG' then
            Result:='Endere�o sacador/avalista n�o informado'
         else if CodMotivo = 'DH' then
            Result:='Cep do sacador/avalista n�o informado'
         else if CodMotivo = 'DI' then
            Result:='Cidade do sacador/avalista n�o informado'
         else if CodMotivo = 'DJ' then
            Result:='Estado do sacador/avalista inv�lido ou n informado'
         else if CodMotivo = 'DM' then
            Result:='Cliente sem C�digo de Flash cadastrado no cobrador'
         else if CodMotivo = 'DN' then
            Result:='T�tulo Descontado com Prazo ZERO � Recusado'
         else if CodMotivo = 'DP' then
            Result:='Data de Refer�ncia menor que a Data de Emiss�o do T�tulo'
         else if CodMotivo = 'DT' then
            Result:='Nosso N�mero do Correspondente n�o deve ser informado'
         else if CodMotivo = 'EB' then
            Result:='HSBC n�o aceita endere�o de sacado com mais de 38 caracteres'
         else if CodMotivo = 'G1' then
            Result:='Endere�o do sacador incompleto ( lei 12.039)'
         else if CodMotivo = 'G2' then
            Result:='Sacador impedido de movimentar'
         else if CodMotivo = 'G3' then
            Result:='Concentra��o de cep n�o permitida'
         else if CodMotivo = 'G4' then
            Result:='Valor do t�tulo n�o permitido'
         else if CodMotivo = 'HA' then
            Result:='Servi�o e Modalidade Incompat�veis'
         else if CodMotivo = 'HB' then
            Result:='Inconsist�ncias entre Registros T�tulo e Sacador'
         else if CodMotivo = 'HC' then
            Result:='Ocorr�ncia n�o dispon�vel'
         else if CodMotivo = 'HD' then
            Result:='T�tulo com Aceite'
         else if CodMotivo = 'HF' then
            Result:='Baixa Liquidez do Sacado'
         else if CodMotivo = 'HG' then
            Result:='Sacado Informou que n�o paga Boletos'
         else if CodMotivo = 'HH' then
            Result:='Sacado n�o confirmou a Nota Fiscal'
         else if CodMotivo = 'HI' then
            Result:='Checagem Pr�via n�o Efetuada'
         else if CodMotivo = 'HJ' then
            Result:='Sacado desconhece compra e Nota Fiscal'
         else if CodMotivo = 'HK' then
            Result:='Compra e Nota Fiscal canceladas pelo sacado'
         else if CodMotivo = 'HL' then
            Result:='Concentra��o al�m do permitido pela �rea de Cr�dito'
         else if CodMotivo = 'HM' then
            Result:='Vencimento acima do permitido pelo �rea de Cr�dito'
         else if CodMotivo = 'HN' then
            Result:='Excede o prazo limite da opera��o'
         else if CodMotivo = 'IX' then
            Result:='T�tulo de Cart�o de Cr�dito n�o aceita instru��es'
         else if CodMotivo = 'JB' then
            Result:='T�tulo de Cart�o de Cr�dito inv�lido para o Produto'
         else if CodMotivo = 'JC' then
            Result:='Produto somente para Cart�o de Cr�dito'
         else if CodMotivo = 'JH' then
            Result:='CB Direta com opera��o de Desconto Autom�tico'
         else if CodMotivo = 'JI' then
            Result:='Esp�cie de Documento incompat�vel para produto de Cart�o de Cr�dito';
      end;
    toRetornoBaixaRejeitada:
      begin
         if CodMotivo = '05' then
            Result:='Solicita��o de baixa para t�tulo j� baixado ou liquidado'
         else if CodMotivo = '06' then
            Result:='Solicita��o de baixa para t�tulo n�o registrado no sistema'
         else if CodMotivo = '08' then
            Result:='Solicita��o de baixa para t�tulo em float';
      end;
    toRetornoInstrucaoRejeitada:
      begin
         if CodMotivo = '04' then
            Result:='Data de vencimento n�o num�rica ou inv�lida'
         else if CodMotivo = '05' then
            Result:='Data de Vencimento inv�lida ou fora do prazo m�nimo'
         else if CodMotivo = '14' then
            Result:='Registro em duplicidade'
         else if CodMotivo = '19' then
            Result:='Data de desconto inv�lida ou maior que a data de vencimento'
         else if CodMotivo = '20' then
            Result:='Campo livre n�o informado'
         else if CodMotivo = '21' then
            Result:='T�tulo n�o registrado no sistema'
         else if CodMotivo = '22' then
            Result:='T�tulo baixado ou liquidado'
         else if CodMotivo = '26' then
            Result:='Esp�cie de documento inv�lida'
         else if CodMotivo = '27' then
            Result:='Instru��o n�o aceita, por n�o ter sido emitida ordem de protesto ao cart�rio'
         else if CodMotivo = '28' then
            Result:='T�tulo tem instru��o de cart�rio ativa'
         else if CodMotivo = '29' then
            Result:='T�tulo n�o tem instru��o de carteira ativa'
         else if CodMotivo = '30' then
            Result:='Existe instru��o de n�o protestar, ativa para o t�tulo'
         else if CodMotivo = '36' then
            Result:='Valor de perman�ncia (mora) n�o num�rico'
         else if CodMotivo = '37' then
            Result:='T�tulo Descontado � Instru��o n�o permitida para a carteira'
         else if CodMotivo = '38' then
            Result:='Valor do abatimento n�o num�rico ou maior que a soma do valor do t�tulo + perman�ncia + multa'
         else if CodMotivo = '39' then
            Result:='T�tulo em cart�rio'
         else if CodMotivo = '40' then
            Result:='Instru��o recusada � Reprovado no Represamento para An�lise'
         else if CodMotivo = '44' then
            Result:='T�tulo zerado ou em branco ou n�o num�rico na remessa'
         else if CodMotivo = '51' then
            Result:='Tipo/N�mero de Inscri��o Sacador/Avalista Inv�lido'
         else if CodMotivo = '53' then
            Result:='Prazo de vencimento do t�tulo excede ao da contrata��o'
         else if CodMotivo = '57' then
            Result:='Remessa contendo duas instru��es incompat�veis � n�o protestar e dias de protesto ou prazo para protesto inv�lido.'
         else if CodMotivo = 'AA' then
            Result:='Servi�o de cobran�a inv�lido'
         else if CodMotivo = 'AE' then
            Result:='T�tulo n�o possui abatimento'
         else if CodMotivo = 'AG' then
            Result:='Movimento n�o permitido � T�tulo � vista ou contra apresenta��o'
         else if CodMotivo = 'AH' then
            Result:='Cancelamento de valores inv�lidos'
         else if CodMotivo = 'AI' then
            Result:='Nossa carteira inv�lida'
         else if CodMotivo = 'AK' then
            Result:='T�tulo pertence a outro cliente'
         else if CodMotivo = 'AU' then
            Result:='Data da ocorr�ncia inv�lida'
         else if CodMotivo = 'AY' then
            Result:='T�tulo deve estar em aberto e vencido para acatar protesto'
         else if CodMotivo = 'CB' then
            Result:='T�tulo possui protesto efetivado/a efetivar hoje'
         else if CodMotivo = 'CT' then
            Result:='T�tulo j� baixado'
         else if CodMotivo = 'CW' then
            Result:='T�tulo j� transferido'
         else if CodMotivo = 'DO' then
            Result:='T�tulo em Preju�zo'
         else if CodMotivo = 'JK' then
            Result:='Produto n�o permite altera��o de valor de t�tulo'
         else if CodMotivo = 'JQ' then
            Result:='T�tulo em Correspondente � N�o alterar Valor'
         else if CodMotivo = 'JS' then
            Result:='T�tulo possui Descontos/Abto/Mora/Multa'
         else if CodMotivo = 'JT' then
            Result:='T�tulo possui Agenda de Protesto/Devolu��o'
         else if CodMotivo = '99' then
            Result:='Ocorr�ncia desconhecida na remessa';
      end;
    else
      Result := CodMotivo + ' - Outros Motivos';
    end; //case TipoOcorrencia
end;

procedure TACBrBancoSofisaItau.GerarRegistroTransacao400(ACBrTitulo :TACBrTitulo; aRemessa: TStringList);
var
  Ocorrencia,aEspecie :String;
  Protesto, Multa, valorMulta, aAgencia, TipoSacado, wLinha, ChaveNFe :String;
  aCarteira, I, mensagemBranco, multiplicadorMulta: Integer;
begin

  aCarteira := StrToIntDef(ACBrTitulo.Carteira, 0 );

  if aCarteira = 109  then
    aCarteira := 4
  else
     raise Exception.Create( ACBrStr('Carteira n�o permitida, aceita por enquanto apenas carteira 109(C�digo 4).') );

   aAgencia:= '0000'{agencia} + '0'{Digito};

  with ACBrTitulo do
  begin
    {Pegando C�digo da Ocorrencia}
    case OcorrenciaOriginal.Tipo of
      toRemessaBaixar                        : Ocorrencia := '02'; {Pedido de Baixa}
      toRemessaConcederAbatimento            : Ocorrencia := '04'; {Concess�o de Abatimento}
      toRemessaCancelarAbatimento            : Ocorrencia := '05'; {Cancelamento de Abatimento concedido}
      toRemessaAlterarVencimento             : Ocorrencia := '06'; {Altera��o de vencimento}
      toRemessaProtestar                     : Ocorrencia := '09'; {Pedido de protesto}
      toRemessaNaoProtestar                  : Ocorrencia := '10'; {Sustar protesto antes do in�cio do ciclo de protesto}
      toRemessaCancelarInstrucaoProtesto     : Ocorrencia := '18'; {Sustar protesto e manter na carteira}
    else
      Ocorrencia := '01';                                          {Remessa}
    end;

    {Pegando Especie}
    if trim(EspecieDoc) = 'DM' then
      aEspecie:= '01'
    else if trim(EspecieDoc) = 'NP' then
      aEspecie:= '02'
    else if trim(EspecieDoc) = 'CH' then
      aEspecie:= '03'
    else if trim(EspecieDoc) = 'LC' then
      aEspecie:= '04'
    else if trim(EspecieDoc) = 'RC' then
      aEspecie:= '05'
    else if trim(EspecieDoc) = 'AP' then
      aEspecie:= '08'
    else if trim(EspecieDoc) = 'DS' then
      aEspecie:= '12'
    else if trim(EspecieDoc) = '99' then
      aEspecie:= '99'
    else
      aEspecie := EspecieDoc;

    {Pegando campo Intru��es}
    if (DataProtesto > 0) and (DataProtesto > Vencimento) then //and (Instrucao1 = '06') then
    begin
      Protesto := IntToStrZero(DaysBetween(DataProtesto,Vencimento),2);
      if (trim(Instrucao1) <> '06' )  and (trim(Instrucao2) <> '06' ) then
        If Trim(Instrucao1) = '' then
          Instrucao1 := '06'
        else
          Instrucao2 := '06';
    end
    else
      Protesto:= '00';

    {Pegando Dias Multa}
    if (DataMulta > 0) and (DataMulta > Vencimento) then
    begin
      Multa := IntToStrZero(DaysBetween(DataMulta, Vencimento), 2);
    end
    else
      Multa := '00';

    {Define Valor Multa}
    if MultaValorFixo then
      multiplicadorMulta:= 100
    else
      multiplicadorMulta:= 10000;
    valorMulta:= IntToStrZero( round( PercentualMulta * multiplicadorMulta ), 13);

    {Pegando Tipo de Sacado}
    case Sacado.Pessoa of
      pFisica   : TipoSacado := '01';
      pJuridica : TipoSacado := '02';
    else
      TipoSacado := '99'; //TODO: CHECAR OQ FAZER PARA CEDENTE SEM TIPO
    end;


    {Chave da NFe}
    if ListaDadosNFe.Count>0 then
      ChaveNFe := ListaDadosNFe[0].ChaveNFe
    else
      ChaveNFe := StringOfChar('0', 44);

    with ACBrBoleto do
    begin
      wLinha:= '1'                                                  +  // 1- ID Registro
        IfThen(Cedente.TipoInscricao = pJuridica,'02','01')         +  // 2 a 3
        PadLeft(trim(OnlyNumber(Cedente.CNPJCPF)),14,'0')           +  // 4 a 17
        PadRight(trim(Cedente.CodigoTransmissao),20)                +  // 18 a 37
        PadRight( SeuNumero ,25,' ')                                +  // 38 a 62
        '00000000000'                                               +  // 63 a 73
        //quando � sofisa ita�, o nosso numero nao tem DV, nota 3 item 4.
        PadLeft(RightStr(NossoNumero,13),13,'0')                    +  // 74 a 86 Cobran�a direta T�tulo Correspondente
        Space(3)                                                    +  // 87 a 89 Modalidade de Cobran�a com bancos correspondentes.
        IfThen(PercentualMulta > 0,'2','0')                         +  // 90 a 90
        valorMulta                                                  +  // 91 a 103
        Multa                                                       +  // 104 a 105 N�mero de dias ap�s o vencimento para aplicar a multa
        Space(2)                                                    +  // 106 a 107 Identifica��o da Opera��o no Banco
        IntToStr(aCarteira)                                         +  // 108 a 108 C�digo da Carteira
        Ocorrencia                                                  +  // 109 a 110 Identifica��o da Ocorr�ncia
        PadRight( NumeroDocumento,10,' ')                           +  // 111 a 120
        FormatDateTime( 'ddmmyy', Vencimento)                       +  // 121 a 126
        IntToStrZero( round( ValorDocumento * 100), 13)             +  // 127 a 139
        '341' + aAgencia                                            +  // 140 a 147
        PadLeft(aEspecie, 2) + 'N'                                  +  // 148 a 150
        FormatDateTime( 'ddmmyy', DataDocumento )                   +  // 151 a 156
        PadLeft(trim(Instrucao1),2,'0')                             +  // 157 a 158
        PadLeft(trim(Instrucao2),2,'0')                             +  // 159 a 160
        IntToStrZero( round(ValorMoraJuros * 100 ), 13)             +  // 161 a 173
        IfThen(DataDesconto < EncodeDate(2000,01,01),
               '000000',
               FormatDateTime( 'ddmmyy', DataDesconto))             +  // 174 a 179
        IntToStrZero( round( ValorDesconto * 100), 13)              +  // 180 a 192
        IntToStrZero( round( ValorIOF * 100 ), 13)                  +  // 193 a 205
        IntToStrZero( round( ValorAbatimento * 100 ), 13)           +  // 206 a 218
        TipoSacado + PadLeft(OnlyNumber(Sacado.CNPJCPF),14,'0')     +  // 219 a 234
        PadRight( Sacado.NomeSacado, 40, ' ')                       +  // 235 a 274
        PadRight( Sacado.Logradouro + ' '+ Sacado.Numero, 40, ' ')  +  // 275 a 314
        PadRight( Sacado.Bairro,12,' ')                             +  // 315 a 326
        PadRight( OnlyNumber(Sacado.CEP) , 8, ' ' )                 +  // 327 a 334
        PadRight( Sacado.Cidade, 15, ' ')                           +
        PadRight( Sacado.UF, 2 )                                    +  // 335 a 351
        PadRight( Sacado.NomeSacado, 30, ' ')                       +  // 352 a 381
        Space(4)                                                    +  // 382 a 385
        Space(6)                                                    +  // 386 a 391
        Protesto + '0'                                              +  // 392 a 394
        IntToStrZero( aRemessa.Count + 1, 6 )                       +  // 395 a 400
        ChaveNFe;                                                      // 401 a 444


      wLinha:= UpperCase(wLinha);
      if Mensagem.Count > 0 then
      begin
        wLinha:= wLinha + #13#10                         +
                 '2' + '0';
        for I := 0 to Mensagem.Count - 1 do
        begin
          if i = 5  then
            Break;

          wLinha := wLinha +
            PadRight(Mensagem[I],69);

        end;

        mensagemBranco := (5 - i) * 69;

        wLinha := wLinha + Space(mensagemBranco) + Space(47);
        wLinha := wLinha +  IntToStrZero(aRemessa.Count  + 2, 6 );
      end;

      aRemessa.Text:= aRemessa.Text + UpperCase(wLinha);
    end;
  end;
end;

end.


