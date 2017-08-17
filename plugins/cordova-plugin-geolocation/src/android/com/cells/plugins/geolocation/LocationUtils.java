/*
 * Copyright (c) 2011 CELLS All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * CELLS ("Confidential Information").  You shall not disclose such
 * Confidential Information and shall use it only in accordance with
 * the terms of the license agreement you entered into with CELLS.
 */
package com.cells.plugins.geolocation;

import android.location.Location;
import android.support.annotation.NonNull;

import com.cells.plugins.base.utils.Log;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Location utils
 *
 * @author (c) 2015, Cells
 */
public class LocationUtils {

    /**
     * Get current position JSON Object
     *
     * @param location the location to result json object
     * @return the result JSON Object
     */
    public static JSONObject getLocationJSONObject(@NonNull Location location) {
        JSONObject result = new JSONObject();
        try {
            result.put(LocationConstants.KEY_LATITUDE, location.getLatitude());
            result.put(LocationConstants.KEY_LONGITUDE, location.getLongitude());
            result.put(LocationConstants.KEY_ALTITUDE, location.getAltitude());
            result.put(LocationConstants.KEY_ACCURACY, location.getAccuracy());
        } catch (JSONException e) {
            Log.e(e, "Error parsing");
        }

        return result;
    }
}