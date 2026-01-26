package com.acbr.cep.acbrlibcep.demo;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.util.Log;

import androidx.appcompat.app.AppCompatActivity;
import androidx.navigation.NavController;
import androidx.navigation.fragment.NavHostFragment;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

import com.acbr.cep.acbrlibcep.demo.databinding.ActivityMainBinding;
import com.google.android.material.appbar.MaterialToolbar;
import com.google.android.material.bottomnavigation.BottomNavigationView;

import br.com.acbr.lib.cep.ACBrLibCep;

public class MainActivity extends AppCompatActivity {

    private ActivityMainBinding binding;
    private MaterialToolbar toolbar;
    private BottomNavigationView bottomNavigationView;
    private ACBrLibCep ACBrCEP;
    private CEPApplication application;

    @SuppressLint("MissingInflatedId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setupEdgeToEdge();
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        toolbar = binding.topAppBar;
        bottomNavigationView = binding.bottomNavigation;

        setSupportActionBar(toolbar);
        setupNavigation();
        setContentView(binding.getRoot());
        application = ((CEPApplication) getApplication());

    }


    @Override
    protected void onResume() {
        ACBrCEP = application.getAcBrLibCEP();
        configurarACBrCEP();
        super.onResume();

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
            ACBrCEP.configGravarValor("Principal", "LogNivel", "1");
            ACBrCEP.configGravarValor("CEP", "SSLType", "5");
            ACBrCEP.configGravar();
        } catch (Exception e) {
            Log.e("MainActivity", e.getMessage());
        }
    }


    private void setupEdgeToEdge() {
        // Configurar status bar com cor azul escura
        getWindow().setStatusBarColor(getColor(R.color.primary_blue_dark));
        getWindow().setNavigationBarColor(getColor(R.color.white));

        // Ícones da status bar em branco para contraste com azul escuro
        getWindow().getDecorView().setSystemUiVisibility(0);
    }


    private void setupNavigation() {
        NavHostFragment navHostFragment = (NavHostFragment) getSupportFragmentManager()
                .findFragmentById(R.id.nav_host_fragment);
        if (navHostFragment != null) {
            // Configure Bottom Navigation with Navigation Component
            NavController navController = navHostFragment.getNavController();
            NavigationUI.setupWithNavController(bottomNavigationView, navController);

            // Configure AppBar to update title from destination labels
            AppBarConfiguration appBarConfiguration = new AppBarConfiguration.Builder(
                    R.id.BuscarPorCepFragment,
                    R.id.BuscarPorLogradouroFragment,
                    R.id.ConfiguracoesCEPFragment,
                    R.id.AcbrlibIniFragment
            ).build();
            NavigationUI.setupWithNavController(toolbar, navController, appBarConfiguration);


        }
    }


    @Override
    protected void onDestroy() {

        if (ACBrCEP != null)
            ACBrCEP.finalizar();

        super.onDestroy();
    }
}