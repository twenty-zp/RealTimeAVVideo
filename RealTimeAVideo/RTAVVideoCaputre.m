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
{
    AVCaptureVideoPreviewLayer * _preViewLayer;
    
}
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)RTAVVideoConfiguration *videoConfiguration;
@end
@implementation RTAVVideoCaputre

- (instancetype)initWithVideoConfiguration:(RTAVVideoConfiguration *)configuration
{
    if (self = [super init]) {
        _videoConfiguration = configuration;
        [self addPreVideo];
    }
    return self;
}
#pragma mark - Method
- (void)addPreVideo
{
    AVCaptureVideoPreviewLayer * preViewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    preViewLayer.frame = [UIScreen mainScreen].bounds;
    preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    _preViewLayer = preViewLayer;
    
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
- (AVCaptureSession *)session
{
    if (!_session) {
        //4.
        AVCaptureSession * session = [[AVCaptureSession alloc]init];
        session.sessionPreset = _videoConfiguration.avsessionPreset;
       
        
        //1.
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError * error = nil;
        //2.
        AVCaptureDeviceInput * videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
      
        //3.
        AVCaptureVideoDataOutput *  videoOutput = [[AVCaptureVideoDataOutput alloc]init];
        dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
        [videoOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];

//        videoOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
        
    
        //5.
        if ([session canAddInput:videoInput]) {
            [session addInput:videoInput];
        }
        if ([session canAddOutput:videoOutput]) {
            [session addOutput:videoOutput];
        }
        
        //此设置要放到addDeviceInput之后才能获取到
        AVCaptureConnection * connection =  [videoOutput connectionWithMediaType:AVMediaTypeVideo] ;
        
        UIInterfaceOrientation statusBar = [[UIApplication sharedApplication] statusBarOrientation];
        if(_videoConfiguration.landscape){
            if(statusBar != UIInterfaceOrientationLandscapeLeft && statusBar != UIInterfaceOrientationLandscapeRight){
                NSLog(@"当前设置方向出错");
                NSLog(@"当前设置方向出错");
                NSLog(@"当前设置方向出错");
                if (connection.isVideoOrientationSupported) {
                    [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
                }
            }else{
                
                if (connection.isVideoOrientationSupported) {
                    [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
                }
            }
        }else{
            if(statusBar != UIInterfaceOrientationPortrait && statusBar != UIInterfaceOrientationPortraitUpsideDown){
                NSLog(@"当前设置方向出错");
                NSLog(@"当前设置方向出错");
                NSLog(@"当前设置方向出错");
                if (connection.isVideoOrientationSupported) {
                    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
                }
            }else{
                if (connection.isVideoOrientationSupported) {
                    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
                }
            }
        }
        //设置帧率
        if ([device respondsToSelector:@selector(setActiveVideoMaxFrameDuration:)] && [device respondsToSelector:@selector(setActiveVideoMinFrameDuration:)]) {
            NSError * error ;
            if (nil == error) {
#if defined (__IPHONE_7_0)
             CMTime videoFrameRate =  CMTimeMake(1, (int32_t)_videoConfiguration.videoFrameRate);
                NSArray *supportedFrameRateRanges = [device.activeFormat videoSupportedFrameRateRanges];
                BOOL frameRateSupported = NO;
                for (AVFrameRateRange *range in supportedFrameRateRanges) {
                    if (CMTIME_COMPARE_INLINE(videoFrameRate, >=, range.minFrameDuration) &&
                        CMTIME_COMPARE_INLINE(videoFrameRate, <=, range.maxFrameDuration)) {
                        frameRateSupported = YES;
                    }
                }
                if (frameRateSupported && [device lockForConfiguration:&error]) {
                    device.activeVideoMaxFrameDuration = videoFrameRate;
                    device.activeVideoMinFrameDuration = videoFrameRate;
                    [device unlockForConfiguration];
                }
#endif
            }
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

        
        //光学防抖
        AVCaptureVideoStabilizationMode stabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        if ([device.activeFormat isVideoStabilizationModeSupported:stabilizationMode]) {
            [connection setPreferredVideoStabilizationMode:stabilizationMode];
        }
        
        _session = session;
        
    }
    return _session;
}
- (void)setPreView:(UIView *)preView
{
    _preView = preView;
    if (_preViewLayer.superlayer ) {
        [_preViewLayer removeFromSuperlayer];
    }
    if (_preViewLayer) {
        [preView.layer addSublayer:_preViewLayer];
    }

}
- (void)setRuning:(BOOL)runing
{
    if (_runing == runing) return;
    
    _runing = runing;
    
    if (runing) {
        [self.session  startRunning];
    }else
    {
        [self.session stopRunning];
    }
}
@end
