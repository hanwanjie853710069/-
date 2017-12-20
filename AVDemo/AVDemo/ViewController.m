//
//  ViewController.m
//  AVDemo
//
//  Created by Mr.H on 2017/12/19.
//  Copyright © 2017年 Mr.H. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "GJAVAudioPlayer.h"
#import "GJAVAudioRecorder.h"
#import "EMVoiceConverter.h"
#import "EMCDDeviceManager.h"

@interface ViewController ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) GJAVAudioRecorder *recorder;//录音对象

@property (nonatomic, strong) GJAVAudioPlayer *player;//播放对象

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    
    btn.backgroundColor = [UIColor redColor];
    
    [btn setTitle:@"录音" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(btntouch) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    
    [btn1 setTitle:@"播放" forState:UIControlStateNormal];
    
    btn1.backgroundColor = [UIColor redColor];
    
    [btn1 addTarget:self action:@selector(btntouch1) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(100, 450, 100, 100)];
    
    btn2.backgroundColor = [UIColor redColor];
    
    [btn2 setTitle:@"停止" forState:UIControlStateNormal];
    
    [btn2 addTarget:self action:@selector(btntouchstop) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn2];
    
    self.recorder = [[GJAVAudioRecorder alloc]init];
    
    self.player = [[GJAVAudioPlayer alloc]init];
    
    [self.player setSpeaker];
    
}

// 停止
- (void)btntouchstop {
    
     NSLog(@"停止录音");
    
    [self.recorder setStop];
    
}

// 录音
- (void)btntouch {
    
    NSLog(@"开始录音");
    
    [self.recorder setRecordUrl:@"hwj"];
    
    [self.recorder setRecord];
    
}

// 播放
- (void)btntouch1 {
    
    NSLog(@"播放录音");
    
    [self.player setPayerUrl:@"hwj"];
    
    [self.player setPlay];
    
}


#pragma mark - Convert

- (BOOL)convertAMR:(NSString *)amrFilePath
             toWAV:(NSString *)wavFilePath
{
    BOOL ret = NO;
    BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:amrFilePath];
    if (isFileExists) {
        [EMVoiceConverter amrToWav:amrFilePath wavSavePath:wavFilePath];
        isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:wavFilePath];
        if (isFileExists) {
            ret = YES;
        }
    }
    
    return ret;
}

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


@end
