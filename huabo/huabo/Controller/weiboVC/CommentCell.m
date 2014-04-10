//
//  CommentCell.m
//  huabo
//
//  Created by admin on 14-3-21.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "CommentCell.h"
#import "UIView+MakeAViewRoundCorner.h"
#import "ClickableUIImageView.h"
#import "UIImageView+WebCache.h"
#import "WeiboModel.h"
#import "JsDevice.h"
#import "UIViewExt.h"
#import "HtmlString.h"
#import "UIImage+imageNamed_JSen.h"

#define kImageWidth 70
#define kImageHeight 75
#define kDiffItemsGap 5

#define kHeadIcon 100;

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    _headIcon = (ClickableUIImageView *)[self viewWithTag:100];
    [_headIcon setRoundedCornerWithRadius:5.0f];
    _headIcon.tag = kHeadIcon;
    
    _labelName = (UILabel *)[self viewWithTag:101];
    _labelTime = (UILabel *)[self viewWithTag:102];
    
    _content = [[RCLabel alloc]initWithFrame:CGRectZero];
    [_content setFont: [UIFont systemFontOfSize:13]];
    _content.delegate = self;
    
    [self.contentView addSubview:_content];
}

- (void)layoutSubviews{
    [_headIcon setImageWithURL:[NSURL URLWithString:_cModel.targetInfo.HeadSculpture48] placeholderImage:nil];
    _labelName.text = _cModel.targetInfo.UserRealName ;
    _labelTime.text = _cModel.SubTimeStr;
    _content.frame = CGRectMake(_labelName.right+5, _labelName.bottom + 10,kScreenWidth-40 ,21);
    
    NSString *str = [HtmlString transformString:_cModel.targetInfo.msgInfo.Content];
    RCLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:str];
    _content.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [_content optimumSize:YES];
    _content.frame = CGRectMake(_labelName.left, _labelName.bottom+10, kScreenWidth-70, optimalSize.height);
    
    if (_cModel.targetInfo.arrAttInfoList) {
        //文档附件只能有一个
        if (_cModel.targetInfo.arrAttInfoList.count == 1 && [[_cModel.targetInfo.arrAttInfoList objectAtIndex:0] Type] == 1) {
            //如果是文档附件
         //   AttachmentInfo *info = [_cModel.arrAttachments objectAtIndex:0];
            //下面这样做为了解决复用问题（性能欠佳）
            [self _removeClickImageViewWithSuperView:self];
           ClickableUIImageView *iViewDocs = [[ClickableUIImageView alloc]initWithFrame:CGRectMake(5, _content.bottom+5, kImageWidth, kImageHeight)];
            [self addSubview:iViewDocs];
            iViewDocs.hidden = NO;
            iViewDocs.image = [UIImage JSenImageNamed:@"weibolist_pic.png"];
            
            
        }
        if ([[_cModel.targetInfo.arrAttInfoList objectAtIndex:0] Type] == 2) {
            //下面这样做为了解决复用问题（性能欠佳）
            [self _removeClickImageViewWithSuperView:self];
            
            for (int i=0; i<_cModel.targetInfo.arrAttInfoList.count; i++) {
                CGRect rect = CGRectMake(i%3*(kImageWidth+kDiffItemsGap)+35,_content.bottom+5+(i/3)*(kImageHeight+kDiffItemsGap), kImageWidth, kImageHeight);
                ClickableUIImageView *iView = [[ClickableUIImageView alloc]initWithFrame:rect];
                AttachmentInfo *info = [_cModel.targetInfo.arrAttInfoList objectAtIndex:i];
                [iView setImageWithURL:[NSURL URLWithString:info.ImageBigPath] placeholderImage:[UIImage JSenImageNamed:@"weibolist_pic.png"]];
                [self addSubview:iView];
            }
        }
    }else{
        
        
        //除掉所有的图片内容
        [self _removeClickImageViewWithSuperView:self];
    }

    
}

+ (float)getCommentHeight:(CommentModel *)cModel{
    float h = 0;
    RCLabel *rc = [[RCLabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-70, 0)];
    rc.font = SysFont(14);
    NSString *str = [HtmlString transformString:cModel.targetInfo.msgInfo.Content];
    RCLabelComponentsStructure *ds = [RCLabel extractTextStyle:str];
    rc.componentsAndPlainText = ds;
    CGSize size = [rc optimumSize:YES];
    
    h += size.height+28+10;
    //计算图片高度
    if (cModel.targetInfo.arrAttInfoList) {
        if (cModel.targetInfo.arrAttInfoList.count >= 1 && cModel.targetInfo.arrAttInfoList.count <= 3) {
            h += kImageHeight+3;
        }else{
            h += kImageHeight*2+10;
        }
    }
    return h+5;
}

- (void)_removeClickImageViewWithSuperView:(UIView *)sView{
    if (sView.subviews !=0) {
        for (UIView *view in sView.subviews) {
            if ([view isKindOfClass:[ClickableUIImageView class]] && view != _headIcon) {
                ClickableUIImageView *iV = (ClickableUIImageView*)view;
                    iV.image = nil;
                    [view removeFromSuperview];
    
                
            }else{
                [self _removeClickImageViewWithSuperView:view];
            }
        }
        
    }
}

#pragma mark - RCLabel delegate
- (void)RCLabel:(id)RCLabel didChangedSize:(CGSize)size{
    
}
@end
