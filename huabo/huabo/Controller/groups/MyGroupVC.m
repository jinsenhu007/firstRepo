//
//  MyGroupVC.m
//  huabo
//
//  Created by admin on 14-3-24.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "MyGroupVC.h"
#import "GroupCell.h"
#import "UserModel.h"
#import "UserMgr.h"
#import "jsHttpHandler.h"
#import "GroupModel.h"
#import "JsDevice.h"
#import "MMProgressHUD.h"
#import "UIImage+imageNamed_JSen.h"

@interface MyGroupVC ()

@end

@implementation MyGroupVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrData = [NSMutableArray array];
    [self showLeftButtonWithImageName:@"返回.png" target:self action:@selector(pressBack)];
    [self _loadData];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickDone)];
    self.navigationItem.rightBarButtonItem = btnItem;
    [btnItem setEnabled:NO];
}

- (void)_loadData{
    if (![JsDevice netOK]) {
        return;
    }
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:@"加载中..."];
    UserModel *model = [[UserMgr sharedInstance] readFromDisk];
    NSString *str = [NSString stringWithFormat:kGroupsUrl,model.Token];
    [jsHttpHandler jsHttpDownloadWithStrOfUrl:str withCache:YES completionBlock:^(id JSON) {
        if (!JSON) {
            NSLog(@"没有返回数据");
            [MMProgressHUD dismissWithError:@"没有返回数据"];
            return ;
            
        }
        int total = [[JSON objectForKey:@"Total"] intValue];
        if (!total) {
            NSLog(@"无群组");
            [MMProgressHUD dismissWithError:@"无群组"];
            return;
        }
        [_arrData removeAllObjects];
        
        [self _createDefaultGroup];
        
        for ( NSDictionary *dict in [JSON objectForKey:@"Rows"]) {
            GroupModel *gm = [[GroupModel alloc]init];
            gm.ID = [dict objectForKey:@"ID"];
            gm.GroupName = [dict objectForKey:@"GroupName"];
            gm.GroupType = [[dict objectForKey:@"GroupType"] integerValue];
            gm.GroupNameShort = [dict objectForKey:@"GroupNameShort"];
            [_arrData addObject:gm];
        }
        [self.tableView reloadData];
        [MMProgressHUD dismiss];
    }];
    [jsHttpHandler setCacheTime:5*60];//cache时间，待定
}
//创建默认group
- (void)_createDefaultGroup{
    UserModel *model = [[UserMgr sharedInstance] readFromDisk];
    //如果当前用户是网主或网络管理员
    if (model.UserNetworkRole == 1 || model.UserNetworkRole == 2) {
        GroupModel *g = [[GroupModel alloc]init];
        g.GroupName = @"所有人";
        g.GroupNameShort = @"所有人";
        [_arrData addObject:g];
    }
    
    GroupModel *one = [[GroupModel alloc]init];
    one.GroupName = @"所有粉丝";
    one.GroupNameShort = @"所有粉丝";
    [_arrData addObject:one];
    
    GroupModel *myself = [[GroupModel alloc]init];
    myself.GroupName = @"仅自己";
    myself.GroupNameShort = @"仅自己";
    [_arrData addObject:myself];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_arrData.count) {
        return 10;
    }
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GroupCell" owner:self options:nil]lastObject];
    }
    if (!_arrData.count) {
        return cell;
    }
    
    GroupModel *model = [_arrData objectAtIndex:indexPath.row];
    cell.gModel = model;
    
  UIButton  *button =(UIButton *) [cell.contentView viewWithTag:101];
	[button setBackgroundImage:[UIImage JSenImageNamed:@"uncheckBox.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage JSenImageNamed:@"checkBox.png"] forState:UIControlStateSelected];
	[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    [button setSelected:model.rowSelected];
    
	cell.accessoryView = button;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    GroupModel *model = [_arrData objectAtIndex:indexPath.row];
    model.rowSelected = !model.rowSelected;
    if (model.rowSelected) {
        _selectedCount++;
    }else{
        _selectedCount--;
    }
    
    GroupCell *cell = (GroupCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)cell.accessoryView;
    [btn setSelected:model.rowSelected];
    [self.navigationItem.rightBarButtonItem setEnabled:(_selectedCount > 0)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - button action
- (void)checkButtonTapped:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil) {
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
    
}

- (void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickDone{
    if (_selectedCount == 0) return;
    
    NSMutableArray *arr = [NSMutableArray new];
    for (GroupModel *g in _arrData) {
        if (g.rowSelected) {
            [arr addObject:g];
        }
    }
    if (_block) {
        _block([arr copy]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
