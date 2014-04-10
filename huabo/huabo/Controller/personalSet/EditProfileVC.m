//
//  EditProfileVC.m
//  huabo
//
//  Created by admin on 14-3-20.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "EditProfileVC.h"
#import "UIImageView+WebCache.h"
#import "clickableUIView.h"
#import "BlockUI.h"
#import "UserModel.h"
#import "UserMgr.h"
#import "UIView+MakeAViewRoundCorner.h"


#define kHeadIconImageView 100
@interface EditProfileVC ()

@end

@implementation EditProfileVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showLeftButtonWithImageName:@"返回.png" target:self action:@selector(pressBack)];
    [self showRightButtonOfSureWithName:@"保存" target:self action:@selector(pressSave)];
    
    UserModel *m = [[UserMgr sharedInstance] readFromDisk];
    _model = m;
    _tUserName.text = _model.RealName;
    _tUserName.textColor = [UIColor blueColor];
    
    _tPwd.text = _model.LoginPwd;
    _tEmail.text = _model.LoginEmail;
    _tTelPhone.text = _model.TelPhone;
    NSLog(@"username %@ pass %@ email %@ telPhone %@",_model.RealName,_model.LoginPwd,_model.LoginEmail,_model.TelPhone);
    [(UIImageView *)[_changeHeadIcon viewWithTag:kHeadIconImageView] setRoundedCornerWithRadius:6.0f];
    [(UIImageView *)[_changeHeadIcon viewWithTag:kHeadIconImageView] setImageWithURL:[NSURL URLWithString:_model.HeadSculpture100] placeholderImage:nil];
    
    [_changeHeadIcon handleComplemetionBlock:^(clickableUIView *view) {
        UIActionSheet *s = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"本地相册", nil];
        
        [s showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
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
                
                [self presentViewController:phoPic animated:YES completion:nil];

                
            }else if (buttonIndex == 1){
                //本地相册
                UIImagePickerController *pic = [[UIImagePickerController alloc]init];
                pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pic.delegate = self;
                [self presentViewController:pic animated:YES completion:nil];
            }
        }];
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressSave{
    
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [(UIImageView *)[_changeHeadIcon viewWithTag:kHeadIconImageView] setImage:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
