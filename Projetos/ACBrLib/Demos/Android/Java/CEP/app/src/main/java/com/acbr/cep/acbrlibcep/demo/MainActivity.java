package com.acbr.cep.acbrlibcep.demo;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.util.Log;

import androidx.appcompat.app.AppCompatActivity;
import androidx.navigation.NavController;
import androidx.navigation.fragment.NavHostFragment;
import androidx.navigation.ui.NavigationUI;

import com.acbr.cep.acbrlibcep.demo.databinding.ActivityMainBinding;

import br.com.acbr.lib.cep.ACBrLibCep;

public class MainActivity extends AppCompatActivity {

    private ActivityMainBinding binding;
    private NavController navController;

    private ACBrLibCep ACBrCEP;
    private CEPApplication application;

    @SuppressLint("MissingInflatedId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setupEdgeToEdge();
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
        setupAppBar();
        setupNavigation();
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
            ACBrCEP.configGravarValor("Principal", "LogNivel", "4");
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

    private void setupAppBar() {
        com.google.android.material.appbar.MaterialToolbar topAppBar = findViewById(R.id.topAppBar);
        setSupportActionBar(topAppBar);

        // Configurar título da AppBar baseado na navegação atual
        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayShowTitleEnabled(true);
            getSupportActionBar().setTitle("ACBr NFe Demo");
        }
    }

    private void setupNavigation() {
        try {
            // Obter o NavHostFragment
            NavHostFragment navHostFragment = (NavHostFragment) getSupportFragmentManager()
                    .findFragmentById(R.id.nav_host_fragment);

            if (navHostFragment != null) {
                navController = navHostFragment.getNavController();

                // Configurar BottomNavigationView
                com.google.android.material.bottomnavigation.BottomNavigationView bottomNavigationView =
                        findViewById(R.id.bottom_navigation);

                if (bottomNavigationView != null) {
                    // Usar integração padrão do Navigation Component com BottomNavigationView
                    NavigationUI.setupWithNavController(bottomNavigationView, navController);

                    // Configurar listener para atualizar o título da AppBar
                    navController.addOnDestinationChangedListener((controller, destination, arguments) -> {
                        updateAppBarTitle(destination.getId());
                    });

                    Log.d("MainActivity", "Navigation Controller e BottomNavigation configurados com sucesso");
                } else {
                    Log.e("MainActivity", "BottomNavigationView não encontrada!");
                }

            } else {
                Log.e("MainActivity", "NavHostFragment não encontrado!");
            }
        } catch (Exception e) {
            Log.e("MainActivity", "Erro ao configurar navegação: " + e.getMessage());
        }
    }

    private void updateAppBarTitle(int destinationId) {
        String title = "ACBr CEP Demo"; // Título padrão

        if (destinationId == R.id.BuscarPorCepFragment) {
            title = "Demo ACBr CEP";
        } else if (destinationId == R.id.BuscarPorLogradouroFragment) {
            title = "Buscar Por Logradouro";
        } else if (destinationId == R.id.ConfiguracoesCEPFragment) {
            title = "Configurações";
        } else if (destinationId == R.id.AcbrlibIniFragment) {
            title = "ACBrLib.ini";
        }

        if (getSupportActionBar() != null) {
            getSupportActionBar().setTitle(title);
        }
    }



    @Override
    protected void onDestroy() {

        if (ACBrCEP != null)
            ACBrCEP.finalizar();

        super.onDestroy();
    }
}