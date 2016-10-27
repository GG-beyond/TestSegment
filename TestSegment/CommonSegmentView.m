//
//  CommonSegmentView.m
//  LiCaiHui
//
//  Created by anxindeli on 16/1/11.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import "CommonSegmentView.h"
#define SegmentHeight 45
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

//当前设备的屏幕宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

//当前设备的屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface CommonSegmentView ()<UIScrollViewDelegate>
{
    CGFloat greenWidth;
    BOOL isToRight;
    BOOL isToLeft;
}
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray *allBT;
@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) UIScrollView *bgView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *leftImageView;

@end

@implementation CommonSegmentView
@synthesize currentOfItem = _currentOfItem,itemWidth = itemWidth;
- (instancetype)initWithFrame:(CGRect)frame withItems:(NSArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = array;
        self.allBT = [[NSMutableArray alloc]init];
        _pageSize = 4;
        [self creatSubViews];
    }
    return self;
}
//创建segment个数 以及view个数
- (void)creatSubViews{
    
    UIScrollView *bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SegmentHeight)];
    self.bgView = bgView;
    bgView.delegate = self;
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    bgView.showsHorizontalScrollIndicator = false;
     itemWidth = 0.0;
    if (self.items.count > _pageSize) {
        itemWidth = SCREEN_WIDTH /(_pageSize+0.5);
        bgView.scrollEnabled = true;
    }else{
        bgView.scrollEnabled = false;
        itemWidth = SCREEN_WIDTH / self.items.count;
    }
    bgView.contentSize = CGSizeMake(itemWidth*self.items.count, 0);
    for (int i = 0 ; i <self.items.count; i++) {
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        [item setTitle:self.items[i] forState:UIControlStateNormal];
        item.titleLabel.font = [UIFont systemFontOfSize:15];
        item.tag = i;
        item.frame = CGRectMake(itemWidth*i, 0, itemWidth, SegmentHeight);
        [item setTitleColor:RGBCOLOR(34, 34, 34) forState:UIControlStateNormal];
        [item setTitleColor:RGBCOLOR(62, 200, 142) forState:UIControlStateHighlighted];
        [item setTitleColor:RGBCOLOR(62, 200, 142) forState:UIControlStateSelected];
        [item addTarget:self action:@selector(doSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:item];
        [self.allBT addObject:item];
        CGFloat tempWidth = [self.items[i] length] * 15 + 6;
        if (greenWidth<=tempWidth) {
            greenWidth = tempWidth;
        }
        if (i == 0) {
            item.selected = YES;
//            greenWidth = [self.items[i] length] * 15 + 6;
        }else{
            item.selected = NO;

        }

    }
    
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 27, 0, 27, 45)];
    self.rightImageView = rightImageView;
    rightImageView.image = [UIImage imageNamed:@"segment_right.png"];
    [self addSubview:rightImageView];
    
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 27, 45)];
    self.leftImageView = leftImageView;
    self.leftImageView.hidden = YES;
    leftImageView.image = [UIImage imageNamed:@"segment_left.png"];
    [self addSubview:leftImageView];
    
    //灰色线条
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, SegmentHeight - 0.5, SCREEN_WIDTH, 0.5)];
    grayView.backgroundColor = RGBCOLOR(217 , 217, 217);
    [self addSubview:grayView];
    //绿色条目
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake((itemWidth - greenWidth)/2.0, SegmentHeight - 4, greenWidth, 4)];
    [bgView addSubview:greenView];
    greenView.layer.cornerRadius = 1.0f;
    greenView.layer.masksToBounds = YES;
    greenView.backgroundColor = RGBCOLOR(62, 200, 142);
    self.greenView = greenView;

    
    isToRight = YES;
    isToLeft = YES;
}
#pragma mark - 点击方法
- (void)doSelectItem:(UIButton *)sender{
    [self setSelectIndex:sender.tag];
}
#pragma mark - GET  SET 方法
- (NSInteger)numberOfItems{
    return self.items.count;
}
- (NSInteger)currentOfItem{
    return _currentOfItem;
}
- (void)setSelectIndex:(NSInteger)selectIndex{
    
    if (self.currentOfItem == selectIndex) {
        return;
    }
    
    
    for (int i = 0 ; i <self.allBT.count; i++) {
        UIButton *item = self.allBT[i];
        item.selected = NO;
    }
    UIButton *item = self.allBT[selectIndex];
    item.selected = YES;
    CGFloat center_x = item.center.x;
    [UIView animateWithDuration:0.25 animations:^{
        self.greenView.frame = CGRectMake(center_x - greenWidth/2.0,SegmentHeight - 4, greenWidth, 4);
    }];
    
    
    if ([self isCanAutoScroll:selectIndex]) {
        if (selectIndex - self.currentOfItem>0) {//往右走
            self.rightImageView.hidden = YES;
            self.leftImageView.hidden = false;

            isToLeft = true;
            if (isToRight) {
                isToRight = !isToRight;
            }
            [self.bgView setContentOffset:CGPointMake(center_x-itemWidth*(_pageSize-2), 0) animated:true];

        }else{//往左走
            self.leftImageView.hidden = YES;
            self.rightImageView.hidden = false;

            isToRight = true;
            if (isToLeft) {
                isToLeft = !isToLeft;
            }
            [self.bgView setContentOffset:CGPointMake(center_x-itemWidth*(_pageSize-2)-itemWidth/2.0, 0) animated:true];
            
        }
    }
    
    self.currentOfItem = selectIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectSegmentControlView:)]) {
        [self.delegate selectSegmentControlView:selectIndex];
    }

}
//判断scroll是否自动滑动
- (BOOL)isCanAutoScroll:(NSInteger)selectIndex{
    
    if (self.allBT.count>_pageSize) {
        
        
        if (selectIndex<_pageSize-2) {//认为往左边走
            
            self.leftImageView.hidden = YES;
            self.rightImageView.hidden = false;

            [self.bgView setContentOffset:CGPointMake(0, 0) animated:true];
            return false;
        }else if (selectIndex>self.allBT.count - (_pageSize-1)){//认为往右边走
            
            self.rightImageView.hidden = YES;
            self.leftImageView.hidden = false;

             CGFloat offset = self.bgView.contentSize.width - self.bgView.bounds.size.width;
            [self.bgView setContentOffset:CGPointMake(offset, 0) animated:true];
            
            return false;
        }
        else{
            return YES;
        }
        
    }else{//小于4个时，不考虑
        return false;
    }
}
@end
