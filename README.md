# Cordova Plugin BaiduOcr
================================

Cross-platform BaiduOcr for Cordova / PhoneGap.

Follows the [Cordova Plugin spec](https://cordova.apache.org/docs/en/latest/plugin_ref/spec.html), so that it works with [Plugman](https://github.com/apache/cordova-plugman).

## Installation


This requires cordova 7.1.0+ ( current stable v8.0.0 )

    cordova plugin add cordova-plugin-baidu-ocr

It is also possible to install via repo url directly ( unstable )

    cordova plugin add https://github.com/liugogal/cordova-plugin-baidu-ocr.git

注意：

1、首先需要到Baidu上注册并且申请并下载aip.license授权文件，具体操作查看：https://ai.baidu.com/docs#/OCR-Android-SDK/top

2、然后将aip.license拷贝到www/assets下面。

注意：官方说的是拷贝到android的app/src/main/assets下面，不用担心，此插件使用了hook钩子做文件拷贝，可以放心使用。


### Supported Platforms

- Android
- iOS (come soon)


### Cordova Build Usage


### Using the plugin ###

A full example could be:

初始化（init）：
```js
    cordova.plugins.BaiduOcr.init(
        ()=>{
            console.log('init ok');
        },
        (error)=>{
            console.log(error)
        })
```
扫描身份证（scan id card）:
```js
    //默认使用的是本地质量控制，如果想使用拍照扫描的方式，可以修改参数为
    //nativeEnable:false,nativeEnableManual:false
    cordova.plugins.BaiduOcr.scanId(
        (result)=>{
            console.log(JSON.stringify(result));
        },
        (error)=>{
            console.log(error)
        },
        {
            contentType:"IDCardBack",
            nativeEnable:true,
            nativeEnableManual:true
        });
```
销毁本地控制模型（destroy）：
```js
    cordova.plugins.BaiduOcr.destroy(
        ()=>{
            console.log('destroy ok');
        },
        (error)=>{
            console.log(error)
        });
```


### ionic-native ###
install：
```bash
    npm i @liu-gogal/baidu-ocr --save
```
app.module.ts:
```js
    import {BaiduOcr} from "@liu-gogal/baidu-ocr";
    @NgModule({
        providers: [
            BaiduOcr
        ]
    })
    export class AppModule {}
```
view.page.ts:
```js
    import {BaiduOcr} from "@liu-gogal/baidu-ocr";
    @IonicPage()
    @Component({
        selector: 'view-page',
        templateUrl: 'view-page.html'
    })
    export class ViewPage {
        constructor(private baiduOcr: BaiduOcr) {}
        
        doInit() {
            this.baiduOcr.init()
                .then((result)=>{
                    
                })
                .catch((error)=>{
                    
                });
        }
        
        doDestroy() {
            this.baiduOcr.destroy()
                .then((result)=>{
                    
                })
                .catch((error)=>{
                    
                });
        }
        
        doScanId() {
            this.baiduOcr.scanId({contentType: 'IDCardFront', nativeEnable: true, nativeEnableManual: true})
                .then((result)=>{
                    if (result.message == "OK") {
                        console.log(result.data);
                    }
                })
                .catch((error)=>{
                    
                });
        }
        
    }
```