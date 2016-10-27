//
//  CommonSegmentView.h
//  LiCaiHui
//
//  Created by anxindeli on 16/1/11.
//  Copyright © 2016年 anxindeli. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CommonSegmentViewDelegate<NSObject>
- (void)selectSegmentControlView:(NSInteger)index;
@end
@interface CommonSegmentView : UIView
@property (nonatomic, readonly) NSInteger numberOfItems;//多少个模块
@property (nonatomic, assign)   NSInteger currentOfItem;//当前模块
@property (nonatomic, assign)   NSInteger selectIndex;  //选中某一个,跳转。
@property (nonatomic, assign)   NSInteger pageSize;  //默认一屏幕展示4个，多于4个开始滑动；

@property (nonatomic, assign)   id<CommonSegmentViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame withItems:(NSArray *)array;


@end
