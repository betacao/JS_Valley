//
//  ZYExceptionHandler.m
//  ZYExceptionDemo
//
//  Created by 1 on 15/3/31.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "ZYExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
@implementation ZYExceptionHandler
+ (void)caughtExceptionHandler{
    //指定crash的处理方法。
    NSSetUncaughtExceptionHandler(& UncaughtExceptionHandler);
    

}

+ (void)fileCreate{
    NSString *path = [ZYExceptionHandler exceptionPath];
    NSFileManager *manager =[NSFileManager defaultManager];
    //文件不存在时创建
    if (![manager fileExistsAtPath:path])
    {
        NSString *dateString = [ZYExceptionHandler currentTime];
        NSString *logStr = [NSString stringWithFormat:@"================\n文件创建时间：%@\n================",dateString];
        NSData *data = [logStr dataUsingEncoding:NSUTF8StringEncoding];
        
        [data writeToFile:path atomically:YES];

    }
}

void UncaughtExceptionHandler(NSException *exception) {
    /**
     *  获取异常崩溃信息
     */
    //在这里创建一个接受crash的文件
    [ZYExceptionHandler fileCreate];

    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *dateString = [ZYExceptionHandler currentTime];

    NSString *systemName = [[UIDevice currentDevice] systemName];
    
    NSString *strModel = [[UIDevice currentDevice] model];

    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier = infoDict[@"CFBundleIdentifier"];
    NSString* versionNum = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    NSString *content = [NSString stringWithFormat:@"\n\n\n========异常错误报告========\n错误时间:%@ 系统：%@ 设备:%@\n当前版本:%@ 当前唯一标示符:%@\n\n错误名称:%@\n错误原因:\n%@\ncallStackSymbols:\n%@\n\n========异常错误结束========\n",dateString,systemName,strModel,versionNum,bundleIdentifier,name,reason,[callStack componentsJoinedByString:@"\n"]];


    NSString *path = [ZYExceptionHandler exceptionPath];

    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:path];
    //找到并定位到outFile的末尾位置(在此后追加文件)
    [outFile seekToEndOfFile];
    
    [outFile writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    //关闭读写文件
    [outFile closeFile];

    
}
+ (NSString *)exceptionPath{
    NSString *documents = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documents stringByAppendingPathComponent:@"exceptionHandler.txt"];
    NSLog(@"=========%@",NSHomeDirectory());
    return path;

}
+ (NSString *)currentTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;

}
//获取调用堆栈
+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack,frames);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i=0;i<frames;i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}
@end


