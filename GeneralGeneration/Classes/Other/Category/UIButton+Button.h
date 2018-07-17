//
//  UIButton+Button.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/19.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Button)
//返回一个按钮view
+(UIButton *)cleanButton:(UIImage *)image target:(id)target action:(SEL)action;
@end
