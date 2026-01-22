package com.acbr.consultacnpj.acbrlibconsultacnpj.demo.ui.fragment;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.fragment.app.Fragment;

import com.acbr.consultacnpj.acbrlibconsultacnpj.demo.R;
import com.acbr.consultacnpj.acbrlibconsultacnpj.demo.source.ACBrLibHelper;
import com.google.android.material.textfield.TextInputEditText;
import br.com.acbr.lib.consultacnpj.ACBrLibConsultaCNPJ;

public class IniFragment extends Fragment {
    private ACBrLibConsultaCNPJ ACBrConsultaCNPJ;
    private TextInputEditText txtIni;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_ini, container, false);

        ACBrConsultaCNPJ = ACBrLibHelper.getInstance("");

        txtIni = view.findViewById(R.id.txtIni);

        return view;
    }


    @Override 
    public void onResume() {
        super.onResume();
        lerIni();
    }

    private void lerIni() {
        try {
            String ini = ACBrConsultaCNPJ.configExportar();
            txtIni.setText(ini);
        } catch (Exception ex) {
            Log.e("Erro", " - Ler INI: " + ex.getMessage());
            txtIni.setText(ex.getMessage());
        }
    }
} 