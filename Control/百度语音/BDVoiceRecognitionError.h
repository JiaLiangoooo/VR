//
//  BDVoiceRecognitionError.h
//  VR
//
//  Created by Galen on 15/8/18.
//  Copyright (c) 2015年 XW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDVoiceRecognitionError : NSObject


+ (void)firstStartError:(NSString *)statusString;


//以下状态为错误通知，出现错语后，会自动结束本次识别
+ (void)createErrorViewWithErrorType:(int)aStatus;


// 枚举 - 语音识别状态
+ (void)createRunLogWithStatus:(int)aStatus;
@end

