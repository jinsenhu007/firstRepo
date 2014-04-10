//
//  MyReplyCell.m
//  huabo
//
//  Created by admin on 14-4-8.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "MyReplyCell.h"
#import "ReplyModel.h"
#import "UserModel.h"
#import "UserMgr.h"
#import "UIImageView+WebCache.h"
#import "HtmlString.h"
#import "RegexKitLite.h"
#import "UIViewExt.h"

#define kOriginalMsgWidth 220
#define kTargetMsgWidth 250

#define kTargetFont 14
#define kSourceFont 12

@implementation MyReplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    UserModel *um = [[UserMgr sharedInstance]readFromDisk];
    
    _headIcon = (ClickableUIImageView *)[self.contentView viewWithTag:100];
    [_headIcon setImageWithURL:[NSURL URLWithString:um.HeadSculpture100] placeholderImage:nil];
    NSLog(@"head %@",um.HeadSculpture100);
    _labelName = (UILabel *)[self.contentView viewWithTag:101];
    _labelName.text = um.RealName;
    
    _subTime = (UILabel *)[self.contentView viewWithTag:102];
    
//    _toName = (UILabel *)[self.contentView viewWithTag:102];
//    _tailStr = (UILabel *)[self.contentView viewWithTag:103];
    
    _content = [[RCLabel alloc]initWithFrame:CGRectZero];
    _content.font = [UIFont systemFontOfSize:kTargetFont];
    _content.delegate =self;
    [self.contentView addSubview:_content];
    
    _sourceContent = [[RCLabel alloc]initWithFrame:CGRectZero];
    _sourceContent.font = [UIFont systemFontOfSize:kSourceFont];
    _sourceContent.delegate =self;
    [self.contentView addSubview:_sourceContent];
    
   oneLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    oneLabel.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:oneLabel];
//    [self.contentView layoutIfNeeded];
}

- (void )layoutSubviews{
    [super layoutSubviews];
    
   // _toName.text = _model.SourceUserName;
  //  [_toName sizeToFit];
    //_toName.backgroundColor = [UIColor blackColor];
    _subTime.text = _model.SubTimeStr;
    NSString *toName  = _model.SourceUserName;
    NSString *tailStr = nil;
    if ([_model.SourceMessageType intValue] == 1 || [_model.SourceMessageType intValue] == 2) {
        tailStr = @"的回复";
    }else{
        tailStr = @"的动态";
    }
   
    
  //  _tailStr.frame = CGRectMake(_toName.right+3, _toName.top, 80, _toName.height);
    
    NSString *strContent = [HtmlString transformString:_model.TargetMessageContent];
    RCLabelComponentsStructure *ds01 = [RCLabel extractTextStyle:strContent];
    _content.componentsAndPlainText = ds01;
    CGSize size01 = [_content optimumSize:YES];
    
    _content.frame = CGRectMake(68, 50, kTargetMsgWidth, size01.height);
    
    NSString *fianlStr = [NSString stringWithFormat:@"回复 %@ %@:",toName,tailStr];
    oneLabel.text = fianlStr;
   CGSize s = [oneLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    oneLabel.frame = CGRectMake(68, _content.bottom,s.width, s.height);
    
    NSString *strSource = [HtmlString transformString:_model.SourceMessageContent];
    RCLabelComponentsStructure *ds02 = [RCLabel extractTextStyle:strSource];
    _sourceContent.componentsAndPlainText = ds02;
    CGSize size02 = [_sourceContent optimumSize:YES];
    _sourceContent.frame = CGRectMake(68, oneLabel.bottom, kOriginalMsgWidth, size02.height);
    
}

+ (CGFloat)getCellHeightWithModel:(ReplyModel *)oneModel{
    float h = 0;
    NSString *strContent = [HtmlString transformString:oneModel.TargetMessageContent];
    RCLabel *label01 = [[RCLabel alloc]initWithFrame:CGRectMake(0, 0, kTargetMsgWidth, 0)];
    label01.font = [UIFont systemFontOfSize:kTargetFont];
    RCLabelComponentsStructure *ds01 = [RCLabel extractTextStyle:strContent];
    label01.componentsAndPlainText = ds01;
    CGSize size01 = [label01 optimumSize:YES];
    
    h += size01.height;
    
    //计算 回复 ** 的动态 的尺寸
    UILabel *someLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    someLabel.font = [UIFont systemFontOfSize:12];
    NSString *toName  = oneModel.SourceUserName;
    NSString *tailStr = nil;
    if ([oneModel.SourceMessageType intValue] == 1 || [oneModel.SourceMessageType intValue] == 2) {
        tailStr = @"的回复";
    }else{
        tailStr = @"的动态";
    }
    NSString *fianlStr = [NSString stringWithFormat:@"回复 %@ %@:",toName,tailStr];
    someLabel.text = fianlStr;
    CGSize s = [someLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    h += s.height;
    
    NSString *strSource = [HtmlString transformString:oneModel.SourceMessageContent];
    RCLabel *label02 = [[RCLabel alloc]initWithFrame:CGRectMake(0, 0, kOriginalMsgWidth, 0)];
    label02.font = [UIFont systemFontOfSize:kSourceFont];
    RCLabelComponentsStructure *ds02 = [RCLabel extractTextStyle:strSource];
    label02.componentsAndPlainText = ds02;
    CGSize size02 = [label02 optimumSize:YES];
    h += size02.height;
    
    return h + 55;
}

@end
