//
//  UIButton+WZEnlargeTouchAre.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WZEnlargeTouchAre)
-(void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

-(void)setEnlargeEdge:(CGFloat)size;
@end
