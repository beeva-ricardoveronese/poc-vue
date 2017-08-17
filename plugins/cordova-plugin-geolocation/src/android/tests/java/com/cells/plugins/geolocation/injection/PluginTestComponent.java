package com.cells.plugins.geolocation.injection;

import com.cells.plugins.base.injection.module.PluginModule;
import com.cells.plugins.geolocation.GeolocationPluginCommandsTest;
import com.cells.plugins.geolocation.injection.component.PluginComponent;
import com.cells.plugins.geolocation.injection.module.JSBridgeModule;
import com.cells.plugins.geolocation.injection.module.LocationModule;
import com.cells.plugins.geolocation.injection.module.StoreModule;

import javax.inject.Singleton;

import dagger.Component;

/**
 * @author (c) 2016, Cells
 */
@Singleton
@Component(modules = {PluginModule.class, StoreModule.class, LocationModule.class, JSBridgeModule.class})
public  interface PluginTestComponent extends PluginComponent {
	/**
     * Inject Test
     * @param test Test
     */
    void inject(GeolocationPluginCommandsTest test);
}
