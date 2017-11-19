//
//  NSHTTPURLResponse+fileLength.h
//  YRDownLoadTool
//
//  Created by yangrui on 2017/11/16.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPURLResponse (fileLength)


/** 根据http 请求的相应头 获取请求文件的长度 */
-(long long)downloadingFileSize;
@end
