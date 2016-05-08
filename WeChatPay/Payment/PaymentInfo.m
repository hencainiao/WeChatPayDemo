//
//  PaymentInfo.m
//  kuaibov
//
//  Created by Sean Yue on 15/12/17.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "PaymentInfo.h"
#import "NSMutableDictionary+SafeCoding.h"
#import "NSString+md5.h"

static NSString *const kPaymentInfoPaymentIdKeyName = @"kuaibov_paymentinfo_paymentid_keyname";
static NSString *const kPaymentInfoOrderIdKeyName = @"kuaibov_paymentinfo_orderid_keyname";
static NSString *const kPaymentInfoOrderPriceKeyName = @"kuaibov_paymentinfo_orderprice_keyname";
static NSString *const kPaymentInfoContentIdKeyName = @"kuaibov_paymentinfo_contentid_keyname";
static NSString *const kPaymentInfoContentTypeKeyName = @"kuaibov_paymentinfo_contenttype_keyname";
static NSString *const kPaymentInfoPayPointTypeKeyName = @"kuaibov_paymentinfo_paypointtype_keyname";
static NSString *const kPaymentInfoPaymentTypeKeyName = @"kuaibov_paymentinfo_paymenttype_keyname";
static NSString *const kPaymentInfoPaymentResultKeyName = @"kuaibov_paymentinfo_paymentresult_keyname";
static NSString *const kPaymentInfoPaymentStatusKeyName = @"kuaibov_paymentinfo_paymentstatus_keyname";
static NSString *const kPaymentInfoPaymentTimeKeyName = @"kuaibov_paymentinfo_paymenttime_keyname";
NSString *const kPaymentInfoKeyName = @"kuaibov_paymentinfo_keyname";
@implementation PaymentInfo

- (NSString *)paymentId {
    if (_paymentId) {
        return _paymentId;
    }
    
    _paymentId = [NSUUID UUID].UUIDString.md5;
    return _paymentId;
}



+ (instancetype)paymentInfoFromDictionary:(NSDictionary *)payment {
    PaymentInfo *paymentInfo = [[self alloc] init];
    paymentInfo.paymentId = payment[kPaymentInfoPaymentIdKeyName];
    paymentInfo.orderId = payment[kPaymentInfoOrderIdKeyName];
    paymentInfo.orderPrice = payment[kPaymentInfoOrderPriceKeyName];
    paymentInfo.contentId = payment[kPaymentInfoContentIdKeyName];
    paymentInfo.contentType = payment[kPaymentInfoContentTypeKeyName];
    paymentInfo.payPointType = payment[kPaymentInfoPayPointTypeKeyName];
    paymentInfo.paymentType = payment[kPaymentInfoPaymentTypeKeyName];
    paymentInfo.paymentResult = payment[kPaymentInfoPaymentResultKeyName];
    paymentInfo.paymentStatus = payment[kPaymentInfoPaymentStatusKeyName];
    paymentInfo.paymentTime = payment[kPaymentInfoPaymentTimeKeyName];
    return paymentInfo;
}

- (NSDictionary *)dictionaryFromCurrentPaymentInfo {
    NSMutableDictionary *payment = [NSMutableDictionary dictionary];
    [payment safelySetObject:self.paymentId forKey:kPaymentInfoPaymentIdKeyName];
    [payment safelySetObject:self.orderId forKey:kPaymentInfoOrderIdKeyName];
    [payment safelySetObject:self.orderPrice forKey:kPaymentInfoOrderPriceKeyName];
    [payment safelySetObject:self.contentId forKey:kPaymentInfoContentIdKeyName];
    [payment safelySetObject:self.contentType forKey:kPaymentInfoContentTypeKeyName];
    [payment safelySetObject:self.payPointType forKey:kPaymentInfoPayPointTypeKeyName];
    [payment safelySetObject:self.paymentType forKey:kPaymentInfoPaymentTypeKeyName];
    [payment safelySetObject:self.paymentResult forKey:kPaymentInfoPaymentResultKeyName];
    [payment safelySetObject:self.paymentStatus forKey:kPaymentInfoPaymentStatusKeyName];
    [payment safelySetObject:self.paymentTime forKey:kPaymentInfoPaymentTimeKeyName];
    return payment;
}
/**
 *  保存支付信息
 */
- (void)save {
    NSArray *paymentInfos = [[NSUserDefaults standardUserDefaults] objectForKey:kPaymentInfoKeyName];
    
    NSMutableArray *paymentInfosM = [paymentInfos mutableCopy];
    if (!paymentInfosM) {
        paymentInfosM = [NSMutableArray array];
    }
    

    
    NSDictionary *payment;
    for (NSDictionary *dic in paymentInfos) {
         NSString *paymentId = dic[kPaymentInfoPaymentIdKeyName];
        if ([paymentId isEqualToString:self.paymentId]) {
            payment = dic;
            break;
        }
    }
    if (payment) {
        [paymentInfosM removeObject:payment];
    }
    
    payment = [self dictionaryFromCurrentPaymentInfo];
    [paymentInfosM addObject:payment];
    
    [[NSUserDefaults standardUserDefaults] setObject:paymentInfosM forKey:kPaymentInfoKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

}

@end
