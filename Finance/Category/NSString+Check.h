//
//  NSString-Check.h
//  Finance
//
//  Created by HuMin on 15/4/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#include <sys/sysctl.h>
@interface NSString (Check)

//第一个是否为数字1
- (BOOL)isFirstIsNumOne;

/*邮箱验证 MODIFIED BY HELENSONG*/
-(BOOL)isValidateEmail;

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidateMobile;

//判断是否是几种组合
- (BOOL)isRightUserPassword;

//长度小于
- (BOOL)isLengthUnderGivenLengthlength:(int)length;

//长度超过
- (BOOL)isLengthOverGivenLengthlength:(int)length;

//- (BOOL)isHaveCharacter:(NSString *)tmpString;

//是否为空
- (BOOL)isStringNull;
//有空格
//- (BOOL)isHaveSpace:(NSString *)tmpString;
//有中文
//- (BOOL)isHaveChinese:(NSString *)tmpString;
//连续相同字符
- (BOOL)isAllSameChars;
//联系递增字符
- (BOOL)hasAllIncreaseChars;

- (CGSize) adjustWithFont:(UIFont*) font WithText:(NSString *) text WithSize:(CGSize) size;

//连续递减字符
- (BOOL)hasAllDecreaseChars;
//是否为整数
- (BOOL)isNumText;
//是否为数字
- (BOOL)isaNumText;
//有数字
//- (BOOL)isHaveNum:(NSString *)tmpString;
//有字母
//- (BOOL)isHaveWord:(NSString *)tmpString;

-(BOOL)isRightUserName;
- (id)parseToArrayOrNSDictionary;
- (NSString *)md5;


- (CGSize)sizeForFont:(UIFont*)font
     constrainedToSize:(CGSize)constraint
         lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)sizeForFont:(UIFont *)font;
- (CGSize)sizeWithSize:(CGSize)size font:(UIFont *)font;
- (NSString *)validLength;
- (NSString *)validPhone;

@end
