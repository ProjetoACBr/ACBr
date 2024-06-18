<?php
/* {******************************************************************************}
// { Projeto: Componentes ACBr                                                    }
// {  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
// { mentos de Automa��o Comercial utilizados no Brasil                           }
// {                                                                              }
// { Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
// {                                                                              }
// { Colaboradores nesse arquivo: Renato Rubinho                                  }
// {                                                                              }
// {  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
// { Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
// {                                                                              }
// {  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
// { sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
// { Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
// { qualquer vers�o posterior.                                                   }
// {                                                                              }
// {  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
// { NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
// { ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
// { do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
// {                                                                              }
// {  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
// { com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
// { no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
// { Voc� tamb�m pode obter uma copia da licen�a em:                              }
// { http://www.opensource.org/licenses/lgpl-license.php                          }
// {                                                                              }
// { Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
// {       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
// {******************************************************************************}
*/
header('Content-Type: application/json; charset=UTF-8');

function ValidaFFI(){
    if (!extension_loaded('ffi')) {
        echo json_encode(["mensagem" => mb_convert_encoding("A extens�o FFI n�o est� habilitada.", "UTF-8", "ISO-8859-1")]);
        return -10;
    }

    return 0;
}

function CarregaDll(){
    if (strpos(PHP_OS, 'WIN') === false) 
        $extensao = ".so";
    else
        $extensao = ".dll";
    
    if (strpos(php_uname('m'), '64') === false) 
        $arquitetura = "86";
    else   
        $arquitetura = "64";

    $biblioteca = "ACBrConsultaCNPJ" . $arquitetura . $extensao;

    $dllPath = __DIR__ . DIRECTORY_SEPARATOR . $biblioteca;

    if (file_exists($dllPath))
        return $dllPath;

    $dllPath = __DIR__ . DIRECTORY_SEPARATOR . "ACBrLib\\x" . $arquitetura . DIRECTORY_SEPARATOR . $biblioteca;

    if (file_exists($dllPath))
        return $dllPath;
    else {
        echo json_encode(["mensagem" => mb_convert_encoding("DLL n�o encontrada no caminho especificado: $dllPath", "UTF-8", "ISO-8859-1")]);
        return -10;
    }

    return $dllPath;
}

function CarregaImports(){
    $importsPath = __DIR__ . DIRECTORY_SEPARATOR . 'ACBrConsultaCNPJ.h';

    if (!file_exists($importsPath)) {
        echo json_encode(["mensagem" => mb_convert_encoding("Imports n�o encontrados no caminho especificado: $importsPath", "UTF-8", "ISO-8859-1")]);
        return -10;
    }

    return $importsPath;
}

function CarregaIniPath(){
    return __DIR__ . DIRECTORY_SEPARATOR . "ACBrConsultaCNPJ.INI";
}

function CarregaContents($importsPath, $dllPath){
    $ffi = FFI::cdef(
        file_get_contents($importsPath),
        $dllPath);

    return $ffi;
}

function Inicializar($ffi, $iniPath) {
    $retorno = $ffi->CNPJ_Inicializar($iniPath, "");
    $sMensagem = FFI::new("char[535]");

    if ($retorno !== 0) {
        echo json_encode(["mensagem" => mb_convert_encoding("Falha ao inicializar a biblioteca ACBr. C�digo de erro: $retorno", "UTF-8", "ISO-8859-1")]);
        return -10;
    }

    return 0;
}    

function Finalizar($ffi) {
    $retorno = $ffi->CNPJ_Finalizar();

    if ($retorno !== 0) {
        echo json_encode(["mensagem" => mb_convert_encoding("Falha ao finalizar a biblioteca ACBr. C�digo de erro: $retorno", "UTF-8", "ISO-8859-1")]);
        return -10;
    }

    return 0;
}    

function ConfigLerValor($ffi, $eSessao, $eChave, &$sValor){
    $sResposta = FFI::new("char[9048]");
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $retorno = $ffi->CNPJ_ConfigLerValor($eSessao, $eChave, $sResposta, FFI::addr($esTamanho));

    $sMensagem = FFI::new("char[535]");

    if ($retorno !== 0){
        if (UltimoRetorno($handle, $ffi, $retorno, $sMensagem, "Erro ao ler valor na secao[$eSessao] e chave[$eChave]. ", 1) != 0)
            return -10;
    }

    $sValor = FFI::string($sResposta);
    return 0;
}

function ConfigGravarValor($ffi, $eSessao, $eChave, $value){
    $retorno = $ffi->CNPJ_ConfigGravarValor($eSessao, $eChave, $value);
    $sMensagem = FFI::new("char[535]");

    if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao gravar valores [$value] na secao[$eSessao] e chave[$eChave]. ") != 0)
        return -10;

    return 0;
}

function UltimoRetorno($ffi, $retornolib, &$sMensagem, $msgErro, $retMensagem = 0) {
    if (($retornolib !== 0) || ($retMensagem == 1)) {
        $esTamanho = FFI::new("long");
        $esTamanho->cdata = 9048;
        $ffi->CNPJ_UltimoRetorno($sMensagem, FFI::addr($esTamanho));

        if ($retornolib !== 0){
            $ultimoRetorno = FFI::string($sMensagem);
            $retorno = "$msgErro C�digo de erro: $retornolib. ";
            
            $retorno = mb_convert_encoding($retorno, "UTF-8", "ISO-8859-1");
    
            if ($ultimoRetorno != "") {
                $retorno = $retorno . mb_convert_encoding("�ltimo retorno: ", "UTF-8", "ISO-8859-1") . $ultimoRetorno;
            }
        
            echo json_encode(["mensagem" => $retorno]);
            return -10;
        }
    }

    return 0;
}

function Consultar($ffi, $cnpj_valor, &$iniContent) {
    $sResposta = FFI::new("char[9048]");
    $esTamanho = FFI::new("long");
    $esTamanho->cdata = 9048;
    $retorno = $ffi->CNPJ_Consultar($cnpj_valor, $sResposta, FFI::addr($esTamanho));

    $sMensagem = FFI::new("char[535]");

    if ($retorno !== 0){
        if (UltimoRetorno($ffi, $retorno, $sMensagem, "Erro ao consultar o cnpj.", 1) != 0)
            return -10;
    }
    
    $iniContent = FFI::string($sResposta);
    return 0;
}    

function parseIniToStr($ini) {
    $lines = explode("\r\n", $ini);
    $config = [];
    $section = null;

    foreach ($lines as $line) {
        $line = trim($line);

        if ($line === '' || $line[0] === ';') {
            continue;
        }

        if ($line[0] === '[' && $line[-1] === ']') {
            $section = substr($line, 1, -1);
            $config[$section] = [];
        } else {
            list($key, $value) = explode('=', $line, 2);
            $key = trim($key);
            $value = trim($value);

            if ($section) {
                $config[$section][$key] = $value;
            } else {
                $config[$key] = $value;
            }
        }
    }

    return $config;
}

?>