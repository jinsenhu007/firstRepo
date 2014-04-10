//
//  ReplyModel.h
//  huabo
//
//  Created by admin on 14-4-4.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseModel.h"
#import "Const.h"

@interface ReplyModel : BaseModel
PropertyNumber(MessageIndexID); //消息索引编号,
PropertyNumber(TargetUserID);   //目标用户编号,
PropertyString(TargetUserName); //"目标用户名称",
PropertyString(TargetUserHeadSculpture48);  //目标用户头像48*48",
PropertyNumber(TargetUserLevel);    //目标用户等级,
PropertyNumber(TargetMessageID);    //目标消息编号,
PropertyString(TargetMessageContent);   //目标消息内容",
PropertyInt(TargetMessageType);         //消息类型(1：评论源消息；2：评论评论者的消息；4：转发源消息；8：收藏源消息；16：发布源消息),        在@我的 界面显示的有2中 1，2 和 4，16 分别显示为“管理员 在回复中提到了你:”，“刘嫚 提到了你:”

//有关Source的不解析;(在我的回复里解析source，没有original)
PropertyNumber(SourceMessageType);      // 源消息类型,
PropertyString(SourceMessageContent);   //"源消息内容",
PropertyInt(SourceMessageIsDeleted);    //源消息是否被删除（true：删除 false：未删除）,
PropertyNumber(SourceMessageID);        //源消息id
PropertyNumber(SourceUserID);
PropertyString(SourceUserName);
//这里为了和web端显示同步，我只显示Original message（只解析）

PropertyNumber(OriginalUserID);     // 原始用户编号,
PropertyString(OriginalUserName);   //"原始用户真实姓名",
PropertyString(OriginalUserHeadSculpture48);    //原始用户头像48*48"
PropertyNumber(OriginalMessageID);      //原始消息编号,
PropertyString(OriginalMessageContent); //"google 允许修改",
PropertyInt(OriginalMessageIsDeleted);  //原始消息是否被删除（true：删除 false：未删除）,
PropertyInt(IsStarMark);                //是否标星（true：是  false 否）,
PropertyNumber(TransferedMessageID);    //被转发的消息编号（转发的时候会用到）,
PropertyNumber(TransferedUserID);       //被转发的消息用户编号（转发的时候会用到）,
PropertyString(SubTimeStr);             //"消息时间",
@end
