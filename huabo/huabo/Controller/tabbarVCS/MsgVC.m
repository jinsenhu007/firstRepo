//
//  AtMeViewController.m
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "MsgVC.h"
#import "MsgCell.h"
#import "clickableUIView.h"
#import "ReplyVC.h"
#import "AllGroupVC.h"
#import "SysMsgVC.h"
#import "DDMenuController.h"
#import "AppDelegate.h"
#import "JsTabBarViewController.h"
#import "UIViewExt.h"
@interface MsgVC ()

@end

@implementation MsgVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self showTitle:@"消息"];
    
    self.tableView.tableHeaderView = self.tHeaderBGView;
    _reply = (clickableUIView *)[self.tHeaderBGView viewWithTag:100];
    _group = (clickableUIView *)[self.tHeaderBGView viewWithTag:101];
    _sysMsg = (clickableUIView *)[self.tHeaderBGView viewWithTag:102];
    
    _atAndReplyView = (UIImageView*)[_reply viewWithTag:998];
    _sysMsgView = (UIImageView *)[_sysMsg viewWithTag:999];
    
    [_reply handleComplemetionBlock:^(clickableUIView *view1) {
        ReplyVC *rep = [[ReplyVC alloc]init];
        [self.navigationController pushViewController:rep animated:YES];
    }];
    
    [_group handleComplemetionBlock:^(clickableUIView *view2) {
        AllGroupVC *allgroup = [[AllGroupVC alloc]init];
        [self.navigationController pushViewController:allgroup animated:YES];
    }];
    
    [_sysMsg handleComplemetionBlock:^(clickableUIView *view3) {
        SysMsgVC *sys = [[SysMsgVC alloc]init];
        [self.navigationController pushViewController:sys animated:YES];
    }];
  
    
    AppDelegate  *del = [[UIApplication sharedApplication] delegate];
    UIWindow *win = del.window;
    DDMenuController *dd = (DDMenuController *)win.rootViewController;
    JsTabBarViewController *tab = (JsTabBarViewController *)dd.rootViewController;
    [tab addObserver:self forKeyPath:@"_atAndReplyCnt" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
	[tab addObserver:self forKeyPath:@"_sysMsgCnt" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"xxx"];
    
    NSInteger  atCnt = [[tab valueForKey:@"_atAndReplyCnt"] integerValue];
    NSInteger sysCnt = [[tab valueForKey:@"_sysMsgCnt"] integerValue];
    
 
    _atAndReplyLabel = [[UILabel alloc]init];
    _atAndReplyLabel.font = [UIFont systemFontOfSize:12];
    _atAndReplyLabel.textColor = [UIColor whiteColor];
    _atAndReplyLabel.text = [NSString stringWithFormat:@"%d",atCnt];
    _atAndReplyLabel.textAlignment = NSTextAlignmentCenter;
    _atAndReplyLabel.center = _atAndReplyView.center;
    _atAndReplyLabel.left = 3;
    _atAndReplyLabel.top = 1;
    [_atAndReplyLabel sizeToFit];
    [_atAndReplyView addSubview:_atAndReplyLabel];
    
    
    _sysMsgLabel = [[UILabel alloc]init];
    _sysMsgLabel.font = [UIFont systemFontOfSize:12];
    _sysMsgLabel.textColor = [UIColor whiteColor];
    _sysMsgLabel.text = [NSString stringWithFormat:@"%d",sysCnt];
    _sysMsgLabel.textAlignment = NSTextAlignmentCenter;
    _sysMsgLabel.center = _sysMsgView.center;
    _sysMsgLabel.left = 3;
    _sysMsgLabel.top = 1;
    [_sysMsgLabel sizeToFit];
    [_sysMsgView addSubview:_sysMsgLabel];
    
    if (atCnt) {
        _atAndReplyView.hidden = NO;
        _atAndReplyLabel.hidden = NO;
        if (atCnt >= 100) {
            atCnt = 99;
        }
        if (atCnt >= 10 ) {
             UIImage *image = [_atAndReplyView.image stretchableImageWithLeftCapWidth:7 topCapHeight:7];
            _atAndReplyView.image = image;
            //_atAndReplyLabel.text = [NSString stringWithFormat:@"99"];
            CGSize s = [_atAndReplyLabel.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(180, 15) lineBreakMode:NSLineBreakByTruncatingTail];
           _atAndReplyView.frame = CGRectMake(_atAndReplyView.left, _atAndReplyView.top, s.width+10, s.height);
        }
    }else{
        _atAndReplyView.hidden = YES;
        _atAndReplyLabel.hidden = YES;
    }
    
    if (sysCnt){
        _sysMsgView.hidden = NO;
        _sysMsgLabel.hidden = NO;
        if (sysCnt >= 10 ) {
            UIImage *image = [_sysMsgView.image stretchableImageWithLeftCapWidth:7 topCapHeight:7];
            _atAndReplyView.image = image;
            //_atAndReplyLabel.text = [NSString stringWithFormat:@"99"];
            CGSize s = [_sysMsgLabel.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(180, 15) lineBreakMode:NSLineBreakByTruncatingTail];
            _sysMsgView.width = s.width + 10;
        }

    }else{
        _sysMsgLabel.hidden = YES;
        _sysMsgView.hidden = YES;
    }
    
    [self setExtraCellLineHidden:self.tableView];
}

#pragma mark - KVO Delegate Method
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"keyPath %@",keyPath);
    NSLog(@"%@",change);
    

    if ([keyPath isEqualToString:@"_atAndReplyCnt"]) {
        int cnt = [[change objectForKey:@"new"] intValue];
        
        if (cnt) {
            _atAndReplyView.hidden = NO;
            _atAndReplyLabel.hidden = NO;
            _atAndReplyLabel.text = [NSString stringWithFormat:@"%d",cnt];
            if (cnt >= 10) {
                CGSize s = [_atAndReplyLabel.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(180, 15) lineBreakMode:NSLineBreakByTruncatingTail];
                _atAndReplyView.width = s.width+10;
            }else{
                _atAndReplyView.width = 15;
            }
           
        }else{
            _atAndReplyView.hidden = YES;
            _atAndReplyView.hidden = YES;
        }
    }else if([keyPath isEqualToString:@"_sysMsgCnt"]) {
        int cnt = [[change objectForKey:@"new"] intValue];
        if (cnt) {
            _sysMsgView.hidden = NO;
            _sysMsgLabel.hidden = NO;
            _sysMsgLabel.text = [NSString stringWithFormat:@"%d",cnt];
            if (cnt >= 10) {
                CGSize s = [_sysMsgLabel.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(180, 15) lineBreakMode:NSLineBreakByTruncatingTail];
                _sysMsgView.width = s.width+10;
            }else{
                _sysMsgView.width = 15;
            }
            
        }else{
            _sysMsgLabel.hidden = YES;
            _sysMsgView.hidden = YES;
        }
    }
}


#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arrData.count) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[MsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
