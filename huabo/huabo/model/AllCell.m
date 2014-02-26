//
//  AllCell.m
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "AllCell.h"
#import "factory.h"
#import "JsDevice.h"

#define CELL_HEIGHT 200

#define TOP_GAP 6
#define LEFT_GAP 6
#define HEAD_IMAGE_WIDTH 35
#define HEAD_IMAGE_HEIGHT 35

@implementation AllCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _headView = [[ClickableUIImageView alloc]initWithFrame:CGRectMake(LEFT_GAP, TOP_GAP, HEAD_IMAGE_WIDTH, HEAD_IMAGE_HEIGHT)];
    _headView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_headView];
    
    _labelName = [[UILabel alloc]initWithFrame:CGRectMake(_headView.frame.origin.x+HEAD_IMAGE_WIDTH+5, TOP_GAP, 200, 15)];
    _labelName =[factory createLabelFrame:CGRectMake(_headView.frame.origin.x+HEAD_IMAGE_WIDTH+5, TOP_GAP, 200, 15) Text:@"IOS programing 你好"];
    [self.contentView addSubview:_labelName];
    
    _labelTime = [factory createLabelFrame:CGRectMake(_headView.frame.origin.x+HEAD_IMAGE_WIDTH+5,_headView.frame.origin.y+_headView.frame.size.height-16, 80, 15) Text:@"1分钟前"];
    _labelTime.font = SysFont(11);
    _labelTime.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_labelTime];
    
    _labelSource = [factory createLabelFrame:CGRectMake(_labelTime.frame.origin.x+_labelTime.frame.size.width+10, _labelTime.frame.origin.y, 150, 15) Text:@"来自：新浪微博"];
    _labelSource.backgroundColor = [UIColor yellowColor];
    _labelSource.font = SysFont(11);
    [self.contentView addSubview:_labelSource];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
