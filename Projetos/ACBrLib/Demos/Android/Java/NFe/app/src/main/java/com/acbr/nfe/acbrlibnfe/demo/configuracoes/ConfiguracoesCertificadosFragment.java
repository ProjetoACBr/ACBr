package com.acbr.nfe.acbrlibnfe.demo.configuracoes;

/**
 * Fragment para configuração de certificados digitais.
 * 
 * Permite seleção de certificados via SAF (sem permissões especiais),
 * configuração de SSL e obtenção da lista de certificados instalados.
 * 
 * @author ACBr Team
 */

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.fragment.app.Fragment;

import com.acbr.nfe.acbrlibnfe.demo.R;
import com.acbr.nfe.acbrlibnfe.demo.utils.ACBrLibHelper;
import com.acbr.nfe.acbrlibnfe.demo.utils.NfeApplication;
import com.acbr.nfe.acbrlibnfe.demo.utils.SpinnerUtils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import br.com.acbr.lib.comum.dfe.SSLCryptLib;
import br.com.acbr.lib.comum.dfe.SSLHttpLib;
import br.com.acbr.lib.comum.dfe.SSLXmlSignLib;
import br.com.acbr.lib.nfe.ACBrLibNFe;

public class ConfiguracoesCertificadosFragment extends Fragment {

    private ACBrLibNFe ACBrNFe;
    private NfeApplication application;
    
    // ActivityResultLauncher simples para selecionar arquivos usando SAF (sem permissões)
    private ActivityResultLauncher<Intent> filePickerLauncher;
    private EditText txtCertPath;
    private EditText txtDadosPFX;
    private EditText txtCertPassword;
    private EditText txtCertNumero;
    private EditText txtRespostaCertificado;
    private Spinner cmbCrypt;
    private Spinner cmbHttp;
    private Spinner cmbXmlSign;
    private Button btnSalvarConfiguracoesCertificados;
    private Button btnCarregarConfiguracoesCertificados;
    private Button btnObterCertificados;
    private Button btnSelecionarCertificado;

    SSLCryptLib[] sslCryptLibs = SSLCryptLib.values();
    SSLHttpLib[] sslHttpLibs = SSLHttpLib.values();
    SSLXmlSignLib[] sslXmlSignLibs = SSLXmlSignLib.values();

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_configuracoes_certificados, container, false);

        // Configurar ActivityResultLauncher simples para SAF
        setupFilePickerLauncher();

        ACBrNFe = ACBrLibHelper.getInstance("");

        cmbCrypt = view.findViewById(R.id.cmbCrypt);
        cmbHttp = view.findViewById(R.id.cmbHttp);
        cmbXmlSign = view.findViewById(R.id.cmbXmlSign);
        txtCertPath = view.findViewById(R.id.txtCertPath);
        txtDadosPFX = view.findViewById(R.id.txtDadosPFX);
        txtCertPassword = view.findViewById(R.id.txtCertPassword);
        txtCertNumero = view.findViewById(R.id.txtCertNumero);
        txtRespostaCertificado = view.findViewById(R.id.txtRespostaCertificado);
        btnObterCertificados = view.findViewById(R.id.btnObterCertificados);
        btnSalvarConfiguracoesCertificados = view.findViewById(R.id.btnSalvarConfiguracoesCertificados);
        btnCarregarConfiguracoesCertificados = view.findViewById(R.id.btnCarregarConfiguracoesCertificados);
        btnSelecionarCertificado = view.findViewById(R.id.btnSelecionarCertificado);
        application = ((NfeApplication) this.getContext().getApplicationContext());
        txtCertPath.setText(application.getPfxPath());

        SpinnerUtils.preencherSpinner(getContext(), cmbCrypt, sslCryptLibs);
        SpinnerUtils.preencherSpinner(getContext(), cmbHttp, sslHttpLibs);
        SpinnerUtils.preencherSpinner(getContext(), cmbXmlSign, sslXmlSignLibs);

        btnSalvarConfiguracoesCertificados.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                salvarConfiguracoesCertificados();
            }
        });

        btnCarregarConfiguracoesCertificados.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                carregarConfiguracoesCertificados();
            }
        });

        btnObterCertificados.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                obterCertificados();
            }
        });

        btnSelecionarCertificado.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Log.d("ConfiguracoesCertificadosFragment", "Botão Selecionar Certificado clicado");
                openFilePicker();
            }
        });

        return view;
    }

    @Override
    public void onResume() {
        super.onResume();
        carregarConfiguracoesCertificados();
    }

    private void salvarConfiguracoesCertificados() {
        try {
            ACBrNFe.configGravarValor("DFe", "SSLCryptLib", Integer.toString(cmbCrypt.getSelectedItemPosition()));
            ACBrNFe.configGravarValor("DFe", "SSLHttpLib", Integer.toString(cmbHttp.getSelectedItemPosition()));
            ACBrNFe.configGravarValor("DFe", "SSLXmlSignLib", Integer.toString(cmbXmlSign.getSelectedItemPosition()));
            ACBrNFe.configGravarValor("DFe", "ArquivoPFX", application.getPfxPath());
            ACBrNFe.configGravarValor("DFe", "DadosPFX", txtDadosPFX.getText().toString());
            ACBrNFe.configGravarValor("DFe", "Senha", txtCertPassword.getText().toString());
            ACBrNFe.configGravarValor("DFe", "NumeroSerie", txtCertNumero.getText().toString());
            ACBrNFe.configGravar();
        } catch (Exception ex) {
            Log.i("Erro", " - Salvar Configurações Certificados: " + ex.getMessage());
        }
    }

    private void carregarConfiguracoesCertificados() {
        try {
            cmbCrypt.setSelection(Integer.valueOf(ACBrNFe.configLerValor("DFe", "SSLCryptLib")));
            cmbHttp.setSelection(Integer.valueOf(ACBrNFe.configLerValor("DFe", "SSLHttpLib")));
            cmbXmlSign.setSelection(Integer.valueOf(ACBrNFe.configLerValor("DFe", "SSLXmlSignLib")));
            txtCertPath.setText(ACBrNFe.configLerValor("DFe", "ArquivoPFX"));
            txtDadosPFX.setText(ACBrNFe.configLerValor("DFe", "DadosPFX"));
            txtCertPassword.setText(ACBrNFe.configLerValor("DFe", "Senha"));
            txtCertNumero.setText(ACBrNFe.configLerValor("DFe", "NumeroSerie"));
        } catch (Exception ex) {
            Log.i("Erro", " - Carregar Configurações Certificados: " + ex.getMessage());
        }
    }

    private void obterCertificados() {
        txtRespostaCertificado.setText("");
        String result = "";
        try {
            result = ACBrNFe.ObterCertificados();
        } catch (Exception e) {
            Log.e("Erro Obter Certificado", e.getMessage());
            result = e.getMessage();
        } finally {
            txtRespostaCertificado.setText(result);
        }
    }

    /**
     * Configura o launcher simples para seleção de arquivos usando SAF (Storage Access Framework)
     * Não requer permissões especiais - funciona em todas as versões do Android
     */
    private void setupFilePickerLauncher() {
        filePickerLauncher = registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(),
            result -> {
                Log.d("ConfiguracoesCertificadosFragment", "ActivityResult recebido - Result Code: " + result.getResultCode());
                if (result.getResultCode() == requireActivity().RESULT_OK && result.getData() != null) {
                    Uri uri = result.getData().getData();
                    if (uri != null) {
                        Log.d("ConfiguracoesCertificadosFragment", "URI do arquivo selecionado: " + uri.toString());
                        copyCertificateToApp(uri);
                    } else {
                        Log.e("ConfiguracoesCertificadosFragment", "URI é nulo");
                        Toast.makeText(requireContext(), "Erro: Arquivo não selecionado", Toast.LENGTH_SHORT).show();
                    }
                } else {
                    Log.d("ConfiguracoesCertificadosFragment", "Seleção de arquivo cancelada pelo usuário");
                }
            }
        );
    }

    /**
     * Abre o file picker usando SAF (Storage Access Framework)
     * Não requer permissões especiais e funciona em todas as versões do Android
     */
    private void openFilePicker() {
        Log.d("ConfiguracoesCertificadosFragment", "Abrindo file picker para seleção de certificado");
        
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        
        // Aceitar arquivos de certificado comuns
        String[] mimeTypes = {
            "application/x-pkcs12",      // .p12, .pfx
            "application/pkcs12",        // .p12, .pfx
        };

        intent.setType("*/*");
        intent.putExtra(Intent.EXTRA_MIME_TYPES, mimeTypes);
        
        try {
            filePickerLauncher.launch(intent);
        } catch (Exception e) {
            Log.e("ConfiguracoesCertificadosFragment", "Erro ao abrir file picker: " + e.getMessage());
            Toast.makeText(requireContext(), "Erro ao abrir seletor de arquivos", Toast.LENGTH_SHORT).show();
        }
    }

    /**
     * Copia o certificado selecionado para o diretório da aplicação
     * @param sourceUri URI do arquivo selecionado pelo usuário via SAF
     */
    private void copyCertificateToApp(Uri sourceUri) {
        InputStream inputStream = null;
        OutputStream outputStream = null;
        
        try {
            // Abrir InputStream do arquivo de origem usando Content Resolver
            inputStream = requireActivity().getContentResolver().openInputStream(sourceUri);
            if (inputStream == null) {
                throw new IOException("Não foi possível abrir o arquivo selecionado");
            }

            // Definir o destino na pasta privada da aplicação
            File destFile = new File(application.getAppDir(), application.PFX_PADRAO);
            outputStream = new FileOutputStream(destFile);

            // Copiar o arquivo usando buffer
            byte[] buffer = new byte[4096]; // Buffer maior para melhor performance
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }

            // Atualizar o campo de texto com o caminho do certificado
            txtCertPath.setText(destFile.getAbsolutePath());

            Toast.makeText(requireContext(), 
                "Certificado importado com sucesso", 
                Toast.LENGTH_SHORT).show();
            Log.d("ConfiguracoesCertificadosFragment", 
                "Certificado copiado para: " + destFile.getAbsolutePath());
                
        } catch (IOException e) {
            Log.e("ConfiguracoesCertificadosFragment", "Erro ao copiar certificado: " + e.getMessage());
            Toast.makeText(requireContext(), 
                "Erro ao importar certificado: " + e.getMessage(), 
                Toast.LENGTH_LONG).show();
        } finally {
            // Fechar streams de forma segura
            try {
                if (inputStream != null) inputStream.close();
                if (outputStream != null) outputStream.close();
            } catch (IOException e) {
                Log.e("ConfiguracoesCertificadosFragment", "Erro ao fechar streams: " + e.getMessage());
            }
        }
    }
}