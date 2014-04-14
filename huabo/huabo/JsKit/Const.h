//
//  Const.h
//  huabo
//
//  Created by admin on 14-3-5.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PropertyString(p) @property(nonatomic,copy) NSString *p
#define PropertyFloat(p) @property (nonatomic, assign) float p;
#define PropertyInt(p) @property (nonatomic, assign) NSInteger p;
#define PropertyUInt(p) @property (nonatomic, assign) NSUInteger p;
#define PropertyBool(p) @property (nonatomic,assign) BOOL p;
//@property (retain,nonatomic) NSNumber *num
#define PropertyNumber(p) @property (nonatomic,retain) NSNumber *p;



#define kHost @"http://192.168.0.221:8080"
#define kBaseUrl(str) [NSString stringWithFormat:@"%@%@",kHost,str]

//test
#define kTestHost @"http://192.168.1.71:8080"
#define kTestBaseUrl(str) [NSString stringWithFormat:@"%@%@",kTestHost,str]
//--------------------登录-POST---------------
/*
 loginCode  string  用户登录邮箱
 loginPwd   string  用户登录密码
 */

#define kLoginCode @"loginCode"
#define kLoginPwd @"loginPwd"
#define kLoginUrl @"http://192.168.0.221:8080/login/login/"

//--------------1.02 刷新当前账号用户访问令牌--POST------------
//parameter : accountID (int)
#define kAccountID @"accountID"
#define kUpdateTokenUrl @"http://192.168.0.221:8080/userinfo/update_token/"

//--------------------获取用户所在所有网络信息---GET-------------
#define kUserNetworkUrl @"http://192.168.0.221:8080/network/user_networks/?accountID=1&format=json"


//--------------------用户的基本信息--GET--------------
#define kUserDetailUrl @"http://192.168.0.221:8080/userinfo/user_detail/?userID=%d&token=%@&format=json"

//--------------------2.01 获取动态_全公司 new--GET--------------
/*
 divideType     消息分类（0全部 1默认 2图片 4文件）
 */
#define kAllMessageUrl @"http://192.168.0.221:8080/message/all/?pageSize=10&token=%@&divideType=%d"

//--------------------3.11 动态更新_点赞 post--------------
#define kMsgLikeUrl kBaseUrl(@"/message/like/")
#define kMsgUnLikeUrl kBaseUrl(@"/message/delete_like/")
//--------------------1.04 获取用户的基本信息 get-----------
#define kUserInfoUrl kBaseUrl(@"/userinfo/user_detail/?userID=%d&token=%@")

//--------------------1.09 获取通讯录用户列表 get-----------
//pageIndex=0 pageSize=0 可以获取所有的好友
//allFlag 搜索全部（默认要提供此参数）0,1
//followFlag  搜索已关注的用户 0,1
#define kContactorsUrl kBaseUrl(@"/userinfo/users/?pageIndex=0&pageSize=0")

//-------------------3.01 动态更新_发布动态更新 post--------------
#define kPublishUrl kBaseUrl(@"/message/publish/")

//--------------------2.12 获取动态_单条动态所有评论 get-----------
#define kCommentsUrl kBaseUrl(@"/message/comments/?messageID=%@&token=%@")


//--------------------5.01 部门_获取公司所有简单部门 (用于绑定下拉框) get-----------
#define kDepartments kBaseUrl(@"/department/simple_departments/?token=%@")

//----------------------4.01 通讯录_获取公司所有简单群组 (用于绑定下拉框)-------------
#define kGroupsUrl kBaseUrl(@"/group/simple_groups/?token=%@")

//----------------------7.02 附件_上传图片（beta） post----------------------
#define kFileHost @"http://192.168.0.221"
#define kUploadImageUrl  [NSString stringWithFormat:@"%@%@",kFileHost,@"/upload/uploadImage"]

//---------------------1.05 获取@用户列表 get-----------------------------
#define kAtUsersUrl kBaseUrl(@"/userinfo/atusers/?token=%@")

//---------------------3.02 动态更新_评论源消息 post----------------------
#define kCommentSourceUrl kBaseUrl(@"/message/comment_source/")

//---------------------3.03 动态更新_评论评论者的消息 post----------------------
#define kCommentCommenterUrl kBaseUrl(@"/message/comment_commenter")

//---------------------3.04 动态更新_转发源消息 post----------------------
#define kTransferSourceUrl kBaseUrl(@"/message/transfer_source")

//---------------------3.05 动态更新_转发转发者的消息 post----------------------
#define kTransfer_transferUrl kBaseUrl(@"/message/transfer_transferedSource")

//下面定义为了在
typedef  NS_ENUM(NSUInteger, CommentType){
    CommentSource = 1,  //动态更新_评论源消息
    Comment_Comment,    //评论评论者的消息
    TransferSource ,    //转发源消息
    Transfer_Transfer,  //转发转发者的消息
};


//----------------3.06 动态更新_收藏源消息 post-------------------
#define kCollectMsgUrl kBaseUrl(@"/message/collect/")
//----------------3.07 动态更新_取消收藏源消息 post-------------------
#define kUnCollectMsgUrl kBaseUrl(@"/message/delete_collect/")
//----------------3.08 动态更新_删除消息 post-------------------
#define kDeleteMsgUrl kBaseUrl(@"/message/delete/")

//----------------2.06 获取动态_回复当前登录用户的 get-------------------
#define kReplyMeUrl kBaseUrl(@"/message/replyme/?pageSize=10&token=%@")

//----------------2.05 获取动态_当前登录用户回复别人的 get-------------------
#define kReplyByMeUrl kBaseUrl(@"/message/replybyme/?pageSize=10&token=%@")
//----------------2.07 获取动态_提到当前登录用户的 get-------------------
#define kAtMeUrl kBaseUrl(@"/message/atme/?pageSize=10&token=%@")

//----------------2.08 获取动态_发给当前登录用户的系统消息 get-------------------
#define kSysMsgUrl kBaseUrl(@"/message/system/?pageSize=10&token=%@")

//----------------2.11 获取动态_单条动态更新内容 get-------------------
#define kOneMsgDetailUrl kBaseUrl(@"/message/detail/?messageID=%d") ////注意这里没带token

//----------------2.13 获取动态_群组消息 get-------------------
#define kGroupMsgUrl kBaseUrl(@"/message/group_message/?groupID=%d")  ////注意这里没带token

//----------------2.13 获取动态_群组消息 get-------------------
#define kUnreadMsgUrl kBaseUrl(@"/message/unread/?token=%@") 

//----------------4.02 群组_获取公司所有群组 get-------------------
#define kGroupUrl kBaseUrl(@"/group/groups/?IsShowClosed=1&RelationSearchType=%d&token=%@")