package com.cells.plugins.geolocation.command.impl;

import android.location.Address;
import android.location.Location;
import android.support.annotation.NonNull;

import com.cells.plugins.base.command.callback.CommandCallback;
import com.cells.plugins.base.utils.Tracer;
import com.cells.plugins.geolocation.LocationConstants;
import com.cells.plugins.geolocation.command.impl.base.PermissionCommand;
import com.cells.plugins.geolocation.command.params.GetAddressFromLocationParams;
import com.cells.plugins.geolocation.command.response.GeolocationErrors;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.ref.WeakReference;
import java.util.List;
import java.util.Locale;

import javax.inject.Inject;

import io.nlopez.smartlocation.OnReverseGeocodingListener;
import io.nlopez.smartlocation.SmartLocation;
import io.nlopez.smartlocation.geocoding.providers.AndroidGeocodingProvider;

/**
 * @author (c) 2016, Cells
 */
public class GetAddressFromLocationCommand extends PermissionCommand<GetAddressFromLocationParams> {

    private static final String TAG = GetAddressFromLocationCommand.class.getSimpleName();

    /**
     * A GetCurrentPosition new command
     */
    @Inject
    public GetAddressFromLocationCommand() {
        super(GetAddressFromLocationParams.class);
    }

    @Override
    protected void executeWithPermissionGranted() {
        Location location = new Location("");
        if (mParams != null) {
            location.setLatitude(mParams.getLatitude());
            location.setLongitude(mParams.getLongitude());
            retrieveNewAddress(location);
        } else {
            mCommandCallback.sendError(GeolocationErrors.ErrorParams);
        }
    }

    /**
     * Retrieve new address
     *
     * @param location the location to reverse geocoding
     */
    private void retrieveNewAddress(Location location) {
        SmartLocation.GeocodingControl controlManager = mSmartLocation.geocoding(new AndroidGeocodingProvider(Locale.getDefault()));
        if (controlManager != null) {
            controlManager.reverse(location, new AddressUpdatedListener(mCommandCallback));
        }
    }


    /**
     * Location updated listener
     */
    private static class AddressUpdatedListener implements OnReverseGeocodingListener {

        private static final String TAG = AddressUpdatedListener.class.getSimpleName();

        /**
         * Callback
         */
        WeakReference<CommandCallback> mCallback;

        /**
         * @param callback the callback
         */
        public AddressUpdatedListener(CommandCallback callback) {
            this.mCallback = new WeakReference<>(callback);
        }

        @Override
        public void onAddressResolved(Location location, List<Address> list) {
            CommandCallback callBackReturn = mCallback.get();
            if (callBackReturn != null) {
                sendAddressEvent(list, callBackReturn);
            }
        }


        /**
         * Send location event
         *
         * @param listAddress    the list address
         * @param callBackReturn the callback return
         */
        private void sendAddressEvent(List<Address> listAddress, CommandCallback callBackReturn) {
            if ((listAddress != null) && (!listAddress.isEmpty())) {

                try {
                    JSONObject result = new JSONObject();

                    JSONArray arrayListAddress = new JSONArray();
                    for (Address address : listAddress) {
                        arrayListAddress.put(getAddressJSONObject(address));
                    }

                    result.put(LocationConstants.KEY_ADDRESS, arrayListAddress);

                    callBackReturn.sendEvent(result);
                } catch (JSONException e) {
                    Tracer.e(TAG, e, e.getMessage());
                }

            } else {
                Tracer.v(TAG, "Address not found!!");
                callBackReturn.sendError(GeolocationErrors.ErrorGeocode);
            }
        }

        /**
         * Get address JSON Object
         *
         * @param address the location to result json object
         * @return the result JSON Object
         */
        private static JSONObject getAddressJSONObject(@NonNull Address address) {
            JSONObject result = new JSONObject();
            try {
                result.put(LocationConstants.KEY_LATITUDE, address.getLatitude());
                result.put(LocationConstants.KEY_LONGITUDE, address.getLongitude());

                StringBuilder addressLineBuilder = new StringBuilder();
                int size = address.getMaxAddressLineIndex();
                if (size > 0) {
                    for (int index = 0; index < size; index++) {
                        addressLineBuilder.append(address.getAddressLine(index)).append(" ");
                    }
                } else {
                    addressLineBuilder.append(address.getThoroughfare());
                }

                result.put(LocationConstants.KEY_ADDRESS_LINE, addressLineBuilder.toString());
            } catch (JSONException e) {
                Tracer.e(TAG, e, "Error parsing");
            }

            return result;
        }
    }
}
