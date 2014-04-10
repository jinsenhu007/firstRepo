//
//  faceViewController.h
//  MyWeiXin
//
//  Created by sensen on 14-1-1.
//  Copyright (c) 2014年 sensen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickFace)(NSString* );

@interface FaceViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControll;
    clickFace _block;
}

-(void)handleSelectBlock:(clickFace)block;
@end
