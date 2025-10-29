const os = require('os')
const fs = require('fs')
const path = require('path')
const dotenv = require('dotenv')

const ACBrLibPixCDMT = require('@projetoacbr/acbrlib-pixcd-node/dist/src').default
const { PSP } = require('@projetoacbr/acbrlib-pixcd-node/dist/src')
const acbrlibName = os.platform() === 'win32' ? 'ACBrPIXCD64.dll' : 'libacbrpixcd64.so'

const acbrLibPath = path.resolve(__dirname, 'libs', acbrlibName)
const dataPath = path.resolve(__dirname, 'data')
const acbrlibIni = path.resolve(__dirname, 'ACBrLib.ini')
const logPath = path.resolve(__dirname, 'logs')

const pathCobrancaImediadatIni = path.resolve(__dirname, "data", "exemploCobrancaImediata.ini")


/**
 * Configurações de sessão principal da ACBrLib
 * @param {ACBrLibPixCDMT} pixcd Objeto da biblioteca ACBrLibPixCD
*/
function configuraSessaoPrincipal(pixcd) {
    pixcd.configGravarValor("Principal", "LogPath", logPath)
    pixcd.configGravarValor("Principal", "LogNivel", "4")
}

/**
 * Cria as pastas necessárias para o funcionamento do app
 * Pastas: logs, data, libs
 */
function inicializaPastasDoApp() {
    let dirs = [logPath, dataPath, path.resolve(__dirname, 'libs')]
    dirs.forEach(dir => {
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true })
        }
    })
}


/**
 * Configurações de sessão PIXCD
 * 
 * @param {ACBrLibPixCDMT} pixcd Objeto da biblioteca ACBrLibPixCD
 ** PSP = Provedor de Serviços de Pagamento
 ** Para evitar expor credencias, crie um arquivo .env na raiz do projeto com as variáveis
 ** essas credenciais são fornecidas pelo PSP
 ** Lembre-se de adicionar o arquivo .env ao .gitignore
 *
 *  **Obs.:** Este é um exemplo **didático**. Em produção, use um método **seguro** para armazenar credenciais
 * 
 * @example .env
 * CLIENT_ID=SeuClientID
 * SECRET=SeuClientSecret 
 * APP_KEY=SuaAppKey
 * CHAVE_PIX=SuaChavePIX
 * NOME_RECEBEDOR=Nome do Recebedor
 * CIDADE_RECEBEDOR=Cidade do Recebedor
 * UF_RECEBEDOR=UF do Recebedor     
 *
*/

function configuraSessaoPIXCD(pixcd) {
    let psp = "BANCOBRASIL"
    pixcd.configGravarValor("PIXCD", "PSP", PSP.BANCO_DO_BRASIL.toString())
    pixcd.configGravarValor("PIXCD", "CidadeRecebedor", process.env.CIDADE_RECEBEDOR)
    pixcd.configGravarValor("PIXCD", "UFRecebedor", process.env.UF_RECEBEDOR)
    pixcd.configGravarValor("PIXCD", "NomeRecebedor", process.env.NOME_RECEBEDOR)

    //essas credenciais são fornecidas pelo PSP
    pixcd.configGravarValor(psp, "ClientID", process.env.CLIENT_ID)
    pixcd.configGravarValor(psp, "ClientSecret", process.env.SECRET)
    pixcd.configGravarValor(psp, "DeveloperApplicationKey", process.env.APP_KEY)
    pixcd.configGravarValor(psp, "ChavePIX", process.env.CHAVE_PIX)


    // novas aplicações usam A versão da api 2.0
    // no acbrlib.ini a propriedade é BBAPIVersao (padrão 0 = v1.0 e 1 = v2.0)
    pixcd.configGravarValor(psp, "BBAPIVersao", "1")


}

/**
 * Aplica todas as configurações em todas as sessões
 * @param {ACBrLibPixCDMT} pixcd Objeto da biblioteca ACBrLibPixCD<br/>
 * 
 * Referências:
 * * {@link https://acbr.sourceforge.io/ACBrLib/Geral.html| Configurações Gerais da ACBrLib}
 * * {@link https://acbr.sourceforge.io/ACBrLib/ConfiguracoesdaBiblioteca23.html| Configurações da ACBrLibPixCD}
 * * {@link https://acbr.sourceforge.io/ACBrLib/ExemplodeINI7.html| Exemplos de INI }
 */

function aplicarConfiguracoes(pixcd) {
    if (!pixcd) throw new Error('Objeto pixcd não foi inicializado')

    configuraSessaoPrincipal(pixcd)
    configuraSessaoPIXCD(pixcd)
    pixcd.configGravar()
}

/**
 * Gera um txId aleatório
 * @param {number} tamanho Tamanho do txId (padrão 26)
 * @returns {string} txId gerado
 */

function gerarTxId(tamanho = 26) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    let txId = ''
    for (let i = 0; i < tamanho; i++) {
        txId += chars.charAt(Math.floor(Math.random() * chars.length))
    }
    return txId
}

/**
 * Exemplo de criação de cobrança imediata
 */

function exemploCobrancaImediata() {
    let token = ''
    let txId = ''
    let result = ''
    let pixcd = new ACBrLibPixCDMT(acbrLibPath, acbrlibIni, '')

    console.log('Iniciando exemplo de cobrança imediata PIXCD')
    try {
        pixcd.inicializar()
        aplicarConfiguracoes(pixcd)

        // agora é possivel gerar token e informar token manualente (opcional)
        // lembrar de guardar em local seguro o token e a data de expiração
        //token = pixcd.gerarToken()

        //use o metodo abaixo para informar um token já existente
        //lembre-se de carregar seu token de um local seguro 
        //token = pixcd.informarToken(process.env.TOKEN, new Date()),// pixcd.gerarToken() 
        txId = gerarTxId(26)

        result = pixcd.criarCobrancaImediata(pathCobrancaImediadatIni, txId)

        console.log('Token Gerado: ', token)
        console.log('Resultado Criação Cobranca: ', result)
        console.log('txId Gerado: ', txId)

        // consultar o status da cobrança
        result = pixcd.consultarCobrancaImediata(txId, 0)
        console.log('Status da Cobranca: ', result)

    } catch (err) {
        console.error('Erro : ', err)
    } finally {
        //  ao finalizar o uso do pixcd, chamar o método finalizar
        // para liberar os recursos alocados pela biblioteca
        // alternativamente pode chamar pixcd[Symbol.dispose]()
        // typescript permite declarar com using (dispose automatico)

        if (pixcd) pixcd.finalizar()
    }
}


// carrega as variáveis de ambiente do arquivo .env
// nunca exporte variáveis sensíveis diretamente no código
// também não é recomendado usar variáveis de ambiente 
// no caso de docker: use secrets

dotenv.config({ path: path.resolve(__dirname, '.env') })

inicializaPastasDoApp()
exemploCobrancaImediata()