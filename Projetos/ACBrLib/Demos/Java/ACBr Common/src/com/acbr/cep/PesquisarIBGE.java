/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.acbr.cep;

import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author rften
 */
public enum PesquisarIBGE {
    Nao(0),
    Sim(1);

    private static final Map<Integer, PesquisarIBGE> map;
    private final int enumValue;

    static {
        map = new HashMap<>();
        for (PesquisarIBGE value : PesquisarIBGE.values()) {
            map.put(value.asInt(), value);
        }
    }

    public static PesquisarIBGE valueOf(int value) {
        return map.get(value);
    }

    private PesquisarIBGE(int id) {
        this.enumValue = id;
    }

    public int asInt() {
        return enumValue;
    }
}
