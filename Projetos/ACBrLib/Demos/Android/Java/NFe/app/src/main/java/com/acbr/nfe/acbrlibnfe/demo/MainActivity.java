package com.acbr.nfe.acbrlibnfe.demo;

import android.os.Bundle;
import android.util.Log;

import androidx.appcompat.app.AppCompatActivity;
import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.fragment.NavHostFragment;
import androidx.navigation.ui.NavigationUI;

import com.acbr.nfe.acbrlibnfe.demo.utils.NfeApplication;

import br.com.acbr.lib.comum.dfe.SSLCryptLib;
import br.com.acbr.lib.comum.dfe.SSLHttpLib;
import br.com.acbr.lib.comum.dfe.SSLXmlSignLib;
import br.com.acbr.lib.nfe.ACBrLibNFe;



public class MainActivity extends AppCompatActivity {

    private ACBrLibNFe ACBrNFe;
    private NfeApplication application;
    private NavController navController;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d("MainActivity", "Carregando layout activity_main");
        setContentView(R.layout.activity_main);
        Log.d("MainActivity", "Layout carregado, configurando navegação");
        
        // Configurar AppBar
        setupAppBar();
        
        // Configurar Navigation Controller
        setupNavigation();
        
        application = ((NfeApplication) getApplicationContext());
        ACBrNFe = application.getAcBrLibNFe();
        configurarACBrNFe();
        
        Log.d("MainActivity", "MainActivity configurada com Navigation Component");
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
                    setupBottomNavigation(bottomNavigationView);
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

    private void setupBottomNavigation(com.google.android.material.bottomnavigation.BottomNavigationView bottomNav) {
        // Configurar cores do BottomNavigationView
        int selectedColor = getColor(R.color.bottom_nav_selected);
        int unselectedColor = getColor(R.color.bottom_nav_unselected);
        
        android.content.res.ColorStateList colorStateList = new android.content.res.ColorStateList(
            new int[][] {
                new int[] { android.R.attr.state_checked },
                new int[] { }
            },
            new int[] {
                selectedColor,
                unselectedColor
            }
        );
        
        bottomNav.setItemIconTintList(colorStateList);
        bottomNav.setItemTextColor(colorStateList);
        
        bottomNav.setOnItemSelectedListener(item -> {
            int itemId = item.getItemId();
            if (itemId == R.id.nav_comandos) {
                navController.navigate(R.id.comandosNFeFragment);
                updateAppBarTitle("Comandos NFe");
                return true;
            } else if (itemId == R.id.nav_configuracoes) {
                navController.navigate(R.id.configuracoesNFeFragment);
                updateAppBarTitle("Configurações NFe");
                return true;
            } else if (itemId == R.id.nav_ini) {
                navController.navigate(R.id.configuracoesIniFragment);
                updateAppBarTitle("ACBrLib.ini");
                return true;
            }
            return false;
        });
    }

    private void updateAppBarTitle(String title) {
        if (getSupportActionBar() != null) {
            getSupportActionBar().setTitle(title);
        }
    }

    private void configurarACBrNFe() {
        try {
            ACBrNFe.inicializar();
            aplicarConfiguracoesPadrao();
        } catch (Exception e) {
            Log.e("ACBrLibNFe", "Erro ao inicializar ACBrLibNFe", e);
        }
    }

    private void aplicarConfiguracoesPadrao() {
        try {

            ACBrNFe.configGravarValor("NFe", "PathSchemas", application.getSchemasPath());
            ACBrNFe.configGravarValor("NFe", "PathSalvar", application.getPathSalvar());
            ACBrNFe.configGravarValor("Principal", "LogPath", application.getLogPath());
            ACBrNFe.configGravarValor("Principal", "LogNivel", "4");
            ACBrNFe.configGravarValor("DFe", "ArquivoPFX", application.getPfxPath());
            ACBrNFe.configGravarValor("DFe", "SSLCryptLib", Integer.toString(SSLCryptLib.cryOpenSSL.ordinal()));
            ACBrNFe.configGravarValor("DFe", "SSLHttpLib", Integer.toString(SSLHttpLib.httpOpenSSL.ordinal()));
            ACBrNFe.configGravarValor("DFe", "SSLXmlSignLib", Integer.toString(SSLXmlSignLib.xsLibXml2.ordinal()));
            ACBrNFe.configGravar();
            ACBrNFe.configLer(application.getArqConfigPath());
        } catch (Exception e) {
            Log.e("MainActivity", e.getMessage());
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        ACBrNFe.finalizar();
    }
}