//
//  GJAVAudioPlayer.m
//  AVDemo
//
//  Created by Mr.H on 2017/12/19.
//  Copyright © 2017年 Mr.H. All rights reserved.
//

#import "GJAVAudioPlayer.h"
#import "EMCDDeviceManager.h"
#define GJVoicWAVName @"Library/GJWAVVoice"
#define GJVoicAMRName @"Library/GJAMRVoice"
#define GJWAVVoiceType @".wav"
#define GJAMRVoiceType @".amr"
@interface GJAVAudioPlayer()

//配置硬件设备
@property (nonatomic, strong) AVAudioSession *section;

@end

@implementation GJAVAudioPlayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/*
 设置播放路径
 */

- (void)setPayerUrl:(NSString *)url {
    
    NSString *urlTemp = [NSString stringWithFormat:@"%@/%@%@",GJVoicAMRName,url,GJWAVVoiceType];
    
    //拼接文件存储路径
    NSString *urlStr = [NSHomeDirectory() stringByAppendingPathComponent:urlTemp];
    
    NSURL *nsurl = [[NSURL alloc]initWithString:urlStr];
    
    self.player = nil;
    
    NSError *error;
    
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:nsurl error:&error];
    
    [self logPlayerMessage];
    
    if (error) {
        
        NSLog(@"初始化播放器失败");
        
    }

}

/*
 设置播放数据
 */

- (void)setPayerData:(NSData *)data {
    
    self.player = nil;
    
    NSError *error;
    
    self.player = [[AVAudioPlayer alloc]initWithData:data error:&error];
    
    [self logPlayerMessage];
    
    if (error) {
        
        NSLog(@"初始化播放器失败");
        
    }
    
}

/*
 设置暂停
 */
- (void)setPause {
    
    if (self.player == nil) { return; }
    
    [self.player pause];
    
}

/*
 设置停止
 */
- (void)setStop {
    
    if (self.player == nil) { return; }
    
    [self.player stop];
    
    self.player = nil;
    
}

/*
 设置开始播放
 */
- (void)setPlay {
    
    if (self.player == nil) { return; }
    
    if ([self.player prepareToPlay]) {
        
        [self.player play];
        
        NSLog(@"开始播放");
        
    }
    
}

/*
 打印播放信息
 */
- (void)logPlayerMessage {
    
    NSString *msg = [NSString stringWithFormat:@"音频文件声道数:%ld\n 音频文件持续时间:%g",self.player.numberOfChannels,self.player.duration];
    
    
    NSLog(@"%@",msg);
    
    NSLog(@"音量：%f",self.player.volume);
    
}

/*
 开启扬声器
 */
- (void)setSpeaker {
    
    self.section = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    
    [self.section setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    
    
    AudioSessionSetProperty (
                             kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride
                             );
    
    if(self.section == nil){
        
        NSLog(@"Error creating session: %@", [sessionError description]);
        
    }else {
        
        [self.section setActive:YES error:nil];
        
    }
    
}

/*
 销毁播放器
 */
- (void)dealloc
{
    self.player = nil;
}

@end
