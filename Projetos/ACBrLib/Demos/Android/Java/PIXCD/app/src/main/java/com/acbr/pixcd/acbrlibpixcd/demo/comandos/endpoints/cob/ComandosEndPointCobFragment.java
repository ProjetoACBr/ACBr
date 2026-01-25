package com.acbr.pixcd.acbrlibpixcd.demo.comandos.endpoints.cob;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.viewpager2.widget.ViewPager2;
import com.google.android.material.tabs.TabLayout;
import com.google.android.material.navigation.NavigationView;

import com.acbr.pixcd.acbrlibpixcd.demo.R;
import com.acbr.pixcd.acbrlibpixcd.demo.utils.ACBrLibHelper;
import com.acbr.pixcd.acbrlibpixcd.demo.utils.ViewPagerAdapter;
import com.google.android.material.tabs.TabLayoutMediator;

import br.com.acbr.lib.pixcd.ACBrLibPIXCD;

public class ComandosEndPointCobFragment extends Fragment {

    private ACBrLibPIXCD ACBrPIXCD;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_comandos_endpoint_cob, container, false);

        ACBrPIXCD = ACBrLibHelper.getInstance("");

        ViewPager2 viewPager = view.findViewById(R.id.viewPager);
        TabLayout tabs = view.findViewById(R.id.tabs);
        NavigationView navigationView = view.findViewById(R.id.navigationView);

        ViewPagerAdapter adapter = new ViewPagerAdapter(requireActivity());
        adapter.addFragment(new com.acbr.pixcd.acbrlibpixcd.demo.comandos.endpoints.cob.ComandosCriarCobrancaImediataFragment(), "Criar Cobrança Imediata");
        adapter.addFragment(new com.acbr.pixcd.acbrlibpixcd.demo.comandos.endpoints.cob.ComandosConsultarCobrancaImediataFragment(), "Consultar Cobrança Imediata");
        adapter.addFragment(new com.acbr.pixcd.acbrlibpixcd.demo.comandos.endpoints.cob.ComandosConsultarCobrancasCobFragment(), "Consultar Cobranças Cob");
        adapter.addFragment(new com.acbr.pixcd.acbrlibpixcd.demo.comandos.endpoints.cob.ComandosRevisarCobrancaImediataFragment(), "Revisar Cobrança Imediata");
        adapter.addFragment(new com.acbr.pixcd.acbrlibpixcd.demo.comandos.endpoints.cob.ComandosCancelarCobrancaImediataFragment(), "Cancelar Cobrança Imediata");

        viewPager.setAdapter(adapter);
        viewPager.setOffscreenPageLimit(adapter.getItemCount());

        new TabLayoutMediator(tabs, viewPager, (tab, position) -> tab.setText(adapter.getTitle(position))).attach();

        navigationView.setNavigationItemSelectedListener(item -> {
            int id = item.getItemId();
            int position = 0;
            if (id == R.id.menu_criar_cobranca_imediata) position = 0;
            else if (id == R.id.menu_consultar_cobranca_imediata) position = 1;
            else if (id == R.id.menu_consultar_cobrancas_cob) position = 2;
            else if (id == R.id.menu_revisar_cobranca_imediata) position = 3;
            else if (id == R.id.menu_cancelar_cobranca_imediata) position = 4;

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
