package com.cells.plugins.geolocation.postmessage.dto;

import com.cells.plugins.base.postmessage.dto.PayloadDTO;

/**
 * @author (c) 2016, Cells
 */
public class LocationDTO extends PayloadDTO {

    /**
     * The latitude location
     */
    double latitude;

    /**
     * The longitude location
     */
    double longitude;

    /**
     * The altitude location
     */
    double altitude;

    /**
     * The accuracy location
     */
    float accuracy;

    /**
     * Set latitude
     * @param latitude the latitude location
     */
    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    /**
     * Set longitude location
     * @param longitude the longitude location
     */
    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    /**
     * Set altitude location
     * @param altitude the altitude location
     */
    public void setAltitude(double altitude) {
        this.altitude = altitude;
    }

    /**
     * Set accuracy location
     * @param accuracy the accuracy location
     */
    public void setAccuracy(float accuracy) {
        this.accuracy = accuracy;
    }
}
