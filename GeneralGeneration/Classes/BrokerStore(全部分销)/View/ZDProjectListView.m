//
//  ZDProjectListView.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDProjectListView.h"
#import "ZDTProjectListCell.h"
#import "ZDProjectListItem.h"
static  NSString * const ID = @"cells";
@interface ZDProjectListView()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation ZDProjectListView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"ZDTProjectListCell" bundle:nil] forCellReuseIdentifier:ID];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self;
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 22;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return _projectArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDTProjectListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    ZDProjectListItem *item = _projectArray[indexPath.row];
    cell.item = item;
    return cell;
}

@end
