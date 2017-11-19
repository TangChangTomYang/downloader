//
//  NSHTTPURLResponse+fileLength.m
//  YRDownLoadTool
//
//  Created by yangrui on 2017/11/16.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import "NSHTTPURLResponse+fileLength.h"

@implementation NSHTTPURLResponse (fileLength)

/** 根据http 请求的相应头 获取请求文件的长度 */
-(long long)downloadingFileSize{

    NSDictionary *headerDic = self.allHeaderFields;
    
    
    
    /**
     代表的是本次请求的总大小(没有设置请求文件范围时,表示请求文件的大小,有设置请求范围表示当前请求文件的大小)
     "Content-Length" = 43873748;
     代表的是资源的总大小(注意: 请求文件时设置了请求范文才会有该字段)
     "Content-Range" = "bytes 0-43873747/43873748";
     */
    NSString *contentRangeStr = headerDic[@"Content-Range"];
    if (contentRangeStr.length > 0) {
      return   [[[contentRangeStr componentsSeparatedByString:@"/"] lastObject] integerValue];
    }
    
    NSString *contentlengehStr = headerDic[@"Content-Length"];
    return [contentlengehStr longLongValue];
                                          
}
@end
