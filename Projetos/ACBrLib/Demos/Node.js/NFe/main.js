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
const ACBrLibNFeMT = require('@projetoacbr/acbrlib-nfe-node/dist/src').default;


// define os caminhos para a lib e o arquivo de exemplo
// a dll ou so devem estar na pasta lib
// a acbrlib (dll ou so) é carrega de acordo com o sistema operacional
// para windows usar a versao 64 bits MT CDECL
// outra observação importante para windows: colocar as dlls de dependências (libxml2, openssl) na mesma pasta  do executável do node 
// para Linux usar a versão console MT 64 bits

// docker: recomendado usar a versão ubuntu:noble (testado com sucesso)

//obsevações importantes para usuários linux:
// instalar o pacote nodejs oficial do ubuntu (ou debian) ue npm
// podem ocorrer falhas de segmentação se usar o pacote do repositório oficial do nodejs
// isso porque o nodejs oficial é compilado com openssl estático e pode entrar em conflito com a lib openssl usada pela ACBrLibNFe
// sudo apt install nodejs npm

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



let pathACBrLibNFe = path.resolve(__dirname, 'lib', os.platform() === 'win32' ? 'ACBrNFe64.dll' : 'libacbrnfe64.so');
let pathExemploNotaXML = path.resolve(__dirname, 'data', 'notas', 'nota-nfe.xml');
let eArqConfig = path.resolve(__dirname, 'data', 'config', 'acbrlib.ini');
let eChaveCrypt = '';
let acbrNFe = new ACBrLibNFeMT(pathACBrLibNFe, eArqConfig, eChaveCrypt);


/**
 * Função para configurar a sessão DANFE
 */
function configuraSessaoDANFE() {
  acbrNFe.configGravarValor("DANFE", "PathPDF", path.resolve(__dirname, 'data', 'pdf'))

  //configura o tipo de DANFE


  //0 = tiSemGeracao
  //1 = tiRetrato
  //2 = tiPaisagem
  //3 = tiSimplificado
  //4 = tiNFCe
  //5 = tiMsgEletronica

  // lembre-se de descomentar a linha abaixo para definir o tipo de DANFE desejado

  // por exemplo, para NFCe, use : acbrNFe.configGravarValor("DANFE", "TipoDANFE", "4") 
  // acbrNFe.configGravarValor("DANFE", "TipoDANFE", "0")

}

/**
 * Função para configurar a sessão NFe
 */
function configuraSessaoNFe() {

  //configurar schemas 
  acbrNFe.configGravarValor("NFE", "PathSchemas", path.resolve(__dirname, 'data', 'Schemas', 'NFe'))
  acbrNFe.configGravarValor("NFE", "PathSalvar", path.resolve(__dirname, 'data', 'notas'));

  //seta ambiente de homologação
  acbrNFe.configGravarValor("NFE", "Ambiente", "1")

  //seta o modelo da NFe
  // O é NFe
  // 1 é NFCe
  // em breve será disponibiizado um enumerado para esses valores
  //acbrNFe.configGravarValor("NFE", "ModeloDF", "0")

}



/**
 * Função para configurar a sessão DFe
 */
function configuraSessaoDFe() {

  //tenta ler a senha do pfx a partir da var de ambiente PFX_PASSWORD
  // PFX_PASSWORD deve ser definida no arquivo .env na raiz do projeto
  // evite deixar a senha hardcoded no código fonte

  let senhaPFX = process.env.PFX_PASSWORD;


  //configuração para usar a lib de criptografia openssl
  acbrNFe.configGravarValor("DFe", "SSLCryptLib", "1")
  //configuração API de comunicação com a openssl
  acbrNFe.configGravarValor("DFe", "SSLHttpLib", "3")

  //configuração para usar a libxml2
  acbrNFe.configGravarValor("DFe", "SSLXmlSignLib", "4")

  acbrNFe.configGravarValor('DFe', 'ArquivoPFX', path.resolve(__dirname, 'data', 'cert', 'cert.pfx'))
  acbrNFe.configGravarValor('DFe', 'Senha', senhaPFX)
}


/**
 * Função para configurar a sessão principal
 */
function configuraSessaoPrincipal() {
  acbrNFe.configGravarValor('Principal', 'LogPath', path.resolve(__dirname, 'data', 'log'))
  acbrNFe.configGravarValor('Principal', 'LogNivel', '4')
}

/**
 * Função para aplicar as configurações no arquivo de configuração da biblioteca
 * cada função chamdada aqui configura uma sessão da biblioteca
 */
function aplicarConfiguracoes() {
  configuraSessaoPrincipal()
  configuraSessaoDFe()
  configuraSessaoNFe()
  configuraSessaoDANFE()

  acbrNFe.configGravar(eArqConfig)
}


dotenv.config({ path: path.resolve(__dirname, '.env') })

try {
  acbrNFe.inicializar()

  aplicarConfiguracoes()


  acbrNFe.carregarXML(pathExemploNotaXML)


  // mais informações sobre fluxo de emissao de NFe: https://acbr.sourceforge.io/ACBrLib/ComoemitirumaNFeouNFCe.html

  acbrNFe.assinar()

  acbrNFe.validar()

  acbrNFe.obterXml(0)

  // acbrNFe.enviar()

  //evite consultar status antes de enviar alguma nota
  // isso pode causar rejeição por consumo indevido do serviço

  console.log(acbrNFe.statusServico())
  //console.log(acbrNFe.openSslInfo())

} catch (error) {
  console.error(error)
} finally {
  // Finaliza a biblioteca
  //liberar os recursos alocados pela biblioteca
  if (acbrNFe) {

    acbrNFe.finalizar()
    //obsevação para typescript: ao declarar a variavel com using o dispose é chamado automaticamente
    // nesse caso o symbol.dispose() não é necessário
    // o Symbol.dispose]() chama o método finalizar internamente
   //acbrNFe[Symbol.dispose]()
    acbrNFe = null
  }

}