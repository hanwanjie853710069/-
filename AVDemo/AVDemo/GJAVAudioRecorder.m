//
//  GJAVAudioRecorder.m
//  AVDemo
//
//  Created by Mr.H on 2017/12/19.
//  Copyright © 2017年 Mr.H. All rights reserved.
//

#import "GJAVAudioRecorder.h"
#import "EMVoiceConverter.h"
#define GJVoicWAVName @"Library/GJWAVVoice"
#define GJVoicAMRName @"Library/GJAMRVoice"
#define GJWAVVoiceType @".wav"
#define GJAMRVoiceType @".amr"

@interface GJAVAudioRecorder()<AVAudioRecorderDelegate>

/*文件路径*/
@property (nonatomic, strong) NSURL *fileUrl;

@end

@implementation GJAVAudioRecorder

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self creatVoicFile];
        
    }
    return self;
}

/*
 删除本地录音文件
 */

- (void)deleteVoicFileName:(NSString *)fileName {
    
    NSString *urlStr = [self getVoicePathName:fileName type:GJWAVVoiceType];
    
    NSError *error;
    
    //删除之前的录音
    [[NSFileManager defaultManager]removeItemAtPath:urlStr error:&error];
    
    if (error) {
        
        NSLog(@"删除本地录音文件错误");
        
        NSLog(@"删除路径：%@",urlStr);
        
    }
    
}

/*
 设置播放路径
 */

- (void)setRecordUrl:(NSString *)url {
    
    /*
     url:录音文件保存的路径
     settings: 录音的设置
     error:错误
     */
    NSError * error;
    
    NSDictionary *info = [self setConfiguration:url];
    
    self.recorder = [[AVAudioRecorder alloc]initWithURL:self.fileUrl settings:info error:&error];
    
    self.recorder.delegate = self;
    
    if(error) {
        
        NSLog(@"错误%@", error); // 在这里我们简单打印错误, 在实际项目中我们要做容错判断
        
    }
    
}

/*
 设置暂停
 */
- (void)setPause {
    
    if (self.recorder == nil) { return; }
    
    [self.recorder pause];
    
}

/*
 设置停止
 */
- (void)setStop {
    
    if (self.recorder == nil) { return; }
    
    [self.recorder stop];
    
    self.recorder = nil;
    
}

/*
 设置开始录音
 */
- (void)setRecord {
    
    if (self.recorder == nil) { return; }
    
    if ([self.recorder prepareToRecord]) {
        
        [self.recorder record];
        
        NSLog(@"开始录音");
        
    }
    
}

/*
 打印播放信息
 */
- (void)logPlayerMessage {
    
}

/*
 设置配置项
 */
- (NSDictionary *)setConfiguration:(NSString *)url {
    
    NSString *urlStr = [self getVoicePathName:url type:GJWAVVoiceType];
    
    //删除之前的录音
    [[NSFileManager defaultManager]removeItemAtPath:urlStr error:nil];
    
    
    self.fileUrl = [NSURL fileURLWithPath:urlStr];
    
    //(2)设置录音的音频参数
    /*
     1 ID号:acc
     2 采样率(HZ):每秒从连续的信号中提取并组成离散信号的采样个数
     3 通道的个数:(1 单声道 2 立体声)
     4 采样位数(8 16 24 32) 衡量声音波动变化的参数
     5 大端或者小端 (内存的组织方式)
     6 采集信号是整数还是浮点数
     7 音频编码质量
     */
    //    NSDictionary *info = @{
    //                           AVFormatIDKey:[NSNumber numberWithInt:kAudioFormatMPEG4AAC],//音频格式
    //                           AVSampleRateKey:@8000,//采样率
    //                           AVNumberOfChannelsKey:@1,//声道数
    //                           AVLinearPCMBitDepthKey:@8,//采样位数
    //                           AVLinearPCMIsBigEndianKey:@NO,
    //                           AVLinearPCMIsFloatKey:@NO,
    //                           AVEncoderAudioQualityKey:[NSNumber numberWithInt:AVAudioQualityHigh],
    //                           };
    
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                          [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                          [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                          [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                          nil];
    
    return info;
    
}

// 录音停止时调用,flag如果为YES则录音成功结束, flag若为NO则录音编码失败. 一般在这里做文件保存操作.
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    if (flag) {
        
        NSLog(@"录音成功");
        
        NSString *wavPath = [self getVoicePathName:@"hwj" type:GJWAVVoiceType];
        
        NSString *amrPath = [self getVoicePathName:@"hwj" type:GJAMRVoiceType];
        
        BOOL convertResult = [self convertWAV:wavPath toAMR:amrPath];
        
        if (convertResult) {
            
            [[NSFileManager defaultManager] removeItemAtPath:wavPath error:nil];
            
            NSLog(@"转换成功");
            
        }
        else {
            
            NSLog(@"转换错误");
            
        }
        
    }else {
        
        NSLog(@"录音失败");
        
    }
    
}

// 如果编码过程中失败, 此方法触发
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    
    NSLog(@"编码失败");
    
}


/*
 如果录音文件夹不存在就创建
 创建路径
 */
- (void)creatVoicFile {
    
    
    NSArray *array = @[GJVoicWAVName,GJVoicAMRName];
    
    for (NSString *url in array) {
        
        NSString *urlTemp = [NSString stringWithFormat:@"%@",url];
        
        NSString *urlStr = [NSHomeDirectory() stringByAppendingPathComponent:urlTemp];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        if(![fm fileExistsAtPath:urlStr]){
            
            [fm createDirectoryAtPath:urlStr
          withIntermediateDirectories:YES
                           attributes:nil
                                error:nil];
            
        }
        
    }
    
}
/*
 wav转arm
 */
- (BOOL)convertWAV:(NSString *)wavFilePath
             toAMR:(NSString *)amrFilePath {
    BOOL ret = NO;
    BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:wavFilePath];
    if (isFileExists) {
        [EMVoiceConverter wavToAmr:wavFilePath amrSavePath:amrFilePath];
        isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:amrFilePath];
        if (!isFileExists) {
            
        } else {
            ret = YES;
        }
    }
    
    return ret;
}

/// 获取arm文件路径
- (NSString *)getVoicePathName:(NSString *)name type:(NSString *)type {
    
    NSString *path = GJVoicWAVName;
    
    if ([type isEqualToString:GJAMRVoiceType]) { path = GJVoicAMRName; }
    
    NSString *urlTemp = [NSString stringWithFormat:@"%@/%@%@",path,name,type];
    
    NSString *urlStr = [NSHomeDirectory() stringByAppendingPathComponent:urlTemp];
    
    return urlStr;
    
}

/*
 销毁播放器
 */
- (void)dealloc
{
    self.recorder = nil;
}

@end
