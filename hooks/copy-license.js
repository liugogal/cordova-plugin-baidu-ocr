module.exports = function (ctx) {

    // make sure android platform is part of build
    //确保在android平台下使用
    if (ctx.opts.platforms.indexOf('android') < 0) {
        return;
    }

    var fs = ctx.requireCordovaModule('fs'),
        path = ctx.requireCordovaModule('path'),
        deferral = ctx.requireCordovaModule('q').defer();


    //android项目根路径
    var platformRoot = path.join(ctx.opts.projectRoot, 'platforms/android');
    //android项目的assets目录
    var assetsRoot = platformRoot + '/app/src/main/assets';
    //证书源路径
    var license_from = assetsRoot + '/www/assets/aip.license';
    //证书目标路径
    var license_to = assetsRoot + '/aip.license';

    //如果证书源存在，则进行文件拷贝
    if (fs.existsSync(platformRoot) && fs.existsSync(license_from)) {
        var readStream = fs.createReadStream(license_from);
        var writeStream = fs.createWriteStream(license_to);

        //拷贝
        readStream.pipe(writeStream);
        console.log('拷贝证书成功');
        deferral.resolve();
    } else {
        console.log('未找到证书文件,请将aip.license证书拷贝到www/assets下');
        deferral.reject('未找到证书文件,请将aip.license证书拷贝到www/assets下');
    }

    return deferral.promise;
};