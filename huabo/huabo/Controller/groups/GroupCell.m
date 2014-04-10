//
//  GroupCell.m
//  huabo
//
//  Created by admin on 14-3-24.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "GroupCell.h"
#import "GroupModel.h"

@implementation GroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    _name = (UILabel *)[self.contentView viewWithTag:100];
    
}

- (void)layoutSubviews{
    _name.text = _gModel.GroupName;
    
    
}



@end
