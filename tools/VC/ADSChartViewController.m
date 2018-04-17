//
//  ADSChartViewController.m
//  tools
//
//  Created by wcc on 2018/4/10.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "ADSChartViewController.h"

@interface ADSChartViewController ()
@property (nonatomic,strong) PNCircleChart *circleChart;
@property (nonatomic,strong) PNPieChart *pieChart;
//@property (nonatomic,strong) UIScrollView * scrollView;
@end

@implementation ADSChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.hidesBarsOnSwipe = YES;
    
    [self.view addSubview:self.circleChart];
    [self.view addSubview:self.pieChart];
    [self layoutSubViews];
    [self initChartDataWithReformer];
}

//- (UIScrollView *)scrollView
//{
//    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc]init];
//        _scrollView.delegate = self;
//        _scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT*2);
//        _scrollView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
//        _scrollView.scrollEnabled = YES;
//        _scrollView.directionalLockEnabled = YES;
//        _scrollView.showsVerticalScrollIndicator = NO;
//        _scrollView.backgroundColor = [UIColor whiteColor];
//    }
//    return _scrollView;
//}
- (PNCircleChart *)circleChart
{
    if (!_circleChart) {
        _circleChart = [[PNCircleChart alloc]initWithFrame:CGRectZero total:@100 current:@78 clockwise:YES];
        _circleChart.backgroundColor = [UIColor qmui_randomColor];
        _circleChart.lineWidth = @35;
        _circleChart.strokeColor = [UIColor qmui_randomColor];
    }
//    sleep(5);
    return _circleChart;
}

- (PNPieChart *)pieChart
{
    if (!_pieChart) {
        _pieChart = [[PNPieChart alloc]init];
        _pieChart.backgroundColor = [UIColor qmui_randomColor];
    }
    return _pieChart;
}

- (void)layoutSubViews
{
    [self.circleChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.equalTo(self.view.mas_centerY);
    }];
    [self.pieChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.view.mas_centerY);
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

//
//- (void)initBarChartData
//{
//    [self.barChart setupDefaultValues];
//    NSArray *xLabels = @[@"华为",@"小米",@"Vivo",@"三星",@"苹果"];
//    NSArray *yValues = @[@300,@456,@576,@90,@1900];
//    NSArray *yLabels = @[@"0",@"50",@"100",@"150",@"200",@"300",@"500",@"1000",@"2000"];
//    self.barChart.xLabels = xLabels;
//    self.barChart.yLabels = yLabels;
//    self.barChart.yValues = yValues;
//    self.barChart.legendStyle = PNLegendItemStyleSerial;
//    self.barChart.legendFont = [UIFont qmui_dynamicSystemFontOfSize:20 weight:QMUIFontWeightBold italic:NO];
//    self.barChart.legendPosition = PNLegendPositionTop;
//    self.barChart.strokeColor = [UIColor qmui_randomColor];
//    self.barChart.tintColor = [UIColor qmui_randomColor];
//    self.barChart.backgroundColor = [UIColor qmui_randomColor];
//    self.barChart.labelTextColor = [UIColor qmui_randomColor];
//    self.barChart.showLabel = YES;
//    self.barChart.showLevelLine = YES;
//    self.barChart.showChartBorder = YES;
//    [self.barChart strokeChart];
//    [self.barChart updateChartData:yValues];
//}

- (void)initChartDataWithReformer
{
    _pieChart = [[PNPieChart alloc]init];
    _pieChart.descriptionTextFont = [UIFont fontWithName:@"PingFangHK-Regular" size:20];
    _pieChart.descriptionTextColor= [UIColor blackColor];
    _pieChart.showAbsoluteValues = YES;
    _pieChart.shouldHighlightSectorOnTouch = YES;
    _pieChart.outerCircleRadius = 100;
    _pieChart.innerCircleRadius = 50;
    PNPieChartDataItem * item1 = [PNPieChartDataItem dataItemWithValue:1000 color:[UIColor purpleColor] description:@"贝纳颂"];
    PNPieChartDataItem * item2 = [PNPieChartDataItem dataItemWithValue:2000 color:[UIColor blueColor] description:@"雀巢"];
    PNPieChartDataItem * item3 = [PNPieChartDataItem dataItemWithValue:3000 color:[UIColor redColor] description:@"星巴克"];
    PNPieChartDataItem * item4 = [PNPieChartDataItem dataItemWithValue:4000 color:[UIColor greenColor] description:@"麦斯威尔"];
    [_pieChart updateChartData:@[item1,item2,item3,item4]];
    [_pieChart recompute];
}



//
//#pragma mark - PNChartDelegate
//
///**
// * Callback method that gets invoked when the user taps on a chart bar.
// */
//- (void)userClickedOnBarAtIndex:(NSInteger)barIndex
//{
//
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//    NSLog(@"%@",[NSRunLoop currentRunLoop].currentMode);
//    NSLog(@"%@",[NSThread currentThread]);
//}
@end
