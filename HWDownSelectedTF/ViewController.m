//
//  ViewController.m
//  HWDownSelectedTF
//
//  Created by HanWei on 15/12/15.
//  Copyright © 2015年 AndLiSoft. All rights reserved.
//

#import "ViewController.h"
#import "HWDownSelectedView.h"

@interface ViewController ()

@property (nonatomic, weak) HWDownSelectedView *down;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    /// text
    
    
    HWDownSelectedView *down = [HWDownSelectedView new];
    down.listArray = @[@"哈哈哈",@"呵呵呵呵呵呵", @"我擦擦擦擦",@"12",@"34", @"56",@"12",@"34", @"56"];
    down.frame = CGRectMake(10, 100, 300, 30);
    [self.view addSubview:down];
    self.down = down;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.down close];
}

@end
