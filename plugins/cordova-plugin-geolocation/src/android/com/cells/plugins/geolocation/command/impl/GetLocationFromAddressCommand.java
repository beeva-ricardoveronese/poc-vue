package com.cells.plugins.geolocation.command.impl;

import android.location.Location;

import com.cells.plugins.base.command.callback.CommandCallback;
import com.cells.plugins.geolocation.LocationUtils;
import com.cells.plugins.geolocation.command.impl.base.PermissionCommand;
import com.cells.plugins.geolocation.command.params.GetLocationFromAddressParams;
import com.cells.plugins.geolocation.command.response.GeolocationErrors;

import org.json.JSONObject;

import java.lang.ref.WeakReference;
import java.util.List;
import java.util.Locale;

import javax.inject.Inject;

import io.nlopez.smartlocation.SmartLocation;
import io.nlopez.smartlocation.geocoding.providers.AndroidGeocodingProvider;
import io.nlopez.smartlocation.geocoding.utils.LocationAddress;

/**
 * @author (c) 2016, Cells
 */
public class GetLocationFromAddressCommand extends PermissionCommand<GetLocationFromAddressParams> {

    /**
     * A GetCurrentPosition new command
     */
    @Inject
    public GetLocationFromAddressCommand() {
        super(GetLocationFromAddressParams.class);
    }

    @Override
    protected void executeWithPermissionGranted() {
        if (mParams != null) {
            retrieveNewLocation(mParams.getAddressLine());
        } else {
            mCommandCallback.sendError(GeolocationErrors.ErrorParams);
        }
    }

    /**
     * Location updated listener
     */
    private static class OnGeocodingListener implements io.nlopez.smartlocation.OnGeocodingListener {
        /**
         * Callback
         */
        WeakReference<CommandCallback> mCallbackWeakReference;

        /**
         * @param callback the callback
         */
        public OnGeocodingListener(CommandCallback callback) {
            mCallbackWeakReference = new WeakReference<>(callback);
        }

        @Override
        public void onLocationResolved(String name,  List<LocationAddress> results) {
            // name is the same you introduced in the parameters of the call
            // results could come empty if there is no match, so please add some checks around that
            // LocationAddress is a wrapper class for Address that has a Location based on its data

            CommandCallback commandCallback = mCallbackWeakReference.get();

            if(commandCallback == null){
                return;
            }

            if ((results != null) && (!results.isEmpty())) {
                Location addressLocation = results.get(0).getLocation();
                JSONObject resultJSONObject = LocationUtils.getLocationJSONObject(addressLocation);
                commandCallback.sendEvent(resultJSONObject);
            } else {
                commandCallback.sendError(GeolocationErrors.ErrorDirectLocation);
            }
        }
    }

    /**
     * Retrieve new location
     *
     * @param address the address to direct geocoding
     */
    private void retrieveNewLocation(String address) {
        SmartLocation.GeocodingControl controlManager = mSmartLocation.geocoding(new AndroidGeocodingProvider(Locale.getDefault()));
        if (controlManager != null) {
            controlManager.direct(address, new OnGeocodingListener(mCommandCallback));
        }
    }

}