//
//  UserModel.h
//  huabo
//
//  Created by admin on 14-3-5.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"

@interface UserModel : NSObject<NSCoding>

PropertyString(CompanyEmail);       //邮箱
PropertyString(CompanyName);
PropertyString(DepartmentName);    //部门名称
PropertyInt(FollowCount);         //关注数量

PropertyString(HeadSculpture);
PropertyString(HeadSculpture100);
PropertyString(HeadSculpture24);
PropertyString(HeadSculpture48);

PropertyInt(ID);
PropertyInt(Integral);           //积分
PropertyBool(IsCurrentUser);     // 是否是当前用户 (true/false)
PropertyBool(IsFollowed);       //是否被我关注
PropertyString(JobName);        // 职位名称
PropertyString(JobNumber);      //工号
PropertyInt(Level);             //等级
PropertyString(LevelName);      //等级名称
PropertyInt(ListenerCount);     //粉丝数量,

PropertyString(LoginEmail);     // 登录邮箱
PropertyString(LoginPwd);       //另加：本地保存

PropertyString(QQ);
PropertyString(RealName);       //用户真实姓名
PropertyString(TelPhone);       //电话
PropertyInt(VisitedCount);      //主页访问数量

//----current no ----
PropertyString(SinaWeiBo);
PropertyString(TencentWeiBo);
PropertyString(WeiXin);

//----获取网络信息-----
/*
 NetworkID = 1;
 NetworkName = "\U534e\U535a\U96c6\U56e2";
 Token = "393c565a-be31-413d-8f43-5b32ab74a4e1";
 UserNetworkRole = 1;
 UserNetworkType = 1;
 */

PropertyInt(NetworkID);
PropertyString(NetworkName);
PropertyString(Token);
PropertyInt(UserNetworkRole);
PropertyInt(UserNetworkType);

//获取联系人界面用得
PropertyInt(IsMy);
PropertyString(WorkPhone);

//
PropertyInt(sectionNum);//在@推出的界面中代表当前model所属的section
PropertyBool(rowSelected);//标志选中
@end
