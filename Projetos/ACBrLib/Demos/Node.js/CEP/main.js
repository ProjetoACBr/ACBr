const path = require('path');
const os = require('os');


//Importa a biblioteca {ACBrLibCepMT}, note ACBrLibCepMT  é exportada como default

const ACBrLibCepMT = require('@projetoacbr/acbrlib-cep-node/dist/src').default

/** Informaçoes importantes sobre o uso da ACBrLibCepMT
 ** Windows: usar ACBrCEP64.dll MT CDECL
 ** Linux: usar libacbrcep64.so MT CDECL
 ** Sempre use path.resolve para evitar problemas com caminhos relativos
 ** **Nunca** use caminhos absolutos diretamente no código, por exemplo: *C:\ACBr\ACBrLib\ACBrCEP64.dll*<br/>
 ** ou *\/usr/local/lib/libacbrcep64.so*, isso prejudica a portabilidade do código

 ** lembre-se apenas é necessário instalar o pacote {@link https://www.npmjs.com/package/@projetoacbr/acbrlib-cep-node?activeTab=code | @projetoacbr/acbrlib-cep-node }
 ** a instalação desse pacote instala automaticamente suas dependências
 *
 ** evite conflitos com o koffi, remova qualquer outra versão do koffi instalada
 ** em caso de erros, remova a pasta node_modules e o package-lock.json e reinstale as dependências com 
 @example ```npm install @projetoacbr/acbrlib-cep-node```
 */


const acbrlibPath = path.resolve(__dirname, os.platform() === 'win32' ? 'ACBrCEP64.dll' : 'libacbrcep64.so')
const configPath = path.resolve(__dirname, 'acbrlib.ini')
const chaveCrypt = '' // Deixar vazio se não estiver usando criptografia

const acbrlibCep = new ACBrLibCepMT(acbrlibPath, configPath, chaveCrypt)

// Exemplo simples de uso da ACBrLibCep, somente o código essencial foi adicionado aqui
try {
    //inicializa a biblioteca, obrigatório antes de qualquer outra chamada
    acbrlibCep.inicializar()

    // configura webservice 3
    acbrlibCep.configGravarValor('CEP', 'WebService', '3')
    acbrlibCep.configGravar() //sempre grave as configurações após alterar

    // Busca o CEP
    let cep = acbrlibCep.buscarPorCep('18270170')
    console.log(cep)
} catch (error) {
    console.error(error)
} finally {
    // Finaliza a biblioteca
    if (acbrlibCep) acbrlibCep.finalizar()
}



