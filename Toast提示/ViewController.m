//
//  ViewController.m
//  Toast提示
//
//  Created by LG on 2017/12/2.
//  Copyright © 2017年 my. All rights reserved.
//

#import "ViewController.h"
#import "MPCToast.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *cutomeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
    
    self.cutomeView = [[UIView alloc]initWithFrame:CGRectMake(100, 250, [UIScreen mainScreen].bounds.size.width-100, 300)];
    self.cutomeView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.cutomeView];
}

- (void)btnClick:(UIButton*)btn {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    view.backgroundColor = [UIColor redColor];
    [MPCToast showWithContentView:view inView:self.cutomeView topMargin:10. duration:2.];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
