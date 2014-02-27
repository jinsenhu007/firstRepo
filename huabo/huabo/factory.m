//
//  factory.m
//  SNSRenRen
//
//  Created by sensen on 13-12-5.
//  Copyright (c) 2013年 sensen. All rights reserved.
//

#import "factory.h"
#import "ClickableUIImageView.h"
#import "JsDevice.h"


@implementation factory

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+(UILabel *)createLabelFrame:(CGRect )frame Text:(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont: [UIFont systemFontOfSize:13]];
    [label setTextColor:[UIColor darkGrayColor]];
    
    return label;
    //return [label autorelease];
}
//穿件响应手势得label
+(UILabel *)createLabelFrame:(CGRect )frame Text:(NSString *)text action:(SEL)sel target:(id)target
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.userInteractionEnabled =YES;////
    label.backgroundColor = [UIColor clearColor];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont: [UIFont systemFontOfSize:13]];
    [label setTextColor:[UIColor whiteColor]];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    tap.numberOfTapsRequired =1;
    tap.numberOfTouchesRequired = 1;
    [tap addTarget:target action:sel];

    [label addGestureRecognizer:tap];
  
    return label;
    //return [label autorelease];
}

//创建自定义button
+(UIButton *)createButtonFrame:(CGRect)frame Image:(UIImage*)image Target:(id)target Action:(SEL)action Tag:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    
    return btn;
}
//you tag
+(UITextField *)createTextFieldFrame:(CGRect)frame Placeholder:(NSString *)placeholder Delegate:(id)del Tag:(NSInteger)tag
{
    UITextField *tf = [[UITextField alloc]initWithFrame:frame];
    [tf setPlaceholder:placeholder];
    [tf setTag:tag];
    [tf setDelegate:del];
    [tf setFont:[UIFont systemFontOfSize:13]];
    [tf setBorderStyle:UITextBorderStyleRoundedRect];
    
    return tf;
   // return [tf autorelease];
}
//没有tag
+(UITextField *)createTextFieldFrame:(CGRect)frame Placeholder:(NSString *)placeholder Delegate:(id)del 
{
    UITextField *tf = [[UITextField alloc]initWithFrame:frame];
    [tf setPlaceholder:placeholder];
       [tf setDelegate:del];
    [tf setFont:[UIFont systemFontOfSize:13]];
    [tf setBorderStyle:UITextBorderStyleRoundedRect];
    
    return tf;
    // return [tf autorelease];
}

//创建普通button
+(UIButton *)createButtonFrame:(CGRect)frame Title:(NSString *)title Target:(id)target Action:(SEL)action Tag:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTag:tag];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}


+(ClickableUIImageView*)personalInfoMainLabel:(NSString*)name subLabel:(NSString*)sub andBackgroundViewFrame:(CGRect)frame{
    
    ClickableUIImageView *bgView = [[ClickableUIImageView alloc]initWithFrame:frame];
    bgView.image = [UIImage imageNamed:@"基本信息_03@2x.png"];
    bgView.userInteractionEnabled = YES;
    
    UILabel *main = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 100, 15)];
    main.text= name;
    main.font = [UIFont boldSystemFontOfSize:15];
    main.backgroundColor = [UIColor clearColor];
    
    UILabel *sub1 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-200, 3, 180, 15)];
    sub1.text = sub;
    sub1.font= [UIFont systemFontOfSize:13];
    sub1.textColor =[UIColor darkGrayColor];
    sub1.textAlignment = NSTextAlignmentCenter;
    
    //[bgView addSubview:sub1];
    [bgView addSubview:main];
    return bgView;
}

+(ClickableUIImageView*)createDiscoverUIWithAImageName:(NSString*)imageName aTitle:(NSString *)str andFrame:(CGRect)frame{
    CGFloat y = 10;
    
    ClickableUIImageView *bgView = [[ClickableUIImageView alloc]initWithFrame:frame];
    bgView.image = [UIImage imageNamed:@"基本信息_03@2x.png"];
    bgView.userInteractionEnabled = YES;
    
    UIImageView *iView = [[UIImageView alloc]initWithFrame:CGRectMake(5,y , 20, 20)];
    iView.image = [UIImage imageNamed:imageName];
    [bgView addSubview:iView];
    
    UILabel *sub1 = [[UILabel alloc]initWithFrame:CGRectMake(iView.frame.size.width+10,y,70,20)];
    sub1.text = str;
    sub1.font= [UIFont boldSystemFontOfSize:14];
    sub1.textColor =[UIColor darkGrayColor];
    sub1.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:sub1];
    
    UIImageView *small = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"更改头像_03.png"]];
    small.frame = CGRectMake(frame.size.width-20, y+3, 10, 10);
    [bgView addSubview:small];
    
    return bgView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
