//
//  ContactorVC.m
//  huabo
//
//  Created by admin on 14-3-19.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "ContactorVC.h"
#import "SVPullToRefresh.h"
#import "jsHttpHandler.h"
#import "Const.h"
#import "UserMgr.h"
#import "MMProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIView+MakeAViewRoundCorner.h"
#import "PersonalVC.h"
//#import "SearchCoreManager.h"

#define kCellHeight 60

#define kHeadIcon 100
#define kNameLabel 101
#define keMailLabel 102

@interface ContactorVC ()

@end

@implementation ContactorVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
            }
    return self;
}

- (void)_loadFriends{
    UserModel *model = [[UserMgr sharedInstance] readFromDisk];
    NSString *strUrl = [NSString stringWithFormat:@"%@&token=%@&allFlag=%d",kContactorsUrl,model.Token,_allFlag];
    NSLog(@"ContactorsUrl %@",strUrl);
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:@"加载中..."];
    
    [jsHttpHandler jsHttpDownloadWithStrOfUrl:strUrl withCache:YES completionBlock:^(id JSON) {
        if ([[JSON objectForKey:@"Total"] intValue] == 0) {
            [MMProgressHUD dismissWithError:@"没有联系人"];
            return ;
        }
        
        //有好友
        NSArray *arrRows = [JSON objectForKey:@"Rows"];
        for (NSDictionary *dict in arrRows) {
            UserModel *model = [[UserModel alloc]init];
            model.CompanyEmail = [dict objectForKey:@"CompanyEmail"];
            model.DepartmentName = [dict objectForKey:@"DepartmentName"];
            model.HeadSculpture = [dict objectForKey:@"HeadSculpture"];
            model.HeadSculpture24 = [dict objectForKey:@"HeadSculpture24"];
            model.HeadSculpture48 = [dict objectForKey:@"HeadSculpture48"];
            model.Integral = [[dict objectForKey:@"Integral"] integerValue];
            model.IsFollowed = [[dict objectForKey:@"IsFollowed"] integerValue];
            model.IsMy = [[dict objectForKey:@"IsMy"] integerValue];
            model.JobName = [dict objectForKey:@"JobName"];
            model.Level = [[dict objectForKey:@"Level"] integerValue];
            model.LevelName = [dict objectForKey:@"LevelName"];
            model.QQ = [dict objectForKey:@"QQ"];
            model.TelPhone = [dict objectForKey:@"TelPhone"];
            model.ID = [[dict objectForKey:@"UserID"] integerValue];
            model.RealName = [dict objectForKey:@"UserRealName"];
            model.WorkPhone = [dict objectForKey:@"WorkPhone"];
            
            [_arrData addObject:model];
           // [self _addToSearchDataBase:model];
        }
        [_tView reloadData];
        [MMProgressHUD dismiss];
    }];
   // [jsHttpHandler setCacheTime:1*10*60];//10min
}

//- (void)_addToSearchDataBase:(UserModel*)m{
//    if (![m.RealName isEqualToString:@""] && ![m.TelPhone isEqualToString:@""]) {
//        NSMutableArray *phoneArray = [NSMutableArray array];
//        [phoneArray addObject:m.TelPhone];
//        [[SearchCoreManager share] AddContact:nil name:m.RealName phone:phoneArray];
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showTitle:@"联系人"];
    self.tView.delegate =self;
    self.tView.dataSource = self;
    /*
     token
     下面2个参数只提供其一
     allFlag
     followFlag
     */
    _allFlag = 1;
    _arrData = [NSMutableArray array];
    [self _loadFriends];

    
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchVC.searchResultsTableView) {
        return _searchData.count;
    }
    
    if (_arrData.count == 0) {
        return 10;
    }
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ContactorCell" owner:self options:nil]lastObject];
    }
    if (_arrData.count == 0) {
        return cell;
    }
    UserModel *model = nil;
    if (tableView == self.searchVC.searchResultsTableView) {
        model = [_searchData objectAtIndex:indexPath.row];
    }else{
        model = [_arrData objectAtIndex:indexPath.row];
    }
    
    UIImageView *iVew = (UIImageView *)[cell.contentView viewWithTag:kHeadIcon];
    [iVew setImageWithURL:[NSURL URLWithString:model.HeadSculpture48] placeholderImage:nil];
    [iVew setRoundedCornerWithRadius:5.0f];
    [(UILabel *)[cell.contentView viewWithTag:101] setText:model.RealName];
    [(UILabel *)[cell.contentView viewWithTag:102] setText:model.CompanyEmail];
    
    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_arrData.count && !_searchData.count) {
        return;
    }
    UserModel *model = nil;
    if(tableView == self.searchVC.searchResultsTableView )
    {
        model = [_searchData objectAtIndex:indexPath.row];
    
    }
    else
    {
       model = [_arrData objectAtIndex:indexPath.row];
        
    }
    
    PersonalVC *p = [[PersonalVC alloc]init];
    p.uModel = model;
    [self.navigationController pushViewController:p animated:YES];
    
}

#pragma mark - UISearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    if ([searchText isEqualToString:@""] && searchText.length == 0) return;
    
//    _searchData = [[NSMutableArray alloc]init];
    NSString *str = [NSString stringWithFormat:@"*%@*",searchText];
    //暂时名字搜索。。
    NSPredicate *predicateStr = [NSPredicate predicateWithFormat:@"%K LIKE[cd] %@",@"RealName",str];
    _nameArr =[NSMutableArray arrayWithArray: [_arrData filteredArrayUsingPredicate:predicateStr]];
    _searchData = _nameArr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
