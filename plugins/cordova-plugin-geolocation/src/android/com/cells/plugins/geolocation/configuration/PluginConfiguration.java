package com.cells.plugins.geolocation.configuration;

import com.cells.plugins.base.configuration.AbstractConfiguration;
import com.cells.plugins.base.preferences.PreferencesStore;
import com.cells.plugins.geolocation.configuration.model.ConfigurationModel;

import javax.inject.Inject;

/**
 * @author (c) 2016, Cells
 */
public class PluginConfiguration extends AbstractConfiguration<ConfigurationModel> {

	/**
     * Create a new Plugin configuration
     * 
     * @param preferencesStore Preference store
     */
    @Inject
    public PluginConfiguration(PreferencesStore preferencesStore) {
        super(ConfigurationModel.class, preferencesStore);
    }

}
