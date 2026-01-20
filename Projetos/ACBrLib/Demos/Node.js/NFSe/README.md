# 🚀 Demo ACBrLibNFSe Node

[![Node.js](https://img.shields.io/badge/Node.js-22+-green.svg)](https://nodejs.org/)
[![NPM](https://img.shields.io/badge/NPM-@projetoacbr/acbrlib--nfse--node-blue.svg)](https://www.npmjs.com/package/@projetoacbr/acbrlib-nfse-node)
[![ACBrLib](https://img.shields.io/badge/ACBrLib-NFSe-orange.svg)](https://acbr.sourceforge.io/)
[![License](https://img.shields.io/badge/License-LGPL--2.1-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows-blue.svg)](https://nodejs.org/)

> 🏢 Este projeto demonstra o uso da biblioteca [`@projetoacbr/acbrlib-nfse-node`](https://www.npmjs.com/package/@projetoacbr/acbrlib-nfse-node) para emissão e gestão de Notas Fiscais de Serviços Eletrônicas via Node.js.

## 🚀 Como usar

### 1️⃣ Instale as dependências

```bash
npm install
```

### 2️⃣ Prepare a estrutura de pastas

```
📦 NFSe/
├── 📄 main.js
├── 📂 lib/
│   └── 🔧 libacbrnfse64.so (Linux) ou ACBrLibNFSe64.dll (Windows)
├── 📂 data/
│   ├── ⚙️ config/
│   │   ├── 📄 acbrlib.ini
│   │   └── 📄 ACBrNFSeXServicos.ini
│   ├── 📂 cert/
│   │   └── 🔐 cert.pfx
│   ├── 📂 notas/
│   ├── 📂 pdf/
│   ├── 📂 log/
│   └── 📂 Schemas/
│       └── 📂 NFSe/
└── 📂 node_modules/
```

> 📋 **Importante**: Copie a biblioteca `libacbrnfse64.so` (Linux) ou `ACBrLibNFSe64.dll` (Windows) para a pasta **lib/** do projeto NFSe.

> 🔐 **Certificado**: Copie o arquivo `cert.pfx` para a pasta **data/cert/** do projeto NFSe.

### 3️⃣ Configure as credenciais

Crie um arquivo `.env` na raiz do projeto com as credenciais :
Senha do certificado e usuário e senha do Webservice

```env
# 🔑 Senha do certificado digital
PFX_PASSWORD=SuaSenhaDoCertificado
EMITENTE_USER=usario
EMITENTE_PASSWORD=senha
```

### 4️⃣ Execute o exemplo

```bash
node main.js
```

> ⚠️ **Windows**: Use biblioteca CDECL MT (64 bits)

---

<div align="center">
  <p>Feito com ❤️ pela equipe Projeto ACBr</p>
  🌐 <a href="https://projetoacbr.com.br">Projeto ACBr</a>
</div>