//
//  MyPaymentViewController.m
//  HuangDuanZi
//
//  Created by ZF on 16/4/14.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import "MyPaymentViewController.h"
#import "Util.h"
#import "PaymentManager.h"

@interface MyPaymentViewController ()

@end

@implementation MyPaymentViewController

+ (instancetype)sharedPaymentVC {
    
    static MyPaymentViewController *_sharedPaymentVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPaymentVC = [[MyPaymentViewController alloc] init];
    });
    return _sharedPaymentVC;
}
/**
 *  支付弹窗
 */
- (void)pay{
    
    
    [[PaymentManager sharedManager] startPaymentWithType:PaymentTypeWeChatPay subType:PaymentTypeWeChatPay price:100 completionHandler:^(PAYRESULT payResult, PaymentInfo *paymentInfo) {
        
        [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
        
    }];
    
    
    
}
/**
 *  把支付结果提示暴露出来，在appdelegate的becomeActive方法中会调用该方法
 *
 *  @param payResult   支付枚举
 *  @param paymentInfo 支付参数
 */
- (void)notifyPaymentResult:(PAYRESULT)payResult withPaymentInfo:(PaymentInfo*)paymentInfo{
    
    
    if (payResult == PAYRESULT_SUCCESS && [Util successfulPaymentInfo]) {
        return ;
    }
    
    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
    [dateFormmater setDateFormat:@"yyyyMMddHHmmss"];
    
    paymentInfo.paymentResult = @(payResult);
    paymentInfo.paymentStatus = @(PaymentStatusNotProcessed);
    paymentInfo.paymentTime = [dateFormmater stringFromDate:[NSDate date]];
    [paymentInfo save];
    
    
    //在这里做出支付提示
    //。。。。。。
    
    
    /**
     *完了之后提交支付结果到服务器
     */
//    [[PaymentModel sharedModel] commitPaymentInfo:paymentInfo];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
