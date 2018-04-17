//
//  ADSBaseViewController.h
//  tools
//
//  Created by wcc on 2018/3/30.
//  Copyright © 2018年 ads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADSBaseViewController : UIViewController
@property (nonatomic,copy) NSString *strLeftBarItemTitle;
/**
 布局方法
 */
- (void)layoutSubViews;
@end
