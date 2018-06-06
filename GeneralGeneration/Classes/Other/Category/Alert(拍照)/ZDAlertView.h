//
//  ZDAlertView.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  拍照功能

#import <UIKit/UIKit.h>

@interface ZDAlertView : UIView
//拍照按钮
@property(nonatomic,strong)UIButton *cancel;
//手机相册
@property(nonatomic,strong)UIButton *phone;

//获取拍照的照片回传
@property(nonatomic,strong)void(^imageBlock)(UIImage *image);

@property (nonatomic,strong)UIImagePickerController *picker;

@property (nonatomic,strong)UIViewController *Vc;

+(NSData *)imageProcessWithImage:(UIImage *)image;
@end
