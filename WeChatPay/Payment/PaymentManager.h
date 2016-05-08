//
//  PaymentManager.h
//  kuaibov
//
//  Created by Sean Yue on 16/3/11.
//  Copyright © 2016年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentInfo.h"
#import "CommonSet.h"
@class Program;
/**
 *  回调block
 *
 *  @param payResult   支付结果
 *  @param paymentInfo 各种支付参数
 */
typedef void (^PaymentCompletionHandler)(PAYRESULT payResult, PaymentInfo *paymentInfo);

@interface PaymentManager : NSObject

+ (instancetype)sharedManager;
/**
 *  设置基本参数
 */
- (void)setup;

/**
 *
 *
 *  @param type    支付方式
 *  @param price   支付金额
 *  @param program 支付的模型对象
 *  @param handler 支付回调
 *
 *  @return 支付成功/失败
 */
- (BOOL)startPaymentWithType:(PaymentType)type
                       price:(NSUInteger)price
                  forProgram:(Program *)program
           completionHandler:(PaymentCompletionHandler)handler;

/**
 *  支付
 *
 *  @param type    支付方式
 *  @param subType 子支付方式
 *  @param price   支付金额
 *  @param handler 支付回调
 *
 *  @return 支付成功/失败
 */
- (BOOL)startPaymentWithType:(PaymentType)type
                     subType:(PaymentType)subType
                       price:(NSUInteger)price
           completionHandler:(PaymentCompletionHandler)handler;
/**
 *  支付结果
 *
 *  @param type    支付方式
 *  @param price   金额
 *  @param handler 回调
 *
 *  @return 返回支付成功/失败
 */
- (BOOL)startPaymentWithType:(PaymentType)type
                       price:(float)price
           completionHandler:(PaymentCompletionHandler)handler;

- (void)handleOpenURL:(NSURL *)url;

/**
 *  检查是否支付
 */
- (void)checkPayment;

@end
