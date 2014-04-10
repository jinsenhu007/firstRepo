//
//  AtUsersVC.m
//  huabo
//
//  Created by admin on 14-3-27.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "AtUsersVC.h"
#import "jsHttpHandler.h"
#import "Const.h"
#import "UserModel.h"
#import "UserMgr.h"
#import "MMProgressHUD.h"
#import "JsDevice.h"


@interface AtUsersVC ()

@end

@implementation AtUsersVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrData = [NSMutableArray array];
    _arrDataSource = [NSMutableArray array];
    [self _loadData];
   // [self showRightButton:@"选中(0)" target:self action:@selector(rightBarBtn:)];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithTitle:@"选中(0)" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtn)];
    self.navigationItem.rightBarButtonItem = btnItem;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)_loadData{
    if (![JsDevice netOK]) {
        return;
    }
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
  
    [MMProgressHUD showWithStatus:@"加载中..."];
    
    UserModel *m = [[UserMgr sharedInstance] readFromDisk];
    NSString *str = [NSString stringWithFormat:kAtUsersUrl,m.Token];
    
    [jsHttpHandler jsHttpDownloadWithStrOfUrl:str withCache:YES completionBlock:^(id JSON) {
        if (!JSON || [[JSON objectForKey:@"Total"] intValue] == 0) {
            NSLog(@"没有取到@的朋友，或者没有@的朋友");
            [MMProgressHUD dismissWithError:@"没有数据"];
            return ;
        }
        for (NSDictionary *dic  in [JSON objectForKey:@"Rows"]) {
            UserModel *model = [[UserModel alloc]init];
            model.ID = [[dic objectForKey:@"UserID"] integerValue];
            model.RealName = [dic objectForKey:@"RealName"];
            model.JobName = [dic objectForKey:@"JobName"];
            model.DepartmentName = [dic objectForKey:@"DepartmentName"];
            model.CompanyEmail = [dic objectForKey:@"CompanyEmail"];
            //jobNameShort ,DepartmentNameShort 没要
            model.HeadSculpture48 = [dic objectForKey:@"HeadSculpture48"];
            [_arrData addObject:model];
            
        }
      //  [_tableView reloadData];
        
        [self _dealWithArrData];
    }];
    [MMProgressHUD dismiss];
    [jsHttpHandler setCacheTime:1*60*60];
}

- (void)_dealWithArrData{
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (UserModel *model  in _arrData) {
        NSInteger sect = [theCollation sectionForObject:model collationStringSelector:@selector(RealName)];
        model.sectionNum = sect;
        
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrs = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArr = [NSMutableArray arrayWithCapacity:1];
        [sectionArrs addObject:sectionArr];
    }
    
    //向每个section中添加模型
    for (UserModel *m in _arrData) {
        [[sectionArrs objectAtIndex:m.sectionNum] addObject:m];
    }
    
    for (NSMutableArray *oneArr in sectionArrs) {
       // if (oneArr.count == 0  ) continue;
        
        NSArray *sortedSection = [theCollation sortedArrayFromArray:oneArr collationStringSelector:@selector(RealName)];
        [_arrDataSource addObject:sortedSection];
        
    }
   // NSLog(@"_arrDataSource count %d",_arrDataSource.count);
    [_tableView reloadData];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ( tableView == self.searchVC.searchResultsTableView  ) {
        return _arrFiltered.count;
    }
    return [[_arrDataSource objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.searchVC.searchResultsTableView) {
        return 1;
    }else{
        //return [self _arrDataSourceCount];
       // return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
        return [_arrDataSource count];
    }
}

- (NSInteger) _arrDataSourceCount{
    __block int count = 0;
    [_arrDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableArray *arr = (NSMutableArray *)obj;
        if (arr.count != 0) {
            count++;
        }
    }];
   // NSLog(@"count %d",count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.font = SysFont(14);
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = SysFont(12);
    }
//    if (![[_arrDataSource objectAtIndex:indexPath.section] count]) {
//        return cell;
//    }
    UserModel *model = nil;
    if (tableView == self.searchVC.searchResultsTableView) {
        model = [[_arrFiltered objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else{
        model = [[_arrDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = model.RealName;
   
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",model.DepartmentName,model.JobName];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(30.0, 0.0, 28, 28)];
	[button setBackgroundImage:[UIImage imageNamed:@"uncheckBox.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateSelected];
	[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    [button setSelected:model.rowSelected];
    
	cell.accessoryView = button;
	
	return cell;
    
}

//显示侧边的字母列表
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == self.searchVC.searchResultsTableView) {
        return nil;
    }else{
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}
//点击字母列表中字母跳到相应的section
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (tableView == self.searchVC.searchResultsTableView) {
        return 0;
    }else{
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchVC.searchBar.frame animated:YES];
            return -1;
        }else{
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.searchVC.searchResultsTableView) {
        return nil;
    }else{
        return [[_arrDataSource objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
//    if ([[_arrDataSource objectAtIndex:section] count] ) {
//        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
//    }else{
//        return nil;
//    }
  //  return [[_arrDataSource objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.searchVC.searchResultsTableView) {
        return 0;
    }else{
         CGFloat h = [[_arrDataSource objectAtIndex:section] count]  ? tableView.sectionHeaderHeight : 0;
        NSLog(@"sec %d h = %f",section,h);
        return h;
    }
    NSLog(@"section %d height %f",section,tableView.sectionHeaderHeight);
//    if ([[_arrDataSource objectAtIndex:section] count]) {
//        return tableView.sectionHeaderHeight;
//    }else{
//        return 0;
//    }
   
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    UserModel *m = nil;
    if (tableView == self.searchVC.searchResultsTableView) {
        m = [_arrFiltered objectAtIndex:indexPath.row];
    }else{
        m = [[_arrDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    BOOL checked = !m.rowSelected;
    m.rowSelected = checked;
    
    if (checked) _selectCount++;
    else _selectCount--;
    
    [self.navigationItem.rightBarButtonItem setTitle:[NSString stringWithFormat:@"完成(%d)",_selectCount]];
    [self.navigationItem.rightBarButtonItem setEnabled:(_selectCount > 0 ? YES : NO)];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)cell.accessoryView;
    [btn setSelected:checked];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchVC.searchResultsTableView) {
        [self tableView:self.searchVC.searchResultsTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
        [self.searchVC.searchResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [self.navigationItem.rightBarButtonItem setEnabled:(_selectCount > 0)];
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

//选择完成
- (void)rightBarBtn{
    if (_selectCount == 0) return;
    NSMutableArray *arrMu = [NSMutableArray new];
    for (NSArray *sec in _arrDataSource) {
        for (UserModel *model in sec) {
            if (model.rowSelected) {
                [arrMu addObject:model];
            }
        }
    }
    
    if (_block) {
        _block([arrMu copy]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
