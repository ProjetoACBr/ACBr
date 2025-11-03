package com.acbr.nfe.acbrlibnfe.demo.comandos;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.acbr.nfe.acbrlibnfe.demo.databinding.FragmentComandosNfeBinding;
import com.acbr.nfe.acbrlibnfe.demo.utils.ACBrLibHelper;
import com.acbr.nfe.acbrlibnfe.demo.utils.ViewPagerAdapter;
import com.google.android.material.tabs.TabLayoutMediator;

import br.com.acbr.lib.nfe.ACBrLibNFe;

/**
 * Container principal para comandos NFe organizados em abas.
 * 
 * Utiliza ViewPager2 com TabLayout para navegação entre:
 * Envio, Consulta, Inutilização, Eventos e Distribuição DFe.
 * 
 * @author ACBr Team
 */
public class ComandosNFeFragment extends Fragment {

    private FragmentComandosNfeBinding binding;
    private ACBrLibNFe ACBrNFe;
    private ViewPagerAdapter adapter;
    private TabLayoutMediator mediator;

    @SuppressLint("MissingInflatedId")
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        binding = FragmentComandosNfeBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        
        configTabLayout();
        ACBrNFe = ACBrLibHelper.getInstance("");
    }

    private void configTabLayout(){
        // Configuração tradicional do ViewPager2
        adapter = new ViewPagerAdapter(requireActivity());
        
        // Adiciona os fragments
        adapter.addFragment(new ComandosEnvioNFeFragment(), "Envio");
        adapter.addFragment(new ComandosConsultaNFeFragment(), "Consultas");
        adapter.addFragment(new ComandosEventoNFeFragment(), "Eventos");
        adapter.addFragment(new ComandosInutilizacaoNFeFragment(), "Inutilização");
        adapter.addFragment(new ComandosDistribuicaoNFeFragment(), "Distribuição DFe");
        
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
