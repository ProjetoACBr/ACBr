# ACBrLib NFe Go Demo

Este projeto demonstra como utilizar a ACBrLib NFe em Go via cgo.

## Pré-requisitos

- Linux
- Go 1.18 ou superior
- ACBrLib NFe compilada (`libacbrnfe64.so`)
- Pasta `Schemas` e arquivo `cert.pfx` em `./data`
- Definir a variável de ambiente `PFX_PASS` com a senha do certificado

## Como obter a ACBrLib NFe (`.so`)

1. Baixe ou compile a ACBrLib NFe para Linux 64 bits.
2. Copie o arquivo `libacbrnfe64.so` para o diretório do projeto ou para um diretório do sistema acessível pelo linker.

## Preparando o ambiente

```bash
# Defina a senha do certificado
export PFX_PASS="sua_senha_do_certificado"

# Exporte o caminho da biblioteca compartilhada, se necessário
export LD_LIBRARY_PATH=$(pwd):$LD_LIBRARY_PATH

# Certifique-se de que os arquivos estejam presentes:
ls ./data/Schemas/NFe
ls ./data/cert.pfx
```

## Executando o projeto

```bash
go run nfe.go
```

## Observações

- O projeto utiliza cgo para integração com a biblioteca C.
- As configurações são gravadas em `acbrlib.ini`.
- O resultado das operações é exibido no terminal.

## LDFLAGS e CFLAGS para outros sistemas

Se estiver utilizando outro sistema operacional ou arquitetura, ajuste as diretivas cgo no início do arquivo `nfe.go` conforme necessário:

```go
/*
#cgo linux LDFLAGS: -lacbrnfe64 -L.
#cgo linux CFLAGS: -I.
#cgo windows LDFLAGS: -lacbrnfe64 -LC:/caminho/para/lib
#cgo windows CFLAGS: -IC:/caminho/para/include
*/
```

- **LDFLAGS**: Define o caminho e o nome da biblioteca compartilhada.
- **CFLAGS**: Define o caminho dos arquivos de cabeçalho (`.h`).

Consulte a documentação do seu sistema para ajustar os caminhos conforme necessário.

## Estrutura

- `nfe.go`: Código principal de exemplo.
- `data/`: Pasta com Schemas e certificado.
- `libacbrnfe64.so`: Biblioteca compartilhada da ACBrLib NFe.

