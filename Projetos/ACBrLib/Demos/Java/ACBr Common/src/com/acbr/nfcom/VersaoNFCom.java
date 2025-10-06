/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.acbr.nfcom;

import java.util.HashMap;
import java.util.Map;

public enum VersaoNFCom {
    ve100(0);

    private static final Map<Integer, VersaoNFCom> map;
    private final int enumValue;

    static {
        map = new HashMap<>();
        for (VersaoNFCom value : VersaoNFCom.values()) {
            map.put(value.asInt(), value);
        }
    }

    public static VersaoNFCom valueOf(int value) {
        return map.get(value);
    }

    private VersaoNFCom(int id) {
        this.enumValue = id;
    }

    public int asInt() {
        return enumValue;
    }
}
