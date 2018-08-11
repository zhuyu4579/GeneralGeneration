//
//  ZDSureProjectsTableView.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDSureProjectsTableView.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UIViewController+WZFindController.h"
#import "ZDSureProjectCell.h"
#import "ZDProjectItem.h"
@interface ZDSureProjectsTableView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableDictionary *projectDicy;
@end
static  NSString * const ID = @"cells";
@implementation ZDSureProjectsTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"ZDSureProjectCell" bundle:nil] forCellReuseIdentifier:ID];
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self;
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _projectArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDSureProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    ZDProjectItem *item = _projectArray[indexPath.row];
    cell.item = item;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDSureProjectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *projectId = cell.projectId;
    NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
    dicty[@"projectId"] = projectId;
    dicty[@"projectName"] = cell.projectName.text;
    dicty[@"defaultSignStartTime"] = cell.defaultSignStartTime;
    if (_projectBlock) {
        _projectBlock(dicty);
    }
    UIViewController *VC = [UIViewController viewController:self.superview];
    [VC.navigationController popViewControllerAnimated:YES];
}
@end
