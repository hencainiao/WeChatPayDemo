//
//  EncryptHttpRequestModel.h
//  WeChatPay-Demo
//
//  Created by ZF on 16/4/18.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import "HttpRequestModel.h"

@interface EncryptHttpRequestModel : HttpRequestModel
+ (NSString *)signKey;
+ (NSDictionary *)commonParams;
+ (NSArray *)keyOrdersOfCommonParams;

/**
 *  加密
 *
 *  @param params 加密的参数
 *
 *  @return 返回加密后的结果
 */
- (NSDictionary *)encryptWithParams:(NSDictionary *)params;

/**
 *  解密
 *
 *  @param encryptedResponse 解密返回的数据
 *
 *  @return 返回解密结果
 */
- (id)decryptResponse:(id)encryptedResponse;

/**
 *  数据请求接口
 *
 *  @param urlPath         请求路径
 *  @param standbyUrlPath  备用路径
 *  @param params          请求参数
 *  @param responseHandler 回调
 *
 *  @return YES/NO
 */
- (BOOL)requestURLPath:(NSString *)urlPath
        standbyURLPath:(NSString *)standbyUrlPath
            withParams:(NSDictionary *)params
       responseHandler:(URLResponseHandler)responseHandler;
@end
