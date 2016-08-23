//
//  EditPersonViewController.m
//  RAC基本使用
//
//  Created by 陈红荣 on 16/5/23.
//  Copyright © 2016年 chenHongRong. All rights reserved.
//

#import "EditPersonViewController.h"
#import "Person.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Masonry.h"

@interface EditPersonViewController ()

@property (nonatomic, copy) void (^completionBlock)();
@property (nonatomic,strong) Person *person;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation EditPersonViewController

- (instancetype)initWithPerson:(Person *)person completion:(void (^)())completion {
    self = [super init];
    if (self) {
        _person = person;
        _completionBlock = completion;
        
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupUI];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupUI];

}


#pragma mark - 设置UI
- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UITextField *nameTextField = [[UITextField alloc] init];
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    nameTextField.placeholder = @"请输入用户名:";
    UITextField *pwdTextField = [[UITextField alloc] init];
    pwdTextField.borderStyle = UITextBorderStyleRoundedRect;
    pwdTextField.placeholder = @"请输入用户密码:";
    [self.view addSubview:nameTextField];
    [self.view addSubview:pwdTextField];

    CGFloat offset = 12;
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(offset);
        make.leading.equalTo(self.view).offset(offset);
        make.trailing.equalTo(self.view).offset(-offset);
    }];
    [pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextField.mas_bottom).offset(offset);
        make.leading.equalTo(nameTextField);
        make.trailing.equalTo(nameTextField);
    }];

    // 准备导航栏按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // 设置数据
    nameTextField.text = _person.name;
    pwdTextField.text = [NSString stringWithFormat:@"%zd", _person.pwd];

    // 监听文本变化
    [[nameTextField rac_textSignal] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [[pwdTextField rac_textSignal] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];

    //组合文本信号
    RACSignal *textsingle = [RACSignal combineLatest:@[
                                                       nameTextField.rac_textSignal,
                                                       pwdTextField.rac_textSignal]
                                              reduce:^id{
                                                    return @(nameTextField.text.length > 0 && pwdTextField.text.length > 0);
                                              }];
    
    @weakify(self)
    //RACCommand 是对一个动作的触发以及它产生的后续事件的封装。
    RACCommand *command = [[RACCommand alloc]initWithEnabled:textsingle signalBlock:^RACSignal *(id input) {
        @strongify(self)
        self.person.name = nameTextField.text;
        self.person.pwd = pwdTextField.text;
        
        if (self.completionBlock != nil) {
            self.completionBlock();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        return [RACSignal empty];
    }];
    
    self.navigationItem.rightBarButtonItem.rac_command = command;
    
     /*===========================双向绑定 ============================*/
    //双向绑定
    //  模型  ->   UI (name) -> text
    RAC(nameTextField, text) = RACObserve(self.person, name);
    [[nameTextField rac_textSignal]subscribeNext:^(id x) {
        @strongify(self)
        self.person.name = x;
    }];
    
    
    /**
     - 如果使用 基本数据类型绑定 UI 的内容，需要使用 map 函数，通过 block 对 value 的数值进行转换之后
     - 才能够绑定
     */
    RAC(pwdTextField, text) = RACObserve(self.person, pwd);
    //    假如  Pwd 是 int  类型  用这种方式绑定
    //    RAC(pwdTextField, text) = [RACObserve(self.person, pwd) map:^id(id value) {
    //        return value;
    //    }];
    [[pwdTextField rac_textSignal] subscribeNext:^(id x) {
        self.person.pwd = x;
    }];
    
    // UI  ->  模型
    [[RACSignal combineLatest:@[nameTextField.rac_textSignal,pwdTextField.rac_textSignal]] subscribeNext:^(RACTuple *x) {
       
        self.person.name = [x  first];
        self.person.pwd = [x second];
        
    }];
    
    
}

#pragma mark - 监听按钮响应事件
- (void)demoButton {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.center = self.view.center;
    [self.view addSubview:btn];
    
    // 监听按钮事件 - 不再需要新建一个方法
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    self.btn = btn;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
