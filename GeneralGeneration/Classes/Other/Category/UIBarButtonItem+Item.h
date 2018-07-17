//
//  UIBarButtonItem+Item.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)
//给导航条添加一个按钮
+(UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;
//创建一个返回按钮
+(UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action nav:(CGRect)navsize;
+(UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;
//创建一个文字按钮
+(UIBarButtonItem *)itemWithButton:(id)target action:(SEL)action title:(NSString *)title;
+(UIBarButtonItem *)itemWithButtons:(id)target action:(SEL)action title:(NSString *)title;
+(UIBarButtonItem *)itemWithButtonImage:(UIImage *)image target:(id)target action:(SEL)action title:(NSString *)title;
@end
