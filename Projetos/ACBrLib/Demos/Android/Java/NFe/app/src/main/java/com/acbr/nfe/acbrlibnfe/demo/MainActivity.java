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

/**
 * Activity principal do ACBrLibNFe Demo.
 * 
 * Container para navegação entre fragments de comandos e configurações NFe.
 * Inicializa a biblioteca ACBrLibNFe e gerencia o ciclo de vida da aplicação.
 * 
 * @author ACBr Team
 * @version 1.0
 */
public class MainActivity extends AppCompatActivity {

    private ACBrLibNFe ACBrNFe;
    private NfeApplication application;
    private NavController navController;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d("MainActivity", "Carregando layout activity_main");
        
        // Configurar edge-to-edge e status bar para Material 3
        setupEdgeToEdge();
        
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
        String title = "ACBr NFe Demo"; // Título padrão
        
        if (destinationId == R.id.comandosNFeFragment) {
            title = "Demo ACBrLibNFe";
        } else if (destinationId == R.id.configuracoesNFeFragment) {
            title = "Configurações";
        } else if (destinationId == R.id.configuracoesIniFragment) {
            title = "ACBrLib.ini";
        }
        
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