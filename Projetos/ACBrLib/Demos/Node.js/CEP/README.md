# 🚀 Demo ACBrLibCEP Node

[![Node.js](https://img.shields.io/badge/Node.js-22+-green.svg)](https://nodejs.org/)
[![NPM](https://img.shields.io/badge/NPM-@projetoacbr/acbrlib--cep--node-blue.svg)](https://www.npmjs.com/package/@projetoacbr/acbrlib-cep-node)
[![ACBrLib](https://img.shields.io/badge/ACBrLib-CEP-orange.svg)](https://acbr.sourceforge.io/)
[![License](https://img.shields.io/badge/License-LGPL--2.1-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows-blue.svg)](https://nodejs.org/)

> 📍 Este projeto demonstra o uso da biblioteca [`@projetoacbr/acbrlib-cep-node`](https://www.npmjs.com/package/@projetoacbr/acbrlib-cep-node) para consulta de CEPs via Node.js.

## 🚀 Como usar

### 1️⃣ Instale as dependências

```bash
npm install
```

### 2️⃣ Prepare a estrutura de pastas

```
📦 CEP/
├── 📄 main.js
├── ⚙️ acbrlib.ini
├── 🔧 libacbrcep64.so (Linux) ou ACBrCEP64.dll (Windows)
└── 📂 node_modules/
```

> 📋 **Importante**: Copie a biblioteca `libacbrcep64.so` (Linux) ou `ACBrCEP64.dll` (Windows) para a **raiz** do projeto CEP.

### 3️⃣ Execute o exemplo

```bash
node main.js
```

> ⚠️ **Windows**: Use biblioteca CDECL MT (64 bits)

---

<div align="center">
  <p>Feito com ❤️ pela equipe Projeto ACBr</p>
  🌐 <a href="https://projetoacbr.com.br">Projeto ACBr</a>
</div>