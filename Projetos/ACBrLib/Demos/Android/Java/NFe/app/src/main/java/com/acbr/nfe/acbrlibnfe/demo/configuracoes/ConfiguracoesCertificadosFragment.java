package com.acbr.nfe.acbrlibnfe.demo.configuracoes;

import android.content.Intent;
import android.content.pm.PackageManager;
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
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
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
    
    // ActivityResultLauncher para selecionar arquivos
    private ActivityResultLauncher<Intent> filePickerLauncher;
    private static final int REQUEST_CODE_READ_EXTERNAL_STORAGE = 2;
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

        // Configurar ActivityResultLauncher
        setupActivityResultLaunchers();

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
                getCertificate();
            }
        });

        carregarConfiguracoesCertificados();

        return view;
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

    private void setupActivityResultLaunchers() {
        // Configurar launcher para seleção de arquivos
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
                    }
                } else {
                    Log.e("ConfiguracoesCertificadosFragment", "Resultado cancelado ou dados nulos");
                }
            }
        );
    }

    public void getCertificate() {
        Log.d("ConfiguracoesCertificadosFragment", "getCertificate() chamado");
        checkAndRequestPermissions();
    }

    private void checkAndRequestPermissions() {
        // Check if the READ_EXTERNAL_STORAGE permission is already granted
        if (ContextCompat.checkSelfPermission(requireContext(), android.Manifest.permission.READ_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {
            // If not, request it
            ActivityCompat.requestPermissions(requireActivity(),
                    new String[]{android.Manifest.permission.READ_EXTERNAL_STORAGE},
                    REQUEST_CODE_READ_EXTERNAL_STORAGE);
        } else {
            openFilePicker();
        }
    }

    // Open file picker to let the user choose a file
    protected void openFilePicker() {
        Log.d("ConfiguracoesCertificadosFragment", "Abrindo file picker para seleção de certificado");
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        intent.setType("application/x-pkcs12");
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        
        filePickerLauncher.launch(intent);
    }

    private void copyCertificateToApp(Uri sourceUri) {
        try {
            // Abrir InputStream do arquivo de origem
            InputStream inputStream = requireActivity().getContentResolver().openInputStream(sourceUri);

            // Definir o destino para o arquivo na pasta do app (getExternalFilesDir())
            File destFile = new File(application.getAppDir(), application.PFX_PADRAO);
            OutputStream outputStream = new FileOutputStream(destFile);

            // Fazer a cópia do arquivo
            byte[] buffer = new byte[1024];
            int length;
            while ((length = inputStream.read(buffer)) > 0) {
                outputStream.write(buffer, 0, length);
            }

            // Fechar os streams
            inputStream.close();
            outputStream.close();

            // Atualizar o campo txtCertPath com o caminho do arquivo copiado
            txtCertPath.setText(destFile.getAbsolutePath());

            Toast.makeText(requireContext(), "Certificado selecionado: " + destFile.getAbsolutePath(), Toast.LENGTH_SHORT).show();
            Log.d("ConfiguracoesCertificadosFragment", "Arquivo copiado para: " + destFile.getAbsolutePath());
        } catch (IOException e) {
            Toast.makeText(requireContext(), "Erro ao copiar o arquivo: " + e.getMessage(), Toast.LENGTH_SHORT).show();
            Log.e("ConfiguracoesCertificadosFragment", "Erro ao copiar arquivo: " + e.getMessage());
        }
    }
}