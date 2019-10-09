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
@property (nonatomic, strong) RACDisposable *keyboardDisposable;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation RACFirstUseVC

- (void)dealloc
{
    [_keyboardDisposable dispose];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC的使用";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
    [self loadUIKitRAC];
    [self loadFoundationRAC];
    [self loadKVORAC];
    
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
   /********************************通知*******************************/ //注意：rac_addObserverForName同样需要移除监听。RAC通知监听会返回一个RACDisposable清洁工的对象，在dealloc中销毁信号，信号销毁时，RAC在销毁的block中移除了监听
   _keyboardDisposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@ 键盘弹起", x); // x 是通知对象
    }];
    
    /********************************interval定时器*******************************/
    //创建一个定时器，间隔1s，在主线程中运行
    RACSignal *timerSignal = [RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]];
    //定时器总时间3秒
    timerSignal = [timerSignal take:3];
    self.counter = 3;
    @weakify(self)
    [timerSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.counter--;
//        NSLog(@"count = %ld", (long)self.counter);
    } completed:^{
        //计时完成
//        NSLog(@"Timer completed");
    }];
    
    /********************************延迟*******************************/
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        return nil;
    }] delay:2] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"delay : %@", x);
    }];
    
    /********************************NSArray数组遍历*******************************/
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"数组内容：%@", x);
    }];
    
    /********************************NSDictionary字典遍历*******************************/
    NSDictionary *dictionary = @{@"key1":@"value1", @"key2":@"value2", @"key3":@"value3"};
    [dictionary.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"字典内容：%@ : %@", key, value);
    }];
    
    /********************************RACSubject代理*******************************/
    /*
     @interface DelegateView : UIView
     //定义了一个RACSubject信号
     @property (nonatomic, strong) RACSubject *delegateSignal;
     @end

     @implementation DelegateView

     - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
         // 判断代理信号是否有值
         if (self.delegateSignal) {
             // 有值，给信号发送消息
             [self.delegateSignal sendNext:@666];
         }
     }
     @end
     ///////////////////////////在UIViewController中声明DelegateView作为属性
     @interface ViewController ()
     @property (nonatomic, strong) DelegateView *bView;
     @end

     //使用前，记得初始化
     self.bView.delegateSignal = [RACSubject subject];
     [self.bView.delegateSignal subscribeNext:^(id  _Nullable x) {
         //订阅到 666 的消息
         NSLog(@"RACSubject result = %@", x);
     }];
     
     */
    
}

- (void)loadKVORAC
{
    /********************************rac_valuesForKeyPath 通过keyPath监听*******************************/
    [[self.view rac_valuesForKeyPath:@"frame" observer:self] subscribeNext:^(id  _Nullable x) {
        //当self.view的frame变化时，会收到消息
        NSLog(@"kvo = %@", x);
    }];
    
    /********************************RACObserve 属性监听*******************************/
    //counter是一个NSInteger类型的属性
    [[RACObserve(self, counter) filter:^BOOL(id  _Nullable value) {
        return [value integerValue] >= 2;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACObserve : value = %@", x);
    }];
    
    /********************************RAC 事件绑定*******************************/
    //当UITextField输入的内容为@"666"时，bView视图的背景颜色变为grayColor
    RAC(self.view, backgroundColor) = [self.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [value isEqualToString:@"666"]?[UIColor grayColor]:[UIColor orangeColor];
    }];
    //#define RAC(TARGET, ...)这个宏定义是将对象的属性变化信号与其他信号关联，比如：登录时，当手机号码输入框的文本内容长度为11位时，"发送验证码" 的按钮才可以点击
    
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
