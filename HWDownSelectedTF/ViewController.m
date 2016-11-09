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

@property (weak, nonatomic) IBOutlet HWDownSelectedView *sexBox;

@property (nonatomic, weak) HWDownSelectedView *down;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    /// text
    
    
    
    HWDownSelectedView *down = [HWDownSelectedView new];
    
    down.listArray = @[@"选择项1",@"选择项2", @"选择项3",@"选择项4",@"选择项5", @"选择项6",@"选择项7",@"选择项8", @"选择项9"];
    down.frame = CGRectMake(10, 100, 300, 30);
    [self.view addSubview:down];
    self.down = down;
    
    _sexBox.placeholder = @"性别选择";
    _sexBox.listArray = @[@"男", @"女"];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.down close];
}

@end
