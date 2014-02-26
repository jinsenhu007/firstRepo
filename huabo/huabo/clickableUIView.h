//
//  clickableUIView.h
//  LimitFree
//
//  Created by sensen on 13-12-19.
//  Copyright (c) 2013年 sensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class clickableUIView;
typedef  void(^handleComleplement)(clickableUIView*);
@interface clickableUIView : UIView
{

    handleComleplement _block;
}


-(void)handleComplemetionBlock:(handleComleplement)block;
@end
