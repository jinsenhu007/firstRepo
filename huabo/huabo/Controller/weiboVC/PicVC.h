//
//  PicVC.h
//  huabo
//
//  Created by admin on 14-3-17.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"

@interface PicVC : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
   // UIView *_bgView;
    UIButton *_btnAdd;
    
    UIImagePickerController *picker;
    
    
}

@property (retain,nonatomic) UIView *bgView;
@end
