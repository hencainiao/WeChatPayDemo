//
//  MyPaymentViewController.h
//  HuangDuanZi
//
//  Created by ZF on 16/4/14.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentInfo.h"
#import "CommonSet.h"

@interface MyPaymentViewController : UIViewController


+ (instancetype)sharedPaymentVC;
/**
 *  支付
 */
- (void)pay;
/**
 *  支付完成之后提示支付信息
 *
 *  @param payResult   支付结果
 *  @param paymentInfo 支付参数
 */
- (void)notifyPaymentResult:(PAYRESULT)payResult withPaymentInfo:(PaymentInfo*)paymentInfo;
@end
