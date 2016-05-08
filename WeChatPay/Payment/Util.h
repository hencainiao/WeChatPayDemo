//
//  Util.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/8.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kPaymentInfoKeyName;
@class PaymentInfo;

@interface Util : NSObject

+ (BOOL)isRegistered;
+ (void)setRegisteredWithUserId:(NSString *)userId;

+ (NSArray<PaymentInfo *> *)allPaymentInfos;
+ (NSArray<PaymentInfo *> *)payingPaymentInfos;
+ (NSArray<PaymentInfo *> *)paidNotProcessedPaymentInfos;
+ (PaymentInfo *)successfulPaymentInfo;
+ (BOOL)isPaid;

+ (NSString *)accessId;
+ (NSString *)userId;
+ (NSString *)deviceName;

+ (void)startMonitoringNetwork;

@end
