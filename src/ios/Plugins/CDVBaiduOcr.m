//
//  CDVBaiduOcr.m
//  myTestCordova
//
//  Created by mac on 2018/6/4.
//

#import <Cordova/CDV.h>
#import "CDVBaiduOcr.h"
#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>

BOOL hasGotToken = NO;

@implementation CDVBaiduOcr

- (void)init:(CDVInvokedUrlCommand *)command {

    NSMutableDictionary* resultDic = [NSMutableDictionary dictionary];

    //     授权方法1：在此处填写App的Api Key/Secret Key
    //    [[AipOcrService shardService] authWithAK:@"AK" andSK:@"SK"];


    // 授权方法2（更安全）： 下载授权文件，添加至资源
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    if(!licenseFileData) {
        //[[[UIAlertView alloc] initWithTitle:@"授权失败" message:@"授权文件不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];

        resultDic[@"code"] = @(-1);
        resultDic[@"message"] = @"授权文件不存在";
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:resultDic];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];

    //获取token回调
    [[AipOcrService shardService] getTokenSuccessHandler:^(NSString *token) {
        NSLog(@"获取token成功: %@",token);
        hasGotToken = YES;
    } failHandler:^(NSError *error) {
        NSLog(@"获取token失败: %@",error);
        resultDic[@"code"] = @(-1);
        resultDic[@"message"] = @"获取token失败";
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:resultDic];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        hasGotToken = NO;
    }];

}

- (void)scanId:(CDVInvokedUrlCommand *)command {

    NSDictionary *param = [command argumentAtIndex:0];

    NSMutableDictionary* resultDic = [NSMutableDictionary dictionary];

    NSMutableString *contentType = nil;
    BOOL nativeEnable = YES;

    //默认为本地质量扫描正面
    CardType cardType = CardTypeLocalIdCardFont;

    //必须初始化
    if(!hasGotToken) {
        resultDic[@"code"] = @(-1);
        resultDic[@"message"] = @"please init ocr";
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:resultDic];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    //如果未找到contentType属性则直接返回错误
    if(param == nil || param[@"contentType"] == nil) {
        resultDic[@"code"] = @(-1);
        resultDic[@"message"] = @"contentType is null";
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:resultDic];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    //获取扫描类型，正面还是反面
    contentType = param[@"contentType"];
    //获取是否使用本地质量控制
    nativeEnable = param[@"nativeEnable"];

    if([contentType isEqualToString:@"IDCardFront"]) {
        if(nativeEnable){
            cardType = CardTypeLocalIdCardFont;
        }else{
            cardType = CardTypeIdCardFont;
        }
    } else if ([contentType isEqualToString:@"IDCardBack"]) {
        if(nativeEnable){
            cardType = CardTypeLocalIdCardBack;
        }else{
            cardType = CardTypeIdCardBack;
        }
    }


    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:cardType andImageHandler:^(UIImage *image){
        [[AipOcrService shardService] detectIdCardFrontFromImage:image withOptions:nil successHandler:^(id result){
            NSLog(@"%@", result);

            //NSMutableString *message = [NSMutableString string];


            if(result[@"words_result"]){
                if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){

                    NSMutableDictionary *data = [NSMutableDictionary dictionary];
                    NSDictionary *wordsResult = [NSDictionary dictionaryWithDictionary:result[@"words_result"]];

                    if(wordsResult[@"姓名"] && wordsResult[@"姓名"][@"words"])
                        data[@"name"] = wordsResult[@"姓名"][@"words"];
                    if(wordsResult[@"出生"] && wordsResult[@"出生"][@"words"])
                        data[@"birthday"] = wordsResult[@"出生"][@"words"];
                    if(wordsResult[@"公民身份号码"] && wordsResult[@"公民身份号码"][@"words"])
                        data[@"idNumber"] = wordsResult[@"公民身份号码"][@"words"];
                    if(wordsResult[@"性别"] && wordsResult[@"性别"][@"words"])
                        data[@"gender"] = wordsResult[@"性别"][@"words"];
                    if(wordsResult[@"住址"] && wordsResult[@"住址"][@"words"])
                        data[@"address"] = wordsResult[@"住址"][@"words"];
                    if(wordsResult[@"民族"] && wordsResult[@"民族"][@"words"])
                        data[@"ethnic"] = wordsResult[@"民族"][@"words"];

                    if(wordsResult[@"失效日期"] && wordsResult[@"失效日期"][@"words"])
                        data[@"expiryDate"] = wordsResult[@"失效日期"][@"words"];
                    if(wordsResult[@"签发日期"] && wordsResult[@"签发日期"][@"words"])
                        data[@"signDate"] = wordsResult[@"签发日期"][@"words"];
                    if(wordsResult[@"签发机关"] && wordsResult[@"签发机关"][@"words"])
                        data[@"issueAuthority"] = wordsResult[@"签发机关"][@"words"];

                    resultDic[@"code"] = @(0);
                    resultDic[@"message"] = @"OK";
                    resultDic[@"data"] = data;

                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDic];

                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

                }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                    //其他类型的文本扫描，后期增加
                    NSLog(@"words_result: %@", result);
                }

            }else{
                NSLog(@"words_result: %@", result);
            }

            //_successHandler(result);
            // 这里可以存入相册
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, (__bridge void *)self);

            //NSLog(@"%@", [NSThread currentThread]);

            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewController dismissViewControllerAnimated:YES completion:nil];
            });
        } failHandler:^(NSError *error){
            NSLog(@"读取身份证失败：%@",error);
            resultDic[@"code"] = @(-1);
            resultDic[@"message"] = @"读取身份证失败";
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:resultDic];

            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
    [self.viewController presentViewController:vc animated:YES completion:nil];
}

- (void)destroy:(CDVInvokedUrlCommand *)command {
    return;
}

@end
