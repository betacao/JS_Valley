//
//  DisplayView.m
//  CoreTextDemo01
//
//  Created by LiYeBiao on 16/3/31.
//  Copyright © 2016年 LiYeBiao. All rights reserved.
//

#import "CTTextDisplayView.h"
#import <CoreText/CoreText.h>
#import "CTTextRun.h"


@interface CTTextDisplayView()

@property (nonatomic,strong) NSMutableDictionary * keyRectDict;
@property (nonatomic,strong) NSMutableDictionary * keyAttributeDict;
@property (nonatomic,strong) NSString * currentKey;
@property (nonatomic,strong) NSArray * currentKeyRectArray;
@property (nonatomic,assign) BOOL private_autoHeight;
@property (nonatomic,assign) BOOL private_need_calc_height;

@end

@implementation CTTextDisplayView

- (void)dealloc{
    //    NSLog(@"--- dealloc %@ ---",[self class]);
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData{
    self.styleModel = [CTTextStyleModel new];
    self.keyRectDict = [NSMutableDictionary new];
    self.keyAttributeDict = [NSMutableDictionary new];
}

+ (NSMutableAttributedString *)createAttributedStringWithText:(NSString *)text styleModel:(CTTextStyleModel *)styleModel
{
    UIFont * font = styleModel.font;
    CGFloat fontSpace = styleModel.fontSpace;
    CGFloat lineSpace = styleModel.lineSpace;
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    //设置字体
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,attString.length)];
    
    //设置字体颜色
    [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)styleModel.textColor.CGColor range:NSMakeRange(0,attString.length)];
    
    CFRelease(fontRef);
    
    //设置字距
    [attString addAttribute:(NSString *)kCTKernAttributeName value:[NSNumber numberWithFloat:fontSpace] range:NSMakeRange(0, attString.length)];
    
    
    //添加换行模式
    CTParagraphStyleSetting lineBreakStyle;
    CTLineBreakMode lineBreakMode = kCTLineBreakByCharWrapping;
    lineBreakStyle.spec        = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakStyle.value       = &lineBreakMode;
    lineBreakStyle.valueSize   = sizeof(CTLineBreakMode);//sizeof(lineBreak);
    
    //行距
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;//kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.valueSize = sizeof(CGFloat);//sizeof(lineSpace);
    lineSpaceStyle.value =&lineSpace;
    
    //    const CFIndex kNumberOfSettings = 2;
    CTParagraphStyleSetting settings[] = {lineSpaceStyle,lineBreakStyle};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(settings[0]));
    //    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, kNumberOfSettings);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    CFRelease(style);
    
    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
    
    return attString;
}

+ (CGFloat)getRowHeightWithText:(NSString *)text rectSize:(CGSize)rectSize styleModel:(CTTextStyleModel *)styleModel{
    if(!text){
        return 0;
    }
    NSMutableAttributedString *attString = [CTTextDisplayView createAttributedStringWithText:text styleModel:styleModel];
    CTTextRun * textRun = [[CTTextRun alloc] init];
    textRun.styleModel = styleModel;
    [textRun runsWithAttString:attString];

    if (attString.length > styleModel.maxLength) {
        [attString deleteCharactersInRange:NSMakeRange(styleModel.maxLength, attString.length - styleModel.maxLength)];
    }

    CGRect viewRect = CGRectMake(0, 0, rectSize.width, rectSize.height);//CGRectGetHeight(self.bounds)
    
    //创建一个用来描画文字的路径，其区域为当前视图的bounds  CGPath
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, viewRect);
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    
    //创建由framesetter管理的frame，是描画文字的一个视图范围  CTFrame
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, nil);
    
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CFIndex lineCount = CFArrayGetCount(lines);
    
    
    CFRelease(pathRef);
    CFRelease(frameRef);
    CFRelease(framesetterRef);
    
    
    CGFloat frameHeight = 0;
    if(styleModel.numberOfLines < 0){
        frameHeight = lineCount*(styleModel.font.lineHeight+styleModel.lineSpace)+styleModel.lineSpace;
    }else{
        frameHeight = MIN(lineCount, styleModel.numberOfLines) * (styleModel.font.lineHeight+styleModel.lineSpace)+styleModel.lineSpace;
    }
    
    //四舍五入函数，否则可能会出现一条黑线
    return roundf(frameHeight);
}

- (void)setText:(NSString *)text{
    _text = text;
    [self setNeedsDisplay];
}

//如果autoHeight==YES，则frame.size.height >= 1
- (void)setStyleModel:(CTTextStyleModel *)styleModel{
    _styleModel = styleModel;
    _private_autoHeight = styleModel.isAutoHeight;
    _private_need_calc_height = _private_autoHeight;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if(!self.text){
        return;
    }
    
    [self.keyRectDict removeAllObjects];
    [self.keyAttributeDict removeAllObjects];
    
    BOOL isAutoHeight = _styleModel.isAutoHeight;
    UIFont * font = _styleModel.font;
    NSInteger numberOfLines = _styleModel.numberOfLines;
    CGFloat lineSpace = _styleModel.lineSpace;
    CGSize faceSize = _styleModel.faceSize;
    CGFloat faceOffset = _styleModel.faceOffset;
    
    CGFloat highlightBackgroundRadius = _styleModel.highlightBackgroundRadius;
    UIColor * highlightBackgroundColor = _styleModel.highlightBackgroundColor;
    
    NSMutableAttributedString *attString = [CTTextDisplayView createAttributedStringWithText:_text styleModel:_styleModel];
    
    CTTextRun * textRun = [[CTTextRun alloc] init];
    textRun.styleModel = _styleModel;
    [textRun runsWithAttString:attString];
    if (attString.length > _styleModel.maxLength) {
        [attString deleteCharactersInRange:NSMakeRange(_styleModel.maxLength, attString.length - _styleModel.maxLength)];
    }
    //绘图上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextRef, self.backgroundColor.CGColor);
    
    CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
    CGContextTranslateCTM(contextRef, 0, CGRectGetHeight(self.bounds)); // 此处用计算出来的高度
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    CGRect viewRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGFLOAT_MAX);//CGRectGetHeight(self.bounds)
    
    //创建一个用来描画文字的路径，其区域为当前视图的bounds  CGPath
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, viewRect);
    
    //创建一个framesetter用来管理描画文字的frame  CTFramesetter
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    
    //创建由framesetter管理的frame，是描画文字的一个视图范围  CTFrame
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, nil);
    
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CFIndex lineCount = CFArrayGetCount(lines);
    
    
    //自动计算高度(此处计算并得到高度后再重新绘制)
    if(_private_autoHeight && _private_need_calc_height){
        CFRelease(pathRef);
        CFRelease(frameRef);
        CFRelease(framesetterRef);
        
        _private_autoHeight = NO;
        __weak CTTextDisplayView * _weak_self = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:0.01];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CGRect frame = _weak_self.frame;
                frame.size.height = roundf(lineCount*(font.lineHeight+lineSpace)+lineSpace);
                _weak_self.frame = frame;
                [_weak_self setNeedsDisplay];
            });
        });
        return;
    }
    _private_autoHeight = isAutoHeight;
    
    
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
    
    //绘制高亮区域
    if(self.currentKeyRectArray){
        NSInteger a_count = _currentKeyRectArray.count;
        for(int i=0;i<a_count;i++){
            NSValue * rectValue =_currentKeyRectArray[i];
            CGRect rect = [rectValue CGRectValue];
            CGPathRef path = [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:highlightBackgroundRadius] CGPath];
            CGContextSetFillColorWithColor(contextRef, highlightBackgroundColor.CGColor);
            CGContextAddPath(contextRef, path);
            CGContextFillPath(contextRef);
        }
    }
    
    CGFloat frameY = 0;
    CGFloat lineHeight = font.lineHeight+lineSpace;
    
    CGRect prevImgRect = CGRectZero;
    
    for (int i = 0; i < lineCount; i++)
    {
        if(!isAutoHeight && ( numberOfLines >= 0 && !(i < numberOfLines))){
            break;
        }
        
        CTLineRef lineRef= CFArrayGetValueAtIndex(lines, i);
        //        CGFloat lineAscent;
        //        CGFloat lineDescent;
        //        CGFloat lineLeading;
        //        CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
        
        CGPoint lineOrigin = lineOrigins[i];
        frameY = CGRectGetHeight(self.bounds) - (i + 1)*lineHeight - font.descender;
        lineOrigin.y = frameY;
        
        CGContextSetTextPosition(contextRef, lineOrigin.x, lineOrigin.y);
        CTLineDraw(lineRef, contextRef);
        
        
        CFArrayRef runs = CTLineGetGlyphRuns(lineRef);
        for (int j = 0; j < CFArrayGetCount(runs); j++)
        {
            CTRunRef runRef = CFArrayGetValueAtIndex(runs, j);
            CGFloat runAscent;
            CGFloat runDescent;
            CGRect runRect;
            
            runRect.size.width = CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            runRect = CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, NULL),
                                 lineOrigin.y ,
                                 runRect.size.width,
                                 runAscent + runDescent);
            
            NSDictionary * attributes = (__bridge NSDictionary *)CTRunGetAttributes(runRef);
            NSString * keyAttribute = [attributes objectForKey:@"keyAttribute"];
            
            if (keyAttribute)
            {
                CGFloat runAscent,runDescent;
                CGFloat runWidth  = CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
                //                CGFloat runHeight = (lineAscent + lineDescent );
                
                CGFloat runPointX = runRect.origin.x + lineOrigin.x;
                CGFloat runPointY = lineOrigin.y-faceOffset;
                
                CGRect keyRect = CGRectZero;
                char firstCharAttribute = [keyAttribute characterAtIndex:0];
                //                NSLog(@"keyAttribute:%@",keyAttribute);
                if(firstCharAttribute == 'F'){
                    NSString * imageName = nil;
                    NSArray * imageNameArr = [keyAttribute componentsSeparatedByString:@"("];
                    if(imageNameArr.count > 1){
                        imageName = imageNameArr[0];
                    }else{
                        imageName = keyAttribute;
                    }
                    UIImage *image = [UIImage imageNamed:imageName];
                    if (image) {
                        //runWidth, runHeight);
                        if([keyAttribute hasPrefix:@"F:hyperlink"] || [keyAttribute hasPrefix:@"F:video"] || [keyAttribute hasPrefix:@"F:photo"]){
                            keyRect = CGRectMake(runPointX, runPointY+(lineHeight-_styleModel.tagImgSize.height)/2.0, _styleModel.tagImgSize.width,_styleModel.tagImgSize.height);
                            prevImgRect = CGRectMake(runPointX, lineOrigin.y-(lineHeight+_styleModel.highlightBackgroundAdjustHeight-lineSpace)/4-_styleModel.highlightBackgroundOffset, _styleModel.tagImgSize.width, lineHeight+_styleModel.highlightBackgroundAdjustHeight);
                        }else{
                            keyRect = CGRectMake(runPointX, runPointY, faceSize.width,faceSize.height);
                        }
                        CGContextDrawImage(contextRef, keyRect, image.CGImage);
                        
                    }
                }else if(firstCharAttribute == 'T' || firstCharAttribute == 'H' || firstCharAttribute == 'U' || firstCharAttribute == '@' || firstCharAttribute == '#' || firstCharAttribute == '$' || firstCharAttribute == 'E' || firstCharAttribute == 'P'){
                    
                    keyRect = CGRectMake(runPointX, lineOrigin.y-(lineHeight+_styleModel.highlightBackgroundAdjustHeight-lineSpace)/4-_styleModel.highlightBackgroundOffset, runWidth, lineHeight+_styleModel.highlightBackgroundAdjustHeight);
                    
                    NSMutableArray * obj = [self.keyAttributeDict objectForKey:keyAttribute];
                    if(obj == nil){
                        obj = [NSMutableArray new];
                        if(firstCharAttribute == 'H' || firstCharAttribute == 'T'){
                            CGFloat t_w = 0;
                            if(keyRect.origin.x == 0.0f){
                                [obj addObject:[NSValue valueWithCGRect:prevImgRect]];
                                
                                [self.keyRectDict setObject:keyAttribute forKey:[NSValue valueWithCGRect:prevImgRect]];
                                
                            }else{
                                t_w = _styleModel.tagImgSize.width;
                            }
                            keyRect = CGRectMake(keyRect.origin.x-t_w, CGRectGetMinY(keyRect), CGRectGetWidth(keyRect)+t_w, CGRectGetHeight(keyRect));
                        }
                    }
                    NSInteger objCount = obj.count;
                    BOOL rep = NO;
                    for(int rect_index=0;rect_index<objCount;rect_index++){
                        NSValue * rectValue = obj[rect_index];
                        CGRect rect_value = [rectValue CGRectValue];
                        
                        if(rect_value.origin.y == keyRect.origin.y){
                            
                            rect_value.size.width += keyRect.size.width;
                            
                            [obj replaceObjectAtIndex:rect_index withObject:[NSValue valueWithCGRect:rect_value]];
                            rep = YES;
                            
                            break;
                        }
                    }
                    if(!rep){
                        [obj addObject:[NSValue valueWithCGRect:keyRect]];
                    }
                    [self.keyAttributeDict setObject:obj forKey:keyAttribute];
                    [self.keyRectDict setObject:keyAttribute forKey:[NSValue valueWithCGRect:keyRect]];
                }
                //                else{
                //
                //                    UIImage *image = [UIImage imageNamed:keyAttribute];
                //                    if (image) {
                //                        //runWidth, runHeight);
                //                        if([keyAttribute isEqualToString:@"hyperlink.png"]){
                //                            keyRect = CGRectMake(runPointX, runPointY+(lineHeight-_styleModel.tagImgSize.height)/2.0, _styleModel.tagImgSize.width,_styleModel.tagImgSize.height);
                //                            prevImgRect = CGRectMake(runPointX, lineOrigin.y-(lineHeight+_styleModel.highlightBackgroundAdjustHeight-lineSpace)/4-_styleModel.highlightBackgroundOffset, _styleModel.tagImgSize.width, lineHeight+_styleModel.highlightBackgroundAdjustHeight);
                //                        }else{
                //                            keyRect = CGRectMake(runPointX, runPointY, faceSize.width,faceSize.height);
                //                        }
                //                        CGContextDrawImage(contextRef, keyRect, image.CGImage);
                //
                //                    }
                //                }
            }
        }
    }
    
    //通过context在frame中描画文字内容
    //    CTFrameDraw(frameRef, contextRef);
    CFRelease(pathRef);
    CFRelease(frameRef);
    CFRelease(framesetterRef);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _private_need_calc_height = NO;
    
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);

    [self.keyRectDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        
        CGRect rect = [((NSValue *)key) CGRectValue];
        if(CGRectContainsPoint(rect, runLocation))
        {
            NSArray * objArr = [self.keyAttributeDict objectForKey:obj];
            if(objArr){
                self.currentKeyRectArray = objArr;
                [self setNeedsDisplay];
            }
        }
    }];
    if (self.currentKeyRectArray.count == 0) {
        [super touchesBegan:touches withEvent:event];
    }

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesCancelled:touches withEvent:event];
    _private_need_calc_height = NO;
    self.currentKey = nil;
    self.currentKeyRectArray = nil;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _private_need_calc_height = NO;
    
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);

    if (self.currentKeyRectArray.count == 0) {
        [super touchesEnded:touches withEvent:event];
    }

    [self.keyRectDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        
        CGRect rect = [((NSValue *)key) CGRectValue];
        if(CGRectContainsPoint(rect, runLocation))
        {
            __weak CTTextDisplayView * _weak_self = self;
            if(self.delegate && [self.delegate respondsToSelector:@selector(ct_textDisplayView: obj:)]){
                char ch_key = [obj characterAtIndex:0];
                NSString * key = nil;
                if(ch_key == 'U'){
                    key = @"U";
                }else if(ch_key == '@'){
                    key = @"@";
                }else if(ch_key == '#'){
                    key = @"#";
                }else if(ch_key == '$'){
                    key = @"$";
                }else if(ch_key == 'E'){
                    key = @"E";
                }else if(ch_key == 'P'){
                    key = @"P";
                }else if(ch_key == 'H'){
                    key = @"U";
                }else if(ch_key == 'T'){
                    key = @"T";
                }
                
                NSRange endRange = [((NSString *)obj) rangeOfString:@"{"];
                NSDictionary * objDict = @{@"key":key,@"value":[obj substringWithRange:NSMakeRange(1, endRange.location-1)]};
                [_weak_self.delegate ct_textDisplayView:_weak_self obj:objDict];
            }
        } else {
            [super touchesEnded:touches withEvent:event];
        }
    }];
    self.currentKey = nil;
    self.currentKeyRectArray = nil;
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesMoved:touches withEvent:event];
    _private_need_calc_height = NO;
    
    
    //以下注释打开后 触摸移动时内存消耗比较严重
    /***
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
    
    [self.keyRectDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        
        CGRect rect = [((NSValue *)key) CGRectValue];
        if(CGRectContainsPoint(rect, runLocation))
        {
            NSArray * objArr = [self.keyAttributeDict objectForKey:obj];
            if(objArr && (![self.currentKey isEqualToString:obj])){
                self.currentKey = obj;
                self.currentKeyRectArray = objArr;
                [self setNeedsDisplay];
            }
        }
    }];
    */
}





@end
