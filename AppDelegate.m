//
//  AppDelegate.m
//  WeChatPay-Demo
//
//  Created by ZF on 16/4/17.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import "AppDelegate.h"
#import "PaymentManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[PaymentManager sharedManager] setup];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [[PaymentManager sharedManager] handleOpenURL:url];

    return YES;
    
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    [[PaymentManager sharedManager] handleOpenURL:url];
    

    return YES;

}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    /**
     *  这个在支付完之后不从微信返回，而是自己手动返回到本应用必须要判断支付成功还是失败
     */
    [[PaymentManager sharedManager] checkPayment];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
