package com.cells.plugins.geolocation.injection.module;

import android.support.annotation.NonNull;

import com.cells.plugins.geolocation.postmessage.PostMessenger;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;

/**
 * @author (c) 2016, Cells
 */
@Module
public class JSBridgeModule {

    /**
     * Java > JS - Post messenger
     */
    private PostMessenger mPostMessenger;

    /**
     * Create a js bridge module
     * @param postMessenger Post messenger
     */
    public JSBridgeModule(@NonNull PostMessenger postMessenger) {
        mPostMessenger = postMessenger;
    }

    /**
     * Provide Post messenger
     * @return Post messenger
     */
    @Provides
    @Singleton
    PostMessenger providePostMessenger() {
        return mPostMessenger;
    }
}
