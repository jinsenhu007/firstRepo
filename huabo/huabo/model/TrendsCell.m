//
//  AllCell.m
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "TrendsCell.h"
#import "factory.h"
#import "JsDevice.h"
#import "UIImage+imageNamed_JSen.h"
#import "UIImageView+WebCache.h"
#import "UIView+MakeAViewRoundCorner.h"
#import "PNChart.h"

//#define CELL_HEIGHT 200

#define TOP_GAP 6
#define LEFT_GAP 6
#define HEAD_IMAGE_WIDTH 35
#define HEAD_IMAGE_HEIGHT 35

#define kWeibo_Width (kScreenWidth-2*8-50)  //微博在列表中的宽度
#define kWeibo_width_Detail kScreenWidth-2*8-30-20 //转发的微博宽度

@implementation TrendsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self _createUI];
    }
    return self;
}

- (void)_createUI{
    _headView = [[ClickableUIImageView alloc]initWithFrame:CGRectMake(LEFT_GAP, TOP_GAP, HEAD_IMAGE_WIDTH, HEAD_IMAGE_HEIGHT)];
    _headView.backgroundColor = [UIColor blueColor];
    [_headView setRoundedCornerWithRadius:6.0];
    [self.contentView addSubview:_headView];
    
    _labelName = [[UILabel alloc]initWithFrame:CGRectMake(_headView.frame.origin.x+HEAD_IMAGE_WIDTH+5, TOP_GAP, 200, 15)];
    _labelName =[factory createLabelFrame:CGRectMake(_headView.frame.origin.x+HEAD_IMAGE_WIDTH+5, TOP_GAP, 200, 15) Text:@"IOS programing 你好"];
    [self.contentView addSubview:_labelName];
    
    _labelTime = [factory createLabelFrame:CGRectMake(_headView.frame.origin.x+HEAD_IMAGE_WIDTH+5,_headView.frame.origin.y+_headView.frame.size.height-16, 80, 15) Text:@"1分钟前"];
    _labelTime.font = SysFont(11);
    _labelTime.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_labelTime];
    
    _labelSource = [factory createLabelFrame:CGRectMake(_labelTime.frame.origin.x+_labelTime.frame.size.width+10, _labelTime.frame.origin.y, 150, 15) Text:@"来自：新浪微博"];
    _labelSource.backgroundColor = [UIColor clearColor];
    _labelSource.font = SysFont(11);
    [self.contentView addSubview:_labelSource];
    
    
    _trendsV = [[TrendsView alloc]initWithFrame:CGRectMake(35, 40, kWeibo_Width, 100)];
    _trendsV.backgroundColor = [UIColor clearColor];
    _trendsV.isDetail = NO;
    _trendsV.isTransfer = NO;
   
    [self.contentView addSubview:_trendsV];
    
//    //设置cell的选中背景颜色
//    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_GAP, 0, kScreenWidth-2*8, 0)];
//    selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage JSenImageNamed:@"statusdetail_cell_sepatator.png"]];
//    self.selectedBackgroundView = selectedBackgroundView;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor=[UIColor colorWithRed:251.0/255 green:249.0/255 blue:249.0/255 alpha:1.0];
    
}

- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    _weiboModel = weiboModel;
    [_headView setImageWithURL:[NSURL URLWithString:weiboModel.HeadSculpture48] placeholderImage:nil];
    _labelName.text = weiboModel.UserRealName;
    _labelTime.text = weiboModel.msgInfo.SubTimeStr;
    if (weiboModel.msgInfo.ComeFromType == 1) {
        _labelSource.text = @"来自:web网页";
    }else if (weiboModel.msgInfo.ComeFromType == 2){
        _labelSource.text = @"来自:android客户端";
    }else if (weiboModel.msgInfo.ComeFromType == 4){
        _labelSource.text = @"来自:iPhone客户端";
    }else if (weiboModel.msgInfo.ComeFromType == 8){
        _labelSource.text = @"来自:pc客户端";
    }
    
 
    
    [_trendsV setModel:weiboModel];

    float h = [TrendsView getWeiboViewHeight:weiboModel isRepost:NO isDetail:NO];
   // NSLog(@"float h = %f",h);
    _trendsV.frame = CGRectMake(35, 45,kWeibo_Width , h);
    
}



/*
 1：网页端；2：android手机端；4：Ios手机端；8：pc客户端）
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
