//
//  ViewController.m
//  CoreDataDemo
//
//  Created by Lymn on 6/11/16.
//  Copyright © 2016 Andy. All rights reserved.
//

#import "ViewController.h"
#import "DatabaseManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)insertData:(id)sender {
    NSArray *nameArray = @[@"ZhangSan",@"LiSi",@"HanMei",@"Lilei",@"HanXiao",@"Rose",@"Jack",@"Lisa",@"Shero",@"Riki"];
    NSArray *addressArray = @[@"北京",@"上海",@"广州",@"郑州",@"武汉",@"天津",@"长沙",@"杭州",@"苏州",@"丽江"];
    for (int i = 0; i < nameArray.count; i++) {
        [[DatabaseManager shareManager]insertData:nameArray[i] studentId:[NSNumber numberWithInt:i+1] studentAddress:addressArray[i] studentScore:[NSNumber numberWithInt:arc4random()%40 + 60]];
    }
}
//学号为2的分数改为90
- (IBAction)updateData:(id)sender {
    NSNumber *tempId = [NSNumber numberWithInt:2];
    [[DatabaseManager shareManager]updateData:tempId];
}
//删除学号为10的同学
- (IBAction)deleteData:(id)sender {
    NSNumber *tempId = [NSNumber numberWithInt:10];
    [[DatabaseManager shareManager]deleteData:tempId];
}
- (IBAction)deleteAllData:(id)sender {
    [[DatabaseManager shareManager]deleteData];

}
- (IBAction)queryAllData:(id)sender {
    [[DatabaseManager shareManager]queryData];
}
//查询学号为8的学生信息
- (IBAction)queryData:(id)sender {
    NSNumber *tempId = [NSNumber numberWithInt:8];
    [[DatabaseManager shareManager]queryData:tempId];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
