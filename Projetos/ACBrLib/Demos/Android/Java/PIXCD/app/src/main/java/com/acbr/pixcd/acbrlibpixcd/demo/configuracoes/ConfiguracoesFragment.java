package com.acbr.pixcd.acbrlibpixcd.demo.configuracoes;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.viewpager2.widget.ViewPager2;

import com.acbr.pixcd.acbrlibpixcd.demo.R;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesAilosFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesBancoBrasilFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesBradescoFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesCieloFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesGerenciaNetFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesInterFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesItauFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesMateraFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesMercadoPagoFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesPagSeguroFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesPixPDVFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesSantanderFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesShipayFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesSicoobFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.configuracoes.psp.ConfiguracoesSicrediFragment;
import com.acbr.pixcd.acbrlibpixcd.demo.utils.ACBrLibHelper;
import com.acbr.pixcd.acbrlibpixcd.demo.utils.ViewPagerAdapter;
import com.google.android.material.navigation.NavigationView;
import com.google.android.material.tabs.TabLayout;
import com.google.android.material.tabs.TabLayoutMediator;

import java.util.HashMap;
import java.util.Map;

import br.com.acbr.lib.pixcd.ACBrLibPIXCD;

public class ConfiguracoesFragment extends Fragment {

    private ACBrLibPIXCD ACBrPIXCD;

    @SuppressLint("MissingInflatedId")
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        // Inflate the ViewPager + TabLayout layout used previously by the activity
        View view = inflater.inflate(R.layout.activity_configuracoes_pixcd, container, false);

        ACBrPIXCD = ACBrLibHelper.getInstance("");

        ViewPager2 viewPager = view.findViewById(R.id.viewPager);
        TabLayout tabs = view.findViewById(R.id.tabs);
        NavigationView navigationView = view.findViewById(R.id.navigationView);

        ViewPagerAdapter adapter = new ViewPagerAdapter(requireActivity());
        adapter.addFragment(new ConfiguracoesPIXCDFragment(), "Configurações PIXCD");
        adapter.addFragment(new ConfiguracoesBradescoFragment(), "Bradesco");
        adapter.addFragment(new ConfiguracoesSicrediFragment(), "Sicredi");
        adapter.addFragment(new ConfiguracoesSicoobFragment(), "Sicoob");
        adapter.addFragment(new ConfiguracoesShipayFragment(), "Shipay");
        adapter.addFragment(new ConfiguracoesSantanderFragment(), "Santander");
        adapter.addFragment(new ConfiguracoesPixPDVFragment(), "PixPDV");
        adapter.addFragment(new ConfiguracoesPagSeguroFragment(), "PagSeguro");
        adapter.addFragment(new ConfiguracoesItauFragment(), "Itau");
        adapter.addFragment(new ConfiguracoesInterFragment(), "Inter");
        adapter.addFragment(new ConfiguracoesGerenciaNetFragment(), "GerenciaNet");
        adapter.addFragment(new ConfiguracoesBancoBrasilFragment(), "Banco do Brasil");
        adapter.addFragment(new ConfiguracoesAilosFragment(), "Ailos");
        adapter.addFragment(new ConfiguracoesMateraFragment(), "Matera");
        adapter.addFragment(new ConfiguracoesCieloFragment(), "Cielo");
        adapter.addFragment(new ConfiguracoesMercadoPagoFragment(), "MercadoPago");

        viewPager.setAdapter(adapter);
        viewPager.setOffscreenPageLimit(adapter.getItemCount());

        new TabLayoutMediator(tabs, viewPager, (tab, position) -> tab.setText(adapter.getTitle(position))).attach();

        Map<Integer, Integer> menuPositionMap = new HashMap<>();
        menuPositionMap.put(R.id.menu_pixcd, 0);
        menuPositionMap.put(R.id.menu_bradesco, 1);
        menuPositionMap.put(R.id.menu_sicredi, 2);
        menuPositionMap.put(R.id.menu_sicoob, 3);
        menuPositionMap.put(R.id.menu_shipay, 4);
        menuPositionMap.put(R.id.menu_santander, 5);
        menuPositionMap.put(R.id.menu_pixpdv, 6);
        menuPositionMap.put(R.id.menu_pagseguro, 7);
        menuPositionMap.put(R.id.menu_itau, 8);
        menuPositionMap.put(R.id.menu_inter, 9);
        menuPositionMap.put(R.id.menu_gerencianet, 10);
        menuPositionMap.put(R.id.menu_bancobrasil, 11);
        menuPositionMap.put(R.id.menu_ailos, 12);
        menuPositionMap.put(R.id.menu_matera, 13);
        menuPositionMap.put(R.id.menu_cielo, 14);
        menuPositionMap.put(R.id.menu_mercadopago, 15);

        navigationView.setNavigationItemSelectedListener(item -> {
            Integer position = menuPositionMap.getOrDefault(item.getItemId(), 0);

            viewPager.setCurrentItem(position, true);
            View drawer = view.findViewById(R.id.drawerLayout);
            if (drawer instanceof androidx.drawerlayout.widget.DrawerLayout) {
                ((androidx.drawerlayout.widget.DrawerLayout) drawer).closeDrawer(androidx.core.view.GravityCompat.START);
            }
            return true;
        });

        return view;
    }
}
