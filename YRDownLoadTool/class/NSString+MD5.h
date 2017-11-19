//
//  NSString+MD5.h
//  YRDownLoadTool
//
//  Created by yangrui on 2017/11/19.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>// c语言 MD5算法

@interface NSString (MD5)

-(NSString *)md5;
@end
