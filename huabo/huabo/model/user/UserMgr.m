//
//  UserMgr.m
//  huabo
//
//  Created by admin on 14-3-6.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "UserMgr.h"

@implementation UserMgr


+(id) sharedInstance{
    static id _s ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s = [[[self class]alloc]init];
    });
    return _s;
}

- (NSString*) getCurrUserFile{
    return [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"/Library/Caches/CurrUser"];
}

- (void) setLoginUser:(UserModel *)m{
    _currUser = m;
    [self saveToDisk:m];
}

- (void)saveToDisk:(UserModel *)m{
    if (_currUser != m) _currUser = m;
    NSString *f = [self getCurrUserFile];
    NSLog(@"current user file path %@",f);
   BOOL isOk = [NSKeyedArchiver archiveRootObject:m toFile:f];
    if (!isOk) {
        NSLog(@"write to file %@ fail ",f);
    }else{
        NSLog(@"write to file %@ success !",f);
    }
}

- (UserModel *) readFromDisk{
    NSString *f = [self getCurrUserFile];
    if(![[NSFileManager defaultManager]fileExistsAtPath:f])
    {
        //bu cun zai
        _currUser = [[UserModel alloc]init];
        return _currUser;
    }
    UserModel *u = [NSKeyedUnarchiver unarchiveObjectWithFile:f];
    if(_currUser == nil) _currUser = u;
    return u;
}
@end
