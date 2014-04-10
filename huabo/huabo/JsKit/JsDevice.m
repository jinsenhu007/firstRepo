//
//  JsDevice.m
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "JsDevice.h"


@implementation JsDevice

static id _s = nil;
+(id)sharedReach{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    });
    return _s;
}

+(BOOL)netOK{
    return [[[self class] sharedReach] isReachable];
}

+(float)getOSVersion{
    return [[[UIDevice currentDevice] systemVersion]floatValue];
}

+(float)getScreenHeight{
    return [UIScreen mainScreen].bounds.size.height;
}

+(float)getScreenWidth{
    return [UIScreen mainScreen].bounds.size.width;
}

+(NSString*)getIphoneName{
    return [[UIDevice currentDevice]name];
}
@end
