package com.cells.plugins.geolocation.command.impl;

import com.cells.plugins.geolocation.command.impl.base.PermissionCommand;
import com.cells.plugins.geolocation.command.response.GeolocationErrors;

import javax.inject.Inject;

/**
 * @author (c) 2016, Cells
 */
public class ClearWatchLocationCommand extends PermissionCommand<Void> {
    /**
     * A GetCurrentPosition new command
     */
    @Inject
    public ClearWatchLocationCommand() {
        super(Void.class);
    }

    @Override
    protected void executeWithPermissionGranted() {
        try{
            mSmartLocation.location().stop();
            mCommandCallback.sendEvent();
        }catch (Exception ex){
            mCommandCallback.sendError(GeolocationErrors.ErrorStopWatchLocation);
        }
    }
}