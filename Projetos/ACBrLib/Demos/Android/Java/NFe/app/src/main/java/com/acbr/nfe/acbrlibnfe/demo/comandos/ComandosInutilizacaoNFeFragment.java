package com.acbr.nfe.acbrlibnfe.demo.comandos;

/**
 * Fragment para inutilização de numeração de NFe na SEFAZ.
 * 
 * Permite inutilizar número único ou sequência. Requer CNPJ, série,
 * numeração e justificativa (min. 15 caracteres).
 * 
 * @author ACBr Team
 */

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.google.android.material.textfield.TextInputEditText;

import androidx.fragment.app.Fragment;

import com.acbr.nfe.acbrlibnfe.demo.utils.ACBrLibHelper;
import com.acbr.nfe.acbrlibnfe.demo.R;

import br.com.acbr.lib.nfe.ACBrLibNFe;

public class ComandosInutilizacaoNFeFragment extends Fragment {

    private ACBrLibNFe ACBrNFe;

    private TextInputEditText txtRespostaInutilizacao;
    private TextInputEditText txtCNPJInutilizarNumeracao;
    private TextInputEditText txtJustificativaInutilizarNumeracao;
    private TextInputEditText txtAnoInutilizarNumeracao;
    private TextInputEditText txtModeloInutilizarNumeracao;
    private TextInputEditText txtSerieInutilizarNumeracao;
    private TextInputEditText txtNumeroInicialInutilizarNumeracao;
    private TextInputEditText txtNumeroFinalInutilizarNumeracao;
    private Button btnInutilizarNumeracao;
    private Button btnLimparRespostaInutilizacao;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_comandos_inutilizacao_nfe, container, false);

        txtRespostaInutilizacao = view.findViewById(R.id.txtRespostaInutilizacao);
        txtCNPJInutilizarNumeracao = view.findViewById(R.id.txtCNPJInutilizarNumeracao);
        txtJustificativaInutilizarNumeracao = view.findViewById(R.id.txtJustificativaInutilizarNumeracao);
        txtAnoInutilizarNumeracao = view.findViewById(R.id.txtAnoInutilizarNumeracao);
        txtModeloInutilizarNumeracao = view.findViewById(R.id.txtModeloInutilizarNumeracao);
        txtSerieInutilizarNumeracao = view.findViewById(R.id.txtSerieInutilizarNumeracao);
        txtNumeroInicialInutilizarNumeracao = view.findViewById(R.id.txtNumeroInicialInutilizarNumeracao);
        txtNumeroFinalInutilizarNumeracao = view.findViewById(R.id.txtNumeroFinalInutilizarNumeracao);
        btnInutilizarNumeracao = view.findViewById(R.id.btnInutilizarNumeracao);
        btnLimparRespostaInutilizacao = view.findViewById(R.id.btnLimparRespostaInutilizacao);

        btnInutilizarNumeracao.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                inutilizarNumeracao();
            }
        });

        btnLimparRespostaInutilizacao.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                LimparRespostaInutilizacao();
            }
        });

        return view;
    }

    @Override
    public void onResume() {
        super.onResume();
        ACBrNFe = ACBrLibHelper.getInstance("");
    }

    public void inutilizarNumeracao() {
        txtRespostaInutilizacao.setText("");
        String result = "";
        String cnpj = txtCNPJInutilizarNumeracao.getText().toString();
        String justificativa = txtJustificativaInutilizarNumeracao.getText().toString();
        Integer ano = Integer.parseInt(txtAnoInutilizarNumeracao.getText().toString());
        Integer modelo = Integer.parseInt(txtModeloInutilizarNumeracao.getText().toString());
        Integer serie = Integer.parseInt(txtSerieInutilizarNumeracao.getText().toString());
        Integer numeroInicial = Integer.parseInt(txtNumeroInicialInutilizarNumeracao.getText().toString());
        Integer numeroFinal = Integer.parseInt(txtNumeroFinalInutilizarNumeracao.getText().toString());

        try {
            result = ACBrNFe.Inutilizar(cnpj, justificativa, ano, modelo, serie, numeroInicial, numeroFinal);
        } catch (Exception ex) {
            Log.e("Erro ao Enviar NFe", ex.getMessage());
            result = ex.getMessage();
        } finally {
            txtRespostaInutilizacao.setText(result);
        }
    }

    public void LimparRespostaInutilizacao() {
        txtRespostaInutilizacao.setText("");
    }
}