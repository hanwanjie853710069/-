//
//  GJAVAudioRecorder.h
//  AVDemo
//
//  Created by Mr.H on 2017/12/19.
//  Copyright © 2017年 Mr.H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GJAVAudioRecorder : NSObject

/*录音对象*/
@property (nonatomic, strong) AVAudioRecorder *recorder;

/*
 设置路径
 */
- (void)setRecordUrl:(NSString *)url;

/*
 设置开始录音
 */
- (void)setRecord;

/*
 设置暂停
 */
- (void)setPause;

/*
 设置停止
 */
- (void)setStop;

/*
 删除本地录音文件
 */
- (void)deleteVoicFileName:(NSString *)fileName;

@end
