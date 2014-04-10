//
//  faceViewController.m
//  MyWeiXin
//
//  Created by sensen on 14-1-1.
//  Copyright (c) 2014年 sensen. All rights reserved.
//

#import "FaceViewController.h"
#import "JsDevice.h"
#import "factory.h"



@interface FaceViewController ()

@end

@implementation FaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define faceCount [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"emotionImage.plist" ofType:nil]] count]

-(void)createUI{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2_03.png"]];
    [_scrollView setPagingEnabled:YES];
    _scrollView.delegate = self;
    _scrollView.contentSize  = CGSizeMake(kScreenWidth*(faceCount/24+2), 210) ;
    
    [self.view addSubview:_scrollView];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"emotionImage.plist" ofType:nil];
    NSDictionary *dic= [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSEnumerator *keys = [dic keyEnumerator];
    id keyInDic = nil;
    
    for (int i=0; i<[dic count]; i++) {
        keyInDic = [keys nextObject];
        NSString *str = [dic objectForKey:keyInDic];
        NSLog(@"str %@",str);
        CGRect rect = CGRectMake(i%8*40+(i/24*kScreenWidth), i/8*40+10-(i/24*40)*3, 50, 50);
        UIButton *btn = [factory createButtonFrame:rect Image:[UIImage imageNamed:str] Target:self Action:@selector(btnClick:) Tag:i+100];
        [_scrollView addSubview:btn];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    
    _pageControll = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _scrollView.frame.size.height-40, kScreenWidth, 40)];
    [_pageControll setNumberOfPages:faceCount/24+1];
    [_pageControll setCurrentPage:0];
    [_pageControll setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"2_03.png"]]];
    [_pageControll  setPageIndicatorTintColor:[UIColor whiteColor]];
    _pageControll.currentPageIndicatorTintColor = [UIColor redColor];
    
    [_pageControll addTarget:self action:@selector(pageControllChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControll];
	// Do any additional setup after loading the view.
}

-(void)pageControllChange{
    [UIView animateWithDuration:0.3f animations:^{
        CGPoint offset = _scrollView.contentOffset;
        offset.x = kScreenWidth * _pageControll.currentPage;
        _scrollView.contentOffset = offset;
        
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.3f animations:^{
        CGPoint point = _scrollView.contentOffset;
        _pageControll.currentPage = point.x/kScreenWidth;
    }];
}

-(void)btnClick:(UIButton*)btn{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"emotionImage.plist" ofType:nil];
    NSDictionary *dic= [NSDictionary dictionaryWithContentsOfFile:path];
    NSEnumerator *enu = [dic keyEnumerator];
    
    NSArray *arr = [enu allObjects];
    NSString *oneKey = [arr objectAtIndex:btn.tag - 100];
    _block(oneKey);
    
}

-(void)handleSelectBlock:(clickFace)block{
    _block = block;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
