//
//  TrendsView.m
//  huabo
//
//  Created by admin on 14-3-10.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "TrendsView.h"
#import "UIViewExt.h"
#import "HtmlString.h"
#import "UIImage+imageNamed_JSen.h"
#import "UIImageView+WebCache.h"
#import "PNChart.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "PersonalVC.h"



#define LIST_FONT 14.0f             //列表中文本字体
#define LIST_REPOST_FONT 13.0f      //列表中转发的文本字体
#define DETAIL_FONT 15.0f           //详情中的文本字体
#define DETAIL_REPOST_FONT 14.0f    //详情中的转发的文本字体

#define kWeibo_Width (kScreenWidth-2*8-50)   //微博在列表中的宽度    254
#define kWeibo_width_Detail kScreenWidth-2*8-30-20 //转发的微博宽度

#define kImage_Width 75
#define kImage_Height 70

#define kDiffItemsGap 6     //不同项目之间的空隙

#define kAppendSpace 12

#define kBarChartHeight 150


@implementation TrendsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createUI];
        
    }
    return self;
}

- (void)_createUI{
    _textLabel = [[RCLabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 20)];
    _textLabel.delegate = self;
    _textLabel.sizeDelegate = self;
    //[_textLabel setFont:SysFont(LIST_FONT)];
     float font = [TrendsView getFontSize:self.isDetail isRepost:self.isTransfer];
    [_textLabel setFont:SysFont(font)];
    _textLabel.lineSpacing = 2;
    _textLabel.textColor = [UIColor colorWithRed:33.0/255 green:33.0/255 blue:33.0/255 alpha:1];
    [self addSubview:_textLabel];
    
    
    //转发的微博背景图
    _repostBGView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWeibo_Width, 10)];
    _repostBGView.image = [UIImage JSenImageNamed:@"timeline_retweet_background.png"];
    UIImage *image = [_repostBGView.image stretchableImageWithLeftCapWidth:25 topCapHeight:10];
    _repostBGView.image = image;
    _repostBGView.backgroundColor = [UIColor clearColor];
   [self insertSubview:_repostBGView atIndex:0];
//    
 
    
}

- (void)setModel:(WeiboModel *)model
{
    _model = model;
    NSString *str = [HtmlString transformString:model.msgInfo.Content];
   // NSLog(@"str %@",str);
    RCLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:str];
    
    
    _textLabel.componentsAndPlainText = componentsDS;
    float font = [TrendsView getFontSize:self.isDetail isRepost:self.isTransfer];
    //NSLog(@"font %f",font);
   
    _textLabel.font = SysFont(font);
    CGSize optimalSize = [_textLabel optimumSize:YES];
    _textLabel.height = optimalSize.height;
  
    NSLog(@"size %f %f  %@",optimalSize.width,optimalSize.height,_textLabel.componentsAndPlainText);
    
    //图片75*70
    float y = _textLabel.bottom+kDiffItemsGap;
    
    if (model.arrAttachments) {
        //文档附件只能有一个
        if (model.arrAttachments.count == 1 && [[model.arrAttachments objectAtIndex:0] Type] == 1) {
            //如果是文档附件
             AttachmentInfo *info = [model.arrAttachments objectAtIndex:0];
            //下面这样做为了解决复用问题（性能欠佳）
            [self _removeClickImageViewWithSuperView:self];
              iViewDocs = [[ClickableUIImageView alloc]initWithFrame:CGRectMake(5, y, kImage_Width, kImage_Height)];
                 [self addSubview:iViewDocs];
                iViewDocs.hidden = NO;
               iViewDocs.image = [UIImage JSenImageNamed:@"weibolist_pic.png"];
            
            
        }
        if ([[model.arrAttachments objectAtIndex:0] Type] == 2) {
            //下面这样做为了解决复用问题（性能欠佳）
             [self _removeClickImageViewWithSuperView:self];
        
        for (int i=0; i<model.arrAttachments.count; i++) {
            CGRect rect = CGRectMake(i%3*(kImage_Width+kDiffItemsGap)+5,y+(i/3)*(kImage_Height+kDiffItemsGap), kImage_Width, kImage_Height);
            ClickableUIImageView *iView = [[ClickableUIImageView alloc]initWithFrame:rect];
            AttachmentInfo *info = [model.arrAttachments objectAtIndex:i];
            [iView setImageWithURL:[NSURL URLWithString:info.ImageSmallPath] placeholderImage:[UIImage JSenImageNamed:@"weibolist_pic.png"]];
            [self addSubview:iView];
        }
        }
    }else{
       
        
        //除掉所有的图片内容
        [self _removeClickImageViewWithSuperView:self];
    }
    
    if (model.arrAttachments.count >= 1 && model.arrAttachments.count <= 3) {
        y += kImage_Height+kDiffItemsGap;
    }else if (model.arrAttachments.count > 3){
        y += kImage_Height * 2 +kDiffItemsGap;
    }
    
    //有投票
    if (model.voteInfo) {
        NSMutableArray *arrOptName = [NSMutableArray array];
        NSMutableArray *arrOptPct = [NSMutableArray array];
        for (Options *opt in model.voteInfo.arrOptions) {
            [arrOptName addObject:opt.OptionName];
            [arrOptPct addObject:[opt.Percentage stringValue]];
            
        }
        [self _removePNBarChartWithSuperView:self];
        PNChart * barChart = [[PNChart alloc] initWithFrame:CGRectMake(0, y, self.width, kBarChartHeight)];
        barChart.backgroundColor = [UIColor clearColor];
        barChart.type = PNBarType;
        [barChart setXLabels:arrOptName];
        [barChart setYValues:arrOptPct];
        [barChart strokeChart];
        [self addSubview:barChart];
        barChart.hidden = NO;
        y += kBarChartHeight;
        
    }else{

        [self _removePNBarChartWithSuperView:self];
    }
    
    //有被转发的微博
    if (model.transInfo) {
        
        if (_repostView == nil) {
            //解决的_repostView的复用问题/*O(∩_∩)O哈哈~*/ 这样只会创建一个_repostView，就不会有复用问题了
             _repostView = [[TrendsView alloc]initWithFrame:CGRectMake(0, y,self.width , 10)];
           
        }
    
        _repostView.isTransfer = YES;
        _repostView.isDetail = NO;
        _repostView.frame = CGRectMake(0, y, self.width, 10);
        _repostView.backgroundColor = [UIColor clearColor];
        
        //_repostView.hidden = NO;
        _repostBGView.hidden = NO;
        [self addSubview:_repostView];
        
        _repostView.model = model.transInfo.tModel;
        float reHeight = [TrendsView getWeiboViewHeight:model.transInfo.tModel isRepost:_repostView.isTransfer isDetail:_repostView.isDetail];
        _repostView.height = reHeight + kAppendSpace;
        [_repostView insertSubview:_repostBGView atIndex:0];
         _repostBGView.frame = CGRectMake(0,-5,_repostView.width, _repostView.height);
        //NSLog(@"bgView %f %f %f %f ",_repostBGView.left,_repostBGView.top,_repostBGView.width,_repostBGView.height);
    
    }else{
        _repostBGView.hidden = YES;
       
        [self _removeTrendsViewWithSuperView:self];
    }
 

}


+ (CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel isRepost:(BOOL)isRepost isDetail:(BOOL)isDetail{
    float height = 0;
    //------------------------微博文字内容-----------------------------
    RCLabel *textLabel = [[RCLabel alloc]initWithFrame:CGRectZero];
    float fontSize = [TrendsView getFontSize: isDetail isRepost:isRepost];
    textLabel.font = SysFont(fontSize);
    if (isDetail) {
        textLabel.width = kWeibo_width_Detail;
    }else{
        textLabel.width = kWeibo_Width;
    }
   NSString *str = nil;
    if (isRepost) {
        textLabel.width -= 20;
        str =[NSString stringWithFormat:@"%@:%@",weiboModel.transInfo.tModel.UserRealName,weiboModel.msgInfo.Content];
       // weiboModel.msgInfo.Content = str;
  
    }else{
        str = weiboModel.msgInfo.Content;
    }
    RCLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:str];
    textLabel.componentsAndPlainText = componentsDS;

    CGSize optimalSize = [textLabel optimumSize:YES];
    height += optimalSize.height;
    
    //图片高度分为3个，6个图片
    if (weiboModel.arrAttachments.count > 0 && weiboModel.arrAttachments.count <= 3) {
        height += kImage_Height+kDiffItemsGap+5;
    }else if (weiboModel.arrAttachments.count > 3){
        height += kImage_Height * 2+kDiffItemsGap * 2+5;
    }
    
    //投票高度
    if (weiboModel.voteInfo) {
        height += kBarChartHeight;
    }
    
    //被转发的微博高度
    if (weiboModel.transInfo != nil) {
        float h = [TrendsView getWeiboViewHeight:weiboModel.transInfo.tModel isRepost:YES isDetail:isDetail];
       // NSLog(@"h = %f",h);
        height += h ;
    }
    
    return height;
}

+ (float)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost
{
  //  float fontSize = 14.0f;
    
    if (!isDetail && !isRepost) {
        return LIST_FONT;
    }else if (!isDetail && isRepost){
        return LIST_REPOST_FONT;
    }else if (isDetail && !isRepost){
        return DETAIL_FONT;
    }else if (isDetail && isRepost){
        return DETAIL_REPOST_FONT;
    }
    
    return LIST_FONT;
}

- (void)_removeClickImageViewWithSuperView:(UIView *)sView{
    if (sView.subviews !=0) {
        for (UIView *view in sView.subviews) {
            if ([view isKindOfClass:[ClickableUIImageView class]]) {
                ClickableUIImageView *iV = (ClickableUIImageView*)view;
                iV.image = nil;
                [view removeFromSuperview];
               
            }else{
                [self _removeClickImageViewWithSuperView:view];
            }
        }

    }
}

- (void)_removeTrendsViewWithSuperView:(UIView *)sView{
    if (sView.subviews != 0) {
        for (UIView *view in sView.subviews) {
            if ([view isKindOfClass:[TrendsView class]])
            {
                [view removeFromSuperview];
            }else if([view isKindOfClass:[PNChart class]] || [view isKindOfClass:[PNBarChart class]])
            {
                continue;
            }
            else
            {
                [self _removeTrendsViewWithSuperView:view];
            }
        }
    }
}

- (void)_removePNBarChartWithSuperView:(UIView*)sView{
    if (sView.subviews !=0) {
        for (UIView *view in sView.subviews) {
            if ([view isKindOfClass:[PNChart class]] || [view isKindOfClass:[PNBarChart class]]) {
                [view removeFromSuperview];
                
            }else{
                [self _removePNBarChartWithSuperView:view];
            }
        }
        
    }
}
- (void)RCLabel:(id)RCLabel didSelectLinkWithURL:(NSString*)url{
    NSLog(@"%@",url);
    if ([url integerValue] != 0) {
        UIViewController *vc = [self _getMianController];
        PersonalVC *pvc = [[PersonalVC alloc]init];
        pvc.userId = [url integerValue];
        [vc.navigationController pushViewController:pvc animated:YES];
    }
    
}

- (void)RCLabel:(id)RCLabel didChangedSize:(CGSize)size{
    
}

- (UIViewController *)_getMianController{
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *del = app.delegate;
    UIWindow *win = del.window;
    DDMenuController *vc =(DDMenuController*) win.rootViewController;
    UITabBarController *tab = (UITabBarController*)vc.rootViewController;
    //  UINavigationController *nav = [tab.viewControllers objectAtIndex:0];
    UINavigationController *nav = [tab.viewControllers objectAtIndex:tab.selectedIndex];
    return [nav topViewController];
}
@end
