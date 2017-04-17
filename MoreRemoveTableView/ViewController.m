//
//  ViewController.m
//  MoreRemoveTableView
//
//  Created by 一米阳光 on 2017/4/17.
//  Copyright © 2017年 一米阳光. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<
UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrayDS;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isEditing;//用来标识此时表格视图的状态
@property (nonatomic, strong) NSMutableArray *arrayRemove;//存放删除的所有元素

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDatas];
    [self setupSubviews];
}

- (void)setupDatas {
    self.isEditing = NO;
    self.arrayRemove = [[NSMutableArray alloc] init];
    self.arrayDS = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        NSString * str = [NSString stringWithFormat:@"同学%d",i+1];
        [self.arrayDS addObject:str];
    }
}

- (void)setupSubviews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"表格视图";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //在导航条上添加编辑按钮
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //将按钮添加到表格的底部
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 300, 44);//有效值只有宽高
    [button setTitle:@"删除" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = button;
}

- (void)buttonClick:(UIButton *)button {
    if (self.isEditing) {
        //先移除数据源中与删除数组中相同的元素信息
        [self.arrayDS removeObjectsInArray:_arrayRemove];
        //清空删除数组中的内容,如果不清空删除数组中的内容,下一次删除操作就会在删除数组的内容基础上继续追加,那么第一步的移除操作一定会崩溃
        [self.arrayRemove removeAllObjects];
        //刷新表格
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayDS.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * str = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.textLabel.text = _arrayDS[indexPath.row];
    return cell;
}

/**
 *  开启/关闭表格编辑状态
 */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    self.isEditing = !self.isEditing;
    if (self.isEditing == NO) {
        [self.arrayRemove removeAllObjects];
    }
    [self.tableView setEditing:self.isEditing animated:YES];
}

/**
 *  设置单元格的编辑样式:
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

/**
 *  触发cell点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //通过判断表格是否处于编辑状态 来决定单元格的状态
    if (self.isEditing) {
        [self.arrayRemove addObject:[self.arrayDS objectAtIndex:indexPath.row]];
    }
}

/**
 *  选中的单元格再次点击就处于非选中状态
 */
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取非选中单元格中的内容
    NSString * str = [_arrayDS objectAtIndex:indexPath.row];
    //判断删除数组是否存在非选中单元格的内容
    if ([self.arrayRemove containsObject:str]) {
        [self.arrayRemove removeObject:str];
    }
}


@end
