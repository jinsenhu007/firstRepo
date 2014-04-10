//
//  PsersonalVC.h
//  huabo
//
//  Created by admin on 14-3-4.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"
#import "UserModel.h"

@interface PersonalVC : BaseViewController
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *depart;
@property (strong, nonatomic) IBOutlet UILabel *job;
@property (strong, nonatomic) IBOutlet UILabel *level;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *company;
@property (strong, nonatomic) IBOutlet UILabel *telNum;
@property (strong, nonatomic) IBOutlet UILabel *jobNum;



@property (strong, nonatomic) IBOutlet UIButton *follow; //我得关注
- (IBAction)followAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *fans; //我的粉丝
- (IBAction)fansAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *myWeibo; //我的微博
- (IBAction)myWeiboAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *myCollect; //我的收藏
- (IBAction)myCollectionAction:(UIButton *)sender;




@property (retain,nonatomic) UserModel *uModel;
@property (assign,nonatomic) NSInteger userId;//点击cell中得@xxx传来userid
@end
