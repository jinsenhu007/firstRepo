//
//  jsHttpDownloader.m
//  MyWeiXin
//
//  Created by sensen on 13-12-25.
//  Copyright (c) 2013年 sensen. All rights reserved.
//

#import "jsHttpDownloader.h"
#import "ASIFormDataRequest.h"
#import "AFNetworking.h"
#import "userModel.h"
#import "userMgr.h"


@implementation jsHttpDownloader
static NSMutableArray *arr = nil;
static NSMutableArray *arrAF = nil;
-(id)initWithStringOfUrl:(NSString *)str withTarget:(id)target finishAction:(SEL)sel{
    if (self = [super init]) {
        _target = target;
        _sel = sel;
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
        request.delegate = self;
        [request startAsynchronous];
        if (arr == nil) {
            arr = [[NSMutableArray alloc]initWithCapacity:0];
        }
          [arr addObject:self];
    }
    return self;
}

+(id)checkWithStringOfUrl:(NSString *)str withTarget:(id)target finishAction:(SEL)sel {
    
    return [[[self class]alloc]initWithStringOfUrl:(NSString *)str withTarget:(id)target finishAction:sel];
    
   
}
//解析数据
- (void)requestFinished:(ASIHTTPRequest *)request{
   _data = [request responseData];
    [_target performSelector:_sel withObject:self];
   
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"%@",request.error);
}

-(NSData*)responseData{
    return _data;
}

-(id)initWithSTringOfUrl:(NSString*)str completionBlock:(completionBlock)block{
    
    if (self = [super init]) {
       _block = block;
        
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    AFJSONRequestOperation *AF = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _block(JSON);
       
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _block(nil);
    }];
        [AF setJSONReadingOptions:NSJSONReadingMutableContainers];
        //-------设置内容类型-------------------
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/json",@"application/json",@"text/html", nil]];
        [AF start];
        
        if (arrAF == nil) {
            arrAF  = [[NSMutableArray alloc]init];
            [arrAF addObject:self];
        }
    }
    return self;
}


+(id)jsHttpDownloaderWithStringOfUrl:(NSString*)str completionBlock:(completionBlock)block{
    return [[[self class]alloc]initWithSTringOfUrl:str completionBlock:block];
    
}

-(id)initWithDictionary:(NSDictionary *)dic baseStringOfURL:(NSString*)str completionBlock:(completionBlock)block{
    if (self = [super init]) {
        _block = [block copy];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
         __weak ASIFormDataRequest *weak = request;
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *keyStr = (NSString*)key;
            [weak addPostValue:obj forKey:keyStr];
        }];
        userModel *currUser =  [[userMgr sharedInstance]getLoginUser];
        [request setPostValue:currUser.token  forKey:@"token"];
        [request startAsynchronous];
       
        [request setCompletionBlock:^{
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:weak.responseData options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSLog(@"解析出错 %@",err);
            }
            _block(dic);
        }];
        [request setFailedBlock:^{
            NSLog(@"下载出错");
        }];
        
        if (arr== nil) {
            arr= [NSMutableArray array];
            [arr addObject:self];
        }
        
    }
    return self;
}

//使用字典包装，做POST请求
+(id)jsHttpDownloaderWithDictionary:(NSDictionary*)dic baseStringOfURL:(NSString *)str completionBlock:(completionBlock)block{
    return [[[self class]alloc]initWithDictionary:dic baseStringOfURL:str completionBlock:block];
}
@end
