# 🚀 Demo ACBrLibNFe Node

[![Node.js](https://img.shields.io/badge/Node.js-22+-green.svg)](https://nodejs.org/)
[![NPM](https://img.shields.io/badge/NPM-@projetoacbr/acbrlib--nfe--node-blue.svg)](https://www.npmjs.com/package/@projetoacbr/acbrlib-nfe-node)
[![ACBrLib](https://img.shields.io/badge/ACBrLib-NFe-orange.svg)](https://acbr.sourceforge.io/)
[![License](https://img.shields.io/badge/License-LGPL--2.1-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows-blue.svg)](https://nodejs.org/)

> 📄 Este projeto demonstra o uso da biblioteca [`@projetoacbr/acbrlib-nfe-node`](https://www.npmjs.com/package/@projetoacbr/acbrlib-nfe-node) para emissão e gestão de Notas Fiscais Eletrônicas via Node.js.

## 🚀 Como usar

### 1️⃣ Instale as dependências

```bash
npm install
```

### 2️⃣ Prepare a estrutura de pastas

```
📦 NFe/
├── 📄 main.js
├── 📂 lib/
│   └── 🔧 libacbrnfe64.so (Linux) ou ACBrNFe64.dll (Windows)
├── 📂 data/
│   ├── ⚙️ config/
│   │   └── 📄 acbrlib.ini
│   ├── 📂 cert/
│   │   └── 🔐 cert.pfx
│   ├── 📂 notas/
│   │   └── 📄 nota-nfe.xml
│   ├── 📂 pdf/
│   ├── 📂 log/
│   └── 📂 Schemas/
│       └── 📂 NFe/
└── 📂 node_modules/
```

> 📋 **Importante**: Copie a biblioteca `libacbrnfe64.so` (Linux) ou `ACBrNFe64.dll` (Windows) para a pasta **lib/** do projeto NFe.

> 🔐 **Certificado**: Copie o arquivo `cert.pfx` para a pasta **data/cert/** do projeto NFe.

### 3️⃣ Configure as credenciais

Crie um arquivo `.env` na raiz do projeto com as credenciais do certificado digital:

```env
# 🔑 Senha do certificado digital
PFX_PASSWORD=SuaSenhaDoCertificado
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