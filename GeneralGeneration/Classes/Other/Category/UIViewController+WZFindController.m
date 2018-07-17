//
//  UIViewController+WZFindController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "UIViewController+WZFindController.h"

@implementation UIViewController (WZFindController)
#pragma mark -获取当前的viewController
+ (UIViewController *)viewController:(id)target {
    for (UIView* next = target; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
