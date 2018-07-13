//
//  ZDRightTableView.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDRightTableView.h"
#import "ZDAreasCell.h"
#import "ZDAreasItem.h"
@interface ZDRightTableView()<UITableViewDelegate,UITableViewDataSource>

@end
static  NSString * const ID = @"cells";
@implementation ZDRightTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"ZDAreasCell" bundle:nil] forCellReuseIdentifier:ID];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.areas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDAreasCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    ZDAreasItem *item  = _areas[indexPath.row];
    cell.item = item;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDAreasCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *areaId = cell.areasId;
    NSString *cityName = cell.name.text;
    
    NSMutableDictionary *citys = [NSMutableDictionary dictionary];
    citys[@"areaId"] = areaId;
    citys[@"name"] = cityName;
    if (_cityBlock) {
        _cityBlock(citys);
    }
}
@end
