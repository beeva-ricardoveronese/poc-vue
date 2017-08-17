package com.cells.plugins.geolocation.command.impl;

import android.app.Activity;
import android.content.Intent;

import com.cells.plugins.base.command.AbstractCommand;
import com.cells.plugins.base.command.callback.CommandCallback;

import javax.inject.Inject;

import static android.provider.Settings.*;

/**
 * @author (c) 2016, Cells
 */
public class PromptForLocationServiceCommand extends AbstractCommand<Void> {

    @Inject Activity mActivity;

    @Inject
    public PromptForLocationServiceCommand() {
        super(Void.class);
    }

    @Override
    protected void execute(Void params, CommandCallback callback) {
        Intent gpsOptionsIntent = new Intent(ACTION_LOCATION_SOURCE_SETTINGS);
        mActivity.startActivity(gpsOptionsIntent);
        callback.sendEvent();
    }

}