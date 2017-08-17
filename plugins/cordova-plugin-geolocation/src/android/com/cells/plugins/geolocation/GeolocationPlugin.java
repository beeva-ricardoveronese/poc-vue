/*
 * Copyright (c) 2011 CELLS All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * CELLS ("Confidential Information").  You shall not disclose such
 * Confidential Information and shall use it only in accordance with
 * the terms of the license agreement you entered into with CELLS
 */
package com.cells.plugins.geolocation;

import android.support.annotation.CheckResult;

import com.cells.plugins.base.BasePlugin;
import com.cells.plugins.base.command.AbstractCommand;
import com.cells.plugins.base.command.callback.CommandCallback;
import com.cells.plugins.base.preferences.impl.SecureSharedPreferencesStore;
import com.cells.plugins.geolocation.command.CommandFactory;
import com.cells.plugins.geolocation.configuration.PluginConfiguration;
import com.cells.plugins.geolocation.injection.component.DaggerPluginComponent;
import com.cells.plugins.geolocation.injection.component.PluginComponent;
import com.cells.plugins.geolocation.injection.module.JSBridgeModule;
import com.cells.plugins.geolocation.injection.module.LocationModule;
import com.cells.plugins.geolocation.injection.module.StoreModule;
import com.cells.plugins.geolocation.postmessage.PostMessenger;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

import javax.inject.Inject;

import io.nlopez.smartlocation.SmartLocation;

/**
 * Plugin define the plugin cordova
 *
 * @author (c) 2015, Cells
 */
public class GeolocationPlugin extends BasePlugin {

    /**
     * Plugin Component
     */
    private PluginComponent mPluginComponent;

    /**
     * Command Factory
     */
    @Inject
    CommandFactory mCommandFactory;


    /**
     * Configuration
     */
    @Inject
    PluginConfiguration mConfiguration;

    /**
     * Create Plugin Component
     *
     * @return Plugin component
     */
    @CheckResult(suggest = "#inject( GeolocationPlugin )")
    PluginComponent component() {
        if (mPluginComponent == null) {
            mPluginComponent = DaggerPluginComponent.builder()
                    .pluginModule(createPluginModule())
                    .storeModule(new StoreModule(new PluginConfiguration(new SecureSharedPreferencesStore(cordova.getActivity()))))
                    .jSBridgeModule(new JSBridgeModule(new PostMessenger(cordova.getActivity(), mWebView, getClass().getSimpleName())))
                    .locationModule(new LocationModule(SmartLocation.with(cordova.getActivity())))
                    .build();
        }

        return mPluginComponent;
    }

    @Override
    protected void pluginInitialize() {
        super.pluginInitialize();
        component().inject(this);
        mConfiguration.loadDefault(cordova.getActivity(), getClass().getName());
    }

    /**
     * Execute plugin
     *
     * @param action          The action to execute.
     * @param data            The data plugin
     * @param callbackContext The callback context used when calling back into JavaScript.
     * @return The state plugin
     */
    @Override
    public boolean execute(final String action, final JSONArray data, final CallbackContext callbackContext) throws JSONException {

        AbstractCommand command = mCommandFactory.getCommand(action);
        executeCommand(command, data, new CommandCallback(callbackContext));

        return true;
    }

}