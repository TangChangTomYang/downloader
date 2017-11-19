//
//  YRDownload_downloaderManager.m
//  YRDownLoadTool
//
//  Created by yangrui on 2017/11/19.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import "YRDownload_downloaderManager.h"
#import "YRDownload_downloader.h"
#import "NSString+MD5.h"

typedef void(^infoCallBack)();
typedef void(^progressCallBack)();
typedef void(^successCallBack)();
typedef void(^faileCallBack)();

@interface YRDownload_downloaderManager()



@property(nonatomic, strong)NSMutableDictionary  *downLoaderDicM;

@end


static YRDownload_downloaderManager *_downloaderMgr = nil;
@implementation YRDownload_downloaderManager

+(instancetype)shareMgr{
    if (!_downloaderMgr) {
        _downloaderMgr = [[self alloc]init];
    }
    return _downloaderMgr;
}


/** 
 
 key : url MD5
 value: downloader
 */
-(NSMutableDictionary *)downLoaderDicM{
    if (!_downLoaderDicM) {
        _downLoaderDicM = [NSMutableDictionary dictionary];
    }
    return _downLoaderDicM;
}



-(void)download:(NSURL *)url  infoCallBack:(infoCallBack)infoCallBack progressCallBack:(progressCallBack)progressCallBack successCallBack:(successCallBack)successCallBack faileCallBack:(faileCallBack)faileCallBack{

    
    
    YRDownload_downloader *downloader = [self downloader:url];
 
    [downloader downloadFile:url];
}





#pragma mark - 私有方法

-(YRDownload_downloader *)downloader:(NSURL *)url{
    
    NSString *urlMd5Str = [url.absoluteString md5];
    YRDownload_downloader *downloader = self.downLoaderDicM[urlMd5Str];
    if (downloader) {
        downloader = [[YRDownload_downloader alloc]init];
        self.downLoaderDicM[urlMd5Str] = downloader;
    }
    
    return downloader;

}























@end
