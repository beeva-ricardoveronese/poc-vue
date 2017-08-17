package com.cells.plugins.geolocation.command.response;

import com.cells.plugins.base.command.response.ErrorMessage;

/**
 * @author (c) 2016, Cells
 */
public enum GeolocationErrors implements ErrorMessage{
    ErrorGeocode (440, "Geocode Converter Error"),
    ErrorParams (441, "Latitud and longitud are empty. Set Location permission to YES first."),
    ErrorLocation (442, "The location service is unable to retrieve a location right away."),
    ErrorDirectLocation (443, "The location direct is unable to retrieve a location right away."),
    ErrorStopWatchLocation(444, "Impossible stop the watch location"),
    ErrorNotProviderAvailable(445, "Have not any provider available"),
    ErrorNotLocationServiceEnabled(446, "Location service is disabled");

    /**
     * Code
     */
    private int mCode;

    /**
     * Message
     */
    private String mMessage;

    /**
     * @param code Code
     * @param message Message
     */
    GeolocationErrors(int code, String message){
        mCode = code;
        mMessage = message;
    }

    /**
     * @return Code
     */
    @Override
    public int getCode() {
        return mCode;
    }

    /**
     * @return Message
     */
    @Override
    public String getMessage() {
        return mMessage;
    }
}