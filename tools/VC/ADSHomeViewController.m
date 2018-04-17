//
//  ADSHomeViewController.m
//  tools
//
//  Created by wcc on 2018/4/17.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "ADSHomeViewController.h"
#import "ADSSettingViewController.h"

@interface ADSHomeViewController ()
@property (nonatomic,strong) UIButton *jumpButton;
@end

@implementation ADSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Home"];
    NSLog(@"%@",self.navigationItem.titleView);
    [self.view addSubview:self.jumpButton];
    [self layoutSubViews];
}

- (UIButton *)jumpButton
{
    if (!_jumpButton) {
        _jumpButton = [[UIButton alloc]init];
        [_jumpButton setTitle:@"跳转按钮" forState:UIControlStateNormal];
        __weak __block typeof(self) weakself = self;
        [_jumpButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            ADSSettingViewController *settingVC = [[ADSSettingViewController alloc]init];
            settingVC.strLeftBarItemTitle = @"hi!";
            weakself.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"title" style:UIBarButtonItemStylePlain target:weakself action:@selector(back)];
            [weakself.navigationItem.backBarButtonItem setTintColor:[UIColor blackColor]];
            [weakself.navigationController pushViewController:settingVC animated:YES];
        }];
    }
    return _jumpButton;
}

- (void)back {
    NSLog(@"back");
}

- (void)layoutSubViews
{
    [self.jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.mas_equalTo(@100);
    }];
}

@end
