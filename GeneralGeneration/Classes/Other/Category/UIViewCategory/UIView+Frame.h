//
//  UIView+Frame.h
//  ProjectProJect(LC)
//


#import <UIKit/UIKit.h>


/**
 通过分类可以使用点语法访问UIView对象的x, y, width, height
 */
@interface UIView (Frame)

@property (nonatomic, assign) CGFloat fX;
@property (nonatomic, assign) CGFloat fY;

@property (nonatomic, assign) CGFloat fWidth;
@property (nonatomic, assign) CGFloat fHeight;

@property (nonatomic, assign) CGPoint fOrigin;
@property (nonatomic, assign) CGSize fSize;

@end
