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

include 'ACBrConsultaCNPJ.php';

if (ValidaFFI() != 0)
    exit; 

$dllPath = CarregaDll();

if ($dllPath == -10)
    exit; 

$importsPath = CarregaImports();

if ($importsPath == -10)
    exit; 

$iniPath = CarregaIniPath();

$handle = FFI::new("uintptr_t");

try {
    $processo = "file_get_contents";
    $ffi = CarregaContents($importsPath, $dllPath);

    $prov = intval($_POST['prov']);
    $usuario = $_POST['usuario'];
    $senha = $_POST['senha'];
    
    $processo = "CNPJ_Inicializar";
    if (Inicializar($handle, $ffi, $iniPath) != 0) 
        exit;

    $processo = "CNPJ_ConfigGravarValor";
    if (ConfigGravarValor($handle, $ffi, "ConsultaCNPJ", "Provedor", (string)$prov) != 0) exit;
    if (ConfigGravarValor($handle, $ffi, "ConsultaCNPJ", "Usuario", (string)$usuario) != 0) exit;
    if (ConfigGravarValor($handle, $ffi, "ConsultaCNPJ", "Senha", (string)$senha) != 0) exit;
} catch (Exception $e) {
    $erro = $e->getMessage();
    echo json_encode(["mensagem" => mb_convert_encoding("Exce��o[$processo]: $erro", "UTF-8", "ISO-8859-1")]);
    exit;
}

try {
    if ($processo != "CNPJ_Inicializar") {
        $processo = "CNPJ_Finalizar";
        if (Finalizar($handle, $ffi) != 0) 
            exit;
    }
} catch (Exception $e) {
    $erro = $e->getMessage();
    echo json_encode(["mensagem" => mb_convert_encoding("Exce��o[$processo]: $erro", "UTF-8", "ISO-8859-1")]);
    exit;
}

echo json_encode(["mensagem" => mb_convert_encoding("Configura��es salvas com sucesso.", "UTF-8", "ISO-8859-1")]);
?>