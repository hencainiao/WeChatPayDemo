//
//  CommonSet.h
//  WeChatPay-Demo
//
//  Created by ZF on 16/4/17.
//  Copyright © 2016年 ZF. All rights reserved.
//

#ifndef CommonSet_h
#define CommonSet_h
// DLog
#ifdef  DEBUG
#define DLog(fmt,...) {NSLog((@"%s [Line:%d]" fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__);}
#else
#define DLog(...)
#endif

#define SYS_FONT(x)     [UIFont systemFontOfSize:x];
#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:1.]
#define IS_IOS7_LATER   ([UIDevice currentDevice].systemVersion.floatValue > 6.99)
#define IS_4_INCH   (([UIScreen mainScreen].bounds.size.height == 568)?YES:NO)
#define IS_IPHONE_4 (([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 480)?YES:NO)
#define IS_IPHONE_5 (([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 568)?YES:NO)
#define IS_RETINA_DISPLAY_DEVICE (([UIScreen mainScreen].scale == 2.f)?YES:NO)

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MB_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define MB_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

#define LocalizedStr(key)  NSLocalizedString(key, @"")

#define DefineLazyPropertyInitialization(propertyType, propertyName) \
-(propertyType *)propertyName { \
if (_##propertyName) { \
return _##propertyName; \
} \
_##propertyName = [[propertyType alloc] init]; \
return _##propertyName; \
}



#define TABBAR_TEXT_NOR_COLOR       RGB(66, 72, 96)
#define TABBAR_TEXT_HLT_COLOR       RGB(238,76,72)//RGB(232, 60, 40)

#import "RACEXTScope.h"
#define kBASE_URL                  @""
#define kSTANDBY_BASE_URL          @""
#define kNetworkErrorNotification  @"kNetworkErrorNotification"
#define kNetworkErrorCodeKey       @"kNetworkErrorCodeKey"
#define kNetworkErrorMessageKey    @"kNetworkErrorMessageKey"
#define kAPP_ID                    @""
#define kCHANNEL_NO                @""
#define kAPP_PV                    @""

#define KB_WECHATPAY_CONFIG_URL @"/iosvideo/weixinConfig.htm"
#define KB_STANDBY_WECHATPAY_CONFIG_URL @"/iosvideo/aliConfig.json"

typedef void (^CompletionHandler)(BOOL success, id obj);
typedef NS_ENUM(NSInteger, PAYRESULT)
{
    PAYRESULT_SUCCESS   = 0,
    PAYRESULT_FAIL      = 1,
    PAYRESULT_ABANDON   = 2,
    PAYRESULT_UNKNOWN   = 3
};
typedef NS_ENUM(NSUInteger, PaymentType) {
    PaymentTypeNone,
    PaymentTypeAlipay = 1001,
    PaymentTypeWeChatPay = 1008,
    PaymentTypeIAppPay = 1009
};
#endif /* CommonSet_h */
