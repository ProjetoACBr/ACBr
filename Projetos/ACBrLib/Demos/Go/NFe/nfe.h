#include <stdio.h>
#include <stdlib.h>


#ifndef NFE_H
#define NFE_H
    int NFE_Inicializar(void ** plibHandle, const char * arquivoConfig, const char * chaveCrypt);
    int NFE_Finalizar(void * plibHandle);
    int NFE_ConfigLer(void * handle,const char * eArqConfig);
    int NFE_ConfigLerValor(void *handle,const char * eSessao, const char * eChave, char * sValor, int * esTamanho);
    int NFE_ConfigGravarValor(void * handle,const char * eSessao, const char * eChave, char * sValor);
    int NFE_UltimoRetorno(void *handle, char * sMensagem, int * sTamanho);
    int NFE_Nome(void *handle, char * sNome, int * esTamanho);
    int NFE_Versao(void *handle, char * sVersao, int * esTamanho);
    int NFE_ConfigImportar(void * handle, const char * eArqConfig);
    int NFE_ConfigExportar(void *handle, char * sMensagem, int * esTamanho);
    int NFE_ConfigGravar(void *handle, const char * eArqConfig);
    int NFE_OpenSSLInfo(void *handle, char * sOpenSslInfo, int * esTamanho);
    int NFE_StatusServico(void *handle,char * buffer, int * esTamanho);
    int NFE_ValidarRegrasdeNegocios(void * handle, char * resposta, int * tamanho);
    int NFE_CarregarXML(void * handle, const char * eArquivoOuXML);

#endif //NFE_H
