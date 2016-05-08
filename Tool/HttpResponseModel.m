//
//  HttpResponseModel.m
//  WeChatPay-Demo
//
//  Created by ZF on 16/4/17.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import "HttpResponseModel.h"
#import <objc/runtime.h>
#import "NSObject+Properties.h"
#import "CommonSet.h"
@implementation HttpResponseModel
#pragma mark - 解析返回的数据
/**
 *  解析json数据
 *
 *  @param dic 字典类型的json数据
 */
- (void)parseResponseWithDictionary:(NSDictionary *)dic {
    [self parseDataWithDictionary:dic inInstance:self];
}

/**
 *  解析响应的数据
 *
 *  @param dic      响应数据
 *  @param instance 参数模型
 */
- (void)parseDataWithDictionary:(NSDictionary *)dic inInstance:(id)instance {
    if (!dic || !instance) {
        return ;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSArray *properties = [NSObject propertiesOfClass:[instance class]];
    [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *propertyName = (NSString *)obj;
        
        id value = [dic objectForKey:propertyName];
        if ([value isKindOfClass:[NSString class]]
            || [value isKindOfClass:[NSNumber class]]) {
            [instance setValue:value forKey:propertyName];//给每个属性赋值
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            id property = [instance valueForKey:propertyName];
            Class subclass = [property class];
            if (!subclass) {
                NSString *classPropertyName = [propertyName stringByAppendingString:@"Class"];
                subclass = [instance valueForKey:classPropertyName];
            }
            id subinstance = [[subclass alloc] init];
            [instance setValue:subinstance forKey:propertyName];//给每个属性赋值
            
            [self parseDataWithDictionary:(NSDictionary *)value inInstance:subinstance];
        } else if ([value isKindOfClass:[NSArray class]]) {
            Class subclass = [instance valueForKey:[propertyName stringByAppendingString:@"ElementClass"]];//KVC取值
            //            Class subclass;
            //
            //           NSString *methordString = [propertyName stringByAppendingString:@"ElementClass"];
            //            NSLog(@"%@",methordString);
            //            unsigned int count = 0;
            //            Method *memberFuncs = class_copyMethodList([instance class], &count);//所有在.m文件所有实现的方法都会被找到
            //            for (int i = 0; i < count; i++) {
            //                SEL selname = method_getName(memberFuncs[i]);
            //
            //                NSString *methodName = [NSString stringWithCString:sel_getName(selname) encoding:NSUTF8StringEncoding];
            //                NSLog(@"member method:%@", methodName);
            //                if ([methodName isEqualToString:methordString]) {
            //                   subclass = (Class)[instance performSelector:selname];
            //                   break;
            //                }
            //
            //            }
            
            if (!subclass) {
                
                DLog(@"JSON Parsing Warning: cannot find element class of property: %@ in class: %@\n", propertyName, [[instance class] description]);
                return;
            }
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [instance setValue:arr forKey:propertyName];
            
            for (NSDictionary *subDic in (NSArray *)value) {
                id subinstance = [[subclass alloc] init];
                [arr addObject:subinstance];
                [self parseDataWithDictionary:subDic inInstance:subinstance];
            }
        }
    }];
#pragma clang diagnostic pop
}

@end
