package com.cells.plugins.geolocation.injection.module;

import android.support.annotation.NonNull;

import com.cells.plugins.geolocation.configuration.PluginConfiguration;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;

/**
 * @author (c) 2016, Cells
 */
@Module
public class StoreModule {

    /**
     * Configuration
     */
    private PluginConfiguration mConfiguration;

    /**
     * Create a configuration module
     * @param abstractConfiguration Configuration
     */
    public StoreModule(@NonNull PluginConfiguration abstractConfiguration) {
        mConfiguration = abstractConfiguration;
    }

    /**
     * Provide Configuration
     * @return Configuration
     */
    @Provides
    @Singleton
    PluginConfiguration provideConfiguration() {
        return mConfiguration;
    }

}
