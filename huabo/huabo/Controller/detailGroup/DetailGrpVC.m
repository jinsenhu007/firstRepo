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

@interface DetailGrpVC ()

@end

@implementation DetailGrpVC

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
    
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    DetailGrpCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailGrpCell" owner:self options:nil]lastObject];
    }
    DetailGrpModel *m = [_arrData objectAtIndex:indexPath.row];
    cell.model = m;
    return cell;
    
}


@end
