//
//  ViewController.m
//  RAC基本使用
//
//  Created by 陈红荣 on 16/5/23.
//  Copyright © 2016年 chenHongRong. All rights reserved.
//

#import "ViewController.h"
#import "PersonViewModel.h"
#import "PersonTableViewCell.h"
#import "EditPersonViewController.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PersonViewModel *personViewModel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

static NSString *ID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载数据
    [self loadData];
    
    //加载tableView
    [self loadTableView];
    
}

#pragma mark - 加载数据
-(void)loadData
{
    // 1. 实例化视图模型
    _personViewModel = [[PersonViewModel alloc] init];
    
    // 2. 加载个人数组
    [[_personViewModel loadPersons] subscribeNext:^(id x) {
        NSLog(@"%@", x);
        [_tableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    } completed:^{
        NSLog(@"完成");
    }];
    
}

#pragma mark - 加载tableView
-(void)loadTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[PersonTableViewCell class] forCellReuseIdentifier:ID];

    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _personViewModel.persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    cell.textLabel.text = self.personViewModel.persons[indexPath.row].name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd", self.personViewModel.persons[indexPath.row].pwd];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EditPersonViewController *vc = [[EditPersonViewController alloc] initWithPerson:self.personViewModel.persons[indexPath.row] completion:^{
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
