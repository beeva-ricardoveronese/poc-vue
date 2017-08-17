package com.cells.plugins.geolocation.command.impl;

import android.app.Application;
import android.location.Location;

import com.cells.plugins.base.command.callback.CommandCallback;
import com.cells.plugins.base.command.response.Errors;
import com.cells.plugins.base.utils.Tracer;
import com.cells.plugins.geolocation.LocationConstants;
import com.cells.plugins.geolocation.LocationUtils;
import com.cells.plugins.geolocation.command.impl.base.PermissionCommand;
import com.cells.plugins.geolocation.command.response.GeolocationErrors;

import org.json.JSONObject;

import java.lang.ref.WeakReference;

import javax.inject.Inject;

import io.nlopez.smartlocation.OnLocationUpdatedListener;
import io.nlopez.smartlocation.SmartLocation;
import io.nlopez.smartlocation.location.providers.LocationGooglePlayServicesWithFallbackProvider;
import io.nlopez.smartlocation.location.utils.LocationState;

/**
 * @author (c) 2016, Cells
 */
public class GetCurrentPositionCommand extends PermissionCommand<Void> {

    private static final String TAG = GetCurrentPositionCommand.class.getSimpleName();

    /**
     * App context
     */
    @Inject
    Application app;


    /**
     * A GetCurrentPosition new command
     */
    @Inject
    public GetCurrentPositionCommand() {
        super(Void.class);
    }

    @Override
    protected void executeWithPermissionGranted() {
        Location location = mSmartLocation.location().getLastLocation();

        if (location != null) {
            long time = location.getTime();
            if ((time + LocationConstants.TIME_ELAPSED) >= (System.currentTimeMillis())) {
                JSONObject resultJSONObject = LocationUtils.getLocationJSONObject(location);
                mCommandCallback.sendEvent(resultJSONObject);
                return;
            }
        }

        retrieveNewLocation();
    }

    /**
     * Retrieve new location
     */
    private void retrieveNewLocation() {
        SmartLocation.LocationControl controlManager = mSmartLocation.location(new LocationGooglePlayServicesWithFallbackProvider(app));
        if (controlManager != null) {
            LocationState locationState = controlManager.state();
            if ((locationState != null) && (locationState.isAnyProviderAvailable())) {
                try {
                    controlManager.oneFix()
                            .start(new LocationUpdatedListener(mCommandCallback));
                }catch (Exception e){
                    mCommandCallback.sendError(Errors.ErrorDefault);
                }
            } else {
                Tracer.v(TAG, "Have not any provider available");
                mCommandCallback.sendError(GeolocationErrors.ErrorNotProviderAvailable);
            }
        }
    }


    /**
     * Location updated listener
     */
    private static class LocationUpdatedListener implements OnLocationUpdatedListener {

        /**
         * Callback
         */
        WeakReference<CommandCallback> mCallback;

        /**
         * @param callback the callback
         */
        public LocationUpdatedListener(CommandCallback callback) {
            this.mCallback = new WeakReference<>(callback);
        }

        @Override
        public void onLocationUpdated(Location location) {
            CommandCallback callBackReturn = mCallback.get();
            if (callBackReturn != null) {
                sendLocationEvent(location, callBackReturn);
            }
        }

        /**
         * Send location event
         *
         * @param location       the location send event
         * @param callBackReturn the callback return
         */
        private void sendLocationEvent(Location location, CommandCallback callBackReturn) {
            if (location != null) {
                JSONObject resultJSONObject = LocationUtils.getLocationJSONObject(location);
                callBackReturn.sendEvent(resultJSONObject);
            } else {
                callBackReturn.sendError(GeolocationErrors.ErrorLocation);
            }
        }
    }
}
