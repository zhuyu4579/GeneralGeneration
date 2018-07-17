//
//  WZCollectionHeaderView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZCollectionHeaderView.h"

@implementation WZCollectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, frame.size.width, 14)];
        self.headerTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        self.headerTitle.textColor = UIColorRBG(102, 102, 102);
        self.headerTitle.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.headerTitle];
    }
    return self;
}

@end
