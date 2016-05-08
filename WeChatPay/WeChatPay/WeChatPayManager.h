//
//  WeChatPayManager.h
//  kuaibov
//
//  Created by Sean Yue on 15/11/13.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonSet.h"
#import "PaymentInfo.h"
typedef void (^WeChatPayCompletionHandler)(PAYRESULT payResult);

@interface WeChatPayManager : NSObject

+ (instancetype)sharedInstance;

- (void)startWithPayment:(PaymentInfo *)paymentInfo completionHandler:(WeChatPayCompletionHandler)handler;
/**
 *  调起微信支付接口
 *
 *  @param orderNo 订单号
 *  @param price   订单金额
 *  @param handler 回调
 */
- (void)startWeChatPayWithOrderNo:(NSString *)orderNo
                            price:(double)price
                completionHandler:(WeChatPayCompletionHandler)handler;

- (void)sendNotificationByResult:(PAYRESULT)result;
@end
