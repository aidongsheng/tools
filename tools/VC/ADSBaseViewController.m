//
//  ADSBaseViewController.m
//  tools
//
//  Created by wcc on 2018/3/30.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "ADSBaseViewController.h"
//#import "UIView+POPAnimation.h"
//#import "ADSMQTTViewController.h"
//#import "NSObject+GetClassProperty.h"

@interface ADSBaseViewController ()
@property (nonatomic,strong) UILabel * label;
//@property (nonatomic,strong) ADSMQTTViewController *mqttVC;
@end

#define DLog( s, ... ) NSLog( @"<%s,%p %@:(%d)> %@",__func__, self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

@implementation ADSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)setupLeftBarButtonWithTitle:(NSString *)title {
    UIFont *font = [UIFont HeitiSCWithFontSize:15];
    NSDictionary *textAttr = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:font};
    [[UINavigationBar appearance] setTitleTextAttributes:textAttr];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title
                                                                            style:UIBarButtonItemStyleDone
                                                                           target:self
                                                                           action:@selector(leftBarButtonClick)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:textAttr
                                                         forState:UIControlStateNormal];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:textAttr
                                                         forState:UIControlStateHighlighted];
}

- (void)leftBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)layoutSubViews
{
    //...需要子类重写
}

- (void)setStrLeftBarItemTitle:(NSString *)strLeftBarItemTitle
{
    [self setupLeftBarButtonWithTitle:strLeftBarItemTitle];
}

@end
