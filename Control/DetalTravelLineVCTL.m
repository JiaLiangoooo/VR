//
//  DetalTravelLineVCTL.m
//  VR
//
//  Created by Galen on 15/8/13.
//  Copyright (c) 2015年 XW. All rights reserved.
//

#import "DetalTravelLineVCTL.h"
#import "VRVideo.h"
#import "SimplePlayerViewController.h"
#import "AFNetworkTool.h"
#import "Const.h"

#import "BDVoiceCommon.h"
#import "BDVoiceRecognitionClient.h"
#import "BDVoiceRecognitionError.h"
#import "BDVRSConfig.h"

@interface DetalTravelLineVCTL ()<UITableViewDataSource,UITableViewDelegate,MVoiceRecognitionClientDelegate>
@property NSMutableArray *sourceDataArray;
@property (strong, nonatomic)  UITableView *videoListTabView;
@property (weak, nonatomic) NSString  *tmpStr;

@end

@implementation DetalTravelLineVCTL

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _videoListTabView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _videoListTabView.delegate = self;
    _videoListTabView.dataSource = self;
    [self.view addSubview:_videoListTabView];
    
    _sourceDataArray = [[NSMutableArray alloc]init];
    
    [self DetalTravelLineVCTLData];


    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [BDVoiceRecognitionClient releaseInstance];
    [BDVoiceCommon voiceRecognitionAction];
    [self startVoiceRecongnition];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:YES];
    [BDVoiceRecognitionClient releaseInstance];
}

- (void )DetalTravelLineVCTLData{
    
    [AFNetworkTool JSONDataWithUrl:_sourceLineUrl success:^(id json) {
        for (NSDictionary *dic in json) {
            
            VRVideo *vrVideo = [[VRVideo alloc]init];
            [vrVideo getData:dic];
            
            [_sourceDataArray addObject:vrVideo];
            
        }
        
     [_videoListTabView reloadData];
        
    } fail:^{
        
        NSLog(@"路线获取失败");
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _sourceDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
    }
    
    VRVideo *vrSource = _sourceDataArray[indexPath.row];
    cell.textLabel.text = vrSource.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SimplePlayerViewController *simpleVCTL = [[SimplePlayerViewController alloc]init];
    [self.navigationController presentViewController:simpleVCTL animated:YES completion:nil];

}

#pragma mark - 百度语音

- (void)startVoiceRecongnition {
    
    // 开始语音识别功能，之前必须实现MVoiceRecognitionClientDelegate协议中的VoiceRecognitionClientWorkStatus:obj方法
    int startStatus = -1;
    
    startStatus = [[BDVoiceRecognitionClient sharedInstance] startVoiceRecognition:self];
    if (startStatus != EVoiceRecognitionStartWorking) // 创建失败则报告错误
    {
        NSString *statusString = [NSString stringWithFormat:@"%d",startStatus];
        [self performSelector:@selector(firstStartError:) withObject:statusString afterDelay:0.3];  // 延迟0.3秒，以便能在出错时正常删除view
        return;
    }
}

//启动发生错误
- (void)firstStartError:(NSString *)statusString
{
    [BDVoiceRecognitionError createErrorViewWithErrorType:[statusString intValue]];
}


//重新开始开启声音识别
- (void)reStartVoice : (NSString *)obj{
    
    
    if ([obj rangeOfString:@"巴厘岛"].location !=NSNotFound && obj!= nil ) {
        
        SimplePlayerViewController *vctl = [[SimplePlayerViewController alloc]init];
//        vctl.sourceLineUrl = @"http://192.168.0.6:8080/VRMobileServer/VrVideoListAction";
        [self.navigationController pushViewController:vctl animated:YES];
        
    }else {
        
        [BDVoiceRecognitionClient releaseInstance];
        [[BDVoiceRecognitionClient sharedInstance] setApiKey:API_KEY withSecretKey:SECRET_KEY];
        
        [self  startVoiceRecongnition];
    }
}

- (void)VoiceRecognitionClientWorkStatus:(int) aStatus obj:(id)aObj
{
    switch (aStatus)
    {
            // 语音识别功能完成，服务器返回正确结果
        case EVoiceRecognitionClientWorkStatusFinish:
        {
            
            [BDVoiceRecognitionError createRunLogWithStatus:aStatus];
            
            if ([[BDVoiceRecognitionClient sharedInstance] getRecognitionProperty] != EVoiceRecognitionPropertyInput)
            {
                NSMutableArray *audioResultData = (NSMutableArray *)aObj;
                NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
                for (int i=0; i<[audioResultData count]; i++)
                {
                    [tmpString appendFormat:@"%@\r\n",[audioResultData objectAtIndex:i]];
                }
                
                _tmpStr = [NSString stringWithFormat:@"%@",tmpString];
                
                CLog(@"EVoiceRecognitionClientWorkStatusFinish_tmpString_:%@",tmpString);
                
            }
            else
            {
                NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aObj];
                _tmpStr = [NSString stringWithFormat:@"%@",tmpString];
                CLog(@"EVoiceRecognitionClientWorkStatusFinish_tmpString_:%@",tmpString);
                
            }
            
            CLog(@"composeInputModeResultz_______%@",aObj);
            
            [self performSelector:@selector(reStartVoice:) withObject:_tmpStr afterDelay:1];}
            
            break;
            
            // 连续上屏中间结果
        case EVoiceRecognitionClientWorkStatusFlushData:
            
        {
            if (1) {
                NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
                
                [tmpString appendFormat:@"%@",[aObj objectAtIndex:0]];
                
            }
        }
            
            // 输入模式下有识别结果返回
        case EVoiceRecognitionClientWorkStatusReceiveData:
        {
            
            if ([[BDVoiceRecognitionClient sharedInstance] getRecognitionProperty] == EVoiceRecognitionPropertyInput)
            {
                NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aObj];
                
                CLog(@"EVoiceRecognitionClientWorkStatusReceiveData__%@__输入模式结果返回",tmpString);
            }
            
            break;
        }
// 本地声音采集结束结束，等待识别结果返回并结束录音
        case EVoiceRecognitionClientWorkStatusEnd:
        {
            
//           [self performSelector:@selector(reStartVoice:) withObject:_tmpStr afterDelay:1];
            break;
        }
            
            // 识别库开始识别工作，用户可以说话
            
        case EVoiceRecognitionClientWorkStatusStartWorkIng: // 识别库开始识别工作，用户可以说话
        {
            if ([BDVRSConfig sharedInstance].playStartMusicSwitch) // 如果播放了提示音，此时再给用户提示可以说话
                
                
                [BDVoiceRecognitionError createRunLogWithStatus:aStatus];
            
            break;
        }
        default:
        {
            break;
        }
    }
}


- (void)VoiceRecognitionClientErrorStatus:(int) aStatus subStatus:(int)aSubStatus
{
    [BDVoiceRecognitionError createErrorViewWithErrorType:aSubStatus];
    [self performSelector:@selector(reStartVoice:) withObject:_tmpStr afterDelay:1];
}



- (void)VoiceRecognitionClientNetWorkStatus:(int) aStatus
{
    switch (aStatus)
    {
        case EVoiceRecognitionClientNetWorkStatusStart:
        {
            CLog(@"VoiceRecognitionClientNetWorkStatus__%d__网络开始工作",aStatus);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;
        }
        case EVoiceRecognitionClientNetWorkStatusEnd:
        {
            CLog(@"VoiceRecognitionClientNetWorkStatus__%d__网络工作完成",aStatus);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;   
        }          
    }
}
@end
