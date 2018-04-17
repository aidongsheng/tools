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
    [[UIApplication sharedApplication].keyWindow addSubview:self.jumpButton];
    [self layoutSubViews];
    [self.jumpButton wcc_addCornerRadiusAnimation];
    
}

- (UIButton *)jumpButton
{
    if (!_jumpButton) {
        _jumpButton = [[UIButton alloc]init];
        _jumpButton.backgroundColor = [UIColor qmui_randomColor];
        [_jumpButton setTitle:@"跳转按钮" forState:UIControlStateNormal];
        __weak __block typeof(self) weakself = self;
        [_jumpButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            for (int count = 0; count< 5; count++) {
                [[GCDManager shareInstance] executeTaskWithLock:^(NSLock *lock) {
                    [lock lock];
                    sleep(count);
                    NSLog(@"sleep for %i seconds",count);
                    [lock unlock];
                }];
            }
            
            
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
        make.center.equalTo([UIApplication sharedApplication].keyWindow);
        make.width.height.mas_equalTo(@100);
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
}




@end
