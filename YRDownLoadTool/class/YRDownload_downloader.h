//
//  YRDownLoadTool.h
//  YRDownLoadTool
//
//  Created by yangrui on 2017/11/14.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 
 文件的存放路径
 下载ing: -> temp+名称
 下载完成: -> cache+名称
 
 */

typedef enum {

    YRDownloaderStatus_pause,           //暂停
    YRDownloaderStatus_downloading,     //整在下载
    YRDownloaderStatus_success,         //已经下载
    YRDownloaderStatus_fail,            //下载失败
}YRDownloaderStatus;




/** 一个下载器,对应一个下载任务 */
@interface YRDownload_downloader : NSObject




@property(nonatomic, assign,readonly)YRDownloaderStatus status;


-(void)downloadFile:(NSURL *)url ;

-(void)pause;

-(void)cancle;

-(void)cancleAndClean;


















@end
