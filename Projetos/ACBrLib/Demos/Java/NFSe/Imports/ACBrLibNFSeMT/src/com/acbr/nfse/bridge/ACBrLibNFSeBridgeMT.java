/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.acbr.nfse.bridge;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Platform;
import com.sun.jna.Pointer;
import com.sun.jna.ptr.IntByReference;
import com.sun.jna.ptr.PointerByReference;
import java.nio.ByteBuffer;

/**
 *
 * @author daniel
 */
public interface ACBrLibNFSeBridgeMT extends Library {

    static String JNA_LIBRARY_NAME = LibraryLoader.getLibraryName();
    public final static ACBrLibNFSeBridgeMT INSTANCE = LibraryLoader.getInstance();

    class LibraryLoader {

        private static String library = "";
        private static ACBrLibNFSeBridgeMT instance = null;

        private static String getLibraryName() {
            if (library.isEmpty()) {
                if (Platform.isWindows()) {
                    library = Platform.is64Bit() ? "ACBrNFSe64" : "ACBrNFSe32";
                } else {
                    library = Platform.is64Bit() ? "acbrnfse64" : "acbrnfse32";
                }
            }
            return library;
        }

        public static ACBrLibNFSeBridgeMT getInstance() {
            if (instance == null) {
                instance = (ACBrLibNFSeBridgeMT) Native.synchronizedLibrary(
                        (Library) Native.load(JNA_LIBRARY_NAME, ACBrLibNFSeBridgeMT.class));
            }

            return instance;
        }
    }

    //MT
    int NFSE_Inicializar(PointerByReference libHandler, String eArqConfig, String eChaveCrypt);

    int NFSE_Finalizar(Pointer libHandler);

    int NFSE_Nome(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_Versao(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_UltimoRetorno(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConfigImportar(Pointer libHandler, String eArqConfig);

    int NFSE_ConfigExportar(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConfigLer(Pointer libHandler, String eArqConfig);

    int NFSE_ConfigGravar(Pointer libHandler, String eArqConfig);

    int NFSE_ConfigLerValor(Pointer libHandler, String eSessao, String eChave, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConfigGravarValor(Pointer libHandler, String eSessao, String eChave, String valor);

    int NFSE_ConfigGravarValor(Pointer libHandler, String eArquivoOuXML);

    int NFSE_CarregarXML(Pointer libHandler, String eArquivoOuXml);

    int NFSE_CarregarLoteXML(Pointer libHandler, String eArquivoOuXml);

    int NFSE_CarregarINI(Pointer libHandler, String eArquivoOuINI);

    int NFSE_ObterXml(Pointer libHandler, int AIndex, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_GravarXml(Pointer libHandler, int AIndex, String eNomeArquivo, String ePathArquivo);

    int NFSE_ObterIni(Pointer libHandler, int AIndex, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_GravarIni(Pointer libHandler, int AIndex, String eNomeArquivo, String ePathArquivo);

    int NFSE_LimparLista(Pointer libHandler);

    int NFSE_ObterCertificados(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_Emitir(Pointer libHandler, String aLote, int aModoEnvio, boolean aImprimir, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_Cancelar(Pointer libHandler, String aInfCancelamento, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_SubstituirNFSe(Pointer libHandler, String aNumeroNFSe, String aSerieNFSe, String aCodigoCancelamento, String aMotivoCancelamento, String aNumeroLote, String aCodigoVerificacao, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_LinkNFSE(Pointer libHandler, String aNumeroNFSe, String aCodigoVerificacao, String aChaveAcesso, String aValorServico, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_GerarLote(Pointer libHandler, String aLote, int aQtdMaximaRps, int aModoEnvio, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_GerarToken(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarSituacao(Pointer libHandler, String aProtocolo, String aNumeroLote, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarLoteRps(Pointer libHandler, String aProtocolo, String aNumLote, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSePorRps(Pointer libHandler, String aNumeroRps, String aSerie, String aTipo, String aCodigoVerificacao, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSePorNumero(Pointer libHandler, String aNumero, int aPagina, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSePorPeriodo(Pointer libHandler, double aDataInicial, double aDataFinal, int aPagina, String aNumeroLote, int aTipoPeriodo, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSePorFaixa(Pointer libHandler, String aNumeroInicial, String aNumeroFinal, int aPagina, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSeGenerico(Pointer libHandler, String aInfConsultaNFSe, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarLinkNFSe(Pointer libHandler, String aInfConsultaLinkNFSe, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_EnviarEmail(Pointer libHandler, String ePara, String eXmlNFSe, boolean aEnviaPDF, String eAssunto, String eCc, String eAnexos, String eMensagem);

    int NFSE_Imprimir(Pointer libHandler, String cImpressora, int nNumCopias, String bGerarPDF, String bMostrarPreview, String cCancelada);

    int NFSE_ImprimirPDF(Pointer libHandler);

    int NFSE_SalvarPDF(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSeServicoPrestadoPorNumero(Pointer libHandler, String aNumero, int aPagina, double aDataInicial, double aDataFinal, int aTipoPeriodo, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSeServicoPrestadoPorPeriodo(Pointer libHandler, double aDataInicial, double aDataFinal, int aPagina, int aTipoPeriodo, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSeServicoPrestadoPorTomador(Pointer libHandler, String aCNPJ, String aInscMun, int aPagina, double aDataInicial, double aDataFinal, int aTipoPeriodo, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSeServicoPrestadoPorIntermediario(Pointer libHandler, String aCNPJ, String aInscMun, int aPagina, double aDataInicial, double aDataFinal, int aTipoPeriodo, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSeServicoTomadoPorNumero(Pointer libHandler, String aNumero, int aPagina, double aDataInicial, double aDataFinal, int aTipoPeriodo, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSeServicoTomadoPorPrestador(Pointer libHandler, String aCNPJ, String aInscMun, int aPagina, double aDataInicial, double aDataFinal, int aTipoPeriodo, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSeServicoTomadoPorTomador(Pointer libHandler, String aCNPJ, String aInscMun, int aPagina, double aDataInicial, double aDataFinal, int aTipoPeriodo, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSeServicoTomadoPorPeriodo(Pointer libHandler, double aDataInicial, double aDataFinal, int aPagina, int aTipoPeriodo, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSeServicoTomadoPorIntermediario(Pointer libHandler, String aCNPJ, String aInscMun, int aPagina, double aDataInicial, double aDataFinal, int aTipoPeriodo, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_EnviarEvento(Pointer libHandler, String aInfEvento, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarDPSPorChave(Pointer libHandler, String aChaveDPS, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarNFSePorChave(Pointer libHandler, String aChaveNFSe, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarEvento(Pointer libHandler, String aChave, int aTipoEvento, int aNumSeq, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarDFe(Pointer libHandler, int aNSU, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ObterDANFSE(Pointer libHandler, String aChaveNFSe, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ConsultarParametros(Pointer libHandler, int aTipoParametroMunicipio, String aCodigoServico, double aCompetencia, String aNumeroBeneficio, ByteBuffer buffer, IntByReference bufferSize);

    int NFSE_ObterInformacoesProvedor(Pointer libHandler, ByteBuffer buffer, IntByReference bufferSize);

}
