package com.cells.plugins.geolocation.injection.component;

import com.cells.plugins.base.injection.component.AbstractPluginComponent;
import com.cells.plugins.base.injection.module.PluginModule;
import com.cells.plugins.geolocation.GeolocationPlugin;
import com.cells.plugins.geolocation.injection.module.LocationModule;
import com.cells.plugins.geolocation.injection.module.StoreModule;
import com.cells.plugins.geolocation.injection.module.JSBridgeModule;

import javax.inject.Singleton;

import dagger.Component;

/**
 * @author (c) 2016, Cells
 */
@Singleton
@Component(modules = {PluginModule.class, StoreModule.class, JSBridgeModule.class, LocationModule.class})
public interface PluginComponent extends AbstractPluginComponent{
	/**
     * @param plugin Plugin
     */
    void inject(GeolocationPlugin plugin);
}
