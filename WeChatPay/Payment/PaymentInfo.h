//
//  PaymentInfo.h
//  kuaibov
//
//  Created by Sean Yue on 15/12/17.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PaymentStatus) {
    PaymentStatusUnknown,
    PaymentStatusPaying,
    PaymentStatusNotProcessed,
    PaymentStatusProcessed
};

@interface PaymentInfo : NSObject

@property (nonatomic) NSString *paymentId;
@property (nonatomic) NSString *orderId;
@property (nonatomic) NSNumber *orderPrice;
@property (nonatomic) NSNumber *contentId;
@property (nonatomic) NSNumber *contentType;
@property (nonatomic) NSNumber *payPointType;
@property (nonatomic) NSString *paymentTime;
@property (nonatomic) NSNumber *paymentType;
@property (nonatomic) NSNumber *paymentResult;
@property (nonatomic) NSNumber *paymentStatus;
@property (nonatomic) NSString *reservedData;

// 商户信息
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *signKey;
@property (nonatomic) NSString *notifyUrl;
/**
 *  查询支付信息
 *
 *  @param payment 支付信息
 *
 *  @return 支付结果模型
 */
+ (instancetype)paymentInfoFromDictionary:(NSDictionary *)payment;
/**
 *  保存支付信息
 */
- (void)save;

@end
