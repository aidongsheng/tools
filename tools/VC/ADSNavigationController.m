//
//  ADSNavigationController.m
//  tools
//
//  Created by wcc on 2018/4/10.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "ADSNavigationController.h"


@interface ADSNavigationController ()

@end

@implementation ADSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIFont *font = [UIFont HeitiSCWithFontSize:23];
    NSDictionary *textAttr = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:font};
    [[UINavigationBar appearance] setTitleTextAttributes:textAttr];
    
    [[UINavigationBar appearance] setTranslucent:NO];
}

@end
