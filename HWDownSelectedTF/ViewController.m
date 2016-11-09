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

@property (weak, nonatomic) IBOutlet HWDownSelectedView *ageBox;
@property (weak, nonatomic) IBOutlet HWDownSelectedView *sexBox;
@property (nonatomic, weak) HWDownSelectedView *down;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ageBox.placeholder = @"年龄选择";
    _ageBox.listArray = @[@"22", @"23", @"24", @"25", @"26"];
    
    _sexBox.placeholder = @"性别选择";
    _sexBox.listArray = @[@"男", @"女"];

    
    HWDownSelectedView *down = [HWDownSelectedView new];
    down.backgroundColor = [UIColor whiteColor];
    down.listArray = @[@"选择项1",@"选择项2", @"选择项3",@"选择项4",@"选择项5", @"选择项6",@"选择项7",@"选择项8", @"选择项9"];
    down.frame = CGRectMake(30, 100, 315, 40);
    [self.view addSubview:down];
    self.down = down;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.down close];
    [_sexBox close];
    [_ageBox close];
}

@end
