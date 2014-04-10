//
//  AllViewController.h
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"
#import "PopupListComponent.h"
#import "MBProgressHUD.h"

@interface TrendsVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,PopupListComponentDelegate,MBProgressHUDDelegate>
{
    
    UIButton *btn;
    PopupListComponent *_popupList;
    NSArray *_arrMenu;
    NSArray *_popArray;
    
    NSString *_strOfUrl;
    NSInteger _devideType;  //消息分类（0全部 1默认 2图片 4文件）
    NSInteger _maxID;       // 当前返回的数据中的最小数据编号，此参数供查询比之发表早的消息动态,
    NSInteger _SinceID;     //最新的动态
    
    BOOL _loadDataSource ; //标记是否正在加载最新数据
    BOOL _needCache;    //标记是否需要缓存
    
    NSIndexPath *_pathForPopList; //
    
    MBProgressHUD *HUD;
}


@property (retain,nonatomic) UITableView *tableView;
@property (retain,nonatomic) NSMutableArray *arrData;


@end
