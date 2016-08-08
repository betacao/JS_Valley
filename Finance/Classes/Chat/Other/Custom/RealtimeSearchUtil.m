/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "RealtimeSearchUtil.h"

static RealtimeSearchUtil *defaultUtil = nil;

@interface RealtimeSearchUtil()

@property (strong, nonatomic) id source;

@property (nonatomic) SEL selector;

@property (nonatomic) SEL secondSelector;

@property (nonatomic) SEL thirdSelector;

@property (copy, nonatomic) RealtimeSearchResultsBlock resultBlock;

/**
 *  当前搜索线程
 */
@property (strong, nonatomic) NSThread *searchThread;
/**
 *  搜索线程队列
 */
@property (strong, nonatomic) dispatch_queue_t searchQueue;

@end

@implementation RealtimeSearchUtil

@synthesize source = _source;
@synthesize selector = _selector;
@synthesize resultBlock = _resultBlock;
@synthesize secondSelector = _secondSelector;
@synthesize thirdSelector = _thirdSelector;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _asWholeSearch = YES;
        _searchQueue = dispatch_queue_create("cn.realtimeSearch.queue", NULL);
    }
    
    return self;
}

/**
 *  实时搜索单例实例化
 *
 *  @return 实时搜索单例
 */
+ (instancetype)currentUtil
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultUtil = [[RealtimeSearchUtil alloc] init];
    });
    
    return defaultUtil;
}

#pragma mark - private

- (void)realtimeSearch:(NSString *)string
{
    [self.searchThread cancel];
    
    //开启新线程
    self.searchThread = [[NSThread alloc] initWithTarget:self selector:@selector(searchBegin:) object:string];
    [self.searchThread start];
}

- (void)searchBegin:(NSString *)string
{
    WEAK(self, weakSelf);
    dispatch_async(self.searchQueue, ^{
        if (string.length == 0) {
            weakSelf.resultBlock(weakSelf.source);
        }
        else{
            NSMutableArray *results = [NSMutableArray array];
            NSString *subStr = [string lowercaseString];
            for (id object in weakSelf.source) {
                NSString *tmp1 = @"";
                NSString *tmp2 = @"";
                NSString *tmp3 = @"";
                if (weakSelf.selector||weakSelf.secondSelector||weakSelf.thirdSelector) {
                    if([object respondsToSelector:weakSelf.selector])
                    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        tmp1 = [[object performSelector:weakSelf.selector] lowercaseString];
#pragma clang diagnostic pop
                        
                    }
                    if([object respondsToSelector:weakSelf.secondSelector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        tmp2 = [[object performSelector:weakSelf.secondSelector] lowercaseString];
#pragma clang diagnostic pop
                    }
                    if([object respondsToSelector:weakSelf.thirdSelector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        tmp3 = [[object performSelector:weakSelf.thirdSelector] lowercaseString];
#pragma clang diagnostic pop
                    }
                    
                }
                else if ([object isKindOfClass:[NSString class]])
                {
                    tmp1 = [object lowercaseString];
                }
                else{
                    continue;
                }
                
                if(tmp1 && [tmp1 rangeOfString:subStr].location != NSNotFound)
                {
                    [results addObject:object];
                } else if(tmp2 && [tmp2 rangeOfString:subStr].location != NSNotFound){
                    [results addObject:object];
                } else if(tmp3 && [tmp3 rangeOfString:subStr].location != NSNotFound){
                    [results addObject:object];
                }
            }
            
            weakSelf.resultBlock(results);
        }
    });
}

#pragma mark - public

/**
 *  开始搜索，只需要调用一次，与[realtimeSearchStop]配套使用
 *
 *  @param source      要搜索的数据源
 *  @param selector    获取元素中要比较的字段的方法
 *  @param resultBlock 回调方法，返回搜索结果
 */
- (void)realtimeSearchWithSource:(id)source searchText:(NSString *)searchText collationStringSelector:(SEL)selector resultBlock:(RealtimeSearchResultsBlock)resultBlock
{
    if (!source || !searchText || !resultBlock) {
        _resultBlock(source);
        return;
    }
    
    _source = source;
    _selector = selector;
    _resultBlock = resultBlock;
    [self realtimeSearch:searchText];
}

- (void)realtimeSearchWithSource:(id)source searchText:(NSString *)searchText collationStringSelector:(SEL)selector otherSelector:(SEL)otherSelector resultBlock:(RealtimeSearchResultsBlock)resultBlock
{
    _source = source;
    _selector = selector;
    _resultBlock = resultBlock;
    _secondSelector = otherSelector;
    [self realtimeSearch:searchText];
    
}

- (void)realtimeSearchWithSource:(id)source searchText:(NSString *)searchText firstSel:(SEL)selector1 secondSel:(SEL)selector2 thirdSel:(SEL)selector3 resultBlock:(RealtimeSearchResultsBlock)resultBlock
{
    _source = source;
    _selector = selector1;
    _secondSelector = selector2;
    _thirdSelector = selector3;
    _resultBlock = resultBlock;
    [self realtimeSearch:searchText];
}

/**
 *  从fromString中搜索是否包含searchString
 *
 *  @param searchString 要搜索的字串
 *  @param fromString   从哪个字符串搜索
 *
 *  @return 是否包含字串
 */
- (BOOL)realtimeSearchString:(NSString *)searchString fromString:(NSString *)fromString
{
    if (!searchString || !fromString || (fromString.length == 0 && searchString.length != 0)) {
        return NO;
    }
    if (searchString.length == 0) {
        return YES;
    }
    
    NSUInteger location = [[fromString lowercaseString] rangeOfString:[searchString lowercaseString]].location;
    return (location == NSNotFound ? NO : YES);
}

/**
 * 结束搜索，只需要调用一次，在[realtimeSearchBeginWithSource:]之后使用，主要用于释放资源
 */
- (void)realtimeSearchStop
{
    [self.searchThread cancel];
}

@end
