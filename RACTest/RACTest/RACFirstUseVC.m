//
//  RACFirstUseVC.m
//  RACTest
//
//  Created by KnowChat03 on 2019/10/8.
//  Copyright © 2019 KnowChat03. All rights reserved.
//

#import "RACFirstUseVC.h"
#import "RACHeader.h"


@interface RACFirstUseVC ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;
@end

@implementation RACFirstUseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC的使用";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
    [self loadUIKitRAC];
    [self loadFoundationRAC];
    
}

- (void)loadUI
{
    self.textField = [UITextField new];
    [self.view addSubview:_textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(120, 40));
        make.top.equalTo(self.view.mas_top).offset(20+IPHONEX_INSETS().top+44);
    }];
    self.textField.borderStyle = UITextBorderStyleBezel;
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_button];
    [_button setTitle:@"点击" forState:UIControlStateNormal];
    [_button setBackgroundColor:[UIColor redColor]];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(120, 40));
        make.top.equalTo(self.textField.mas_bottom).offset(20);
    }];
    
}

- (void)loadUIKitRAC
{
    //UITextField创建了一个 `textSignal`的信号，并订阅了该信号
    //当UITextField的内容发生改变时，就会回调subscribeNext
    [[self.textField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"text changed = %@", x);
    }];
    
    //当UITextField内输入的内容长度大于5时，才会回调subscribeNext
    [[[self.textField rac_textSignal] filter:^BOOL(NSString * _Nullable value) {
        return value.length > 5;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"filter result = %@",  x);
    }];
    
    [[[self.textField rac_textSignal] ignore:@"666"] subscribeNext:^(NSString * _Nullable x) {
        //当输入的内容 equalTo @"666" 时，这里不执行
        //其他内容，均会执行subscribeNext
        NSLog(@"ignore = %@", x);
    }];
    
    /***************************************************************/
    //当UIButton点击时，会调用subscribeNext
    [[self.button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"button clicked");
    }];
    
    
}

- (void)loadFoundationRAC
{
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
