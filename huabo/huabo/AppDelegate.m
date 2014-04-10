//
//  AppDelegate.m
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "AppDelegate.h"
#import "JsTabBarViewController.h"
#import "TrendsVC.h"
#import "MsgVC.h"
#import "ContactorVC.h"
#import "SetVC.h"

#import "LoginViewController.h"

#import "DDMenuController.h"
#import "SideMenuViewController.h"

#import "TSMessageView.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"LS" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        NSLog(@"login Success %@",note.name);
        [self switchToMainUI];
    }];

        
    if ([self isFirstLogin]) {
        //登录界面
        [self createLoginUI];
    }else{
        //第二次登录
        [self switchToMainUI];
    }
    
    
    
    return YES;
}


-(void)createLoginUI{
    UINavigationController *loginNav = [self createNav:@"LoginViewController"];
    self.window.rootViewController = loginNav;
}

-(void)switchToMainUI{
    NSDictionary *trendsNav = [self createNav:@"TrendsVC" withName:@"动态" withImage:@"动态.png"];
    NSDictionary *msgNav = [self createNav:@"MsgVC" withName:@"信息" withImage:@"信息.png"];
    NSDictionary *contactorNav = [self createNav:@"ContactorVC" withName:@"联系人" withImage:@"联系人.png"];
    NSDictionary *setNav = [self createNav:@"SetVC" withName:@"设置" withImage:@"设置.png"];
  //  NSDictionary *moreNav = [self createNav:@"MoreViewController" withName:@"更多" withImage:nil];
    
    JsTabBarViewController *tab = [[JsTabBarViewController alloc]init];
    [tab setViewControllers:[NSArray arrayWithObjects:trendsNav,msgNav,contactorNav,setNav, nil]];
    DDMenuController *rootController = [[DDMenuController alloc]initWithRootViewController:tab];
    _menuController = rootController;
    
    SideMenuViewController *side = [[SideMenuViewController alloc]init];
//    UINavigationController *navSide = [[UINavigationController alloc]initWithRootViewController:side];
    _menuController.leftViewController = side;
    
    self.window.rootViewController = _menuController;
    
    
}

-(NSDictionary*)createNav:(NSString*)clsName withName:(NSString*)name withImage:(NSString*)imageName{
    UINavigationController *nav = [self createNav:clsName];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          nav,kController,
                          name,kTitle,
                          imageName,kImageName
                          ,nil];
    return dict;
}

-(UINavigationController*)createNav:(NSString *)clsName{
    Class cls = NSClassFromString(clsName);
    UIViewController *vc = [[cls alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    //[vc.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBG.png"] forBarMetrics:UIBarMetricsDefault];
    return nav;
}

-(BOOL)isFirstLogin{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
