

module.exports = function(ctx) {

    if( !ctx.opts.plugin.id.includes("cordova-plugin-geolocation") ){
        return;
    }

    var plugins = ctx.opts.cordova.plugins;
    var coreIndex = plugins.indexOf("cordova-cells-native-core");

    if( coreIndex == -1 ){
        throw new Error('Plugin base is not installed yet. Please, install cordova-plugin-base first and try again,');
    }
   
};


