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
    [self.navigationItem setTitle:@"home"];
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
            [weakself.navigationController pushViewController:settingVC animated:YES];
        }];
    }
    return _jumpButton;
}

- (void)layoutSubViews
{
    [self.jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.mas_equalTo(@100);
    }];
}

@end
