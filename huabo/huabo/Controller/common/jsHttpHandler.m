//
//  jsHttpHandler.m
//
//
//  Created by sensen on 14-1-13.
//  Copyright (c) 2014年 Jsen.co.ltd. All rights reserved.
//

#import "jsHttpHandler.h"
#import "NSString+Hashing.h"


#define MAX_CACHE_SIZE 100000
#define cacheDir  [ NSHomeDirectory() stringByAppendingFormat:@"%@",@"/Library/huaboCache" ]

@implementation jsHttpHandler

static NSMutableArray *_array = nil;

//GET
-(id)initWithStringOfUrl:(NSString*)str withCache:(BOOL)yesOrNo completionBlock:(completionBlock)block {
    _block = [block copy];
    if (self = [super init]) {
        _data = [self hasCached:str];
        
        if (_data && yesOrNo) {
            //有缓存
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSLog(@"err %@",err);
            }
            if (_block) {
                _block(dic);
            }
            return self;
        }
        
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:str]];
        __weak ASIHTTPRequest *weak = request;
        [request setCompletionBlock:^{
            if (yesOrNo) {
                //存起来
                [self saveToSandBox:str andData:weak.responseData];
            }
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:weak.responseData options:NSJSONReadingMutableContainers error:nil];
            if (_block) {
                _block(dic);
            }
         
        }];
       [request setFailedBlock:^{
           _block(nil);
       }];
        [request setShouldContinueWhenAppEntersBackground:YES];
        [request startAsynchronous];
        if (_array == nil) {
            _array = [NSMutableArray array];
            [_array addObject:self];
        }
        
    }
    return self;
}

//不带缓存
+(id)jsHttpDwonloadWithStringOfUrl:(NSString*)str completionBlock:(completionBlock)block {
   // return [[[self class]alloc]initWithStringOfUrl:str completionBlock:block];
   return [[self class] jsHttpDownloadWithStrOfUrl:str withCache:NO completionBlock:block];
    
}
//可带可不带缓存
+(id)jsHttpDownloadWithStrOfUrl:(NSString*)str withCache:(BOOL)yesOrNo completionBlock:(completionBlock)block{
    return [[[self class]alloc]initWithStringOfUrl:str withCache:yesOrNo completionBlock:block];
}


//-----------------------------POST----------------------------------
static NSMutableArray *arrPost = nil;
- (id)_initWithStrOfUrl:(NSString *)str paraDict:(NSDictionary*)paraDict completionBlock:(completionBlock)block{
    _block = [block copy];
    if (self = [super init]) {
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:str]];
        [paraDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [request setPostValue:obj forKey:key];
        }];
        [request setShouldContinueWhenAppEntersBackground:YES];
        __weak ASIFormDataRequest *weakRequest = request;
        [request setCompletionBlock:^{
            NSError *err=nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSLog(@"POST ERR With Request Data %@",err);
            }
            if (_block) {
                _block(dic);
            }
        }];
        [request setFailedBlock:^{
            NSLog(@"POST request failed");
            if (_block) {
                _block(nil);
            }
        }];
        [request startAsynchronous];
        if (arrPost == nil) {
            arrPost = [NSMutableArray array];
            [arrPost addObject:self];
        }
    }
    return self;
}
+(id)JsHttpPostWithStrOfUrl:(NSString*)str paraDict:(NSDictionary*)paraDict completionBlock:(completionBlock)block{
    return [[[self class]alloc]_initWithStrOfUrl:str paraDict:paraDict completionBlock:block];
}
//--------------------------------------------------------------------

// cache time
static NSTimeInterval maxTimeout = 1*60*60;
+(void)setCacheTime:(NSTimeInterval)time{
    if (time < 0) return;
    maxTimeout = time;
}

-(NSData *)hasCached:(NSString*)str{
    NSString *path = [NSString stringWithFormat:@"%@/%@",cacheDir,[str MD5Hash]];
    NSLog(@"path %@",path);
    //判断cache存放的时间
    NSTimeInterval fileTime = [[self class] lastModifyTime:path];
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    NSLog(@"now %f now-fileTime %f",now,now-fileTime);
    if (now-fileTime >maxTimeout ) {
        return nil;
    }
    
    //判断cache的大小
    if ([[self class]getCacheSize] > MAX_CACHE_SIZE) {
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

+(NSTimeInterval)lastModifyTime:(NSString*)path{
    NSError *err;
    NSDictionary *dic = [[NSFileManager defaultManager]attributesOfItemAtPath:path error:&err];
    if (err) {
        NSLog(@"%@",err);
    }
    NSDate *date = [dic objectForKey:NSFileModificationDate];
    return [date timeIntervalSince1970];
}
+(NSInteger)getCacheSize{
    NSError *err;
    int sum = 0;
    //取得cache目录下所有文件的数组
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDir  error:&err];
    if (err) {
        NSLog(@"%@",err);
    }
    for (NSString *fileName in arr) {
        if ([fileName hasPrefix:@"."]) continue;
        NSString *path = [NSString stringWithFormat:@"%@/%@",cacheDir,fileName];
        NSDictionary *dic = [[NSFileManager defaultManager]attributesOfItemAtPath:path error:nil];
        sum += [[dic objectForKey:NSFileSize] integerValue];
    }
    return sum;
}

//saveToSandBox
-(void)saveToSandBox:(NSString*)str  andData:(NSData*)data{
    NSError *err;
    [[NSFileManager defaultManager]createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:&err];
    if (err) {
        NSLog(@"%@",err);
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",cacheDir,[str MD5Hash]];

    if ([data writeToFile:path atomically:YES]) {
        NSLog(@"缓存成功 %@",path);
    }else{
        NSLog(@"缓存失败");
    }
}
@end
