package com.cells.plugins.geolocation.command.impl.base;

import android.support.annotation.NonNull;

import com.cells.plugins.base.command.AbstractCommand;
import com.cells.plugins.base.command.callback.CommandCallback;
import com.cells.plugins.base.command.response.Errors;
import com.cells.plugins.base.permissions.Action;
import com.cells.plugins.base.permissions.Permission;
import com.cells.plugins.base.permissions.PermissionListener;
import com.cells.plugins.base.permissions.PermissionsController;
import com.cells.plugins.geolocation.command.response.GeolocationErrors;

import java.util.List;

import javax.inject.Inject;

import io.nlopez.smartlocation.SmartLocation;

/**
 * @author (c) 2016, Cells
 */
public abstract class PermissionCommand<T> extends AbstractCommand<T> implements PermissionListener {

    @Inject protected SmartLocation mSmartLocation;
    @Inject PermissionsController mPermissionsController;

    protected T               mParams;
    protected CommandCallback mCommandCallback;

    public PermissionCommand(@NonNull Class<T> clazz) {
        super(clazz, EXECUTE_ON_NEW_THREAD);
    }

    @Override
    protected void execute(T params, CommandCallback callback) {
        mParams = params;
        mCommandCallback = callback;

        Action action = Action.builder()
                .addPermission(Permission.PERMISSION_CODE.ACCESS_COARSE_LOCATION)
                .addPermission(Permission.PERMISSION_CODE.ACCESS_FINE_LOCATION)
                .allowDefaultBehaviourOnDenied(true)
                .allowDefaultBehaviourOnDenied(true)
                .build();

        mPermissionsController.requestActionPermissions(action, this);
    }

    @Override
    public void onActionGranted(Action action) {
        boolean locationServicesEnabled = mSmartLocation.location().state().locationServicesEnabled();
        if(locationServicesEnabled) {
            executeWithPermissionGranted();
        }else{
            mCommandCallback.sendError(GeolocationErrors.ErrorNotLocationServiceEnabled);
        }
    }

    @Override
    public void onActionDenied(Action action) {
        mCommandCallback.sendError(Errors.ErrorPermissionDenied);
    }

    @Override
    public void onShouldShowRationals(List<Permission> permissions, Action action) {

    }

    protected abstract void executeWithPermissionGranted();
}
