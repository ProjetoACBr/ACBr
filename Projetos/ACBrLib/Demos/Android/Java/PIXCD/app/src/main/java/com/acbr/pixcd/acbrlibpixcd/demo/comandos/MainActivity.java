package com.acbr.pixcd.acbrlibpixcd.demo.comandos;

import android.os.Bundle;
import android.util.Log;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.navigation.NavController;
import androidx.navigation.fragment.NavHostFragment;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

import com.acbr.pixcd.acbrlibpixcd.demo.R;
import com.acbr.pixcd.acbrlibpixcd.demo.utils.PIXCDApplication;

import br.com.acbr.lib.pixcd.ACBrLibPIXCD;
import com.google.android.material.bottomnavigation.BottomNavigationView;

public class MainActivity extends AppCompatActivity {

    private ACBrLibPIXCD ACBrPIXCD;
    private PIXCDApplication application;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        this.application = (PIXCDApplication) getApplicationContext();
        this.ACBrPIXCD = application.getACBrLibPIXCD();
        this.configurarACBrPIXCD();

        // Setup toolbar
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        // Configure Bottom Navigation with Navigation Component
        NavHostFragment navHostFragment = (NavHostFragment) getSupportFragmentManager()
                .findFragmentById(R.id.nav_host_fragment);
        if (navHostFragment != null) {
            NavController navController = navHostFragment.getNavController();
            BottomNavigationView bottomNav = findViewById(R.id.bottom_navigation);
            NavigationUI.setupWithNavController(bottomNav, navController);

            // Configure AppBar to update title from destination labels
            AppBarConfiguration appBarConfiguration = new AppBarConfiguration.Builder(
                    R.id.qrcodeFragment, R.id.endPointPixFragment, R.id.endPointCobFragment, R.id.endPointCobVFragment, R.id.configuracoesFragment
            ).build();
            NavigationUI.setupWithNavController(toolbar, navController, appBarConfiguration);
        }
    }

    private void configurarACBrPIXCD() {
        try {
            ACBrPIXCD.inicializar();
            aplicarConfiguracoesPadrao();
        } catch (Exception e) {
            Log.e("ACBrLibPIXCD", "Erro ao inicializar ACBrLibPIXCD", e);
        }
    }

    private void aplicarConfiguracoesPadrao(){
        try{
            ACBrPIXCD.configGravarValor("Principal", "LogPath", application.getLogPath());
            ACBrPIXCD.configGravarValor("Principal", "LogNivel", "4");
            ACBrPIXCD.configGravar();
            ACBrPIXCD.configLer(application.getArqConfigPath());
        } catch (Exception e){
            Log.e("MainActivity", e.getMessage());
        }
    }

    @Override
    protected void onDestroy(){
        super.onDestroy();
        if (ACBrPIXCD != null) {
            ACBrPIXCD.finalizar();
        }
    }
}