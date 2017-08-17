package com.cells.plugins.geolocation;

import android.location.Geocoder;
import android.os.Build;
import android.support.annotation.CheckResult;
import android.test.suitebuilder.annotation.SmallTest;

import com.cells.plugins.base.base.BaseCommandsTest;
import com.cells.plugins.base.preferences.impl.MockSharedPreferencesStore;
import com.cells.plugins.geolocation.command.CommandFactory;
import com.cells.plugins.geolocation.configuration.PluginConfiguration;
import com.cells.plugins.geolocation.injection.DaggerPluginTestComponent;
import com.cells.plugins.geolocation.injection.PluginTestComponent;
import com.cells.plugins.geolocation.injection.module.JSBridgeModule;
import com.cells.plugins.geolocation.injection.module.StoreModule;
import com.cells.plugins.geolocation.postmessage.PostMessenger;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.MockitoAnnotations;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.robolectric.RobolectricGradleTestRunner;
import org.robolectric.annotation.Config;

import javax.inject.Inject;

import io.cordova.hellocordova.BuildConfig;

import static org.mockito.Mockito.mock;

/**
 * @author (c) 2016, Cells
 */
@RunWith(RobolectricGradleTestRunner.class)
@Config(constants = BuildConfig.class,
        sdk = Build.VERSION_CODES.KITKAT)
@PrepareForTest(Geocoder.class)
public class GeolocationPluginCommandsTest extends BaseCommandsTest{

    /**
     * Plugin Component
     */
    private PluginTestComponent mPluginTestComponent;

    /**
     * Command Factory
     */
    @Inject CommandFactory mCommandFactory;

    /**
     * Create Plugin Test Component
     *
     * @return Plugin test component
     */
    @CheckResult(suggest = "#inject(GeolocationPluginCommandTest)")
    PluginTestComponent component() {
        if (mPluginTestComponent == null) {
            mPluginTestComponent = DaggerPluginTestComponent.builder()
                    .pluginModule(getPluginModule())
                    .storeModule(new StoreModule(new PluginConfiguration(new MockSharedPreferencesStore())))
                    .jSBridgeModule(new JSBridgeModule(mock(PostMessenger.class)))
                    .build();
        }

        return mPluginTestComponent;
    }

    /**
     * Setup Test
     */
    @Before
    public void setupTest() {
        MockitoAnnotations.initMocks(this);

        component().inject(this);
    }

    /**
     * Test getcurrentposition command
     */
    @Test
    @SmallTest
    public void getCurrentPositionCommandTest() {
//        JSONArray params = readParams("tests/assets/geolocation/command_getcurrentposition_params.json");
//
//        mCommandFactory.getCommand(CommandFactory.ACTION_GETCURRENTPOSITION).executeAction(
//                params, mCommandCallback
//        );
//
//        verify(mCommandCallback).sendEvent(anyString());
    }

    /**
     * Test addressfromlocation command
     */
    @Test
    @SmallTest
    public void getAddressFromLocationCommandTest() {
//        JSONArray params = readParams("tests/assets/geolocation/command_addressfromlocation_params.json");
//
//        GetAddressFromLocationCommand command = (GetAddressFromLocationCommand) mCommandFactory.getCommand(CommandFactory.ACTION_GETADDRESSFROMLOCATION);
//
//        command.executeAction(
//                params, mCommandCallback
//        );
//
//        verify(mCommandCallback).sendEvent(anyString());
    }

}
