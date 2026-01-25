package com.acbr.cep.acbrlibcep.demo;

import android.os.Bundle;

import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import br.com.acbr.lib.cep.ACBrLibCep;

public class AcbrlibIniFragment extends Fragment {

    private ACBrLibCep acbrCep;
    private TextView txtIniContent;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        acbrCep = ACBrLibHelper.getInstance("");
    }



    private void carregarIni() {
        String content = "";
        try {
             content = acbrCep.configExportar();

            // Process the iniContent as needed
        } catch (Exception e) {
            content = "Erro ao carregar o arquivo INI: " + e.getMessage();
        } finally {
            txtIniContent.setText(content);
        }
    }



    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view  = inflater.inflate(R.layout.fragment_acbrlib_ini, container, false);
        txtIniContent = view.findViewById(R.id.text_acbrlib_ini);

        return view;
    }


    @Override
    public void onResume() {
        super.onResume();
        carregarIni();
    }
}
