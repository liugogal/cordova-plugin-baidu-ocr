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
    //     授权方法1：在此处填写App的Api Key/Secret Key
//    [[AipOcrService shardService] authWithAK:@"AK" andSK:@"SK"];


    // 授权方法2（更安全）： 下载授权文件，添加至资源
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip-2" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    if(!licenseFileData) {
        [[[UIAlertView alloc] initWithTitle:@"授权失败" message:@"授权文件不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];

    //获取token回调
    [[AipOcrService shardService] getTokenSuccessHandler:^(NSString *token) {
        NSLog(@"token: %@",token);
        hasGotToken = YES;
    } failHandler:^(NSError *error) {
        NSLog(@"error: %@",error.domain);
        hasGotToken = NO;
    }];

}

- (void)scanId:(CDVInvokedUrlCommand *)command {
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont
                                 andImageHandler:^(UIImage *image) {

                                     [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                                                  withOptions:nil
                                                                               successHandler:^(id result){
                                                                                   NSLog(@"%@", result);
                                                                                   //_successHandler(result);
                                                                                   // 这里可以存入相册
                                                                                   //UIImageWriteToSavedPhotosAlbum(image, nil, nil, (__bridge void *)self);
                                                                               }
                                                                                  failHandler:^(NSError *error){
                                                                                      NSLog(@"%@",error);
                                                                                  }];
                                 }];
    [self.viewController presentViewController:vc animated:YES completion:nil];
}

- (void)destroy:(CDVInvokedUrlCommand *)command {

}

@end
