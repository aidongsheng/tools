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
    [self.view addSubview:self.jumpButton];
    [self layoutSubViews];
    
    self.navigationItem.title = @"Home";
    QMUIButton *button = [[QMUIButton alloc]init];
    button.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.titleView = button;
    
    [button setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1541406632322&di=516ca3d4a89990cd2f0ebc332f392717&imgtype=0&src=http%3A%2F%2Fec4.images-amazon.com%2Fimages%2FI%2F71yVUKar4vL._SL1000_.jpg"]
                    forState:UIControlStateNormal
                 placeholder:[UIImage imageNamed:@"jinqiangyu"]];
//    QMUIPopupMenuView *menuView = [[QMUIPopupMenuView alloc]init];
//    QMUIPopupMenuItem *item = [QMUIPopupMenuItem itemWithImage:[UIImage imageWithColor:[UIColor qmui_randomColor]] title:@"条目一" handler:^{
//
//    }];
//    menuView.items = @[item];
//    menuView.itemHeight = 30;
//    [menuView layoutWithTargetView:self.view];
    [button wcc_addCornerRadiusAnimation];
    
    
    NSLog(@"%@",self.navigationItem.titleView);
}

- (UIButton *)jumpButton
{
    if (_jumpButton == nil) {
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
        make.center.equalTo(self.view);
        make.width.height.mas_equalTo(@100);
    }];
    _jumpButton.layer.cornerRadius = 50;
    _jumpButton.layer.masksToBounds = YES;
    
    [self.testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.equalTo(@50);
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [[GCDManager shareInstance] executeTaskWithLock:^(NSLock *lock) {
        [lock lock];
        [_jumpButton wcc_addScaleXYAnimation:3 duration:3 autoReverse:YES];
        [self.jumpButton wcc_addCornerRadiusAnimation];
        [self.jumpButton wcc_addRotationXYAnimation:M_PI *10 duration:2 autoReverse:NO];
        [lock unlock];
    }];
    
}

@end
