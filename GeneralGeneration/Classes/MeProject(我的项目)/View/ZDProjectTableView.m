//
//  ZDProjectTableView.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDProjectTableView.h"
#import "ZDProjectCell.h"
#import "ZDAlreadyContractStoreController.h"
#import "UIViewController+WZFindController.h"
#import "ZDProjectItem.h"
#import "ZDContractController.h"
static  NSString * const ID = @"cells";
@interface ZDProjectTableView()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation ZDProjectTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"ZDProjectCell" bundle:nil] forCellReuseIdentifier:ID];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self;
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return _projectArray.count;
   //return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [cell.contractStore addTarget:self action:@selector(contractStore:) forControlEvents:UIControlEventTouchUpInside];
    [cell.alreadyContractStore addTarget:self action:@selector(alreadyContractStore:) forControlEvents:UIControlEventTouchUpInside];
    ZDProjectItem *item = _projectArray[indexPath.row];
    cell.item = item;
    return cell;
}
//签约门店
-(void)contractStore:(UIButton *)button{
    CGPoint point = button.center;
    point = [self convertPoint:point fromView:button.superview];
    NSIndexPath* indexpath = [self indexPathForRowAtPoint:point];
    ZDProjectCell *cell = [self cellForRowAtIndexPath:indexpath];
    ZDContractController *contract = [[ZDContractController alloc] init];
    contract.projectId = cell.ID;
    contract.projectName = cell.projectName.text;
    UIViewController *Vc = [UIViewController viewController:self.superview];
    [Vc.navigationController pushViewController:contract animated:YES];
}
//已签约门店
-(void)alreadyContractStore:(UIButton *)button{
    CGPoint point = button.center;
    point = [self convertPoint:point fromView:button.superview];
    NSIndexPath* indexpath = [self indexPathForRowAtPoint:point];
    ZDProjectCell *cell = [self cellForRowAtIndexPath:indexpath];
    ZDAlreadyContractStoreController  *already = [[ZDAlreadyContractStoreController alloc] init];
    already.projectId = cell.ID;
    UIViewController *Vc = [UIViewController viewController:self.superview];
    [Vc.navigationController pushViewController:already animated:YES];
}
@end
