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
@property (nonatomic, strong) UIButton *jumpButton;
@property (nonatomic, strong) UILabel *testLabel;
@property (nonatomic, strong) NSString *testStr;
@end

@implementation ADSHomeViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.testLabel];
    [[UIApplication sharedApplication].keyWindow addSubview:self.jumpButton];
    [self layoutSubViews];
    [self.navigationItem setTitle:@"Home"];
    NSLog(@"%@",self.navigationItem.titleView);
}

- (UIButton *)jumpButton
{
    if (!_jumpButton) {
        _jumpButton = [[UIButton alloc]init];
        _jumpButton.backgroundColor = [UIColor qmui_randomColor];
        [_jumpButton setTitle:@"跳转按钮" forState:UIControlStateNormal];
        __weak __block typeof(self) weakself = self;
        [_jumpButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            ADSSettingViewController *settingVC = [[ADSSettingViewController alloc]init];
            settingVC.strLeftBarItemTitle = @"主页";
            [weakself.navigationController pushViewController:settingVC animated:YES];
        }];
    }
    return _jumpButton;
}

- (UILabel *)testLabel
{
    if (_testLabel == nil) {
        _testLabel = [[UILabel alloc]init];
    }
    return _testLabel;
}

- (void)back {
    NSLog(@"back");
    
}

- (void)layoutSubViews
{
    [self.jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo([UIApplication sharedApplication].keyWindow);
        make.width.height.mas_equalTo(@100);
    }];
    [self.testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.equalTo(@50);
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [[FPSTool shareInstance] showFPSInfomation];
    
    NSLog(@"  MD4 of aidongsheng:%@",[@"aidongsheng" ads_MD4String]);
    NSLog(@"  MD5 of aidongsheng:%@",[@"aidongsheng" ads_MD5String]);
    NSLog(@" SHA1 of aidongsheng:%@",[@"aidongsheng" ads_SHA1String]);
    NSLog(@"CRC32 of aidongsheng:%@",[@"aidongsheng's macbook pro computer is very cool!" ads_CRC32String]);
    
}

@end
