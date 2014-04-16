//
//  GrpTypeVC.h
//  huabo
//
//  Created by admin on 14-4-16.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"
#import "QCheckBox.h"
#import "RadioButton.h"

typedef void (^finishBlock)(int n);

@interface GrpTypeVC : BaseViewController<QCheckBoxDelegate,RadioButtonDelegate>
{
    RadioButton *_private;
    RadioButton *_public;
    QCheckBox *_first;
  
    int _groupType; //群组类型（1私有 列入公司群组列表，2私有 不列入公司群组列表，4公共）
}


@property (copy,nonatomic) finishBlock block;


@end
