//
//  NSString+LCExtension.h
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LCExtension)

//判断状态码返回登录
+(void)isCode:(id)target code:(NSString *)code;
//判断版本号
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2;
@end
