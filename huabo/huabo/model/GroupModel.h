//
//  GroupModel.h
//  huabo
//
//  Created by admin on 14-3-24.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"
#import "BaseModel.h"
@interface GroupModel : NSObject

PropertyNumber(ID);         //群组编号,
PropertyString(GroupName);  //群组名称",
PropertyInt(GroupType);     //群组类型（1：私有 列入公司群组列表；2：私有 不列入公司群组列表；4：公共）,
PropertyString(GroupNameShort); //群组简称"


PropertyBool(rowSelected); //是否选中




@end

//--------------以下为DetailGrpCell使用------------------
@interface DetailGrpModel : BaseModel
PropertyNumber(GroupID);    // 群组编号,
PropertyString(GroupHeadSculpture24);   //
PropertyString(GroupName);      //"群组名称",
PropertyInt(GroupType);         //群组类型（1私有 列入公司群组列表，2私有 不列入公司群组列表，4公共）
PropertyNumber(MemberCount);       // 成员数量,
PropertyNumber(MessageCount);   // 消息数量,
PropertyNumber(CreaterID);      //创建者编号,
PropertyString(CreaterName);    //创建者姓名",
PropertyString(SubTimeStr);     //"创建时间",
PropertyInt(GroupStatus);       // 群组状态 （1正常 2 已关闭）,
PropertyInt(IsJoined);          //

@end