//
//  GJAVAudioPlayer.h
//  AVDemo
//
//  Created by Mr.H on 2017/12/19.
//  Copyright © 2017年 Mr.H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface GJAVAudioPlayer : NSObject

/*
 播放对象
 */
@property (nonatomic, strong) AVAudioPlayer *player;

/*
 设置开始播放
 */
- (void)setPlay;

/*
 设置播放路径
 */

- (void)setPayerUrl:(NSString *)url;

/*
 设置播放数据
 */

- (void)setPayerData:(NSData *)data;

/*
 设置暂停
 */
- (void)setPause;

/*
 设置停止
 */
- (void)setStop;

/*
 开启扬声器
 */
- (void)setSpeaker;

@end
