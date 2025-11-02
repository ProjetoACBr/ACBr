package com.acbr.nfe.acbrlibnfe.demo.configuracoes;

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
            try {
                verConfiguracoesAtuais();
            } catch (Exception ex) {
                Log.e("onClickButtonExportarConfig", "Erro ao visualizar as configurações", ex);
            }
        });

        verConfiguracoesAtuais();
    }

    public void verConfiguracoesAtuais() {
        String config = binding.editExportedConfig.getText().toString();
        String result = "";
        try {
            Log.i("verConfiguracoesAtuais", config);
            result = ACBrNFe.configExportar();
            binding.editExportedConfig.setText(result);
        } catch (Exception e) {
            Log.e("verConfiguracoesAtuais", "Erro ao exportar configurações", e);
            result = e.getMessage();
        } finally {
            binding.editExportedConfig.setText(result);
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
