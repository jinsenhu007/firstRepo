//
//  secFooter.h
//  huabo
//
//  Created by admin on 14-3-17.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
@class SecFooter;

@interface SecFooter : UIView
{
    UIView *_bgView;
    WeiboModel *_model;
    id _object;
    
    BOOL _isZan;//是否已赞
}

@property (strong, nonatomic) IBOutlet UIImageView *img01;
@property (strong, nonatomic) IBOutlet UIImageView *img02;
@property (strong, nonatomic) IBOutlet UIImageView *img03;
@property (strong, nonatomic) IBOutlet UILabel *label01;
@property (strong, nonatomic) IBOutlet UILabel *label02;
@property (strong, nonatomic) IBOutlet UILabel *label03;

@property (strong, nonatomic) IBOutlet UIButton *btnZF;
- (IBAction)zfAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnPL;
- (IBAction)plAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnZan;
- (IBAction)zanAction:(UIButton *)sender;


- (void)useModel:(WeiboModel*)model object:(id)obj;


@end
