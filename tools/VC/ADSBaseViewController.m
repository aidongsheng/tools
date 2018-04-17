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
    self.view.backgroundColor = [UIColor lightGrayColor];
    if(self.navigationController){
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupLeftBarButton];
}
- (void)setupLeftBarButton {
    // 自定义 leftBarButtonItem ，UIImageRenderingModeAlwaysOriginal 防止图片被渲染
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back-蓝"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(leftBarButtonClick)];
}
- (void)leftBarButtonClick
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)layoutSubViews
{
    //...需要子类重写
}





@end
