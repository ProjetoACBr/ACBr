/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.acbr.boleto.bridge;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Platform;
import com.sun.jna.Pointer;
import com.sun.jna.ptr.IntByReference;
import com.sun.jna.ptr.PointerByReference;
import java.nio.ByteBuffer;

/**
 *
  ACBrLibBoletoBridgeMT é uma interface que mapeia os métodos nativos da ACBrLibBoleto Multi-thread
  * @see https://acbr.sourceforge.io/ACBrLib/ACBrLibBoleto.html
 */
public interface ACBrLibBoletoBridgeMT extends Library {

    static String JNA_LIBRARY_NAME = LibraryLoader.getLibraryName();
    public final static ACBrLibBoletoBridgeMT INSTANCE = LibraryLoader.getInstance();

    class LibraryLoader {

        private static String library = "";
        private static ACBrLibBoletoBridgeMT instance = null;

        public static String getLibraryName() {
            if (library.isEmpty()) {
                if (Platform.isWindows()) {
                    library = Platform.is64Bit() ? "ACBrBoleto64" : "ACBrBoleto32";
                } else {
                    library = Platform.is64Bit() ? "acbrboleto64" : "acbrboleto32";
                }

            }
            return library;
        }

        public static ACBrLibBoletoBridgeMT getInstance() {
            if (instance == null) {
                instance = (ACBrLibBoletoBridgeMT) Native.synchronizedLibrary((Library) Native.load(JNA_LIBRARY_NAME, ACBrLibBoletoBridgeMT.class));
            }
            return instance;
        }
    }

    int Boleto_Inicializar(PointerByReference libHandler, String eArqConfig, String eChaveCrypt);

    int Boleto_Finalizar(Pointer libHandler);

    int Boleto_Nome(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_Versao(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_UltimoRetorno(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_ConfigImportar(Pointer libHandler, String eArqConfig);

    int Boleto_ConfigExportar(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_ConfigLer(Pointer libHandler, String eArqConfig);

    int Boleto_ConfigGravar(Pointer libHandler, String eArqConfig);

    int Boleto_ConfigLerValor(Pointer libHandler, String eSessao, String eChave, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_ConfigGravarValor(Pointer libHandler, String eSessao, String eChave, String valor);

    int Boleto_ConfigurarDados(Pointer libHandler, String eArquivoIni);

    int Boleto_IncluirTitulos(Pointer libHandler, String eArquivoIni, String eTpSaida);

    int Boleto_LimparLista(Pointer libHandler);

    int Boleto_TotalTitulosLista(Pointer libHandler);

    int Boleto_Imprimir(Pointer libHandler, String eNomeImpressora);

    int Boleto_ImprimirBoleto(Pointer libHandler, int eIndice, String eNomeImpressora);

    int Boleto_GerarPDF(Pointer libHandler);

    int Boleto_SalvarPDF(Pointer libHandler, ByteBuffer sResposta, IntByReference esTamanho);

    int Boleto_GerarHTML(Pointer libHandler);

    int Boleto_GerarRemessa(Pointer libHandler, String eDir, int eNumArquivo, String eNomeArquivo);

    int Boleto_LerRetorno(Pointer libHandler, String eDir, String eNomeArq);

    int Boleto_ObterRetorno(Pointer libHandler, String eDir, String eNomeArq, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_EnviarEmail(Pointer libHandler, String ePara, String eAssunto, String eMensagem, String eCC);

    int Boleto_EnviarEmailBoleto(Pointer libHandler, int eIndice, String ePara, String eAssunto, String eMensagem, String eCC);

    int Boleto_SetDiretorioArquivo(Pointer libHandler, String eDir, String eArq);

    int Boleto_ListaBancos(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_ListaCaractTitulo(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_ListaOcorrencias(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_ListaOcorrenciasEX(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_TamNossoNumero(Pointer libHandler, String eCarteira, String enossoNumero, String eConvenio);

    int Boleto_CodigosMoraAceitos(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_SelecionaBanco(Pointer libHandler, String eCodBanco);

    int Boleto_MontarNossoNumero(Pointer libHandler, int eIndice, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_RetornaLinhaDigitavel(Pointer libHandler, int eIndice, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_RetornaCodigoBarras(Pointer libHandler, int eIndice, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_EnviarBoleto(Pointer libHandler, int eCodigoOperacao, ByteBuffer buffer, IntByReference bufferSize);

    int Boleto_ConsultarTitulosPorPeriodo(Pointer libHandler, String eArquivoIni, ByteBuffer buffer, IntByReference bufferSize);

}
