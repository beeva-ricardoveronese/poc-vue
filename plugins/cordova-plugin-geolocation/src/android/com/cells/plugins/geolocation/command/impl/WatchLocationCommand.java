package com.cells.plugins.geolocation.command.impl;

import android.location.Location;

import com.cells.plugins.base.command.callback.CommandCallback;
import com.cells.plugins.base.command.response.Errors;
import com.cells.plugins.base.utils.Tracer;
import com.cells.plugins.geolocation.LocationUtils;
import com.cells.plugins.geolocation.command.impl.base.PermissionCommand;
import com.cells.plugins.geolocation.command.params.WatchLocationParams;
import com.cells.plugins.geolocation.command.response.GeolocationErrors;
import com.cells.plugins.geolocation.postmessage.PostMessenger;
import com.cells.plugins.geolocation.postmessage.dto.LocationDTO;

import org.json.JSONObject;

import java.lang.ref.WeakReference;

import javax.inject.Inject;

import io.nlopez.smartlocation.OnLocationUpdatedListener;
import io.nlopez.smartlocation.location.config.LocationAccuracy;
import io.nlopez.smartlocation.location.config.LocationParams;

/**
 * @author (c) 2016, Cells
 */
public class WatchLocationCommand extends PermissionCommand<WatchLocationParams> {

    /**
     * The post messenger
     */
    @Inject
    PostMessenger postMessenger;

    /**
     * A GetCurrentPosition new command
     */
    @Inject
    public WatchLocationCommand() {
        super(WatchLocationParams.class);
    }

    @Override
    protected void executeWithPermissionGranted() {

        LocationParams params;

        if (mParams != null) {
            LocationParams.Builder paramsLocation = new LocationParams.Builder();
            paramsLocation  .setAccuracy(LocationAccuracy.HIGH)
                            .setDistance(0.0F)
                            .setInterval(mParams.getInterval());

            params = paramsLocation.build();

        } else {
            params = LocationParams.NAVIGATION;
        }

        try {

            mSmartLocation  .location()
                    .config(params)
                    .start(new LocationUpdatedListener(mCommandCallback, postMessenger));

            // send ok event
            mCommandCallback.sendEvent();

        } catch (Throwable e) {
            mCommandCallback.sendError(Errors.ErrorDefault);
        }
    }

    /**
     * Location updated listener
     */
    private static class LocationUpdatedListener implements OnLocationUpdatedListener {
        /**
         * Callback
         */
        WeakReference<CommandCallback> mCallbackWeakReference;

        PostMessenger mPostMessenger;

        /**
         * @param callback the callback
         * @param postMessenger Post messenger
         */
        public LocationUpdatedListener(CommandCallback callback, PostMessenger postMessenger) {
            mCallbackWeakReference = new WeakReference<>(callback);
            mPostMessenger = postMessenger;
        }

        @Override
        public void onLocationUpdated(Location location) {

            CommandCallback commandCallback = mCallbackWeakReference.get();
            if(commandCallback != null) {
                sendLocationEvent(location, commandCallback);
            }
        }

        /**
         * Send location event
         *
         * @param location       the location send event
         */
        private void sendLocationEvent(Location location, CommandCallback callback) {
            if (location != null) {
                JSONObject resultJSONObject = LocationUtils.getLocationJSONObject(location);
                Tracer.v("Location found " + resultJSONObject);

                LocationDTO locationDTO = new LocationDTO();
                locationDTO.setLatitude(location.getLatitude());
                locationDTO.setLongitude(location.getLongitude());
                locationDTO.setAltitude(location.getAltitude());
                locationDTO.setAccuracy(location.getAccuracy());

                mPostMessenger.onLocation(locationDTO);
            } else {
                Tracer.v("Location not found!");
                callback.sendError(GeolocationErrors.ErrorLocation);
            }
        }
    }


}