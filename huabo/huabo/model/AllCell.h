//
//  AllCell.h
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableUIImageView.h"
#import "clickableUIView.h"
@interface AllCell : UITableViewCell
{
    ClickableUIImageView *_headView;//头像
    UILabel *_labelName;//姓名
    UILabel *_labelTime;//发布时间
    UILabel *_labelSource;//来源
    UILabel *_labelContent;//内容
    
    ClickableUIImageView *_picContent;//发布的图片
    
}
@end
