package com.acbr.cep.acbrlibcep.demo;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.util.Log;

import androidx.appcompat.app.AppCompatActivity;

import com.acbr.cep.acbrlibcep.demo.databinding.ActivityMainBinding;
import com.google.android.material.tabs.TabLayoutMediator;

import br.com.acbr.lib.cep.ACBrLibCep;

public class MainActivity extends AppCompatActivity {

    private ActivityMainBinding binding;

    private ACBrLibCep ACBrCEP;
    private CEPApplication application;

    @SuppressLint("MissingInflatedId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
        application = ((CEPApplication) getApplication());
        ACBrCEP = application.getAcBrLibCEP();
        configurarACBrCEP();

    }

    @Override
    protected void onResume() {
        super.onResume();
        configTabLayout();
    }

    private void configTabLayout(){
        ViewPagerAdapter adapter = new ViewPagerAdapter(this);
        binding.viewPager.setAdapter(adapter);
        binding.viewPager.setOffscreenPageLimit(1);
        adapter.addFragment(new ComandosBuscarPorCEPFragment(), "Buscar Por CEP");
        adapter.addFragment(new ComandosBuscarPorLogradouroFragment(), "Buscar Por Logradouro");
        adapter.addFragment(new ConfiguracoesCEPFragment(), "Configurações");
        adapter.addFragment(new AcbrlibIniFragment(), "ACBrLib.ini");



        TabLayoutMediator mediator = new TabLayoutMediator(binding.tabs, binding.viewPager, (tab, position) -> {
            tab.setText(adapter.getTitle(position));
        });

        mediator.attach();
    }


    private void configurarACBrCEP() {
        try {
            ACBrCEP.inicializar();
            aplicarConfiguracoesPadrao();
        } catch (Exception e) {
            Log.e("ACBrLibConsultaCNPJ", "Erro ao inicializar ACBrLibCEP", e);
        }
    }
    private void aplicarConfiguracoesPadrao() {
        try {
            ACBrCEP.configGravarValor("Principal", "LogPath", application.getLogPath());
            ACBrCEP.configGravarValor("Principal", "LogNivel", "4");
            ACBrCEP.configGravarValor("CEP", "SSLType", "5");
            ACBrCEP.configGravar();
        } catch (Exception e) {
            Log.e("MainActivity", e.getMessage());
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        ACBrCEP.finalizar();
    }
}