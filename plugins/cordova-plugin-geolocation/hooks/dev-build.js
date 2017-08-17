

module.exports = function(ctx) {

    if(!ctx.cmdLine.includes("--dev")){
        return
    }


    var fs = ctx.requireCordovaModule('fs'),
        path = ctx.requireCordovaModule('path'),
        deferral = ctx.requireCordovaModule('q').defer();
   

    var wwwProjectFolder = path.join(ctx.opts.projectRoot, 'www');
    var wwwPluginFolder = path.join(__dirname, '../demo/www');

    var dirs = ['js', 'css', 'img', 'fonts'];

    var files = ['index.html', 'js/index.js', 'css/styles.css', 
                 'img/cells.png', 'img/background.png',
                 'fonts/Lato-Bold.ttf', 'fonts/Lato-Italic.ttf', 'fonts/Lato-Regular.ttf'];


    for(var dir of dirs){
        createDir(fs, path.join(wwwProjectFolder, dir));
    }

    for (var file of files) {
        copyFile(fs, path, file, wwwProjectFolder, wwwPluginFolder);
    }    
};

function createDir(fs, dir){
    var existsDir = fs.existsSync(dir);

    if(!existsDir){
        fs.mkdirSync(dir);
    }
}

function copyFile(fs, path, file, wwwProjectFolder, wwwPluginFolder){
    var sourceFile = path.join(wwwPluginFolder, file);
    var destinationFile = path.join(wwwProjectFolder, file);

    fs.createReadStream(sourceFile).pipe(fs.createWriteStream(destinationFile));
};

