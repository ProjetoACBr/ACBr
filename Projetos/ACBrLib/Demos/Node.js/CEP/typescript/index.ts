import path from "path";
import os from 'os';
import { fileURLToPath } from "url";

// Importa a biblioteca ACBrLibCepMT como ES Module
import ACBrLibCepMT from "@projetoacbr/acbrlib-cep-node/dist/src/index.js";

// __dirname não está disponível em módulos ES, então precisamos defini-lo manualmente

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Define os caminhos para a DLL e o arquivo INI usando path.resolve


const pathACBrLib = path.resolve(__dirname, os.platform() === 'win32' ? 'ACBrCEP64.dll' : 'libacbrcep64.so');
const pathACBrLibIni = path.resolve(__dirname, 'ACBrLib.ini');
const chaveCrypt = "";

// para usar o construtor da classe ACBrLibCepMT em ESM devemos usar ACBrLibCepMT.default
let cep: ACBrLibCepMT.default = new ACBrLibCepMT.default(pathACBrLib, pathACBrLibIni, chaveCrypt);
let result = ""
try {

    cep.inicializar();
    // Configura o WebService para Republica Virtual (3)
    cep.configGravarValor("CEP", "WebService", "3");
    cep.configGravar()
    result = cep.buscarPorCep("18270170")
    console.log(result);
} catch (e) {
    console.log("Erro: " + e);
} finally {
    cep.finalizar();
}
