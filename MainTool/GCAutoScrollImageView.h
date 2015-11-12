//
//  GCAutoScrollImageView.h
//  GameChat
//
//  Created by Tom on 2/2/15.
//  Copyright (c) 2015 Ruoogle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCAutoScrollImageView;

@protocol  GCAutoScrollImageViewDelegate <NSObject>

@optional
- (void)autoScrollImageView:(GCAutoScrollImageView *)autoScrollImageView imageTapped:(NSInteger)indexOfImage;

@end

@interface GCAutoScrollImageView : UIView

@property (nonatomic,assign) id <GCAutoScrollImageViewDelegate> delegate;


@property (assign) BOOL  isLocalPhoto;
- (instancetype)initWithFrame:(CGRect)frame urls:(NSArray *)urlOfPhoto needTapGesture:(BOOL)needGesture isLocalPhoto:(BOOL)isLocalPhoto;
- (void)updateData:(NSArray *)urlArray needGesture:(BOOL)needGesture;
@end
