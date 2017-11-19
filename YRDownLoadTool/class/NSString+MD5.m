//
//  NSString+MD5.m
//  YRDownLoadTool
//
//  Created by yangrui on 2017/11/19.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)


-(NSString *)md5{

    const char *data = self.UTF8String;
    
    //16位
    unsigned char md[CC_MD5_DIGEST_LENGTH];

    CC_MD5(data, (CC_LONG)strlen(data), md);
    
    
    //32 位
    NSMutableString *resultStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    
    for (int i = 0 ; i < CC_MD5_DIGEST_LENGTH; i++) {
        // 将每一位字符取出转换成2位的16进制的
        [resultStr appendFormat:@"%02x",md[i]];
    }
    
   return  resultStr;
}
@end
