package com.acbr.pixcd.acbrlibpixcd.demo.comandos;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;

import com.acbr.pixcd.acbrlibpixcd.demo.R;
import com.acbr.pixcd.acbrlibpixcd.demo.comandos.endpoints.cob.ComandosEndPointCobActivity;
import com.acbr.pixcd.acbrlibpixcd.demo.comandos.endpoints.cobv.ComandosEndPointCobVActivity;
import com.acbr.pixcd.acbrlibpixcd.demo.comandos.endpoints.pix.ComandosEndPointPixActivity;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.ConfiguracoesPIXCDActivity;
import com.acbr.pixcd.acbrlibpixcd.demo.utils.PIXCDApplication;

import br.com.acbr.lib.pixcd.ACBrLibPIXCD;

public class MainActivity extends AppCompatActivity {

    private ACBrLibPIXCD ACBrPIXCD;
    private PIXCDApplication application;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_comandos_pixcd);

        Button btnQRCodeEstatico = findViewById(R.id.btnQRCodeEstatico);
        Button btnEndPointPix = findViewById(R.id.btnEndPointPix);
        Button btnEndPointCob = findViewById(R.id.btnEndPointCob);
        Button btnEndPointCobV = findViewById(R.id.btnEndPointCobV);
        Button btnConfiguracoes = findViewById(R.id.btnAbrirConfiguracoes);

        btnQRCodeEstatico.setOnClickListener(view -> IrParaTelaQRCodeEstatico());
        btnEndPointPix.setOnClickListener(view -> IrParaTelaEndPointPix());
        btnEndPointCob.setOnClickListener(view -> IrParaTelaEndPointCob());
        btnEndPointCobV.setOnClickListener(view -> IrParaTelaEndPointCobV());
        btnConfiguracoes.setOnClickListener(view -> IrParaTelaConfiguracoes());

        this.application = (PIXCDApplication) getApplicationContext();
        this.ACBrPIXCD = application.getACBrLibPIXCD();
        this.configurarACBrPIXCD();
    }

    private void IrParaTelaQRCodeEstatico(){
        Intent intent = new Intent(this, ComandosQRCodeEstaticoActivity.class);
        startActivity(intent);
    }

    private void IrParaTelaEndPointPix(){
        Intent intent = new Intent(this, ComandosEndPointPixActivity.class);
        startActivity(intent);
    }

    private void IrParaTelaEndPointCob(){
        Intent intent = new Intent(this, ComandosEndPointCobActivity.class);
        startActivity(intent);
    }

    private void IrParaTelaEndPointCobV(){
        Intent intent = new Intent(this, ComandosEndPointCobVActivity.class);
        startActivity(intent);
    }

    private void IrParaTelaConfiguracoes(){
        Intent intent = new Intent(this, ConfiguracoesPIXCDActivity.class);
        startActivity(intent);
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
        ACBrPIXCD.finalizar();
    }
}