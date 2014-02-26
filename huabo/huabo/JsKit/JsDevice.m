//
//  JsDevice.m
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "JsDevice.h"

@implementation JsDevice

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
