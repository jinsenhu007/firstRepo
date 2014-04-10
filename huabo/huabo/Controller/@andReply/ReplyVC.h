//
//  ReplyVC.h
//  huabo
//
//  Created by admin on 14-4-4.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"
#import "PopupListComponent.h"
#import "MyReplyVC.h"
#import "AtMeVC.h"
@interface ReplyVC : BaseViewController<PopupListComponentDelegate,UITableViewDataSource,UITableViewDelegate>
{
    PopupListComponent *_popupList;
    NSMutableArray *_popArray;
    
    BOOL _needCache;
    
    UIView *_popupBGView;
    
    NSInteger _maxID; //获取更多数据用的 for 回复我的
    BOOL _isLoadMore; //是否加载更多数据

    NSInteger _myReplyMaxID;    //我的回复中maxid
    
    
    MyReplyVC *_myReply;
    UIView *_myReplyView;
    
    AtMeVC *_atMe;
    UIView *_atMeView;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *titleBtn;

@property (strong, nonatomic) IBOutlet UIView *navTitleView;
- (IBAction)clickBtn:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *arrow;

@property (retain,nonatomic) NSMutableArray *arrData;

@property (retain,nonatomic) NSString *strOfUrl;
@end
