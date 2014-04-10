//
//  AtMeCell.m
//  huabo
//
//  Created by admin on 14-4-9.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "AtMeCell.h"
#import "HtmlString.h"
#import "UIImageView+WebCache.h"
#import "JsDevice.h"
#import "UIViewExt.h"
#import "UIView+MakeAViewRoundCorner.h"
#import "ClickableUIImageView.h"
#import "ReplyModel.h"
#import "UIView+MakeAViewRoundCorner.h"

#define kTargetFont 14
#define kSourceFont 13

#define kOriginalMsgWidth 220
#define kTargetMsgWidth 250

@implementation AtMeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    _headIcon = (ClickableUIImageView *)[self.contentView viewWithTag:100];
    [_headIcon setRoundedCornerWithRadius:5.0f];
    _nameLabel = (UILabel *)[self.contentView viewWithTag:101];
    
    _content = [[RCLabel alloc]initWithFrame:CGRectZero];
    _content.font = [UIFont systemFontOfSize:kTargetFont];
    _content.delegate =self;
    [self.contentView addSubview:_content];
    
    _sourceContent = [[RCLabel alloc]initWithFrame:CGRectZero];
    _sourceContent.font = [UIFont systemFontOfSize:kSourceFont];
    _sourceContent.delegate =self;
    [self.contentView addSubview:_sourceContent];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_headIcon setImageWithURL:[NSURL URLWithString:_model.TargetUserHeadSculpture48] placeholderImage:nil];
    _nameLabel.text = _model.TargetUserName;
    
    NSString *strContent = [HtmlString transformString:_model.TargetMessageContent];
    RCLabelComponentsStructure *ds01 = [RCLabel extractTextStyle:strContent];
    _content.componentsAndPlainText = ds01;
    CGSize size01 = [_content optimumSize:YES];
    
    _content.frame = CGRectMake(68, 50, kTargetMsgWidth, size01.height);
    
    
    NSString *s1 = nil;
    if ([_model.OriginalUserID integerValue] == 0) {
        //源消息被删除
        s1 = _model.OriginalMessageContent;
    }else{
        s1 = [NSString stringWithFormat:@"%@ %@",_model.OriginalUserName,_model.OriginalMessageContent];
    }
   
    NSString *strSource = [HtmlString transformString:s1];
    RCLabelComponentsStructure *ds02 = [RCLabel extractTextStyle:strSource];
    _sourceContent.componentsAndPlainText = ds02;
    CGSize size02 = [_sourceContent optimumSize:YES];
    _sourceContent.frame = CGRectMake(68, _content.bottom+3, kOriginalMsgWidth, size02.height);
}


+ (CGFloat)getCellHeightWithModel:(ReplyModel *)oneModel{
    float h = 0;
    
    RCLabel *labelOne = [[RCLabel alloc]initWithFrame:CGRectMake(0, 0, kOriginalMsgWidth, 0)];
    labelOne.font = [UIFont systemFontOfSize:kTargetFont];
    NSString *s01 = [HtmlString transformString:oneModel.TargetMessageContent];
    RCLabelComponentsStructure *ds01 = [RCLabel extractTextStyle:s01];
    labelOne.componentsAndPlainText = ds01;
    CGSize s1 = [labelOne optimumSize:YES];
    h += s1.height;
    
    NSString *s02 = nil;
    if ([oneModel.OriginalUserID integerValue] == 0) {
        //源消息被删除
        s02 = oneModel.OriginalMessageContent;
    }else{
        s02 = [NSString stringWithFormat:@"%@ %@",oneModel.OriginalUserName,oneModel.OriginalMessageContent];
    }
    
    NSString *s03 = [HtmlString transformString:s02];
    RCLabel *labelTow = [[RCLabel alloc]initWithFrame:CGRectZero];
    labelTow.font = [UIFont systemFontOfSize:kSourceFont];
    RCLabelComponentsStructure *ds02 = [RCLabel extractTextStyle:s03];
    labelTow.componentsAndPlainText = ds02;
    CGSize s2 = [labelTow optimumSize:YES];
    h += s2.height;

    
    return h + 55;
}
@end
