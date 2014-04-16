//
//  PhotoBrowserVC.h
//  huabo
//
//  Created by admin on 14-4-16.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"

@interface PhotoBrowserVC : BaseViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)pageControlClicked:(UIPageControl *)sender;

@property (retain,nonatomic) NSArray *arrSource; //数据源
@property (assign,nonatomic) int currIndex;     // 选中的图片index，（从0开始）
@end
