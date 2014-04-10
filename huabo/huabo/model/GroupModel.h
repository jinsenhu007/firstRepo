//
//  GroupModel.h
//  huabo
//
//  Created by admin on 14-3-24.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"
@interface GroupModel : NSObject

PropertyNumber(ID);         //群组编号,
PropertyString(GroupName);  //群组名称",
PropertyInt(GroupType);     //群组类型（1：私有 列入公司群组列表；2：私有 不列入公司群组列表；4：公共）,
PropertyString(GroupNameShort); //群组简称"


PropertyBool(rowSelected); //是否选中
@end
