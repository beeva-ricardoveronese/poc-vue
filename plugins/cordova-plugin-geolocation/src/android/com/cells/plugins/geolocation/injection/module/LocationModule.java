package com.cells.plugins.geolocation.injection.module;

import android.support.annotation.NonNull;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;
import io.nlopez.smartlocation.SmartLocation;

/**
 * @author (c) 2016, Cells
 */
@Module
public class LocationModule {

    /**
     * The smart location
     */
    private SmartLocation mSmartLocation;

    /**
     * Create a configuration module
     * @param smartLocation Smart location
     */
    public LocationModule(@NonNull SmartLocation smartLocation) {
        mSmartLocation = smartLocation;
    }

    /**
     * Provide Smart location
     * @return smart location
     */
    @Provides
    @Singleton
    SmartLocation provideSmartLocation() {
        return mSmartLocation;
    }

}
