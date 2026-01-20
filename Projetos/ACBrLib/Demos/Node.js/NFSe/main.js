const path = require("path");
const os = require("os");
const dotenv = require('dotenv')

// ACBrLibNFSeMT é exportado como default
const ACBrLibNFSeMT = require("@projetoacbr/acbrlib-nfse-node/dist/src").default;

const { NFSeModoEnvio } = require("@projetoacbr/acbrlib-nfse-node/dist/src");



// define os caminhos para a lib e o arquivo de exemplo
// a (ACBrNFSe64.dll ou libacbrnfse64.so) devem estar na pasta lib
// a acbrlib é carrega de acordo com o sistema operacional
// para windows usar a versao 64 bits MT CDECL
// para Linux usar a versão console MT 64 bits

// docker: recomendado usar a versão ubuntu:noble (testado com sucesso)

// lembre-se de criar as pastas:
//  lib
//  data
//  data/config
//  data/notas
//  data/notas/rps
// data/notas/nfse
//  data/pdf
//  data/cert
//  data/log

// copie arquivo ACBrNFSeXServicos.ini para a pasta data/config
// copie a pasta Schemas para a pasta data/Schemas


const pathACBrLibNFSe = path.resolve(__dirname, 'lib', os.platform() === 'win32' ? 'ACBrNFSe64.dll' : 'libacbrnfse64.so');
const eArqConfig = path.resolve(__dirname, "data", "config", "acbrlib.ini");
const logPath = path.resolve(__dirname, "data", "log");
const eChaveCrypt = "";
const pathCert = path.resolve(__dirname, "data", "cert", "cert.pfx");
const pathSchemas = path.join(__dirname, "data", "Schemas", "NFSe");
const pathGeral = path.resolve(__dirname, "data", "notas");
const pathRps = path.resolve(__dirname, "data", "notas", "rps");
const pathNFse = path.resolve(__dirname, "data", "notas", "nfse");
const pathIniServicos = path.resolve(__dirname, "data", "config", "ACBrNFSeXServicos.ini");
const dotenvPath = path.resolve(__dirname, '.env')

let tipoResposta = 2
let codigoMunicipio = "3531902";
let layoutNFSe = 0;
let ambienteDeEmissao = 0;
let nfse = new ACBrLibNFSeMT(pathACBrLibNFSe, eArqConfig, eChaveCrypt);

let inicio = 2;

/**
 * Configura as sessões e valores específicos para NFSe
 */

function configuraSecaoNFSe() {


  let emitenteUser = process.env.EMITENTE_USER;
  let emitentePassword = process.env.EMITENTE_PASSWORD;


  nfse.configGravarValor("NFSe", "PathSchemas", pathSchemas);

  nfse.configGravarValor("NFSe", "IniServicos", pathIniServicos);

  nfse.configGravarValor("NFSe", "CodigoMunicipio", codigoMunicipio);

  nfse.configGravarValor("NFSe", "Ambiente", ambienteDeEmissao.toString()); //0 produção 1 homologação

  nfse.configGravarValor("NFSe", "LayoutNFSe", layoutNFSe.toString());

  nfse.configGravarValor("NFSe", "PathSalvar", pathGeral);

  nfse.configGravarValor("NFSe", "PathGer", pathGeral);

  nfse.configGravarValor("NFSe", "PathRps", pathRps);

  nfse.configGravarValor("NFSe", "PathNFSe", pathNFse);

  nfse.configGravarValor("NFSe", "Emitente.WSUser", emitenteUser);

  nfse.configGravarValor("NFSe", "Emitente.WSSenha", emitentePassword);



}

function configuraSecaoDFe() {
  let senha = process.env.PFX_PASSWORD;

  inicio = nfse.configGravarValor("DFe", "ArquivoPFX", pathCert);

  inicio = nfse.configGravarValor("DFe", "Senha", senha);

  nfse.configGravarValor("DFe", "SSLCryptLib", "1")

  nfse.configGravarValor("DFe", "SSLHttpLib", "3")

  nfse.configGravarValor("DFe", "SSLXmlSignLib", "4")

}


/** * 
 * Função para configurar a seção Principal
 */

function configuraSecaoPrincipal() {
 
  nfse.configGravarValor("Principal", "LogPath", logPath);

  nfse.configGravarValor("Principal", "TipoResposta", tipoResposta.toString());
}


/**
 * Função para configurar a biblioteca NFSe
 */
function aplicarConfiguracoes() {

  configuraSecaoPrincipal();

  configuraSecaoDFe()

  configuraSecaoNFSe();

  nfse.configGravar()
}


/**
 * Função para emitir NFSe a partir de um arquivo INI
 * Como emitir: https://acbr.sourceforge.io/ACBrLib/ComoemitirumaNFSe.html
 */
function emitirNFSeDeUmArquivoIni() {
  try {

    inicio = nfse.inicializar();
    console.log(`iniciou >>>>>>> ${inicio}`);

    aplicarConfiguracoes();
    //
    let modoEnvio = NFSeModoEnvio.UNITARIO;

    let informacoesProvedor = nfse.obterInformacoesProvedor();

    let inputIniRps = path.resolve(__dirname, "data", "notas", "NFSe_Layout_ABRASF.ini")

    let resultConsulta = ""

    let numeroLote = "12"

    let resultadoEmissao = ""

    let resultadoEmissaoJSON = {}

    nfse.limparLista();

    nfse.carregarINI(inputIniRps);

    console.log("Informacoes do Provedor:\n", JSON.parse(informacoesProvedor));

    resultadoEmissao = nfse.emitir(numeroLote, modoEnvio, false);
    resultadoEmissaoJSON = JSON.parse(resultadoEmissao);

    console.log("Resultado da Emissão:\n", resultadoEmissaoJSON);

    resultConsulta = nfse.consultarLoteRPS(resultadoEmissao.Protocolo, numeroLote)

    console.log("Resultado da Consulta do Lote RPS:");
    console.log(JSON.parse(resultConsulta));

  } catch (error) {
    console.error("Erro:", error);
  }
  finally {
    nfse.finalizar();
  }

}

dotenv.config({ path: dotenvPath })
emitirNFSeDeUmArquivoIni();


