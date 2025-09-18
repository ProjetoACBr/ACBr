package main

/*
#cgo LDFLAGS: -lacbrnfe64 -L.
#cgo CFLAGS: -I.
#include <stdio.h>
#include <stdlib.h>
#include "nfe.h"
*/
import "C"
import (
	"fmt"
	"unsafe"
)

// aplica as configuracoes necessarias para o funcionamento da lib
// nesse exemplo, apenas a sessao principal
// mas poderia ser qualquer outra sessao
// como por exemplo a sessao NFE,DFE ...
func configurarSessaoPrincipal(handle unsafe.Pointer) {
	if handle == nil {
		return
	}

	// configura sessao principal

	//configura logPath
	C.NFE_ConfigGravarValor(handle, C.CString("Principal"), C.CString("LogPath"), C.CString("./"))

	//configura logNivel
	C.NFE_ConfigGravarValor(handle, C.CString("Principal"), C.CString("LogNivel"), C.CString("4"))

}

// lembre-se copiar a pasta Schemas para data
// copie o cert.pfx para data
// e defina a variavel de ambiente PFX_PASS com a senha
func configurarSessaoNFE(handle unsafe.Pointer) {
	if handle == nil {
		return
	}

	C.NFE_ConfigGravarValor(handle, C.CString("NFE"), C.CString("PathSchemas"), C.CString("./data/Schemas/NFe"))

	//ambiente homologacao
	C.NFE_ConfigGravarValor(handle, C.CString("NFE"), C.CString("Ambiente"), C.CString("1"))

	C.NFE_ConfigGravarValor(handle, C.CString("NFE"), C.CString("PathSalvar"), C.CString("/tmp"))
	C.NFE_ConfigGravarValor(handle, C.CString("NFE"), C.CString("Timeout"), C.CString("600"))

}

func configurarSessaoDFe(handle unsafe.Pointer) {
	if handle == nil {
		return
	}

	// Obtém a senha do certificado por variável de ambiente

	// para fins didaticos funcionaria também
	// data := C.CString("123456")
	var data *C.char = nil
	data = (*C.char)(C.getenv(C.CString("PFX_PASS")))

	status := C.NFE_ConfigGravarValor(handle, C.CString("DFe"), C.CString("SSLCryptLib"), C.CString("1"))
	//fmt.Printf("status SSLCryptLib  = %d\n", int(status))

	status = C.NFE_ConfigGravarValor(handle, C.CString("DFe"), C.CString("SSLHttpLib"), C.CString("3"))
	//fmt.Printf("status SSLHttpLib  = %d\n", int(status))

	status = C.NFE_ConfigGravarValor(handle, C.CString("DFe"), C.CString("SSLXmlSignLib"), C.CString("4"))
	//fmt.Printf("status SSLXmlSignLib  = %d\n", int(status))

	status = C.NFE_ConfigGravarValor(handle, C.CString("DFe"), C.CString("ArquivoPFX"), C.CString("./data/cert.pfx"))
	fmt.Printf("status pfx  = %d\n", int(status))

	status = C.NFE_ConfigGravarValor(handle, C.CString("DFe"), C.CString("Senha"), (*C.char)(data))
	fmt.Printf("status senha pfx  = %d\n", int(status))

}

func configuraSessaoDANFE(handle unsafe.Pointer) {
	if handle == nil {
		return
	}
	C.NFE_ConfigGravarValor(handle, C.CString("DANFE"), C.CString("PathPDF"), C.CString("/tmp"))
}

func aplicarConfiguracoes(handle unsafe.Pointer) {
	if handle == nil {
		return
	}

	configurarSessaoPrincipal(handle)
	configurarSessaoNFE(handle)
	configurarSessaoDFe(handle)
	configuraSessaoDANFE(handle)

	// salva as configuracoes no arquivo de configuracao
	C.NFE_ConfigGravar(handle, C.CString("./acbrlib.ini"))

}

func main() {
	var handle unsafe.Pointer = nil

	// define um ponteiro para array de char, char * (string em C)
	// e um inteiro (int) para o tamanho do bufferResposta
	// o bufferResposta sera alocado usando malloc()
	// o size sera usado para informar o tamanho do bufferResposta alocado
	// e receber o tamanho do conteudo retornado pela funcao
	var bufferResposta *C.char = nil

	tamanhoBuffer := C.int(100)

	//aloca um string usando malloc()
	bufferResposta = (*C.char)(C.malloc(C.size_t(tamanhoBuffer)))

	configFile := C.CString("./acbrlib.ini")
	chaveCrypt := C.CString("")

	status := C.NFE_Inicializar(&handle, configFile, chaveCrypt)
	fmt.Println("Result:", status)

	aplicarConfiguracoes(handle)

	// exemplo de uso da funcao NFE_StatusServico
	// para servir de exemplo de uso do buffer alocado e do size

	status = C.NFE_StatusServico(handle, bufferResposta, &tamanhoBuffer)
	fmt.Println("StatusServico:", status)
	fmt.Println("Tamanho:", int(tamanhoBuffer))
	fmt.Println("Conteudo:", C.GoString(bufferResposta))
	status = C.NFE_Finalizar(handle)
	fmt.Println("Result:", status)

	//liberando memoria alocada
	C.free(unsafe.Pointer(bufferResposta))
	C.free(unsafe.Pointer(configFile))
	C.free(unsafe.Pointer(chaveCrypt))

	//sempre aponte as variaveis liberadas para NULL
	configFile = nil
	chaveCrypt = nil
	bufferResposta = nil
	handle = nil

}
