//
//  DetailGrpVC.m
//  huabo
//
//  Created by admin on 14-4-14.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "DetailGrpVC.h"
#import "jsHttpHandler.h"
#import "Const.h"
#import "UserModel.h"
#import "UserMgr.h"
#import "DetailGrpCell.h"
#import "GroupModel.h"
#import "factory.h"
#import "JsDevice.h"
#import "AppDelegate.h"
#import "CreateGrpVC.h"

@interface DetailGrpVC ()

@end

@implementation DetailGrpVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrData = [NSMutableArray new];
    _relationSearchType = 4;
    
    [self showLeftButtonWithImageName:@"返回.png" target:self action:@selector(pressBack)];
     [self showRightButtonOfSureWithName:@"新建" target:self action:@selector(clickRightBtn)];
    self.navigationItem.titleView = self.titleBGView;
    self.nameLabel.text = @"全部群组";
    [self setExtraCellLineHidden:_tableView];
    
    
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self _prepareLoadData];
}

- (void)_prepareLoadData{
    UserModel *m = [[UserMgr sharedInstance] readFromDisk];
    _strOfUrl = [NSString stringWithFormat:kGroupUrl,_relationSearchType,m.Token];
    
    [self _loadData];
}

- (void)_loadData{
    
    if (![JsDevice netOK]) {
        return;
    }
    
    [jsHttpHandler jsHttpDownloadWithStrOfUrl:_strOfUrl withCache:YES completionBlock:^(id JSON) {
        if (!JSON) {
            return ;
        }
     
        NSArray *arrRows = [JSON objectForKey:@"Rows"];
        if ([arrRows isKindOfClass:[NSNull class]]) {
            //提示无群组。。。。。。
            return;
        }
           [_arrData removeAllObjects];
        if (arrRows.count) {
            //jiexi
            for (NSDictionary *dict in arrRows) {
                DetailGrpModel *m = [[DetailGrpModel alloc]init];
                m.GroupID = [dict objectForKey:@"GroupID"];
                m.GroupHeadSculpture24 = [dict objectForKey:@"GroupHeadSculpture24"];
                m.GroupName = [dict objectForKey:@"GroupName"];
                m.GroupType = [[dict objectForKey:@"GroupType"] intValue];
                m.MemberCount = [dict objectForKey:@"MemberCount"];
                m.MessageCount = [dict objectForKey:@"MessageCount"];
                m.CreaterID = [dict objectForKey:@"CreaterID"];
                m.CreaterName = [dict objectForKey:@"CreaterName"];
                m.SubTimeStr = [dict objectForKey:@"SubTimeStr"];
                m.GroupStatus = [[dict objectForKey:@"GroupStatus"] intValue];
                m.IsJoined = [[dict objectForKey:@"IsJoined"] intValue];
                
                
                [_arrData addObject:m];
            }
        }
        
        [_tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arrData.count) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    DetailGrpCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailGrpCell" owner:self options:nil]lastObject];
    }
    if (!_arrData.count) {
        return cell;
    }
    DetailGrpModel *m = [_arrData objectAtIndex:indexPath.row];
    cell.model = m;
    
    UserModel *user = [[UserMgr sharedInstance] readFromDisk];
    NSString *s = nil;
    if (m.IsJoined) {
        s = @"退出";
        if ([m.CreaterID integerValue] == user.ID) {
            s = @"解散";
        }
    }else{
        s = @"加入";
    }
    
    UIButton *btn = [factory createButtonFrame:CGRectMake(0, 0, 40, 30) Title:s Target:self Action:@selector(clickBtn:) Tag:0];
    btn.titleLabel.textColor = [UIColor colorWithRed:0.000 green:0.800 blue:0.800 alpha:1.000];
    cell.accessoryView = btn;
    return cell;
    
}

- (void)clickBtn:(UIButton *)sender{
    CGPoint btnPoint = [sender convertPoint:sender.bounds.origin toView:self.tableView];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:btnPoint];
    DetailGrpModel *m = [_arrData objectAtIndex:path.row];
    UserModel *user = [[UserMgr sharedInstance] readFromDisk];
    
    NSString *str = nil;
    if ([sender.titleLabel.text isEqualToString:@"加入"]) {
        
        if (m.GroupType == 1 || m.GroupType == 2) {
            str = [NSString stringWithFormat:kJoinPrivateGrp,m.GroupID,user.Token];
            [jsHttpHandler jsHttpDownloadWithStrOfUrl:str withCache:NO completionBlock:^(id JSON) {
                if (!JSON) {
                    return ;
                }
                if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                    //申请成功
                    
                }else{
                    
                }
            }];
        }else if (m.GroupType == 4){
            str = [NSString stringWithFormat:kJoinPublicGrp,m.GroupID,user.Token];
//            [self loadData:str btn:sender  model:m];
            [jsHttpHandler jsHttpDownloadWithStrOfUrl:str withCache:NO completionBlock:^(id JSON) {
                if (!JSON) {
                    return ;
                }
                if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                    m.IsJoined = 1;
                    [_tableView reloadData];
                }

            }];
        }
        
    }else if ([sender.titleLabel.text isEqualToString:@"退出"]){
        str = [NSString stringWithFormat:kQuitGrp,m.GroupID,user.Token];
      //  [self loadData:str btn:sender  model:m];
        [jsHttpHandler jsHttpDownloadWithStrOfUrl:str withCache:NO completionBlock:^(id JSON) {
            if (!JSON) {
                return ;
            }
            if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                m.IsJoined = 0;
                [_tableView reloadData];
            }
            
        }];
        
    }else if([sender.titleLabel.text isEqualToString:@"解散"]){
        str = [NSString stringWithFormat:kDisperseGrp,m.GroupID,user.Token];
        //[self loadData:str btn:sender  model:m];
        [jsHttpHandler jsHttpDownloadWithStrOfUrl:str withCache:NO completionBlock:^(id JSON) {
            if (!JSON) {
                return ;
            }
            if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                [_arrData removeObjectAtIndex:path.row];
                [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
              //  [_tableView reloadData];
            }

        }];
    }
}

//- (void)loadData:(NSString *)str btn:(UIButton *)sender  model:(DetailGrpModel*)m{
//    if (![JsDevice netOK]) {
//        return;
//    }
//    [jsHttpHandler jsHttpDownloadWithStrOfUrl:str withCache:NO completionBlock:^(id JSON) {
//        if (!JSON) {
//            return ;
//        }
//        if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
//            m.IsJoined = 1;
//        }else{
//            
//        }
//    }];
//}

- (void)pressBack{
    if (_popupList) {
        _popupList = nil;
    }
    if (_popupBGView) {
        [_popupBGView removeFromSuperview];
        _popupBGView = nil;
    }

    [self.navigationController  popViewControllerAnimated:YES];
}

- (IBAction)titleBtnAction:(UIButton *)sender {
    if (_popupList) {
        
        [UIView animateWithDuration:0.3f animations:^{
            self.arrowImage.transform = CGAffineTransformIdentity;
        }];
        _popupList = nil;
        if (_popupBGView) {
            [_popupBGView removeFromSuperview];
            _popupBGView = nil;
        }
        
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        CGAffineTransform transfrom = CGAffineTransformMakeRotation(M_PI);
        self.arrowImage.transform = transfrom;
    }];
    PopupListComponentItem *itemOne = [[PopupListComponentItem alloc]initWithCaption:@"全部群组" image:Nil itemId:1 showCaption:YES];
    PopupListComponentItem *itemTwo = [[PopupListComponentItem alloc]initWithCaption:@"我创建的" image:Nil itemId:2 showCaption:YES];
    PopupListComponentItem *itemThree = [[PopupListComponentItem alloc]initWithCaption:@"我加入的" image:Nil itemId:3 showCaption:YES];
    
    _popArray = [NSMutableArray arrayWithObjects:itemOne,itemTwo,itemThree, nil];
    
    _popupList = [[PopupListComponent alloc]init];
    _popupList.font = [UIFont systemFontOfSize:13];
    _popupList.buttonSpacing = 3;
    _popupList.textPaddingHorizontal = 4;
    _popupList.textPaddingVertical = 3;
    [_popupList showAnchoredTo:self.navigationItem.titleView inView:[self _popupBGView] withItems:_popArray withDelegate:self];

}

- (UIView *)_popupBGView{
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    UIWindow *win = del.window;
    if (!_popupBGView) {
        _popupBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, win.frame.size.width, win.frame.size.height)];
        [win addSubview:_popupBGView];
    }
    return _popupBGView;
}

#pragma mark - PopupListComponent Delegate
- (void) popupListcomponent:(PopupListComponent *)sender choseItemWithId:(int)itemId{
    //UIButton *btnSelect = (UIButton *)[self.view viewWithTag:itemId];
    //   NSLog(@"subviews count %d",self.view.subviews.count);
    
    if (itemId == 1) {
        //回复我的
        if (![self.nameLabel.text isEqualToString:@"全部群组"]) {
            self.nameLabel.text = @"全部群组";
            _relationSearchType = 4;
            [self _prepareLoadData];
        }
        
    }else if (itemId == 2){
        //我的回复
        if (![self.nameLabel.text isEqualToString:@"我创建的"]) {
            self.nameLabel.text = @"我创建的";
            _relationSearchType = 2;
            
            [self _prepareLoadData];
        }
        
    }else if (itemId == 3){
        //@我的
        if (![self.nameLabel.text isEqualToString:@"我加入的"]) {
            self.nameLabel.text = @"我加入的";
            _relationSearchType = 1;
            [self _prepareLoadData];
        }
        
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.arrowImage.transform = CGAffineTransformIdentity;
    }];
    _popupList = nil;
    [_popupBGView removeFromSuperview];
    _popupBGView = nil;
}
- (void) popupListcompoentDidCancel:(PopupListComponent *)sender{
    if (_popupList) {
        [UIView animateWithDuration:0.3f animations:^{
            self.arrowImage.transform = CGAffineTransformIdentity;
        }];
        _popupList = nil;
    }
    
    if (_popupBGView) {
        [_popupBGView removeFromSuperview];
        _popupBGView = nil;
    }
    
}

#pragma mark - Scroll View Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_popupList) {
        _popupList = nil;
    }
    if (_popupBGView) {
        [_popupBGView removeFromSuperview];
        _popupBGView = nil;
    }
}

#pragma mark - 
- (void)clickRightBtn{
    CreateGrpVC *cvc = [[CreateGrpVC alloc ]init];
    [self.navigationController pushViewController:cvc animated:YES];
}

@end
