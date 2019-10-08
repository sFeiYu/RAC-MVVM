//
//  ViewController.m
//  RACTest
//
//  Created by KnowChat03 on 2019/10/8.
//  Copyright © 2019 KnowChat03. All rights reserved.
//

#import "ViewController.h"
#import "RACHeader.h"
#import "RACFirstUseVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    NSArray *ary = @[@"RAC的使用"];
    for (int i = 0; i < ary.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(120, 40));
            make.top.equalTo(self.view.mas_top).offset(80+20*i);
        }];
        [btn setBackgroundColor:[UIColor redColor]];
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)btnEvent:(UIButton *)btn
{
    RACFirstUseVC *vc = [RACFirstUseVC new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}




@end
