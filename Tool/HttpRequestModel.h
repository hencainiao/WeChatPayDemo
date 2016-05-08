//
//  HttpRequestModel.h
//  WeChatPay-Demo
//
//  Created by ZF on 16/4/17.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, URLResponseStatus) {
    URLResponseSuccess,
    URLResponseFailedByInterface,
    URLResponseFailedByNetwork,
    URLResponseFailedByParsing,
    URLResponseFailedByParameter,
    URLResponseNone
};

typedef NS_ENUM(NSUInteger, URLRequestMethod) {
    URLGetRequest,
    URLPostRequest
};

/**
 *  响应block
 *
 *  @param respStatus   响应状态
 *  @param errorMessage 错误信息
 */
typedef void (^URLResponseHandler)(URLResponseStatus respStatus, NSString *errorMessage);


@interface HttpRequestModel : NSObject

/**
 *  数据请求返回的结果，子类调用setter/getter方法返回子类的类型数据
 */
@property (nonatomic,retain) id response;


/**
 *   override this method to provide a custom class to be used when instantiating instances of URLResponse
 *
 *  @return 返回的class类型
 */
+ (Class)responseClass;


/**
 *  是否对数据进行本地保存
 *
 *  @return 返回YES/NO
 */
+ (BOOL)shouldPersistURLResponse;


/**
 *  override this method to provide a custom base URL to be used
 *
 *  @return 返回baseURL
 */
- (NSURL *)baseURL;


/**
 *  override this method to provide a custom standby base URL to be used
 *
 *  @return 返回standbyBaseURL
 */
- (NSURL *)standbyBaseURL;

/**
 *  是否通知失败
 *
 *  @return
 */
- (BOOL)shouldPostErrorNotification;

/**
 *  数据请求方式
 *
 *  @return
 */
- (URLRequestMethod)requestMethod;

/**
 *  数据请求接口1
 *
 *  @param urlPath           请求路径
 *  @param params            请求参数
 *  @param isStandBy         是否是备用的路径
 *  @param shouldNotifyError 是否错误提示
 *  @param responseHandler   响应回调block
 *
 *  @return 返回是否获取数据成功
 */
- (BOOL)requestURLPath:(NSString *)urlPath
            withParams:(NSDictionary *)params
             isStandby:(BOOL)isStandBy
     shouldNotifyError:(BOOL)shouldNotifyError
       responseHandler:(URLResponseHandler)responseHandler;

/**
 *  数据请求接口2
 *
 *  @param urlPath         请求路径
 *  @param params          参数
 *  @param responseHandler 响应回调block
 *
 *  @return 返回是否获取数据成功
 */
- (BOOL)requestURLPath:(NSString *)urlPath
            withParams:(NSDictionary *)params
       responseHandler:(URLResponseHandler)responseHandler;


//- (BOOL)requestURLPath:(NSString *)urlPath standbyURLPath:(NSString *)standbyUrlPath withParams:(NSDictionary *)params responseHandler:(URLResponseHandler)responseHandler;


/**
 *  For subclass pre/post processing response object
 *
 *  @param responseObject  响应返回的数据
 *  @param responseHandler 响应回调block
 */
- (void)processResponseObject:(id)responseObject withResponseHandler:(URLResponseHandler)responseHandler;
@end
