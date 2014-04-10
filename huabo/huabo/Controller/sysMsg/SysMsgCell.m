//
//  SysMsgCell.m
//  huabo
//
//  Created by admin on 14-4-10.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "SysMsgCell.h"
#import "HtmlString.h"
#import "SingleTrendVC.h"
#import "DDMenuController.h"
#import "JsTabBarViewController.h"
#import "SysMsgModel.h"
#import "AppDelegate.h"

#define kMsgWidth 280

@implementation SysMsgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    _content = [[RCLabel alloc]initWithFrame:CGRectZero];
    _content.font = [UIFont systemFontOfSize:13];
    _content.delegate = self;
    [self.contentView addSubview:_content];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSString *str = [HtmlString transformString:_model.MessageContent];
    RCLabelComponentsStructure *ds = [RCLabel extractTextStyle:str];
    _content.componentsAndPlainText = ds;
    
    _content.frame = CGRectMake(5, 10,kMsgWidth , 0);
    CGSize s = [_content optimumSize:YES];
    _content.frame = CGRectMake(5, 10, kMsgWidth, s.height);
}

+(CGFloat )getHeightWithModel:(SysMsgModel*)model{
    float h = 0;
    NSString *str = [HtmlString transformString:model.MessageContent];
    
    RCLabel *rc = [[RCLabel alloc]initWithFrame:CGRectMake(5, 10, kMsgWidth, 0)];
    RCLabelComponentsStructure *ds = [RCLabel extractTextStyle:str];
    rc.componentsAndPlainText = ds;
    
    CGSize s = [rc optimumSize:YES];
    
    h += s.height;
    return h + 20;
}

- (void)RCLabel:(id)RCLabel didSelectLinkWithURL:(NSString*)url{
    NSLog(@"url %@",url);
    //点击动态时 ，接口包含 “detail” 字串,,待定。。。
    NSRange range = [url rangeOfString:@"detail" options:NSCaseInsensitiveSearch|NSBackwardsSearch];
    if (range.length) {
        UIViewController *vc = [self _getMainVC];
        SingleTrendVC *st = [[SingleTrendVC alloc]init];
        st.strOfUrl = url;
        [vc.navigationController pushViewController:st animated:YES];
    }
}

- (UIViewController *)_getMainVC{
    AppDelegate *del =  [[UIApplication sharedApplication] delegate];
    UIWindow *win = del.window;
    DDMenuController *dd = (DDMenuController *)win.rootViewController;
    JsTabBarViewController *js = (JsTabBarViewController *)dd.rootViewController;
    UINavigationController  *vc = (UINavigationController*)js.selectedViewController;
    return vc.topViewController;
}
@end
