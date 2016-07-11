//
//  ViewController.m
//  SpeedDialDemo
//
//  Created by 韩金波 on 16/7/11.
//  Copyright © 2016年 Psylife. All rights reserved.

//

#import "ViewController.h"
#import "KBSpeedDialView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    KBSpeedDialView * view = [[KBSpeedDialView alloc ] init];
    
    [self.view addSubview:view];
    
    view.frame = CGRectMake(0, 0, 300, 300);
    
    view.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
