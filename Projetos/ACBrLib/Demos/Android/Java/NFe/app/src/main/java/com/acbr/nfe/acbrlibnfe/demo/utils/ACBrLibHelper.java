package com.acbr.nfe.acbrlibnfe.demo.utils;

import br.com.acbr.lib.nfe.ACBrLibNFe;

/**
 * Helper para gerenciamento de instância única da ACBrLibNFe.
 * 
 * Implementa padrão Singleton para garantir uma única instância
 * da biblioteca ACBrLibNFe em toda a aplicação.
 * 
 * @author ACBr Team
 */
public class ACBrLibHelper {

    private static ACBrLibNFe ACBrNFe;

    /**
     * Retorna instância única da ACBrLibNFe (Singleton).
     * 
     * Cria nova instância apenas se não existir. Caso contrário,
     * retorna a instância já criada.
     * 
     * @param fileConfig caminho para arquivo de configuração ACBrLib.ini
     * @return instância única da ACBrLibNFe
     */
    public static ACBrLibNFe getInstance(String fileConfig) {
        if (ACBrNFe == null) {
            ACBrNFe = new ACBrLibNFe(fileConfig, "");
        }
        return ACBrNFe;
    }
}
