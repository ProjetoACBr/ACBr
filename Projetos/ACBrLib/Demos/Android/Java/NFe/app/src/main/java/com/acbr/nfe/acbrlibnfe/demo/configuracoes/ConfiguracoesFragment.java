package com.acbr.nfe.acbrlibnfe.demo.configuracoes;

/**
 * Fragment base de navegação para configurações.
 * 
 * @author ACBr Team
 */

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import com.acbr.nfe.acbrlibnfe.demo.databinding.FragmentConfiguracoesBinding;
import com.acbr.nfe.acbrlibnfe.demo.utils.NfeApplication;

import br.com.acbr.lib.nfe.ACBrLibNFe;

public class ConfiguracoesFragment extends Fragment {

    private FragmentConfiguracoesBinding binding;
    private ACBrLibNFe ACBrNFe;
    private NfeApplication application;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        binding = FragmentConfiguracoesBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        
        application = (NfeApplication) requireActivity().getApplicationContext();
        ACBrNFe = application.getAcBrLibNFe();

        binding.btnExportarConfig.setOnClickListener(v -> {
            binding.editExportedConfig.setText("Atualizando configurações...");
            verConfiguracoesAtuais();
        });

        verConfiguracoesAtuais();
    }

    public void verConfiguracoesAtuais() {
        try {
            String result = ACBrNFe.configExportar();
            binding.editExportedConfig.setText(result);
            Log.i("verConfiguracoesAtuais", "Configurações carregadas com sucesso");
        } catch (Exception e) {
            Log.e("verConfiguracoesAtuais", "Erro ao exportar configurações", e);
            binding.editExportedConfig.setText("Erro ao carregar configurações:\n" + e.getMessage());
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
