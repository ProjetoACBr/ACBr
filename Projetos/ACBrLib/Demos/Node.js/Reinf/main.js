// {******************************************************************************}
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

const path = require('path');
const os = require('os');
const ACBrLibReinfMT = require('@projetoacbr/acbrlib-reinf-node/dist/src').default;



let pathACBrLibReinf = path.resolve(__dirname, 'lib', os.platform() === 'win32' ? 'ACBrReinf64.dll' : 'libacbrreinf64debug.so');
let eArqConfig = path.resolve(__dirname, 'data', 'config', 'acbrlib.ini');
let eChaveCrypt = '';

let acbrReinf = new ACBrLibReinfMT(pathACBrLibReinf, eArqConfig, eChaveCrypt);


/**
 * Configura a sessão DFe
 */
function configuraSessaoDFe() {
  let senha = process.env.PFX_PASSWORD;
  acbrReinf.configGravarValor('DFe', 'ArquivoPFX', path.join(__dirname, 'data', 'cert', 'cert.pfx'));
  acbrReinf.configGravarValor('DFe', 'Senha', senha);
}

/**
 * Configura a sessão Reinf
 */
function configuraSessaoReinf() {
  acbrReinf.configGravarValor('Reinf', 'VersaoDF', '6');
  acbrReinf.configGravarValor('Reinf', 'Ambiente', '1');
  acbrReinf.configGravarValor('Reinf', 'SalvarArq', '1');
  acbrReinf.configGravarValor('Reinf', 'SalvarGer', '0');
  acbrReinf.configGravarValor('Reinf', 'SalvarWS', '1');
  acbrReinf.configGravarValor('Reinf', 'Timeout', '30000');
  acbrReinf.configGravarValor('Reinf', 'PathSchemas', path.resolve(__dirname, 'data', 'Schemas', 'Reinf'));
  acbrReinf.configGravarValor('Reinf', 'PathSalvar', path.resolve(__dirname, 'data', 'notas'));
  acbrReinf.configGravarValor('Reinf', 'PathReinf', path.resolve(__dirname, 'data', 'Retorno'));
  acbrReinf.configGravarValor('Reinf', 'IniServicos', path.resolve(__dirname, 'data', 'config', 'ACBrReinfServicos.ini'));
}

/**
 * Configura a sessão Principal
 */
function configuraSessaoPrincipal() {
  acbrReinf.configGravarValor('Principal', 'LogPath', path.resolve(__dirname, 'data', 'log'));
  acbrReinf.configGravarValor('Principal', 'LogNivel', '4');

}


/**
 * Aplica as configurações de todas as sessões
 */
function aplicarConfiguracoes() {
  configuraSessaoPrincipal();
  configuraSessaoDFe();
  configuraSessaoReinf();
  acbrReinf.configGravar();

}

let status  = -1;
try {


  status = acbrReinf.inicializar();
  console.log('Status da inicialização: ' + status);

  console.log('Aplicando configurações...');
  aplicarConfiguracoes();
  console.log('Configurações aplicadas com sucesso!');

  //* Exemplo de Limpeza
 // acbrReinf.limparReinf();

  /* Exemplo de Criacao e Envio em dois métodos
  acbrReinf.criarEventoReinf(path.join(__dirname, 'evento.ini'));
 
  acbrReinf.enviarReinf();
  //*/
  //* Exemplo de Criacao e Envio em método único
 // acbrReinf.criarEn2viarReinf(path.join(__dirname, 'evento.ini'));
  //*/
  /* Exemplo de Consulta de Protocolo
  acbrReinf.consultarReinf('2.202310.1234567');
  //*/
  /* Exemplo de Consulta de recibo
  acbrReinf.consultarReciboReinf('2023-09',1000,'12345678000195',
    '98765432000198','12345678000195','30/09/2023', '', '');
  //*/

}
catch (error) {
  console.error('Erro ' +error )
}
finally {
  if (status === 0) {
    status = acbrReinf.finalizar();
    console.log('Status da finalização: ' + status);
  }else{
    console.log('Erro na finalização: ' + acbrReinf.ultimoRetorno());
  }
}
