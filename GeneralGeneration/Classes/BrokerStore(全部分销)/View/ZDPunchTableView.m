//
//  ZDPunchTableView.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/6/15.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDPunchTableView.h"
#import "ZDPunchCell.h"
#import "ZDPunchItem.h"
@interface ZDPunchTableView()<UITableViewDelegate,UITableViewDataSource>

@end
static  NSString * const ID = @"cells";
@implementation ZDPunchTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"ZDPunchCell" bundle:nil] forCellReuseIdentifier:ID];
    //    self.showsVerticalScrollIndicator = NO;
    //    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self;
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _punchArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDPunchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [cell.ineTop setHidden:NO];
    [cell.ineBottom setHidden:NO];
    if(_punchArray.count == 1){
        [cell.ineTop setHidden:YES];
        [cell.ineBottom setHidden:YES];
    }else{
        if (indexPath.row == 0) {
            [cell.ineTop setHidden:YES];
            [cell.ineBottom setHidden:NO];
        }
        if (indexPath.row == (_punchArray.count-1)) {
            [cell.ineTop setHidden:NO];
            [cell.ineBottom setHidden:YES];
        }
    }
    
    ZDPunchItem *item = _punchArray[indexPath.row];
    cell.item = item;
    return cell;
}
@end
