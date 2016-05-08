//
//  EncryptHttpRequestModel.m
//  WeChatPay-Demo
//
//  Created by ZF on 16/4/18.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import "EncryptHttpRequestModel.h"
#import "NSString+crypt.h"
#import "NSDictionary+Sign.h"
#import "CommonSet.h"
static NSString *const kEncryptionPasssword = @"f7@j3%#5aiG$4";
@implementation EncryptHttpRequestModel
+ (NSString *)signKey {
    return kEncryptionPasssword;
}
/**
 *  @return 返回共有参数键值对
 */
+ (NSDictionary *)commonParams {
    return @{@"appId":kAPP_ID,
             kEncryptionKeyName:[self class].signKey,
             @"imsi":@"999999999999999",
             @"channelNo":kCHANNEL_NO,
             @"pV":kAPP_PV
             };
}
/**
 *  共有参数key
 *
 *  @return 返回共有的参数key
 */
+ (NSArray *)keyOrdersOfCommonParams {
    return @[@"appId",kEncryptionKeyName,@"imsi",@"channelNo",@"pV"];
}

/**
 *  加密
 *
 *  @param params 加密参数
 *
 *  @return 返回加密后的参数
 */
- (NSDictionary *)encryptWithParams:(NSDictionary *)params {
    NSMutableDictionary *mergedParams = params ? params.mutableCopy : [NSMutableDictionary dictionary];
    NSDictionary *commonParams = [[self class] commonParams];
    if (commonParams) {
        [mergedParams addEntriesFromDictionary:commonParams];
    }
    
    return [mergedParams encryptedDictionarySignedTogetherWithDictionary:commonParams keyOrders:[[self class] keyOrdersOfCommonParams] passwordKeyName:kEncryptionKeyName];
}

/**
 *  数据请求
 *
 *  @param urlPath         路径
 *  @param params          参数
 *  @param responseHandler 回调
 *
 *  @return 
 */
- (BOOL)requestURLPath:(NSString *)urlPath
            withParams:(NSDictionary *)params
       responseHandler:(URLResponseHandler)responseHandler {
    
    return [self requestURLPath:urlPath
                 standbyURLPath:nil
                     withParams:params
                responseHandler:responseHandler];
}
#pragma mark - 外界数据请求接口
/**
 *  外界数据请求接口
 *
 *  @param urlPath         请求路径
 *  @param standbyUrlPath  备用路径
 *  @param params          请求参数
 *  @param responseHandler 回调
 *
 *  @return 返回请求成功/失败
 */
- (BOOL)requestURLPath:(NSString *)urlPath
        standbyURLPath:(NSString *)standbyUrlPath
            withParams:(NSDictionary *)params
       responseHandler:(URLResponseHandler)responseHandler
{
    BOOL willUseStandby = standbyUrlPath.length > 0;
    
    NSDictionary *encryptedParams = [self encryptWithParams:params];
    
    @weakify(self);
    BOOL ret = [self requestURLPath:urlPath
                         withParams:encryptedParams
                          isStandby:NO
                  shouldNotifyError:!willUseStandby
                    responseHandler:^(URLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    
                    if (willUseStandby && respStatus == URLResponseFailedByNetwork) {
                        [self requestURLPath:standbyUrlPath withParams:params isStandby:YES shouldNotifyError:YES responseHandler:responseHandler];
                    } else {
                        if (responseHandler) {
                            responseHandler(respStatus, errorMessage);
                        }
                    }
                }];
    return ret;
}
/**
 *  解密
 *
 *  @param encryptedResponse 被加密的返回数据
 *
 *  @return 返回解密结果
 */
- (id)decryptResponse:(id)encryptedResponse {
    if (![encryptedResponse isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSDictionary *originalResponse = (NSDictionary *)encryptedResponse;
    NSArray *keys = [originalResponse objectForKey:kEncryptionKeyName];
    NSString *dataString = [originalResponse objectForKey:kEncryptionDataName];
    if (!keys || !dataString) {
        return nil;
    }
    
    NSString *decryptedString = [dataString decryptedStringWithKeys:keys];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[decryptedString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];//json解析解密之后的数据
    if (jsonObject == nil) {
        jsonObject = decryptedString;
    }
    return jsonObject;
}

/**
 *  处理请求返回的数据
 *
 *  @param responseObject  返回数据
 *  @param responseHandler 回调
 */
- (void)processResponseObject:(id)responseObject withResponseHandler:(URLResponseHandler)responseHandler {
    
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        [super processResponseObject:nil withResponseHandler:responseHandler];
        return ;
    }
    
    id decryptedResponse = [self decryptResponse:responseObject];//解密
    DLog(@"Decrypted response: %@", decryptedResponse);
    [super processResponseObject:decryptedResponse withResponseHandler:responseHandler];//这一步是吧json数据转成对应的模型分给各个model
}

@end
