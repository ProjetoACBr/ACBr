# 🚀 Demo ACBrLibReinf Node

[![Node.js](https://img.shields.io/badge/Node.js-22+-green.svg)](https://nodejs.org/)
[![NPM](https://img.shields.io/badge/NPM-@projetoacbr/acbrlib--reinf--node-blue.svg)](https://www.npmjs.com/package/@projetoacbr/acbrlib-reinf-node)
[![ACBrLib](https://img.shields.io/badge/ACBrLib-Reinf-orange.svg)](https://acbr.sourceforge.io/)
[![License](https://img.shields.io/badge/License-LGPL--2.1-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows-blue.svg)](https://nodejs.org/)

> 📊 Este projeto demonstra o uso da biblioteca [`@projetoacbr/acbrlib-reinf-node`](https://www.npmjs.com/package/@projetoacbr/acbrlib-reinf-node) para transmissão de eventos do eSocial-Reinf via Node.js.

## 🚀 Como usar

### 1️⃣ Instale as dependências

```bash
npm install
```

### 2️⃣ Prepare a estrutura de pastas

```
📦 Reinf/
├── 📄 main.js
├── 📂 lib/
│   └── 🔧 libacbrreinf64.so (Linux) ou ACBrReinf64.dll (Windows)
├── 📂 data/
│   ├── ⚙️ config/
│   │   ├── 📄 acbrlib.ini
│   │   └── 📄 ACBrReinfServicos.ini
│   ├── 📂 cert/
│   │   └── 🔐 cert.pfx
│   ├── 📂 notas/
│   ├── 📂 Retorno/
│   ├── 📂 log/
│   └── 📂 Schemas/
│       └── 📂 Reinf/
└── 📂 node_modules/
```

> 📋 **Importante**: Copie a biblioteca `libacbrreinf64.so` (Linux) ou `ACBrReinf64.dll` (Windows) para a pasta **lib/** do projeto Reinf.

> 🔐 **Certificado**: Copie o arquivo `cert.pfx` para a pasta **data/cert/** do projeto Reinf.

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

## 📋 Funcionalidades Demonstradas

O exemplo inclui configurações para:

- **DFe**: Configuração do certificado digital
- **Reinf**: Configuração do ambiente, versão DF, paths e timeouts
- **Principal**: Configuração de logs

### 🔧 Exemplos de Uso Disponíveis

O código inclui exemplos comentados para:

- **Limpeza**: `acbrReinf.limparReinf()`
- **Criação e Envio**: 
  - Método separado: `criarEventoReinf()` + `enviarReinf()`
  - Método único: `criarEnviarReinf()`
- **Consultas**:
  - Consulta de protocolo: `consultarReinf()`
  - Consulta de recibo: `consultarReciboReinf()`

## ⚙️ Configurações

### Ambiente
- **Produção**: `Ambiente = 0`
- **Homologação**: `Ambiente = 1` (padrão no exemplo)

### Versão DF
- **Versão 6**: Configurada por padrão

### Paths Configurados
- **Schemas**: `data/Schemas/Reinf`
- **Salvar**: `data/notas`
- **Retorno**: `data/Retorno`
- **Logs**: `data/log`

---

<div align="center">
  <p>Feito com ❤️ pela equipe Projeto ACBr</p>
  🌐 <a href="https://projetoacbr.com.br">Projeto ACBr</a>
</div>
