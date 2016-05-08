//
//  NSDictionary+KbSign.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/13.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Sign)

- (NSString *)concatenatedValues;
- (NSString *)concatenatedValuesWithKeys:(NSArray *)keys;
- (NSString *)signWithDictionary:(NSDictionary *)dic keyOrders:(NSArray *)keys;

- (NSDictionary *)encryptedDictionarySignedTogetherWithDictionary:(NSDictionary *)dicForSignTogether
                                                        keyOrders:(NSArray *)keys
                                                  passwordKeyName:(NSString *)pwdKeyName;
- (NSString *)encryptedStringWithSign:(NSString *)sign
                             password:(NSString *)pwd
                          excludeKeys:(NSArray *)excludedKeys;

- (NSString *)encryptedStringWithSign:(NSString *)sign
                             password:(NSString *)pwd
                          excludeKeys:(NSArray *)excludedKeys
                    shouldIncludeSign:(BOOL)shouldIncludeSign;
@end

extern NSString *const kParamKeyName;
extern NSString *const kEncryptionKeyName;
extern NSString *const kEncryptionDataName;