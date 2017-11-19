//
//  AppDelegate.h
//  YRDownLoadTool
//
//  Created by yangrui on 2017/11/14.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end


/** 
 
 文件下载封装思路
 
 1. 下载完成的文件存放在 cache文件夹内
 2. 下载中的文件存放在 temp文件夹内
 
 
 
 step1. 
 判断 url 对应的资源是否下载完毕,完毕 return (文件路径,文件大小)
 
 step2.
 检测,临时文件是否存在
 临时文件存在,以当前的存在文件大小作为开始字节,去网络请求文件
 
 
 
 step3.
 临时文件不存在,直接开始下载
 
 */
















