const path = require('path');
const os = require('os');
const ACBrLibCepMT = require('@projetoacbr/acbrlib-cep-node/dist/src').default
const acbrlibPath = path.resolve(__dirname, os.platform() === 'win32' ? 'ACBrCEP64.dll' : 'libacbrcep64.so')
const configPath = path.resolve(__dirname, 'config.ini')


const acbrlibCep = new ACBrLibCepMT(acbrlibPath, configPath, '')

try {
    acbrlibCep.inicializar()
    acbrlibCep.configGravarValor('CEP','WebService','3')
    acbrlibCep.configGravar()
    const cep = acbrlibCep.buscarPorCep('18270170')
    console.log(cep)
    acbrlibCep.finalizar()
} catch (error) {
    console.error(error)
}



