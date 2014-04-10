//
//  jsHttpHandler.h
//  
//
//  Created by sensen on 14-1-13.
//  Copyright (c) 2014年 Jsen.co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
typedef void (^completionBlock)(id JSON);

@interface jsHttpHandler : NSObject<ASIHTTPRequestDelegate>
{

    NSData *_data;
    
    completionBlock _block;
}
// [jsHttpHandler jsHttpDwonloadWithStringOfUrl:@"" completionBlock:]

+(id)jsHttpDwonloadWithStringOfUrl:(NSString*)str completionBlock:(completionBlock)block;


+(id)jsHttpDownloadWithStrOfUrl:(NSString*)str withCache:(BOOL)yesOrNo completionBlock:(completionBlock)block;

//POST
+(id)JsHttpPostWithStrOfUrl:(NSString*)str paraDict:(NSDictionary*)pardDict completionBlock:(completionBlock)block;


+(void)setCacheTime:(NSTimeInterval)time;

+(NSInteger)getCacheSize;
@end
