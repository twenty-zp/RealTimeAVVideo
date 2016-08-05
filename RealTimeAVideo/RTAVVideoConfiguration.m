//
//  RTAVVideoConfiguration.m
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/3.
//  Copyright © 2016年 zp. All rights reserved.
//

#import "RTAVVideoConfiguration.h"
@import AVFoundation;

@interface RTAVVideoConfiguration ()
@property (nonatomic,assign)RTVideoSessionPreset supportPreset;
@end

@implementation RTAVVideoConfiguration

+ (instancetype)defaultConfiguration
{
   RTAVVideoConfiguration * configuration =  [RTAVVideoConfiguration defaultConfigurationForQuality:kRTVideoQuality_Default];
    return configuration;
}

+ (instancetype)defaultConfigurationForQuality:(RTVideoQuality)quality
{
    RTAVVideoConfiguration * configuration =  [RTAVVideoConfiguration defaultConfigurationForQuality:quality landscape:NO];
    return configuration;
}

+ (instancetype)defaultConfigurationForQuality:(RTVideoQuality)quality landscape:(BOOL)landscape
{
    RTAVVideoConfiguration * configuration =  [RTAVVideoConfiguration new];
    NSUInteger sessionPreset = 0, videoBitRate = 0 ,videoMaxBitRate = 0, videoMinBitRate = 0,
    videoFrameRate = 0,videoMaxFrameRate = 0, videoMinFrameRate = 0;
    CGSize videoSize = CGSizeZero;
    switch (quality) {
        case kRTVideoQuality_Common_Low:
        {
            sessionPreset = kRTVideoSessionPreset640x480;
            videoBitRate =  500 * 1000;
            videoMaxBitRate = 800* 1000;
            videoMinBitRate = 500*1000;
            videoFrameRate = 15;
            videoMaxFrameRate = 30;
            videoMinFrameRate = 15;
            videoSize = CGSizeMake(480, 640);
        }
            break;
        case kRTVideoQuality_Common_Medium:
        {
            sessionPreset = kRTVideoSessionPreset640x480;
            videoBitRate =  800 * 1000;
            videoMaxBitRate = 800* 1000;
            videoMinBitRate = 800*1000;
            videoFrameRate = 24;
            videoMaxFrameRate = 30;
            videoMinFrameRate = 24;
            videoSize = CGSizeMake(480, 640);
        }
            break;
        case kRTVideoQuality_Common_High:
        {
            sessionPreset = kRTVideoSessionPreset640x480;
            videoBitRate =  800 * 1000;
            videoMaxBitRate = 800* 1000;
            videoMinBitRate = 800*1000;
            videoFrameRate = 30;
            videoMaxFrameRate = 30;
            videoMinFrameRate = 30;
            videoSize = CGSizeMake(480, 640);
        }
            break;
        case kRTVideoQuality_Standard_Low:
        {
            sessionPreset = kRTVideoSessionPreset960x540;
            videoBitRate =  800 * 1000;
            videoMaxBitRate = 800* 1000;
            videoMinBitRate = 800*1000;
            videoFrameRate = 15;
            videoMaxFrameRate = 30;
            videoMinFrameRate = 15;
            videoSize = CGSizeMake(540, 960);

        }
            break;
        case kRTVideoQuality_Standard_Medium:
        {
            sessionPreset = kRTVideoSessionPreset960x540;
            videoBitRate =  800 * 1000;
            videoMaxBitRate = 800* 1000;
            videoMinBitRate = 800*1000;
            videoFrameRate = 24;
            videoMaxFrameRate = 30;
            videoMinFrameRate = 24;
            videoSize = CGSizeMake(540, 960);
        }
            break;
        case kRTVideoQuality_Standard_Hight:
        {
            sessionPreset = kRTVideoSessionPreset960x540;
            videoBitRate =  800 * 1000;
            videoMaxBitRate = 800* 1000;
            videoMinBitRate = 800*1000;
            videoFrameRate = 30;
            videoMaxFrameRate = 30;
            videoMinFrameRate = 30;
            videoSize = CGSizeMake(540, 960);
        }
            break;
        case kRTVideoQuality_HD_Low:
        {
            sessionPreset = kRTVideoSessionPreset1280x720;
            videoBitRate =  1000 * 1000;
            videoMaxBitRate = 1000 * 1000;
            videoMinBitRate = 1000 *1000;
            videoFrameRate = 15;
            videoMaxFrameRate = 30;
            videoMinFrameRate = 15;
            videoSize = CGSizeMake(720, 1280);
        }
            break;
        case kRTVideoQuality_HD_Medium:
        {
            sessionPreset = kRTVideoSessionPreset1280x720;
            videoBitRate =  1200 * 1000;
            videoMaxBitRate = 1200 * 1000;
            videoMinBitRate = 1200 * 1000;
            videoFrameRate = 24;
            videoMaxFrameRate = 30;
            videoMinFrameRate = 24;
            videoSize = CGSizeMake(720, 1280);
        }
            break;
        case kRTVideoQuality_HD_Hight:
        {
            sessionPreset = kRTVideoSessionPreset1280x720;
            videoBitRate =  1200 * 1000;
            videoMaxBitRate = 1200* 1000;
            videoMinBitRate = 1200*1000;
            videoFrameRate = 30;
            videoMaxFrameRate = 30;
            videoMinFrameRate = 30;
            videoSize = CGSizeMake(720, 1280);
        }
            break;
        case kRTVideoQuality_FHD_Low:
        {
            sessionPreset = kRTVideoSessionPreset1920x1080;
            videoBitRate =  1500 * 1000;
            videoMaxBitRate = 1500* 1000;
            videoMinBitRate = 1500*1000;
            videoFrameRate = 15;
            videoMaxFrameRate = 30;
            videoMinFrameRate = 15;
            videoSize = CGSizeMake(1080, 1920);
        }
            break;
        case kRTVideoQuality_FHD_Medium:
        {
            sessionPreset = kRTVideoSessionPreset1920x1080;
            videoBitRate =  1500 * 1000;
            videoMaxBitRate = 1500* 1000;
            videoMinBitRate = 1500*1000;
            videoFrameRate = 24;
            videoMaxFrameRate = 30;
            videoMinFrameRate = 24;
            videoSize = CGSizeMake(1080, 1920);
        }
            break;
        case kRTVideoQuality_FHD_Hight:
        {
            sessionPreset = kRTVideoSessionPreset1920x1080;
            videoBitRate =  1500 * 1000;
            videoMaxBitRate = 1500* 1000;
            videoMinBitRate = 1500*1000;
            videoFrameRate = 30;
            videoMaxFrameRate = 30;
            videoMinFrameRate = 30;
            videoSize = CGSizeMake(1080, 1920);
        }
            break;
    }
    configuration.sessionPreset = sessionPreset;
    configuration.sessionPreset = [configuration supportSessionPreset:sessionPreset];
    configuration.videoBitRate =  videoBitRate;
    configuration.videoMaxBitRate = videoMaxBitRate;
    configuration.videoMinBitRate = videoMinBitRate;
    configuration.videoFrameRate = videoFrameRate;
    configuration.videoMaxFrameRate = videoMaxFrameRate;
    configuration.videoMinFrameRate = videoMinFrameRate;
    configuration.videoMaxKeyframeInterval = videoFrameRate * 2;
    configuration.videoSize = videoSize;
    configuration.landscape = NO;
    return configuration;
}
#pragma mark - Method
- (RTVideoSessionPreset)supportSessionPreset:(RTVideoSessionPreset)sessionPreset
{
    NSString * avSessionPreset = [self avsessionPreset];
    
    AVCaptureSession * session = [[AVCaptureSession alloc]init];
    if (![session canSetSessionPreset:avSessionPreset]) {
        if (sessionPreset == kRTVideoSessionPreset1920x1080) {
            sessionPreset = kRTVideoSessionPreset1280x720;
            if (![session canSetSessionPreset:avSessionPreset]) {
                sessionPreset = kRTVideoSessionPreset960x540;
                if (![session canSetSessionPreset:avSessionPreset]) {
                    sessionPreset = kRTVideoSessionPreset640x480;
                }
            }
        }else if (sessionPreset == kRTVideoSessionPreset1280x720) {
            sessionPreset = kRTVideoSessionPreset960x540;
            if (![session canSetSessionPreset:avSessionPreset]) {
                sessionPreset = kRTVideoSessionPreset640x480;
            }
        }
        else if (sessionPreset == kRTVideoSessionPreset960x540) {
            sessionPreset = kRTVideoSessionPreset640x480;
        }
    }
    return sessionPreset;
}

#pragma mark - setter & getter
- (NSString *)avsessionPreset
{
    NSString * avSessionPreset = nil;
    switch (self.sessionPreset) {
        case kRTVideoSessionPreset640x480:
        {
            avSessionPreset = AVCaptureSessionPreset640x480;
        }
            break;
        case kRTVideoSessionPreset960x540:
        {
            avSessionPreset = AVCaptureSessionPresetiFrame960x540;
        }
            break;
        case kRTVideoSessionPreset1280x720:
        {
            avSessionPreset = AVCaptureSessionPreset1280x720;
        }
            break;
        case kRTVideoSessionPreset1920x1080:
        {
            avSessionPreset = AVCaptureSessionPreset1920x1080;
        }
            break;
    }
    return avSessionPreset;
}
@end
