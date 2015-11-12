//
//  VRVideo.h
//  VR
//
//  Created by Galen on 15/8/13.
//  Copyright (c) 2015年 XW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VRVideo : NSObject


@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *lineId;
@property (nonatomic, copy) NSString *L_00000001;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, copy) NSString *videoName;
@property (assign) NSDate *updateTime;

- (VRVideo *)getData:(NSDictionary *)data;
@end
