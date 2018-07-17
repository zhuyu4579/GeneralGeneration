//
//  UIButton+Button.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/19.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "UIButton+Button.h"

@implementation UIButton (Button)
#pragma mark -创建一个清除按钮
+(UIButton *)cleanButton:(UIImage *)image target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  btn;
}
@end
