//
//  SingleTrendVC.h
//  huabo
//
//  Created by admin on 14-4-10.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"

@interface SingleTrendVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property (retain,nonatomic) NSMutableArray *arrData;

@property (retain,nonatomic) NSString *strOfUrl;
@end
