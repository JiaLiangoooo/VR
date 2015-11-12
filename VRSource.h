//
//  VRSource.h
//  VR
//
//  Created by Galen on 15/8/13.
//  Copyright (c) 2015年 XW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VRSource : NSObject

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *sourceUrl;

@property (assign) NSDate *updateTime;

- (VRSource *)VRSource:(NSDictionary *)data;

@end
