//
//  ViewController.m
//  Custom ARkit Demo
//
//  Created by chenxi on 2017/8/1.
//  Copyright © 2017年 BaiZe. All rights reserved.
//

#import "ViewController.h"
#import "ARSCNViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)startARClick:(id)sender {
    //创建自定义AR控制器
    ARSCNViewController *vc = [[ARSCNViewController alloc] init];
    vc.arType = ARTypeStart;
    //跳转到AR控制器
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)planeARClick:(id)sender {
    //创建自定义AR控制器
    ARSCNViewController *vc = [[ARSCNViewController alloc] init];
    vc.arType = ARTypePlane;
    //跳转到AR控制器
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)moveARClick:(id)sender {
    //创建自定义AR控制器
    ARSCNViewController *vc = [[ARSCNViewController alloc] init];
    vc.arType = ARTypeMove;
    //跳转到AR控制器
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)moonARClick:(id)sender {
    //创建自定义AR控制器
    ARSCNViewController *vc = [[ARSCNViewController alloc] init];
    vc.arType = ARTypeMoon;
    //跳转到AR控制器
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
