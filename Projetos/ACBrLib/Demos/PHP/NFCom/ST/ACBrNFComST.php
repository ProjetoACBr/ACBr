<?php
/* {******************************************************************************}
// { Projeto: Componentes ACBr                                                    }
// {  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
// { mentos de Automação Comercial utilizados no Brasil                           }
// {                                                                              }
// { Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
// {                                                                              }
// { Colaboradores nesse arquivo: Renato Rubinho                                  }
// {                                                                              }
// {  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
// { Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
// {                                                                              }
// {  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
// { sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
// { Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
// { qualquer versão posterior.                                                   }
// {                                                                              }
// {  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
// { NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
// { ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
// { do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
// {                                                                              }
// {  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
// { com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
// { no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
// { Você também pode obter uma copia da licença em:                              }
// { http://www.opensource.org/licenses/lgpl-license.php                          }
// {                                                                              }
// { Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
// {       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
// {******************************************************************************}
*/
header('Content-Type: application/json; charset=UTF-8');

function Inicializar($ffi, $iniPath)
{
    $retorno = $ffi->NFCom_Inicializar($iniPath, "");

    if ($retorno !== 0) {
        echo json_encode(["mensagem" => "Falha ao inicializar a biblioteca ACBr. Código de erro: $retorno"]);
        return -10;
    }

    return 0;
}

function Finalizar($ffi)
{
    $retorno = $ffi->NFCom_Finalizar();

    if ($retorno !== 0) {
        echo json_encode(["mensagem" => "Falha ao finalizar a biblioteca ACBr. Código de erro: $retorno"]);
        return -10;
    }

    return 0;
}

function ConfigLer($ffi, $eArqConfig)
{
    $retorno = $ffi->NFCom_ConfigLer($eArqConfig);
    $sMensagem = FFI::new("char[9048]");

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao carregar o arquivo ini. ") != 0)
        return -10;

    return 0;
}

function ConfigLerValor($ffi, $eSessao, $eChave, &$sValor)
{
    $sResposta = FFI::new("char[9048]");
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $retorno = $ffi->NFCom_ConfigLerValor($eSessao, $eChave, $sResposta, FFI::addr($esTamanho));

    $sMensagem = FFI::new("char[9048]");

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao ler valor na secao[$eSessao] e chave[$eChave]. ", 1) != 0)
            return -10;
    }

    $sValor = FFI::string($sResposta);
    return 0;
}

function ConfigGravarValor($ffi, $eSessao, $eChave, $value)
{
    $retorno = $ffi->NFCom_ConfigGravarValor($eSessao, $eChave, $value);
    $sMensagem = FFI::new("char[9048]");

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao gravar valores [$value] na secao[$eSessao] e chave[$eChave]. ") != 0)
        return -10;

    return 0;
}

function ConfigGravar($ffi, $eArqConfig)
{
    $retorno = $ffi->NFCom_ConfigGravar($eArqConfig);
    $sMensagem = FFI::new("char[9048]");

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao gravar as configurações. ") != 0)
        return -10;

    return 0;
}

function UltimoRetorno($ffi, $retornolib, &$sMensagem, $msgErro, $retMensagem = 0)
{
    if (($retornolib !== 0) || ($retMensagem == 1)) {
        $esTamanho = FFI::new("long");
        $esTamanho->cdata = 9048;
        $resposta = $ffi->NFCom_UltimoRetorno($sMensagem, FFI::addr($esTamanho));

        if ($retornolib !== 0) {
            $ultimoRetorno = FFI::string($sMensagem);
            $retorno = "$msgErro Código de erro: $retornolib. ";

            $retorno = $retorno;

            if ($ultimoRetorno != "") {
                $retorno = $retorno . "Último retorno: " . $ultimoRetorno;
            }

            echo json_encode(["mensagem" => $retorno]);
            return -10;
        }
    }

    return 0;
}

function StatusServico($ffi, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_StatusServico($sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao consultar status do serviço", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function NFComNome($ffi, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_Nome($sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao verificar o nome da biblioteca", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function NFComVersao($ffi, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_Versao($sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao verificar a versão da biblioteca", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function OpenSSLInfo($ffi, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_OpenSSLInfo($sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao verificar a OpenSSLInfo", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function CarregarXmlNFCom($ffi, $eArquivoOuXML, &$retornoGeral)
{
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_CarregarXML($eArquivoOuXML);

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao carregar o XML da NFCom", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function CarregarINI($ffi, $eArquivoOuINI, &$retornoGeral)
{
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_CarregarINI($eArquivoOuINI);

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao carregar o INI", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function CarregarEventoXML($ffi, $eArquivoOuXML, &$retornoGeral)
{
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_CarregarEventoXML($eArquivoOuXML);

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao carregar o XML do evento", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function LimparListaNFCom($ffi, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_LimparLista();

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao limpar a lista de NFComs.", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function LimparListaEventos($ffi, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_LimparListaEventos();

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao limpar a lista de eventos.", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function AssinarNFCom($ffi, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_Assinar();

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro assinar NFCom.", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function ValidarNFCom($ffi, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_Validar();

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro validar NFCom.", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function ValidarRegrasdeNegocios($ffi, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_ValidarRegrasdeNegocios($sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao validar regra de negócio", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function VerificarAssinatura($ffi, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_VerificarAssinatura($sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao verificar assinatura", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function ObterXml($ffi, $AIndex, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_ObterXml($AIndex, $sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao obter o xml", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function GravarXml($ffi, $AIndex, $eNomeArquivo, $ePathArquivo, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_GravarXml($AIndex, $eNomeArquivo, $ePathArquivo);

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro gravar o xml da NFCom.", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function ObterIni($ffi, $AIndex, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_ObterIni($AIndex, $sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao obter o ini", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function GravarIni($ffi, $AIndex, $eNomeArquivo, $ePathArquivo, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_GravarIni($AIndex, $eNomeArquivo, $ePathArquivo);

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro gravar o ini", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function CarregarEventoINI($ffi, $eArquivoOuINI, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_CarregarEventoINI($eArquivoOuINI);

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro carregar o ini do evento", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function ObterCertificados($ffi, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_ObterCertificados($sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao obter certificados", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function GetPath($ffi, $ATipo, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_GetPath($ATipo, $sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao obter o caminnho", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function GetPathEvento($ffi, $ACodEvento, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_GetPathEvento($ACodEvento, $sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao obter o caminnho do evento", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function Consultar($ffi, $eChaveOuNFCom, $AExtrairEventos, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_Consultar($eChaveOuNFCom, $AExtrairEventos, $sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao consultar a chave", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function Enviar($ffi, $AImprimir, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_Enviar($AImprimir, $sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao enviar NFCom", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function Cancelar($ffi, $AeChave, $AeJustificativa, $AeCNPJCPF, $ALote, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_Cancelar($AeChave, $AeJustificativa, $AeCNPJCPF, $ALote, $sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao cancelar NFCom", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function EnviarEvento($ffi, $AidLote, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_EnviarEvento($AidLote, $sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao enviar o evento", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function EnviarEmail($ffi, $AePara, $eXmlNFCom, $AEnviaPDF, $AeAssunto, $AeCC, $AeAnexos, $AeMensagem, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 144768;
    $sMensagem = FFI::new("char[144768]");
    $retorno = $ffi->NFCom_EnviarEmail($AePara, $eXmlNFCom, $AEnviaPDF, $AeAssunto, $AeCC, $AeAnexos, $AeMensagem);

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao enviar e-mail", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function EnviarEmailEvento($ffi, $AePara, $AeXmlEvento, $AeXmlNFCom, $AEnviaPDF, $AeAssunto, $AeCC, $AeAnexos, $AeMensagem, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 144768;
    $sMensagem = FFI::new("char[144768]");
    $retorno = $ffi->NFCom_EnviarEmailEvento($AePara, $AeXmlEvento, $AeXmlNFCom, $AEnviaPDF, $AeAssunto, $AeCC, $AeAnexos, $AeMensagem);

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao enviar e-mail do evento", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function Imprimir($ffi, $AcImpressora, $AnNumCopias, $AcProtocolo, $AbMostrarPreview, $AcMarcaDagua, $AbViaConsumidor, $AbSimplificado, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_Imprimir($AcImpressora, $AnNumCopias, $AcProtocolo, $AbMostrarPreview, $AcMarcaDagua, $AbViaConsumidor, $AbSimplificado);

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao imprimir", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function ImprimirPDF($ffi, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $sMensagem = FFI::new("char[9048]");
    $retorno = $ffi->NFCom_ImprimirPDF();

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao imprimir o pdf", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function SalvarPDF($ffi, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 144768;
    $sMensagem = FFI::new("char[144768]");
    $retorno = $ffi->NFCom_SalvarPDF($sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao salvar o pdf", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function ImprimirEvento($ffi, $AeArquivoXmlNFCom, $AeArquivoXmlEvento, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 144768;
    $sMensagem = FFI::new("char[144768]");
    $retorno = $ffi->NFCom_ImprimirEvento($AeArquivoXmlNFCom, $AeArquivoXmlEvento);

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao imprimir o evento", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function ImprimirEventoPDF($ffi, $AeArquivoXmlNFCom, $AeArquivoXmlEvento, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 144768;
    $sMensagem = FFI::new("char[144768]");
    $retorno = $ffi->NFCom_ImprimirEventoPDF($AeArquivoXmlNFCom, $AeArquivoXmlEvento);

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao imprimir o pdf do evento", 1) != 0)
        return -10;

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}

function SalvarEventoPDF($ffi, $AeArquivoXmlNFCom, $AeArquivoXmlEvento, &$retornoGeral)
{
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 144768;
    $sMensagem = FFI::new("char[144768]");
    $retorno = $ffi->NFCom_SalvarEventoPDF($AeArquivoXmlNFCom, $AeArquivoXmlEvento, $sMensagem, FFI::addr($esTamanho));

    if ($retorno !== 0) {
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao salvar o pdf do evento", 1) != 0)
            return -10;
    }

    $retornoGeral = FFI::string($sMensagem);

    return 0;
}
