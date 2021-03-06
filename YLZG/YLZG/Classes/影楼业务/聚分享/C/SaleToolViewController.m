//
//  SaleToolViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/3.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SaleToolViewController.h"
#import "SaleWebViewController.h"
#import "SaleDataViewController.h"
#import "SaleIntrolduceController.h"
#import "HTTPManager.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "YLZGTitleLabel.h"
#import "SaleToolModel.h"
#import "EmptyViewController.h"


#define ScrollHeight 45
@interface SaleToolViewController ()<UIScrollViewDelegate,UIViewControllerTransitioningDelegate>

/** 顶部标签滚动栏 */
@property (strong, nonatomic) UIScrollView * titleScrollView;
/** 内容滚动栏 */
@property (strong, nonatomic) UIScrollView * contentScrollView;
/** 标签数组 */
@property (strong, nonatomic) NSArray * titleArray;

/** 子控制器 */
@property (strong,nonatomic) SaleWebViewController *actionVC;
/** 子控制器 */
@property (strong,nonatomic) SaleDataViewController *datasourceVC;


@end

@implementation SaleToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.saleModel.name;
    [self setupSubViews];
}

#pragma mark - UI
- (void)setupSubViews
{
    self.titleArray = @[@"功能介绍",@"数据统计"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"rightbar_about"] style:UIBarButtonItemStylePlain target:self action:@selector(ButtonClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    /** 初始化顶部标签滚动栏 */
    [self setupTitleScrollView];
    
    /** 初始化内容滚动栏 */
    [self setupContentScrollView];
    
    /** 添加子控制器 */
    [self addController];
    
    /** 添加标签 */
    [self addLabel];
    
    /** 添加默认控制器 */
    [self addDefaultController];
}

/** 添加默认控制器 */
- (void)addDefaultController
{
    SaleWebViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.contentScrollView.bounds;
    [self.contentScrollView addSubview:vc.view];
    YLZGTitleLabel *lable = [self.titleScrollView.subviews firstObject];
    lable.scale = 1.0;
}


/** 添加子控制器 */
- (void)addController
{
    SaleWebViewController * vc1 = [[SaleWebViewController alloc] init];
    vc1.saleModel = self.saleModel;
    [self addChildViewController:vc1];
    
    SaleDataViewController * vc2 = [[SaleDataViewController alloc] init];
    vc2.saleModel = self.saleModel;
    [self addChildViewController:vc2];
}

/** 添加标签 */
- (void)addLabel
{
    CGFloat labelW = SCREEN_WIDTH / self.titleArray.count;
    CGFloat labelH = ScrollHeight;
    CGFloat labelY = 0;
    for (int i = 0; i < self.titleArray.count; i++) {
        CGFloat labelX = i * labelW;
        YLZGTitleLabel * label = [[YLZGTitleLabel alloc] init];
        label.text = self.titleArray[i];
        if (iOS_Version >= 8.2) {
            label.font = [UIFont systemFontOfSize:15 weight:0.01];
        }else{
            label.font = [UIFont systemFontOfSize:15];
        }
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        label.tag = i;
        [self.titleScrollView addSubview:label];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderTitleClick:)]];
    }
    self.titleScrollView.contentSize = CGSizeMake(labelW * self.titleArray.count, 0);
}

/** 标签点击方法 */
- (void)orderTitleClick:(UITapGestureRecognizer *)recognizer
{
    YLZGTitleLabel *titlelable = (YLZGTitleLabel *)recognizer.view;
    
    CGFloat offsetX = titlelable.tag * self.contentScrollView.frame.size.width;
    
    CGFloat offsetY = self.contentScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.contentScrollView setContentOffset:offset animated:YES];
    
}


/** 初始化顶部标签滚动栏 */
- (void)setupTitleScrollView
{
    UIScrollView * titleScrollView = [[UIScrollView alloc] init];
    titleScrollView.backgroundColor = ToolBarColor;
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.showsVerticalScrollIndicator = NO;
    titleScrollView.x = 0;
    titleScrollView.y = 0;
    titleScrollView.width = self.view.width;
    titleScrollView.height = ScrollHeight;
    self.titleScrollView = titleScrollView;
    [self.view addSubview:self.titleScrollView];
}

/** 初始化内容滚动栏 */
- (void)setupContentScrollView
{
    UIScrollView * contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.delegate = self;
    contentScrollView.y = CGRectGetMaxY(self.titleScrollView.frame);
    contentScrollView.width = self.view.width;
    
    CGFloat scrollViewH;
    scrollViewH = self.view.height - 64 - self.titleScrollView.height;
    contentScrollView.height = scrollViewH;
    
    contentScrollView.contentSize = CGSizeMake(self.view.width * self.titleArray.count, 0);
    contentScrollView.backgroundColor = self.view.backgroundColor;
    contentScrollView.pagingEnabled = YES;
    self.contentScrollView = contentScrollView;
    [self.view insertSubview:self.contentScrollView belowSubview:self.titleScrollView];
}



#pragma mark - scrollView代理方法
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    
    // 滚动标题栏
    YLZGTitleLabel *titleLable = (YLZGTitleLabel *)self.titleScrollView.subviews[index];
    
    CGFloat offsetx = titleLable.center.x - self.titleScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, self.titleScrollView.contentOffset.y);
    [self.titleScrollView setContentOffset:offset animated:YES];
    // 添加控制器
    if (index == 0) {
        SaleWebViewController *newsVc = self.childViewControllers[index];
        
        [self.titleScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx != index) {
                YLZGTitleLabel *temlabel = self.titleScrollView.subviews[idx];
                temlabel.scale = 0.0;
            }
        }];
        
        if (newsVc.view.superview) return;
        
        newsVc.view.frame = scrollView.bounds;
        [self.contentScrollView addSubview:newsVc.view];
    } else {
        SaleDataViewController *newsVc = self.childViewControllers[index];
        
        [self.titleScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx != index) {
                YLZGTitleLabel *temlabel = self.titleScrollView.subviews[idx];
                temlabel.scale = 0.0;
            }
        }];
        
        if (newsVc.view.superview) return;
        
        newsVc.view.frame = scrollView.bounds;
        [self.contentScrollView addSubview:newsVc.view];
    }
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    YLZGTitleLabel *labelLeft = self.titleScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.titleScrollView.subviews.count) {
        YLZGTitleLabel *labelRight = self.titleScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
}

- (void)ButtonClick
{
    SaleIntrolduceController *area = [SaleIntrolduceController new];
    area.transitioningDelegate = self;
    area.saleModel = self.saleModel;
    area.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:area animated:YES completion:^{
        
    }];
}
#pragma mark - POP动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}

@end
