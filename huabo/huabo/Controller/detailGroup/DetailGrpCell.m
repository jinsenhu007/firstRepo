//
//  DetailGrpCell.m
//  huabo
//
//  Created by admin on 14-4-14.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "DetailGrpCell.h"
#import "UIImageView+WebCache.h"

@implementation DetailGrpCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    _grpHead = (UIImageView *)[self.contentView viewWithTag:100];
    _nameLabel = (UILabel *)[self.contentView viewWithTag:101];
    _creator = (UILabel *)[self.contentView viewWithTag:102];
    _lockView = (UIImageView *)[self.contentView viewWithTag:103];
    
}

- (void)layoutSubviews{
    [super layoutSubviews ];
    
    [_grpHead setImageWithURL:[NSURL URLWithString:_model.GroupHeadSculpture24] placeholderImage:nil];
    _nameLabel.text = _model.GroupName;
    _creator.text = _model.CreaterName;
    // 群组类型（1私有 列入公司群组列表，2私有 不列入公司群组列表，4公共）
    if (_model.GroupType == 1 || _model.GroupType == 2) {
        _lockView.hidden = NO;
    }else if (_model.GroupType == 4){
        _lockView.hidden = YES;
    }
    
}


@end
