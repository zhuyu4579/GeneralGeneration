//
//  WZDynamictableView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZDynamictableView.h"
#import "WZDynamicCell.h"
static  NSString * const ID = @"Dcell";
@interface WZDynamictableView()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation WZDynamictableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZDynamicCell" bundle:nil] forCellReuseIdentifier:ID];
    //设置分割线
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WZDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.DynamicTime.text = @"";
    cell.DynamicTitle.text = @"";
    cell.DynamicContent.text = _name;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
