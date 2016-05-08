//
//  WeChatPayQueryOrderRequest.h
//  kuaibov
//
//  Created by Sean Yue on 15/11/23.
//  Copyright © 2015年 kuaibov. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "PaymentInfo.h"
/**
 *  微信支付查询
 *
 *  @param success     支付成功/失败
 *  @param trade_state 交易状态
 *  @param total_fee   交易金额
 */
typedef void (^WeChatPayQueryOrderCompletionHandler)(BOOL success, NSString *trade_state, double total_fee);

@interface WeChatPayQueryOrderRequest : NSObject

@property (nonatomic) NSString *return_code;
@property (nonatomic) NSString *result_code;
@property (nonatomic) NSString *trade_state;
@property (nonatomic) double total_fee;


/**
 *  去微信查询支付结果
 *
 *  @param paymentInfo 支付传入的参数模型
 *  @param handler     回调结果
 *
 *  @return 支付成功/失败
 */
-(BOOL)queryPayment:(PaymentInfo*)paymentInfo completionHandler:(WeChatPayQueryOrderCompletionHandler)handler;

@end
