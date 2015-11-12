//
//  VRSource.m
//  VR
//
//  Created by Galen on 15/8/13.
//  Copyright (c) 2015年 XW. All rights reserved.
//

#import "VRSource.h"
#define pid          @"pid"
#define name         @"name"
#define sourceUrl    @"sourceUrl"
#define updateTime   @"updateTime"


@implementation VRSource

- (VRSource *)VRSource:(NSDictionary *)data

{
    _pid = [[data objectForKey:pid]copy];
    _name = [[data objectForKey:name]copy];
    _sourceUrl = [[data objectForKey:sourceUrl]copy];
    
    return self;
}


@end
