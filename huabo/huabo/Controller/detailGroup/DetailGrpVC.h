//
//  DetailGrpVC.h
//  huabo
//
//  Created by admin on 14-4-14.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"
#import "PopupListComponent.h"
@interface DetailGrpVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,PopupListComponentDelegate>
{
    int _relationSearchType;    //搜索类型（1我加入的，2我创建的，4所有群组)
    
    PopupListComponent *_popupList;
    NSMutableArray *_popArray;
     UIView *_popupBGView;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) NSMutableArray *arrData;

@property (retain,nonatomic) NSString *strOfUrl;
@property (strong, nonatomic) IBOutlet UIButton *titleBtn;
- (IBAction)titleBtnAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIView *titleBGView;
@end
