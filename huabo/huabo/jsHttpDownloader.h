//
//  jsHttpDownloader.h
//  MyWeiXin
//
//  Created by sensen on 13-12-25.
//  Copyright (c) 2013年 sensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
typedef void (^completionBlock)(id JSON);

@interface jsHttpDownloader : NSObject<ASIHTTPRequestDelegate>
{
    id _target;
    SEL _sel;
    NSData *_data;
    
    completionBlock _block;
}

+(id)checkWithStringOfUrl:(NSString *)str withTarget:(id)target finishAction:(SEL)sel;

-(NSData*)responseData;

+(id)jsHttpDownloaderWithStringOfUrl:(NSString*)str completionBlock:(completionBlock)block;

//使用字典包装，做POST请求
+(id)jsHttpDownloaderWithDictionary:(NSDictionary*)dic baseStringOfURL:(NSString *)str completionBlock:(completionBlock)block;
@end
