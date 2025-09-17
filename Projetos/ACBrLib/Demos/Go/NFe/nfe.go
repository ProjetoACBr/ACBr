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
	configFile := C.CString("./acbrlib.ini");
	chaveCrypt := C.CString("");

	result:= C.NFE_Inicializar(&handle, configFile,chaveCrypt);
	fmt.Println("Result:", result);

	result = C.NFE_Finalizar(handle);
	fmt.Println("Result:", result);
	handle = nil;

}