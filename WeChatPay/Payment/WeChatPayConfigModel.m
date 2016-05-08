//
//  WeChatPayConfigModel.m
//  kuaibov
//
//  Created by Sean Yue on 16/1/8.
//  Copyright © 2016年 kuaibov. All rights reserved.
//

#import "WeChatPayConfigModel.h"

@implementation WeChatPayConfigModel

+ (instancetype)sharedModel {
    static WeChatPayConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [WeChatPayConfig class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}
/**
 *  从后台获取微信支付的配置参数
 *
 *  @param handler 回调block
 *
 *  @return 返回获取成功/失败
 */

- (BOOL)fetchWeChatPayConfigWithCompletionHandler:(CompletionHandler)handler {
    @weakify(self);
    
    BOOL ret = [self requestURLPath:KB_WECHATPAY_CONFIG_URL
                     standbyURLPath:KB_STANDBY_WECHATPAY_CONFIG_URL
                         withParams:nil
                    responseHandler:^(URLResponseStatus respStatus, NSString *errorMessage)
    {
        
        @strongify(self);
        
        WeChatPayConfig *config;
        if (respStatus == URLResponseSuccess) {
            config = self.response;
            [config saveAsDefaultConfig];
        }
        
        if (handler) {
            handler(respStatus==URLResponseSuccess, config);
        }
    }];
    return ret;
}

@end
