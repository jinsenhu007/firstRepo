//
//  UserModel.m
//  huabo
//
//  Created by admin on 14-3-5.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "UserModel.h"

#define encObj(a,b) [aCoder encodeObject:(a) forKey:(b)]
#define encInt(a,b) [aCoder encodeInt:(a) forKey:(b)]
#define encBool(a,b) [aCoder encodeBool:(a) forKey:(b)]

#define decObj(p) [aDecoder decodeObjectForKey:(p)];
#define decInt(p) [aDecoder decodeIntForKey:(p)];

@implementation UserModel


- (void)encodeWithCoder:(NSCoder *)aCoder{
    encObj(_Token, @"Token");
    encInt(_ID,@"ID" );
    encInt(_NetworkID, @"NetworkID");
    encObj(_NetworkName, @"NetworkName");
    encInt(_UserNetworkRole, @"UserNetworkRole");
    encInt(_UserNetworkType, @"UserNetworkType");
    encObj(_LoginEmail, @"LoginEmail");
    encObj(_LoginPwd, @"LoginPwd");
    
    encObj(_CompanyEmail,@"CompanyEmail");
    encObj(_CompanyName, @"CompanyName");
    encObj(_DepartmentName, @"DepartmentName");
    encInt(_FollowCount, @"FollowCount");
    encObj(_HeadSculpture, @"HeadSculpture");
    encObj(_HeadSculpture100, @"HeadSculpture100");
    encObj(_HeadSculpture24, @"HeadSculpture24");
    encObj(_HeadSculpture48, @"HeadSculpture48");
    encInt(_Integral, @"Integral");
    encInt(_IsCurrentUser, @"IsCurrentUser");
    encInt(_IsFollowed, @"IsFollowed");
    encObj(_JobName, @"JobName");
    encObj(_JobNumber, @"JobNumber");
    encInt(_Level, @"Level");
    encObj(_LevelName, @"LevelName");
    encInt(_ListenerCount, @"ListenerCount");
    encObj(_QQ, @"QQ");
    encObj(_RealName, @"RealName");
    encObj(_TelPhone, @"TelPhone");
    encInt(_VisitedCount, @"VisitedCount");
    
   
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _Token = decObj(@"Token");
        _ID = decInt(@"ID");
        _NetworkID = decInt(@"NetworkID");
        _NetworkName = decObj(@"NetworkName");
        _UserNetworkRole = decInt(@"UserNetworkRole");
        _UserNetworkType = decInt(@"UserNetworkType");
        _LoginEmail = decObj(@"LoginEmail");
        _LoginPwd = decObj(@"LoginPwd");
        
        _CompanyEmail = decObj(@"CompanyEmail");
        _CompanyName = decObj(@"CompanyName");
        _DepartmentName = decObj(@"DepartmentName");
        _FollowCount = decInt(@"FollowCount");
        _HeadSculpture = decObj(@"HeadSculpture");
        _HeadSculpture100 = decObj(@"HeadSculpture100");
        _HeadSculpture24 = decObj(@"HeadSculpture24");
        _HeadSculpture48 = decObj(@"HeadSculpture48");
        _Integral = decInt(@"Integral");
        _IsCurrentUser = decInt(@"IsCurrentUser");
        _IsFollowed = decInt(@"IsFollowed");
        
        _JobName = decObj(@"JobName");
        _JobNumber = decObj(@"JobNumber");
        _Level = decInt(@"Level");
        _LevelName = decObj(@"LevelName");
        _ListenerCount = decInt(@"ListenerCount");
        _QQ = decObj(@"QQ");
        _RealName = decObj( @"RealName");
        _TelPhone = decObj(@"TelPhone");
        _VisitedCount = decInt(@"VisitedCount");
        
    }
    return self;
}
@end
/*
 NetworkID = 1;
 NetworkName = "\U534e\U535a\U96c6\U56e2";
 Token = "393c565a-be31-413d-8f43-5b32ab74a4e1";
 UserNetworkRole = 1;
 UserNetworkType = 1;
 */