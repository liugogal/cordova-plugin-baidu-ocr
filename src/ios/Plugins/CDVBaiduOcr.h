//
//  CDVBaiduOcr.h
//  myTestCordova
//
//  Created by mac on 2018/6/4.
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

@interface CDVBaiduOcr : CDVPlugin

- (void)init:(CDVInvokedUrlCommand *)command;
- (void)scanId:(CDVInvokedUrlCommand *)command;
- (void)destroy:(CDVInvokedUrlCommand *)command;

@end