//
//  RTAVVideoEncoder.h
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/3.
//  Copyright © 2016年 zp. All rights reserved.
//

#import <Foundation/Foundation.h>
@import VideoToolbox;
@class RTAVVideoConfiguration;
@interface RTAVVideoEncoder : NSObject
- (nullable instancetype)initWithVideoConfiguration:(nullable RTAVVideoConfiguration *)configuration;

- (void)encoderVideoData:(CVPixelBufferRef)pixelBuffer timeStamp:(int64_t)timestamp;
@end
