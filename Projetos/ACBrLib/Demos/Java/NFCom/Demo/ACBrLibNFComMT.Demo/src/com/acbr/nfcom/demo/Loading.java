/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author ericbortoleto
 */
package com.acbr.nfcom.demo;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.Window;
import javax.swing.JDialog;
import javax.swing.JPanel;
import javax.swing.SwingUtilities;
import javax.swing.Timer;
import javax.swing.border.EmptyBorder;

public class Loading extends JDialog {

    public Loading(Window owner) {
        // 'super(owner)' torna este diálogo dependente da janela principal
        // 'true' como terceiro parâmetro o torna MODAL
        super(owner, "Aguarde...", ModalityType.APPLICATION_MODAL);

        // Cria o painel de animação
        LoadingAnimation animationPanel = new LoadingAnimation();
        animationPanel.setBorder(new EmptyBorder(20, 20, 20, 20)); // Adiciona um respiro

        // Configurações do diálogo
        setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE); // Impede o usuário de fechar
        setResizable(false);
        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(animationPanel, BorderLayout.CENTER);
        pack();
        setLocationRelativeTo(owner); // Centraliza em relação à janela principal
    }

    public void start() {
        SwingUtilities.invokeLater(() -> setVisible(true));
    }

    /**
     * Fecha e libera os recursos do diálogo.
     */
    public void stop() {
        SwingUtilities.invokeLater(() -> {
            setVisible(false);
            dispose();
        });
    }
}

 class LoadingAnimation extends JPanel {
    private static final int DOT_COUNT = 12;
    private static final int RADIUS = 40; // Raio do círculo
    private static final int DOT_SIZE = 15; // Tamanho de cada ponto
    private static final int DELAY = 60; // Velocidade da animação (ms)
    private double angle = 0;

    // O construtor agora inicia a animação
    public LoadingAnimation() {
        setPreferredSize(new Dimension(200, 200)); // Um tamanho mais razoável
        setBackground(Color.WHITE);
        Timer timer = new Timer(DELAY, e -> {
            angle += Math.toRadians(10); // Avança 10° por frame
            repaint();
        });
        timer.start();
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2 = (Graphics2D) g;
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

        int cx = getWidth() / 2;
        int cy = getHeight() / 2;

        for (int i = 0; i < DOT_COUNT; i++) {
            double theta = angle + (2 * Math.PI / DOT_COUNT) * i;
            int x = (int) (cx + Math.cos(theta) * RADIUS) - DOT_SIZE / 2;
            int y = (int) (cy + Math.sin(theta) * RADIUS) - DOT_SIZE / 2;

            // Opacidade baseada na posição, para dar efeito de "cauda"
            float opacity = (float) (Math.sin(theta) + 1) / 2.0f;
            opacity = Math.max(0.1f, opacity); // Garante uma opacidade mínima
            
            g2.setColor(new Color(0, 0, 0, opacity));
            g2.fillOval(x, y, DOT_SIZE, DOT_SIZE);
        }
    }
}