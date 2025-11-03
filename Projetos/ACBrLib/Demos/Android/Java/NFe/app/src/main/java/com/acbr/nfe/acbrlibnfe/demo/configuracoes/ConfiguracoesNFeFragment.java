package com.acbr.nfe.acbrlibnfe.demo.configuracoes;

/**
 * Container principal para configurações NFe organizadas em abas.
 * 
 * Utiliza ViewPager2 com TabLayout para navegação entre:
 * Geral, Certificados, WebServices, Email, Arquivos e DANFE.
 * 
 * @author ACBr Team
 */

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.acbr.nfe.acbrlibnfe.demo.databinding.FragmentConfiguracoesNfeBinding;
import com.acbr.nfe.acbrlibnfe.demo.utils.ACBrLibHelper;
import com.acbr.nfe.acbrlibnfe.demo.utils.NfeApplication;
import com.acbr.nfe.acbrlibnfe.demo.utils.ViewPagerAdapter;
import com.google.android.material.tabs.TabLayoutMediator;

import br.com.acbr.lib.nfe.ACBrLibNFe;

public class ConfiguracoesNFeFragment extends Fragment {

    private FragmentConfiguracoesNfeBinding binding;
    private ACBrLibNFe ACBrNFe;
    private NfeApplication application;
    private ViewPagerAdapter adapter;
    private TabLayoutMediator mediator;

    @SuppressLint("MissingInflatedId")
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        binding = FragmentConfiguracoesNfeBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        
        configTabLayout();

        application = (NfeApplication) requireActivity().getApplicationContext();
        ACBrNFe = ACBrLibHelper.getInstance("");
    }



    private void configTabLayout() {
        // Configuração tradicional do ViewPager2
        adapter = new ViewPagerAdapter(requireActivity());
        
        // Adiciona os fragments
        adapter.addFragment(new ConfiguracoesGeraisFragment(), "Geral");
        adapter.addFragment(new ConfiguracoesWebServicesFragment(), "WebServices");
        adapter.addFragment(new ConfiguracoesCertificadosFragment(), "Certificados");
        adapter.addFragment(new ConfiguracoesArquivosFragment(), "Arquivos");
        adapter.addFragment(new ConfiguracoesEmailFragment(), "Email");
        adapter.addFragment(new ConfiguracoesDocumentoAuxiliarFragment(), "Documento Auxiliar");
        
        // Configura o ViewPager2
        binding.viewPager.setAdapter(adapter);
        
        // Otimização simples: mantém 2 páginas adjacentes em memória
        binding.viewPager.setOffscreenPageLimit(2);
        
        // Conecta as abas ao ViewPager2
        mediator = new TabLayoutMediator(binding.tabs, binding.viewPager, 
                (tab, position) -> tab.setText(adapter.getTitle(position)));
        mediator.attach();
    }



    @Override
    public void onDestroyView() {
        super.onDestroyView();
        
        // Limpa recursos do ViewPager
        if (mediator != null) {
            mediator.detach();
            mediator = null;
        }
        
        binding = null;
    }
}
