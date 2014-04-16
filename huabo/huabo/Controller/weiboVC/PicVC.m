//
//  PicVC.m
//  huabo
//
//  Created by admin on 14-3-17.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "PicVC.h"
#import "JsDevice.h"
#import "BlockUI.h"
#import "factory.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "ClickableUIImageView.h"


#define kImageWidth 80
#define kImageHeight 80

#define kBtnTag 1000
@interface PicVC ()

@end

@implementation PicVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)_createUI{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth , 210)];
    _bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2_03.png"]];
    [self.view addSubview:_bgView];
    
    
    for (int i=0; i < 6; i++) {
        CGRect rect = CGRectMake(i%3*(kImageWidth+26)+13, i/3*(kImageHeight+22)+15, kImageWidth, kImageHeight);
        
       // _btnAdd.frame = rectBtn;
        ClickableUIImageView *iView = [[ClickableUIImageView alloc]initWithFrame:rect];
        iView.tag = 100+i;
        iView.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:iView];
        
        
        [iView handleComplemetionBlock:^(ClickableUIImageView *oneView) {
            //没有图片不带点得。。。
            if (iView.image == nil) {
                return ;
            }
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否删除照片" delegate:nil cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                NSLog(@"%d",buttonIndex);
                NSLog(@"iview %d",iView.tag);
                if (buttonIndex == 1) {
                    //要删除
                    iView.image = nil;
                    [self _reLayoutBGViewSubViews];
                }else if (buttonIndex == 0){
                    //不删除
                }
            }];
        }];
    }

    
    
    CGRect rect = CGRectMake(10, 10, 80, 80) ;
    _btnAdd =[factory createButtonFrame:rect image:@"addPhoto.png" selectImage:@"addPhotoSelected.png" target:self action:@selector(btnAddClick:)];
    _btnAdd.backgroundColor = [UIColor clearColor];
    _btnAdd.tag = kBtnTag;
    [_bgView addSubview:_btnAdd];
    
   
    
    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   // [self _showActionSheet];
    [self _reLayoutBGViewSubViews];
}

- (void)_showActionSheet{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择照片来源" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片",@"手机相册", nil];
    [sheet showInView:_btnAdd withCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            //拍摄照片
            // UIImagePickerControllerCameraDeviceRear,
            //UIImagePickerControllerCameraDeviceFront
            BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
            if (!isCamera) {
                NSLog(@"no Camera");
                return ;
            }
            UIImagePickerController *phoPic = [[UIImagePickerController alloc]init];
            phoPic.sourceType = UIImagePickerControllerSourceTypeCamera;
            phoPic.delegate  = self;
            phoPic.allowsEditing = YES;
            UIViewController *vc = [self _getWeiboVC];
            [vc presentViewController:phoPic animated:YES completion:nil];
          
            
        }else if (buttonIndex == 1){
            //手机相册
           picker = [[UIImagePickerController alloc]init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
//            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
//            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            UIViewController *vc = [self _getWeiboVC];//需取到所在的"父"视图控制器（这个意思）
            [vc presentViewController:picker animated:YES completion:nil];
            
        }else if (buttonIndex == 2){
           //取消
        }
    }];
    
}

- (UIViewController *) _getWeiboVC{
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    UIWindow *win  = [app window];
    DDMenuController *ddMenu = (DDMenuController *)win.rootViewController;
    UITabBarController *tab = (UITabBarController *)ddMenu.rootViewController;
    UIViewController *vc = [tab selectedViewController];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController*)vc;
        return [nav topViewController];
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _createUI];
  
	// Do any additional setup after loading the view.
}

- (void)btnAddClick:(id)sender{
    [self _showActionSheet];
}

- (void)_reLayoutBGViewSubViews{

   //思路：点击"+",就在当前位置添加图片,"+"移到最近的一个空白区域（没有图片的区域）,如果有5张图，则 + 移走。 点击图片弹出对话框，如果删除了当前位置图片，则 "+"移到当前位置，
    //统计有图片的ImageView个数
    int count = 0;
    for ( int i = 0; i < 6;  i++) {
        UIView *view = [_bgView.subviews objectAtIndex:i];
        if ([view isKindOfClass:[ClickableUIImageView class]] ) {
            ClickableUIImageView *iView = (ClickableUIImageView *)view;
            //有图片
            if (iView.image) {
                count++;
            }
        }
    }
    //重新排布图片
    for (int i = 0; i < 5; i++) {
        UIView *view = [_bgView.subviews objectAtIndex:i];
        if ([view isKindOfClass:[ClickableUIImageView class]]) {
            ClickableUIImageView *iView = (ClickableUIImageView *)view;
            //该地有图片
            if (iView.image) {
               // iView.hidden = NO;
                continue;
            }else{
                //该地无图片
                for (int j = i+1; j < 6; j++) {
                    UIView *v = [_bgView.subviews objectAtIndex:j];
                    if ([v isKindOfClass:[ClickableUIImageView class]]) {
                        ClickableUIImageView *iView02 = (ClickableUIImageView *)v;
                        if (iView02.image) {
                           //找到第一个image非空的就给i中得那个空得
                            iView.image = iView02.image;
                            iView02.image = nil;
                            break;
                        }
                        
                    }
                }
                
            }
        }
    }
    [UIView animateWithDuration:0.3f animations:^{
        CGRect rectBtn = CGRectMake((count)%3*(kImageWidth+26)+13, (count)/3*(kImageHeight+22)+15, kImageWidth, kImageHeight);
        _btnAdd.frame = rectBtn;
    }];
    
}

- (ClickableUIImageView *)_getClickableUIImageViewUnderBtnAdd{
    CGPoint center = _btnAdd.center;
    for (ClickableUIImageView *iView in _bgView.subviews) {
        //包含
        if (CGRectContainsPoint(iView.frame, center)) {
            return iView;
        }
    }
    return nil;
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //选中的图片加在当前_btnAdd按钮的位置
    ClickableUIImageView *iView = [self _getClickableUIImageViewUnderBtnAdd];
    if (iView) {
        iView.image = image;
    }
    
    
   
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
