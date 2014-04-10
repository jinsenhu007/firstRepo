//
//  ReplyCell.m
//  huabo
//
//  Created by admin on 14-4-4.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "ReplyCell.h"
#import "HtmlString.h"
#import "UIImageView+WebCache.h"
#import "JsDevice.h"
#import "UIViewExt.h"
#import "UIView+MakeAViewRoundCorner.h"

#define kOriginalMsgWidth 220
#define kTargetMsgWidth 250

@implementation ReplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib{
    _targetHead = (ClickableUIImageView *)[self.contentView viewWithTag:100];
    [_targetHead setRoundedCornerWithRadius:5.0f];
    _userName = (UILabel *)[self.contentView viewWithTag:101];
    _subTime = (UILabel *)[self.contentView viewWithTag:102];
    
    _content = [[RCLabel alloc]initWithFrame:CGRectZero];
    _content.font = [UIFont systemFontOfSize:14];
    _content.delegate = self;
    [self.contentView addSubview:_content];
    
    _originalContent = [[RCLabel alloc]initWithFrame:CGRectZero];
    _originalContent.font = [UIFont systemFontOfSize:12];
    _originalContent.delegate = self;
    [self.contentView addSubview:_originalContent];
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [_targetHead setImageWithURL:[NSURL URLWithString:_model.TargetUserHeadSculpture48] placeholderImage:nil];
   // _userName.text = _model.TargetUserName;
    _userName.text = [NSString stringWithFormat:@"%@ 回复了你",_model.TargetUserName];
    _subTime.text = _model.SubTimeStr;
    
    NSString *strContent = [HtmlString transformString:_model.TargetMessageContent];
    RCLabelComponentsStructure *ds = [RCLabel extractTextStyle:strContent];
    _content.componentsAndPlainText = ds;
    CGSize size01 = [_content optimumSize:YES];
    _content.frame = CGRectMake(68, 65,kTargetMsgWidth, size01.height);
    
    NSString *strOriginal = nil;
    if (_model.OriginalMessageIsDeleted) {
        strOriginal = _model.OriginalMessageContent;
    }else{
        strOriginal = [NSString stringWithFormat:@"%@:%@",_model.OriginalUserName,_model.OriginalMessageContent];
    }
    
    strOriginal = [HtmlString transformString:strOriginal];
    
    RCLabelComponentsStructure *ds02 = [RCLabel extractTextStyle:strOriginal];
    _originalContent.componentsAndPlainText = ds02;
    CGSize size02 = [_originalContent optimumSize:YES];
    _originalContent.frame = CGRectMake(75, _content.bottom, kOriginalMsgWidth, size02.height);
    
    
    
}


+ (CGFloat)getCellHeightWithModel:(ReplyModel *)oneModel{
    float h = 0;
//    if (oneModel.OriginalMessageIsDeleted) {
//        h += 20;
//    }else{
    
    NSString *str  = nil;
    if (oneModel.OriginalMessageIsDeleted) {
        str = oneModel.OriginalMessageContent;
    }else{
        str = [NSString stringWithFormat:@"%@:%@",oneModel.OriginalUserName,oneModel.OriginalMessageContent];
    }
        str = [HtmlString transformString:oneModel.OriginalMessageContent];
        RCLabel *original = [[RCLabel alloc ]initWithFrame:CGRectMake(0, 0,kOriginalMsgWidth, 0)];
        original.font = [UIFont systemFontOfSize:12];
        RCLabelComponentsStructure *ds1 = [RCLabel extractTextStyle:str];
        original.componentsAndPlainText = ds1;
        CGSize size1 = [original optimumSize:YES];
        h += size1.height;
    
    
    NSString *newStr = [HtmlString transformString:oneModel.TargetMessageContent];
    RCLabel *target = [[RCLabel alloc]initWithFrame:CGRectMake(0, 0, kTargetMsgWidth, 0)];
    target.font = [UIFont systemFontOfSize:14];
    RCLabelComponentsStructure *ds = [RCLabel extractTextStyle:newStr];
    target.componentsAndPlainText = ds;
    CGSize size = [target optimumSize:YES];
    h += size.height;
    
    //根据xib排布，应该加69
    return h + 69;
}


#pragma mark -RCLabel Delegate
- (void)RCLabel:(id)RCLabel didSelectLinkWithURL:(NSString*)url{
    
}
@end
