//
//  UserMgr.h
//  huabo
//
//  Created by admin on 14-3-6.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface UserMgr : NSObject
{
    UserModel *_currUser;
}

+ (id) sharedInstance;

- (void) setLoginUser:(UserModel *)m;

- (void)saveToDisk:(UserModel *)m;

- (UserModel *) readFromDisk;
@end
