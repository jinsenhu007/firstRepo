//
//  SideMenuCell.m
//  huabo
//
//  Created by admin on 14-2-26.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "SideMenuCell.h"

@implementation SideMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sideMenuCellBG.png"]];;
        UIView *view = [[UIView alloc]initWithFrame:self.bounds];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sideMenuBG.png"]];
        self.selectedBackgroundView = view;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
