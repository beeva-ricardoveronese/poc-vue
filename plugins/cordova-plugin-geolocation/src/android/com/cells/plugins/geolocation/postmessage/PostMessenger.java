package com.cells.plugins.geolocation.postmessage;

import android.app.Activity;
import android.support.annotation.NonNull;

import com.cells.plugins.base.postmessage.AbstractPostMessenger;
import com.cells.plugins.base.view.WebView;
import com.cells.plugins.geolocation.postmessage.dto.LocationDTO;

/**
 * @author (c) 2016, Cells
 */
public class PostMessenger extends AbstractPostMessenger{

    /**
     * The location dto
     */
    private static final String POST_ACTION_LOCATION = "location";

    /**
     * Post message constructor
     *
     * @param activity      Activity
     * @param webView       Web view
     * @param pluginName   Plugin name
     */
    public PostMessenger(@NonNull Activity activity, @NonNull WebView webView, @NonNull String pluginName) {
        super(activity, webView, pluginName);
    }



    /**
     * Post read message
     * @param locationDTO location dto
     */
    public void onLocation(LocationDTO locationDTO){
        postMessage(POST_ACTION_LOCATION, locationDTO);
    }

}