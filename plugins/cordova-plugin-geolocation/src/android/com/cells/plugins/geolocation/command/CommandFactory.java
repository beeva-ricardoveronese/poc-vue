package com.cells.plugins.geolocation.command;

import com.cells.plugins.base.command.AbstractCommandFactory;
import com.cells.plugins.geolocation.command.impl.ClearWatchLocationCommand;
import com.cells.plugins.geolocation.command.impl.GetAddressFromLocationCommand;
import com.cells.plugins.geolocation.command.impl.GetCurrentPositionCommand;
import com.cells.plugins.geolocation.command.impl.GetLocationFromAddressCommand;
import com.cells.plugins.geolocation.command.impl.PromptForLocationServiceCommand;
import com.cells.plugins.geolocation.command.impl.WatchLocationCommand;

import javax.inject.Inject;
import javax.inject.Provider;

/**
 * @author (c) 2016, Cells
 */
public class CommandFactory extends AbstractCommandFactory {

    public static final String ACTION_GETCURRENTPOSITION     = "getcurrentposition";
    public static final String ACTION_GETADDRESSFROMLOCATION = "getaddressfromlocation";
    public static final String ACTION_GETLOCATIONFROMADDRESS = "getlocationfromaddress";
    public static final String ACTION_WATCHLOCATION          = "watchlocation";
    public static final String ACTION_CLEARWATCHLOCATION     = "clearwatchlocation";
    public static final String ACTION_PROMPT_FOR_LOCATION_SERVICE     = "promptforlocationservice";

    @Inject
    public CommandFactory(
            Provider<GetCurrentPositionCommand> getcurrentpositionCommandProvider,
            Provider<GetAddressFromLocationCommand> getaddressfromlocationCommandProvider,
            Provider<GetLocationFromAddressCommand> getlocationfromaddressCommandProvider,
            Provider<WatchLocationCommand> watchLocationCommandProvider,
            Provider<ClearWatchLocationCommand> clearWatchLocationCommandProvider,
            Provider<PromptForLocationServiceCommand> promptForLocationServiceCommandProvider) {
        super();

        addCommand(ACTION_GETCURRENTPOSITION, getcurrentpositionCommandProvider);
        addCommand(ACTION_GETADDRESSFROMLOCATION, getaddressfromlocationCommandProvider);
        addCommand(ACTION_GETLOCATIONFROMADDRESS, getlocationfromaddressCommandProvider);
        addCommand(ACTION_WATCHLOCATION, watchLocationCommandProvider);
        addCommand(ACTION_CLEARWATCHLOCATION, clearWatchLocationCommandProvider);
        addCommand(ACTION_PROMPT_FOR_LOCATION_SERVICE, promptForLocationServiceCommandProvider);
    }

}
