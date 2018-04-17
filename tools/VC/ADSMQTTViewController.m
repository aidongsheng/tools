//
//  ADSMQTTViewController.m
//  tools
//
//  Created by wcc on 2018/4/9.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "ADSMQTTViewController.h"
//#import "ADSChartViewController.h"
#import "ADSMQTTTool.h"
#import <Masonry.h>
#import <YYKit.h>
#import "UIView+POPAnimation.h"
@interface ADSMQTTViewController ()<MQTTSessionDelegate>
@property (nonatomic,strong) QMUIButton * buttonConnect;
@end

@implementation ADSMQTTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.buttonConnect];
    
//    self.view.backgroundColor = [UIColor qmui_randomColor];
    [self.view wcc_addAlphaAnimation:1 duration:2 autoReverse:NO];
    [self.view wcc_addBackgroundColorAnimation:[UIColor qmui_randomColor] duration:1 autoReverse:NO];
    [_buttonConnect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.height.equalTo(@50);
        make.width.equalTo(@200);
    }];
}

- (QMUIButton *)buttonConnect
{
    if (!_buttonConnect) {
        _buttonConnect = [[QMUIButton alloc]init];
        [_buttonConnect setTitle:@"连接到MQTT服务器" forState:UIControlStateNormal];
        __block __weak typeof(self) weakself = self;
        [_buttonConnect addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//            ADSChartViewController *chartVC = [[ADSChartViewController alloc]init];
//            [weakself.navigationController pushViewController:chartVC animated:YES];
        }];
    }
    return _buttonConnect;
}


@end
