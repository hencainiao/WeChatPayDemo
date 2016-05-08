//
//  HttpResponseModel.h
//  WeChatPay-Demo
//
//  Created by ZF on 16/4/17.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpResponseModel : NSObject

@property (nonatomic) NSNumber *success;
@property (nonatomic) NSString *resultCode;

/**
 *  解析从后台获取的数据
 *
 *  @param dic 从后台获取的字典参数
 */
- (void)parseResponseWithDictionary:(NSDictionary *)dic;
@end
