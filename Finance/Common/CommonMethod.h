//
//  CommonMethod.h
//  Finance
//
//  Created by HuMin on 15/4/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonMethod : NSObject

+(UIImage *)imageWithColor:(UIColor*)color andSize:(CGSize)size;
+(NSString *)getVersion;
+(void)setExtraCellLineHidden:(UITableView *)tableView;
+ (void)showNoResultView:(UITableView *)tableVContent description:(NSString *)description;
+ (void)hideNoResultView:(UITableView*)tableVContent;
+(void)filterTextWithLabel:(UILabel *)label andText:(NSString *)text fontSize:(CGFloat)size lineSpace:(CGFloat)lineSpace fontColor:(UIColor *)color;
+(CGFloat )heigtForFootView:(NSMutableAttributedString *) attributeString andWidth:(CGFloat)width;
+(NSMutableAttributedString *)attributeStrWithText:(NSString *)text fontSize:(CGFloat )fontSize lineSpacing:(CGFloat)lineSpace fontColor:(UIColor *)color;
+ (BOOL)stringContainsEmoji:(NSString *)string;

@end
