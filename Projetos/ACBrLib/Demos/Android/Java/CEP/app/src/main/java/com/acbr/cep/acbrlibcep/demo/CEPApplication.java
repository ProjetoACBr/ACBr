package com.acbr.cep.acbrlibcep.demo;

import android.app.Application;

import com.acbr.cep.acbrlibcep.demo.source.ACBrLibHelper;

import java.io.File;

import br.com.acbr.lib.cep.ACBrLibCep;
public class CEPApplication extends Application {

    private File appDir;
    private ACBrLibCep ACBrCEP;
    public final String ARQCONFIG_PADRAO = "ACBrLib.ini";
    public final String LOG_PATH_PADRAO = "logs";
    private String arqConfigPath;

    private String[] treeDirectory = {
            LOG_PATH_PADRAO
    };

    private String logPath;

    @Override
    public void onCreate(){
        super.onCreate();

        appDir = getExternalFilesDir(null);
        initRootDirectory();
        arqConfigPath = appDir.getAbsolutePath() + "/" + ARQCONFIG_PADRAO;
        logPath = appDir.getAbsolutePath() + "/" + LOG_PATH_PADRAO;
        ACBrCEP = ACBrLibHelper.getInstance(arqConfigPath);
    }


    private void initRootDirectory() {
        if (!appDir.exists())
            appDir.mkdir();

        for (String currentDir : treeDirectory) {
            File f = new File(appDir, currentDir);
            if (!f.exists()) {
                f.mkdirs();
            }
        }
    }

    public File getAppDir(){
        return appDir;
    }

    public String getArqConfigPath() {
        return arqConfigPath;
    }

    public ACBrLibCep getAcBrLibCEP() {
        return ACBrCEP;
    }

    public String getLogPath() {
        return logPath;
    }

}

