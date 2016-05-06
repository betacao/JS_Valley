//
//  CommonMethod.m
//  Finance
//
//  Created by HuMin on 15/4/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "CommonMethod.h"

@implementation CommonMethod


+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}


+(UIImage *)imageWithColor:(UIColor*)color andSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    [color set];
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    [path fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext();
    
    return image;
}
+(NSString *)getVersion
{
    return [UIDevice currentDevice].systemVersion;
}
+(void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

+ (void)showNoResultView:(UITableView *)tableVContent description:(NSString *)description
{
    [self hideNoResultView:tableVContent];
    
    CGRect rect = tableVContent.frame;
    tableVContent.hidden = YES;
    
    CGRect rectImageV = CGRectMake(0, 0, 100, 100);
    rectImageV.origin.x = 110;
    rectImageV.origin.y = rect.origin.y + (CGRectGetHeight(rect)-CGRectGetHeight(rectImageV))/2 -25;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:rectImageV];
    imageV.image = [UIImage imageNamed:@"prompt.png"];
    
    rectImageV.origin.y += rectImageV.size.height+10;
    rectImageV.size.height = 40;
    rectImageV.origin.x = 60;
    rectImageV.size.width = 200;
    
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:rectImageV];
    lblTemp.textAlignment = NSTextAlignmentCenter;
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor blackColor];
    lblTemp.font = [UIFont systemFontOfSize:16.0f];
    if([description isEqualToString:@""])
    {
        lblTemp.text = @"亲,您还没有相关的记录";
    }else
    {
        lblTemp.text = description;
    }
    
    [tableVContent.superview addSubview:lblTemp];
    [tableVContent.superview addSubview:imageV];
    
}
+ (void)hideNoResultView:(UITableView*)tableVContent{
    tableVContent.hidden=NO;
    for (UIView *view in tableVContent.superview.subviews){
        if ([view isKindOfClass:[UIImageView class]]){
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UILabel class]]){
            [view removeFromSuperview];
        }
    }
}

#pragma mark - coreText

+(void)filterTextWithLabel:(UILabel *)label andText:(NSString *)text fontSize:(CGFloat)size lineSpace:(CGFloat)lineSpace fontColor:(UIColor *)color
{
    
    NSMutableAttributedString *attributeStr = [self attributeStrWithText:text fontSize:size lineSpacing:lineSpace fontColor:color];
    label.attributedText = attributeStr;
    CGRect labelRect = label.frame;
    labelRect.size.height = [self heigtForFootView:attributeStr andWidth:label.frame.size.width] ;
    label.frame  = labelRect;
}

+(CGFloat )heigtForFootView:(NSMutableAttributedString *) attributeString andWidth:(CGFloat)width
{
    
    CGFloat titleHeight;
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                options:options
                                                context:nil];
    titleHeight = ceilf(rect.size.height);
    
    return titleHeight;
    
}
+(NSMutableAttributedString *)attributeStrWithText:(NSString *)text fontSize:(CGFloat )fontSize lineSpacing:(CGFloat)lineSpace fontColor:(UIColor *)color
{
    
    if (!text)
    {
        text = @"";
    }
    
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentLeft];
    
    ps.lineSpacing = lineSpace;
    
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:ps,NSForegroundColorAttributeName: color?:RGBA(59, 59, 59, 1)};
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
    return attributeString;
    
}
+ (BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue =NO;
        [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring,NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         
         // surrogate pair
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             
             if (substring.length > 1) {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     
                     returnValue =YES;
                     
                 }
                 
             }
             
         }else if (substring.length > 1) {
             
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3) {
                 
                 returnValue =YES;
                 
             }
             
         }else {
             
             // non surrogate
             
             if (0x2100 <= hs && hs <= 0x27ff) {
                 
                 returnValue =YES;
                 
             }else if (0x2B05 <= hs && hs <= 0x2b07) {
                 
                 returnValue =YES;
                 
             }else if (0x2934 <= hs && hs <= 0x2935) {
                 
                 returnValue =YES;
                 
             }else if (0x3297 <= hs && hs <= 0x3299) {
                 
                 returnValue =YES;
                 
             }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 
                 returnValue =YES;
                 
             }
         }
         
     }];
    
    return returnValue;
    
}



@end
