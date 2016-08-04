//
//  RTAVVideoCaputre.m
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/3.
//  Copyright © 2016年 zp. All rights reserved.
//

#import "RTAVVideoCaputre.h"
#import "RTAVVideoConfiguration.h"
@interface RTAVVideoCaputre ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)RTAVVideoConfiguration *videoConfiguration;
@end
@implementation RTAVVideoCaputre

- (instancetype)initWithVideoConfiguration:(RTAVVideoConfiguration *)configuration
{
    if (self = [super init]) {
        _videoConfiguration = configuration;
        [self setVideoConfiguration];
    }
    return self;
}
#pragma mark - delegate

#pragma mark AVCaptureSessionDelegete
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer  = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (imageBuffer != NULL) {
        if ([_delegate respondsToSelector:@selector(captureOutput:pixelBuffer:)]) {
            [_delegate captureOutput:self pixelBuffer:imageBuffer];
        }
    }
}
#pragma mark - setter & getter
- (void)setVideoConfiguration
{
    if (!_session) {
        //1.
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError * error = nil;
        //2.
        AVCaptureDeviceInput * videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        //3.
        AVCaptureVideoDataOutput * videoOutput = [[AVCaptureVideoDataOutput alloc]init];
        [videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        
        
        //4.
        AVCaptureSession * session = [[AVCaptureSession alloc]init];
        session.sessionPreset = _videoConfiguration.avsessionPreset;

        //设置帧率
        if ([device respondsToSelector:@selector(setActiveVideoMaxFrameDuration:)] && [device respondsToSelector:@selector(setActiveVideoMinFrameDuration:)]) {
            NSError * error ;
            [device lockForConfiguration:&error];
            if (nil == error) {
#if defined (__IPHONE_7_0)
                device.activeVideoMaxFrameDuration = CMTimeMake(1, (int32_t)_videoConfiguration.videoFrameRate);
                device.activeVideoMinFrameDuration = CMTimeMake(1, (int32_t)_videoConfiguration.videoFrameRate);
#endif
            }
            [device unlockForConfiguration];
        }else
        {
            for (AVCaptureConnection * connection in videoOutput.connections) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                if ([connection respondsToSelector:@selector(setVideoMinFrameDuration:)])
                    connection.videoMinFrameDuration = CMTimeMake(1,  (int32_t)_videoConfiguration.videoMinFrameRate);
                
                if ([connection respondsToSelector:@selector(setVideoMaxFrameDuration:)])
                    connection.videoMaxFrameDuration = CMTimeMake(1, (int32_t)_videoConfiguration.videoMaxFrameRate);
#pragma clang diagnostic pop
            }
        }
        
        
        _session = session;
        //5.
        if ([session canAddInput:videoInput]) {
            [session addInput:videoInput];
        }
        if ([session canAddOutput:videoOutput]) {
            [session addOutput:videoOutput];
        }
    }
}

- (void)setRuning:(BOOL)runing
{
    if (_runing == runing) return;
    
    _runing = runing;
    
    if (runing) {
        [_session  startRunning];
    }else
    {
        [_session stopRunning];
    }
}
@end
