//
//  VRVideo.m
//  VR
//
//  Created by Galen on 15/8/13.
//  Copyright (c) 2015年 XW. All rights reserved.
//

#import "VRVideo.h"
#define pid        @"pid"
#define name       @"name"
#define lineId     @"lineId"
#define posId      @"posId"
#define videoName  @"videoName"
#define updateTime @"updateTime"
@implementation VRVideo


- (VRVideo *)getData:(NSDictionary *)data {
    
    _pid       = [[data objectForKey:pid]copy];
    _name      = [[data objectForKey:name]copy];
    _lineId    = [[data objectForKey:lineId]copy];
    _posId     = [[data objectForKey:posId]copy];
    _videoName = [[data objectForKey:videoName]copy];
    
    
    return self;
}
@end
