package com.acbr.boleto;

import com.acbr.ACBrLibBase;
import com.acbr.ACBrSessao;
import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Platform;
import com.sun.jna.Pointer;
import com.sun.jna.ptr.IntByReference;
import com.sun.jna.ptr.PointerByReference;
import java.io.File;
import java.nio.ByteBuffer;
import java.nio.file.Paths;
import com.acbr.boleto.bridge.ACBrLibBoletoBridgeMT;

/**
 * ACBrBoleto é classe de alto nivel para ACBrLibBoleto Multi-thread
 */
public final class ACBrBoleto extends ACBrLibBase {

    public ACBrBoleto() throws Exception {
        File iniFile = Paths.get(System.getProperty("user.dir"), "ACBrLib.ini").toFile();
        if (!iniFile.exists()) {
            iniFile.createNewFile();
        }

        PointerByReference handle = new PointerByReference();
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_Inicializar(handle, toUTF8(iniFile.getAbsolutePath()), toUTF8(""));
        checkResult(ret);
        setHandle(handle.getValue());
    }

    public ACBrBoleto(String eArqConfig, String eChaveCrypt) throws Exception {
        PointerByReference handle = new PointerByReference();
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_Inicializar(handle, toUTF8(eArqConfig), toUTF8(eChaveCrypt));
        checkResult(ret);
        setHandle(handle.getValue());
    }

    @Override
    protected void dispose() throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_Finalizar(getHandle());
        checkResult(ret);
    }

    public String nome() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_Nome(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public String versao() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_Versao(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public void configLer() throws Exception {
        configLer("");
    }

    public void configLer(String eArqConfig) throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_ConfigLer(getHandle(), toUTF8(eArqConfig));
        checkResult(ret);
    }

    public void configGravar() throws Exception {
        configGravar("");
    }

    public void configGravar(String eArqConfig) throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_ConfigGravar(getHandle(), toUTF8(eArqConfig));
        checkResult(ret);
    }

    @Override
    public String configLerValor(ACBrSessao eSessao, String eChave) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_ConfigLerValor(getHandle(), toUTF8(eSessao.name()), toUTF8(eChave), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    @Override
    public void configGravarValor(ACBrSessao eSessao, String eChave, Object value) throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_ConfigGravarValor(getHandle(), toUTF8(eSessao.name()), toUTF8(eChave), toUTF8(value.toString()));
        checkResult(ret);
    }

    public void ConfigImportar(String eArqConfig) throws Exception {

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_ConfigImportar(getHandle(), eArqConfig);
        checkResult(ret);

    }

    public String ConfigExportar() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_ConfigExportar(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public void ConfigurarDados(String eArquivoIni) throws Exception {

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_ConfigurarDados(getHandle(), toUTF8(eArquivoIni));
        checkResult(ret);
    }

    public void IncluirTitulos(String eArquivoIni, String eTpSaida) throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_IncluirTitulos(getHandle(), toUTF8(eArquivoIni), toUTF8(eTpSaida));
        checkResult(ret);
    }

    public void LimparLista() throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_LimparLista(getHandle());
        checkResult(ret);
    }

    public int TotalTitulosLista() throws Exception {

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_TotalTitulosLista(getHandle());
        checkResult(ret);

        return ret;
    }

    public void Imprimir() throws Exception {
        Imprimir("");
    }

    public void Imprimir(String eNomeImpressora) throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_Imprimir(getHandle(), eNomeImpressora);
        checkResult(ret);
    }

    public void ImprimirBoleto(int Indice) throws Exception {
        ImprimirBoleto(Indice, "");
    }

    public void ImprimirBoleto(int Indice, String eNomeImpressora) throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_ImprimirBoleto(getHandle(), Indice, eNomeImpressora);
        checkResult(ret);
    }

    public void GerarPDF() throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_GerarPDF(getHandle());
        checkResult(ret);
    }

    /**
     * Método para geração de PDF dos Boletos em formato Base64.
     */
    public String salvarPDF() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference tamanhoBuffer = new IntByReference(STR_BUFFER_LEN);
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_SalvarPDF(getHandle(), buffer, tamanhoBuffer);
        checkResult(ret);
        return processResult(buffer, tamanhoBuffer);

    }

    public void GerarHTML() throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_GerarHTML(getHandle());
        checkResult(ret);
    }

    public void GerarRemessa(String eDir, int eNumArquivo, String eNomeArquivo) throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_GerarRemessa(getHandle(), eDir, eNumArquivo, eNomeArquivo);
        checkResult(ret);
    }

    public void LerRetorno(String eDir, String eNomeArq) throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_LerRetorno(getHandle(), eDir, eNomeArq);
        checkResult(ret);
    }

    public String ObterRetorno(String eDir, String eNomeArq) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_ObterRetorno(getHandle(), eDir, eNomeArq, buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public void EnviarEmail(String ePara, String eAssunto, String eMensagem, String eCC) throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_EnviarEmail(getHandle(), ePara, eAssunto, eMensagem, eCC);
        checkResult(ret);
    }

    public void EnviarEmailBoleto(int eIndice, String ePara, String eAssunto, String eMensagem, String eCC) throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_EnviarEmailBoleto(getHandle(), eIndice, ePara, eAssunto, eMensagem, eCC);
        checkResult(ret);
    }

    public void SetDiretorioArquivo(String eDir, String eArq) throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_SetDiretorioArquivo(getHandle(), eDir, eArq);
        checkResult(ret);
    }

    public String[] ListaBancos() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_ListaBancos(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen).split("|");
    }

    public String[] ListaCaractTitulo() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_ListaCaractTitulo(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen).split("|");
    }

    public String ListaOcorrencias() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_ListaOcorrencias(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public String[] ListaOcorrenciasEX() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_ListaOcorrenciasEX(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen).split("|");
    }

    public int TamNossoNumero(String eCarteira, String enossoNumero, String eConvenio) throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_TamNossoNumero(getHandle(), eCarteira, enossoNumero, eConvenio);
        checkResult(ret);

        return ret;
    }

    public String CodigosMoraAceitos() throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_CodigosMoraAceitos(getHandle(), buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public void SelecionaBanco(String eCodBanco) throws Exception {
        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_SelecionaBanco(getHandle(), eCodBanco);
        checkResult(ret);
    }

    public String MontarNossoNumero(int eIndice) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_MontarNossoNumero(getHandle(), eIndice, buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public String RetornaLinhaDigitavel(int eIndice) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_RetornaLinhaDigitavel(getHandle(), eIndice, buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public String RetornaCodigoBarras(int eIndice) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_RetornaCodigoBarras(getHandle(), eIndice, buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public String EnviarBoleto(int eCodigoOperacao) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_EnviarBoleto(getHandle(), eCodigoOperacao, buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    public String ConsultarTitulosPorPeriodo(String eArquivoIni) throws Exception {
        ByteBuffer buffer = ByteBuffer.allocate(STR_BUFFER_LEN);
        IntByReference bufferLen = new IntByReference(STR_BUFFER_LEN);

        int ret = ACBrLibBoletoBridgeMT.INSTANCE.Boleto_ConsultarTitulosPorPeriodo(getHandle(), eArquivoIni, buffer, bufferLen);
        checkResult(ret);

        return processResult(buffer, bufferLen);
    }

    @Override
    protected void UltimoRetorno(ByteBuffer buffer, IntByReference bufferLen) {
        ACBrLibBoletoBridgeMT.INSTANCE.Boleto_UltimoRetorno(getHandle(), buffer, bufferLen);
    }
}
