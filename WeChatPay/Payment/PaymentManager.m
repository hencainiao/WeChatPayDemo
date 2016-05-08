//
//  PaymentManager.m
//  kuaibov
//
//  Created by Sean Yue on 16/3/11.
//  Copyright © 2016年 kuaibov. All rights reserved.
//

#import "PaymentManager.h"
#import "PaymentInfo.h"
#import "NSString+md5.h"
#import "Util.h"
#import "WXApi.h"
#import "WeChatPayManager.h"
#import "WeChatPayConfigModel.h"
#import "PaymentInfo.h"
#import "WeChatPayConfig.h"
#import "WeChatPayQueryOrderRequest.h"
#import "MyPaymentViewController.h"
@interface PaymentManager ()<WXApiDelegate>
@property (nonatomic,strong) WeChatPayQueryOrderRequest *WeChatPayQueryOrderRequest;
@property (nonatomic,retain) PaymentInfo *paymentInfo;
@property (nonatomic,copy) PaymentCompletionHandler completionHandler;
@end

@implementation PaymentManager

+ (instancetype)sharedManager {
    static PaymentManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}
/**
 *  设置基本参数
 */
- (void)setup {
    
    
    [[WeChatPayConfigModel sharedModel] fetchWeChatPayConfigWithCompletionHandler:^(BOOL success, id obj) {
         [WXApi registerApp:[WeChatPayConfig defaultConfig].appId];
    }];
   
}

/**
 *  回调打开url
 *
 *  @param url 从appdelegate中传入的url
 */
- (void)handleOpenURL:(NSURL *)url {
    
     [WXApi handleOpenURL:url delegate:self];
    
}

/**
 *  爱贝支付
 *
 *  @param type    爱贝支付／微信支付
 *  @param subType 爱贝支付中的微信支付／支付宝支付
 *  @param price   金额
 *  @param handler 回调
 *
 *  @return 支付成功失败
 */
- (BOOL)startPaymentWithType:(PaymentType)type
                     subType:(PaymentType)subType
                       price:(NSUInteger)price
           completionHandler:(PaymentCompletionHandler)handler
{
    if (type == PaymentTypeNone || (type == PaymentTypeIAppPay && subType == PaymentTypeNone)) {
        if (self.completionHandler) {
            self.completionHandler(PAYRESULT_FAIL, nil);
        }
        return NO;
    }
    
    NSString *channelNo = kCHANNEL_NO;
    channelNo = [channelNo substringFromIndex:channelNo.length-14];
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
    
    PaymentInfo *paymentInfo = [[PaymentInfo alloc] init];
    paymentInfo.orderId = orderNo;
    paymentInfo.orderPrice = @(price);
    paymentInfo.paymentType = @(type);
    paymentInfo.paymentResult = @(PAYRESULT_UNKNOWN);
    paymentInfo.paymentStatus = @(PaymentStatusPaying);

    
    if (type == PaymentTypeWeChatPay) {
        paymentInfo.appId = [WeChatPayConfig defaultConfig].appId;
        paymentInfo.mchId = [WeChatPayConfig defaultConfig].mchId;
        paymentInfo.signKey = [WeChatPayConfig defaultConfig].signKey;
        paymentInfo.notifyUrl = [WeChatPayConfig defaultConfig].notifyUrl;
    }
    
    [paymentInfo save];
    self.paymentInfo = paymentInfo;
    self.completionHandler = handler;
    
    BOOL success = YES;
    if (type == PaymentTypeWeChatPay) {
        @weakify(self);
        
        [[WeChatPayManager sharedInstance] startWithPayment:paymentInfo completionHandler:^(PAYRESULT payResult) {
            @strongify(self);
            if (self.completionHandler) {
                self.completionHandler(payResult, self.paymentInfo);
            }
        }];
    }else {
        success = NO;
        
        if (self.completionHandler) {
            self.completionHandler(PAYRESULT_FAIL, self.paymentInfo);
        }
    }
    
    
    return success;
}


- (void)checkPayment {
    
    if ([Util isPaid]) {
        return;
    };
    
    NSArray<PaymentInfo *> *payingPaymentInfos = [Util payingPaymentInfos];
    [payingPaymentInfos enumerateObjectsUsingBlock:^(PaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PaymentType paymentType = obj.paymentType.unsignedIntegerValue;
        if (paymentType == PaymentTypeWeChatPay) {
            if (obj.appId.length == 0 || obj.mchId.length == 0 || obj.signKey.length == 0 || obj.notifyUrl.length == 0) {
                obj.appId = [WeChatPayConfig defaultConfig].appId;
                obj.mchId = [WeChatPayConfig defaultConfig].mchId;
                obj.signKey = [WeChatPayConfig defaultConfig].signKey;
                obj.notifyUrl = [WeChatPayConfig defaultConfig].notifyUrl;
            }
            [self.WeChatPayQueryOrderRequest queryPayment:obj completionHandler:^(BOOL success, NSString *trade_state, double total_fee) {
                
                if ([trade_state isEqualToString:@"SUCCESS"]) {
                    //这个地方要为单利保证里面的参数是同一个
                    MyPaymentViewController *paymentVC = [MyPaymentViewController sharedPaymentVC];
                    [paymentVC notifyPaymentResult:PAYRESULT_SUCCESS withPaymentInfo:obj];
                }

            }];
            
        }
    }];
}
#pragma mark - WeChat delegate

- (void)onReq:(BaseReq *)req {
    
}

/**
 *  从微信回来会调用这个代理方法
 *
 *  @param resp 
 */
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        PAYRESULT payResult;
        if (resp.errCode == WXErrCodeUserCancel) {
            payResult = PAYRESULT_ABANDON;
        } else if (resp.errCode == WXSuccess) {
            payResult = PAYRESULT_SUCCESS;
        } else {
            payResult = PAYRESULT_FAIL;
        }
        [[WeChatPayManager sharedInstance] sendNotificationByResult:payResult];
    }
}

@end
