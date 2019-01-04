//
//  ViewController.m
//  YBSBarrageViewTool
//
//  Created by 严兵胜 on 2019/1/4.
//  Copyright © 2019 严兵胜. All rights reserved.
//

#import "ViewController.h"

#import "YBSBarrageViewTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    YBSBarrageViewTool *barrageView = [[YBSBarrageViewTool alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
    [self.view addSubview:barrageView];
    barrageView.contentStrArray = @[@"用户188****2221：已成功购买200两！", @"用户188****2222：已成功购买200两！",@"用户188****2221：已成功购买200两！", @"用户188****2222：已成功购买200两！",@"用户188****2221：已成功购买200两！", @"用户188****2222：已成功购买200两！",@"用户188****2221：已成功购买200两！", @"用户188****2222：已成功购买200两！",@"用户188****2221：已成功购买200两！", @"用户188****2222：已成功购买200两！"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
