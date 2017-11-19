//
//  YRDownLoadTool.m
//  YRDownLoadTool
//
//  Created by yangrui on 2017/11/14.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import "YRDownload_downloader.h"



@interface YRDownload_downloader()<NSURLSessionDataDelegate>
{
    long long _tempSize ;
    long long _totalSize;
}


@property(nonatomic, weak)NSURLSession *session;
@property(nonatomic, strong)NSURLSessionDataTask *datatask;





/**输入输出流*/
@property(nonatomic, strong)NSOutputStream *outputStream;
@end

@implementation YRDownload_downloader



-(void)downloadFile:(NSURL *)url {
    
    
    // 当前下载任务存在
    if ([url isEqual:self.datatask.originalRequest.URL]) {
        
        if (self.status == YRDownloaderStatus_pause) {
            
            // 判断当前的状态
            [self resume];
            return;
        }
        
    }
    
    //[self cancle];
    // 缓存文件存在 直接返回
    if ([YRDownload_FileTool iscacheFileExists:url]) {
        
        self.status = YRDownloaderStatus_success;
        return;
        
    }
    
    _tempSize = [YRDownload_FileTool tempFileSize:url];
    if(_tempSize > 0){
        
        [self downloadFile:url atOffset:_tempSize];
        return;
    }
    
    // 临时文件
    [self downloadFile:url atOffset:0];
}

// 坑,如果调用到了几次暂停,就要调用调用几次继续才会开始
-(void)pause{
    if (self.status == YRDownloaderStatus_downloading) {
        [self.datatask suspend];
        self.status = YRDownloaderStatus_pause;
    }
  
}

-(void)cancle{

    // 取消
    [self.session invalidateAndCancel];
    self.status = YRDownloaderStatus_pause;
    self.session = nil;
}

-(void)cancleAndClean{
   
    [YRDownload_FileTool deleteTempFile:self.datatask.originalRequest.URL];
    [self cancle];

}

#pragma mark- 内部私有方法
// 坑,如果调用到了几次继续,就要调用调用几次暂停才会开始
-(void)resume{
    if (self.datatask && self.status == YRDownloaderStatus_pause) {
        [self.datatask resume];
        self.status = YRDownloaderStatus_downloading;
    }
    
}





#pragma mark- 内部私有方法
-(void)downloadFile:(NSURL *)url atOffset:(long long)offset{

    // 注意:cachePolicy 要使用NSURLRequestReloadIgnoringLocalCacheData 忽略本地缓存,每次都重新请求
    // timeoutInterval == 0 ,不超时
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];//
    
    // 设置文件的请求范围(注意设置请求后头长度,在相应头response 才会有Content-Range代表请求资源的长度信息)
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-",offset] forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];

    self.datatask = dataTask;
    [self resume];
}



#pragma mark- http 请求代理方法

/** 使用https 就会调用这个方法 */
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{


}

/** 第一次接受到相应时调用(相应头,并没有具体的数据) */



- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{


    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        
        // 文件总大小
        _totalSize =  [((NSHTTPURLResponse *)response) downloadingFileSize];
    }
 
    // 比对本地大小和总大小
    if (_tempSize == _totalSize) {
        //1. 移动到文件到缓存文件夹
        [YRDownload_FileTool moveTempFileToCacheFile:response.URL];
        

        self.status = YRDownloaderStatus_success;
        //2. 结束本次下载
         completionHandler(NSURLSessionResponseCancel);
        
    }
    
    else if(_tempSize > _totalSize){
        // 1. 删除临时缓存
        [YRDownload_FileTool deleteTempFile:response.URL];
        
        
        //2.从0 开始下载( 不一定对)
        [self downloadFile:response.URL atOffset:0];
        
        //3.取消本次请求
         completionHandler(NSURLSessionResponseCancel);
    }
    
    else{
        NSString *tempFilePath = [YRDownload_FileTool tempFilePath:response.URL];
        self.outputStream = [NSOutputStream outputStreamToFileAtPath:tempFilePath append:YES];
        [self.outputStream open];
        self.status = YRDownloaderStatus_downloading;
        
        // 开始请求
        completionHandler(NSURLSessionResponseAllow);
    
    }
    
}

/** 当用户确认,继续接受数据时就会调用 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{


    [self.outputStream write:data.bytes maxLength:data.length];
    NSLog(@"接受数据中");
}


/** 请求完成的时候调用(请求完成 != 请求成功或者失败) */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{

    if (error == nil) {
        NSLog(@"数据请求完成,但不一定是成功");
        
        [YRDownload_FileTool moveTempFileToCacheFile:self.datatask.originalRequest.URL];
        self.status = YRDownloaderStatus_success;
        // 请求完成,但不一定数据请求成功,比如文件:12345678,但是下载的是123445678,文件中间重复错误
        // 因此严谨情况下,需要检测文件的完整度
        // 严重文件的完整度的方式主要有 tempSize == totalSize ,或者文件的MD5 (文件是否被串改,丢包,乱码)
        
        // 通常验证下载文件完整性的方式:(tempfileSize == totalSize, 文件的MD5 摘要, 等等)
    }
    else{// 用户点击 datatask 取消也会来这里
        
        if (error.code == -999) {//取消
            self.status = YRDownloaderStatus_pause;
        }
        else{
            
            self.status = YRDownloaderStatus_fail;
        
        }
         NSLog(@"有问题,可能断网了,没信号了");
    }
    
    
    NSLog(@"请求结束");
    [self.outputStream close];
    self.outputStream = nil;
}

-(void)setStatus:(YRDownloaderStatus)status{
    if (_status != status) {
        _status = status;
    }
}

#pragma mark-

-(NSURLSession *)session{
    if (!_session) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
@end
