//
//  SysMsgModel.h
//  huabo
//
//  Created by admin on 14-4-10.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseModel.h"
#import "Const.h"
@interface SysMsgModel : BaseModel


PropertyNumber(MessageIndexID); //消息索引编号,
PropertyString(MessageContent); //消息内容(###id|name###代表@用户(id为用户id name为用户名)，%%%id|name%%%代表@群组(id为群组id name为群组名称)，$$$id|动态$$$代表@动态(id为消息编号))",
PropertyString(SubTimeStr);     //"提交时间"
@end
