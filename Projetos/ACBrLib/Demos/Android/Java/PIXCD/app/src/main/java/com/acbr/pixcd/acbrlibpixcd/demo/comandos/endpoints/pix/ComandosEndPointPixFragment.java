package com.acbr.pixcd.acbrlibpixcd.demo.comandos.endpoints.pix;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.GravityCompat;
import androidx.fragment.app.Fragment;

import androidx.viewpager2.widget.ViewPager2;
import com.google.android.material.tabs.TabLayout;
import com.google.android.material.navigation.NavigationView;

import com.acbr.pixcd.acbrlibpixcd.demo.R;
import com.acbr.pixcd.acbrlibpixcd.demo.utils.ACBrLibHelper;
import com.acbr.pixcd.acbrlibpixcd.demo.utils.ViewPagerAdapter;
import com.google.android.material.tabs.TabLayoutMediator;

import br.com.acbr.lib.pixcd.ACBrLibPIXCD;

public class ComandosEndPointPixFragment extends Fragment {

    private ACBrLibPIXCD ACBrPIXCD;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.activity_comandos_endpoint_pix, container, false);

        ACBrPIXCD = ACBrLibHelper.getInstance("");

        // setup viewpager + tabs
        ViewPager2 viewPager = view.findViewById(R.id.viewPager);
        TabLayout tabs = view.findViewById(R.id.tabs);
        NavigationView navigationView = view.findViewById(R.id.navigationView);

        ViewPagerAdapter adapter = new ViewPagerAdapter(requireActivity());
        adapter.addFragment(new com.acbr.pixcd.acbrlibpixcd.demo.comandos.endpoints.pix.ComandosConsultarPixFragment(), "ConsultarPIX");
        adapter.addFragment(new com.acbr.pixcd.acbrlibpixcd.demo.comandos.endpoints.pix.ComandosConsultarPixRecebidosFragment(), "ConsultarPIXRecebidos");
        adapter.addFragment(new com.acbr.pixcd.acbrlibpixcd.demo.comandos.endpoints.pix.ComandosSolicitarDevolucaoPixFragment(), "SolicitarDevolucaoPIX");
        adapter.addFragment(new com.acbr.pixcd.acbrlibpixcd.demo.comandos.endpoints.pix.ComandosConsultarDevolucaoPixFragment(), "ConsultarDevolucaoPIX");

        viewPager.setAdapter(adapter);
        viewPager.setOffscreenPageLimit(adapter.getItemCount());

        new TabLayoutMediator(tabs, viewPager, (tab, position) -> tab.setText(adapter.getTitle(position))).attach();

        // map navigation drawer menu items to viewpager positions using if/else
        navigationView.setNavigationItemSelectedListener(item -> {
            int id = item.getItemId();
            int position = 0;
            if (id == R.id.menu_consultar_pix) position = 0;
            else if (id == R.id.menu_consultar_pix_recebidos) position = 1;
            else if (id == R.id.menu_solicitar_devolucao_pix) position = 2;
            else if (id == R.id.menu_consultar_devolucao_pix) position = 3;

            viewPager.setCurrentItem(position, true);
            // close drawer: parent is DrawerLayout in layout file
            View drawer = view.findViewById(R.id.drawerLayout);
            if (drawer instanceof androidx.drawerlayout.widget.DrawerLayout) {
                ((androidx.drawerlayout.widget.DrawerLayout) drawer).closeDrawer(GravityCompat.START);
            }
            return true;
        });

        return view;
    }
}
