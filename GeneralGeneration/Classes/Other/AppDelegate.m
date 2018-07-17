//
//  AppDelegate.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/23.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "AppDelegate.h"
#import "ZDLoginController.h"
#import "ZDNavgationController.h"
#import "ZDHomePageController.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/AdSupport.h>
#import "NSString+LCExtension.h"
#import "ZDStoreDetailsController.h"
@interface AppDelegate ()<JPUSHRegisterDelegate>
@property(nonatomic,strong)NSString *registerid;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //注册推送
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"420657cd2e8ef9559f3f66de"
                          channel:@"App Store"
                 apsForProduction:1
            advertisingIdentifier:advertisingId];
    
    //1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //2.设置窗口根控制器
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    if(uuid){
        ZDHomePageController *Vc = [[ZDHomePageController alloc] init];
        ZDNavgationController *nav = [[ZDNavgationController alloc] initWithRootViewController:Vc];
        self.window.rootViewController = nav;
    }else{
        ZDLoginController *Vc = [[ZDLoginController alloc] init];
        ZDNavgationController *nav = [[ZDNavgationController alloc] initWithRootViewController:Vc];
        self.window.rootViewController = nav;
    }
    //3.显示窗口
    [self.window makeKeyAndVisible];
    
    [NSThread sleepForTimeInterval:1];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    //获得注册后的regist_id，此值一般传给后台做推送的标记用,先存储起来
    _registerid = [JPUSHService registrationID];
    
}
//点击推送条幅
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    //自定义内容
    //NSLog(@"收到的推送消息 userinfo %@",userInfo);
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        // NSLog(@"前台收到消息1");
        [self setControllers:userInfo]; //收到推送消息，需要调整的界面
        
    }
    completionHandler();
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    //自定义内容
    //    NSLog(@"收到的推送消息 userinfo %@",userInfo);
    //
    //    //判断应用是在前台还是后台
    //
    //    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
    //
    //        //     前台收到消息后，做的对应页面跳转操作
    //        [self setControllers:userInfo];
    //        // [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHYUJING" object:nil];
    //        NSLog(@"前台收到消息");
    //    }
    //
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        
    }
    
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
}

-(void)setControllers:(NSDictionary *)userInfo{
    
    //自定义的内容
    //参数跳转
    NSString *param = [userInfo valueForKey:@"param"];
    //楼盘ID或订单ID
    NSString *additional = [userInfo valueForKey:@"additional"];
    //展示类型
    NSString *viewType = [userInfo valueForKey:@"viewType"];
    //h5地址
    //NSString *url = [userInfo valueForKey:@"url"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    if (!uuid) {
        [NSString isCode:self.window.rootViewController.navigationController code:@"401"];
        return;
    }
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    
    [pushJudge setObject:@"push"forKey:@"push"];
    
    [pushJudge synchronize];
    //跳转页面
   if([viewType isEqual:@"2"]){
        //跳转原生
        if ([param isEqual:@"114"]) {
            ZDStoreDetailsController *detailVc = [[ZDStoreDetailsController alloc] init];
            detailVc.storeId = additional;
            ZDNavgationController *nav = [[ZDNavgationController alloc] initWithRootViewController:detailVc];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }
}
@end
