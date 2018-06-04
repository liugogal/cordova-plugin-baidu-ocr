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

@implementation CDVBaiduOcr

- (void)init:(CDVInvokedUrlCommand *)command {
    [[AipOcrService shardService] authWithAK:@"AK" andSK:@"SK"];
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
