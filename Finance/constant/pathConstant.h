//
//  pathConstant.h
//  Finance
//
//  Created by HuMin on 15/4/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#ifndef Finance_pathConstant_h
#define Finance_pathConstant_h


/**Document路径*/
static NSString *_FileDocumentPath;

static inline NSString* FileDocumentPath()
{
    if (!_FileDocumentPath)
    {
        
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains
                                  (NSDocumentDirectory,NSUserDomainMask,YES)
                                  objectAtIndex:0];
        
        BOOL isDir = YES;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isExist = [fileManager fileExistsAtPath:documentPath
                                         isDirectory:&isDir];
        if (!isExist)
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:documentPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        _FileDocumentPath = [documentPath copy];
    }
    return _FileDocumentPath;
}


#endif
