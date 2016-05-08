//
//  WeChatPayConfigModel.h
//  kuaibov
//
//  Created by Sean Yue on 16/1/8.
//  Copyright © 2016年 kuaibov. All rights reserved.
//

#import "EncryptHttpRequestModel.h"
#import "WeChatPayConfig.h"
#import "CommonSet.h"
@interface WeChatPayConfigModel : EncryptHttpRequestModel

+ (instancetype)sharedModel;
/**
 *  获取微信支付的配参数的接口
 *
 *  @param handler 响应回调Block
 *
 *  @return 返回成功/失败
 */
- (BOOL)fetchWeChatPayConfigWithCompletionHandler:(CompletionHandler)handler;

@end
