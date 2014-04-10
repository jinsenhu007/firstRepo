//
//  commSetVC.h
//  huabo
//
//  Created by admin on 14-3-4.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commSetVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *push;
- (IBAction)pushAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *clearCache;
- (IBAction)clearCacheAction:(UIButton *)sender;
@end
