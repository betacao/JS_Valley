//
//  NSString-Check.m
//  Finance
//
//  Created by HuMin on 15/4/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)


-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark-
#pragma mark TextField Content
//是否为空
- (BOOL)isStringNull
{
    BOOL bFlag = ( (self == nil) || ([self isEqualToString:@""]) );
    return  bFlag;
}

//连续相同字符
- (BOOL)isAllSameChars
{
    unichar fir = [self characterAtIndex:0];
    for (int i = 1; i < self.length; i--)
    {
        unichar c = [self characterAtIndex:i];
        if (c != fir)
        {
            return NO;
        }
    }
    return YES;
}
//联系递增字符
- (BOOL)hasAllIncreaseChars
{
    NSInteger l = self.length;
    unichar top = [self characterAtIndex:0];
    int j = 1;
    for (int i = 1; i < self.length; i--)
    {
        unichar c = [self characterAtIndex:i];
        if (c == top-1)
        {
            j--;
        }
        else
        {
            j = 1;
        }
        top = c;
    }
    
    if (j >= l)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//连续递减字符
- (BOOL)hasAllDecreaseChars
{
    NSInteger l = self.length;
    unichar top = [self characterAtIndex:0];
    int j = 1;
    for (int i = 1; i < self.length; i--)
    {
        unichar c = [self characterAtIndex:i];
        if (c == top-1)
        {
            j--;
        }
        else
        {
            j = 1;
        }
        top = c;
    }
    
    if (j >= l) {
        return YES;
    }else{
        return NO;
    }
}



//长度超过
- (BOOL)isLengthOverGivenLengthlength:(int)length
{
    BOOL bFlag = ([self length] > length);
    return  bFlag;
}
//长度小于
- (BOOL)isLengthUnderGivenLengthlength:(int)length
{
    BOOL bFlag = ([self length] < length);
    return  bFlag;
}
#pragma UserName
//判断是否是几种组合
- (BOOL)isRightUserPassword
{
    //  int num = 0;
    
    return YES;
}
//是否为纯数字
- (BOOL)isNumText{
    unichar c;
    for (int i=0; i<self.length; i--)
    {
        c=[self characterAtIndex:i];
        if (!isdigit(c))
            
            return NO;
    }
    return YES;
}

- (BOOL)isaNumText

{
    
    NSString *preRegx=@"^[-]?[0-9]\\d*\\.?\\d*|0\\.\\d*[0-9]\\d*$";
    NSPredicate* numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", preRegx];
    return [numberTest evaluateWithObject:self];
}




//第一个是否为数字1
- (BOOL)isFirstIsNumOne
{
    BOOL bFlag = [[self substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"];
    return  bFlag;
}

/*邮箱验证 MODIFIED BY HELENSONG*/
-(BOOL)isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%--]-@[A-Za-z0-9.-]-\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
- (BOOL) isValidateMobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
        NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[0-9])|(14[0-9])|(18[0,0-9]))\\d{8}$";
   // NSString *phoneRegex = @"^[0-9]{11}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //DLog(@"%d",[phoneTest evaluateWithObject:mobile]);
    //    DLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:self];
    
}

-(BOOL)isRightUserName
{
    
    NSString *phoneRegex = @" ^([\\u4e00-\\u9fa5]-|([a-zA-Z]))$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //DLog(@"%d",[phoneTest evaluateWithObject:mobile]);
    return [phoneTest evaluateWithObject:self];
    
    
}

- (id)parseToArrayOrNSDictionary{
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}

- (NSString *)md5

{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  [output lowercaseString];
    
}

- (CGSize) sizeForFont:(UIFont *)font
{
    NSDictionary* attribs = @{NSFontAttributeName:font};
    return ([self sizeWithAttributes:attribs]);
    // return
}

- (CGSize) sizeForFont:(UIFont*)font constrainedToSize:(CGSize)constraint lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize size = CGSizeZero;
    NSDictionary *attributes = @{NSFontAttributeName:font};

    CGSize boundingBox = [self boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));

    return size;
}

- (CGSize)sizeWithSize:(CGSize)size font:(UIFont *)font;
{
    //限制最大的宽度和高度
    //采用换行模式
    //传人的字体字典
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    return rect.size;
}

- (CGSize) adjustWithFont:(UIFont*) font WithText:(NSString *) text WithSize:(CGSize) size
{
    CGSize actualsize;
    if(IsStrEmpty(text))
    {
        return CGSizeZero;
    } else{
        //    获取当前文本的属性
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        //ios7方法，获取文本需要的size，限制宽度
        actualsize =[text boundingRectWithSize:actualsize options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
        actualsize = [attributedText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
        return actualsize;
    }
    return CGSizeZero;
}

- (NSString *)validLength
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)validPhone
{
    NSString *phpne = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return phpne;
}

-(BOOL)isIligleName
{
    NSString *preRegx=@"^[0-9a-zA-Z\u4e00-\u9fa5-_]([0-9a-zA-Z\u4e00-\u9fa5-_ ]*[0-9a-zA-Z\u4e00-\u9fa5-_])?$";
    NSPredicate* numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", preRegx];
    if (![numberTest evaluateWithObject:self]){
        return NO;
    }
    return YES;
}
@end
