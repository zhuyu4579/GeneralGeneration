//
//  WZBankTableView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZBankTableView.h"
#import "WZAllTableViewCell.h"
static  NSString * const ID = @"Tcell";
@interface WZBankTableView()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation WZBankTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZAllTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    
    return self;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WZAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    return cell;
}
@end
