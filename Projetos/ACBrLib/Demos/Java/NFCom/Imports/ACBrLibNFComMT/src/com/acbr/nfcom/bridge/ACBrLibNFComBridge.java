/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.acbr.nfcom.bridge;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Platform;
import com.sun.jna.Pointer;
import com.sun.jna.ptr.IntByReference;
import com.sun.jna.ptr.PointerByReference;
import java.nio.ByteBuffer;

/**
 * ACBrLibNFComBridge é a interface que mapeia os métodos nativos da ACBrLibNFCom Multi-Thread
 * @see <a href="https://acbr.sourceforge.io/ACBrLib/ACBrLibNFCom.html">Documentação ACBrLibNFCom</a>
 *
 */
public interface ACBrLibNFComBridge extends Library {

    static final ACBrLibNFComBridge INSTANCE = LibraryLoader.getInstance();

    class LibraryLoader {

        private static String library = "";
        private static ACBrLibNFComBridge instance = null;

        private static String getLibraryName() {
            if (library.isEmpty()) {
                if (Platform.isWindows()) {
                    library = Platform.is64Bit() ? "ACBrNFCom64" : "ACBrNFCom32";
                } else {
                    library = Platform.is64Bit() ? "acbrnfcom64" : "acbrnfcom32";
                }
            }
            return library;
        }

        public static ACBrLibNFComBridge getInstance() {
            if (instance == null) {
                instance = (ACBrLibNFComBridge) Native.synchronizedLibrary(
                        (Library) Native.load(getLibraryName(), ACBrLibNFComBridge.class));
            }

            return instance;
        }
    }

    int NFCom_Inicializar(PointerByReference handle, String eArqConfig, String eChaveCrypt);

    int NFCom_Finalizar(Pointer handle);

    int NFCom_Nome(Pointer handle, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_Versao(Pointer handle, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_OpenSSLInfo(Pointer handle, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_UltimoRetorno(Pointer handle, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_ConfigLer(Pointer handle, String eArqConfig);

    int NFCom_ConfigGravar(Pointer handle, String eArqConfig);

    int NFCom_ConfigLerValor(Pointer handle, String eSessao, String eChave, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_ConfigGravarValor(Pointer handle, String eSessao, String eChave, String valor);

    int NFCom_ConfigImportar(Pointer handle, String eArqConfig);

    int NFCom_ConfigExportar(Pointer handle, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_CarregarXML(Pointer handle, String eArquivoOuXML);

    int NFCom_CarregarINI(Pointer handle, String eArquivoOuINI);

    int NFCom_LimparLista(Pointer handle);

    int NFCom_LimparListaEventos(Pointer handle);

    int NFCom_Deletar(Pointer handle, int AIndex);

    int NFCom_Assinar(Pointer handle);

    int NFCom_VerificarAssinatura(Pointer handle);

    int NFCom_Validar(Pointer handle);

    int NFCom_ValidarRegrasdeNegocios(Pointer handle, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_Enviar(Pointer handle, int ALote, boolean AImprimir, boolean ASincrono, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_EnviarEvento(Pointer handle, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_Consultar(Pointer handle, String eChaveOuNFCom, boolean AExtrairEventos, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_Cancelar(Pointer handle, String eChaveOuNFCom, String eJustificativa, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_StatusServico(Pointer handlePointer, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_ObterXml(Pointer handle, int AIndex, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_GravarXml(Pointer handle, int AIndex, String eNomeArquivo, String ePathArquivo);

    int NFCom_GetPath(Pointer handle, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_GetPathEvento(Pointer handle, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_SetIdCSC(Pointer handle, String eIdCSC, String eCSC);

    int NFCom_ObterCertificados(Pointer handle, ByteBuffer buffer, IntByReference bufferSize);

    int NFCom_EnviarEmail(Pointer handle, String ePara, String eArquivoNFCom, boolean AEnviaPDF, String eAssunto, String eCC,
            String eAnexos, String eMensagem);

    int NFCom_EnviarEmailEvento(Pointer handle, String ePara, String eArquivoXmlEvento, String eArquivoXmlNFCom, boolean AEnviaPDF,
            String eAssunto, String eCC, String eAnexos, String eMensagem);

    int NFCom_Imprimir(Pointer handle);

    int NFCom_ImprimirPDF(Pointer handle);

    int NFCom_SalvarPDF(Pointer handle);

    int NFCom_ImprimirEvento(Pointer handle, String eArquivoXmlEvento, String eArquivoXmlNFCom);

    int NFCom_ImprimirEventoPDF(Pointer handle, String eArquivoXmlEvento, String eArquivoXmlNFCom);

    int NFCom_SalvarEventoPDF(Pointer handle, String eArquivoXmlEvento, String eArquivoXmlNFCom);
}
