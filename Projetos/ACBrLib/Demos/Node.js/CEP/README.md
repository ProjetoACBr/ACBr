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


### 2️⃣ Estrutura de pastas

```
📦 CEP/
├── javascript/
│   ├── main.js
│   ├── ACBrLib.ini
│   ├── lib_teste-acbrlibcep-mt.js
│   └── package.json
│
├── typescript/
│   ├── index.ts
│   ├── ACBrLib.ini
│   ├── package.json
│   ├── tsconfig.json
│   └── src/
│
├── README.md
└── ... (outros arquivos e pastas)
```

> 📋 **Importante**: Copie a biblioteca `libacbrcep64.so` (Linux) ou `ACBrCEP64.dll` (Windows) para a **raiz** do projeto CEP.

### 3️⃣ Execute o exemplo

```bash
node main.js
```

> ⚠️ **Windows**: Use biblioteca CDECL MT (64 bits)


## 🟦 Exemplo em TypeScript

O diretório `typescript/` contém um exemplo de uso da ACBrLibCEP com TypeScript, utilizando ES Module, baseado nas configurações padrão do TypeScript 5.9.3

> ℹ️ O arquivo `tsconfig.json` está configurado com `types: ["node"]` e `lib: ["esnext"]` para garantir compatibilidade com recursos modernos do Node.js e ECMAScript.

### 1️⃣ Instale as dependências

```bash
cd typescript
npm install
```

### 2️⃣ Compile o projeto

```bash
npx tsc
```

### 3️⃣ Execute o exemplo

```bash
node .
```

> 📋 **Importante**: Copie a biblioteca `libacbrcep64.so` (Linux) ou `ACBrCEP64.dll` (Windows) para a pasta `typescript/`.

O código principal está em [`typescript/index.ts`](typescript/index.ts), demonstrando a inicialização da biblioteca, configuração do WebService e consulta de CEP.

<div align="center">
  <p>Feito com ❤️ pela equipe Projeto ACBr</p>
  🌐 <a href="https://projetoacbr.com.br">Projeto ACBr</a>
</div>