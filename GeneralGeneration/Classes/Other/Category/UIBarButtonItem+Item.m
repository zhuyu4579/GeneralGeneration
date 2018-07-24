//
//  UIBarButtonItem+Item.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "UIBarButtonItem+Item.h"
#import "UIView+Frame.h"
#import "UIButton+WZEnlargeTouchAre.h"
@implementation UIBarButtonItem (Item)

//#pragma mark -给导航条添加一个按钮
//+(UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action{
//    //创建一个button
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:100];
//    [btn setImage:image     forState:UIControlStateNormal];
//    [btn setImage:highImage forState:UIControlStateHighlighted];
//    [btn sizeToFit];
//    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
//    [containView addSubview:btn];
//
//    return  [[UIBarButtonItem alloc] initWithCustomView:containView];
//
//}
#pragma mark -给导航条添加一个按钮
+(UIBarButtonItem *)itemWithButtons:(id)target action:(SEL)action title:(NSString *)title {
    //创建一个button
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 15)];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:3/255.0 green:133/255.0 blue:219/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    return  [[UIBarButtonItem alloc] initWithCustomView:containView];
}

+(UIBarButtonItem *)itemWithButtonImage:(UIImage *)image target:(id)target action:(SEL)action title:(NSString *)title {
    //创建一个button
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110, 15)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 90, 0, -90)];
    [btn setImage:image forState:UIControlStateNormal];
   
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:3/255.0 green:133/255.0 blue:219/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    return  [[UIBarButtonItem alloc] initWithCustomView:containView];
}
#pragma mark -创建一个返回按钮
+(UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title{
    //设置返回按钮样式
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    //设置字体状态颜色
    [backButton setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //设置图片
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    //调整按钮位置
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //适应图片
    [backButton sizeToFit];
    //返回上一个控制器
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
#pragma mark -给导航条添加一个按钮
+(UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action{
    //创建一个button
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:image     forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    //调整按钮位置
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    //[btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:containView];
    
}
#pragma mark -给导航条添加一个按钮
+(UIBarButtonItem *)itemWithButton:(id)target action:(SEL)action title:(NSString *)title {
    //创建一个button
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:3/255.0 green:133/255.0 blue:219/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    //调整按钮位置
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    return  [[UIBarButtonItem alloc] initWithCustomView:containView];
}
#pragma mark -创建一个返回按钮
+(UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action{
    
    //设置返回按钮样式
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    //设置图片
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    //调整按钮位置
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
  
    //返回上一个控制器
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
#pragma mark -创建一个返回按钮
+(UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action nav:(CGRect)navsize{
    
    //设置返回按钮样式
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 56)];
    
    //设置图片
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    //调整按钮位置
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    
    //返回上一个控制器
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
@end
