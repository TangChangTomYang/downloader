//
//  YRFileTool.m
//  YRDownLoadTool
//
//  Created by yangrui on 2017/11/14.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import "YRDownload_FileTool.h"

@implementation YRDownload_FileTool

+(NSString *)cacheDocPath{
  return   NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+(NSString *)tempDocPath{
  return   NSTemporaryDirectory();
}


+(NSString *)cachedFilePath:(NSURL *)url{
    
    NSString *fileName = url.lastPathComponent;
    return [[self cacheDocPath] stringByAppendingPathComponent:fileName];
}

+(NSString *)tempFilePath:(NSURL *)url{
    NSString *fileName = url.lastPathComponent;
    return [[YRDownload_FileTool tempDocPath] stringByAppendingPathComponent:fileName];

}




+(BOOL)iscacheFileExists:(NSURL *)url{
    NSString *cachedFile = [self cachedFilePath:url];
    
   return  [[NSFileManager defaultManager] fileExistsAtPath:cachedFile];
    
}


+(BOOL)isTempFileExists:(NSURL *)url{

    NSString *tempFile = [self tempFilePath:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:tempFile];
}


/** 获取磁盘上文件的大小 */
+(long long)cacheFileSize:(NSURL *)url;{

    if([self iscacheFileExists:url]){
    
        NSString *cachefilePath = [self cachedFilePath:url];
        NSError *err = nil;
        NSDictionary<NSFileAttributeKey, id> *arrDic = [[NSFileManager defaultManager] attributesOfItemAtPath:cachefilePath error:&err];
        return    [arrDic[NSFileSize] longLongValue];
    
    }
    
    return 0;
}


/** 获取磁盘上 临时文件的大小 */
+(long long)tempFileSize:(NSURL *)url{

    if([self isTempFileExists:url]){
        
        NSString *tempfilePath = [self tempFilePath:url];
        NSError *err = nil;
        NSDictionary<NSFileAttributeKey, id> *arrDic = [[NSFileManager defaultManager] attributesOfItemAtPath:tempfilePath error:&err];
        return    [arrDic[NSFileSize] longLongValue];
        
    }
    
    return 0;

}






/** 将临时文件 移动到临时文件 */
+(BOOL)moveTempFileToCacheFile:(NSURL *)url{

    if ([self isTempFileExists:url]) {
        NSString *tempFilePath = [self tempFilePath:url];
        NSString *cacheFielPath = [self cachedFilePath:url];
        
        return [[NSFileManager defaultManager] moveItemAtPath:tempFilePath toPath:cacheFielPath error:nil];
        
    }
    
    return NO;

}

/** 删除临时文件 */
+(BOOL)deleteTempFile:(NSURL *)url{
    NSString *tempFilePath = [self tempFilePath:url];
    
    
    return [[NSFileManager defaultManager] removeItemAtPath:tempFilePath error:nil];
    
    

}

/** 删除缓存文件 */
+(BOOL)deleteCacheFile:(NSURL *)url{
    NSString *cacheFielPath = [self cachedFilePath:url];
     return [[NSFileManager defaultManager] removeItemAtPath:cacheFielPath error:nil];
}






@end
