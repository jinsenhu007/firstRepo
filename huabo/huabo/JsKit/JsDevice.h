//
//  JsDevice.h
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsDevice : NSObject

+(float)getOSVersion;
+(float)getScreenWidth;
+(float)getScreenHeight;
+(NSString *)getIphoneName;

@end


#define kScreenWidth [JsDevice getScreenWidth]
#define kScreenHeight [JsDevice getScreenHeight]
#define kOSVersion [JsDevice getOSVersion]

#define isIOS7 ([JsDevice getOSVersion] >= 7)

//--------------适配-------------------
#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
#define CGRECT_NO_NAV(x,y,w,h) CGRectMake((x), (y+(IsIOS7?20:0)), (w), (h))
#define CGRECT_HAVE_NAV(x,y,w,h) CGRectMake((x), (y+(IsIOS7?64:0)), (w), (h))
//-------------------------------------

#define SysFont(f) [UIFont systemFontOfSize:f]
#define BoldFont(f) [UIFont boldSystemFontOfSize:f]

#define PropertyString(p) @property(nonatomic,copy) NSString *p
#define PropertyFloat(p) @property (nonatomic, assign) float p;
#define PropertyInt(p) @property (nonatomic, assign) NSInteger p;
#define PropertyUInt(p) @property (nonatomic, assign) NSUInteger p;

#define kDeviceSerialNo [[[UIDevice currentDevice] identifierForVendor] UUIDString]

//-------------------------------------
#define IOS7 if([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)\
{self.extendedLayoutIncludesOpaqueBars = NO;\
self.modalPresentationCapturesStatusBarAppearance =NO;\
self.edgesForExtendedLayout = UIRectEdgeNone;}
