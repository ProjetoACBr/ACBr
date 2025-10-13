// {******************************************************************************}
// { Projeto: Componentes ACBr                                                    }
// {  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
// { mentos de Automação Comercial utilizados no Brasil                           }
// {                                                                              }
// { Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
// {                                                                              }
// { Colaboradores nesse arquivo: Daniel Oliveira Souza                           }
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
const dotenv = require('dotenv')

//importa a classe ACBrLibNFeMT
// a classe ACBrLibNFeMT é exportada como default 
const ACBrLibMDFeMT = require('@projetoacbr/acbrlib-mdfe-node/dist/src').default;


// define os caminhos para a lib e o arquivo de exemplo
// a dll ou so devem estar na pasta lib
// a acbrlib (dll ou so) é carrega de acordo com o sistema operacional
// para windows usar a versao 64 bits MT CDECL
// para Linux usar a versão console MT 64 bits

// docker: recomendado usar a versão ubuntu:noble (testado com sucesso)

// lembre-se de criar as pastas:
//  lib
//  data
//  data/config
//  data/notas
//  data/pdf
//  data/Schemas
//  data/cert
//  data/log


// e copiar o arquivo de exemplo nota-nfe.xml para a pasta data/notas
// e copiar o arquivo de exemplo cert.pfx para a pasta data/cert
// não esquecer de copiar o Schemas para a pasta data/
// usuarios do windows: devem colocar as dependencias junto com o executável do node
// usuarios do linux: devem configurar o link simbólico para libxml2
// e habilitar legacy providers no openssl
// mais informações: https://www.practicalnetworking.net/practical-tls/openssl-3-and-legacy-providers/



let pathACBrLibMDFe = path.resolve(__dirname, 'lib', os.platform() === 'win32' ? 'ACBrMDFe64.dll' : 'libacbrmdfe64.so');
let pathExemploNotaXML = path.resolve(__dirname, 'data', 'notas', 'mdfe.xml');
let eArqConfig = path.resolve(__dirname, 'data', 'config', 'acbrlib.ini');
let eChaveCrypt = '';
let acbrMDFe = new ACBrLibMDFeMT(pathACBrLibMDFe, eArqConfig, eChaveCrypt);


/**
 * Função para configurar a sessão DANFE
 */
function configuraSessaoDAMDFe() {
  acbrMDFe.configGravarValor("DAMDFe", "PathPDF", path.resolve(__dirname, 'data', 'pdf'))

}

/**
 * Função para configurar a sessão MDFe
 */
function configuraSessaoMDFe() {

  //configurar schemas 
  acbrMDFe.configGravarValor("MDFe", "PathSchemas", path.resolve(process.env.ACBR_HOME, 'Exemplos', 'ACBrDFe', 'Schemas', 'MDFe'))
  acbrMDFe.configGravarValor("MDFe", "PathSalvar", path.resolve(__dirname, 'data', 'notas'));

  //seta ambiente de homologação
  acbrMDFe.configGravarValor("MDFe", "Ambiente", "1")

}



/**
 * Função para configurar a sessão DFe
 */
function configuraSessaoDFe() {

  //tenta ler a senha do pfx a partir da var de ambiente PFX_PASSWORD
  // apenas para teste
  //não fazer isso em produção

  let senhaPFX = process.env.PFX_PASSWORD;


  //configuração para usar a lib de criptografia openssl
  acbrMDFe.configGravarValor("DFe", "SSLCryptLib", "1")
  //configuração API de comunicação com a openssl
  acbrMDFe.configGravarValor("DFe", "SSLHttpLib", "3")

  //configuração para usar a libxml2
  acbrMDFe.configGravarValor("DFe", "SSLXmlSignLib", "4")

  acbrMDFe.configGravarValor('DFe', 'ArquivoPFX', path.resolve(__dirname, 'data', 'cert', 'cert.pfx'))
  acbrMDFe.configGravarValor('DFe', 'Senha', senhaPFX)
}


/**
 * Função para configurar a sessão principal
 */
function configuraSessaoPrincipal() {
  acbrMDFe.configGravarValor('Principal', 'LogPath', path.resolve(__dirname, 'data', 'log'))
  acbrMDFe.configGravarValor('Principal', 'LogNivel', '4')
}

/**
 * Função para aplicar as configurações no arquivo de configuração da biblioteca
 * cada função chamdada aqui configura uma sessão da biblioteca
 */
function aplicarConfiguracoes() {
  configuraSessaoPrincipal()
  configuraSessaoDFe()
  configuraSessaoMDFe()
  configuraSessaoDAMDFe()

  acbrMDFe.configGravar()
}


dotenv.config({ path: path.resolve(__dirname, '.env') })



try {
  let pdfStream = ''
  acbrMDFe.inicializar()

  aplicarConfiguracoes()

  acbrMDFe.limparLista()
  acbrMDFe.carregarXML(pathExemploNotaXML)
  pdfStream = acbrMDFe.salvarPDF()

  console.log(pdfStream)

} catch (error) {
  console.error(error)

} finally {
  if (acbrMDFe) acbrMDFe.finalizar()
}