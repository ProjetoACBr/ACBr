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

include 'ACBrNFComST.php';
include '../../ACBrComum/ACBrComum.php';

$nomeLib = "ACBrNFCom";
$metodo = $_POST['metodo'];

if (ValidaFFI() != 0)
    exit;

$dllPath = CarregaDll(__DIR__, $nomeLib);

if ($dllPath == -10)
    exit;

$importsPath = CarregaImports(__DIR__, $nomeLib, 'ST');

if ($importsPath == -10)
    exit;

$iniPath = CarregaIniPath(__DIR__, $nomeLib);

$processo = "file_get_contents";
$ffi = CarregaContents($importsPath, $dllPath);

try {
    $resultado = "";
    $processo = "Inicializar";

    $processo = "NFCOM_Inicializar";
    if (Inicializar($ffi, $iniPath) != 0)
        exit;

    if ($metodo == "salvarConfiguracoes") {
        $processo = $metodo . "/" . "NFCOM_ConfigGravarValor";

        if (ConfigGravarValor($ffi, "Principal", "LogPath", $_POST['LogPath']) != 0) exit;
        if (ConfigGravarValor($ffi, "Principal", "LogNivel", $_POST['LogNivel']) != 0) exit;

        if (ConfigGravarValor($ffi, "NFCom", "ExibirErroSchema", $_POST['exibirErroSchema']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "FormatoAlerta", $_POST['formatoAlerta']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "FormaEmissao", $_POST['formaEmissao']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "VersaoDF", $_POST['versaoDF']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "RetirarAcentos", $_POST['retirarAcentos']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "SalvarGer", $_POST['SalvarGer']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "PathSalvar", $_POST['pathSalvar']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "PathSchemas", $_POST['pathSchemas']) != 0) exit;

        if (ConfigGravarValor($ffi, "NFCom", "SSLType", $_POST['SSLType']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "Timeout", $_POST['timeout']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "Ambiente", $_POST['ambiente']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "Visualizar", $_POST['visualizar']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "SalvarWS", $_POST['SalvarWS']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "AjustaAguardaConsultaRet", $_POST['ajustaAguardaConsultaRet']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "AguardarConsultaRet", $_POST['aguardarConsultaRet']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "Tentativas", $_POST['tentativas']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "IntervaloTentativas", $_POST['intervaloTentativas']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "SalvarArq", $_POST['SalvarArq']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "SepararPorMes", $_POST['SepararPorMes']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "AdicionarLiteral", $_POST['AdicionarLiteral']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "EmissaoPathNFCom", $_POST['EmissaoPathNFCom']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "SalvarEvento", $_POST['SalvarEvento']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "SepararPorCNPJ", $_POST['SepararPorCNPJ']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "SepararPorModelo", $_POST['SepararPorModelo']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "PathNFCom", $_POST['PathNFCom']) != 0) exit;
        if (ConfigGravarValor($ffi, "NFCom", "PathEvento", $_POST['PathEvento']) != 0) exit;

        if (ConfigGravarValor($ffi, "Proxy", "Servidor", $_POST['proxyServidor']) != 0) exit;
        if (ConfigGravarValor($ffi, "Proxy", "Porta", $_POST['proxyPorta']) != 0) exit;
        if (ConfigGravarValor($ffi, "Proxy", "Usuario", $_POST['proxyUsuario']) != 0) exit;
        if (ConfigGravarValor($ffi, "Proxy", "Senha", $_POST['proxySenha']) != 0) exit;

        if (ConfigGravarValor($ffi, "DFe", "UF", $_POST['UF']) != 0) exit;
        if (ConfigGravarValor($ffi, "DFe", "SSLCryptLib", $_POST['SSLCryptLib']) != 0) exit;
        if (ConfigGravarValor($ffi, "DFe", "SSLHttpLib", $_POST['SSLHttpLib']) != 0) exit;
        if (ConfigGravarValor($ffi, "DFe", "SSLXmlSignLib", $_POST['SSLXmlSignLib']) != 0) exit;
        if (ConfigGravarValor($ffi, "DFe", "ArquivoPFX", $_POST['ArquivoPFX']) != 0) exit;
        if (ConfigGravarValor($ffi, "DFe", "DadosPFX", $_POST['DadosPFX']) != 0) exit;
        if (ConfigGravarValor($ffi, "DFe", "Senha", $_POST['senhaCertificado']) != 0) exit;
        if (ConfigGravarValor($ffi, "DFe", "NumeroSerie", $_POST['NumeroSerie']) != 0) exit;

        if (ConfigGravarValor($ffi, "DANFCom", "PathLogo", $_POST['PathLogo']) != 0) exit;
        // Habilitar, caso seja implementado leiaute paisagem                
        // if (ConfigGravarValor($ffi, "DANFCom", "TipoDANFCom", $_POST['TipoDANFCom']) != 0) exit;

        if (ConfigGravarValor($ffi, "Email", "Nome", $_POST['emailNome']) != 0) exit;
        if (ConfigGravarValor($ffi, "Email", "Conta", $_POST['emailConta']) != 0) exit;
        if (ConfigGravarValor($ffi, "Email", "Servidor", $_POST['emailServidor']) != 0) exit;
        if (ConfigGravarValor($ffi, "Email", "Porta", $_POST['emailPorta']) != 0) exit;
        if (ConfigGravarValor($ffi, "Email", "SSL", $_POST['emailSSL']) != 0) exit;
        if (ConfigGravarValor($ffi, "Email", "TLS", $_POST['emailTLS']) != 0) exit;
        if (ConfigGravarValor($ffi, "Email", "Usuario", $_POST['emailUsuario']) != 0) exit;
        if (ConfigGravarValor($ffi, "Email", "Senha", $_POST['emailSenha']) != 0) exit;

        $resultado = "Configurações salvas com sucesso.";
    }

    if ($metodo == "carregarConfiguracoes") {
        $processo = $metodo . "/" . "NFCOM_ConfigLer";

        if (ConfigLerValor($ffi, "Principal", "LogPath", $LogPath) != 0) exit;
        if (ConfigLerValor($ffi, "Principal", "LogNivel", $LogNivel) != 0) exit;

        if (ConfigLerValor($ffi, "NFCom", "ExibirErroSchema", $exibirErroSchema) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "FormatoAlerta", $formatoAlerta) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "FormaEmissao", $formaEmissao) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "VersaoDF", $versaoDF) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "RetirarAcentos", $retirarAcentos) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "SalvarGer", $SalvarGer) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "PathSalvar", $pathSalvar) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "PathSchemas", $pathSchemas) != 0) exit;

        if (ConfigLerValor($ffi, "NFCom", "SSLType", $SSLType) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "Timeout", $timeout) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "Ambiente", $ambiente) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "Visualizar", $visualizar) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "SalvarWS", $SalvarWS) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "AjustaAguardaConsultaRet", $ajustaAguardaConsultaRet) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "AguardarConsultaRet", $aguardarConsultaRet) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "Tentativas", $tentativas) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "IntervaloTentativas", $intervaloTentativas) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "SalvarArq", $SalvarArq) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "SepararPorMes", $SepararPorMes) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "AdicionarLiteral", $AdicionarLiteral) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "EmissaoPathNFCom", $EmissaoPathNFCom) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "SalvarEvento", $SalvarEvento) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "SepararPorCNPJ", $SepararPorCNPJ) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "SepararPorModelo", $SepararPorModelo) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "PathNFCom", $PathNFCom) != 0) exit;
        if (ConfigLerValor($ffi, "NFCom", "PathEvento", $PathEvento) != 0) exit;

        if (ConfigLerValor($ffi, "Proxy", "Servidor", $proxyServidor) != 0) exit;
        if (ConfigLerValor($ffi, "Proxy", "Porta", $proxyPorta) != 0) exit;
        if (ConfigLerValor($ffi, "Proxy", "Usuario", $proxyUsuario) != 0) exit;
        if (ConfigLerValor($ffi, "Proxy", "Senha", $proxySenha) != 0) exit;

        if (ConfigLerValor($ffi, "DFe", "UF", $UF) != 0) exit;
        if (ConfigLerValor($ffi, "DFe", "SSLCryptLib", $SSLCryptLib) != 0) exit;
        if (ConfigLerValor($ffi, "DFe", "SSLHttpLib", $SSLHttpLib) != 0) exit;
        if (ConfigLerValor($ffi, "DFe", "SSLXmlSignLib", $SSLXmlSignLib) != 0) exit;
        if (ConfigLerValor($ffi, "DFe", "ArquivoPFX", $ArquivoPFX) != 0) exit;
        if (ConfigLerValor($ffi, "DFe", "DadosPFX", $DadosPFX) != 0) exit;
        if (ConfigLerValor($ffi, "DFe", "Senha", $senhaCertificado) != 0) exit;
        if (ConfigLerValor($ffi, "DFe", "NumeroSerie", $NumeroSerie) != 0) exit;

        if (ConfigLerValor($ffi, "DANFCom", "PathLogo", $PathLogo) != 0) exit;
        // Habilitar, caso seja implementado leiaute paisagem                
        // if (ConfigLerValor($ffi, "DANFCom", "TipoDANFCom", $TipoDANFCom) != 0) exit;

        if (ConfigLerValor($ffi, "Email", "Nome", $emailNome) != 0) exit;
        if (ConfigLerValor($ffi, "Email", "Conta", $emailConta) != 0) exit;
        if (ConfigLerValor($ffi, "Email", "Servidor", $emailServidor) != 0) exit;
        if (ConfigLerValor($ffi, "Email", "Porta", $emailPorta) != 0) exit;
        if (ConfigLerValor($ffi, "Email", "SSL", $emailSSL) != 0) exit;
        if (ConfigLerValor($ffi, "Email", "TLS", $emailTLS) != 0) exit;
        if (ConfigLerValor($ffi, "Email", "Usuario", $emailUsuario) != 0) exit;
        if (ConfigLerValor($ffi, "Email", "Senha", $emailSenha) != 0) exit;

        $processo = $metodo . "/" . "responseData";
        $responseData = [
            'dados' => [
                'LogPath' => $LogPath ?? '',
                'LogNivel' => $LogNivel ?? '',

                'exibirErroSchema' => $exibirErroSchema ?? '',
                'formatoAlerta' => $formatoAlerta ?? '',
                'formaEmissao' => $formaEmissao ?? '',
                'versaoDF' => $versaoDF ?? '',
                'retirarAcentos' => $retirarAcentos ?? '',
                'SalvarGer' => $SalvarGer ?? '',
                'pathSalvar' => $pathSalvar ?? '',
                'pathSchemas' => $pathSchemas ?? '',
                'SSLType' => $SSLType ?? '',
                'timeout' => $timeout ?? '',
                'ambiente' => $ambiente ?? '',
                'visualizar' => $visualizar ?? '',
                'SalvarWS' => $SalvarWS ?? '',
                'ajustaAguardaConsultaRet' => $ajustaAguardaConsultaRet ?? '',
                'aguardarConsultaRet' => $aguardarConsultaRet ?? '',
                'tentativas' => $tentativas ?? '',
                'intervaloTentativas' => $intervaloTentativas ?? '',
                'SalvarArq' => $SalvarArq ?? '',
                'SepararPorMes' => $SepararPorMes ?? '',
                'AdicionarLiteral' => $AdicionarLiteral ?? '',
                'EmissaoPathNFCom' => $EmissaoPathNFCom ?? '',
                'SalvarEvento' => $SalvarEvento ?? '',
                'SepararPorCNPJ' => $SepararPorCNPJ ?? '',
                'SepararPorModelo' => $SepararPorModelo ?? '',
                'PathNFCom' => $PathNFCom ?? '',
                'PathEvento' => $PathEvento ?? '',

                'proxyServidor' => $proxyServidor ?? '',
                'proxyPorta' => $proxyPorta ?? '',
                'proxyUsuario' => $proxyUsuario ?? '',
                'proxySenha' => $proxySenha ?? '',

                'UF' => $UF ?? '',
                'SSLCryptLib' => $SSLCryptLib ?? '',
                'SSLHttpLib' => $SSLHttpLib ?? '',
                'SSLXmlSignLib' => $SSLXmlSignLib ?? '',
                'ArquivoPFX' => $ArquivoPFX ?? '',
                'DadosPFX' => $DadosPFX ?? '',
                'senhaCertificado' => $senhaCertificado ?? '',
                'NumeroSerie' => $NumeroSerie ?? '',

                'PathLogo' => $PathLogo ?? '',
                // Habilitar, caso seja implementado leiaute paisagem                
                // 'TipoDANFCom' => $TipoDANFCom ?? '',

                'emailNome' => $emailNome ?? '',
                'emailConta' => $emailConta ?? '',
                'emailServidor' => $emailServidor ?? '',
                'emailPorta' => $emailPorta ?? '',
                'emailSSL' => $emailSSL ?? '',
                'emailTLS' => $emailTLS ?? '',
                'emailUsuario' => $emailUsuario ?? '',
                'emailSenha' => $emailSenha ?? ''
            ]
        ];
    }

    if ($metodo == "statusServico") {
        $processo = "NFCOM_StatusServico";

        if (StatusServico($ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "OpenSSLInfo") {
        $processo = "NFCOM_OpenSSLInfo";

        if (OpenSSLInfo($ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "ObterCertificados") {
        $processo = "NFCOM_ObterCertificados";

        if (ObterCertificados($ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "CarregarXmlNFCom") {
        $processo = "NFCOM_CarregarXml";

        if (CarregarXmlNFCom($ffi, $_POST['conteudoArquivo01'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "CarregarIniNFCom") {
        $processo = "NFCOM_CarregarINI";

        if (CarregarINI($ffi, $_POST['conteudoArquivo01'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "CarregarEventoXML") {
        $processo = "NFCOM_CarregarEventoXml";

        if (CarregarEventoXML($ffi, $_POST['conteudoArquivo01'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "LimparListaNFCom") {
        $processo = "NFCOM_LimparListaNFCom";

        if (LimparListaNFCom($ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "LimparListaEventos") {
        $processo = "NFCOM_LimparListaEventos";

        if (LimparListaEventos($ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "AssinarNFCom") {
        $processo = "NFCOM_AssinarNFCom";

        if (AssinarNFCom($ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "ValidarNFCom") {
        $processo = "NFCOM_ValidarNFCom";

        if (ValidarNFCom($ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "ValidarRegrasdeNegocios") {
        $processo = "NFCOM_CarregarXml";

        if (CarregarXmlNFCom($ffi, $_POST['AeArquivoXmlNFCom'], $resultado) != 0) {
            exit;
        }

        $processo = "NFCOM_ValidarRegrasdeNegocios";

        if (ValidarRegrasdeNegocios($ffi, $resultado) != 0) {
            exit;
        }

        $resultado = "ok";
    }
    
    if ($metodo == "Consultar") {
        $processo = "NFCOM_Consultar";

        if (Consultar($ffi, $_POST['eChaveOuNFCom'], $_POST['AExtrairEventos'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "Enviar") {
        if ($_POST['tipoArquivo'] == "xml") {
            $processo = "NFCOM_CarregarXml";

            if (CarregarXmlNFCom($ffi, $_POST['AeArquivoNFCom'], $resultado) != 0) {
                exit;
            }
        } else {
            $processo = "NFCOM_CarregarINI";

            if (CarregarINI($ffi, $_POST['AeArquivoNFCom'], $resultado) != 0) {
                exit;
            }
        }

        $processo = "NFCOM_AssinarNFCom";

        if (AssinarNFCom($ffi, $resultado) != 0) {
            exit;
        }

        $processo = "NFCOM_Enviar";

        if (Enviar(
            $ffi,
            $_POST['AImprimir'],
            $resultado
        ) != 0) {
            exit;
        }
    }

    if ($metodo == "Cancelar") {
        $processo = "NFCOM_Cancelar";

        if (Cancelar($ffi, $_POST['AeChave'], $_POST['AeJustificativa'], $_POST['AeCNPJCPF'], $_POST['ALote'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "EnviarEvento") {
        $processo = "NFCOM_CarregarXml";

        if (CarregarXmlNFCom($ffi, $_POST['AeArquivoXmlNFCom'], $resultado) != 0) {
            exit;
        }

        $processo = "NFCOM_CarregarEventoXml";

        if (CarregarEventoXML($ffi, $_POST['AeArquivoXmlEvento'], $resultado) != 0) {
            exit;
        }

        $processo = "NFCOM_EnviarEvento";

        if (EnviarEvento($ffi, $_POST['AidLote'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "EnviarEmail") {
        $processo = "NFCOM_EnviarEmail";

        if (EnviarEmail($ffi, $_POST['AePara'], $_POST['AeArquivoXmlNFCom'], $_POST['AEnviaPDF'], $_POST['AeAssunto'], $_POST['AeCC'], $_POST['AeAnexos'], $_POST['AeMensagem'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "EnviarEmailEvento") {
        $processo = "NFCOM_EnviarEmailEvento";

        if (EnviarEmailEvento($ffi, $_POST['AePara'], $_POST['AeArquivoXmlEvento'], $_POST['AeArquivoXmlNFCom'], $_POST['AEnviaPDF'], $_POST['AeAssunto'], $_POST['AeCC'], $_POST['AeAnexos'], $_POST['AeMensagem'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "ImprimirPDF") {
        $processo = "NFCOM_CarregarXml";

        if (CarregarXmlNFCom($ffi, $_POST['AeArquivoXmlNFCom'], $resultado) != 0) {
            exit;
        }

        $processo = "NFCOM_ImprimirPDF";

        if (ImprimirPDF($ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "SalvarPDF") {
        $processo = "NFCOM_CarregarXml";

        if (CarregarXmlNFCom($ffi, $_POST['AeArquivoXmlNFCom'], $resultado) != 0) {
            exit;
        }

        $processo = "NFCOM_SalvarPDF";

        if (SalvarPDF($ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "ImprimirEventoPDF") {
        $processo = "NFCOM_ImprimirEventoPDF";

        if (ImprimirEventoPDF($ffi, $_POST['AeArquivoXmlNFCom'], $_POST['AeArquivoXmlEvento'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "SalvarEventoPDF") {
        $processo = "NFCOM_SalvarEventoPDF";

        if (SalvarEventoPDF($ffi, $_POST['AeArquivoXmlNFCom'], $_POST['AeArquivoXmlEvento'], $resultado) != 0) {
            exit;
        }
    }

    if ($metodo != "carregarConfiguracoes") {
        $processo = "responseData";
        $responseData = [
            'mensagem' => $resultado
        ];
    }
} catch (Exception $e) {
    $erro = $e->getMessage();
    echo json_encode(["mensagem" => "Exceção[$processo]: $erro"]);
    exit;
}

try {
    if ($processo != "NFCOM_Inicializar") {
        $processo = "NFCOM_Finalizar";
        if (Finalizar($ffi) != 0)
            exit;
    }
} catch (Exception $e) {
    $erro = $e->getMessage();
    echo json_encode(["mensagem" => "Exceção[$processo]: $erro"]);
    exit;
}

echo json_encode($responseData);
