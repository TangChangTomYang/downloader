//
//  YRFileTool.h
//  YRDownLoadTool
//
//  Created by yangrui on 2017/11/14.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRDownload_FileTool : NSObject


/** 缓存文件夹 */
+(NSString *)cacheDocPath;
/** 临时文件文件夹 */
+(NSString *)tempDocPath;


/** 缓存文件夹路径 */
+(NSString *)cachedFilePath:(NSURL *)url;
/** 临时文件文件夹路径 */
+(NSString *)tempFilePath:(NSURL *)url;




+(BOOL)iscacheFileExists:(NSURL *)url;

+(BOOL)isTempFileExists:(NSURL *)url;




/** 获取磁盘上 缓存文件的大小 */
+(long long)cacheFileSize:(NSURL *)url;

/** 获取磁盘上 临时文件的大小 */
+(long long)tempFileSize:(NSURL *)url;




/** 将临时文件 移动到临时文件 */
+(BOOL)moveTempFileToCacheFile:(NSURL *)url;

/** 删除临时文件 */
+(BOOL)deleteTempFile:(NSURL *)url;

/** 删除缓存文件 */
+(BOOL)deleteCacheFile:(NSURL *)url;



@end
