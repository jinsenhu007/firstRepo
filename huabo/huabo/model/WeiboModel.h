//
//  WeiboModel.h
//  huabo
//
//  Created by admin on 14-3-10.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseModel.h"
#import "Const.h"


@class MessageInfo;
@class AttachmentInfo;
@class TransferedMessageInfo;
@class VoteInfo;
@interface WeiboModel : BaseModel

PropertyNumber(MessageIndexID);     //消息索引编号 maxID和sinceID传递此项,
PropertyNumber(UserInfoID);         //用户信息编号,
PropertyString(UserRealName);       //"用户真实姓名",
PropertyString(HeadSculpture48);    //"用户头像 48*48",
PropertyNumber(Level);              //用户等级,
PropertyBool(More);                 //是否还有更多数据（true：是；false：否）,
PropertyNumber(MaxID);              // 当前返回的数据中的最小数据编号，此参数供查询比之发表早的消息动态,
PropertyNumber(SinceID);            //当前返回的数据中的最大数据编号，此参数供查询比之发表晚的消息动态
@property (retain,nonatomic) MessageInfo *msgInfo;
@property (retain,nonatomic) NSMutableArray *arrAttachments;//附件数组
PropertyNumber(MessageCommentTotalCount);   //消息评论总条数,
PropertyNumber(MessageTransferTotalCount);  // 消息转发总条数,
PropertyNumber(MessageCollectTotalCount);   //消息收藏总条数,
PropertyNumber(MessageLikeTotalCount);      //消息赞总条数
PropertyInt(CollectFlag);       //是否已被收藏（true：已收藏；false：没有被收藏）
PropertyInt(StarMark);         // 是否标星（true：已标星；false：没有被标星）
PropertyInt(IsMy);             //是否是我提交的（true：是；false：否）
PropertyInt(LikeFlag);         //当前用户是否赞 （true 已赞  false 未赞）,
PropertyInt(LikerMore);        //是否有更多点赞用户（true 还有  false 没有了）
@property (retain,nonatomic) TransferedMessageInfo *transInfo;  //转发的消息
@property (retain,nonatomic) VoteInfo *voteInfo;    //投票信息
@end



@interface MessageInfo : BaseModel
PropertyNumber(ID);     //消息信息编号,
PropertyString(Content);//消息内容
//PropertyString(ContentTip); //"[偷笑]@刘嫚  做的不错！"
PropertyInt(Type);          //消息类型（1：评论源消息；2：评论评论者的消息；4：转发源消息；8：收藏源消息；16：发布源消息）,
PropertyInt(DivideType);    //消息分类类型（1：普通消息；2：图片；4：文件；8：投票）
PropertyInt(ComeFromType);  //消息来源（1：网页端；2：android手机端；4：Ios手机端；8：pc客户端）
PropertyInt(SendObjectType);//发布对象类型（1：所有人(管理员)；2：所有粉丝；4仅自己；8：发送至群组；16：所有粉丝和群组）,
PropertyString(GUID);       //
PropertyString(SubTimeStr); //"消息提交时间"
@end

@interface AttachmentInfo : BaseModel
PropertyNumber(ID); //附件编号
PropertyInt(Type);  // 附件类型（1：文件；2：图片）,
PropertyString(AttachmentPathFull); //带的附件完整路径
PropertyString(AttachmentName); //"附件名称",
PropertyString(ImageSmallPath); //"图片缩略图完整路径",
PropertyString(ImageBigPath);   // "图片大图完整路径"

@end
//------------------被转发的消息-------------------
@interface TransferedMessageInfo : BaseModel
@property (retain,nonatomic) WeiboModel *tModel;
@end

//------------------投票-----------------------
@class Options;
@interface VoteInfo : BaseModel
PropertyNumber(AvailableNumber);   //允许选择的选项个数
PropertyInt(Anonymous);         /// 投票匿名  true 匿名投票 false 不是匿名
PropertyString(Deadline);       //"截止日期",
PropertyInt(IsDeadline);        //是否已经过期 （true 已经过期 false 未过期）,
PropertyInt(MyVoted);           // 是否我已经投票 （true 已经投票 false 未投票）
PropertyInt(Visble);            // 是否可以查看投票结果,
PropertyNumber(VoteInfoID);     //投票编号
@property (retain,nonatomic) NSMutableArray *arrMyVotedOptions;// 我投的选项编号(数组放的NSNumber)
@property (retain,nonatomic) NSMutableArray *arrOptions;        //

@end
//----------------投票中的选项字段---------------
@interface Options : BaseModel
@property (retain,nonatomic) AttachmentInfo *attMent;   //附件 （可以不带图片，只是文字）
PropertyNumber(OptionID);       //选项编号,
PropertyString(OptionName);     //"选项名称",
PropertyNumber(Percentage);     //该选项投票数占总条数百分比,
//没有加 VoteMembers数组
@end

//-------------------评论-------------------------
@class SourceTargetMsgInfo;
@interface CommentModel : BaseModel
PropertyInt(MessageRelationType);    //消息关系类型（1：评论源消息；2：评论评论者的消息；4：转发源消息；8：收藏源消息；16：发布源消息）,
PropertyString(SubTimeStr);     //消息提交时间
@property (retain,nonatomic) SourceTargetMsgInfo *sourceInfo;
@property (retain,nonatomic) SourceTargetMsgInfo *targetInfo;

@end
//-------------------评论里的Source Target message info-------------------------
@interface SourceTargetMsgInfo : BaseModel
PropertyString(HeadSculpture48);
PropertyNumber(Level);          //等级,
PropertyNumber(UserInfoID);     //用户信息编号,
PropertyString(UserRealName);      //用户真实姓名
@property (retain,nonatomic) MessageInfo *msgInfo;
@property (retain,nonatomic) NSMutableArray *arrAttInfoList;
@end