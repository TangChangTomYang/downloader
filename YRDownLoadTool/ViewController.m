//
//  ViewController.m
//  YRDownLoadTool
//
//  Created by yangrui on 2017/11/14.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()



@property(nonatomic, strong)YRDownload_downloader *downloader;
@end

@implementation ViewController


-(YRDownload_downloader *)downloader{
    if (!_downloader) {
        _downloader = [[YRDownload_downloader alloc]init];
    }
    return _downloader;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

  
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/abc.mp4"];
    [self.downloader downloadFile:url ];
}

@end





















