/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author daniel
 */
package com.acbr.nfcom;

import com.acbr.ACBrLibBase;
import com.acbr.ACBrSessao;
import com.sun.jna.ptr.IntByReference;
import com.sun.jna.ptr.PointerByReference;
import java.io.File;
import java.nio.ByteBuffer;
import java.nio.file.Paths;
import com.acbr.nfcom.bridge.ACBrLibNFComBridgeMT;


/**
 * Classe de alto nível para acesso à biblioteca ACBrNFCom Multi-thread.,
 * 
 * Obs.: o sufixo MT indica que a biblioteca é multi-thread.
 */

public class ACBrLibNFComMT extends ACBrLibBase {

    private ACBrLibNFComBridgeMT acbrLibNFComBridge;

    /**
     * Inicializa a biblioteca ACBrNFCom Multi-thread.
     * @throws Exception
    */
    public ACBrLibNFComMT() throws Exception {
        PointerByReference handle = new PointerByReference();
        File iniFile = Paths.get(System.getProperty("user.dir"), "ACBrLib.ini").toFile();
        if (!iniFile.exists()) {
            iniFile.createNewFile();
        }

        acbrLibNFComBridge = ACBrLibNFComBridgeMT.INSTANCE;
        int ret = acbrLibNFComBridge.NFCom_Inicializar(handle, toUTF8(iniFile.getAbsolutePath()), toUTF8(""));
        setHandle(handle.getValue());
        checkResult(ret);
    }

    /**
     * Inicializa a biblioteca ACBrNFCom Multi-thread.
     * @param eArqConfig - arquivo de configuração da biblioteca
     * @param eChaveCrypt - chave de criptografia da biblioteca
     * @throws Exception
    */
    public ACBrLibNFComMT(String eArqConfig, String eChaveCrypt) throws Exception {
        PointerByReference handle = new PointerByReference();
        acbrLibNFComBridge = ACBrLibNFComBridgeMT.INSTANCE;
        int ret = acbrLibNFComBridge.NFCom_Inicializar(handle, toUTF8(eArqConfig), toUTF8(eChaveCrypt));
        setHandle(handle.getValue());
        checkResult(ret);
    }

    @Override
    protected void dispose() throws Exception {
        int ret = acbrLibNFComBridge.NFCom_Finalizar(getHandle());

        checkResult(ret);
        setHandle(null);
    }

    public String nome() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_Nome(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return fromUTF8(buffer, bufferLen.getValue());
    }

    public String versao() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_Versao(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return fromUTF8(buffer, bufferLen.getValue());
    }

    public String openSSLInfo() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_OpenSSLInfo(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public void configLer() throws Exception {
        configLer("");
    }

    public void configLer(String eArqConfig) throws Exception {
        int ret = acbrLibNFComBridge.NFCom_ConfigLer(getHandle(), toUTF8(eArqConfig));
        checkResult(ret);
    }

    public void configGravar() throws Exception {
        configGravar("");
    }

    public void configGravar(String eArqConfig) throws Exception {
        int ret = acbrLibNFComBridge.NFCom_ConfigGravar(getHandle(), toUTF8(eArqConfig));
        checkResult(ret);
    }

    @Override
    public String configLerValor(ACBrSessao eSessao, String eChave) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_ConfigLerValor(getHandle(), toUTF8(eSessao.name()), toUTF8(eChave), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    @Override
    public void configGravarValor(ACBrSessao eSessao, String eChave, Object value) throws Exception {
        int ret = acbrLibNFComBridge.NFCom_ConfigGravarValor(getHandle(), toUTF8(eSessao.name()), toUTF8(eChave), toUTF8(value.toString()));
        checkResult(ret);
    }

    public void ConfigImportar(String eArqConfig) throws Exception {
        int ret = acbrLibNFComBridge.NFCom_ConfigImportar(getHandle(), eArqConfig);
        checkResult(ret);
    }

    public String ConfigExportar() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_ConfigExportar(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return fromUTF8(buffer, bufferLen.getValue());
    }

    public void carregarXml(String eArquivoOuXML) throws Exception {
        int ret = acbrLibNFComBridge.NFCom_CarregarXML(getHandle(), toUTF8(eArquivoOuXML));
        checkResult(ret);
    }

    public void carregarIni(String eArquivoOuIni) throws Exception {
        int ret = acbrLibNFComBridge.NFCom_CarregarINI(getHandle(), toUTF8(eArquivoOuIni));
        checkResult(ret);
    }

    public void limparLista() throws Exception {
        int ret = acbrLibNFComBridge.NFCom_LimparLista(getHandle());
        checkResult(ret);
    }

    public void limparListaEventos() throws Exception {
        int ret = acbrLibNFComBridge.NFCom_LimparListaEventos(getHandle());
        checkResult(ret);
    }

    public void deletar(int index) throws Exception {
        int ret = acbrLibNFComBridge.NFCom_Deletar(getHandle(), index);
        checkResult(ret);
    }

    public void assinar() throws Exception {
        int ret = acbrLibNFComBridge.NFCom_Assinar(getHandle());
        checkResult(ret);
    }

    public void verificarAssinatura() throws Exception {
        int ret = acbrLibNFComBridge.NFCom_VerificarAssinatura(getHandle());
        checkResult(ret);
    }

    public void validar() throws Exception {
        int ret = acbrLibNFComBridge.NFCom_Validar(getHandle());
        checkResult(ret);
    }

    public String validarRegrasdeNegocios() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_ValidarRegrasdeNegocios(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public String enviar(int lote) throws Exception {
        return enviar(lote, false);
    }

    public String enviar(int lote, boolean imprimir) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_Enviar(getHandle(), lote, imprimir, buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public String enviarEvento() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_EnviarEvento(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public String consultar(String eChaveOuNFCom) throws Exception {
        return consultar(eChaveOuNFCom, false);
    }

    public String consultar(String eChaveOuNFCom, boolean extrairEventos) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_Consultar(getHandle(), toUTF8(eChaveOuNFCom), extrairEventos, buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public String cancelar(String eChaveOuNFCom, String eJustificativa,String cpfouCnpj, int lote) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_Cancelar(getHandle(), toUTF8(eChaveOuNFCom), toUTF8(eJustificativa),cpfouCnpj,lote, buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public String statusServico() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_StatusServico(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public String obterXml(int index) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_ObterXml(getHandle(), index, buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public void gravarXml(int index) throws Exception {
        gravarXml(index, "", "");
    }

    public void gravarXml(int index, String eNomeArquivo) throws Exception {
        gravarXml(index, eNomeArquivo, "");
    }

    public void gravarXml(int index, String eNomeArquivo, String ePathArquivo) throws Exception {
        int ret = acbrLibNFComBridge.NFCom_GravarXml(getHandle(), index, toUTF8(eNomeArquivo), toUTF8(ePathArquivo));
        checkResult(ret);
    }

    public String getPath() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_GetPath(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public String getPathEvento() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_GetPathEvento(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public void setIdCSC(String eIdCSC, String eCSC) throws Exception {
        int ret = acbrLibNFComBridge.NFCom_SetIdCSC(getHandle(), toUTF8(eIdCSC), toUTF8(eCSC));
        checkResult(ret);
    }

    public String obterCertificados() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = acbrLibNFComBridge.NFCom_ObterCertificados(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public void enviarEmail(String ePara, String eArquivoNFCom, boolean enviaPDF, String eAssunto) throws Exception {
        enviarEmail(ePara, eArquivoNFCom, enviaPDF, eAssunto, "", "", "");
    }

    public void enviarEmail(String ePara, String eArquivoNFCom, boolean enviaPDF, String eAssunto, String eCC,
            String eAnexos, String eMensagem) throws Exception {
        int ret = acbrLibNFComBridge.NFCom_EnviarEmail(getHandle(), ePara, eArquivoNFCom, enviaPDF, eAssunto, eCC, eAnexos, eMensagem);
        checkResult(ret);
    }

    public void enviarEmailEvento(String ePara, String eArquivoXmlEvento, String eArquivoXmlNFCom, boolean enviaPDF,
            String eAssunto) throws Exception {
        enviarEmailEvento(ePara, eArquivoXmlEvento, eArquivoXmlNFCom, enviaPDF, eAssunto, "", "", "");
    }

    public void enviarEmailEvento(String ePara, String eArquivoXmlEvento, String eArquivoXmlNFCom, boolean enviaPDF,
            String eAssunto, String eCC, String eAnexos, String eMensagem) throws Exception {
        int ret = acbrLibNFComBridge.NFCom_EnviarEmailEvento(getHandle(), ePara, eArquivoXmlEvento, eArquivoXmlNFCom, enviaPDF,
                eAssunto, eCC, eAnexos, eMensagem);
        checkResult(ret);
    }

    public void imprimir() throws Exception {
        int ret = acbrLibNFComBridge.NFCom_Imprimir(getHandle());
        checkResult(ret);
    }

    public void imprimirPDF() throws Exception {
        int ret = acbrLibNFComBridge.NFCom_ImprimirPDF(getHandle());
        checkResult(ret);
    }

    public void salvarPDF() throws Exception {
        int ret = acbrLibNFComBridge.NFCom_SalvarPDF(getHandle());
        checkResult(ret);
    }

    public void imprimirEvento(String eArquivoXmlEvento, String eArquivoXmlNFCom) throws Exception {
        int ret = acbrLibNFComBridge.NFCom_ImprimirEvento(getHandle(), toUTF8(eArquivoXmlEvento), toUTF8(eArquivoXmlNFCom));
        checkResult(ret);
    }

    public void imprimirEventoPDF(String eArquivoXmlEvento, String eArquivoXmlNFCom) throws Exception {
        int ret = acbrLibNFComBridge.NFCom_ImprimirEventoPDF(getHandle(), toUTF8(eArquivoXmlEvento), toUTF8(eArquivoXmlNFCom));
        checkResult(ret);
    }

    public void salvarEventoPDF(String eArquivoXmlEvento, String eArquivoXmlNFCom) throws Exception {
        int ret = acbrLibNFComBridge.NFCom_SalvarEventoPDF(getHandle(), toUTF8(eArquivoXmlEvento), toUTF8(eArquivoXmlNFCom));
        checkResult(ret);
    }

    @Override
    protected void UltimoRetorno(ByteBuffer buffer, IntByReference bufferLen) {
        acbrLibNFComBridge.NFCom_UltimoRetorno(getHandle(), buffer, bufferLen);
    }

}
