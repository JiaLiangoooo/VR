//
//  BDVoiceCommon.h
//  VR
//
//  Created by Galen on 15/8/18.
//  Copyright (c) 2015年 XW. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KsourceUrl @"http://192.168.0.6:8080/VRMobileServer"
#define API_KEY @"8MAxI5o7VjKSZOKeBzS4XtxO" // 请修改为您在百度开发者平台申请的API_KEY
#define SECRET_KEY @"Ge5GXVdGQpaxOmLzc8fOM8309ATCz9Ha" // 请修改您在百度开发者平台申请的SECRET_KEY
@interface BDVoiceCommon : NSObject


+ (void)voiceRecognitionAction;
@end
