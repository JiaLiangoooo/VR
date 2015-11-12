//
//  VRGaidePangeViewControl.m
//  VR
//
//  Created by Galen on 15/8/14.
//  Copyright (c) 2015年 XW. All rights reserved.
//

#import "VRGaidePangeViewControl.h"
#import "GCAutoScrollImageView.h"
#import "Define.h"
#import "Const.h"
#import "UIView+Extension.h"
#import "UIButton+WF.h"
#import "UIStoryboard+WF.h"
@interface VRGaidePangeViewControl ()<UIScrollViewDelegate>

@property (nonatomic, strong) GCAutoScrollImageView *gaidePageView;
@property (nonatomic, strong) UIScrollView *guideScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *images;


@end

@implementation VRGaidePangeViewControl


-(UIScrollView *)guideScrollView {
    
    if (!_guideScrollView) {
        
        _guideScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20,self.view.frame.size.height - 20,40,20)];
        _images =[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"4.jpg"],nil];
        [self.view addSubview:_guideScrollView];
        [self.view addSubview:_pageControl];
       // [self setupPage];
        CLog(@"%f",_guideScrollView.width);
    }
    return _guideScrollView;
}

- (void)awakeFromNib {
    
    
}

- (void)setupPage {
    
    self.guideScrollView.delegate = self;
    _guideScrollView.backgroundColor = [UIColor blueColor];
    _guideScrollView.canCancelContentTouches = NO;
    _guideScrollView.indicatorStyle =  UIScrollViewIndicatorStyleWhite;
    _guideScrollView.clipsToBounds = NO;
    _guideScrollView.scrollEnabled = YES;
    _guideScrollView.pagingEnabled = YES;
    _guideScrollView.directionalLockEnabled = NO;
    _guideScrollView.showsVerticalScrollIndicator = NO;
    _guideScrollView.showsHorizontalScrollIndicator = NO;
    
    NSUInteger pages = 0;
    int originX = 0;
    for (UIImage *image in _images) {
        
        UIImageView *pImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        pImageView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
        [pImageView setImage:image];
        CGRect rect = self.guideScrollView.frame;
        rect.origin.x = originX;
        rect.origin.y = 0;
        rect.size.height = _guideScrollView.frame.size.height;
        rect.size.width = _guideScrollView.frame.size.width;
        pImageView.frame = rect;
        pImageView.contentMode = UIViewContentModeScaleToFill;
        if (pages == _images.count-1) {
            
            UIButton *btn = [UIButton createButtonWithFrame:CGRectMake(originX, 0, _guideScrollView.width, _guideScrollView.height) Title:@"点击me" Target:self Selector:@selector(goMainStoryBoard)];
            [_guideScrollView addSubview:btn];
            CLog(@"width__%f_____height__%f",btn.x,btn.width);
        }
        [_guideScrollView addSubview:pImageView];
        
        originX += _guideScrollView.frame.size.width;
        pages ++;
    }
    
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventEditingChanged];
    _pageControl.numberOfPages = pages;
    _pageControl.currentPage = 0;
    _pageControl.tag = 110;
    
    [_guideScrollView setContentSize:CGSizeMake(originX, _guideScrollView.frame.size.height)];
    
}

- (void)changePage:(id)sender {
    
    CLog(@"指示器当前界面：%li",(long)self.pageControl.currentPage);
    
    CGRect rect = _guideScrollView.frame;
    rect.origin.x = _pageControl.currentPage * _guideScrollView.frame.size.width;
    rect.origin.y = 0;
    [_guideScrollView scrollRectToVisible:rect animated:YES];
}

- (void)goMainStoryBoard {
    
    [UIStoryboard showInitialVCWithName:@"Main"];
}
#pragma mark - scrollview delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    
    int page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    self.pageControl.currentPage = page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPage];

}


@end
