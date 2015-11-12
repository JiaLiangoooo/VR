//
//  ViewController.m
//  VR
//
//  Created by Galen on 15/8/13.
//  Copyright (c) 2015年 XW. All rights reserved.
//

#import "HomeViewController.h"
#import "VRSource.h"
#import "DetalTravelLineVCTL.h"
#import "SimplePlayerViewController.h"
#import "AFNetworkTool.h"
#import "Const.h"
#import "BDVoiceCommon.h"


#import "BDVoiceRecognitionClient.h"
#import "BDVRSConfig.h"
#import "BDVoiceRecognitionError.h"


#define VOICE_LEVEL_INTERVAL 0.1 // 音量监听频率为1秒中10次

#define KsourceUrl @"http://192.168.0.6:8080/VRMobileServer"
#define API_KEY @"8MAxI5o7VjKSZOKeBzS4XtxO" // 请修改为您在百度开发者平台申请的API_KEY
#define SECRET_KEY @"Ge5GXVdGQpaxOmLzc8fOM8309ATCz9Ha" // 请修改您在百度开发者平台申请的SECRET_KEY

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,MVoiceRecognitionClientDelegate>

@property NSMutableArray  *sourceDataArray;
@property (strong, nonatomic) IBOutlet UITableView *sourTableView;
@property (weak, nonatomic) NSString *tmpStr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sourceDataArray = [[NSMutableArray alloc]init];
    [self sourceData];
    
}
- (IBAction)intoSim:(id)sender {
    
    
    SimplePlayerViewController *simpleVCTL = [[SimplePlayerViewController alloc]init];
    [self.navigationController presentViewController:simpleVCTL animated:YES completion:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    
    [BDVoiceCommon voiceRecognitionAction];
    [self startVoiceRecongnition];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:YES];
  
}

#pragma mark -获取数据源
- (void )sourceData {
    
    //第一步，创建url
    NSString *strUrl = [NSString localizedStringWithFormat:@"%@/SourceListAction",KsourceUrl];
    
    [AFNetworkTool JSONDataWithUrl:strUrl  success:^(id json) {
        
        
        NSLog(@"%@",json);
        
        for (NSDictionary *dic in json) {
            
            VRSource *vrSourec = [[VRSource alloc]init];
            [vrSourec VRSource:dic];
            
            [_sourceDataArray addObject:vrSourec];
            
        }
        [_sourTableView reloadData];
    } fail:^{
        NSLog(@"fail sourceUrl");
    }];
}
#pragma mark tableViewDelegate、datasource

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
    
    VRSource *vrSource = _sourceDataArray[indexPath.row];
    cell.textLabel.text = vrSource.name;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetalTravelLineVCTL *vctl = [[DetalTravelLineVCTL alloc]init];
    VRSource *source = _sourceDataArray[indexPath.row];
    vctl.sourceLineUrl = [NSString  stringWithFormat:@"%@/%@",KsourceUrl,source.sourceUrl];
    [self.navigationController pushViewController:vctl animated:NO];
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
    
    
    if ([obj rangeOfString:@"旅游"].location !=NSNotFound && obj!= nil ) {
        
        [BDVoiceRecognitionClient releaseInstance];
        DetalTravelLineVCTL *vctl = [[DetalTravelLineVCTL alloc]init];
            vctl.sourceLineUrl = @"http://192.168.0.6:8080/VRMobileServer/VrVideoListAction";
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
            
            [BDVoiceRecognitionError createRunLogWithStatus:aStatus];
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
