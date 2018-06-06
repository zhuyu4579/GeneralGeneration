//
//  ZDFollowTableView.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/5/1.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDFollowTableView.h"
#import "ZDFollowCell.h"
#import "ZDFollowItem.h"
@interface ZDFollowTableView()<UITableViewDelegate,UITableViewDataSource>

@end
static  NSString * const ID = @"cells";
@implementation ZDFollowTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"ZDFollowCell" bundle:nil] forCellReuseIdentifier:ID];
//    self.showsVerticalScrollIndicator = NO;
//    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self;
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _followArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (indexPath.row == 0) {
        [cell.ineOne setHidden:YES];
    }
    if (indexPath.row == (_followArray.count-1)) {
        [cell.ineTwo setHidden:YES];
    }
    ZDFollowItem *item = _followArray[indexPath.row];
    cell.item = item;
    return cell;
}

@end
