//
//  ViewController.m
//  TestSegment
//
//  Created by anxindeli on 16/10/24.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

//当前设备的屏幕宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

//当前设备的屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#import "ViewController.h"
#import "CommonSegmentView.h"
@interface ViewController ()<CommonSegmentViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) CommonSegmentView *segmentView;
@property (nonatomic, strong) UIScrollView *bgScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatCommonSegment];
}
#pragma mark - 创建Segment
- (void)creatCommonSegment{
    
    NSArray *array = @[@"未收货",@"已收货",@"123",@"中文",@"main",@"采购单",@"我的采购单",@"未收货",@"收货",@"已收货",@"好收货",@"破收货"];
    CommonSegmentView *segmentView = [[CommonSegmentView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 45) withItems:array];
    self.segmentView = segmentView;
    segmentView.delegate = self;
    segmentView.selectIndex = 0;
    [self.view addSubview:segmentView];
    
    //背景可滑动ScrollView
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 45, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45)];
    [self.view addSubview:bgScrollView];
    bgScrollView.pagingEnabled = YES;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.delegate = self;
    bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH *array.count, 0);
    self.bgScrollView = bgScrollView;
//    [bgScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}
#pragma mark - CommonSegmentViewDelegate代理方法
- (void)selectSegmentControlView:(NSInteger)index{
    [self.bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0) animated:NO];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.bgScrollView]) {
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        self.segmentView.selectIndex = index;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
