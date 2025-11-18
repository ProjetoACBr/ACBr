const path = require("path");
const os = require("os");
const dotenv = require('dotenv')

// ACBrLibNFSeMT é exportado como default
const ACBrLibNFSeMT = require("@projetoacbr/acbrlib-nfse-node/dist/src").default;



// define os caminhos para a lib e o arquivo de exemplo
// a (ACBrLibNFSe64.dll ou libacbrlibnfse64.so) devem estar na pasta lib
// a acbrlib é carrega de acordo com o sistema operacional
// para windows usar a versao 64 bits MT CDECL
// para Linux usar a versão console MT 64 bits

// docker: recomendado usar a versão ubuntu:noble (testado com sucesso)

// lembre-se de criar as pastas:
//  lib
//  data
//  data/config
//  data/notas
//  data/pdf
//  data/cert
//  data/log

// copie arquivo ACBrNFSeXServicos.ini para a pasta data/config
// copie a pasta Schemas para a pasta data/Schemas


const pathACBrLibNFSe = path.resolve(__dirname, 'lib', os.platform() === 'win32' ? 'ACBrNFSe64.dll' : 'libacbrnfse64.so');
const eArqConfig = path.resolve(__dirname, "data", "config", "acbrlib.ini");
const eChaveCrypt = "";
const pathCert = path.resolve(__dirname, "data", "cert", "cert.pfx");
const pathSchemas = path.join(__dirname, "data", "Schemas", "NFSe");
const pathIniServicos = path.resolve("data", "config", "ACBrNFSeXServicos.ini");
const dotenvPath = path.resolve(__dirname, '.env')
let codigoMunicipio = "3550308"; //exemplo de codigo de municipio de Sao Paulo/SP

let nfse = new ACBrLibNFSeMT(pathACBrLibNFSe, eArqConfig, eChaveCrypt);

let inicio = 2;


dotenv.config({ path: dotenvPath })
try {

  let senha = process.env.PFX_PASSWORD;
  inicio = nfse.inicializar();
  console.log(`iniciou >>>>>>> ${inicio}`);

  inicio = nfse.configGravarValor("DFe", "ArquivoPFX", pathCert);
  console.log(`Set Configurações ArquivoPFX ${inicio}`);

  inicio = nfse.configGravarValor("DFe", "Senha", senha);
  console.log(`Set Configurações sENHA ${inicio}`);

  inicio = nfse.configGravarValor("NFSe", "PathSchemas", pathSchemas);
  console.log(`Set Configurações PathSchemas ${inicio}`);

  inicio = nfse.configGravarValor("NFSe", "IniServicos", pathIniServicos);
  console.log(`Set Configurações IniServicos ${inicio}`);

  inicio = nfse.configGravarValor("NFSe", "CodigoMunicipio", codigoMunicipio);
  console.log(`Set Configurações CodigoMunicipio ${inicio}`);

  nfse.configGravar()

  inicio = nfse.emitir("55", 0, false);
  console.log(`NFSE_Emitir >>>>>>>> ${inicio}`);



  console.log(`NFSE_Emitir >>>>>>>> ${inicio}`);
} catch (error) {
  console.error("Erro:", error);
}
finally {
  nfse.finalizar();
}


