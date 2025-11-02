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

public class ComandosNFeFragment extends Fragment {

    private FragmentComandosNfeBinding binding;
    private ACBrLibNFe ACBrNFe;

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
        ViewPagerAdapter adapter = new ViewPagerAdapter(requireActivity());
        binding.viewPager.setAdapter(adapter);

        adapter.addFragment(new ComandosEnvioNFeFragment(), "Envio");
        adapter.addFragment(new ComandosConsultaNFeFragment(), "Consultas");
        adapter.addFragment(new ComandosEventoNFeFragment(), "Eventos");
        adapter.addFragment(new ComandosInutilizacaoNFeFragment(), "Inutilização");
        adapter.addFragment(new ComandosDistribuicaoNFeFragment(), "Distribuição DFe");

        binding.viewPager.setOffscreenPageLimit(adapter.getItemCount());

        TabLayoutMediator mediator = new TabLayoutMediator(binding.tabs, binding.viewPager, (tab, position) -> {
            tab.setText(adapter.getTitle(position));
        });

        mediator.attach();
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
