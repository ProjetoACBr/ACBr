/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.acbr.nfcom;

import java.util.HashMap;
import java.util.Map;

public enum TipoPathNFCom {
    NFCom(0),
    Cancelamento(1);

    private static final Map<Integer, TipoPathNFCom> map;
    private final int enumValue;

    static {
        map = new HashMap<>();
        for (TipoPathNFCom value : TipoPathNFCom.values()) {
            map.put(value.asInt(), value);
        }
    }

    public static TipoPathNFCom valueOf(int value) {
        return map.get(value);
    }

    private TipoPathNFCom(int id) {
        this.enumValue = id;
    }

    public int asInt() {
        return enumValue;
    }
}
