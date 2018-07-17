//
//  WZSchoolTableView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSchoolTableView.h"
#import "WZAllTableViewCell.h"
#import "WZPeripheryItem.h"
static  NSString * const ID = @"Tcell";
@interface WZSchoolTableView()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation WZSchoolTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZAllTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
     self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor clearColor];
    return self;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WZAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WZPeripheryItem *item = _array[indexPath.row];
    cell.item = item;
    return cell;
}

@end
