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
func main (){
	var handle  unsafe.Pointer = nil;
	size := C.int(100);
	// aloca buffer
	s := make([]byte, size);
	// ponteiro char * do s
	buffer := (*C.char) (unsafe.Pointer(&s[0])) ;


	configFile := C.CString("./acbrlib.ini");
	chaveCrypt := C.CString("");

	result := C.NFE_Inicializar(&handle, configFile,chaveCrypt);
	fmt.Println("Result:", result);

	// exemplo de uso da funcao NFE_Nome
	// para servir de exemplo de uso do buffer alocado e do size
	
	result = C.NFE_Nome(handle,  buffer, &size);
	fmt.Println("Result:", result, "Size:", size);
	fmt.Println("Name:", string(s));

	result = C.NFE_Finalizar(handle);
	fmt.Println("Result:", result);
	handle = nil;

}