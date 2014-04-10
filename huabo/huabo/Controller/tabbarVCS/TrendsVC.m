//
//  AllViewController.m
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "TrendsVC.h"
#import "JsDevice.h"
#import "TrendsCell.h"
#import "SVPullToRefresh.h"
#import "AppDelegate.h"
#import "factory.h"
#import "BlockUI.h"
#import "WeiboViewController.h"
#import "JsBtn.h"
#import "jsHttpHandler.h"
#import "UIViewExt.h"
#import "UserMgr.h"
#import "UserModel.h"
#import "DDMenuController.h"
#import "TrendsView.h"
#import "SecFooter.h"
#import "UIImage+imageNamed_JSen.h"
#import "DetailVC.h"
#import "JsDevice.h"
#import "MMProgressHUD.h"

#define CELL_HEIGHT 200
#define LEFT_GAP 8



@interface TrendsVC ()
@property (assign,nonatomic) bool a;
@end

@implementation TrendsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

-(void)createDropDwonMenu{
    btn = [factory createButtonFrame:CGRectMake(0, 0, 100, 44) Title:@"全部消息" Target:self Action:@selector(btnClicked:) Tag:0];
    btn.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = btn;
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
   self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _loadDataSource = NO;
    _devideType = 0;
     _SinceID = 0;
    self.view.backgroundColor = [UIColor lightGrayColor];
    IOS7;
    
   
    
   // [self showTitle:@"全部消息"];
    
    
    [self showLeftButtonWithImageName:@"选项栏.png" target:self action:@selector(leftBtnPress)];
    [self showRightButtonWithImageName:@"编辑.png" target:self action:@selector(rightBtnPress:)];
    
    _arrData = [NSMutableArray array];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(LEFT_GAP, 0, kScreenWidth-LEFT_GAP*2, kScreenHeight-49-44) style:UITableViewStyleGrouped];
   // NSLog(@"%f %f",kScreenHeight,kScreenWidth);
    NSLog(@"%f",_tableView.frame.origin.y);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
    [self createDropDwonMenu];
    
    
    __weak TrendsVC *weakSelf = self;
    [_tableView addPullToRefreshWithActionHandler:^{
        [weakSelf.tableView.pullToRefreshView setTitle:@"正在加载中..." forState:SVPullToRefreshStateLoading];
        [weakSelf.tableView.pullToRefreshView setTitle:@"释放立即刷新" forState:SVPullToRefreshStateTriggered];
        [weakSelf.tableView.pullToRefreshView setTitle:@"往下拉来刷新" forState:SVPullToRefreshStateStopped];
        
        [weakSelf loadDataSource];
    }];
    
    
    //上拉加载更多
    [_tableView addInfiniteScrollingWithActionHandler:^{
        if (weakSelf.tableView.pullToRefreshView.state != SVPullToRefreshStateStopped) {
            return ;
        }
        [weakSelf loadMoreData];
    }];

     [_tableView triggerPullToRefresh];
    _needCache = NO;
    
    //通知接收从detail发过来的删除某一条消息
    [[NSNotificationCenter defaultCenter] addObserverForName:@"deleteMSGSuccess" object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification *note) {
        WeiboModel *m = [note.userInfo objectForKey:@"model"];
        [_arrData removeObject:m];
    }];
    
	// Do any additional setup after loading the view.
}


-(void)loadDataSource{
    __weak TrendsVC *weakSelf = self;
    
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        
        UserModel *model =[[UserMgr sharedInstance] readFromDisk];
        _strOfUrl = [NSString stringWithFormat:kAllMessageUrl,model.Token,_devideType];
        
        _loadDataSource = YES;
        _needCache = NO;
       
        _SinceID = 0;   //depredicated ,bad manner to load data
        NSString *s = [NSString stringWithFormat:kAllMessageUrl,model.Token,_devideType];
        _strOfUrl = [NSString stringWithFormat:@"%@&sinceID=%d",s,_SinceID];
        [weakSelf _downloadWithStrOfUrl:_strOfUrl];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        NSString *subTitle = [NSString stringWithFormat:@"上次更新%@",str];
        [weakSelf.tableView.pullToRefreshView setSubtitle:subTitle forState:SVPullToRefreshStateAll];

        
       // [weakSelf.tableView.pullToRefreshView stopAnimating];
    });
}
-(void)loadMoreData{
    __weak TrendsVC *weakSelf = self;
    double delayInSeconds = 0.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UserModel *model =[[UserMgr sharedInstance] readFromDisk];
        
        _loadDataSource = NO;
        NSString *str = [NSString stringWithFormat:kAllMessageUrl,model.Token,_devideType];
        _strOfUrl = [NSString stringWithFormat:@"%@&maxid=%d",str,_maxID];
        NSLog(@"load more %@",_strOfUrl);
        _needCache = YES;
        [weakSelf _downloadWithStrOfUrl:_strOfUrl];
    });
}

//--------------下载数据--------------
- (void)_downloadWithStrOfUrl:(NSString *)strOfUrl
{
     NSLog(@"allMsg url %@",strOfUrl);
    [jsHttpHandler setCacheTime:1*60*60];
    [jsHttpHandler jsHttpDownloadWithStrOfUrl:strOfUrl withCache:_needCache completionBlock:^(id JSON) {
        if (JSON == nil) {
            return ;
        }
       
             //返回的没有数据
        if ([[JSON objectForKey:@"Total"] intValue] == 0) {
            NSLog(@"没有更多数据了");
            if (_tableView.pullToRefreshView.state == 2) {
                [_tableView.pullToRefreshView stopAnimating];
                return ;
            }
            [_tableView.infiniteScrollingView stopAnimating];
            return;
        }
        
        if ( _loadDataSource ) {
            [_arrData removeAllObjects];
        }
        
        NSArray *arrRows = [JSON objectForKey:@"Rows"];
        
        NSLog(@"arrRows count %d MaxID %d",arrRows.count,_maxID);
        
         _maxID = [[JSON objectForKey:@"MaxID"] intValue];
        //只有在下拉刷新的时候才需要改变SinceID
        if (_loadDataSource) {
          _SinceID = [[JSON objectForKey:@"SinceID"] intValue];
        }
        
        for (NSDictionary *dict in [JSON objectForKey:@"Rows"]){
            
            WeiboModel *wModel = [[WeiboModel alloc]init];
            wModel.MessageIndexID = [dict objectForKey:@"MessageIndexID"];
            wModel.UserInfoID = [dict objectForKey:@"UserInfoID"];
            wModel.UserRealName = [dict objectForKey:@"UserRealName"];
            wModel.HeadSculpture48 = [dict objectForKey:@"HeadSculpture48"];
            wModel.Level = [dict objectForKey:@"Level"];
            wModel.MessageCommentTotalCount = [dict objectForKey:@"MessageCommentTotalCount"];
            wModel.MessageTransferTotalCount = [dict objectForKey:@"MessageTransferTotalCount"];
            wModel.MessageLikeTotalCount = [dict objectForKey:@"MessageLikeTotalCount"];
            wModel.MessageCollectTotalCount = [dict objectForKey:@"MessageCollectTotalCount"];
            //
            wModel.CollectFlag = [[dict objectForKey:@"CollectFlag"]intValue];
            wModel.IsMy = [[dict objectForKey:@"IsMy"]intValue];
            wModel.LikeFlag = [[dict objectForKey:@"LikeFlag"] intValue];
           // NSLog(@"LikeFlag %d",wModel.LikeFlag);
            wModel.StarMark = [[dict objectForKey:@"StarMark"] intValue];
            wModel.LikerMore = [[dict objectForKey:@"LikerMore"] intValue];
            
            
            NSDictionary *msgDic = [dict objectForKey:@"MessageInfo"];
            MessageInfo *msgInfo = [[MessageInfo alloc]init];
            msgInfo.ID = [msgDic objectForKey:@"ID"];
            //msgInfo.ContentTip = [msgDic objectForKey:@"ContentTip"];//没要content
            msgInfo.Content = [msgDic objectForKey:@"Content"];
           // NSLog(@"contentTip %@",msgInfo.Content);
           
            msgInfo.ComeFromType = [[msgDic objectForKey:@"ComeFromType"] intValue];
            msgInfo.SendObjectType = [[msgDic objectForKey:@"SendObjectType"] intValue];
            msgInfo.SubTimeStr = [msgDic objectForKey:@"SubTimeStr"];
            msgInfo.Type = [[msgDic objectForKey:@"Type"] intValue];

            wModel.msgInfo = msgInfo;
            
            
            NSArray *attInfoArr = [dict objectForKey:@"AttachmentInfoList"];
            //带有附件（图片...）
            if (attInfoArr.count) {
                wModel.arrAttachments = [NSMutableArray array];
                for (NSDictionary *attDict in attInfoArr) {
                    AttachmentInfo *attach = [[AttachmentInfo alloc]init];
                    attach.Type = [[attDict objectForKey:@"Type"] intValue];
                    attach.ID = [attDict objectForKey:@"ID"];
                    attach.AttachmentPathFull = [attDict objectForKey:@"AttachmentPathFull"];
                    attach.AttachmentName = [attDict objectForKey:@"AttachmentName"];
                    attach.ImageSmallPath = [attDict objectForKey:@"ImageSmallPath"];
                    attach.ImageBigPath = [attDict objectForKey:@"ImageBigPath"];
                    
                    [wModel.arrAttachments addObject:attach];
                }
            }else{
                wModel.arrAttachments = nil;
            }
           // NSLog(@"msg dic %@",msgDic);
            
            //带有转发的消息
            NSDictionary *transDic = [dict objectForKey:@"TransferedMessageInfo"];
          
            if (![transDic isKindOfClass:[NSNull class]]) {
                wModel.transInfo = [[TransferedMessageInfo alloc ]init];
                [self _parseMessageInfo:transDic model:wModel];
                [self _parseAttachmentInfoList:transDic model:wModel];
                wModel.transInfo.tModel.UserRealName = [transDic objectForKey:@"UserRealName"];
                wModel.transInfo.tModel.UserInfoID = [transDic objectForKey:@"UserInfoID"];
              //  NSLog(@"++++ wModel.transInfo.tModel.UserRealName  %@",[transDic objectForKey:@"UserRealName"]);
            }else{
              //  NSLog(@"no transfer");
                wModel.transInfo = nil;
            }
            
            
            NSDictionary *voteDic = [dict objectForKey:@"VoteInfo"];
            //带有投票
            if (![voteDic isKindOfClass:[NSNull class]]) {
                wModel.voteInfo = [[VoteInfo alloc]init];
                [self _parseVoteInfo:voteDic model:wModel];
            }else{
                wModel.voteInfo = nil;
            }
            
            //  下拉刷新，往原来数组头部添加数据，上拉就加到数组尾部
            if (_loadDataSource) {
                [_arrData insertObject:wModel atIndex:0];
                _loadDataSource = NO;
            }else{
                [_arrData addObject:wModel];
            }
            
            
        }
        
        [_tableView reloadData];
        if (_tableView.pullToRefreshView.state == 2) {
            [_tableView.pullToRefreshView stopAnimating];
            return ;
        }
        [_tableView.infiniteScrollingView stopAnimating];
    }];

}
//解析消息  将消息放到   wModel.transInfo.tModel.msgInfo
- (void)_parseMessageInfo:(NSDictionary*)dict model:(WeiboModel*)wModel{
    NSDictionary *msgDic = [dict objectForKey:@"MessageInfo"];
    MessageInfo *msgInfo = [[MessageInfo alloc]init];
    msgInfo.ID = [msgDic objectForKey:@"ID"];
    msgInfo.Content = [msgDic objectForKey:@"Content"];//没要content
    NSLog(@"content %@",msgInfo.Content);
    
    msgInfo.ComeFromType = [[msgDic objectForKey:@"ComeFromType"] intValue];
    msgInfo.SendObjectType = [[msgDic objectForKey:@"SendObjectType"] intValue];
    msgInfo.SubTimeStr = [msgDic objectForKey:@"SubTimeStr"];
    msgInfo.Type = [[msgDic objectForKey:@"Type"] intValue];
    
    wModel.transInfo.tModel.msgInfo = msgInfo;
}
//解析附件
- (void)_parseAttachmentInfoList:(NSDictionary*)dict model:(WeiboModel*)wModel{
    NSArray *attInfoArr = [dict objectForKey:@"AttachmentInfoList"];
    //转发的消息带有附件（图片...）
    if (attInfoArr.count) {
        wModel.transInfo.tModel.arrAttachments = [NSMutableArray array];
        for (NSDictionary *attDict in attInfoArr) {
            AttachmentInfo *attach = [[AttachmentInfo alloc]init];
            attach.Type = [[attDict objectForKey:@"Type"] intValue];
            attach.ID = [attDict objectForKey:@"ID"];
            attach.AttachmentPathFull = [attDict objectForKey:@"AttachmentPathFull"];
            attach.AttachmentName = [attDict objectForKey:@"AttachmentName"];
            attach.ImageSmallPath = [attDict objectForKey:@"ImageSmallPath"];
            attach.ImageBigPath = [attDict objectForKey:@"ImageBigPath"];
            
            [wModel.transInfo.tModel.arrAttachments addObject:attach];
        }
    }else{
        wModel.transInfo.tModel.arrAttachments = nil;
    }

}
//解析投票
- (void)_parseVoteInfo:(NSDictionary*)dict model:(WeiboModel*)wModel{
    
    wModel.voteInfo.Anonymous = [[dict objectForKey:@"Anonymous"] intValue];
    wModel.voteInfo.AvailableNumber = [dict objectForKey:@"AvailableNumber"];
    wModel.voteInfo.Deadline = [dict objectForKey:@"Deadline"];
    wModel.voteInfo.IsDeadline = [[dict objectForKey:@"IsDeadline"] intValue];
    wModel.voteInfo.MyVoted  = [[dict objectForKey:@"MyVoted"] intValue];
    //我投过票
    if (wModel.voteInfo.MyVoted) {
        wModel.voteInfo.arrMyVotedOptions = [NSMutableArray arrayWithArray:[dict objectForKey:@"MyVotedOptions"]];
    }else{
        wModel.voteInfo.arrMyVotedOptions = nil;
    }
    
    wModel.voteInfo.arrOptions  = [NSMutableArray array];
    //解析Options
    NSArray *arrOptions = [dict objectForKey:@"Options"];
    for (NSDictionary *one in arrOptions) {
        Options *opt = [[Options alloc]init];
        opt.OptionID = [one objectForKey:@"OptionID"];
        opt.OptionName = [one objectForKey:@"OptionName"];
        opt.Percentage = [one objectForKey:@"Percentage"];
        
        //投票中得附件
        NSDictionary *attDict = [one objectForKey:@"AttachmentInfo"];
        if (![attDict isKindOfClass:[NSNull class]]) {
            AttachmentInfo *attach = [[AttachmentInfo alloc]init];
            attach.Type = [[attDict objectForKey:@"Type"] intValue];
            attach.ID = [attDict objectForKey:@"ID"];
            attach.AttachmentName = [attDict objectForKey:@"AttachmentName"];
            attach.ImageSmallPath = [attDict objectForKey:@"ImageSmallPath"];
            attach.ImageBigPath = [attDict objectForKey:@"ImageBigPath"];
        }else{
            opt.attMent = nil;
        }
        
        [wModel.voteInfo.arrOptions addObject:opt];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (_arrData.count == 0) {
//        return 10;
//    }
//    return _arrData.count;
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"cellId";
    
    TrendsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TrendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (_arrData.count == 0) {
        return cell;
    }
    WeiboModel *model = [_arrData objectAtIndex:indexPath.section];
    
    [cell setWeiboModel:model];
    
    UIButton *btn02 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn02 setBackgroundImage:[UIImage JSenImageNamed:@"向下箭头.png"] forState:UIControlStateNormal];
    btn02.frame = CGRectMake(kScreenWidth-50, 10, 12, 12) ;
    [btn02 addTarget:self action:@selector(clickArrow: event:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:btn02];
    return cell;
}

#pragma mark -viewForFooterInSection
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    // 1. The view for the header
//    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
//    headerView.userInteractionEnabled = YES;
//    // 2. Set a custom background color and a border
//    headerView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
//    headerView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
//    headerView.layer.borderWidth = 1.0;
//    
//    JsBtn *btn1  = [[JsBtn alloc]initWithFrame:CGRectMake(0, 0, 101, 40)];
//    btn1.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"statusdetail_header_arrow.png"]];
//    btn1.iconView.frame = CGRectMake(0, 0, 20, 20);
//    btn1.labelTxt.text = @"你好";
//    [btn1 handleAction:^(JsBtn *btn) {
//        NSLog(@"hello");
//        
//    }];
//    [headerView addSubview:btn1];
//    if (_arrData.count == 0) {
//        return nil;
//    }
    WeiboModel *model = [_arrData objectAtIndex:section];
    
    SecFooter *footer = [[SecFooter alloc ]initWithFrame:CGRectMake(0, 0, kScreenWidth-2*8, 30)];
    [footer useModel:model object:self];
   
    
    
    // 5. Finally return
    return footer;
}

#pragma mark - button action
-(void)leftBtnPress{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
    
}
#define POP_BGVIEW_TAG 999

-(void)rightBtnPress:(UIButton*)sender{
    /*
    _leftPopList= [[PopupListComponent alloc]init];
    NSArray *popArr = [NSMutableArray arrayWithObjects:
                 [[PopupListComponentItem alloc]initWithCaption:@"全部动态" image:nil itemId:10 showCaption:YES ],
                 [[PopupListComponentItem alloc] initWithCaption:@"文档" image:nil itemId:20 showCaption:YES],
                 [[PopupListComponentItem alloc ] initWithCaption:@"图片" image:nil itemId:30 showCaption:YES],
                 [[PopupListComponentItem alloc ] initWithCaption:@"投票" image:nil itemId:40 showCaption:YES],
                 nil];
    _popupList.textColor = [UIColor redColor];
    _popupList.userInfo  = @"value change";
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    view.backgroundColor =[UIColor yellowColor];
//    [self.view addSubview:view];
    
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-49-44)];
    view.backgroundColor =[UIColor clearColor];
    view.tag = POP_BGVIEW_TAG;
    [win addSubview:view];
    
    _popupList.buttonSpacing = 0;
    [_popupList showAnchoredTo:sender inView:view withItems:_popArray withDelegate:self];
    
    */
    
    WeiboViewController *weiBo = [[WeiboViewController alloc]init];
    weiBo.title = @"新建";
    [self.navigationController pushViewController:weiBo animated:YES];
}

-(void)btnClicked:(UIButton *)sender{
    if (_popupList) {
        _popupList = nil;
        return;
    }
    _popupList = [[PopupListComponent alloc]init];
    _popArray = [NSMutableArray arrayWithObjects:
                 [[PopupListComponentItem alloc]initWithCaption:@"全部动态" image:nil itemId:1 showCaption:YES ],
                 [[PopupListComponentItem alloc] initWithCaption:@"文档" image:nil itemId:2 showCaption:YES],
                 [[PopupListComponentItem alloc ] initWithCaption:@"图片" image:nil itemId:3 showCaption:YES],
                 [[PopupListComponentItem alloc ] initWithCaption:@"投票" image:nil itemId:4 showCaption:YES],
                 nil];
    _popupList.textColor = [UIColor redColor];
    _popupList.userInfo  = @"value change";
  
   [_popupList showAnchoredTo:sender inView:self.view withItems:_popArray withDelegate:self];
}

#pragma mark - UITableViewDelegate method
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboModel *model = [_arrData objectAtIndex:indexPath.section];
    float h= [TrendsView getWeiboViewHeight:model isRepost:NO isDetail:NO];
    return h+70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_arrData.count == 0) {
        return;
    }
    WeiboModel *model = [_arrData objectAtIndex:indexPath.section];
    DetailVC *dvc = [[DetailVC alloc]init];
    dvc.model = model;
    [self.navigationController pushViewController:dvc animated:YES];
}

//里面有收藏，删除。。
- (void)clickArrow:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
   
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:currentTouchPosition];
   
    if (indexPath != nil) {
        if (_popupList) {
            _popupList = nil;
            return;
        }
        _pathForPopList = indexPath;
         WeiboModel *model = [_arrData objectAtIndex:indexPath.section];
        TrendsCell *cell = (TrendsCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        PopupListComponentItem *item01 = nil;
        if (model.CollectFlag) {
            item01 = [[PopupListComponentItem alloc]initWithCaption:@"取消收藏" image:nil itemId:100 showCaption:YES];
        }else{
            item01 = [[PopupListComponentItem alloc]initWithCaption:@"收藏" image:nil itemId:100 showCaption:YES];
        }
        
        PopupListComponentItem *item02 = nil;
        if (model.IsMy) {
            item02 = [[PopupListComponentItem alloc]initWithCaption:@"删除" image:nil itemId:101 showCaption:YES];
        }
        
        
        
        _popArray = [NSMutableArray arrayWithObjects:item01,item02, nil];
   
   
           _popupList = [[PopupListComponent alloc]init];
      //  _popupList.allowedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionRight;
        _popupList.buttonSpacing = 3;
        _popupList.font = SysFont(12);
        _popupList.textPaddingHorizontal = 0;
        _popupList.textPaddingVertical = 0;
        [_popupList  showAnchoredTo:sender inView:cell withItems:_popArray withDelegate:self];
    }

}

#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_popupList) {
        _popupList = nil;
    }
}


#pragma mark - PopupListComponentDelegate

- (void) popupListcomponent:(PopupListComponent *)sender choseItemWithId:(int)itemId{
    NSLog(@"User chose item with id = %d", itemId);
    //消息分类（0全部 1默认 2图片 4文件）
    // If you stored a "userInfo" object in the popup, access it as:
    id anyObjectToPassToCallback = sender.userInfo;
    NSLog(@"popup userInfo = %@", anyObjectToPassToCallback);
    UIButton *btnSelect = (UIButton *)[self.view viewWithTag:itemId];
    NSLog(@"btnSelect %d  text %@",btnSelect.tag,btnSelect.titleLabel.text);
    
    WeiboModel *model = [_arrData objectAtIndex:_pathForPopList.section];
    UserModel *user = [[UserMgr sharedInstance] readFromDisk];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:user.Token forKey:@"token"];
    [dict setObject:model.msgInfo.ID forKey:@"messageID"];
//    [dict setObject:@"json" forKey:@"format"];
    // Free component object, since our action method recreates it each time:
    // 1  text 全部动态   2  text 文档    3  text 图片    4  text 投票
    if (itemId == 1 ) {
        _devideType = 0;
        if (_tableView.pullToRefreshView.state == 2) {
            [_tableView.pullToRefreshView stopAnimating];
        }
         [_tableView triggerPullToRefresh];
    }else if (itemId == 2){
        _devideType = 4;
        _SinceID = 0;
        if (_tableView.pullToRefreshView.state == 2) {
            [_tableView.pullToRefreshView stopAnimating];
        }
         [_tableView triggerPullToRefresh];
    }else if (itemId == 3){
        _devideType = 2;
        _SinceID = 0;
        if (_tableView.pullToRefreshView.state == 2) {
            [_tableView.pullToRefreshView stopAnimating];
        }
         [_tableView triggerPullToRefresh];
    }else if ( itemId == 4){
        if (_tableView.pullToRefreshView.state == 2) {
            [_tableView.pullToRefreshView stopAnimating];
        }
        [_tableView triggerPullToRefresh];
        _devideType = 8;
        [_tableView triggerPullToRefresh];
    }else if (itemId == 100){
     //收藏或是取消收藏
        
        if (![JsDevice netOK])  return;
        //收藏
        if ([btnSelect.titleLabel.text isEqualToString:@"收藏"]) {
            [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
            [MMProgressHUD showWithStatus:@"请稍后..."];
            [jsHttpHandler JsHttpPostWithStrOfUrl:kCollectMsgUrl paraDict:dict completionBlock:^(id JSON) {
                if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                    model.CollectFlag = 1;
                  //  [self _showMBHUDWithTitle:@"收藏成功!" success:YES];
                    [MMProgressHUD dismissWithSuccess:@"收藏成功!"];
                    
                }else{
                    //[self _showMBHUDWithTitle:@"收藏失败!" success:NO];
                    [MMProgressHUD dismissWithError:@"收藏失败!"];
                }
            }];
        }else{
            //取消收藏
            
            [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
            [MMProgressHUD showWithStatus:@"请稍后..."];
            [jsHttpHandler JsHttpPostWithStrOfUrl:kUnCollectMsgUrl paraDict:dict completionBlock:^(id JSON) {
                if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                    model.CollectFlag = 0;
                  // [self _showMBHUDWithTitle:@"取消收藏成功!" success:YES];
                    [MMProgressHUD dismissWithSuccess:@"取消收藏成功!"];
                }else{
                   //[self _showMBHUDWithTitle:@"取消收藏失败!" success:NO];
                     [MMProgressHUD dismissWithError:@"取消收藏失败!"];
                }
            }];
        }
        
    }else if (itemId == 101){
    //删除该条记录
        if (![JsDevice netOK])  return;
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
        [MMProgressHUD showWithStatus:@"请稍后..."];
        [jsHttpHandler JsHttpPostWithStrOfUrl:kDeleteMsgUrl paraDict:dict completionBlock:^(id JSON) {
            if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
               // [self _showMBHUDWithTitle:@"删除成功！" success:YES];
                [MMProgressHUD dismissWithSuccess:@"删除成功！"];
                [_arrData removeObjectAtIndex:_pathForPopList.section];
                
                [_tableView deleteSections:[NSIndexSet indexSetWithIndex:_pathForPopList.section] withRowAnimation:UITableViewRowAnimationFade];
                
            }else{
               // [self _showMBHUDWithTitle:@"删除失败!" success:NO];
                [MMProgressHUD dismissWithError:@"删除失败!"];
            }
        }];
        
    }
    
   
   //  [self removeViewFromWindow];
    
    
    _popupList = nil;
}

- (void)_startShowHUDWithTitle:(NSString *)title{
    if (HUD) {
        [HUD hide:YES];
    }
    
}

- (void)_showMBHUDWithTitle:(NSString *)title success:(BOOL)isSuccess{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    if (isSuccess) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage JSenImageNamed:@"37x-Checkmark.png"]] ;
    }else{
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage JSenImageNamed:@"37fail-Checkmark.png"]] ;
    }
	
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.delegate = self;
	HUD.labelText =title;
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:0.8];
}

- (void) popupListcompoentDidCancel:(PopupListComponent *)sender{
    [self removeViewFromWindow];
        _popupList = nil;
}

-(void)removeViewFromWindow{
    //从window上移走添加的view
    NSArray *arr = [UIApplication sharedApplication].keyWindow.subviews;
    for (UIView *view in arr) {
        if (view.tag == POP_BGVIEW_TAG) {
            [view removeFromSuperview];
            break;
        }
    }

}

- (void)_removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)dealloc{
    [self _removeObserver];
}

#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
