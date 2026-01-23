package com.acbr.pixcd.acbrlibpixcd.demo.comandos;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.acbr.pixcd.acbrlibpixcd.demo.R;

public class ComandosFragment extends Fragment {

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        // Return the empty comandos container (legacy buttons removed)
        return inflater.inflate(R.layout.fragment_comandos, container, false);
    }
}
