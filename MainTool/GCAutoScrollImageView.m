//
//  GCAutoScrollImageView.m
//  GameChat
//
//  Created by Tom on 2/2/15.
//  Copyright (c) 2015 Ruoogle. All rights reserved.
//

#import "GCAutoScrollImageView.h"
#import "UIImageView+WebCache.h"

@interface GCAutoScrollImageView () <UIScrollViewDelegate>{
  
  UIScrollView  *_scrollView;
  UIPageControl *_pageControll;
  NSTimer       *_timer;
  UIImageView   *_imageViewFirst;
  UIImageView   *_imageViewLast;
  NSArray       *_urlArray;

}

@end

@implementation GCAutoScrollImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateData:(NSArray *)urlOfPhoto needGesture:(BOOL)needGesture {
  
  for (UIView *view in [_scrollView subviews]) {
    [view removeFromSuperview];
  }
  
  CGRect rect = _scrollView.frame;
  for (int i = 0; i < urlOfPhoto.count; i++) {
    
    // 从第二个位置开始显示
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width * (i+([urlOfPhoto count]>1?1:0)), 0, rect.size.width, rect.size.height)];
      if (_isLocalPhoto) {
          
          imageView.image = [UIImage imageNamed:[urlOfPhoto objectAtIndex:i]];
      }else {
          
          [imageView sd_setImageWithURL:[urlOfPhoto objectAtIndex:i]];
      }
      
    [_scrollView addSubview:imageView];
    
    // 如果想添加点击事件，可在此添加tap手势，此处不再赘述
    imageView.userInteractionEnabled = needGesture;
    if (needGesture) {
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
      [imageView addGestureRecognizer:tap];
    }
  }
  
  if ([urlOfPhoto count] <= 1 ) {
    return;
  }
  
  // 第一个位置
  _imageViewFirst = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width,rect.size.height)];
    
    if (_isLocalPhoto) {
        
        _imageViewFirst.image = [UIImage imageNamed:[urlOfPhoto objectAtIndex:urlOfPhoto.count-1]];
        
    }else {
        
    [_imageViewFirst sd_setImageWithURL:[NSURL URLWithString:[urlOfPhoto objectAtIndex:urlOfPhoto.count-1]] placeholderImage:nil];
    }
  _imageViewFirst.userInteractionEnabled = needGesture;
  if (needGesture) {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [_imageViewFirst addGestureRecognizer:tap];
  }
  
  [_scrollView addSubview:_imageViewFirst];
  
  // 最后一个位置
  _imageViewLast = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width * (urlOfPhoto.count + 1), 0, rect.size.width, rect.size.height)];
   if (_isLocalPhoto) {
        
        _imageViewFirst.image = [UIImage imageNamed:[urlOfPhoto objectAtIndex:0]];
        
     }else {
        
        [_imageViewLast sd_setImageWithURL:[NSURL URLWithString:[urlOfPhoto objectAtIndex:0]] placeholderImage:nil];
    }
  _imageViewLast.userInteractionEnabled = needGesture;
  [_scrollView addSubview:_imageViewLast];
  if (needGesture) {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [_imageViewLast addGestureRecognizer:tap];
  }
  
  [_scrollView setContentSize:CGSizeMake(rect.size.width * (urlOfPhoto.count + 2), rect.size.height)];
  [_scrollView scrollRectToVisible:CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height) animated:NO];
  
  if (_timer) {
    [_timer invalidate];
    _timer = nil;
  }
  
    if (_isLocalPhoto) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:2000 target:self selector:@selector(goNextPage) userInfo:Nil repeats:YES];
    }else {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(goNextPage) userInfo:Nil repeats:YES];

    }
    

}

- (instancetype)initWithFrame:(CGRect)frame urls:(NSArray *)urlOfPhoto needTapGesture:(BOOL)needGesture isLocalPhoto:(BOOL)isLocalPhoto{
  
  
  self = [super initWithFrame:frame];
    _isLocalPhoto = isLocalPhoto;
  if (self) {

    _urlArray = urlOfPhoto;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20,self.frame.size.height - 20,40,20)];
    _pageControll.numberOfPages = [urlOfPhoto count];
    [self addSubview:_pageControll];
    if ([urlOfPhoto count]>0) {
      [self updateData:urlOfPhoto needGesture:needGesture];
    }
  }
  
  return self;
}

- (void)tapped:(UIGestureRecognizer *)sender {
  
  if (sender.state == UIGestureRecognizerStateEnded){
    
    if (_delegate && [_delegate respondsToSelector:@selector(autoScrollImageView:imageTapped:)]){

        [_delegate autoScrollImageView:self imageTapped:_pageControll.currentPage];
    }
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  
  CGPoint offset = scrollView.contentOffset;
  NSInteger page = offset.x / scrollView.frame.size.width;
  page--;
  page = page > [_urlArray count] ? 0 : page;
  _pageControll.currentPage = page;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  // 重新计时
    if (!_isLocalPhoto) {
        
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(goNextPage) userInfo:Nil repeats:YES];
    }

  CGFloat pageWidth = scrollView.frame.size.width;

  NSInteger currentPage = floor((_scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
  
  if (currentPage == [_urlArray count]+1) {
    
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
    
  }else if (currentPage == 0) {
    
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width * [_urlArray count], 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
  }
}

- (void)goNextPage {
  
  CGFloat pageWidth = _scrollView.frame.size.width;
  NSInteger currentPage = floor((_scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
  currentPage++;
  
  if (currentPage == [_urlArray count]+1) {
    
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
    
  }else if (currentPage == 0) {
    
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width * [_urlArray count], 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
    
  }else {
    
    [_scrollView scrollRectToVisible:CGRectMake(currentPage * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
  }
}

- (void)dealloc {
  
  [_timer invalidate];
}

@end
