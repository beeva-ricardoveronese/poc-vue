package com.cells.plugins.geolocation.command.params;

import com.cells.plugins.base.utils.ParserUtils;

/**
 * @author (c) 2016, Cells
 */
public class GetAddressFromLocationParams {

    String latitude;
    String longitude;

    /***
     * Get latitude
     * @return the latitude
     */
    public double getLatitude() {
        return ParserUtils.parseDouble(latitude, 0.0d);
    }

    /**
     * Get longitude
     * @return the longitude
     */
    public double getLongitude() {
        return ParserUtils.parseDouble(longitude, 0.0d);
    }
}