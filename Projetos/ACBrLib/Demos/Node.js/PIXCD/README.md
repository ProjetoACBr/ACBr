# 🚀 Demo ACBrLibPixCD Node

[![Node.js](https://img.shields.io/badge/Node.js-22+-green.svg)](https://nodejs.org/)
[![NPM](https://img.shields.io/badge/NPM-@projetoacbr/acbrlib--pixcd--node-blue.svg)](https://www.npmjs.com/package/@projetoacbr/acbrlib-pixcd-node)
[![ACBrLib](https://img.shields.io/badge/ACBrLib-PIXCD-orange.svg)](https://acbr.sourceforge.io/)
[![License](https://img.shields.io/badge/License-LGPL--2.1-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows-blue.svg)](https://nodejs.org/)

> 📱 Este projeto demonstra o uso da biblioteca [`@projetoacbr/acbrlib-pixcd-node`](https://www.npmjs.com/package/@projetoacbr/acbrlib-pixcd-node) para integração com o sistema PIXCD via Node.js.
>
> ✅ Recomendação: utilize Node.js 22 (LTS) ou superior para melhor compatibilidade.

## ✨ Funcionalidades

- 🔧 **Configuração automática** da ACBrLib via arquivo INI e variáveis de ambiente
- 💰 **Geração de cobranças imediatas** PIX
- 📊 **Consulta do status** da cobrança
- 🔐 **Uso seguro de credenciais** via arquivo `.env`

## 📁 Estrutura do Projeto

```
📦 PIXCD/
├── 📄 index.js                           # Exemplo principal de uso da biblioteca
├── ⚙️ ACBrLib.ini                        # Arquivo de configuração da ACBrLib
├── 📂 data/
│   └── 📄 exemploCobrancaImediata.ini    # Exemplo de dados para cobrança imediata
├── 📂 libs/
│   └── 🔧 libacbrpixcd64.so             # Biblioteca nativa (Linux)
└── 📂 logs/                              # Diretório de logs gerados pela ACBrLib
```

## 🚀 Como usar

### 1️⃣ Instale as dependências

```bash
npm install
```

### 2️⃣ Configure as credenciais

Crie um arquivo `.env` na raiz do projeto com as credenciais fornecidas pelo PSP (Provedor de Serviços de Pagamento):

```env
# 🔑 Credenciais do PSP
CLIENT_ID=SeuClientID
SECRET=SeuClientSecret
APP_KEY=SuaAppKey

# 💳 Configurações PIX
CHAVE_PIX=SuaChavePIX
NOME_RECEBEDOR=Nome do Recebedor
CIDADE_RECEBEDOR=Cidade do Recebedor
UF_RECEBEDOR=UF do Recebedor

# 🎫 Token de acesso
TOKEN=SeuToken
```

### 3️⃣ Execute o exemplo

```bash
npm start
```

## 🖥️ Compatibilidade com Windows

> ⚠️ **Importante para usuários Windows**: Este projeto utiliza a biblioteca `libacbrpixcd64.so` (Linux). Para Windows, você deve usar a biblioteca `ACBrPIXCD64.dll` com convenção de chamada **cdecl**.

### 📋 Requisitos para Windows

- 🪟 **Windows 10/11** (64-bit)
- 📚 **Biblioteca ACBrLibPixCD** com convenção de chamada **cdecl**

### 📁 Estrutura para Windows

```
📦 PIXCD/
├── 📄 index.js
├── ⚙️ ACBrLib.ini
├── 📂 data/
│   └── 📄 exemploCobrancaImediata.ini
├── 📂 libs/
│   └── 🔧 ACBrPIXCD64.dll             # Biblioteca Windows (cdecl)
└── 📂 logs/
```

> 💡 **Dica**: Certifique-se de que a biblioteca Windows esteja compilada com convenção de chamada **cdecl** para compatibilidade com Node.js.

## 📄 Exemplo de INI de Cobrança Imediata

> Observações:
> - Substitua os valores do exemplo pelos dados reais da sua cobrança.
> - O devedor pode ser identificado por CPF ou CNPJ (utilize apenas um dos campos).

```ini
[CobSolicitada]
chave=<chavePIX de quem do recebedor>
solicitacaoPagador=Pagamento de conta
expiracao=3600
valorOriginal=100,00
modalidadeAlteracao=False
devedorCPF=12345678900
devedorCNPJ=12345678000190
devedorNome=João Silva


[infoAdicionais001]
nome=Observação
valor=Pagamento solicitado no dia 15/12/2023


[infoAdicionais002]
nome=Referência
valor=123456


```

## ⚠️ Observações Importantes

- 🚫 **Nunca** exponha credenciais diretamente no código
- 🔒 Adicione o arquivo `.env` ao `.gitignore` para evitar vazamento de informações sensíveis
- 🏭 Em produção, utilize métodos seguros para armazenamento de credenciais (ex: secrets do Docker/Kubernetes)

## 📚 Referências

- 📖 [Configurações Gerais da ACBrLib](https://acbr.sourceforge.io/ACBrLib/Geral.html)
- ⚙️ [Configurações da ACBrLibPixCD](https://acbr.sourceforge.io/ACBrLib/ConfiguracoesdaBiblioteca23.html)
- 📝 [Exemplos de INI](https://acbr.sourceforge.io/ACBrLib/ExemplodeINI7.html)
- 🔑 [Como solicitar credenciais e configurar PSPs](https://www.projetoacbr.com.br/forum/topic/68320-acbrpixcd-coo-solicitar-credenciais-e-configurar-psps-no-componente/) - Guia completo para obter credenciais de cada PSP

---

<div align="center">
  <p>Feito com ❤️ pela equipe Projeto ACBr</p> 🌐 <a href="https://projetoacbr.com.br">Projeto ACBr</a></p>
</div>