//
//  HttpRequestModel.m
//  WeChatPay-Demo
//
//  Created by ZF on 16/4/17.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import "HttpRequestModel.h"
#import "AFNetworking.h"
#import "CommonSet.h"
#import "HttpResponseModel.h"
@interface HttpRequestModel ()
@property (nonatomic,retain) AFHTTPRequestOperationManager *requestOpManager;
@property (nonatomic,retain) AFHTTPRequestOperation *requestOp;

@property (nonatomic,retain) AFHTTPRequestOperationManager *standbyRequestOpManager;
@property (nonatomic,retain) AFHTTPRequestOperation *standbyRequestOp;

-(BOOL)requestURLPath:(NSString *)urlPath
           withParams:(NSDictionary *)params
            isStandby:(BOOL)isStandBy
    shouldNotifyError:(BOOL)shouldNotifyError
      responseHandler:(URLResponseHandler)responseHandler;
@end
@implementation HttpRequestModel

+ (Class)responseClass {
    return [HttpResponseModel class];
}

+ (BOOL)shouldPersistURLResponse {
    return NO;
}

+ (NSString *)persistenceFilePath {
    NSString *fileName = NSStringFromClass([self responseClass]);
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.plist", [NSBundle mainBundle].resourcePath, fileName];
    return filePath;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([[[self class] responseClass] isSubclassOfClass:[HttpResponseModel class]]) {
            NSDictionary *lastResponse = [NSDictionary dictionaryWithContentsOfFile:[[self class] persistenceFilePath]];
            if (lastResponse) {
                HttpResponseModel *urlResponse = [[[[self class] responseClass] alloc] init];
                [urlResponse parseResponseWithDictionary:lastResponse];
                self.response = urlResponse;
            }
        }
        
    }
    return self;
}
/**
 *  baseURL
 *
 *  @return 返回根路径
 */
- (NSURL *)baseURL {
    return [NSURL URLWithString:kBASE_URL];
}
/**
 *  备用根路径
 *
 *  @return 返回备用根路径
 */
- (NSURL *)standbyBaseURL {
    return [NSURL URLWithString:kSTANDBY_BASE_URL];
}

- (BOOL)shouldPostErrorNotification {
    return YES;
}
/**
 *  请求方式
 *
 *  @return 返回请求方式
 */
- (URLRequestMethod)requestMethod {
    return URLGetRequest;
}
#pragma mark - 数据请求管理者
/**
 *  数据请求管理者
 *
 *  @return 返回管理者
 */
-(AFHTTPRequestOperationManager *)requestOpManager {
    if (_requestOpManager) {
        return _requestOpManager;
    }
    
    _requestOpManager = [[AFHTTPRequestOperationManager alloc]
                         initWithBaseURL:[self baseURL]];
    //    _requestOpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    return _requestOpManager;
}

- (AFHTTPRequestOperationManager *)standbyRequestOpManager {
    if (_standbyRequestOpManager) {
        return _standbyRequestOpManager;
    }
    
    _standbyRequestOpManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[self standbyBaseURL]];
    return _standbyRequestOpManager;
}
#pragma mark - 外界数据请求的接口
/**
 *  外界数据请求的接口
 *
 *  @param urlPath           请求路径
 *  @param params            请求参数
 *  @param isStandBy         是否是备用路径
 *  @param shouldNotifyError 是否错误提示
 *  @param responseHandler   数据返回响应
 *
 *  @return 返回数据请求成功/失败
 */
-(BOOL)requestURLPath:(NSString *)urlPath
           withParams:(NSDictionary *)params
            isStandby:(BOOL)isStandBy
    shouldNotifyError:(BOOL)shouldNotifyError
      responseHandler:(URLResponseHandler)responseHandler
{
    if (urlPath.length == 0) {
        if (responseHandler) {
            responseHandler(URLResponseFailedByParameter, nil);
        }
        return NO;
    }
    
    DLog(@"Requesting %@ !\nwith parameters: %@\n", urlPath, params);
    
    @weakify(self);
    self.response = [[[[self class] responseClass] alloc] init];//subClass
    
    void (^success)(AFHTTPRequestOperation *,id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);
        
        DLog(@"Response for %@ : %@\n", urlPath, responseObject);
        [self processResponseObject:responseObject withResponseHandler:responseHandler];
    };
    
    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error for %@ : %@\n", urlPath, error.localizedDescription);
        
        if (shouldNotifyError) {
            if ([self shouldPostErrorNotification]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkErrorNotification
                                                                    object:self
                                                                  userInfo:@{kNetworkErrorCodeKey:@(URLResponseFailedByNetwork),
                                                                             kNetworkErrorMessageKey:error.localizedDescription}];
            }
        }
        
        if (responseHandler) {
            responseHandler(URLResponseFailedByNetwork,error.localizedDescription);
        }
    };
    
    AFHTTPRequestOperation *requestOp;
    if (self.requestMethod == URLGetRequest) {
        requestOp = [isStandBy?self.standbyRequestOpManager:self.requestOpManager GET:urlPath parameters:params success:success failure:failure];
    } else {
        requestOp = [isStandBy?self.standbyRequestOpManager:self.requestOpManager POST:urlPath parameters:params success:success failure:failure];
    }
    
    if (isStandBy) {
        self.standbyRequestOp = requestOp;
    } else {
        self.requestOp = requestOp;
    }
    return YES;
}


/**
 *  请求接口
 *
 *  @param urlPath         请求路径
 *  @param params          请求参数
 *  @param responseHandler 响应回调
 *
 *  @return 返回请求成功/失败
 */
-(BOOL)requestURLPath:(NSString *)urlPath withParams:(NSDictionary *)params responseHandler:(URLResponseHandler)responseHandler
{
    return [self requestURLPath:urlPath withParams:params isStandby:NO shouldNotifyError:YES responseHandler:responseHandler];
    
}

/**
 *  处理json返回的数据
 *
 *  @param responseObject  返回的json数据
 *  @param responseHandler 回调
 */
- (void)processResponseObject:(id)responseObject withResponseHandler:(URLResponseHandler)responseHandler {
    URLResponseStatus status = URLResponseNone;
    NSString *errorMessage;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if ([self.response isKindOfClass:[HttpResponseModel class]]) {
            HttpResponseModel *urlResp = self.response;
            [urlResp parseResponseWithDictionary:responseObject];
            
            status = urlResp.success.boolValue ? URLResponseSuccess : URLResponseFailedByInterface;
            errorMessage = (status == URLResponseSuccess) ? nil : [NSString stringWithFormat:@"ResultCode: %@", urlResp.resultCode];
        } else {
            status = URLResponseFailedByParsing;
            errorMessage = @"Parsing error: incorrect response class for JSON dictionary.\n";
        }
        ////////////////////////////////////////////////////////////////////////////
        if ([[self class] shouldPersistURLResponse]) {//是否存储返回的结果
            NSString *filePath = [[self class] persistenceFilePath];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (![((NSDictionary *)responseObject) writeToFile:filePath atomically:YES]) {
                    DLog(@"Persist response object fails!");
                }
            });
        }
        ////////////////////////////////////////////////////////////////////////////
    } else if ([responseObject isKindOfClass:[NSString class]]) {
        if ([self.response isKindOfClass:[NSString class]]) {
            self.response = responseObject;
            status = URLResponseSuccess;
        } else {
            status = URLResponseFailedByParsing;
            errorMessage = @"Parsing error: incorrect response class for JSON string.\n";
        }
    } else {
        errorMessage = @"Error data structure of response from interface!\n";
        status = URLResponseFailedByInterface;
    }
    
    if (status != URLResponseSuccess) {
        DLog(@"Error message : %@\n", errorMessage);
        
        if ([self shouldPostErrorNotification]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkErrorNotification
                                                                object:self
                                                              userInfo:@{kNetworkErrorCodeKey:@(status),
                                                                         kNetworkErrorMessageKey:errorMessage}];
        }
    }
    
    if (responseHandler) {
        responseHandler(status, errorMessage);
    }
    
}

@end
