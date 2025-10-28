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

include 'ACBrExtratoAPIST.php';
include '../../ACBrComum/ACBrComum.php';

$nomeLib = "ACBrExtratoAPI";
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

    $processo = "ExtratoAPI_Inicializar";
    if (Inicializar($ffi, $iniPath) != 0)
        exit;

    if ($metodo == "salvarConfiguracoes") {
        $processo = $metodo . "/" . "ExtratoAPI_ConfigGravarValor";

        if (ConfigGravarValor($ffi, "Principal", "LogPath", $_POST['LogPath']) != 0) exit;
        if (ConfigGravarValor($ffi, "Principal", "LogNivel", $_POST['LogNivel']) != 0) exit;

        if (ConfigGravarValor($ffi, "ExtratoAPI", "BancoConsulta", $_POST['BancoConsulta']) != 0) exit;
        if (ConfigGravarValor($ffi, "ExtratoAPI", "Ambiente", $_POST['ambiente']) != 0) exit;
        if (ConfigGravarValor($ffi, "ExtratoAPI", "ArqLog", $_POST['ArqLog']) != 0) exit;
        if (ConfigGravarValor($ffi, "ExtratoAPI", "NivelLog", $_POST['NivelLog']) != 0) exit;

        if (ConfigGravarValor($ffi, "Proxy", "Servidor", $_POST['proxyServidor']) != 0) exit;
        if (ConfigGravarValor($ffi, "Proxy", "Porta", $_POST['proxyPorta']) != 0) exit;
        if (ConfigGravarValor($ffi, "Proxy", "Usuario", $_POST['proxyUsuario']) != 0) exit;
        if (ConfigGravarValor($ffi, "Proxy", "Senha", $_POST['proxySenha']) != 0) exit;

        if (ConfigGravarValor($ffi, "ExtratoAPIBB", "DeveloperApplicationKey", $_POST['DeveloperApplicationKeyBB']) != 0) exit;
        if (ConfigGravarValor($ffi, "ExtratoAPIBB", "xMCITeste", $_POST['xMCITesteBB']) != 0) exit;
        if (ConfigGravarValor($ffi, "ExtratoAPIBB", "ClientID", $_POST['ClientIDBB']) != 0) exit;
        if (ConfigGravarValor($ffi, "ExtratoAPIBB", "ClientSecret", $_POST['ClientSecretBB']) != 0) exit;
        if (ConfigGravarValor($ffi, "ExtratoAPIBB", "ArquivoChavePrivada", $_POST['ArquivoChavePrivadaBB']) != 0) exit;
        if (ConfigGravarValor($ffi, "ExtratoAPIBB", "ArquivoCertificado", $_POST['ArquivoCertificadoBB']) != 0) exit;

        if (ConfigGravarValor($ffi, "ExtratoAPIInter", "ClientID", $_POST['ClientIDInter']) != 0) exit;
        if (ConfigGravarValor($ffi, "ExtratoAPIInter", "ClientSecret", $_POST['ClientSecretInter']) != 0) exit;
        if (ConfigGravarValor($ffi, "ExtratoAPIInter", "ArquivoChavePrivada", $_POST['ArquivoChavePrivadaInter']) != 0) exit;
        if (ConfigGravarValor($ffi, "ExtratoAPIInter", "ArquivoCertificado", $_POST['ArquivoCertificadoInter']) != 0) exit;

        if (ConfigGravarValor($ffi, "ExtratoAPISicoob", "ClientID", $_POST['ClientIDSicoob']) != 0) exit;
        if (ConfigGravarValor($ffi, "ExtratoAPISicoob", "ArquivoChavePrivada", $_POST['ArquivoChavePrivadaSicoob']) != 0) exit;
        if (ConfigGravarValor($ffi, "ExtratoAPISicoob", "ArquivoCertificado", $_POST['ArquivoCertificadoSicoob']) != 0) exit;

        $resultado = "Configurações salvas com sucesso.";
    }

    if ($metodo == "carregarConfiguracoes") {
        $processo = $metodo . "/" . "ExtratoAPI_ConfigLer";

        if (ConfigLerValor($ffi, "Principal", "LogPath", $LogPath) != 0) exit;
        if (ConfigLerValor($ffi, "Principal", "LogNivel", $LogNivel) != 0) exit;

        if (ConfigLerValor($ffi, "ExtratoAPI", "BancoConsulta", $BancoConsulta) != 0) exit;
        if (ConfigLerValor($ffi, "ExtratoAPI", "Ambiente", $ambiente) != 0) exit;
        if (ConfigLerValor($ffi, "ExtratoAPI", "ArqLog", $ArqLog) != 0) exit;
        if (ConfigLerValor($ffi, "ExtratoAPI", "NivelLog", $NivelLog) != 0) exit;

        if (ConfigLerValor($ffi, "Proxy", "Servidor", $proxyServidor) != 0) exit;
        if (ConfigLerValor($ffi, "Proxy", "Porta", $proxyPorta) != 0) exit;
        if (ConfigLerValor($ffi, "Proxy", "Usuario", $proxyUsuario) != 0) exit;
        if (ConfigLerValor($ffi, "Proxy", "Senha", $proxySenha) != 0) exit;

        if (ConfigLerValor($ffi, "ExtratoAPIBB", "DeveloperApplicationKey", $DeveloperApplicationKeyBB) != 0) exit;
        if (ConfigLerValor($ffi, "ExtratoAPIBB", "xMCITeste", $xMCITesteBB) != 0) exit;
        if (ConfigLerValor($ffi, "ExtratoAPIBB", "ClientID", $ClientIDBB) != 0) exit;
        if (ConfigLerValor($ffi, "ExtratoAPIBB", "ClientSecret", $ClientSecretBB) != 0) exit;
        if (ConfigLerValor($ffi, "ExtratoAPIBB", "ArquivoChavePrivada", $ArquivoChavePrivadaBB) != 0) exit;
        if (ConfigLerValor($ffi, "ExtratoAPIBB", "ArquivoCertificado", $ArquivoCertificadoBB) != 0) exit;

        if (ConfigLerValor($ffi, "ExtratoAPIInter", "ClientID", $ClientIDInter) != 0) exit;
        if (ConfigLerValor($ffi, "ExtratoAPIInter", "ClientSecret", $ClientSecretInter) != 0) exit;
        if (ConfigLerValor($ffi, "ExtratoAPIInter", "ArquivoChavePrivada", $ArquivoChavePrivadaInter) != 0) exit;
        if (ConfigLerValor($ffi, "ExtratoAPIInter", "ArquivoCertificado", $ArquivoCertificadoInter) != 0) exit;

        if (ConfigLerValor($ffi, "ExtratoAPISicoob", "ClientID", $ClientIDSicoob) != 0) exit;
        if (ConfigLerValor($ffi, "ExtratoAPISicoob", "ArquivoChavePrivada", $ArquivoChavePrivadaSicoob) != 0) exit;
        if (ConfigLerValor($ffi, "ExtratoAPISicoob", "ArquivoCertificado", $ArquivoCertificadoSicoob) != 0) exit;

        $processo = $metodo . "/" . "responseData";
        $responseData = [
            'dados' => [
                'LogPath' => $LogPath ?? '',
                'LogNivel' => $LogNivel ?? '',

                'BancoConsulta' => $BancoConsulta ?? '',
                'ambiente' => $ambiente ?? '',
                'ArqLog' => $ArqLog ?? '',
                'NivelLog' => $NivelLog ?? '',

                'proxyServidor' => $proxyServidor ?? '',
                'proxyPorta' => $proxyPorta ?? '',
                'proxyUsuario' => $proxyUsuario ?? '',
                'proxySenha' => $proxySenha ?? '',

                'DeveloperApplicationKeyBB' => $DeveloperApplicationKeyBB ?? '',
                'xMCITesteBB' => $xMCITesteBB ?? '',
                'ClientIDBB' => $ClientIDBB ?? '',
                'ClientSecretBB' => $ClientSecretBB ?? '',
                'ArquivoChavePrivadaBB' => $ArquivoChavePrivadaBB ?? '',
                'ArquivoCertificadoBB' => $ArquivoCertificadoBB ?? '',

                'ClientIDInter' => $ClientIDInter ?? '',
                'ClientSecretInter' => $ClientSecretInter ?? '',
                'ArquivoChavePrivadaInter' => $ArquivoChavePrivadaInter ?? '',
                'ArquivoCertificadoInter' => $ArquivoCertificadoInter ?? '',

                'ClientIDSicoob' => $ClientIDSicoob ?? '',
                'ArquivoChavePrivadaSicoob' => $ArquivoChavePrivadaSicoob ?? '',
                'ArquivoCertificadoSicoob' => $ArquivoCertificadoSicoob ?? ''
            ]
        ];
    }

    if ($metodo == "OpenSSLInfo") {
        $processo = "ExtratoAPI_OpenSSLInfo";

        if (OpenSSLInfo($ffi, $resultado) != 0) {
            exit;
        }
    }

    if ($metodo == "ConsultarExtrato") {
        $processo = "ExtratoAPI_ConsultarExtrato";

        if (ConsultarExtrato(
            $ffi,
            $_POST['AAgencia'],
            $_POST['AConta'],
            strDateToDoubleDate($_POST['ADataInicio']),
            strDateToDoubleDate($_POST['ADataFim']),
            $_POST['APagina'],
            $_POST['ARegistrosPorPag'],
            $resultado
        ) != 0) {
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
    if ($processo != "ExtratoAPI_Inicializar") {
        $processo = "ExtratoAPI_Finalizar";
        if (Finalizar($ffi) != 0)
            exit;
    }
} catch (Exception $e) {
    $erro = $e->getMessage();
    echo json_encode(["mensagem" => "Exceção[$processo]: $erro"]);
    exit;
}

echo json_encode($responseData);
