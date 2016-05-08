//
//  Util.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/8.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//


#import "Util.h"
#import "CommonSet.h"
#import <sys/sysctl.h>
#import "PaymentInfo.h"
#include "NSString+md5.h"

NSString *const kPaymentInfoKeyName = @"kuaibov_paymentinfo_keyname";

static NSString *const kRegisterKeyName = @"kuaibov_register_keyname";
static NSString *const kUserAccessUsername = @"kuaibov_user_access_username";
static NSString *const kUserAccessServicename = @"kuaibov_user_access_service";

@implementation Util

//+ (NSString *)accessId {
//    NSString *accessIdInKeyChain = [SFHFKeychainUtils getPasswordForUsername:kUserAccessUsername andServiceName:kUserAccessServicename error:nil];
//    if (accessIdInKeyChain) {
//        return accessIdInKeyChain;
//    }
//    
//    accessIdInKeyChain = [NSUUID UUID].UUIDString.md5;
//    [SFHFKeychainUtils storeUsername:kUserAccessUsername andPassword:accessIdInKeyChain forServiceName:kUserAccessServicename updateExisting:YES error:nil];
//    return accessIdInKeyChain;
//}

+ (BOOL)isRegistered {
    return [self userId] != nil;
}

+ (void)setRegisteredWithUserId:(NSString *)userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kRegisterKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 *  获取所有的支付信息
 *
 *  @return 返回支付信息数组
 */
+ (NSArray<PaymentInfo *> *)allPaymentInfos {
    NSArray<NSDictionary *> *paymentInfoArr = [[NSUserDefaults standardUserDefaults] objectForKey:kPaymentInfoKeyName];
    
    NSMutableArray *paymentInfos = [NSMutableArray array];
    [paymentInfoArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PaymentInfo *paymentInfo = [PaymentInfo paymentInfoFromDictionary:obj];
        [paymentInfos addObject:paymentInfo];
    }];
    return paymentInfos;
}

/**
 *  返回正在支付的信息
 *
 */
+ (NSArray<PaymentInfo *> *)payingPaymentInfos{
     NSMutableArray *PaymentArray = [NSMutableArray array];
    for (PaymentInfo *paymentInfo in self.allPaymentInfos) {
        if (paymentInfo.paymentStatus.unsignedIntegerValue == PaymentStatusPaying) {
            [PaymentArray addObject:paymentInfo];
        }
    }
    return PaymentArray;
}


/**
 *  返回成功支付的信息
 *
 */
+ (PaymentInfo *)successfulPaymentInfo{
    for (PaymentInfo *paymentInfo in self.allPaymentInfos) {
        if (paymentInfo.paymentResult.unsignedIntegerValue == PAYRESULT_SUCCESS) {
            return paymentInfo;
        }
    }
    return nil;
}

/**
 *  没有处理的
 *
 */
+ (NSArray<PaymentInfo *> *)paidNotProcessedPaymentInfos{
    NSMutableArray *PaymentArray = [NSMutableArray array];
    for (PaymentInfo *paymentInfo in self.allPaymentInfos) {
        if (paymentInfo.paymentStatus.unsignedIntegerValue==PaymentStatusNotProcessed) {
            [PaymentArray addObject:paymentInfo];
        }
        
    }
    return PaymentArray;
}
/**
 *  查询是否支付过
 *
 *  @return 返回支付YES/NO
 */
+ (BOOL)isPaid{
    for (PaymentInfo *paymentInfo in self.allPaymentInfos) {

        if (paymentInfo.paymentResult.unsignedIntegerValue == PAYRESULT_SUCCESS) {
            return YES;
        }
    }
    return NO;

}

+ (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRegisterKeyName];
}
/**
 *  手机信息
 *
 *  @return 手机信息参数
 */
+ (NSString *)deviceName {
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *name = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return name;
}


@end
